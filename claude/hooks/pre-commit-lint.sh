#!/bin/bash
# Pre-commit lint: runs formatters and checks on staged files only
# Skips tools that aren't relevant to the project type
input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command // ""')

# Only intercept git commit commands
if ! echo "$cmd" | grep -qE '^git commit'; then
  echo "$input"
  exit 0
fi

# Get project root from staged files
staged=$(git diff --cached --name-only 2>/dev/null)
if [ -z "$staged" ]; then
  echo "$input"
  exit 0
fi

project_root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
errors=0

# --- Python files (only if Python project detected) ---
py_files=$(echo "$staged" | grep '\.py$' || true)
if [ -n "$py_files" ]; then
  is_python_project=false
  [ -f "$project_root/pyproject.toml" ] || [ -f "$project_root/setup.py" ] || [ -f "$project_root/setup.cfg" ] && is_python_project=true

  if [ "$is_python_project" = true ]; then
    echo "[Hook] Linting Python files..." >&2

    # ruff format + check
    if command -v ruff >/dev/null 2>&1; then
      echo "$py_files" | while read -r f; do
        [ -f "$project_root/$f" ] && ruff format "$project_root/$f" 2>&1 | head -3 >&2 || true
      done
      echo "$py_files" | xargs -I{} ruff check "$project_root/{}" --fix 2>&1 | head -10 >&2 || true
    elif command -v poetry >/dev/null 2>&1; then
      echo "$py_files" | while read -r f; do
        [ -f "$project_root/$f" ] && (cd "$project_root" && poetry run ruff format "$f" 2>&1 | head -3 >&2) || true
      done
      (cd "$project_root" && echo "$py_files" | xargs poetry run ruff check --fix 2>&1 | head -10 >&2) || true
    fi

    # mypy (only if mypy config exists)
    has_mypy=false
    grep -q '\[tool\.mypy\]' "$project_root/pyproject.toml" 2>/dev/null && has_mypy=true
    [ -f "$project_root/mypy.ini" ] && has_mypy=true
    [ -f "$project_root/.mypy.ini" ] && has_mypy=true

    if [ "$has_mypy" = true ]; then
      if command -v poetry >/dev/null 2>&1; then
        mypy_out=$(cd "$project_root" && echo "$py_files" | xargs poetry run mypy --no-error-summary 2>&1 | grep -E ": error:" | head -10)
      elif command -v mypy >/dev/null 2>&1; then
        mypy_out=$(cd "$project_root" && echo "$py_files" | xargs mypy --no-error-summary 2>&1 | grep -E ": error:" | head -10)
      fi
      if [ -n "$mypy_out" ]; then
        echo "[Hook] mypy errors:" >&2
        echo "$mypy_out" >&2
        errors=1
      fi
    fi

    # print() check (skip test files)
    for f in $py_files; do
      fp="$project_root/$f"
      if [ -f "$fp" ] && [[ ! "$f" =~ test.*\.py$ ]] && [[ ! "$f" =~ conftest\.py$ ]]; then
        prints=$(grep -n "^[^#]*print(" "$fp" 2>/dev/null || true)
        if [ -n "$prints" ]; then
          echo "[Hook] WARNING: print() in $f" >&2
          echo "$prints" | head -3 >&2
        fi
      fi
    done
  fi
fi

# --- JS/TS files (only if Node project detected) ---
jsts_files=$(echo "$staged" | grep -E '\.(ts|tsx|js|jsx)$' || true)
if [ -n "$jsts_files" ]; then
  is_node_project=false
  [ -f "$project_root/package.json" ] && is_node_project=true

  if [ "$is_node_project" = true ]; then
    echo "[Hook] Linting JS/TS files..." >&2

    # prettier
    if command -v prettier >/dev/null 2>&1; then
      echo "$jsts_files" | while read -r f; do
        [ -f "$project_root/$f" ] && prettier --write "$project_root/$f" 2>/dev/null >&2 || true
      done
    fi

    # tsc (only if tsconfig exists)
    ts_files=$(echo "$jsts_files" | grep -E '\.(ts|tsx)$' || true)
    if [ -n "$ts_files" ] && [ -f "$project_root/tsconfig.json" ]; then
      tsc_out=$(cd "$project_root" && npx tsc --noEmit --pretty false 2>&1 | head -20)
      if [ -n "$tsc_out" ] && echo "$tsc_out" | grep -q "error TS"; then
        echo "[Hook] TypeScript errors:" >&2
        echo "$tsc_out" >&2
        errors=1
      fi
    fi

    # eslint (only if eslint config exists)
    has_eslint=false
    [ -f "$project_root/.eslintrc.json" ] || [ -f "$project_root/.eslintrc.js" ] || \
      [ -f "$project_root/eslint.config.js" ] || [ -f "$project_root/eslint.config.mjs" ] && has_eslint=true
    if [ "$has_eslint" = true ]; then
      eslint_out=$(cd "$project_root" && echo "$jsts_files" | xargs npx eslint --max-warnings=0 2>&1 | head -20)
      eslint_exit=$?
      if [ $eslint_exit -ne 0 ] && [ -n "$eslint_out" ]; then
        echo "[Hook] ESLint errors:" >&2
        echo "$eslint_out" >&2
        errors=1
      fi
    fi

    # console.log check
    for f in $jsts_files; do
      fp="$project_root/$f"
      if [ -f "$fp" ]; then
        clogs=$(grep -n "console\.log" "$fp" 2>/dev/null || true)
        if [ -n "$clogs" ]; then
          echo "[Hook] WARNING: console.log in $f" >&2
          echo "$clogs" | head -3 >&2
        fi
      fi
    done
  fi
fi

# Re-stage formatted files
if [ -n "$py_files" ] || [ -n "$jsts_files" ]; then
  git diff --name-only 2>/dev/null | while read -r f; do
    if echo "$staged" | grep -qF "$f"; then
      git add "$project_root/$f" 2>/dev/null || true
    fi
  done
fi

if [ "$errors" -eq 1 ]; then
  echo "[Hook] Lint errors found. Fix before committing or use --no-verify to skip." >&2
fi

echo "$input"

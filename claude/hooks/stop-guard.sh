#!/bin/bash
# Stop Guard Hook for Claude Code
# Claude가 작업을 멈추려 할 때 실행됩니다.
# exit 0 = 멈춤 허용, exit 2 = 멈춤 방지 (stderr가 Claude에게 피드백으로 전달됨)

INPUT=$(cat)

# 무한 루프 방지: 이미 stop hook이 활성화된 상태면 멈춤 허용
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
if [ -z "$CWD" ] || [ ! -d "$CWD" ]; then
  exit 0
fi

# --- 검사 1: TypeScript 에러 체크 ---
if [ -f "$CWD/tsconfig.json" ]; then
  if command -v npx &>/dev/null; then
    TSC_OUTPUT=$(cd "$CWD" && npx tsc --noEmit 2>&1)
    TSC_EXIT=$?
    if [ $TSC_EXIT -ne 0 ]; then
      echo "TypeScript 에러가 아직 남아있습니다. 모든 에러를 수정해주세요:" >&2
      echo "$TSC_OUTPUT" | head -20 >&2
      exit 2
    fi
  fi
fi

# --- 검사 2: ESLint 에러 체크 ---
if [ -f "$CWD/.eslintrc.json" ] || [ -f "$CWD/.eslintrc.js" ] || [ -f "$CWD/eslint.config.js" ] || [ -f "$CWD/eslint.config.mjs" ]; then
  if command -v npx &>/dev/null; then
    LINT_OUTPUT=$(cd "$CWD" && npx eslint . --max-warnings=0 2>&1)
    LINT_EXIT=$?
    if [ $LINT_EXIT -ne 0 ]; then
      echo "ESLint 에러가 남아있습니다. 수정해주세요:" >&2
      echo "$LINT_OUTPUT" | head -20 >&2
      exit 2
    fi
  fi
fi

# --- 검사 3: Python ruff check ---
if [ -f "$CWD/pyproject.toml" ] || [ -f "$CWD/setup.py" ] || [ -f "$CWD/setup.cfg" ]; then
  if command -v ruff &>/dev/null; then
    RUFF_OUTPUT=$(cd "$CWD" && ruff check . 2>&1)
    RUFF_EXIT=$?
    if [ $RUFF_EXIT -ne 0 ]; then
      echo "ruff 에러가 남아있습니다. 수정해주세요:" >&2
      echo "$RUFF_OUTPUT" | head -20 >&2
      exit 2
    fi
  elif command -v poetry &>/dev/null && [ -f "$CWD/pyproject.toml" ]; then
    RUFF_OUTPUT=$(cd "$CWD" && poetry run ruff check . 2>&1)
    RUFF_EXIT=$?
    if [ $RUFF_EXIT -ne 0 ]; then
      echo "ruff 에러가 남아있습니다. 수정해주세요:" >&2
      echo "$RUFF_OUTPUT" | head -20 >&2
      exit 2
    fi
  fi
fi

# --- 검사 4: Python mypy 타입 체크 ---
if [ -f "$CWD/pyproject.toml" ]; then
  # mypy 설정이 pyproject.toml에 있는지 확인
  if grep -q '\[tool\.mypy\]' "$CWD/pyproject.toml" 2>/dev/null || grep -q '\[mypy\]' "$CWD/mypy.ini" 2>/dev/null; then
    if command -v poetry &>/dev/null; then
      MYPY_OUTPUT=$(cd "$CWD" && poetry run mypy . --no-error-summary 2>&1 | grep -E ": error:" | head -20)
      if [ -n "$MYPY_OUTPUT" ]; then
        echo "mypy 타입 에러가 남아있습니다. 수정해주세요:" >&2
        echo "$MYPY_OUTPUT" >&2
        exit 2
      fi
    elif command -v mypy &>/dev/null; then
      MYPY_OUTPUT=$(cd "$CWD" && mypy . --no-error-summary 2>&1 | grep -E ": error:" | head -20)
      if [ -n "$MYPY_OUTPUT" ]; then
        echo "mypy 타입 에러가 남아있습니다. 수정해주세요:" >&2
        echo "$MYPY_OUTPUT" >&2
        exit 2
      fi
    fi
  fi
fi

# 모든 검사 통과 - 멈춤 허용
exit 0

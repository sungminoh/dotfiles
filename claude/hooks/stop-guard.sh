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

# --- 검사 1: TypeScript 에러 체크 ---
if [ -f "$CWD/tsconfig.json" ]; then
  # npx tsc가 있으면 에러 체크
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

# 모든 검사 통과 - 멈춤 허용
exit 0

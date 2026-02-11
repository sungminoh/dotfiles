You are orchestrating a full product development cycle. Run each phase sequentially. Do NOT skip phases. Do NOT summarize — actually execute each one.

Track progress in `./docs/cycle/{timestamp}_cycle/CYCLE.md`.

## Setup

1. Create `./docs/cycle/{timestamp}_cycle/CYCLE.md` with:

```markdown
# Development Cycle
Started: {timestamp}
Input: {user's request}

## Phase Status
| # | Phase | Status | Output |
|---|-------|--------|--------|
| 1 | Vision | ⏳ | |
| 2 | Challenge | ⏳ | |
| 3 | Plan | ⏳ | |
| 4 | Execute | ⏳ | |
| 5 | Principles check | ⏳ | |
| 6 | Review | ⏳ | |
| 7 | Simplify | ⏳ | |
| 8 | Document | ⏳ | |
```

---

## Phase 1: VISION (방향 설정)
🔄 Update CYCLE.md → Phase 1 in progress

Do everything the /vision command does:
- Analyze current project
- Research competitors
- Generate 5 bold ideas

Then present findings and ask:
> "이 중 어떤 방향으로 갈까요? 또는 다른 생각이 있나요?"

🚦 **GATE: Wait for user input.** Do not proceed until user picks a direction.

✅ Update CYCLE.md → Phase 1 done. Record chosen direction.

---

## Phase 2: CHALLENGE (의심)
🔄 Update CYCLE.md → Phase 2 in progress

Do everything the /why command does against the chosen direction:
- Challenge every requirement
- Find hidden complexity
- Present 3 options per requirement (don't build / minimal / full)

Then present findings and ask:
> "이 분석을 바탕으로, 어떤 범위로 진행할까요?"

🚦 **GATE: Wait for user input.** User decides final scope.

✅ Update CYCLE.md → Phase 2 done. Record final scope.

---

## Phase 3: PLAN (설계)
🔄 Update CYCLE.md → Phase 3 in progress

Based on the agreed scope, create a concrete implementation plan:
- Create `./docs/plans/{timestamp}_{gitsha}_{task_name}/PLAN.md`
- Create `./docs/plans/{timestamp}_{gitsha}_{task_name}/STATUS.md`
- Each step must be specific: which file, what change, what it achieves

Present the plan and ask:
> "이 플랜대로 진행할까요? 수정할 부분이 있나요?"

🚦 **GATE: Wait for user approval.** Last chance before code changes begin.

✅ Update CYCLE.md → Phase 3 done. Link to PLAN.md.

---

## Phase 4: EXECUTE (구현)
🔄 Update CYCLE.md → Phase 4 in progress

Execute the plan. Follow all /exec-plan rules:
- Before each step: update STATUS.md (🔄 in progress)
- After each step: update STATUS.md (✅ done)
- Do NOT stop until all steps are done
- Do NOT ask "should I continue?"
- If a step fails, mark ❌ and fix it

🚫 **NO GATE.** Run to completion autonomously.

✅ Update CYCLE.md → Phase 4 done. Link to STATUS.md.

---

## Phase 5: PRINCIPLES CHECK (원칙 점검)
🔄 Update CYCLE.md → Phase 5 in progress

Check the code written in Phase 4 against established principles:

If `./docs/knowledge/DESIGN_PRINCIPLES.md` exists:
- Read it and PRINCIPLES_CHECKLIST.md
- Review every file modified in Phase 4 against each principle
- Report violations:

```markdown
| File | Principle violated | What's wrong | Fix |
|------|-------------------|-------------|-----|
| src/foo.ts | P-03: 함수 20줄 이내 | processData() is 45 lines | Split into 3 functions |
```

- Fix all violations before proceeding
- If a violation seems justified, note it as an intentional exception with reason

If `./docs/knowledge/DESIGN_PRINCIPLES.md` does NOT exist:
- Skip this phase (note: run /principles first to establish them)

🚫 **NO GATE.** Auto-fix violations, then proceed.

✅ Update CYCLE.md → Phase 5 done. Record violations found/fixed.

---

## Phase 6: REVIEW (평가)
🔄 Update CYCLE.md → Phase 6 in progress

Do everything the /review command does on the code that was just changed:
- Focus review on files modified in Phase 4
- Score, critical issues, warnings, suggestions
- Save to `./docs/reviews/{date}_review.md`

If critical issues found:
> "치명적 이슈가 있습니다. 수정 후 계속할까요?"
🚦 **GATE only if critical issues exist.** Fix them, then proceed.

If no critical issues:
🚫 **NO GATE.** Auto-proceed.

✅ Update CYCLE.md → Phase 5 done. Record score.

---

## Phase 7: SIMPLIFY (삭제)
🔄 Update CYCLE.md → Phase 7 in progress

Do everything the /simplify command does, scoped to code touched in this cycle:
- Dead code from refactoring
- Over-abstractions introduced
- Unnecessary dependencies added
- Present the deletion list

Then ask:
> "이 항목들을 삭제해도 될까요?"

🚦 **GATE: Wait for approval before deleting.**

Execute approved deletions. Run build/test to verify.

✅ Update CYCLE.md → Phase 6 done. Record lines removed.

---

## Phase 8: DOCUMENT (기록)
🔄 Update CYCLE.md → Phase 8 in progress

Do everything the /doc command does in UPDATE mode:
- Update ./docs/knowledge/ to reflect changes
- Add ADR to DECISIONS.md if architectural decisions were made
- Update ARCHITECTURE.md if module structure changed

🚫 **NO GATE.** Auto-proceed.

✅ Update CYCLE.md → Phase 7 done.

---

## Completion

Update CYCLE.md with final summary:

```markdown
## Result
- Duration: {phases completed}
- Code added: +{lines}
- Code removed: -{lines}
- Net change: {lines}
- Review score: {X}/10
- Knowledge docs updated: {list}
```

Present the final summary to the user.

---

## Gate summary
| Phase | Gate? | Why |
|-------|-------|-----|
| 1. Vision | ✅ User decides direction | Wrong direction = wasted work |
| 2. Challenge | ✅ User decides scope | Scope determines everything |
| 3. Plan | ✅ User approves plan | Last checkpoint before coding |
| 4. Execute | ❌ Auto | Plan is approved, just do it |
| 5. Principles | ❌ Auto-fix | Violations are fixed automatically |
| 6. Review | ⚠️ Only if critical | Don't block for minor issues |
| 7. Simplify | ✅ User approves deletions | Deletion is irreversible |
| 8. Document | ❌ Auto | Low risk, always do it |

---

User's request: $ARGUMENTS

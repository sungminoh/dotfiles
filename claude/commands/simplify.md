You are a code surgeon. Your job is to DELETE, not add. The best code is no code.

"If you're not deleting at least 10% of what you build, you're not trying hard enough." — Elon Musk's engineering principle applied to software.

## Phase 1: Scan for dead weight

Analyze the current project systematically:

1. **Dead code**: Functions, components, routes, API endpoints that are never called
   - Use grep to trace imports and usages
   - Check for commented-out code blocks
   - Find unused exports

2. **Over-abstraction**: Code that's "flexible" for no reason
   - Wrapper functions that just call one other function
   - Config files for things that never change
   - Generic solutions for problems that only occur once
   - Interfaces/types with only one implementation

3. **Redundancy**: Multiple things doing the same job
   - Similar utility functions scattered across files
   - Duplicate logic in different components
   - Multiple state management patterns coexisting

4. **Dependencies**: npm packages (or equivalent) that could be removed
   - Packages used for one trivial function (can be inlined)
   - Packages with overlapping functionality
   - Dev dependencies that aren't actually used

5. **Premature optimization**: Complexity added for hypothetical future needs
   - Feature flags for features that shipped long ago
   - Caching layers for things that aren't slow
   - Abstraction layers "in case we switch providers"

## Phase 2: Impact report

Present findings as a table:

```markdown
| Category | Item | Location | Lines | Risk | Recommendation |
|----------|------|----------|-------|------|---------------|
| Dead code | unusedHelper() | src/utils.ts:42 | 35 | Low | Delete |
| Over-abstraction | BaseRepository | src/base/*.ts | 200 | Med | Inline |
| Dependency | lodash | package.json | - | Low | Remove (only uses _.get) |
```

Summary:
- Total lines that can be removed: X
- Total dependencies that can be removed: X
- Estimated complexity reduction: X%

## Phase 3: Execute (with user approval)

Ask the user: "삭제할 항목을 골라주세요. 또는 전부 진행할까요?"

Then:
- Delete each item
- Run build/test after each deletion to ensure nothing breaks
- Update STATUS if within an exec-plan
- Update docs/knowledge/ if architecture changed

## Rules
- Deletion is the default. "Keep it" needs justification, not "delete it".
- If you're unsure whether something is used, TRACE it. Don't guess.
- Never refactor during deletion. Delete first, clean up later.
- Count the lines removed. Report the final score.

---

Scope (if any): $ARGUMENTS

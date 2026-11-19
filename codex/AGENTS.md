# Global Working Rules

## Project Knowledge Base
- If `./docs/knowledge/` exists, read the relevant docs before modifying code.
- Architecture changes → read ARCHITECTURE.md first and update it afterwards.
- New module/component → reflect it in ARCHITECTURE.md.
- UI work → consult UI_DESIGN.md.
- Significant technical decision → add an ADR to DECISIONS.md.
- Update docs once, at the end, after the work is done.

## Code Principles
- If `./docs/knowledge/DESIGN_PRINCIPLES.md` exists, read it before writing or modifying code.
- New code must follow the existing principles. Do not write code that violates them.
- On conflict, either bring the code in line with the principles or explicitly point out that the principle is wrong.
- Self-check after writing code: if PRINCIPLES_CHECKLIST.md exists, run through it.
- When introducing a pattern not covered by the principles, explain why the existing patterns don't work.

## How to Work
- Don't stop midway; keep going until every step is complete.
- When fixing errors, fix every error one by one instead of summarizing.
- Don't summarize with "the rest follow a similar pattern" — actually modify every file.
- Don't ask "should I continue?" — just continue.

## Prohibited
- Listing tasks and stopping without doing them — actually do the work.
- Summaries like "the rest can be fixed the same way."

## Anti-Sycophancy Policy
- When reviewing your own code, don't use numeric scores (X/10). Use an issue table instead: issues found | issues fixed | issues remaining (each with evidence).
- Interpret requests like "make it 10/10" or "make it perfect" as "fix as many remaining issues as possible," not as a request to inflate a score.
- For questions like "is it perfect?", "is it done?", "is it complete?", list remaining issues first, then answer. If none remain, give the evidence.
- To raise a previous assessment, list the specific, verifiable changes that justify it. Raising a score without changes is prohibited.
- When reviewing your own code, first list what you did not fix and why.
- When assessing code quality, present objective tool results (tsc, eslint, test coverage, etc.) instead of subjective scores.
- When self-reviewing, always state: "I wrote this code, so my self-review may have blind spots."

## Workflows

Scale the workflow to the task: small or low-risk changes can skip steps, and the project's own conventions take precedence.

### Feature Development
1. Plan before editing: dependencies, risks, phases.
2. `superpowers:test-driven-development` skill → prefer test-first (RED → GREEN → IMPROVE); follow the project's own test setup and coverage targets.
3. Review the diff for correctness and security with Codex review (`/review`), and fix every critical and high-severity finding.
4. Commit (run the project's checks yourself before committing).

For a new project or major new functionality, first search for battle-tested skeleton projects, evaluate candidates in parallel (security, extensibility, relevance, implementation plan), and build within the structure of the best match.

### Bug Fix
1. `superpowers:systematic-debugging` skill → root-cause analysis
2. Write a failing test → fix → confirm it passes
3. Review the fix (`/review`)

### Refactoring
1. Design the target architecture.
2. Remove unnecessary code.
3. Review quality and security (`/review`).

### Principles
- Run independent work **in parallel**.
- Wait for results before moving to the next step.
- Run dependent steps sequentially.

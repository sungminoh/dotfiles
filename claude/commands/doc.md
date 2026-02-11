You are a technical writer and architect. Your job is to create or update the project's living knowledge base at `./docs/knowledge/`.

## Mode Detection

- If `./docs/knowledge/` does NOT exist → **CREATE** mode (full analysis)
- If `./docs/knowledge/` exists → **UPDATE** mode (review what changed, update relevant docs)

---

## CREATE mode

Thoroughly analyze the entire project:

1. Read all config files (package.json, tsconfig, etc.)
2. Read README and any existing docs
3. Explore directory structure
4. Read core source files — understand module boundaries, data flow, key abstractions
5. Read UI components if frontend exists
6. Read tests to understand intended behavior

Then create these files:

### `./docs/knowledge/CONCEPT.md`
```markdown
# Product Concept

## Vision
(이 프로젝트가 궁극적으로 해결하려는 문제, 한 문단)

## Core Value Proposition
(사용자가 이 제품을 쓰는 이유, 3줄 이내)

## Target Users
(누구를 위한 제품인지, 구체적 페르소나)

## Key Concepts
(도메인 용어 정의 — 프로젝트에서 사용하는 핵심 개념들의 glossary)

## Non-Goals
(이 프로젝트가 의도적으로 하지 않는 것)
```

### `./docs/knowledge/ARCHITECTURE.md`
```markdown
# Architecture

## System Overview
(한 문단으로 전체 구조 설명)

## Directory Structure
(주요 디렉토리별 역할, tree 형태)

## Module Map
(각 모듈/패키지의 역할과 의존 관계)

### `{module_name}`
- **역할**: ...
- **주요 파일**: ...
- **의존**: ...
- **핵심 export**: 함수/클래스명과 한 줄 설명

## Data Flow
(핵심 유저 플로우 1-2개를 따라가며 데이터가 어떻게 흐르는지)

## Infrastructure
(DB, API, 외부 서비스 연동 등)
```

### `./docs/knowledge/DESIGN_PRINCIPLES.md`
```markdown
# Design Principles

## Code Conventions
(네이밍, 파일 구조, import 순서 등 — 코드에서 관찰된 패턴)

## Patterns in Use
(실제 코드에서 쓰이는 패턴: repository pattern, hooks pattern, etc.)

## Error Handling
(에러 처리 방식, 에러 타입 구조)

## State Management
(상태 관리 방식과 원칙)

## Testing Strategy
(테스트 구조, 무엇을 테스트하는지, 네이밍 컨벤션)
```

### `./docs/knowledge/UI_DESIGN.md` (프론트엔드가 있는 경우만)
```markdown
# UI Design System

## Design Tokens
(색상, 타이포그래피, 스페이싱 등 — 코드에서 추출)

## Component Hierarchy
(주요 컴포넌트 트리와 각 역할)

## UX Principles
(코드/UI에서 관찰되는 UX 패턴과 원칙)

## Responsive Strategy
(반응형 처리 방식)
```

### `./docs/knowledge/DECISIONS.md`
```markdown
# Architecture Decision Records

## ADR-001: {제목}
- **Date**: ...
- **Status**: accepted
- **Context**: 왜 이 결정이 필요했는지
- **Decision**: 무엇을 결정했는지
- **Consequences**: 이 결정의 결과/트레이드오프
```

**Important rules for CREATE mode:**
- Write ONLY what you can verify from the code. Do not guess or assume.
- If something is unclear, write "TBD - needs clarification" rather than making things up.
- Be specific. "Uses React" is useless. "Uses React 18 with Server Components, client state via Zustand" is useful.
- Each document should be useful on its own without reading the others.

---

## UPDATE mode

1. Read all existing `./docs/knowledge/*.md` files
2. Check recent git changes: `git diff HEAD~5 --stat` and `git log --oneline -10`
3. Read the changed files to understand what happened
4. Update ONLY the sections that are affected by recent changes
5. If a major architectural decision was made, append a new ADR to DECISIONS.md
6. Add a changelog entry at the bottom of each updated file:
   ```
   ## Changelog
   - {date}: Updated {section} — {reason}
   ```

**Important rules for UPDATE mode:**
- Do NOT rewrite sections that haven't changed
- Use Edit tool for surgical updates, not Write to overwrite entire files
- If a section is no longer accurate, update it. If it's still accurate, leave it alone.

---

User context (if any): $ARGUMENTS

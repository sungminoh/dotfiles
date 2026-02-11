Read this guide and present it to the user in a clear, organized format. If the user asks about a specific command, explain that one in detail. If no arguments, show the full overview.

---

# Claude Code Workflow Guide

## Commands Overview

| Command | Purpose | When to use |
|---------|---------|-------------|
| `/guide` | 이 가이드 표시 | 커맨드가 기억 안 날 때 |
| `/vision` | 프로덕트 비전/로드맵 브레인스토밍 | 새 프로젝트, 방향 전환, 아이디어 필요할 때 |
| `/why` | 요구사항 의심 + 대안 제시 | 기능 추가 전에 "이거 진짜 필요한가?" |
| `/principles` | 코드 원칙 수립/점검/진화 | 프로젝트 초기, 또는 원칙 정기 점검 |
| `/doc` | 프로젝트 지식 베이스 생성/갱신 | 프로젝트 초기, 큰 변경 후 |
| `/exec-plan` | 구현 플랜 생성 + 자동 실행 | 구체적 기능 구현할 때 |
| `/review` | 코드 품질 평가 (솔직한 점수) | 기능 완성 후, 정기 점검 |
| `/simplify` | 불필요한 코드 찾아서 삭제 | 기능 완성 후, 코드 비대해졌을 때 |
| `/cycle` | 위 전체를 순서대로 자동 실행 | 큰 기능을 처음부터 끝까지 한 번에 |

---

## Quick Start Scenarios

### 새 프로젝트 시작
```
/principles          # 코드 원칙 수립
/doc                 # 프로젝트 지식 베이스 초기 생성
/vision              # 프로덕트 방향 설정
```

### 기능 구현 (풀 사이클)
```
/cycle 결제 시스템 추가
```
Vision → Challenge → Plan → Execute → Principles Check → Review → Simplify → Document 를 순서대로 실행. 의사결정 포인트에서만 멈춤.

### 기능 구현 (빠르게)
```
/exec-plan 로그인 API 추가
```
플랜 작성 + 즉시 구현. `./docs/plans/` 에 PLAN.md, STATUS.md 생성.

### "이거 만들어야 하나?" 판단
```
/why 실시간 알림 기능
```
3가지 옵션 제시: 안 만들기 / 최소 버전 / 풀 구현

### 코드 정기 점검
```
/principles          # 원칙 아직 유효한지?
/review              # 품질 점수
/simplify            # 군살 제거
```

---

## File Structure

### Global (모든 프로젝트 공통)
```
~/.claude/
├── CLAUDE.md              # 글로벌 규칙 (멈추지 마, 원칙 참조)
├── settings.json          # Stop Hook, 플러그인 설정
├── commands/
│   ├── guide.md           # /guide - 이 파일
│   ├── vision.md          # /vision
│   ├── why.md             # /why
│   ├── principles.md      # /principles
│   ├── doc.md             # /doc
│   ├── exec-plan.md       # /exec-plan
│   ├── review.md          # /review
│   ├── simplify.md        # /simplify
│   └── cycle.md           # /cycle
└── hooks/
    ├── stop-guard.sh      # tsc/eslint 에러 체크 (Stop Hook)
    └── plan-template.md   # 플랜 템플릿 (참고용)
```

### Per Project (프로젝트별 생성됨)
```
project/
├── CLAUDE.md              # 프로젝트 고유 규칙 (기존 것 유지)
├── docs/
│   ├── VISION.md          # /vision 결과물
│   ├── knowledge/
│   │   ├── CONCEPT.md          # 비전, 핵심 컨셉, 타겟 유저
│   │   ├── ARCHITECTURE.md     # 모듈 구조, 데이터 흐름
│   │   ├── DESIGN_PRINCIPLES.md # 코드 원칙
│   │   ├── PRINCIPLES_CHECKLIST.md # 원칙 체크리스트
│   │   ├── UI_DESIGN.md        # 디자인 시스템 (프론트엔드)
│   │   └── DECISIONS.md        # 아키텍처 의사결정 기록
│   ├── plans/
│   │   └── {timestamp}_{sha}_{name}/
│   │       ├── PLAN.md         # 구현 플랜
│   │       └── STATUS.md       # 진행 상황
│   ├── reviews/
│   │   └── {date}_review.md    # 코드 리뷰 결과
│   └── cycle/
│       └── {timestamp}_cycle/
│           └── CYCLE.md        # 풀 사이클 진행 상황
```

---

## How It All Connects

### 자동 참조 (코드 작성 시)
`~/.claude/CLAUDE.md`에 의해 Claude는 코드를 수정하기 전에 자동으로:
- `DESIGN_PRINCIPLES.md` 읽고 원칙 준수
- `ARCHITECTURE.md` 읽고 구조 파악
- 작업 후 관련 문서 업데이트

### Stop Hook (작업 멈출 때)
`stop-guard.sh`가 tsc/eslint 에러를 체크해서, 에러가 남아있으면 Claude가 계속 작업.

### /cycle 파이프라인
```
Vision ──→ Challenge ──→ Plan ──→ Execute ──→ Principles ──→ Review ──→ Simplify ──→ Document
  🚦          🚦          🚦       auto         auto         ⚠️          🚦          auto
 방향?        범위?       승인?     실행        원칙체크     평가         삭제?       기록
```
🚦 = 유저 입력 필요, auto = 자동 진행, ⚠️ = 문제 있을 때만 멈춤

---

## Design Philosophy

일론 머스크 5단계 엔지니어링 프로세스 기반:

| 원칙 | 커맨드 | 핵심 질문 |
|------|--------|----------|
| 1. 요구사항을 의심하라 | `/why` | "이거 진짜 필요해?" |
| 2. 삭제하라 | `/simplify` | "지울 수 있는 거 다 찾아" |
| 3. 단순화/최적화 | `/principles`, `/review` | "원칙에 맞나? 품질은?" |
| 4. 사이클 가속 | `/exec-plan`, `/cycle` | "멈추지 말고 끝까지" |
| 5. 자동화 | `/doc`, Stop Hook | "지식을 자동 유지" |

---

User's question (if any): $ARGUMENTS

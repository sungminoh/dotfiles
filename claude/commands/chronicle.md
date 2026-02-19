# Project Evolution Chronicle

프로젝트의 진화 내역을 분석하고, 다관점 평가와 함께 `docs/evolution/` 디렉토리에 기록합니다.

## 산출물

| 파일 | 내용 |
|------|------|
| `docs/evolution/{날짜}_{short-sha}.md` | 진화 기록 (Phase별 커밋 분석) |
| `docs/evolution/{날짜}_{short-sha}_eval.html` | 게임 스탯창 형태의 다관점 평가 (브라우저에서 열기) |

---

## Part 1: 메타데이터 수집

다음 명령어를 **병렬로** 실행하여 현재 상태를 수집합니다:

```bash
# 현재 HEAD SHA (full + short)
git rev-parse HEAD
git rev-parse --short HEAD

# 오늘 날짜
date +%Y-%m-%d

# 총 커밋 수
git log --oneline | wc -l

# 첫 커밋 날짜
git log --format="%ad" --date=short --reverse | head -1

# 전체 커밋 로그 (SHA, 날짜, 메시지)
git log --oneline --format="%h %ad %s" --date=short --reverse

# 코드 통계
npx cloc src/ --quiet

# 테스트 수
npx vitest run --reporter=json 2>/dev/null | python3 -c "import sys,json; [print(f'Tests: {json.loads(l)[\"numTotalTests\"]}, Passed: {json.loads(l)[\"numPassedTests\"]}, Suites: {json.loads(l)[\"numTotalTestSuites\"]}') for l in sys.stdin if l.strip().startswith('{')]"

# 페이지/API 수
ls src/app/**/page.tsx 2>/dev/null | wc -l
ls src/app/api/**/route.ts 2>/dev/null | wc -l

# 컴포넌트 수
ls src/components/**/*.tsx 2>/dev/null | wc -l
```

---

## Part 2: 기존 기록 확인 (증분 모드)

`docs/evolution/` 디렉토리에서 가장 최근 `.md` 기록을 읽어서:
- 이전 기록의 마지막 SHA를 확인
- `git log {이전SHA}..HEAD --format="%h %ad %s" --date=short`로 새 커밋만 추출
- 이전 기록 이후의 변경분만 분석

기존 기록이 없으면 전체 히스토리를 분석합니다.

---

## Part 3: 진화 기록 (Markdown)

`docs/evolution/{날짜}_{short-sha}.md` 파일을 생성합니다.

**필수 포함 항목:**

1. **헤더 메타데이터**
   - 기록 날짜, Git SHA (full), 총 커밋 수, 기간
   - 증분 모드면 "이전 기록: {파일명}" 참조

2. **Phase별 정리**
   - 커밋을 의미 있는 Phase로 그룹핑
   - Phase 경계: 날짜 변화, 아키텍처 변화, 기능 도메인 변화
   - 각 Phase에 "Key decision" (핵심 결정) 1~2개 명시

3. **마일스톤 테이블** (Phase마다)
   ```
   | Milestone | SHA | Description |
   ```

4. **기술 스택 스냅샷**: 주요 의존성과 버전 (`package.json`에서 추출)

5. **아키텍처 다이어그램**: 현재 `src/` 디렉토리 구조 (tree 형식)

6. **정량적 지표 테이블**
   ```
   | Metric | Value |
   |--------|-------|
   | Commits | ... |
   | LoC | ... |
   | Files | ... |
   | Tests | ... |
   | Pages | ... |
   | API Routes | ... |
   | Components | ... |
   ```

7. **진화 아크**: 시간순 한줄 요약 (ASCII timeline)

**작성 원칙:**
- 커밋 메시지를 그대로 복사하지 말고, 의미 단위로 묶어서 해석
- 한국어로 작성 (커밋 메시지, 코드 참조는 영어 유지)
- 증분 모드면 새 Phase만 작성 + 누적 지표 업데이트

---

## Part 4: 다관점 평가 (HTML Stat Card)

`docs/evolution/{날짜}_{short-sha}_eval.html` 파일을 생성합니다.

Chart.js CDN을 사용한 self-contained HTML로, 게임 스탯창 스타일의 평가를 그립니다.

### 평가 관점 (3개 Radar Chart)

**Engineering (기술)**
- Architecture, Maintainability, Security, Code Quality, Test Coverage, Performance, DevOps/CI, Scalability

**Business (비즈니스)**
- Velocity, Cost Efficiency, Competitive Moat, Regulatory, Market Fit, Growth Model, Monetization, Multi-tenant

**Product (제품)**
- AI Integration, Feature Depth, Data Visualization, UX Design, Mobile UX, Accessibility, Simplicity, Onboarding

### 각 카드 구성

1. **Radar chart** — 8축 분포
2. **Bar chart** — 각 항목 점수 바 (높은 순 정렬)
3. **Assessment** — 항목별 근거 코멘트 (데이터 기반, 구체적 수치 인용)
4. **Verdict** — 관점별 한줄 판결

### 점수 산정 원칙

- 수집된 메타데이터(커밋수, 테스트수, LoC, 파일수 등)와 코드 구조를 기반으로 점수 산정
- 각 점수에 반드시 근거를 제시 (예: "Tests 82 — 773개 테스트이나 E2E 부족")
- 이전 평가가 있으면 점수 변화를 delta로 표시 (+3, -2 등)
- Overall Score = 3개 관점의 가중 평균 (Engineering 40%, Product 35%, Business 25%)

### HTML 디자인 사양

- 다크 테마 (bg: #0a0e17, card: #111827)
- 폰트: JetBrains Mono (수치) + Noto Sans KR (코멘트)
- 색상: Engineering=#3b82f6, Business=#f59e0b, Product=#10b981
- Bar 애니메이션: CSS transition으로 로딩 시 좌→우 채워짐
- 반응형: 모바일에서 1컬럼 레이아웃

---

## Part 5: 완료

1. 두 파일이 정상 생성되었는지 확인
2. HTML을 브라우저에서 열기 (`open` 명령)
3. 파일 경로를 사용자에게 보고

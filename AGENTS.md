# AGENTS.md — Codex 운영 가이드

이 프로젝트는 Claude Code와 Codex를 함께 사용한다. Claude Code용 원본 정의는 `.claude/` 아래에 있으며, Codex는 이 파일을 호환 레이어로 사용한다.

## 0. 프로젝트 요약

초등학교 2학년 자녀를 홈스쿨링하는 부모를 위한 **사고력 중심 일일 학습 콘텐츠 생성 시스템**이다. 매일 저녁 30분~1시간 분량의 수학·국어·영어 자료를 만들고, 세션 후 부모 피드백을 `outputs/progress.md`와 `student/profile.md`에 누적한다.

목표는 기초 정착, 한 단계 위 사고력, 자신감 형성이다.

## 1. 세션 시작 루틴

새 작업을 시작할 때는 다음 순서로 읽고 현재 상태를 파악한다.

1. `PROGRESS.md` — 시스템 구현·설계 결정
2. `outputs/progress.md` — 아이 학습 진도·오답·누적 복습 트래커
3. `student/profile.md` — 아이의 현재 수준·취약점
4. 필요한 경우 `outputs/curriculum/{과목}.md`
5. 필요한 경우 `data/academy_research.md`

두 progress 파일을 혼동하지 않는다.

| 파일 | 의미 |
|------|------|
| `/PROGRESS.md` | 시스템 설계·구현 진행 |
| `outputs/progress.md` | 아이 학습 진도 |

## 2. Claude 정의를 단일 원본으로 사용

Codex에서 slash command처럼 보이는 사용자 입력을 받으면 `.claude/commands/{command}.md`를 먼저 읽고 그 절차대로 실행한다.

| 사용자 입력 | Codex가 읽을 파일 |
|-------------|------------------|
| `/today ...` | `.claude/commands/today.md` |
| `/done ...` | `.claude/commands/done.md` |
| `/plan ...` | `.claude/commands/plan.md` |
| `/level ...` | `.claude/commands/level.md` |
| `/review ...` | `.claude/commands/review.md` |

과목별 콘텐츠를 만들 때는 `.claude/agents/{agent}.md`를 해당 역할 프롬프트처럼 적용한다.

| 과목/작업 | 읽을 agent 정의 |
|-----------|----------------|
| 수학 | `.claude/agents/math-tutor.md` |
| 국어 | `.claude/agents/korean-tutor.md` |
| 영어 | `.claude/agents/english-tutor.md` |
| 과학·인문학·enrichment | `.claude/agents/enrichment-tutor.md` |
| 커리큘럼 | `.claude/agents/curriculum-planner.md` |

Codex의 실제 `spawn_agent` 도구는 사용자가 명시적으로 병렬 agent 작업을 요청한 경우에만 사용한다. 일반 `/today`, `/done`, `/plan`에서는 위 Markdown 정의를 로컬 역할 지침으로 읽고 직접 수행한다.

## 3. 자주 쓰는 명령 처리

### `/today [과목|자유 메모]`

1. `.claude/commands/today.md`를 읽는다.
2. `student/profile.md`, `outputs/progress.md`, `data/academy_research.md`, 해당 `outputs/curriculum/{과목}.md`를 읽는다.
3. 과목을 정한다. 과목이 없으면 요일 로테이션과 최근 세션을 기준으로 정한다.
4. 해당 `.claude/agents/*-tutor.md` 정의를 적용해 자료를 생성한다.
5. `outputs/daily/YYYY-MM-DD-{과목}.md`에 작성한다.
6. 마무리로 생성 파일과 `/done` 안내를 짧게 알린다.
7. 같은 날짜·과목의 `YYYY-MM-DD-{과목}-done.md`가 이미 있으면 완료 자료로 보고 덮어쓰지 않는다.

### `/done [메모]`

1. `.claude/commands/done.md`를 읽는다.
2. `outputs/progress.md`, `student/profile.md`, `outputs/learning-log.md`, 오늘 또는 최근의 `outputs/daily/YYYY-MM-DD-{과목}.md`를 읽는다.
3. 부모 메모에서 과목, 맞은/틀린 문제, 오답 패턴, 아이 반응을 추출한다.
4. `outputs/progress.md`와 `student/profile.md`를 갱신한다.
5. 대상 daily 파일을 `outputs/daily/YYYY-MM-DD-{과목}-done.md`로 이름 바꿔 완료 상태가 파일명에 보이게 한다. 이미 `-done.md`이면 유지한다.
6. `outputs/learning-log.md` 맨 위에 git log 스타일의 짧은 학습 로그를 추가한다.
7. 다음 세션에서 보강할 포인트를 1줄로 정리한다.

메모가 모호해서 학습 기록이 왜곡될 위험이 있으면 1~2개만 짧게 질문한다. 충분히 추론 가능하면 바로 갱신한다.

## 4. 출력·편집 규칙

- daily 파일은 과목별 별도 파일로 만든다: `outputs/daily/YYYY-MM-DD-{과목}.md`.
- `/done` 반영이 끝난 daily 파일은 `outputs/daily/YYYY-MM-DD-{과목}-done.md`로 표시한다.
- 완료 학습 요약은 `outputs/learning-log.md`에 최신순으로 누적한다.
- H1은 `# YYYY-MM-DD (요일) — {과목}` 형식을 따른다.
- "부모 컨디션 체크", "화 날 때 루틴" 같은 마인드 코칭 섹션은 넣지 않는다.
- 새 시스템 결정은 `PROGRESS.md` 섹션 2에 추가한다.
- 학습 결과는 `/PROGRESS.md`가 아니라 `outputs/progress.md`에 기록한다.
- `spec.md`는 참고용이며 수정하지 않는다.

## 5. Codex 사용 시 주의

- `.claude/` 파일은 Claude와 Codex가 함께 쓰는 원본 계약이다. 바꿀 때는 두 도구 모두에 영향을 준다고 보고 신중히 수정한다.
- Codex 전용 보조 문서는 `.codex/`에 둘 수 있지만, 규칙 자체를 중복 복사하지 않는다. 중복이 필요하면 원본 경로를 명시하고 짧은 adapter만 둔다.
- 사용자가 `/today 영어`, `/done ...`처럼 Claude Code 방식으로 말해도 일반 자연어 요청으로 해석하지 말고 위 command 라우터로 처리한다.
- 단, Codex UI/CLI가 알 수 없는 slash command를 모델에 보내기 전에 차단할 수 있다. 이 경우 사용자는 `'/done' ...`, `done ...`, `오늘 학습 결과: ...`처럼 앞에 따옴표나 일반 텍스트를 붙여 메시지가 모델까지 전달되게 한다. 모델은 그 내용을 `/done`으로 해석해 같은 절차를 실행한다.

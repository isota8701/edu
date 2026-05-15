# USAGE.md — Claude Code / Codex 공용 사용법

초등학교 2학년 아이를 위한 일일 학습 자료를 만들고, 학습 후 피드백을 누적하는 시스템입니다. 평소에는 아래 두 명령만 알면 됩니다.

```text
/today 영어
/done 2026-05-10 영어 완료. cat은 읽었고 map은 막힘. b/d를 헷갈려함.
```

Claude Code와 Codex가 같은 `.claude/commands/*.md` 정의를 사용합니다. Codex에서 `/today`, `/done`이 slash command로 막히면 앞에 따옴표를 붙이거나 일반 문장으로 보내면 됩니다.

```text
'/today' 영어
today 영어
오늘 영어 자료 만들어줘

'/done' 2026-05-10 영어 완료. cat OK, map 막힘.
done 2026-05-10 영어 완료. cat OK, map 막힘.
오늘 학습 결과: 2026-05-10 영어 완료. cat OK, map 막힘.
```

---

## 1. 매일 쓰는 흐름

```text
1. 자료 생성
   /today 영어

2. 생성된 파일로 아이와 학습
   outputs/daily/2026-05-15-영어.md

3. 학습 후 결과 기록
   /done 2026-05-15 영어 완료. dad는 잘 읽고 bag은 막힘.

4. 완료 파일명 확인
   outputs/daily/2026-05-15-영어-done.md

5. 학습 로그 확인
   outputs/learning-log.md
```

완료 전 자료는 `YYYY-MM-DD-{과목}.md`, 완료 후 자료는 `YYYY-MM-DD-{과목}-done.md`로 보입니다.

---

## 2. 가장 중요한 두 명령

### `/today` — 오늘 학습 자료 생성

```text
/today 수학
/today 국어
/today 영어
/today 과학
/today 인문학

/today 영어 오늘은 20분만
/today 수학 구구단 4단 보강
/today 오늘 피곤해서 짧게
```

자동으로 하는 일:
- `student/profile.md`, `outputs/progress.md`, `outputs/curriculum/{과목}.md`, `data/academy_research.md`를 읽습니다.
- 과목이 없으면 요일 로테이션과 최근 학습 기록을 보고 과목을 정합니다.
- 최근 오답과 누적 복습 항목을 오늘 자료에 섞습니다.
- `outputs/daily/YYYY-MM-DD-{과목}.md` 파일을 만듭니다.

### `/done` — 학습 결과 기록

가장 권장하는 입력 형식:

```text
/done 2026-05-10 영어 완료. cat은 읽었고 map은 막힘. b/d를 헷갈려함.
/done 2026-05-11 수학 완료. 도전2만 유도 필요. 문장제에서 빼기식 선택을 잠깐 고민함.
/done 영어 완료. dad OK, bag 막힘, is/this는 따라 읽기만 가능.
```

날짜를 생략하면 오늘 날짜 또는 가장 최근 daily 파일을 기준으로 처리합니다. 과목을 생략해도 추론할 수 있으면 처리하지만, 여러 자료가 있으면 물어볼 수 있습니다.

자동으로 하는 일:
- `outputs/progress.md`의 세션 로그, 오답, 누적 복습 트래커를 갱신합니다.
- `student/profile.md`의 취약점과 안정화된 영역을 갱신합니다.
- 학습 자료 파일명을 `outputs/daily/YYYY-MM-DD-{과목}-done.md`로 바꿉니다.
- `outputs/learning-log.md` 맨 위에 git log처럼 짧은 학습 기록을 추가합니다.

---

## 3. Claude Code와 Codex에서 쓰는 법

| 환경 | 권장 입력 | 비고 |
|------|----------|------|
| Claude Code | `/today 영어` | slash command가 그대로 동작 |
| Claude Code | `/done 2026-05-10 영어 완료. ...` | `.claude/commands/done.md` 실행 |
| Codex | `today 영어` 또는 `'/today' 영어` | `/today`가 UI에서 막히면 이 방식 사용 |
| Codex | `done 2026-05-10 영어 완료. ...` 또는 `'/done' ...` | 모델까지 전달되면 `/done`으로 해석 |

Codex에서 `Unrecognized command '/done'`가 나오면 시스템 규칙이 실패한 것이 아니라, Codex UI가 메시지를 모델에 보내기 전에 막은 것입니다. 이때는 `done ...`처럼 일반 텍스트로 보내면 됩니다.

---

## 4. 파일 이름 규칙

| 상태 | 파일명 예시 | 의미 |
|------|------------|------|
| 생성됨, 아직 완료 기록 없음 | `outputs/daily/2026-05-15-영어.md` | 학습 예정 또는 결과 미기록 |
| `/done` 반영 완료 | `outputs/daily/2026-05-15-영어-done.md` | 학습 완료 및 피드백 반영 |

규칙:
- daily 파일은 과목별로 분리합니다.
- 같은 날 영어와 수학을 모두 하면 파일도 둘입니다.
- `/done`은 해당 daily 파일 하나만 `-done.md`로 바꿉니다.
- 이미 `-done.md`이면 다시 이름을 바꾸지 않고 내용과 로그만 갱신합니다.

---

## 5. 학습 로그

간단한 전체 이력은 `outputs/learning-log.md`에서 봅니다. 형식은 git log처럼 최신 항목이 위에 옵니다.

```text
commit 2026-05-15-영어
Date: 2026-05-15 (금)
Subject: 영어
Topic: 단모음 a, b/d 구분, 사이트워드 is/this
Result: dad OK, bag 막힘, is/this는 따라 읽기만 가능
Next: b/d 미니게임과 bag/map 재노출
File: outputs/daily/2026-05-15-영어-done.md
```

`outputs/progress.md`는 자세한 누적 진도와 약점 관리용이고, `outputs/learning-log.md`는 한눈에 보는 타임라인입니다.

---

## 6. 가끔 쓰는 명령

```text
/plan 수학
/plan 국어
/plan 영어
/level 수학 종료
/review 받아내림
```

| 명령 | 언제 쓰는지 |
|------|------------|
| `/plan` | 커리큘럼을 새로 만들거나 다시 짤 때 |
| `/level` | 단원 시작/종료 진단이 필요할 때 |
| `/review` | 약한 부분만 변형 문제로 복습하고 싶을 때 |

평소에는 `/today`, `/done`만 사용하면 됩니다.

---

## 7. 주요 파일

| 파일 | 용도 |
|------|------|
| `outputs/daily/` | 매일 생성되는 학습 자료 |
| `outputs/learning-log.md` | 완료된 학습을 한눈에 보는 간단 로그 |
| `outputs/progress.md` | 자세한 학습 진도, 오답, 누적 복습 트래커 |
| `student/profile.md` | 아이의 현재 수준과 취약점 |
| `outputs/curriculum/` | 과목별 커리큘럼 |
| `PROGRESS.md` | 시스템 설계·구현 진행 기록 |

주의: `outputs/progress.md`는 아이 학습 진도이고, 루트의 `PROGRESS.md`는 시스템 개발 기록입니다.

---

## 8. 자주 묻는 질문

**Q. 날짜 형식은 꼭 `2026-05-10`이어야 하나?**  
A. `2026-05-10`, `2026.05.10`, `5/10` 모두 해석합니다. 다만 헷갈리지 않게 `2026-05-10`을 권장합니다.

**Q. `/done`을 했는데 파일이 안 바뀌면?**  
A. 과목이나 날짜 추론이 불확실했을 가능성이 큽니다. `done 2026-05-10 영어 완료 ...`처럼 날짜와 과목을 함께 적어 다시 보내세요.

**Q. 생성만 하고 학습하지 않은 파일은 어떻게 구분하나?**  
A. `-done.md`가 붙지 않은 daily 파일은 결과 미기록 상태입니다.

**Q. `outputs/progress.md`와 `outputs/learning-log.md`는 무엇이 다른가?**  
A. `outputs/progress.md`는 자세한 누적 관리용, `outputs/learning-log.md`는 날짜별 완료 내역을 빠르게 훑는 용도입니다.

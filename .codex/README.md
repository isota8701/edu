# .codex 호환 레이어

이 디렉터리는 Codex용 보조 문서를 둔다. 실제 운영 규칙의 단일 원본은 루트 `AGENTS.md`와 `.claude/` 아래 Markdown 파일이다.

## 사용 방식

- Codex 세션 시작 시 `AGENTS.md`를 읽는다.
- 사용자가 `/today`, `/done`, `/plan`, `/level`, `/review`를 입력하면 `AGENTS.md`의 라우팅 규칙에 따라 `.claude/commands/*.md`를 읽고 실행한다.
- 과목별 생성 규칙은 `.claude/agents/*.md`를 그대로 사용한다.

## Slash command 주의

Codex UI/CLI는 메시지가 모델에 도달하기 전에 `/...` 입력을 자체 slash command로 파싱할 수 있다. 이때 Codex에 등록되지 않은 `/done` 같은 명령은 `Unrecognized command`로 막히며, `AGENTS.md`의 라우팅 규칙까지 도달하지 않는다.

우회 입력:
- `'/done' 2026-05-11 수학 ...`
- `done 2026-05-11 수학 ...`
- `오늘 학습 결과: 2026-05-11 수학 ...`

위처럼 메시지가 모델에 전달되면 Codex는 `AGENTS.md`에 따라 `.claude/commands/done.md`를 읽고 `/done` 절차로 처리한다.

## 완료 표시와 학습 로그

`/done` 절차가 끝나면 Codex도 Claude Code와 동일하게 처리한다.

- 대상 daily 파일을 `outputs/daily/YYYY-MM-DD-{과목}-done.md`로 변경한다.
- `outputs/progress.md`와 `student/profile.md`를 갱신한다.
- `outputs/learning-log.md` 맨 위에 git log 스타일 요약을 추가한다.

## 중복 방지

Claude Code와 Codex가 같은 시스템을 쓰기 위해 `.claude/`를 canonical source로 유지한다. 이 디렉터리에는 복사본을 만들지 않고, Codex에 필요한 adapter 설명만 둔다.

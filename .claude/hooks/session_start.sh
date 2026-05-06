#!/usr/bin/env bash
# SessionStart hook — print context-loading order so the agent reads the right files
# in the right order at the start of every conversation.

cat <<'MSG'
[세션 시작 — 컨텍스트 읽기 순서 안내]
새 작업 진입 전, 다음 순서로 읽고 상태를 파악하세요:

  1) /PROGRESS.md            — 시스템 빌드 상태 + 설계 결정(D1~D21)
  2) /outputs/progress.md    — 아이 학습 진도 + "누적 복습 트래커"(D21) + 세션 로그
  3) /student/profile.md     — 아이 현재 수준·취약·강점
  4) /outputs/curriculum/{과목}.md  — 해당 과목 다주차 계획 (있으면)

매 세션 자료 생성 시 D21 비율 적용:
  · 새 진도 ~60%  · 누적 복습 ~30%  · 기초 자동화 점검 ~10%
  → "누적 복습 트래커"의 🔴 강화 항목을 우선 끌어와 문제에 자연스럽게 섞을 것.

세션 종료 시 /done 호출은 필수 — outputs/progress.md (누적 복습 트래커 포함)
와 student/profile.md 양쪽이 모두 갱신되어야 함.

⚠️ 두 progress 파일 헷갈리지 말 것: /PROGRESS.md = 시스템, /outputs/progress.md = 학습.
MSG

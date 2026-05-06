#!/usr/bin/env bash
# PostToolUse hook for Write tool.
# When a file under outputs/daily/ is created, remind the agent to keep
# outputs/progress.md (cumulative review tracker) and student/profile.md in sync.

set -e

INPUT=$(cat)

# Match file_path containing outputs/daily/ (cross-platform path handling).
if echo "$INPUT" | grep -Eq '"file_path"[^,}]*outputs[\\/]+daily[\\/]+'; then
  cat <<'MSG'
[세션 갱신 안내] outputs/daily/ 에 새 자료가 작성되었습니다.
세션 종료 후 다음 두 파일을 반드시 갱신하세요 (D21 누적 복습 원칙):
  1) outputs/progress.md  — 세션 로그 + "누적 복습 트래커" 상태 갱신
  2) student/profile.md   — 취약 포인트·강점 누적

/done [과목] [메모] 호출이 정석. 호출 안 하고 다음 작업으로 넘어가지 말 것.
MSG
fi

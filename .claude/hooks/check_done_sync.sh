#!/usr/bin/env bash
# Stop hook — /done 일관성·최신성 가드.
#
# 검사 대상(원자적 배치):
#   · outputs/daily/*-done.md  각각이 outputs/learning-log.md 에 한 줄로 기록됐는가
#   · outputs/progress.md / student/profile.md 의 "마지막 업데이트" 날짜가
#     가장 최신 done 파일 날짜 이상인가
# 어긋나면 decision:block 으로 모델에 보강을 요구한다.
# 무한 루프 방지: stop_hook_active 이면 더 막지 않는다.
# 어떤 예외에도 사용자 흐름을 가두지 않도록 항상 exit 0.

INPUT=$(cat 2>/dev/null || true)

# 1) stop-hook 재진입이면 다시 막지 않음 (무한 루프 방지)
if printf '%s' "$INPUT" | grep -Eq '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi

# 리포지토리 루트 = 이 스크립트의 ../../
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." 2>/dev/null && pwd)"
[ -z "$ROOT" ] && exit 0

DAILY="$ROOT/outputs/daily"
LOG="$ROOT/outputs/learning-log.md"
PROG="$ROOT/outputs/progress.md"
PROF="$ROOT/student/profile.md"

# done 파일이 없으면 검사 대상 없음
shopt -s nullglob
DONE_FILES=("$DAILY"/*-done.md)
shopt -u nullglob
[ ${#DONE_FILES[@]} -eq 0 ] && exit 0

MISSING=""
NEWEST="0000-00-00"

for f in "${DONE_FILES[@]}"; do
  base="$(basename "$f")"
  # 파일명: YYYY-MM-DD-{과목}-done.md
  date="$(printf '%s' "$base" | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}')"
  subj="$(printf '%s' "$base" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}-(.+)-done\.md$/\1/')"
  [ -z "$date" ] && continue
  [[ "$date" > "$NEWEST" ]] && NEWEST="$date"
  # learning-log 에 (날짜 + 과목) 동시 포함 줄이 한 개라도 있는가
  if [ ! -f "$LOG" ] || ! grep -F "$date" "$LOG" 2>/dev/null | grep -qF "$subj"; then
    MISSING="$MISSING ${date}-${subj} /"
  fi
done

# "마지막 업데이트" 첫 줄에서 YYYY-MM-DD 추출
last_upd() {
  [ -f "$1" ] || { echo "0000-00-00"; return; }
  local d
  d="$(grep -m1 '마지막 업데이트' "$1" 2>/dev/null | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -n1)"
  [ -z "$d" ] && d="0000-00-00"
  echo "$d"
}
PROG_D="$(last_upd "$PROG")"
PROF_D="$(last_upd "$PROF")"

STALE=""
[[ "$PROG_D" < "$NEWEST" ]] && STALE="${STALE} outputs/progress.md(마지막업데이트 ${PROG_D} < ${NEWEST})"
[[ "$PROF_D" < "$NEWEST" ]] && STALE="${STALE} student/profile.md(마지막업데이트 ${PROF_D} < ${NEWEST})"

if [ -n "$MISSING" ] || [ -n "$STALE" ]; then
  R="[/done 동기화 미완료] "
  [ -n "$MISSING" ] && R="${R}learning-log.md 누락:${MISSING}. "
  [ -n "$STALE" ] && R="${R}최신성 미반영:${STALE}. "
  R="${R}/done 배치를 끝까지 마치세요 — ① outputs/progress.md(세션로그·누적복습 트래커) ② student/profile.md(취약·강점) ③ outputs/learning-log.md(맨 위 한 줄, git-graph 형식) ④ 해당 daily 파일을 -done.md 로 리네임. 넷이 한 묶음으로 동시에 최신화돼야 합니다."
  # JSON 안전: reason 안에 큰따옴표/역슬래시/개행 없음
  printf '{"decision":"block","reason":"%s"}\n' "$R"
  exit 0
fi

exit 0

과목별 다주차 커리큘럼을 작성하거나 갱신한다.

## 사용법
```
/plan 수학          # outputs/curriculum/math.md 생성/갱신
/plan 국어          # outputs/curriculum/korean.md
/plan 영어          # outputs/curriculum/english.md
/plan enrichment    # outputs/curriculum/enrichment.md (주제 풀)
/plan               # 어떤 과목 커리큘럼을 짤지 묻고 진행
```

## 실행 루틴

1. **읽기**:
   - `student/profile.md`
   - `outputs/progress.md`
   - `data/academy_research.md`
   - 직전 버전의 `outputs/curriculum/{과목}.md` (갱신 시)
2. **`curriculum-planner` subagent 호출**
   - 8~12주 단위 단원 시퀀스 생성
   - 학교 진도 sync, 학원 패턴 참고
3. **출력**: `outputs/curriculum/{과목}.md`
4. **갱신 시 변경 로그**: 파일 하단 "조정 기록" 표에 일자·변경·이유 추가
5. **마무리 메시지**:
   ```
   커리큘럼 [과목] 생성 완료. 첫 단원: [단원명].
   /today {과목} 으로 첫 세션 시작 가능합니다.
   ```

## 호출 시 주의
- 너무 멀리 짜지 않음 (8~12주). 먼저 "초기 8주 + 2주마다 미세 조정" 권장.
- 학교 진도 정보가 부족하면 사용자에게 "이번 학기 학교에서 다루는 단원이 어디까지인가요?" 한 번 묻기.

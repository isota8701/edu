# 자동화 교육 콘텐츠 생성 시스템 스펙 (최적화 버전)

## 1. 핵심 목표
- 초등학생 맞춤형 교육 콘텐츠 자동 생성
- 부모(사용자)가 효과적으로 가르칠 수 있도록 코칭
- 레벨 테스트 최소화 + 커리큘럼 중심 학습
- 학습 진행 상황을 지속적으로 추적 및 반영

---

## 2. 핵심 설계 철학

### 2.1 레벨 테스트 최적화
- 초기 1회 수행 (Cold Start)
- 이후:
  - 단원 종료 시 평가
  - 필요 시만 adaptive 테스트 수행
- 목적:
  → 커리큘럼 보정 (Correction), 과도한 테스트 방지

---

### 2.2 사용자 중심 Prompt 기반 시작

사용자 입력 예시:
> "아이가 받아내림 뺄셈을 헷갈려함. 머리셈, 세로셈으로 가르친 이력 있음"

이 입력을 기반으로:
- Student Model 초기화
- Curriculum 생성
- Weakness 기반 학습 시작

---

### 2.3 Progress Tracking 중심 구조

레벨 테스트 대신 핵심:

👉 Progress Tracker Agent

기능:
- 학습 시작 / 종료 기록
- 현재 진도 추적
- 다음 학습 자동 추천

---

## 3. 시스템 아키텍처

[User Prompt]
 → Student Model Init
 → Curriculum Agent
 → Learning Session

[학습 중]
 → Progress Tracker Agent (핵심)
 → Subject Agents
 → Teaching Guide

[중간]
 → Unit Test
 → Curriculum Correction

---

## 4. 주요 에이전트

### 4.1 Progress Tracker Agent (핵심)

출력 파일:
`progress.md`

내용:
- 현재 학습 위치
- 완료 단원
- 다음 학습
- 취약 포인트

---

### 4.2 Curriculum Agent

입력:
- 초기 레벨 or 사용자 설명

출력:
- 주간 계획
- 단원 순서

---

### 4.3 Level Test Agent (최소화)

사용 시점:
- 초기
- 단원 종료

---

### 4.4 Subject Agents

#### 수학
- 연산 / 개념
- 실수 패턴 교정

#### 국어
- 독해 / 어휘

#### 영어
- 파닉스 / 문장

#### 과학
- 개념 + 관찰

#### 사회/국사
- 흐름 이해

#### 인문학
- 사고력 질문

---

### 4.5 Teaching Guide Agent

- 부모 설명 스크립트
- 유도 질문 생성

---

### 4.6 Academy Data Collector

데이터 저장 위치:
```
/data/academy/
  ├── gangnam/
  ├── seocho/
  ├── mokdong/
```

---

### 4.7 Document Converter

- PDF → JSON 변환
- 문제 구조화

---

## 5. 데이터 흐름

외부 데이터:
→ /data/academy 저장

사용자 입력:
→ Student Model

→ Curriculum 생성

→ 학습 진행

→ Progress.md 지속 업데이트

→ 필요 시 테스트

→ 커리큘럼 수정

---

## 6. 출력 구조

### 6.1 daily.md
- 오늘 학습

### 6.2 progress.md
- 진도 관리

### 6.3 curriculum.md
- 전체 계획

---

## 7. 디렉토리 구조

```
project/
 ├── data/
 │   └── academy/
 ├── agents/
 ├── skills/
 ├── outputs/
 │   ├── progress.md
 │   ├── curriculum.md
 │   └── daily.md
```

---

## 8. 핵심 요약

이 시스템은:

👉 "레벨 테스트 기반 시스템"이 아니라  
👉 "커리큘럼 + 진도 추적 기반 학습 시스템"

이다.

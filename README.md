# 한국투자 파이썬 경진대회 프로젝트 프론트엔드

이 프로젝트는 금융 서비스 모니터링 및 관리를 위한 한국투자 파이썬 경진대회 프로젝트 참가용 프로젝트의 프론트엔드 부분입니다.

## 프로젝트 개요

이 프로젝트는 실시간 거래 분석, 오류탐지, 탐지 규칙 설정 등 다양한 기능을 제공하여 금융 거래의 안전성과 효율성을 높이는 것을 목표로 합니다.

## 주요 기능

1. 실시간 거래 분석

   - 거래량, 분당 거래량, 오류율, 평균 응답 시간 등의 실시간 통계 제공
   - D3.js와 ECharts를 활용한 실시간 거래 시각화
   - 오류 및 이상 거래 탐지 및 알림 기능
2. 규칙 설정 및 관리

   - 거래 모니터링을 위한 규칙 생성 및 편집
   - 다양한 조건 설정 (거래량, 오류율, 응답시간, 반복수행 등)
   - 규칙 활성화/비활성화 기능
3. 사용자 관리

   - 사용자 등록, 수정 기능
4. 보안 기능

   - 로그인 및 인증 시스템
   - 접근 토큰 및 갱신 토큰 관리
5. 알람 관리

   - 규칙 기반 알람 생성
   - 알람 목록 조회 및 관리
6. API 목록 및 관리

   - 다양한 API 엔드포인트 정보 제공
   - API 호출 테스트 기능
   - cURL 명령어 자동 생성
   - 응답 데이터 시각화 및 포맷팅

## 기술 스택

### Frontend

- Vue.js : 프론트엔드 프레임워크
- Vuetify : UI 컴포넌트 라이브러리
- D3.js: 데이터 시각화
- ECharts: 고급 차트 및 그래프 생성

### Backend

- Spring Cloud Gateway
- Spring Security
- Spring Data JPA

## 프로젝트 구조

- `index.html` : 이 파일은 전체 애플리케이션의 구조와 동작을 결정하는 중요한 설정들을 포함하고 있습니다. 프로젝트 진입점으로, 주요 스크립트와 스타일시트를 로드합니다. Vue.js 애플리케이션을 초기화하고 라우팅 설정, Vuetify 테마 구성, 전역 믹스인 등을 포함합니다. 주요 특징은 다음과 같습니다:

  - Vue.js, Vuetify, Vue Router 등 핵심 라이브러리 초기화
  - 라우팅 구성: 각 페이지 컴포넌트에 대한 경로 및 메타 정보 정의
  - Vuetify 테마 설정: 라이트/다크 모드 및 커스텀 색상 테마 정의
  - 전역 설정: API 엔드포인트 URL, 버튼 색상 등 전역 변수 설정
  - Axios를 이용한 HTTP 요청 헬퍼 함수 정의
- `vue/App.vue`: 애플리케이션의 메인 컴포넌트로, 전체 레이아웃과 네비게이션을 관리합니다. 다크/라이트 테마 전환, 사용자 인증 상태 관리, 알림 시스템 등 애플리케이션 전반의 기능을 제어합니다.
- `vue/page/`: 주요 페이지 컴포넌트 포함

  - `p0-login.vue`: 로그인 페이지
  - `p1-live-transaction-analytics.vue`: 실시간 서비스 모니터링 페이지
  - `p8-rule-detected-list.vue`: 서비스 이상 감지 목록 페이지
  - `p3-rule-configuration.vue`: 이상 징후 감지 정책 설정 페이지
  - `p2-incident-dashboard.vue`: 서비스 내역 페이지
  - `p7-tx-history.vue`: 전문 상세 내역 페이지
  - `p9-service-manager.vue`: 서비스 관리 페이지
  - `p6-user-management.vue`: 사용자 관리 페이지
  - `p5-api-list.vue`: API 목록 및 테스트 페이지
  - `p20-readme-viewer.vue`: 프로젝트 설명 페이지
- `vue/page/test/`: 서비스 테스트 센터 페이지

  - `p11-mobile-banking-transfer.vue`: 모바일 뱅킹 간편이체 페이지
  - `p12-mobile-banking-loan.vue`: 모바일 뱅킹 대출 페이지
  - `p13-toss-loan.vue`: 토스 비교금리 페이지

## 프론트 엔드 개발 및 배포 가이드

### 1. 개발 환경 설정

1. 프로젝트 클론:

   ```
   git clone https://gitlab.com/hj.na/ki-project-fe
   ```

   (Git은 코드 버전 관리 시스템입니다.)
2. 웹 환경 구성:

   - Node.js 설치: https://nodejs.org/ 에서 다운로드 및 설치
     (Node.js는 자바스크립트 실행 환경입니다.)
   - live-server 설치:
     ```
     npm install -g live-server
     ```

     (npm은 Node.js의 패키지 관리자, live-server는 로컬 개발 서버입니다.)

### 2. 프로젝트 실행

1. 프로젝트 폴더로 이동
2. 다음 명령어로 서버 실행:
   ```
   live-server --port=5500
   ```
3. 브라우저에서 `http://localhost:5500` 접속




### 3. 배포 프로세스

- GitLab에 코드를 push하면 자동으로 Netlify에 배포됩니다.
- 배포 사이트: https://ki-sqm.netlify.app/

### 4. 테스트 접속

- 데모 계정:
  - ID: demo_user
  - PW: demo_password
    (실제 계정 정보는 보안상의 이유로 별도 전달)

### 5. 문제 해결

- 오류 1: Node.js 버전 불일치
  해결: Node.js 최신 LTS 버전으로 업데이트
- 오류 2: live-server 실행 실패
  해결: 관리자 권한으로 명령 프롬프트 실행 후 재시도

&nbsp;
&nbsp;

## 팀 소개 및 역할

- 프로젝트 기획 및 문서 작성 : IT전략기획팀 한경록
- 화면 기획 및 프론트엔드 개발 : IT개발팀 나형주
- 서버 개발 및 데이터 모델링 : IT전략기획팀 이민호

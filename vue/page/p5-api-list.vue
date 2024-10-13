<template>
    <v-container fluid>
        <v-card>
            <v-card-text>
                <v-select v-model="selectedApi" :items="apiList" label="API 선택" @change="showApiDetails"></v-select>

                <v-card v-if="selectedApiDetails" class="mt-0 ">
                    <v-card-title class="text-h6 pt-0 pb-0">{{ selectedApiDetails.name }}</v-card-title>
                    <v-card-text>
                        <v-simple-table>
                            <template v-slot:default>
                                <tbody>
                                    <tr>
                                        <td>엔드포인트</td>
                                        <td>
                                            <!--code>{{ selectedApiDetails.endpoint }}</code-->
                                            <v-text-field v-model="selectedApiDetails.endpoint" dense
                                                hide-details="auto"></v-text-field>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>메소드</td>
                                        <td><code>{{ selectedApiDetails.method }}</code></td>
                                    </tr>
                                    <tr>
                                        <td>설명</td>
                                        <td>{{ selectedApiDetails.description }}</td>
                                    </tr>
                                </tbody>
                            </template>
                        </v-simple-table>

                        <v-subheader class="mt-2">요청 파라미터</v-subheader>
                        <v-form v-if="selectedApiDetails.parameters.length" ref="form" v-model="isFormValid">
                            <v-simple-table>
                                <template v-slot:default>
                                    <thead>
                                        <tr>
                                            <th class="text-left">파라미터</th>
                                            <th class="text-left">타입</th>
                                            <th class="text-left">필수</th>
                                            <th class="text-left">설명</th>
                                            <th class="text-left">입력</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="param in selectedApiDetails.parameters" :key="param.name">
                                            <td><code>{{ param.name }}</code></td>
                                            <td>{{ param.type }}</td>
                                            <td>{{ param.required ? '예' : '아니오' }}</td>
                                            <td>{{ param.description }}</td>
                                            <td>
                                                <v-text-field :value="paramValues[param.name]"
                                                    @input="updateParamValue(param.name, $event)" :label="param.name"
                                                    :rules="[(v) => !param.required || !!v || '이 필드는 필수입니다.']" dense
                                                    hide-details="auto"></v-text-field>
                                            </td>
                                        </tr>
                                    </tbody>
                                </template>
                            </v-simple-table>
                        </v-form>

                        <v-subheader class="mt-2">요청 형식</v-subheader>
                        <v-card outlined>
                            <v-card-text class="font-weight-bold"
                                v-html="curlExample"></v-card-text><!--eslint-disable-line-->
                        </v-card>
                        <v-btn :color="$config.color_btn" @click="callApi" class="mt-2" small dense>API 호출</v-btn>

                        <v-subheader class="mt-2">응답 결과</v-subheader>
                        <v-card outlined v-if="apiResponse">
                            <v-card-text class="font-weight-bold"
                                v-html="apiResponse"></v-card-text><!--eslint-disable-line-->
                        </v-card>

                        <v-row>
                            <v-col cols="12" md="6">
                                <!--v-subheader class="mt-4">응답 형식</v-subheader>
                                <v-card outlined>
                                    <v-card-text>
                                        <pre><code>{{ selectedApiDetails.responseExample }}</code></pre>
                                    </v-card-text>
                                </v-card-->
                                <v-subheader class="mt-4">응답 형식</v-subheader>
                                <v-simple-table v-if="selectedApiDetails.responseFormat?.length">
                                    <template v-slot:default>
                                        <thead>
                                            <tr>
                                                <th class="text-left">필드</th>
                                                <th class="text-left">타입</th>
                                                <th class="text-left">필수</th>
                                                <th class="text-left">설명</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr v-for="param in selectedApiDetails.responseFormat" :key="param.name">
                                                <td><code>{{ param.name }}</code></td>
                                                <td>{{ param.type }}</td>
                                                <td>{{ param.required ? '예' : '아니오' }}</td>
                                                <td>{{ param.description }}</td>
                                            </tr>
                                        </tbody>
                                    </template>
                                </v-simple-table>
                            </v-col>
                            <v-col cols="12" md="6">
                                <v-subheader class="mt-2">응답 샘플</v-subheader>
                                <v-card outlined>
                                    <v-card-text class="font-weight-bold"
                                        v-html="selectedApiDetails.responseSampleHtml"></v-card-text><!--eslint-disable-line-->
                                </v-card>
                            </v-col>
                        </v-row>

                    </v-card-text>
                </v-card>
            </v-card-text>
        </v-card>
    </v-container>
</template>

<script>



const comp = module.exports = {
    data() {
        return {
            selectedApiDetails: null,
            apiResponse: null,
            curlExample: '',
            paramValues: {},
            isFormValid: true,
            selectedApi: 'getRuleDetections',
            apiList: [
                { text: '감지 목록 조회(예정)', value: 'getRuleDetections' },
                { text: '서비스 지표 목록(완료)', value: 'getMetric' },
                { text: '서비스 거래 목록 조회(완료)', value: 'getIncidents' },
                { text: '서비스 내역 조회(완료)', value: 'getGuidData' },
                { text: '룰셋 저장(완료)', value: 'saveRule' },
                { text: '간편 이체(미완-1)', value: 'transfer' },
                { text: '대출 신청(미완-2)', value: 'applyLoan' },
                { text: '한도 조회(미완-3)', value: 'checkLoanLimit' },
                { text: '알람 목록 조회(미완)', value: 'getAlarms' },
                // { text: '실시간 서비스 분석(미완)', value: 'getLiveTransactions' },

                { text: '룰셋 조회(완료)', value: 'getRules' },
                { text: '거래 데이터 조회(완료)', value: 'getTxData' },
                { text: '로그인(완료)', value: 'loginSignin' },
                { text: '로그인 상태 체크(완료)', value: 'loginCheck' },
                { text: '로그아웃(완료)', value: 'logout' },
                { text: '사용자 등록(완료)', value: 'loginSignup' },
                { text: '사용자 목록 조회(완료)', value: 'getUserList' },
            ],
            apiDetails: {
                getIncidents: {
                    name: '서비스 거래 목록 조회',
                    endpoint: '/api/incidents',
                    method: 'POST',
                    description: '서비스 거래 목록을 조회합니다.',
                    parameters: [
                        { name: 'startDttm', type: 'String', required: true, default: this.$util.getDate() + this.$util.getTime(-1, 0), description: '조회 시작 날짜 (yyyymmddhh24miss 형식)' },
                        { name: 'endDttm', type: 'String', required: true, default: this.$util.getDate() + this.$util.getTime(0, 0), description: '조회 종료 날짜 (yyyymmddhh24miss 형식)' },
                        { name: 'status', type: 'String', required: false, default: '', description: '인시던트 상태 (예: "오류,정상")' }
                    ],
                    responseSampleHtml: '',
                    responseSample: {
                        incidents: [
                            {
                                id: 'INC-001',
                                title: '시스템 다운',
                                description: '결제 시스템 10분간 다운',
                                status: 'closed',
                                createdAt: '20230501143000',
                                updatedAt: '20230501145000'
                            }
                        ],
                        totalCount: 1
                    },
                    responseFormat: [
                        { name: 'incidents', type: 'Array', required: true, description: '인시던트 목록' },
                        { name: 'incidents[].id', type: 'String', required: true, description: '인시던트 ID' },
                        { name: 'incidents[].title', type: 'String', required: true, description: '인시던트 제목' },
                        { name: 'incidents[].description', type: 'String', required: false, description: '인시던트 설명' },
                        { name: 'incidents[].status', type: 'String', required: true, description: '인시던트 상태' },
                        { name: 'incidents[].createdAt', type: 'String', required: true, description: '생성 시간 (yyyymmddhh24miss 형식)' },
                        { name: 'incidents[].updatedAt', type: 'String', required: true, description: '수정 시간 (yyyymmddhh24miss 형식)' },
                        { name: 'totalCount', type: 'Number', required: true, description: '전체 인시던트 수' }
                    ],
                },
                getLiveTransactions: {
                    name: '실시간 거래 분석',
                    endpoint: '/api/live-transactions',
                    method: 'POST',
                    description: '실시간 거래 데이터를 분석하여 제공합니다.',
                    parameters: [
                        { name: 'duration', type: 'Number', required: false, default: 5, description: '조회 기간 (분 단위, 기본값: 5)' }
                    ],

                    responseSampleHtml: '',
                    responseSample: {
                        timestamp: "20230515143000",
                        transactionData: {
                            normal: 187,
                            anomaly: 13
                        },
                        anomalyTransactions: [
                            {
                                timestamp: "20230515142945",
                                transactionId: "TX123456",
                                type: "이체",
                                amount: 1000000,
                                status: "오류"
                            },
                            {
                                timestamp: "20230515142930",
                                transactionId: "TX123457",
                                type: "이체",
                                amount: 1000000,
                                status: "의심"
                            }
                        ]
                    },
                    responseFormat: [
                        { name: 'timestamp', type: 'String', required: true, description: '데이터 생성 시간 (yyyymmddhh24miss 형식)' },
                        { name: 'transactionData', type: 'Object', required: true, description: '거래 데이터 요약' },
                        { name: 'transactionData.normal', type: 'Number', required: true, description: '정상 거래 수' },
                        { name: 'transactionData.anomaly', type: 'Number', required: true, description: '이상 거래 수' },
                        { name: 'anomalyTransactions', type: 'Array', required: true, description: '이상 거래 목록' },
                        { name: 'anomalyTransactions[].timestamp', type: 'String', required: true, description: '거래 시간 (yyyymmddhh24miss 형식)' },
                        { name: 'anomalyTransactions[].transactionId', type: 'String', required: true, description: '거래 ID' },
                        { name: 'anomalyTransactions[].type', type: 'String', required: true, description: '거래 유형' },
                        { name: 'anomalyTransactions[].amount', type: 'Number', required: true, description: '거래 금액' },
                        { name: 'anomalyTransactions[].status', type: 'String', required: true, description: '거래 상태' }
                    ],
                },
                getRules: {
                    name: '서비스 모니터링 정책 설정',
                    endpoint: '/api/rule-list',
                    method: 'POST',
                    description: '설정된 룰셋 목록을 조회합니다.',
                    parameters: [],
                    responseSampleHtml: '',
                    responseSample: {},
                    responseFormat: [
                        { name: 'header', type: 'Object', required: true, description: '응답 헤더' },
                        { name: 'header.resultCode', type: 'String', required: true, description: '결과 코드' },
                        { name: 'header.resultMessage', type: 'String', required: true, description: '결과 메시지' },
                        { name: 'body', type: 'Object', required: true, description: '응답 본문' },
                        { name: 'body.rules', type: 'Array', required: true, description: '룰셋 목록' },
                        { name: 'body.rules[].id', type: 'String', required: true, description: '룰 ID' },
                        { name: 'body.rules[].name', type: 'String', required: true, description: '룰 이름' },
                        { name: 'body.rules[].condition', type: 'Object', required: true, description: '룰 조건' },
                        { name: 'body.rules[].condition.type', type: 'String', required: true, description: '룰 타입' },
                        { name: 'body.rules[].condition.direction', type: 'String', required: true, description: '방향' },
                        { name: 'body.rules[].condition.duration', type: 'String', required: true, description: '기간' },
                        { name: 'body.rules[].condition.unit', type: 'String', required: true, description: '단위' },
                        { name: 'body.rules[].condition.threshold', type: 'Number', required: true, description: '임계값' },
                        { name: 'body.rules[].action', type: 'String', required: true, description: '룰 액션' }
                    ],
                },
                saveRule: {
                    name: '룰셋 저장',
                    endpoint: '/api/rule-save',
                    method: 'POST',
                    description: '새로운 룰을 저장하거나 기존 룰을 수정합니다.',
                    parameters: [
                        { name: 'id', type: 'String', required: false, default: 'RULE-001', description: '룰 ID (수정 시 필요)' },
                        { name: 'name', type: 'String', required: true, default: '1시간 무거래 탐지', description: '룰 이름' },
                        { name: 'condition', type: 'Object', required: true, default: {}, description: '룰 조건' },
                        { name: 'condition.type', type: 'String', required: true, default: '거래량', description: '룰 타입 (예: 거래량, 오류율, 응답시간, 반복수행)' },
                        { name: 'condition.direction', type: 'String', required: true, default: '무거래', description: '방향 (예: 증가, 감소, 무거래)' },
                        { name: 'condition.duration', type: 'String', required: true, default: '1', description: '기간' },
                        { name: 'condition.unit', type: 'String', required: true, default: '시간', description: '단위 (예: 분, 시간, 일, 주, 월)' },
                        { name: 'condition.threshold', type: 'Number', required: true, default: '0', description: '임계값' },
                        { name: 'action', type: 'String', required: true, default: '시스템 관리자에게 알림 발송', description: '룰 액션' },
                        { name: 'enabled', type: 'Boolean', required: true, default: true, description: '사용 여부' }
                    ],
                    responseSampleHtml: '',
                    responseSample: {
                        header: {
                            resultCode: "0000",
                            resultMessage: "룰 저장 성공"
                        },
                        body: {
                            id: 'RULE-006',
                            name: '갑작스러운 거래량 증가',
                            condition: {
                                type: '거래량',
                                direction: '증가',
                                duration: '10',
                                unit: '분',
                                threshold: 200,
                            },
                            action: '자동 스케일 아웃 트리거 및 마케팅팀에 확인',
                            enabled: true
                        }
                    },
                    responseFormat: [
                        { name: 'header', type: 'Object', required: true, description: '응답 헤더' },
                        { name: 'header.resultCode', type: 'String', required: true, description: '결과 코드' },
                        { name: 'header.resultMessage', type: 'String', required: true, description: '결과 메시지' },
                        { name: 'body', type: 'Object', required: true, description: '응답 본문' },
                        { name: 'body.id', type: 'String', required: true, description: '저장된 룰 ID' },
                        { name: 'body.name', type: 'String', required: true, description: '룰 이름' },
                        { name: 'body.condition', type: 'Object', required: true, description: '룰 조건' },
                        { name: 'body.condition.type', type: 'String', required: true, description: '룰 타입' },
                        { name: 'body.condition.direction', type: 'String', required: true, description: '방향' },
                        { name: 'body.condition.duration', type: 'String', required: true, description: '기간' },
                        { name: 'body.condition.unit', type: 'String', required: true, description: '단위' },
                        { name: 'body.condition.threshold', type: 'Number', required: true, description: '임계값' },
                        { name: 'body.action', type: 'String', required: true, description: '룰 액션' },
                        { name: 'body.enabled', type: 'Boolean', required: true, description: '사용 여부' }
                    ],
                },
                applyLoan: {
                    name: '대출 신청',
                    endpoint: '/api/loan-apply',
                    method: 'POST',
                    description: '대출을 신청합니다.',
                    parameters: [
                        { name: 'name', type: 'String', required: true, default: '홍길동', description: '신청자 이름' },
                        { name: 'amount', type: 'Number', required: true, default: 1000000, description: '대출 금액' },
                        { name: 'period', type: 'Number', required: true, default: 12, description: '대출 기간 (개월)' }
                    ],
                    responseSampleHtml: '',
                    responseSample: {
                        applicationId: 'LOAN-001',
                        status: '승인',
                        message: '대출 신청이 승인되었습니다.'
                    },
                    responseFormat: [
                        { name: 'applicationId', type: 'String', required: true, description: '대출 신청 ID' },
                        { name: 'status', type: 'String', required: true, description: '신청 상태 (예: 승인, 거절, 검토 중)' },
                        { name: 'message', type: 'String', required: false, description: '상태에 대한 추가 설명' },
                        { name: 'approvedAmount', type: 'Number', required: false, description: '승인된 대출 금액' },
                        { name: 'interestRate', type: 'Number', required: false, description: '이자율 (%)' },
                        { name: 'applicationDate', type: 'String', required: true, description: '신청 일시 (yyyymmddhh24miss 형식)' }
                    ],
                },
                checkLoanLimit: {
                    name: '한도 조회',
                    endpoint: '/api/loan-limit',
                    method: 'POST',
                    description: '대출 가능 한도를 조회합니다.',
                    parameters: [
                        { name: 'customerId', type: 'String', required: true, default: '123456', description: '고객 ID' }
                    ],

                    responseSampleHtml: '',
                    responseSample: {
                        customerId: '123456',
                        loanLimit: 50000000,
                        creditScore: 850
                    },
                    responseFormat: [
                        { name: 'customerId', type: 'String', required: true, description: '고객 ID' },
                        { name: 'loanLimit', type: 'Number', required: true, description: '대출 가능 한도' },
                        { name: 'creditScore', type: 'Number', required: true, description: '신용 점수' },
                        { name: 'lastUpdateDate', type: 'String', required: true, description: '마지막 업데이트 일시 (yyyymmddhh24miss 형식)' },
                        { name: 'factors', type: 'Array', required: false, description: '한도 결정 요인 목록' },
                        { name: 'factors[].name', type: 'String', required: true, description: '요인 이름' },
                        { name: 'factors[].impact', type: 'String', required: true, description: '영향도 (예: 높음, 중간, 낮음)' }
                    ],
                },
                loginCheck: {
                    name: '로그인 체크',
                    endpoint: '/api/login-check',
                    method: 'POST',
                    description: '사용자의 로그인 상태를 확인합니다.',
                    parameters: [
                        { name: 'accessToken', type: 'String', required: true, default: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c', description: '사용자 인증 토큰' },
                        { name: 'refreshToken', type: 'String', required: true, default: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c', description: '사용자 재발급 토큰' },
                    ],

                    responseSampleHtml: '',
                    responseSample: {
                        header: {
                            resultCode: "0000",
                            resultMessage: "로그인 상태입니다."
                        },
                        body: {
                            userId: "admin",
                            userName: "나형주1",
                            userType: "admin",
                            userStatus: "정상",
                            loginStatus: "로그인",
                            lastLoginDate: "2024-05-01 12:00:00",
                            expiredDate: "2024-05-01 13:00:00"
                        }
                    },
                    responseFormat: [
                        { name: 'header', type: 'Object', required: true, description: '응답 헤더' },
                        { name: 'header.resultCode', type: 'String', required: true, description: '결과 코드' },
                        { name: 'header.resultMessage', type: 'String', required: true, description: '결과 메시지' },
                        { name: 'body', type: 'Object', required: true, description: '응답 본문' },
                        { name: 'body.userId', type: 'String', required: true, description: '사용자 ID' },
                        { name: 'body.userName', type: 'String', required: true, description: '사용자 이름' },
                        { name: 'body.userType', type: 'String', required: true, description: '사용자 유형' },
                        { name: 'body.userStatus', type: 'String', required: true, description: '사용자 상태' },
                        { name: 'body.loginStatus', type: 'String', required: true, description: '로그인 상태' },
                        { name: 'body.lastLoginDate', type: 'String', required: true, description: '마지막 로그인 일시' },
                        { name: 'body.expiredDate', type: 'String', required: true, description: '만료 일시' }
                    ],
                },
                loginSignin: {
                    name: '로그인',
                    endpoint: '/api/login-signin',
                    method: 'POST',
                    description: '사용자 로그인을 처리합니다.',
                    parameters: [
                        { name: 'username', type: 'String', required: true, description: '사용자 아이디', default: 'admin' },
                        { name: 'password', type: 'String', required: true, description: '사용자 비밀번호', default: 'admin' }
                    ],
                    responseSampleHtml: '',
                    responseSample: '',
                    responseFormat: [
                        { name: 'header', type: 'Object', required: true, description: '응답 헤더' },
                        { name: 'header.resultCode', type: 'String', required: true, description: '결과 코드' },
                        { name: 'header.resultMessage', type: 'String', required: true, description: '결과 메시지' },
                        { name: 'body', type: 'Object', required: true, description: '응답 본문' },
                        { name: 'body.userId', type: 'String', required: true, description: '사용자 ID' },
                        { name: 'body.userName', type: 'String', required: true, description: '사용자 이름' },
                        { name: 'body.userType', type: 'String', required: true, description: '사용자 유형' },
                        { name: 'body.userStatus', type: 'String', required: true, description: '사용자 상태' },
                        { name: 'body.loginStatus', type: 'String', required: true, description: '로그인 상태' },
                        { name: 'body.lastLoginDate', type: 'String', required: true, description: '마지막 로그인 일시' },
                        { name: 'body.expiredDate', type: 'String', required: true, description: '세션 만료 일시' },
                        { name: 'body.accessToken', type: 'String', required: true, description: '액세스 토큰' },
                        { name: 'body.refreshToken', type: 'String', required: true, description: '리프레시 토큰' }
                    ],
                },
                loginSignup: {
                    name: '사용자 등록',
                    endpoint: '/api/login-signup',
                    method: 'POST',
                    description: '사용자를 등록합니다.',
                    parameters: [
                        { name: 'username', type: 'String', required: true, default: 'admin', description: '사용자 ID' },
                        { name: 'password', type: 'String', required: true, default: 'admin', description: '사용자 비밀번호' },
                        { name: 'name', type: 'String', required: true, default: '나형주', description: '사용자 이름' },
                    ],
                    responseSampleHtml: '',
                    responseSample: {
                        header: {
                            resultCode: "0000",
                            resultMessage: "사용자 등록 성공"
                        },
                        body: {
                            userId: "newuser",
                            userName: "새로운 사용자",
                            userType: "user",
                            userStatus: "정상",
                            loginStatus: "로그인",
                            lastLoginDate: "2024-05-01 12:00:00",
                            expiredDate: "2024-05-01 13:00:00"
                        }
                    },
                },
                logout: {
                    name: '로그아웃',
                    endpoint: '/api/logout',
                    method: 'POST',
                    description: '사용자 로그아웃을 처리합니다.',
                    parameters: [],
                    responseSampleHtml: '',
                    responseSample: {
                        header: {
                            resultCode: "0000",
                            resultMessage: "로그아웃 성공"
                        }
                    },
                    responseFormat: [
                        { name: 'header', type: 'Object', required: true, description: '응답 헤더' },
                        { name: 'header.resultCode', type: 'String', required: true, description: '결과 코드' },
                        { name: 'header.resultMessage', type: 'String', required: true, description: '결과 메시지' }
                    ],
                },

                getUserList: {
                    name: '사용자 목록 조회',
                    endpoint: '/api/user-list',
                    method: 'GET',
                    description: '등록된 사용자 목록을 조회합니다.',
                    parameters: [],
                    responseSampleHtml: '',
                    responseSample: {
                        header: {
                            resultCode: "0000",
                            resultMessage: "사용자 목록 조회 성공"
                        },
                        body: {
                            users: [
                                {
                                    userId: "admin",
                                    userName: "나형주1",
                                    userType: "admin",
                                    userStatus: "정상",
                                    loginStatus: "로그인",
                                    lastLoginDate: "2024-05-01 12:00:00"
                                }
                            ]
                        }
                    },
                    responseFormat: [
                        { name: 'header', type: 'Object', required: true, description: '응답 헤더' },
                        { name: 'header.resultCode', type: 'String', required: true, description: '결과 코드' },
                        { name: 'header.resultMessage', type: 'String', required: true, description: '결과 메시지' },
                        { name: 'body', type: 'Object', required: true, description: '응답 본문' },
                        { name: 'body.users', type: 'Array', required: true, description: '사용자 목록' },
                        { name: 'body.users[].userId', type: 'String', required: true, description: '사용자 ID' },
                        { name: 'body.users[].userName', type: 'String', required: true, description: '사용자 이름' },
                        { name: 'body.users[].userType', type: 'String', required: true, description: '사용자 유형 (admin, user)' },
                        { name: 'body.users[].userStatus', type: 'String', required: true, description: '사용자 상태 (정상, 휴면, 잠금)' },
                        { name: 'body.users[].loginStatus', type: 'String', required: true, description: '로그인 상태' },
                        { name: 'body.users[].lastLoginDate', type: 'String', required: true, description: '마지막 로그인 일시' }
                    ],
                },
                transfer: {
                    name: '간편 이체',
                    endpoint: '/api/transfer',
                    method: 'POST',
                    description: '간편 이체를 처리합니다.',
                    requestHeader: true,
                    parameters: [
                        { name: 'sender', type: 'String', required: true, default: '김남구', description: '보내는 사람' },
                        { name: 'receiver', type: 'String', required: true, default: '이민호', description: '받는 사람' },
                        { name: 'amount', type: 'String', required: true, default: '100000000', description: '이체 금액' },
                        { name: 'date', type: 'String', required: true, default: this.$util.formatDate(new Date()), description: '이체 날짜 (YYYY-MM-DD 형식)' },
                        { name: 'txSecond', type: 'String', required: true, default: '2', description: '처리 시간(초)' },
                        { name: 'txStatus', type: 'String', required: true, default: '처리완료', description: '처리 상태 (처리완료 또는 처리오류)' }
                    ],
                    responseSampleHtml: '',
                    responseSample: {
                        header: {
                            resultCode: "0000",
                            resultMessage: "간편 이체 성공"
                        }
                    },
                    responseFormat: [
                        { name: 'header', type: 'Object', required: true, description: '응답 헤더' },
                        { name: 'header.resultCode', type: 'String', required: true, description: '결과 코드' },
                        { name: 'header.resultMessage', type: 'String', required: true, description: '결과 메시지' }
                    ],
                },
                getTxData: {
                    name: '거래 데이터 조회',
                    endpoint: '/api/gettxdata',
                    method: 'POST',
                    description: '지정된 시간 범위 내의 거래 데이터 목록을 조회합니다.',
                    parameters: [
                        { name: 'startDttm', type: 'String', required: true, default: this.$util.getDateTime(new Date(Date.now() - 10000)), description: '조회 시작 일시 (YYYYMMDDHHmmss 형식)' },
                        { name: 'endDttm', type: 'String', required: true, default: this.$util.getDateTime(new Date()), description: '조회 종료 일시 (YYYYMMDDHHmmss 형식)' }
                    ],
                    responseSampleHtml: '',
                    responseSample: [
                        {
                            id: 228380,
                            guid: "df296924-b9c7-48ab-92e9-12a748f991d2",
                            tx_id: "uE4I9nfVJlkB",
                            if_id: "IF_00016",
                            prg_nm: "나형주5",
                            system_cd: "pmw",
                            tx_status: "타임아웃",
                            req_dt: "20241003",
                            req_tm: "221514",
                            req_dttm: "20241003221514",
                            res_dttm: "20241003221520",
                            res_cd: "T00",
                            res_msg: "T00",
                            tx_biz_id: "BIZ_00016",
                            req_json: "{\"req_dttm\":\"20241003221514\",\"IF_ID\":\"IF_00016\",\"res_dttm\":\"20241003221520\",\"prg_nm\":\"나형주5\"}",
                            res_json: "{\"tx_status\":\"타임아웃\",\"res_cd\":\"T00\"}",
                            elapsed: 0
                        }
                    ],
                    responseFormat: [
                        { name: 'id', type: 'Number', required: true, description: '거래 ID' },
                        { name: 'guid', type: 'String', required: true, description: '고유 식별자' },
                        { name: 'tx_id', type: 'String', required: true, description: '트랜잭션 ID' },
                        { name: 'if_id', type: 'String', required: true, description: '인터페이스 ID' },
                        { name: 'prg_nm', type: 'String', required: true, description: '프로그램 이름' },
                        { name: 'system_cd', type: 'String', required: true, description: '시스템 코드' },
                        { name: 'tx_status', type: 'String', required: true, description: '트랜잭션 상태' },
                        { name: 'req_dt', type: 'String', required: true, description: '요청 날짜' },
                        { name: 'req_tm', type: 'String', required: true, description: '요청 시간' },
                        { name: 'req_dttm', type: 'String', required: true, description: '요청 일시' },
                        { name: 'res_dttm', type: 'String', required: true, description: '응답 일시' },
                        { name: 'res_cd', type: 'String', required: true, description: '응답 코드' },
                        { name: 'res_msg', type: 'String', required: true, description: '응답 메시지' },
                        { name: 'tx_biz_id', type: 'String', required: true, description: '비즈니스 트랜잭션 ID' },
                        { name: 'req_json', type: 'String', required: true, description: '요청 JSON' },
                        { name: 'res_json', type: 'String', required: true, description: '응답 JSON' },
                        { name: 'elapsed', type: 'Number', required: true, description: '경과 시간 (밀리초)' }
                    ],
                },

                getAlarms: {
                    name: '알람 목록 조회',
                    endpoint: '/api/alarms',
                    method: 'GET',
                    description: '시스템 알람 목록을 조회합니다.',
                    parameters: [
                        { name: 'startDate', type: 'String', required: false, default: this.$util.getDate(-1), description: '조회 시작 날짜 (YYYY-MM-DD 형식)' },
                        { name: 'endDate', type: 'String', required: false, default: this.$util.getDate(), description: '조회 종료 날짜 (YYYY-MM-DD 형식)' },
                        { name: 'severity', type: 'String', required: false, default: '', description: '심각도 필터 (예: 심각, 경고, 정보)' },
                    ],
                    responseSampleHtml: '',
                    responseSample: {
                        header: {
                            resultCode: "0000",
                            resultMessage: "알람 목록 조회 성공"
                        },
                        body: {
                            alarms: [
                                {
                                    timestamp: "2023-05-10 14:30:00",
                                    system: "소비자금융시스템",
                                    severity: "심각",
                                    description: "대출 한도조회 오류",
                                },
                                {
                                    timestamp: "2023-05-10 15:15:00",
                                    system: "일반여신시스템",
                                    severity: "심각",
                                    description: "스크래핑 오류",
                                },
                                {
                                    timestamp: "2023-05-10 16:00:00",
                                    system: "모바일앱",
                                    severity: "심각",
                                    description: "1원 인증 오류",
                                },
                            ]
                        }
                    },
                    responseFormat: [
                        { name: 'header', type: 'Object', required: true, description: '응답 헤더' },
                        { name: 'header.resultCode', type: 'String', required: true, description: '결과 코드' },
                        { name: 'header.resultMessage', type: 'String', required: true, description: '결과 메시지' },
                        { name: 'body', type: 'Object', required: true, description: '응답 본문' },
                        { name: 'body.alarms', type: 'Array', required: true, description: '알람 목록' },
                        { name: 'body.alarms[].timestamp', type: 'String', required: true, description: '알람 발생 시간 (YYYY-MM-DD HH:mm:ss 형식)' },
                        { name: 'body.alarms[].system', type: 'String', required: true, description: '알람이 발생한 시스템' },
                        { name: 'body.alarms[].severity', type: 'String', required: true, description: '알람 심각도' },
                        { name: 'body.alarms[].description', type: 'String', required: true, description: '알람 설명' },
                    ],
                },
                getMetric: {
                    name: '매트릭스 데이터 조회',
                    endpoint: '/incident/getMetric',
                    method: 'GET',
                    description: '시스템의 매트릭스 데이터를 조회합니다.',
                    parameters: [],
                    responseSampleHtml: '',
                    responseSample: [
                        {
                            ifId: "IF_00001",
                            svcNm: "토스 가심사 요청",
                            errPer: 3.44,
                            errDiffPer: 7.84,
                            tps: 0.1697,
                            todayCnt: 611,
                            previousDayCnt: 94,
                            previousWeekCnt: 953
                        },
                        {
                            ifId: "IF_00002",
                            svcNm: "송금",
                            errPer: 4.03,
                            errDiffPer: 9.81,
                            tps: 0.1792,
                            todayCnt: 645,
                            previousDayCnt: 109,
                            previousWeekCnt: 978
                        }
                    ],
                    responseFormat: [
                        { name: 'ifId', type: 'String', required: true, description: '인터페이스 ID' },
                        { name: 'svcNm', type: 'String', required: true, description: '서비스 이름' },
                        { name: 'errPer', type: 'Number', required: true, description: '오류율 (%)' },
                        { name: 'errDiffPer', type: 'Number', required: true, description: '전일 대비 오류율 변화 (%)' },
                        { name: 'tps', type: 'Number', required: true, description: '초당 거래량 (TPS)' },
                        { name: 'todayCnt', type: 'Number', required: true, description: '금일 거래량' },
                        { name: 'previousDayCnt', type: 'Number', required: true, description: '전일 거래량' },
                        { name: 'previousWeekCnt', type: 'Number', required: true, description: '전주 거래량' }
                    ],
                },
                getGuidData: {
                    name: '서비스 내역 조회',
                    endpoint: '/getGuidData',
                    method: 'POST',
                    description: '특정 서비스에 대한 상세 거래 데이터를 조회합니다.',
                    parameters: [
                        { name: 'guid', type: 'String', required: true, description: '조회할 GUID', default: 'OQshG_gPNnZO' },
                    ],
                    responseSampleHtml: '',
                    responseSample: [
                        {
                            "id": 2874592,
                            "guid": "OQshG_gPNnZO",
                            "tx_id": "FxwqC2AwL0rL",
                            "if_id": "IF041",
                            "prg_nm": "KIBNET 가상계좌 입금",
                            "system_cd": "모바일",
                            "tx_status": "정상",
                            "req_dt": "20241013",
                            "req_tm": "234657",
                            "req_dttm": "20241013234657",
                            "res_dttm": "20241013234704",
                            "res_cd": "200",
                            "res_msg": "200",
                            "tx_biz_id": "KIBNET 가상계좌 입금",
                            "req_json": "{\"req_dttm\":\"20241013234657\",\"IF_ID\":\"IF041\",\"res_dttm\":null,\"prg_nm\":\"KIBNET 가상계좌 입금\"}",
                            "res_json": "{\"tx_status\":\"정상\",\"res_cd\":\"200\"}",
                            "elapsed": 6827
                        },
                        {
                            "id": 2874620,
                            "guid": "OQshG_gPNnZO",
                            "tx_id": "sPkJQsgaDw91",
                            "if_id": "IF042",
                            "prg_nm": "FSB(중앙회) 원리금 수납",
                            "system_cd": "모바일",
                            "tx_status": "정상",
                            "req_dt": "20241013",
                            "req_tm": "234704",
                            "req_dttm": "20241013234704",
                            "res_dttm": "20241013234712",
                            "res_cd": "200",
                            "res_msg": "200",
                            "tx_biz_id": "FSB(중앙회) 원리금 수납",
                            "req_json": "{\"req_dttm\":\"20241013234704\",\"IF_ID\":\"IF042\",\"res_dttm\":null,\"prg_nm\":\"FSB(중앙회) 원리금 수납\"}",
                            "res_json": "{\"tx_status\":\"정상\",\"res_cd\":\"200\"}",
                            "elapsed": 7904
                        }
                    ],
                    responseFormat: [
                        { name: 'id', type: 'Number', required: true, description: '거래 ID' },
                        { name: 'guid', type: 'String', required: true, description: 'GUID' },
                        { name: 'tx_id', type: 'String', required: true, description: '거래 ID' },
                        { name: 'if_id', type: 'String', required: true, description: '인터페이스 ID' },
                        { name: 'prg_nm', type: 'String', required: true, description: '프로그램 이름' },
                        { name: 'system_cd', type: 'String', required: true, description: '시스템 코드' },
                        { name: 'tx_status', type: 'String', required: true, description: '거래 상태' },
                        { name: 'req_dt', type: 'String', required: true, description: '요청 날짜' },
                        { name: 'req_tm', type: 'String', required: true, description: '요청 시간' },
                        { name: 'req_dttm', type: 'String', required: true, description: '요청 일시' },
                        { name: 'res_dttm', type: 'String', required: true, description: '응답 일시' },
                        { name: 'res_cd', type: 'String', required: true, description: '응답 코드' },
                        { name: 'res_msg', type: 'String', required: true, description: '응답 메시지' },
                        { name: 'tx_biz_id', type: 'String', required: true, description: '거래 업무 ID' },
                        { name: 'req_json', type: 'String', required: true, description: '요청 JSON' },
                        { name: 'res_json', type: 'String', required: true, description: '응답 JSON' },
                        { name: 'elapsed', type: 'Number', required: true, description: '소요 시간 (밀리초)' }
                    ],
                },
                getRuleDetections: {
                    name: '규칙 감지 목록 조회',
                    endpoint: '/api/rule-detections',
                    method: 'POST',
                    description: '규칙 감지 목록을 조회합니다.',
                    parameters: [
                        { name: 'startDate', type: 'String', required: true, default: this.$util.getDate(-7), description: '조회 시작 날짜 (YYYY-MM-DD 형식)' },
                        { name: 'endDate', type: 'String', required: true, default: this.$util.getDate(), description: '조회 종료 날짜 (YYYY-MM-DD 형식)' },
                        { name: 'ruleId', type: 'String', required: false, default: 'RULE-001', description: '규칙 ID (전체 또는 특정 규칙 ID)' }
                    ],
                    responseSampleHtml: '',
                    responseSample: [
                        {
                            "id": 1,
                            "rule_id": "RULE001",
                            "rule_nm": "거래량 급증 감지",
                            "svc_id": "SVC001",
                            "svc_nm": "계좌이체 서비스",
                            "svc_cnt": 1000,
                            "bf_svc_cnt": 800,
                            "bf_err_cnt": 10,
                            "af_svc_cnt": 1200,
                            "af_err_cnt": 15,
                            "tx_zero_yn": "N",
                            "tx_ratio": 150.00,
                            "tx_err_ratio": 1.25,
                            "tx_ratio_yn": "Y",
                            "tx_err_ratio_yn": "N",
                            "bf_startDttm": "20230501000000",
                            "af_startDttm": "20230501010000",
                            "type": "거래량",
                            "duration": "1시간",
                            "direction": "증가",
                            "threshold": 30,
                            "unit": "%",
                            "action": "알림 발송",
                            "enabled": "Y",
                            "reg_dt": "20230501",
                            "reg_dttm": "20230501010000"
                        }
                    ],
                    responseFormat: [
                        { name: 'id', type: 'Number', required: true, description: '규칙 감지 ID' },
                        { name: 'rule_id', type: 'String', required: true, description: '규칙 ID' },
                        { name: 'rule_nm', type: 'String', required: true, description: '규칙명' },
                        { name: 'svc_id', type: 'String', required: true, description: '서비스 ID' },
                        { name: 'svc_nm', type: 'String', required: true, description: '서비스명' },
                        { name: 'svc_cnt', type: 'Number', required: false, description: '서비스 건수' },
                        { name: 'bf_svc_cnt', type: 'Number', required: false, description: '이전 서비스 건수' },
                        { name: 'bf_err_cnt', type: 'Number', required: false, description: '이전 오류 건수' },
                        { name: 'af_svc_cnt', type: 'Number', required: false, description: '이후 서비스 건수' },
                        { name: 'af_err_cnt', type: 'Number', required: false, description: '이후 오류 건수' },
                        { name: 'tx_zero_yn', type: 'String', required: false, description: '거래량 제로 여부' },
                        { name: 'tx_ratio', type: 'Number', required: false, description: '거래량 비율' },
                        { name: 'tx_err_ratio', type: 'Number', required: false, description: '오류율' },
                        { name: 'tx_ratio_yn', type: 'String', required: false, description: '거래량 비율 여부' },
                        { name: 'tx_err_ratio_yn', type: 'String', required: false, description: '오류율 여부' },
                        { name: 'bf_startDttm', type: 'String', required: false, description: '이전 시작 일시' },
                        { name: 'af_startDttm', type: 'String', required: false, description: '이후 시작 일시' },
                        { name: 'type', type: 'String', required: false, description: '규칙 유형' },
                        { name: 'duration', type: 'String', required: false, description: '기간' },
                        { name: 'direction', type: 'String', required: false, description: '방향' },
                        { name: 'threshold', type: 'Number', required: false, description: '임계값' },
                        { name: 'unit', type: 'String', required: false, description: '단위' },
                        { name: 'action', type: 'String', required: false, description: '액션' },
                        { name: 'enabled', type: 'String', required: false, description: '활성화 여부' },
                        { name: 'reg_dt', type: 'String', required: false, description: '등록 일자' },
                        { name: 'reg_dttm', type: 'String', required: false, description: '등록 일시' }
                    ],
                },
            }

        };
    },
    computed: {
        /**
         * curl 예제 계산
         * @returns {string} curl 예제
         */
        computedCurlExample() {
            console.log('computedCurlExample', this.paramValues);
            if (!this.selectedApiDetails) return '';

            const endpoint = this.$config.endpoint_url + this.selectedApiDetails.endpoint;
            const headers = '-H "Content-Type: application/json"';
            let data = '';

            if (Object.keys(this.paramValues).length > 0) {
                const nonEmptyParams = Object.entries(this.paramValues)
                    .filter(([_, value]) => value !== '')
                    .reduce((acc, [key, value]) => ({ ...acc, [key]: value }), {});

                if (Object.keys(nonEmptyParams).length > 0) {
                    data = `-d '${JSON.stringify(nonEmptyParams)}'`;
                }
            }

            const curlCommand = `curl -X ${this.selectedApiDetails.method} "${endpoint}" \\\n     ${headers} \\\n     ${data}`;
            return this.highlightCurl(curlCommand);
        },
    },
    watch: {

    },
    methods: {
        getRequestData() {
            const processParamValues = (params) => {
                const result = {};
                Object.entries(params).forEach(([key, value]) => {
                    if (value !== '') {
                        const [objName, propName] = key.split('.');
                        if (propName) {
                            if (!result[objName]) result[objName] = {};
                            result[objName][propName] = value;
                        } else {
                            result[key] = value;
                        }
                    }
                });
                return result;
            };

            const processedParams = processParamValues(this.paramValues);

            if (this.selectedApiDetails.requestHeader) {
                return {
                    header: {
                        prgId: this.selectedApiDetails.endpoint,
                        prgNm: this.selectedApiDetails.name,
                        txId: this.$util.uuid(),
                        txDtm: this.$util.getCurrentDateTime(),
                        userId: this.$session.userId,
                        userNm: this.$session.userName,
                    },
                    body: processedParams,
                };
            } else {
                return processedParams;
            }
        },
        updateParamValue(paramName, value) {
            //console.log('updateParamValue', paramName, value);
            this.$set(this.paramValues, paramName, value);
            this.curlExample = this.dynamicCurlExample();
        },
        /**
         * curl 예제 계산
         * @returns {string} curl 예제
         */
        dynamicCurlExample() {
            //console.log('dynamicCurlExample', this.selectedApiDetails, this.paramValues);
            if (!this.selectedApiDetails) return '';

            const endpoint = this.$config.endpoint_url + this.selectedApiDetails.endpoint;
            const headers = '-H "Content-Type: application/json"';
            let data = '';

            const requestData = this.getRequestData();
            //console.log('requestData', requestData);
            if (Object.keys(this.paramValues).length > 0) {
                const nonEmptyParams = Object.entries(this.paramValues)
                    .filter(([_, value]) => value !== '')
                    .reduce((acc, [key, value]) => ({ ...acc, [key]: value }), {});

                if (Object.keys(nonEmptyParams).length > 0) {
                    //requestData.body = nonEmptyParams;
                    data = `-d '${JSON.stringify(requestData)}'`;
                }
            }

            const curlCommand = `curl -X ${this.selectedApiDetails.method} "${endpoint}" \\\n     ${headers} \\\n     ${data}`;
            return this.highlightCurl(curlCommand);
        },
        async showApiDetails() {
            this.apiResponse = '';
            this.paramValues = {};

            this.selectedApiDetails = this.apiDetails[this.selectedApi];
            this.selectedApiDetails?.parameters.forEach(param => {
                this.paramValues[param.name] = param.default || '';
            });

            this.curlExample = this.dynamicCurlExample();

            try {
                const response = await fetch(`/mock/${this.selectedApiDetails.endpoint.replace('/api/', '')}.json`);
                console.log('response', response);
                if (!response.ok) {
                    throw new Error('데이터를 불러오는 중 오류가 발생했습니다.');
                }
                const resJson = await response.json();
                console.log('showApiDetails', resJson);

                //this.apiDetails[this.selectedApi].responseSample = hljs.highlight(JSON.stringify(resJson, null, 2), { language: 'json' }).value;
                this.selectedApiDetails.responseSampleHtml = this.beautifyJSON(resJson);
            } catch (error) {
                this.selectedApiDetails.responseSampleHtml = this.beautifyJSON(this.apiDetails[this.selectedApi].responseSample);
                //console.error('json 로드 중 오류 발생:', error);
            }
        },
        async callApi() {
            try {
                this.$loading.show('API를 호출하는 중입니다...');
                const apiDetails = this.apiDetails[this.selectedApi];


                const requestData = this.getRequestData();
                console.log('requestData', requestData);
                //const response = await axios.post(this.$config.endpoint_url + apiDetails.endpoint, requestData);
                const response = await axios({
                    method: apiDetails.method,
                    url: this.$config.endpoint_url + apiDetails.endpoint,
                    data: requestData
                });
                //console.log('response', response);
                try {
                    //this.apiResponse = ' ' + JSON.stringify(response.data, null, 2);
                    this.apiResponse = ' ' + this.beautifyJSON(response.data);
                } catch (error) {
                    console.error('API 호출 중 오류가 발생했습니다:', error, response.data);
                    const data = await response.json();
                    this.apiResponse = JSON.stringify(data, null, 2);
                }
            } catch (error) {
                console.error('API 호출 중 오류가 발생했습니다:', error);
                this.apiResponse = '오류: ' + error.message + ' ' + this.beautifyJSON(error.response.data);
            } finally {
                this.$loading.hide();
            }
        },
        customStringify(obj) {
            return JSON.stringify(obj, null, 2)
                .replace(/\n/g, ' ')
                .replace(/:\s+/g, ' : ')
                .replace(/,\s+/g, ', ');
        },
        beautifyJSON(obj) {
            const json = JSON.stringify(obj, null, 2);
            let depth = 0;

            const colorize = (match) => {
                let cls = 'json_number';
                if (/^"/.test(match)) {
                    cls = /:$/.test(match) ? 'json_key' : 'json_string';
                } else if (/true|false/.test(match)) {
                    cls = 'json_boolean';
                } else if (/null/.test(match)) {
                    cls = 'json_null';
                }
                return `<span class="${cls}">${match}</span>`;
            };

            const processLine = (line) => {

                const trimmedLine = line.trim();
                if (trimmedLine.includes('}') || trimmedLine.includes(']')) {
                    depth--;
                }

                const indentation = '&nbsp;&nbsp;&nbsp;&nbsp;'.repeat(depth);
                const processedLine = trimmedLine
                    .replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, colorize);

                if (trimmedLine.includes('{') || trimmedLine.includes('[')) {
                    depth++;
                }
                return `<span class="json_line">${indentation}${processedLine}</span>`;

            };

            return json.split('\n').map(processLine).join('\n');
        },
        beautifyCURL(curlCommand) {
            const CLASSES = {
                COMMAND: 'curl_command',
                URL: 'curl_url',
                OPTION: 'curl_option',
                HEADER: 'curl_header',
                DATA: 'curl_data'
            };

            const escapeHtml = (str) => {
                return str
                    .replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/"/g, '&quot;')
                    .replace(/'/g, '&#039;');
            };

            const wrap = (content, className) => `<span class="${className}">${content}</span>`;

            const highlightParts = (line) => {
                return line
                    .replace(/^(curl\s)/i, (match) => wrap(match, CLASSES.COMMAND))
                    .replace(/(-X\s+\w+)/g, (match) => wrap(match, CLASSES.OPTION))
                    .replace(/"(https?:\/\/[^"]+)"/g, (match, url) => `"${wrap(url, CLASSES.URL)}"`)
                    .replace(/(-H\s+("[^"]+"|\S+))/g, (match) => wrap(match, CLASSES.HEADER))
                    .replace(/(-d\s+('[^']+'|"[^"]+"))/g, (match) => wrap(match, CLASSES.DATA))
                    .replace(/(\\\s*)$/g, (match) => wrap(match, CLASSES.OPTION));
            };

            return curlCommand
                .split('\n')
                .map(line => escapeHtml(line.trim()))
                .map(highlightParts)
                .map(line => `<span class="curl_line">${line}</span>`)
                .join('\n');
        },
        highlightCurl(curlCommand) {
            return curlCommand
                .replace(/(curl)/g, '<span class="curl_command">$1</span>')
                .replace(/(-X POST)/g, '<span class="curl_method">$1</span>')
                //.replace(/(https:\/\/[\w./]+)(?=\s)/g, '<span class="curl_url">$1</span>')
                .replace(/(["']https?:\/\/[^\s"']+)/g, '<span class="curl_url">$1</span>')
                .replace(/(-H ".*?")/g, '<br />&nbsp;&nbsp;&nbsp;&nbsp;<span class="curl_header">$1</span>')
                .replace(/(-d '.*?')/g, '<br />&nbsp;&nbsp;&nbsp;&nbsp;<span class="curl_data">$1</span>');
        }
    },
    async mounted() {
        this.showApiDetails(); // 컴포넌트 마운트 시 API 상세 정보 표시

        // live_transactions.json 파일 로드
        /*
        try {
            const response = await fetch('/mock/live_transactions.json');
            const liveTransactionsData = await response.json();
            this.apiDetails.getLiveTransactions.responseSample = liveTransactionsData;
        } catch (error) {
            console.error('live_transactions.json 로드 중 오류 발생:', error);
        }
        */
    },
};
</script>

<style scoped>
.v-card-title {
    font-weight: bold;
}

.v-subheader {
    font-weight: bold;
    font-size: 1.1rem;
}

pre {
    background-color: #f5f5f5;
    padding: 10px;
    border-radius: 4px;
    white-space: pre-wrap;
    word-wrap: break-word;
}

.json_string {
    color: var(--v-success-base);
}

.json_key {
    color: var(--v-primary-base);
}

.json_number {
    color: var(--v-warning-base);
}

.json_boolean {
    color: purple;
}

.json_null {
    color: var(--v-grey-base);
}

.json_line {
    display: block;
}

.curl_line {
    display: block;
}

.curl_command {
    color: var(--v-primary-base);
    font-weight: bold;
}

.curl_method {
    color: var(--v-success-base);
}

.curl_url {
    color: var(--v-success-base);
}

.curl_option {
    color: var(--v-warning-base);
    font-weight: bold;
}

.curl_header {
    color: var(--v-accent-base);
}

.curl_data {
    color: var(--v-warning-base);
}
</style>
<template>
    <v-container fluid>
        <v-card>
            <v-card-title>API 명세</v-card-title>
            <v-card-text>
                <v-select v-model="selectedApi" :items="apiList" label="API 선택" @change="showApiDetails"></v-select>

                <v-card v-if="selectedApiDetails" class="mt-4">
                    <v-card-title>{{ selectedApiDetails.name }}</v-card-title>
                    <v-card-text>
                        <v-simple-table>
                            <template v-slot:default>
                                <tbody>
                                    <tr>
                                        <td>엔드포인트</td>
                                        <td>
                                            <!--code>{{ selectedApiDetails.endpoint }}</code-->
                                            <v-text-field v-model="selectedApiDetails.endpoint"></v-text-field>
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

                        <v-subheader class="mt-4">요청 파라미터</v-subheader>
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
                                                <v-text-field :value="paramValues[param.name]" @input="updateParamValue(param.name, $event)" :label="param.name"
                                                    :rules="[(v) => !param.required || !!v || '이 필드는 필수입니다.']" dense
                                                    hide-details="auto" ></v-text-field>
                                            </td>
                                        </tr>
                                    </tbody>
                                </template>
                            </v-simple-table>
                        </v-form>

                        <v-subheader class="mt-4">요청 형식</v-subheader>
                        <v-card outlined>
                            <v-card-text class="font-weight-bold"
                                v-html="curlExample"></v-card-text><!--eslint-disable-line-->
                        </v-card>
                        <v-btn color="primary" @click="callApi" class="mt-2">API 호출</v-btn>

                        <v-subheader class="mt-4">응답 결과</v-subheader>
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
                                <v-subheader class="mt-4">응답 샘플</v-subheader>
                                <v-card outlined>
                                    <v-card-text class="font-weight-bold"
                                        v-html="selectedApiDetails.responseSample"></v-card-text><!--eslint-disable-line-->
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
            selectedApi: 'loginSignin',
            selectedApiDetails: null,
            apiResponse: null,
            curlExample: '',
            paramValues: {},
            isFormValid: true,
            apiList: [
                { text: '로그인', value: 'loginSignin' },
                { text: '사용자 등록', value: 'loginSignup' },
                { text: '로그인 상태 체크', value: 'loginCheck' },
                { text: '로그아웃', value: 'logout' },
                { text: '서비스 거래 목록 조회', value: 'getIncidents' },
                { text: '실시간 서비스 분석', value: 'getLiveTransactions' },
                { text: '룰셋 조회', value: 'getRules' },
                { text: '대출 신청', value: 'applyLoan' },
                { text: '한도 조회', value: 'checkLoanLimit' },

            ],
            apiDetails: {
                getIncidents: {
                    name: '인시던트 목록 조회',
                    endpoint: '/api/incidents',
                    method: 'POST',
                    description: '인시던트 목록을 조회합니다.',
                    parameters: [
                        { name: 'startDate', type: 'String', required: true, default: this.$util.getDate(), description: '조회 시작 날짜 (YYYY-MM-DD 형식)' },
                        { name: 'endDate', type: 'String', required: true, default: this.$util.getDate(), description: '조회 종료 날짜 (YYYY-MM-DD 형식)' },
                        { name: 'status', type: 'String', required: false, default: 'open', description: '인시던트 상태 (예: "open", "closed")' }
                    ],
                    responseExample: '{\n  "incidents": [\n    {\n      "id": "string",\n      "title": "string",\n      "description": "string",\n      "status": "string",\n      "createdAt": "string",\n      "updatedAt": "string"\n    }\n  ],\n  "totalCount": "number"\n}',
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

                    responseExample: '{\n  "timestamp": "string",\n  "transactionData": {\n    "normal": "number",\n    "anomaly": "number"\n  },\n  "anomalyTransactions": [\n    {\n      "timestamp": "string",\n      "transactionId": "string",\n      "type": "string",\n      "amount": "number",\n      "status": "string"\n    }\n  ]\n}',
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

                    responseExample: '{\n  "rules": [\n    {\n      "id": "string",\n      "name": "string",\n      "type": "string",\n      "condition": "string",\n      "action": "string"\n    }\n  ]\n}',
                    responseSample: {
                        header: {
                            resultCode: "0000",
                            resultMessage: "룰셋 목록 조회 성공"
                        },
                        body: {
                            rules: [
                                {
                                    id: 'RULE-001',
                                    name: '10분 무거래 탐지',
                                    type: '거래 부재',
                                    condition: '10분 동안 거래 없음',
                                    action: '시스템 관리자에게 알림 발송'
                                }
                            ]
                        }
                    },
                    responseFormat: [
                        { name: 'rules', type: 'Array', required: true, description: '룰셋 목록' },
                        { name: 'rules[].id', type: 'String', required: true, description: '룰 ID' },
                        { name: 'rules[].name', type: 'String', required: true, description: '룰 이름' },
                        { name: 'rules[].type', type: 'String', required: true, description: '룰 타입' },
                        { name: 'rules[].condition', type: 'String', required: true, description: '룰 조건' },
                        { name: 'rules[].action', type: 'String', required: true, description: '룰 액션' },
                        { name: 'rules[].createdAt', type: 'String', required: true, description: '생성 시간 (yyyymmddhh24miss 형식)' },
                        { name: 'rules[].updatedAt', type: 'String', required: true, description: '수정 시간 (yyyymmddhh24miss 형식)' }
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
                    responseExample: '{\n  "applicationId": "string",\n  "status": "string",\n  "message": "string"\n}',
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

                    responseExample: '{\n  "customerId": "string",\n  "loanLimit": "number",\n  "creditScore": "number"\n}',
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
                        { name: 'token', type: 'String', required: true, default: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c', description: '사용자 인증 토큰' }
                    ],

                    responseExample: '{\n  "header": {\n    "resultCode": "string",\n    "resultMessage": "string"\n  },\n  "body": {\n    "userId": "string",\n    "userName": "string",\n    "userType": "string",\n    "userStatus": "string",\n    "loginStatus": "string",\n    "lastLoginDate": "string",\n    "expiredDate": "string"\n  }\n}',
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
                    responseExample: '{\n  "header": {\n    "resultCode": "string",\n    "resultMessage": "string"\n  },\n  "body": {\n    "userId": "string",\n    "userName": "string",\n    "userType": "string",\n    "userStatus": "string",\n    "loginStatus": "string",\n    "lastLoginDate": "string",\n    "expiredDate": "string"\n  }\n}',
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
                    responseExample: '{\n  "header": {\n    "resultCode": "string",\n    "resultMessage": "string"\n  },\n  "body": {\n    "userId": "string",\n    "userName": "string",\n    "userType": "string",\n    "userStatus": "string",\n    "loginStatus": "string",\n    "lastLoginDate": "string",\n    "expiredDate": "string"\n  }\n}',
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
                    responseExample: '{\n  "header": {\n    "resultCode": "string",\n    "resultMessage": "string"\n  }\n}',
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
            }

        };
    },
    computed: {
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
        updateParamValue(paramName, value) {
            //console.log('updateParamValue', paramName, value);
            this.$set(this.paramValues, paramName, value);
            this.curlExample = this.dynamicCurlExample();
        },
        dynamicCurlExample() {
            //console.log('dynamicCurlExample', this.selectedApiDetails, this.paramValues);
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
        async showApiDetails() {
            this.apiResponse = '';
            this.paramValues = {};
            
            this.selectedApiDetails = this.apiDetails[this.selectedApi];
            this.selectedApiDetails.parameters.forEach(param => {
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
                this.apiDetails[this.selectedApi].responseSample = this.beautifyJSON(resJson);
            } catch (error) {
                console.error('json 로드 중 오류 발생:', error);
            }
        },
        async callApi() {
            try {
                this.$loading.show('API를 호출하는 중입니다...');
                const apiDetails = this.apiDetails[this.selectedApi];

                const requestData = { ...this.paramValues };
                console.log('requestData', requestData);
                const response = await axios.post(this.$config.endpoint_url + apiDetails.endpoint, requestData);
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
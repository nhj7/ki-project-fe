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
                                        <td><code>{{ selectedApiDetails.endpoint }}</code></td>
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
                        <v-simple-table v-if="selectedApiDetails.parameters.length">
                            <template v-slot:default>
                                <thead>
                                    <tr>
                                        <th class="text-left">파라미터</th>
                                        <th class="text-left">타입</th>
                                        <th class="text-left">필수</th>
                                        <th class="text-left">설명</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="param in selectedApiDetails.parameters" :key="param.name">
                                        <td><code>{{ param.name }}</code></td>
                                        <td>{{ param.type }}</td>
                                        <td>{{ param.required ? '예' : '아니오' }}</td>
                                        <td>{{ param.description }}</td>
                                    </tr>
                                </tbody>
                            </template>
                        </v-simple-table>

                        <v-subheader class="mt-4">요청 형식</v-subheader>
                        <v-card outlined>
                            <v-card-text>
                                <pre><code>{{ selectedApiDetails.curlExample }}</code></pre>
                            </v-card-text>
                        </v-card>
                        <v-btn color="primary" @click="callApi" class="mt-2">API 호출</v-btn>

                        <v-subheader class="mt-4">응답 결과</v-subheader>
                        <v-card outlined v-if="apiResponse">
                            <v-card-text>
                                <pre><code>{{ apiResponse }}</code></pre>
                            </v-card-text>
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
                                    <v-card-text>
                                        <pre><code>{{ JSON.stringify(selectedApiDetails.responseSample, null, 2) }}</code></pre>
                                    </v-card-text>
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
            selectedApi: 'getIncidents',
            selectedApiDetails: null,
            apiResponse: null,
            apiList: [
                { text: '인시던트 목록 조회', value: 'getIncidents' },
                { text: '실시간 거래 분석', value: 'getLiveTransactions' },
                { text: '룰셋 조회', value: 'getRules' },
                { text: '대출 신청', value: 'applyLoan' },
                { text: '한도 조회', value: 'checkLoanLimit' }
            ],
            apiDetails: {
                getIncidents: {
                    name: '인시던트 목록 조회',
                    endpoint: '/api/incidents',
                    method: 'POST',
                    description: '인시던트 목록을 조회합니다.',
                    parameters: [
                        { name: 'startDate', type: 'String', required: true, description: '조회 시작 날짜 (YYYY-MM-DD 형식)' },
                        { name: 'endDate', type: 'String', required: true, description: '조회 종료 날짜 (YYYY-MM-DD 형식)' },
                        { name: 'status', type: 'String', required: false, description: '인시던트 상태 (예: "open", "closed")' }
                    ],
                    curlExample: 'curl -X POST "https://api.example.com/api/incidents" \\\n     -H "Content-Type: application/json" \\\n     -d \'{"startDate": "2023-01-01", "endDate": "2023-12-31", "status": "open"}\'',
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
                        { name: 'duration', type: 'Number', required: false, description: '조회 기간 (분 단위, 기본값: 5)' }
                    ],
                    curlExample: 'curl -X POST "https://api.example.com/api/live-transactions" \\\n     -H "Content-Type: application/json" \\\n     -d \'{"duration": 10}\'',
                    responseExample: '{\n  "normalTransactions": [\n    { "timestamp": "string", "value": "number" }\n  ],\n  "anomalyTransactions": [\n    { "timestamp": "string", "value": "number" }\n  ],\n  "kpi": {\n    "totalTransactions": "number",\n    "transactionsPerMinute": "number",\n    "errorRate": "number",\n    "averageResponseTime": "number"\n  }\n}',
                    responseSample: {
                        normalTransactions: [
                            { timestamp: '2023-05-01T10:30:00Z', value: 100 },
                            { timestamp: '2023-05-01T10:31:00Z', value: 105 }
                        ],
                        anomalyTransactions: [
                            { timestamp: '2023-05-01T10:32:00Z', value: 5 }
                        ],
                        kpi: {
                            totalTransactions: 210,
                            transactionsPerMinute: 70,
                            errorRate: 2.38,
                            averageResponseTime: 0.5
                        }
                    },
                    responseFormat: [
                        { name: 'normalTransactions', type: 'Array', required: true, description: '정상 거래 목록' },
                        { name: 'normalTransactions[].timestamp', type: 'String', required: true, description: '거래 시간 (yyyymmddhh24miss 형식)' },
                        { name: 'normalTransactions[].value', type: 'Number', required: true, description: '거래 금액' },
                        { name: 'anomalyTransactions', type: 'Array', required: true, description: '이상 거래 목록' },
                        { name: 'anomalyTransactions[].timestamp', type: 'String', required: true, description: '거래 시간 (yyyymmddhh24miss 형식)' },
                        { name: 'anomalyTransactions[].value', type: 'Number', required: true, description: '거래 금액' },
                        { name: 'kpi', type: 'Object', required: true, description: '주요 성과 지표' },
                        { name: 'kpi.totalTransactions', type: 'Number', required: true, description: '전체 거래 수' },
                        { name: 'kpi.transactionsPerMinute', type: 'Number', required: true, description: '분당 거래 수' },
                        { name: 'kpi.errorRate', type: 'Number', required: true, description: '오류율 (%)' },
                        { name: 'kpi.averageResponseTime', type: 'Number', required: true, description: '평균 응답 시간 (초)' }
                    ],
                },
                getRules: {
                    name: '룰셋 조회',
                    endpoint: '/api/rules',
                    method: 'POST',
                    description: '설정된 룰셋 목록을 조회합니다.',
                    parameters: [],
                    curlExample: 'curl -X POST "https://api.example.com/api/rules" \\\n     -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \\\n     -H "Content-Type: application/json" \\\n     -d \'{}\'',
                    responseExample: '{\n  "rules": [\n    {\n      "id": "string",\n      "name": "string",\n      "type": "string",\n      "condition": "string",\n      "action": "string"\n    }\n  ]\n}',
                    responseSample: {
                        rules: [
                            {
                                id: 'RULE-001',
                                name: '10분 무거래 탐지',
                                type: '거래 부재',
                                condition: '10분 동안 거래 없음',
                                action: '시스템 관리자에게 알림 발송'
                            }
                        ]
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
                    endpoint: '/api/loan/apply',
                    method: 'POST',
                    description: '대출을 신청합니다.',
                    parameters: [
                        { name: 'name', type: 'String', required: true, description: '신청자 이름' },
                        { name: 'amount', type: 'Number', required: true, description: '대출 금액' },
                        { name: 'period', type: 'Number', required: true, description: '대출 기간 (개월)' }
                    ],
                    curlExample: 'curl -X POST "https://api.example.com/api/loan/apply" \\\n     -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \\\n     -H "Content-Type: application/json" \\\n     -d \'{"name": "홍길동", "amount": 1000000, "period": 12}\'',
                    sampleRequestBody: {
                        name: "홍길동",
                        amount: 1000000,
                        period: 12
                    },
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
                    endpoint: '/api/loan/limit',
                    method: 'POST',
                    description: '대출 가능 한도를 조회합니다.',
                    parameters: [
                        { name: 'customerId', type: 'String', required: true, description: '고객 ID' }
                    ],
                    curlExample: 'curl -X POST "https://api.example.com/api/loan/limit" \\\n     -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \\\n     -H "Content-Type: application/json" \\\n     -d \'{"customerId": "123456"}\'',
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
                }
            }
        };
    },
    methods: {
        showApiDetails() {
            this.selectedApiDetails = this.apiDetails[this.selectedApi];
        },
        async callApi() {
            try {
                this.$loading.show('API를 호출하는 중입니다...');
                const apiDetails = this.apiDetails[this.selectedApi];
                const response = await fetch(apiDetails.endpoint, {
                    method: apiDetails.method,
                    headers: {
                        'Content-Type': 'application/json',
                        // 필요한 경우 인증 헤더 추가
                    },
                    // POST 요청의 경우 body 추가
                    ...(apiDetails.method === 'POST' && {
                        body: JSON.stringify(apiDetails.sampleRequestBody)
                    }),
                });
                const data = await response.json();
                this.apiResponse = JSON.stringify(data, null, 2);
            } catch (error) {
                console.error('API 호출 중 오류가 발생했습니다:', error);
                this.apiResponse = '오류: ' + error.message;
            } finally {
                this.$loading.hide();
            }
        },
    },
    mounted() {
        this.showApiDetails(); // 컴포넌트 마운트 시 API 상세 정보 표시
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
</style>
<template>
    <v-container>
        <v-row>
            <v-col cols="12">
                <v-btn :color="isSimulatorRunning ? 'error' : 'success'" @click="toggleSimulator">
                    {{ isSimulatorRunning ? '시뮬레이터 중지' : '시뮬레이터 시작' }}
                </v-btn>
            </v-col>
        </v-row>

        <!-- 시뮬레이터 제어 섹션 -->
        <v-card class="mb-4">
            
            <v-card-text>
                <v-row>
                    <v-col cols="4">
                        <v-slider v-model="transactionSpeed" :min="0" :max="20" label="거래 발생 속도 (초당)"></v-slider>
                    </v-col>
                    <v-col cols="4">
                        <v-text-field v-model="transactionSpeed" label="초당 거래량"
                            type="number"></v-text-field>
                    </v-col>
                </v-row>
            </v-card-text>
        </v-card>

        <!-- 오류율 조절 섹션 -->
        <v-row>
            <v-col cols="3">
                <h3>오류율 조절</h3>
            </v-col>
            <v-col cols="3">
                <v-select v-model="errorRateService" :items="services" label="서비스 선택"></v-select>
            </v-col>
            <v-col cols="3">
                <v-radio-group v-model="errorRateChange">
                    <v-radio label="증가" value="increase"></v-radio>
                    <v-radio label="감소" value="decrease"></v-radio>
                </v-radio-group>
            </v-col>
            <v-col cols="3">
                <v-text-field v-model="errorRateChangeRate" label="변화 비율 (%)" type="number"></v-text-field>
            </v-col>
        </v-row>

        <!-- 응답시간 조절 섹션 -->
        <v-row>
            <v-col cols="3">
                <h3>응답시간 조절</h3>
            </v-col>
            <v-col cols="3">
                <v-select v-model="responseTimeService" :items="services" label="서비스 선택"></v-select>
            </v-col>
            <v-col cols="3">
                <v-radio-group v-model="responseTimeChange">
                    <v-radio label="증가" value="increase"></v-radio>
                    <v-radio label="감소" value="decrease"></v-radio>
                </v-radio-group>
            </v-col>
            <v-col cols="3">
                <v-text-field v-model="responseTimeChangeRate" label="변화 비율 (%)" type="number"></v-text-field>
            </v-col>
        </v-row>

        <!-- 반복 수행 거래 설정 섹션 -->
        <v-row>
            <v-col cols="12">
                <h3>반복 수행 거래 설정</h3>
            </v-col>
            <v-col cols="3">
                <v-text-field v-model="repeatUserId" label="사용자 ID"></v-text-field>
            </v-col>
            <v-col cols="3">
                <v-select v-model="repeatTransactionType" :items="transactionTypes" label="거래 유형"></v-select>
            </v-col>
            <v-col cols="3">
                <v-text-field v-model="repeatCount" label="반복 횟수" type="number"></v-text-field>
            </v-col>
            <v-col cols="3">
                <v-text-field v-model="repeatInterval" label="반복 간격 (초)" type="number"></v-text-field>
            </v-col>
        </v-row>

    </v-container>
</template>

<script>
const comp = module.exports = {
    name: 'SimulatorControl',
    data() {
        return {
            isSimulatorRunning: false,
            transactionSpeed: 10,
            transactionVolumeChange: 'none',
            transactionVolumeChangeRate: 0,
            errorRateService: '',
            errorRateChange: 'increase',
            errorRateChangeRate: 0,
            responseTimeService: '',
            responseTimeChange: 'increase',
            responseTimeChangeRate: 0,
            repeatUserId: '',
            repeatTransactionType: '',
            repeatCount: 1,
            repeatInterval: 1,
            scenarioName: '',
            selectedScenario: '',
            services: ['결제', '주문', '배송'],
            transactionTypes: ['결제', '주문', '조회'],
            savedScenarios: [],
            currentTransactionVolume: 0,
            currentErrorRate: 0,
            averageResponseTime: 0,
            anomalies: []
        };
    },
    methods: {
        toggleSimulator() {
            this.isSimulatorRunning = !this.isSimulatorRunning;
            // 여기에 시뮬레이터 시작/중지 로직 추가
        },
        saveScenario() {
            // 현재 설정을 시나리오로 저장하는 로직
        },
        loadScenario() {
            // 선택된 시나리오를 불러오는 로직
        },
        // 기타 필요한 메서드들...
    }
};
</script>
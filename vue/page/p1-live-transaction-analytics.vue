<template>
    <v-container fluid>
        <v-row>
            <v-col cols="12">
                <v-card>
                    <v-card-text>

                        <!-- KPI 요약 -->
                        <v-row dense class="mb-4">
                            <v-col v-for="(item, index) in summaryItems" :key="index" cols="12" sm="6" md="3">
                                <v-card>
                                    <v-card-text class="pa-2">
                                        <div class="d-flex justify-space-between align-center">
                                            <span class="text-subtitle-1 font-weight-bold pl-6" :class="item.color">{{
                                item.label }}</span>
                                            <span class="text-subtitle-1 font-weight-bold pr-6" :class="item.color">
                                                {{ $util.numberWithComma(item.value) + item.unit }}
                                            </span>
                                        </div>
                                    </v-card-text>
                                </v-card>
                            </v-col>
                        </v-row>
                        <v-row>
                            <v-col cols="12" md="12">
                                <v-chart class="chart" :option="transactionFlowOption" :autoresize="true" />
                            </v-col>
                        </v-row>

                        <v-row>
                            <v-col cols="12">
                                <v-data-table :headers="anomalyHeaders" :items="anomalyTransactions" :items-per-page="3"
                                    :footer-props="{
                                'items-per-page-options': itemsPerPageOptions,

                            }" class="elevation-1">
                                    <template v-slot:[`item.status`]="{ item }">
                                        <v-chip :color="getStatusColor(item.status)" small>
                                            {{ item.status }}
                                        </v-chip>
                                    </template>
                                </v-data-table>
                            </v-col>
                        </v-row>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>

<script>
const comp = module.exports = {
    name: 'TransactionFlowDashboard',
    components: {
        VChart: window.VueECharts
    },
    data: function () {
        return {
            transactionFlowOption: {

                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    data: ['정상 거래', '이상 거래']
                },
                xAxis: {
                    type: 'time',
                    boundaryGap: false
                },
                yAxis: {
                    type: 'value',
                    name: '거래량'
                },
                series: [
                    {
                        name: '정상 거래',
                        type: 'line',
                        data: []
                    },
                    {
                        name: '이상 거래',
                        type: 'line',
                        data: []
                    }
                ],
                dataZoom: [
                    {
                        type: 'inside',
                        start: 0,
                        end: 100
                    },
                    {
                        start: 0,
                        end: 100
                    }
                ]
            },
            kpiData: [
                { label: '총 거래량', value: '0', trend: 'up' },
                { label: '오류율', value: '0%', trend: 'down' },
                { label: '이상 거래 비율', value: '0%', trend: 'up' },
                { label: '평균 처리 시간', value: '0초', trend: 'down' }
            ],
            anomalyHeaders: [
                { text: '시간', value: 'timestamp' },
                { text: '거래 ID', value: 'transactionId' },
                { text: '유형', value: 'type' },
                { text: '금액', value: 'amount' },
                { text: '상태', value: 'status' }
            ],
            anomalyTransactions: [],
            updateInterval: null,
            summaryItems: [
                { label: '총 거래량', value: 0, unit: '건', color: 'primary--text' },
                { label: '분당 거래량', value: 0, unit: '건', color: 'info--text' },
                { label: '오류율', value: 0, unit: '%', color: 'error--text' },
                { label: '평균 응답시간', value: 0, unit: 'ms', color: 'warning--text' }
            ],
            itemsPerPageOptions: [3, 5, 10, 15, 20],
        };
    },
    methods: {
        async fetchNewData() {
            try {
                // 실제로는 서버에서 데이터를 가져와야 합니다.
                // 여기서는 가상의 트랜잭션을 사용합니다.
                await new Promise(resolve => setTimeout(resolve, 500));

                const now = new Date();
                const normalValue = Math.round(Math.random() * 100 + 100);
                const anomalyValue = Math.round(Math.random() * 10 + 10);

                this.transactionFlowOption.series[0].data.push([now, normalValue]);
                this.transactionFlowOption.series[1].data.push([now, anomalyValue]);

                // 최근 100개 데이터만 유지
                if (this.transactionFlowOption.series[0].data.length > 100) {
                    this.transactionFlowOption.series[0].data.shift();
                    this.transactionFlowOption.series[1].data.shift();
                }

                // KPI 업데이트
                const totalTransactions = parseInt(this.summaryItems[0].value) + (normalValue + anomalyValue);
                this.summaryItems[0].value = totalTransactions.toString();
                this.summaryItems[1].value = normalValue + anomalyValue;
                this.summaryItems[2].value = ((anomalyValue / totalTransactions) * 100).toFixed(2);
                this.summaryItems[3].value = (Math.random() * 0.5 + 0.5).toFixed(2);

                // 이상 거래 추가
                if (Math.random() < 0.3) {  // 30% 확률로 이상 거래 발생
                    this.anomalyTransactions.unshift({
                        timestamp: now.toLocaleString(),
                        transactionId: 'TX' + Math.random().toString(36).substr(2, 6),
                        type: ['이체', '결제', '출금'][Math.floor(Math.random() * 3)],
                        amount: this.$util.numberWithComma(Math.floor(Math.random() * 1000000)) + '원',
                        status: Math.random() < 0.5 ? '의심' : '오류'
                    });

                    // 최근 100개 이상 거래만 유지
                    if (this.anomalyTransactions.length > 100) {
                        this.anomalyTransactions.pop();
                    }
                }
            } catch (error) {
                console.error('새 데이터를 가져오는 중 오류가 발생했습니다:', error);
            }
        },
        getStatusColor: function (status) {
            switch (status) {
                case '오류': return 'error';
                case '의심': return 'warning';
                case '정상': return 'success';
                default: return 'grey';
            }
        },
        startUpdating: function () {
            this.updateInterval = setInterval(this.fetchNewData, 5000);  // 5초마다 업데이트
        },
        stopUpdating: function () {
            clearInterval(this.updateInterval);
        },
        updateSummaryItems: function () {
            // 이 메서드에서 summaryItems의 값을 업데이트합니다.
            // 예시:
            this.summaryItems[0].value = this.calculateTotalTransactions();
            this.summaryItems[1].value = this.calculateTransactionsPerMinute();
            this.summaryItems[2].value = this.calculateErrorRate();
            this.summaryItems[3].value = this.calculateAverageResponseTime();
        },
        calculateTotalTransactions: function () {
            // 총 거래량 계산 로직
        },
        calculateTransactionsPerMinute: function () {
            // 분당 거래량 계산 로직
        },
        calculateErrorRate: function () {
            // 오류율 계산 로직
        },
        calculateAverageResponseTime: function () {
            // 평균 응답시간 계산 로직
        },
    },
    mounted: async function () {
        await this.fetchNewData(); // 초기 데이터 로드
        this.startUpdating();
    },
    beforeDestroy: function () {
        //console.log(`${this.$route.meta.title} beforeDestroy`);
        this.stopUpdating();
    }
};
</script>

<style scoped>
.chart {
    height: 400px;
}
</style>
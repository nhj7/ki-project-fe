<template>
    <v-container fluid>
        <v-row>
            <v-col cols="12">
                <v-card>
                    <v-card-text>

                        <!-- KPI 요약 -->
                        <!--v-row dense class="mb-4">
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
                        </v-row-->

                        <v-row>
                            <v-col cols="12" align="center">
                                <div id="realtime-transaction-chart"></div>
                            </v-col>
                        </v-row>

                        <!-- 거래 흐름 차트 -->
                        <v-row>
                            <v-col cols="12" md="12">
                                <v-chart class="chart" :option="chartOption" :autoresize="true" :key="isDarkMode" />
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
                    name: '거래시간'
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                series: [
                    {
                        name: '정상 거래',
                        type: 'scatter',
                        smooth: true,
                        data: [],
                        symbolSize: 5,
                        symbol: 'circle',
                        itemStyle: {
                            color: 'dodgerblue'
                        }
                    },
                    {
                        name: '이상 거래',
                        type: 'scatter',
                        smooth: true,
                        data: [],
                        symbolSize: 5,
                        symbol: 'circle',
                        itemStyle: {
                            color: 'red'
                        }
                    }
                ],

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
            realChartData: {
                svg: null,
                width: '90%',
                height: 40,
                barHeight: 35,
                barWidth: 800,
                ellipseRx: 13, // 가로 반지름
                ellipseRy: 7, // 세로 반지름
                colors: ["red", "orange", "yellow", "green", "blue", "indigo", "violet"],  // 무지개 색상
                colorIndex: 0,
                updateInterval: null,
            },
            resizeObserver: null
        };
    },
    computed: {
        isDarkMode() {
            return this.$vuetify.theme.dark;
        },
        themeColors() {
            return this.$vuetify.theme.currentTheme;
        },
        chartOption() {
            const textColor = this.themeColors.text;
            const primaryColor = this.themeColors.primary;
            const errorColor = this.themeColors.error;
            //const backgroundColor = this.isDarkMode ? '#1E1E1E' : '#FFFFFF';
            //console.log('chartOption', textColor, primaryColor, errorColor);
            return {
                ...this.transactionFlowOption,
                //backgroundColor: backgroundColor,
                textStyle: {
                    color: primaryColor
                },
                legend: {
                    ...this.transactionFlowOption.legend,
                    textStyle: {
                        color: primaryColor
                    },
                    icon: 'roundRect',
                },
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'cross',
                        label: {
                            backgroundColor: this.themeColors.secondary
                        }
                    }
                },
                xAxis: {
                    ...this.transactionFlowOption.xAxis,
                    axisLabel: {
                        ...this.transactionFlowOption.xAxis.axisLabel,
                        color: primaryColor
                    },
                },
                yAxis: {
                    ...this.transactionFlowOption.yAxis,
                    axisLabel: {
                        ...this.transactionFlowOption.yAxis.axisLabel,
                        color: primaryColor
                    },
                    splitLine: {
                        lineStyle: {
                            color: this.isDarkMode ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.1)'
                        }
                    }
                },
                brush: {
                    xAxisIndex: 'all',
                    brushLink: 'all',
                    outOfBrush: {
                        colorAlpha: 0.1
                    },
                    brushStyle: {
                        borderWidth: 1,
                        color: 'rgba(120,140,180,0.3)',
                        borderColor: 'rgba(120,140,180,0.8)'
                    },
                    toolbox: ['rect', 'polygon', 'keep', 'clear'],
                    throttleType: 'debounce',
                    throttleDelay: 300
                },
                toolbox: {
                    feature: {
                        brush: {
                            type: ['rect', 'polygon', 'keep', 'clear']
                        }
                    }
                },
                series: this.transactionFlowOption.series.map(series => ({
                    ...series,
                    itemStyle: {
                        color: series.name === '정상 거래' ? primaryColor : errorColor
                    }
                }))
            };
        }
    },
    methods: {

        animateTransaction(transaction) {
            const ellipse = this.realChartData.svg.append("ellipse")
                .attr("class", "transaction")
                .attr("cx", 0)  // 시작 지점 (원통의 왼쪽 밖)
                .attr("cy", transaction.y)       // Y 좌표는 원통의 중간
                .attr("rx", this.realChartData.ellipseRx)           // 가로 반지름
                .attr("ry", this.realChartData.ellipseRy)           // 세로 반지름
                .attr("fill", transaction.color);  // 색상 지정

            /*
            const ellipse = this.realChartData.svg.append("rect")
                .attr("class", "transaction")
                .attr("x", this.realChartData.ellipseRx)  // 시작 x 좌표
                .attr("y", transaction.y)  // 막대가 중간에 위치하도록 y 좌표를 설정
                .attr("width", this.realChartData.ellipseRx)  // 너비 설정 (막대는 얇게)
                .attr("height", this.realChartData.ellipseRy)  // 높이 설정
                .attr("fill", transaction.color);  // 색상 설정
            */

            const endX = this.realChartData.barWidth; // 원통의 우측 끝
            const fadeStartX = this.realChartData.barWidth;  // 80% 지점에서 서서히 사라지기 시작

            // 애니메이션: 좌측에서 우측으로 이동하며 타원의 모양 변형

            // 애니메이션: 좌측에서 우측으로 이동
            d3.select(ellipse.node())
                .transition()
                .duration(transaction.speed)
                .ease(d3.easeLinear)
                .attrTween("transform", function () {
                    //const interpolateX = d3.interpolate(100 , fadeStartX); // 시작과 끝 좌표 사이의 보간
                    const interpolateX = d3.interpolate(100, fadeStartX); // 시작과 끝 좌표 사이의 보간
                    //console.log('interpolateX', interpolateX);
                    return function (t) {
                        const x = parseInt(interpolateX(t));
                        //console.log('t', t, x);
                        return `translate(${x},0)`;  // translate로 x 좌표 변경
                    };
                })
                .on("end", function () {
                    d3.select(this).remove();  // 애니메이션이 끝나면 타원 제거
                });

            /*
            ellipse
                .transition()
                .duration(transaction.speed)
                .ease(d3.easeLinear)
                .attr("cx", fadeStartX)  // 80% 지점까지 이동
                .attr("transform", `scale(1.3, 0.8)`)  // 이동 중에 타원을 가로로 길게 변형
                .transition()  // 서서히 사라지기 시작
                .duration(transaction.speed * 0.2)  // 속도의 20% 동안 서서히 사라짐
                .attr("cx", endX)  // 원통의 우측 끝으로 이동
                .attr("opacity", 0)
                //.attr("transform", `scale(1, 1)`)  // 사라지기 전 원래 크기로 복원
                .on("end", function () {
                    d3.select(this).remove();  // 애니메이션이 끝나면 타원 제거
                });
            */

            // 잔상 효과 추가
            /*
            for (let i = 1; i <= 5; i++) {
                this.realChartData.svg.append("ellipse")
                    .attr("class", "transaction")
                    .attr("cx", 100 - this.realChartData.ellipseRx)
                    .attr("cy", transaction.y)
                    .attr("rx", this.realChartData.ellipseRx)
                    .attr("ry", this.realChartData.ellipseRy)
                    .attr("fill", transaction.color)
                    .attr("fill-opacity", 0.5 - (i * 0.1))  // 투명도 조절
                    .transition()
                    .duration(transaction.speed * (1 + i * 0.1))  // 속도와 비례한 잔상
                    .attr("cx", fadeStartX)
                    .attr("opacity", 0)
                    .remove();
            }
            */
        },


        generateTransaction() {
            const randomValue = Math.random();
            const transaction = {
                id: randomValue,
                speed: (randomValue * 1500 + 1000) * 2,  // 속도는 기존의 절반으로 더 빠르게
                //color: this.realChartData.colors[this.realChartData.colorIndex % this.realChartData.colors.length],  // 무지개 색 순서대로 지정
                //color: randomValue < 0.05 ? 'red' : 'dodgerblue',
                color: 'dodgerblue',
                y: (this.realChartData.height - this.realChartData.barHeight) / 2 + this.realChartData.barHeight / 2  // 트랜잭션은 원통의 중간을 지나가도록
            };
            this.realChartData.colorIndex++;  // 다음 트랜잭션에 대해 색상 순서 업데이트
            return transaction;
        },
        generateInitialData() {
            const now = new Date();
            const fiveMinutesAgo = new Date(now.getTime() - 5 * 60 * 1000);
            const data = [];

            for (let time = fiveMinutesAgo; time <= now; time.setSeconds(time.getSeconds() + 10)) {
                const normalValue = Math.round(Math.random() * 100 + 100);
                const tx_data = {
                    time: time.getTime(),
                    normal: normalValue,
                }
                // 이상 거래 추가
                if (Math.random() < 0.03) {  // 3% 확률로 이상 거래 발생
                    this.anomalyTransactions.unshift({
                        timestamp: time.toLocaleString(),
                        transactionId: 'TX' + Math.random().toString(36).substr(2, 6),
                        type: ['이체', '결제', '출금'][Math.floor(Math.random() * 3)],
                        amount: this.$util.numberWithComma(Math.floor(Math.random() * 1000000)) + '원',
                        status: Math.random() < 0.5 ? '의심' : '오류'
                    });

                    // 최근 100개 이상 거래만 유지
                    const anomalyValue = Math.round(Math.random() * 100 + 100);
                    tx_data.anomaly = anomalyValue;
                    if (this.anomalyTransactions.length > 100) {
                        this.anomalyTransactions.pop();
                    }
                }

                data.push(tx_data);

            }

            return data;
        },
        updateChartData(data) {
            this.transactionFlowOption.series[0].data = data.map(item => [item.time, item.normal]);
            this.transactionFlowOption.series[1].data = data
                .filter(item => item.anomaly !== undefined)
                .map(item => [item.time, item.anomaly]);
        },
        async fetchNewData() {
            try {
                // 실제로는 서버에서 데이터를 가져와야 합니다.
                // 여기서는 가상의 트랜잭션을 사용합니다.
                await new Promise(resolve => setTimeout(resolve, 500));

                const now = new Date();
                const normalValue = Math.round(Math.random() * 60 + 60);

                this.transactionFlowOption.series[0].data.push([now, normalValue]);


                // 최근 100개 데이터만 유지
                if (this.transactionFlowOption.series[0].data.length > 100) {
                    this.transactionFlowOption.series[0].data.shift();
                }
                // 이상 거래 추가
                if (Math.random() < 0.03) {  // 3% 확률로 이상 거래 발생
                    this.anomalyTransactions.unshift({
                        timestamp: now.toLocaleString(),
                        transactionId: 'TX' + Math.random().toString(36).substr(2, 6),
                        type: ['이체', '결제', '출금'][Math.floor(Math.random() * 3)],
                        amount: this.$util.numberWithComma(Math.floor(Math.random() * 1000000)) + '원',
                        status: Math.random() < 0.5 ? '의심' : '오류'
                    });

                    const anomalyValue = Math.round(Math.random() * 60 + 60);
                    this.transactionFlowOption.series[1].data.push([now, anomalyValue]);

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
            clearInterval(this.realChartData.updateInterval);
        },
        updateSummaryItems(data) {
            const totalTransactions = data.reduce((sum, item) => sum + item.normal + item.anomaly, 0);
            const averageTransactionsPerMinute = totalTransactions / 5;
            const totalAnomalies = data.reduce((sum, item) => sum + item.anomaly, 0);
            const errorRate = (totalAnomalies / totalTransactions) * 100;
            const averageResponseTime = Math.random() * 0.5 + 0.5; // 0.5 ~ 1.0 초 사이의 랜덤값

            this.summaryItems[0].value = totalTransactions;
            this.summaryItems[1].value = Math.round(averageTransactionsPerMinute);
            this.summaryItems[2].value = errorRate.toFixed(2);
            this.summaryItems[3].value = averageResponseTime.toFixed(2);
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
    created() {
        const initialData = this.generateInitialData();
        this.updateChartData(initialData);
        this.updateSummaryItems(initialData);
    },
    mounted: async function () {
        await this.fetchNewData(); // 초기 데이터 로드
        this.startUpdating();

        // SVG 생성
        this.realChartData.svg = d3.select("#realtime-transaction-chart")
            .append("svg")
            .attr("width", this.realChartData.width)
            .attr("height", this.realChartData.height);

        const currentWidth = this.realChartData.svg.node().getBoundingClientRect().width;

        this.realChartData.svg
            .attr("viewBox", `0 0 ${currentWidth} ${this.realChartData.height}`)  // viewBox 설정
            .attr("preserveAspectRatio", "xMidYMid meet");

        //console.log('realChartData', currentWidth);
        this.realChartData.barWidth = currentWidth * 0.9;

        // 가로형 원통 (중앙에 위치한 바)
        this.realChartData.svg.append("rect")
            .attr("class", "bar")
            .attr("x", (currentWidth - this.realChartData.barWidth) / 2)
            .attr("y", (this.realChartData.height - this.realChartData.barHeight) / 2)
            .attr("width", this.realChartData.barWidth)
            .attr("height", this.realChartData.barHeight)
            .attr("rx", 50)  // 둥근 모서리로 원통형 효과
            .attr("ry", 50);

        setInterval(() => {
            const transaction = this.generateTransaction();
            this.animateTransaction(transaction);
        }, 300);  // 1초마다 1개 트랜잭션 생성 (10배 감소)

        this.resizeObserver = new ResizeObserver(entries => {
            for (let entry of entries) {
                //console.log('Element resized:', entry.contentRect.width, entry.contentRect.height);
            }
        });

        this.resizeObserver.observe(this.$el.querySelector('#realtime-transaction-chart'));
    },
    beforeDestroy: function () {
        //console.log(`${this.$route.meta.title} beforeDestroy`);
        this.stopUpdating();
        this.resizeObserver.disconnect();
    }
};
</script>

<style scoped>
.chart {
    height: 400px;
}

.transaction {
    fill-opacity: 0.5;
    /* 투명도 설정 */
}

.bar {
    fill: whitesmoke;
}

.theme--dark .bar {
    fill: #333333;
}
</style>
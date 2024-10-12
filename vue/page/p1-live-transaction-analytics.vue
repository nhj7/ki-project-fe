<template>
    <v-container fluid>
        <v-row>
            <v-col cols="12">
                <v-card>
                    <v-card-text>
                        <v-row>
                            <v-col cols="12" align="center">
                                <div id="realtime-transaction-chart"></div>
                            </v-col>
                        </v-row>

                        <!-- 서비스 별 거래량 데이터 테이블 추가 -->
                        <v-row>
                            <v-col cols="12">
                                <v-data-table :headers="serviceHeaders" :items="serviceTransactions" :items-per-page="5"
                                    :footer-props="{
                                        'items-per-page-options': [5, 10, 15]
                                    }" class="elevation-1">
                                    <template v-slot:[`item.errorRate`]="{ item }">
                                        <v-chip :color="getRateColor(item.errorRate)" small>
                                            {{ item.errorRate }}%
                                        </v-chip>
                                    </template>
                                    <template v-slot:[`item.tps`]="{ item }">
                                        {{ item.tps }}
                                    </template>
                                    <!-- 전일자 대비 표시 -->
                                    <template v-slot:[`item.compare`]="{ item }">
                                        <span
                                            :class="{'text-green': item.compareTrend === 'down', 'text-red': item.compareTrend === 'up'}">
                                            <v-icon small>
                                                {{ item.compareTrend === 'up' ? 'mdi-trending-up' : 'mdi-trending-down'
                                                }}
                                            </v-icon>
                                            {{ item.compareValue }}
                                        </span>
                                    </template>
                                </v-data-table>
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
                                    :footer-props="{'items-per-page-options': itemsPerPageOptions,}"
                                    class="elevation-1">
                                    <template v-slot:[`item.timestamp`]="{ item }">
                                        {{ item.timestamp.replace(/(.{4})(.{2})(.{2})(.{2})(.{2})(.{2})/,
                                        '$1-$2-$3$4:$5:$6') }}
                                    </template>
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
                { text: '상태', value: 'status' }
            ],
            anomalyTransactions: [],
            /**@type {number} 업데이트 주기 */
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
                /**@type {number} 업데이트 주기 */
                updateInterval: null,
            },
            resizeObserver: null,
            // 서비스 거래량 데이터 테이블을 위한 헤더 정의
            serviceHeaders: [
                { text: '서비스명', value: 'serviceName' },
                { text: '오류율', value: 'errorRate' },
                { text: '전일대비', value: 'compare', sortable: false },
                { text: 'TPS', value: 'tps' },
                { text: '시간당', value: 'transactionsPerHour' },
                { text: '금일', value: 'todayTransactions' },
                { text: '전일', value: 'yesterdayTransactions' },
                { text: '전주', value: 'lastWeekTransactions' },
                //{ text: '전월', value: 'lastMonthTransactions' },

            ],
            /**@type {array} 서비스 거래량 데이터 */
            serviceTransactions: [],
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

            return {
                ...this.transactionFlowOption,
                animation: false,  // 애니메이션 비활성화
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
                    trigger: 'item',
                    axisPointer: {
                        type: 'shadow',
                        label: {
                            backgroundColor: this.themeColors.secondary
                        }
                    }
                },
                xAxis: {
                    ...this.transactionFlowOption.xAxis,
                    axisLabel: {
                        ...this.transactionFlowOption.xAxis.axisLabel,
                        color: primaryColor,
                        formatter: (value) => {
                            const date = new Date(value);
                            return `${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`;
                        }
                    },
                    min: this.transactionFlowOption.xAxis.min,
                    max: this.transactionFlowOption.xAxis.max
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
        // 오류율에 따른 색상 반환
        getRateColor(rate) {
            if (rate < 5) return 'green';
            if (rate < 10) return 'orange';
            return 'red';
        },

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
                    d3.select(this).remove();  // 애니메이션이 끝면 타원 제거
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

        /**
         * 트랜잭션 데이터를 생성하는 함수
         * @param {object} tx 트랜잭션 데이터
         * @returns 트랜잭션 데이터
         */
        generateTransaction(tx) {
            const randomValue = Math.random();
            const transaction = {
                id: randomValue,
                //speed: (randomValue * 1500 + 1000) * 2,  // 속도는 기존의 절반으로 더 빠르게
                speed: tx.elapsed,
                //color: this.realChartData.colors[this.realChartData.colorIndex % this.realChartData.colors.length],  // 무지개 색 순서대로 지정
                //color: randomValue < 0.05 ? 'red' : 'dodgerblue',
                color: 'dodgerblue',
                y: (this.realChartData.height - this.realChartData.barHeight) / 2 + this.realChartData.barHeight / 2  // 트랜잭션은 원통의 중간을 지나가도록
            };
            this.realChartData.colorIndex++;  // 다음 트랜잭션에 대해 색상 순서 업데이트
            return transaction;
        },

        /**
         * 초기 데이터를 가져오는 함수
         * @returns 초기 데이터
         */
        async generateInitialData() {
            const now = new Date();
            const minutesAgo = new Date(now.getTime() - 3 * 60 * 1000);
            const data = [];
            // 초기 데이터 로드를 위한 API 호출
            const endDttm = this.$util.getDateTime(now);
            const startDttm = this.$util.getDateTime(minutesAgo);
            try {
                const response = await this.$axios.post(
                    '/api/gettxdata',
                    {
                        startDttm: startDttm,
                        endDttm: endDttm
                    }
                );
                return response.data.txDataList;
            } catch (error) {
                console.error('초기 데이터를 가져오는 중 오류가 발생했습니다:', error);
                return [];
            }
        },

        /**
         * 차트 데이터를 업데이트하는 함수
         * @param {array} transactions 트랜잭션 데이터
         */
        updateChartData(transactions) {
            const now = Date.now();
            const threeMinutesAgo = now - 180000; // 3분 전

            transactions.forEach(tx => {
                const time = new Date(tx.req_dttm.slice(0, 4) + '-' + tx.req_dttm.slice(4, 6) + '-' + tx.req_dttm.slice(6, 8) + 'T' + tx.req_dttm.slice(8, 10) + ':' + tx.req_dttm.slice(10, 12) + ':' + tx.req_dttm.slice(12, 14)).getTime();
                if (time >= threeMinutesAgo) {
                    if (tx.tx_status === '정상') {
                        this.transactionFlowOption.series[0].data.push([time, tx.elapsed]);
                    } else {
                        this.transactionFlowOption.series[1].data.push([time, tx.elapsed]);
                    }
                }
            });

            // 데이터 정렬 및 오래된 데이터 제거
            for (let i = 0; i < 2; i++) {
                this.transactionFlowOption.series[i].data.sort((a, b) => a[0] - b[0]);
                this.transactionFlowOption.series[i].data = this.transactionFlowOption.series[i].data.filter(item => item[0] >= threeMinutesAgo);
            }

            // X축 범위 조정
            this.transactionFlowOption.xAxis.min = threeMinutesAgo;
            this.transactionFlowOption.xAxis.max = now;
        },

        /**
         * 새로운 데이터를 가져오는 함수
         * @returns 새로운 데이터
         */
        async fetchNewData() {
            try {
                // 실제로는 서버에서 데이터를 가져와야 합니다.                
                // gettxdata API를 사용하여 최근 5분간의 거래 데이터를 가져옵니다.
                const endDttm = this.$util.getDateTime(new Date());
                const startDttm = this.$util.getDateTime(new Date(Date.now() - 5 * 1000));


                const response = await this.$axios.post(
                    '/api/gettxdata',
                    {
                        startDttm: startDttm,
                        endDttm: endDttm
                    }
                );
                const transactions = response.data.txDataList;

                this.updateChartData(transactions);

                // 이상 거래 목록 업데이트
                // 새로운 비정상 거래 필터링 및 매핑
                const newAnomalies = transactions
                    .filter(tx => tx.tx_status !== '정상')
                    .filter(tx => !this.anomalyTransactions.some(existingItem => existingItem.id === tx.id))
                    .map(tx => ({
                        id: tx.id,
                        timestamp: tx.req_dttm,
                        transactionId: tx.tx_id,
                        type: tx.tx_biz_id,
                        amount: this.$util.numberWithComma(JSON.parse(tx.req_json).amount || 0) + '원',
                        status: tx.tx_status === '타임아웃' ? '오류' : '의심'
                    }));

                // 기존 anomalyTransactions와 새로운 비정상 거래를 합치고 정렬
                this.anomalyTransactions = [...this.anomalyTransactions, ...newAnomalies]
                    .sort((a, b) => new Date(b.id) - new Date(a.id))
                    .slice(0, 10);  // 최근 100개만 유지

                //console.log('anomalyTransactions', this.anomalyTransactions)



                transactions.sort((a, b) => b.id - a.id);
                transactions.forEach((tx, idx) =>
                    setTimeout(() => {
                        const transaction = this.generateTransaction(tx);
                        this.animateTransaction(transaction);
                    }, 300 * idx)
                )


            } catch (error) {
                console.error('새 데이터를 가져오는 중 오류가 발생했습니다:', error);
            }
        },

        /**
         * 상태에 따른 색상을 반환하는 함수
         * @param {string} status 상태
         * @returns 상태에 따른 색상
         */
        getStatusColor: function (status) {
            switch (status) {
                case '오류': return 'error';
                case '의심': return 'warning';
                case '정상': return 'success';
                default: return 'grey';
            }
        },

        /**
         * 업데이트를 시작하는 함수
         * @param none
         * @returns none
         */
        startUpdating: function () {
            this.updateInterval = setInterval(this.fetchNewData, 5000);  // 5초마다 업데이트
        },
        /**
         * 숫자를 입력받아 단위를 붙여 반환하는 함수
         * @param {number} num 입력 숫자
         * @returns {string} 단위가 붙은 문자열
         */
        formatNumber: function (num) {
            if (num >= 1000000) {
                return (num / 1000000).toFixed(1).replace(/\.0$/, '') + 'M';
            } else if (num >= 1000) {
                return (num / 1000).toFixed(1).replace(/\.0$/, '') + 'K';
            } else {
                return num.toString();
            }
        },

        /**
         * 업데이트를 중지하는 함수
         */
        stopUpdating: function () {
            clearInterval(this.updateInterval);
            clearInterval(this.realChartData.updateInterval);
            clearInterval(this.transactionFlowUpdateInterval);
        },

        /**
         * 서비스 거래량 데이터를 가져오는 함수
         * @returns none
         */
        async fetchServiceData() {
            // 서비스 목록 정의
            const services = ['여신 한도조회', '모바일 비대면 대출', '수신 계좌개설', '수신 간편송금'];

            // 현재 서비스 데이터가 비어있다면 초기화
            /*
            if (this.serviceTransactions.length === 0) {
                services.forEach(serviceName => {
                    this.serviceTransactions.push({
                        serviceName: serviceName,
                        normal: 0,
                        errorRate: 0,
                        tps: 0,
                        transactionsPerHour: 0,
                        todayTransactions: 0,
                        compareTrend: 'up',
                        compareValue: '+0%'
                    });
                });
                return;
            }
            */

            // 각 서비스에 대해 랜덤 데이터 생성 및 업데이트
            /*
            this.serviceTransactions = this.serviceTransactions.map(service => {
                // 이전 데이터를 저장하여 비교에 사용
                const previousTransactionsPerHour = service.transactionsPerHour;
                const previousTodayTransactions = service.todayTransactions;

                // 랜덤으로 정상 거래량과 오류율 생성
                const newNormal = Math.floor(Math.random() * 100) + 100; // 100 ~ 199
                const newErrorRate = parseFloat((Math.random() * 10).toFixed(2)); // 0.00 ~ 9.99%

                // 초당 거래량(TPS) 계산 (예: transactionsPerHour / 3600)
                const newTps = parseFloat((service.transactionsPerHour / 3600).toFixed(2));

                // 거래량 누적
                const updatedTransactionsPerHour = service.transactionsPerHour + newNormal;
                const updatedTodayTransactions = service.todayTransactions + newNormal;

                // 전일 대비 비교
                let compareTrend = 'up';
                let compareValue = '+0%';

                if (previousTransactionsPerHour > 0) {
                    const difference = updatedTransactionsPerHour - previousTransactionsPerHour;
                    compareTrend = difference >= 0 ? 'up' : 'down';
                    const percentageChange = ((Math.abs(difference) / previousTransactionsPerHour) * 100).toFixed(2);
                    compareValue = `${difference >= 0 ? '+' : '-'}${percentageChange}%`;
                }

                return {
                    ...service,
                    normal: service.normal + newNormal,
                    errorRate: newErrorRate ,
                    tps: newTps,
                    transactionsPerHour: updatedTransactionsPerHour,
                    todayTransactions: updatedTodayTransactions,
                    compareTrend: compareTrend,
                    compareValue: compareValue
                };
            });
            */
           
            try {
                const response = await this.$axios.get('/incident/getMetric');

                console.log('getMetric response', response);

                if (response.data && response.data) {
                    this.serviceTransactions = response.data.map(service => ({
                        serviceName: service.svcNm,
                        normal: service.todayCnt,
                        errorRate: service.errPer,
                        tps: service.tps ? parseFloat(service.tps).toFixed(2) : 0, // TPS를 소수점 두 자리까지 표시
                        transactionsPerHour: this.$util.numberWithComma(service.currentCnt),
                        todayTransactions: this.formatNumber(service.todayCnt),
                        yesterdayTransactions: this.$util.numberWithComma(service.previousDayCnt),
                        lastWeekTransactions: this.$util.numberWithComma(service.previousWeekCnt),
                        compareTrend: service.errDiffPer >= 0 ? 'up' : 'down',
                        compareValue: `${service.errDiffPer >= 0 ? '+' : ''}${service.errDiffPer}%`
                    }));
                }
            } catch (error) {
                console.error('서비스 데이터 가져오기 실패:', error);
                // 에러 처리 로직 추가 (예: 사용자에게 알림)
            }
            

        },

        /**
         * 서비스 데이터 업데이트를 시작하는 함수
         * @returns none
         */
        startServiceDataUpdate() {
            this.fetchServiceData(); // 초기 데이터 로드
            this.serviceDataInterval = setInterval(this.fetchServiceData, 5000); // 5초마다 갱신
        },

        /**
         * 서비스 데이터 업데이트를 중지하는 함수
         * @returns none
         */
        stopServiceDataUpdate() {
            clearInterval(this.serviceDataInterval);
        }
    },
    async created() {
        const initialData = await this.generateInitialData();
        this.updateChartData(initialData);
        this.fetchServiceData(); // 초기 데이터 로드 (가상 데이터 사용)
        ///this.updateSummaryItems(initialData);
    },
    async mounted() {
        await this.fetchNewData(); // 초기 데이터 로드
        this.startUpdating();

        // 서비스 거래량 데이터 업데이트 시작
        this.startServiceDataUpdate();

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

        /*
        this.transactionFlowUpdateInterval = setInterval(() => {
            const transaction = this.generateTransaction();
            this.animateTransaction(transaction);
        }, 300);  // 1초마다 1개 트랜잭션 생성 (10배 감소)
        */

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
        this.stopServiceDataUpdate();
        try {
            this.resizeObserver.disconnect();
        } catch (e) {
            console.error('resizeObserver 종료 중 오류가 발생했습니다:', e);
        }
    }
};
</script>

<style scoped>
.chart {
    height: 200px;
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

/* 추가 스타일 */
.text-green {
    color: green;
}

.text-red {
    color: red;
}
</style>
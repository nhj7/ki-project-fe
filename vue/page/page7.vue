<template>
    <v-container fluid>
      <v-card>
        <v-card-title>트랜잭션 흐름 모니터링</v-card-title>
        <v-card-text>
          <v-chart class="chart" :option="chartOption" :autoresize="true" />
        </v-card-text>
      </v-card>
    </v-container>
  </template>
  
  <script>
  const comp = module.exports = {
    components: {
      VChart: VueECharts
    },
    data() {
      return {
        chartOption: {
          title: {
            text: '트랜잭션 흐름 모니터링'
          },
          tooltip: {
            formatter: function(params) {
              return `시간: ${params.data[2]}<br/>
                      응답시간: ${params.data[1].toFixed(2)}초<br/>
                      트랜잭션 ID: ${params.data[3]}`;
            }
          },
          xAxis: {
            type: 'value',
            name: '시간',
            min: 0,
            max: 100
          },
          yAxis: {
            type: 'value',
            name: '응답시간 (초)',
            min: 0,
            max: 60
          },
          dataZoom: [
            {
              type: 'inside',
              xAxisIndex: 0,
              start: 0,
              end: 100
            },
            {
              type: 'slider',
              xAxisIndex: 0,
              start: 0,
              end: 100
            }
          ],
          series: [{
            type: 'scatter',
            data: [],
            symbolSize: 8,
            itemStyle: {
              color: function(params) {
                const responseTime = params.data[1];
                if (responseTime <= 10) return 'limegreen';
                if (responseTime <= 30) return 'orange';
                return 'red';
              }
            },
            emphasis: {
              itemStyle: {
                borderColor: '#fff',
                borderWidth: 2
              }
            }
          }]
        },
        timer: null,
        transactions: [],
        currentTime: 0
      }
    },
    methods: {
      addTransaction() {
        let responseTime;
        const rand = Math.random();
        if (rand < 0.8) {
          responseTime = Math.random() * 10; // 0-10초 (80% 확률)
        } else if (rand < 0.95) {
          responseTime = Math.random() * 20 + 10; // 10-30초 (15% 확률)
        } else {
          responseTime = Math.random() * 30 + 30; // 30-60초 (5% 확률)
        }
        responseTime = Math.min(responseTime, 60); // 60초로 제한
  
        const transaction = {
          x: this.currentTime,
          y: responseTime,
          time: new Date().toLocaleTimeString(),
          id: `TXN-${Math.floor(Math.random() * 1000000)}`
        };
        this.transactions.push(transaction);
        this.updateChartData();
      },
      updateChartData() {
        this.currentTime += 0.1; // 시간을 천천히 증가
        if (this.currentTime > 100) {
          this.currentTime = 0;
          this.transactions = [];
        }
        this.chartOption.series[0].data = this.transactions.map(t => [t.x, t.y, t.time, t.id]);
      },
      startSimulation() {
        this.timer = setInterval(() => {
          if (Math.random() < 0.3) { // 30% 확률로 새 트랜잭션 추가
            this.addTransaction();
          }
          this.updateChartData();
        }, 100);
      }
    },
    mounted() {
      this.startSimulation();
    },
    beforeDestroy() {
      if (this.timer) {
        clearInterval(this.timer);
      }
    }
  }
  </script>
  
  <style scoped>
  .chart {
    height: 600px;
  }
  </style>
<template>
  <v-container fluid>
    <v-row>
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title>라인 차트</v-card-title>
          <v-card-text>
            <v-chart class="chart" :option="lineChartOption" />
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title>바 차트</v-card-title>
          <v-card-text>
            <v-chart class="chart" :option="barChartOption" />
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title>파이 차트</v-card-title>
          <v-card-text>
            <v-chart class="chart" :option="pieChartOption" />
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title>산점도 차트</v-card-title>
          <v-card-text>
            <v-chart class="chart" :option="scatterChartOption" />
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title>레이더 차트</v-card-title>
          <v-card-text>
            <v-chart class="chart" :option="radarChartOption" />
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title>히트맵 차트</v-card-title>
          <v-card-text>
            <v-chart class="chart" :option="heatmapChartOption" />
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title>웨이브 게이지 차트</v-card-title>
          <v-card-text>
            <v-chart class="chart" :option="waveGaugeOption" />
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="6">
        <v-card>

        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
const comp = module.exports = {
  components: {
    VChart: VueECharts
  },
  data() {
    return {
      lineChartOption: {
        xAxis: {
          type: 'category',
          data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        },
        yAxis: {
          type: 'value'
        },
        series: [{
          data: [150, 230, 224, 218, 135, 147, 260],
          type: 'line'
        }]
      },
      barChartOption: {
        xAxis: {
          type: 'category',
          data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        },
        yAxis: {
          type: 'value'
        },
        series: [{
          data: [120, 200, 150, 80, 70, 110, 130],
          type: 'bar'
        }]
      },
      pieChartOption: {
        series: [{
          type: 'pie',
          data: [
            { value: 335, name: '직접 방문' },
            { value: 234, name: '이메일 마케팅' },
            { value: 1548, name: '검색 엔진' }
          ]
        }]
      },
      scatterChartOption: {
        xAxis: {},
        yAxis: {},
        series: [{
          symbolSize: 20,
          data: [
            [10.0, 8.04],
            [8.0, 6.95],
            [13.0, 7.58],
            [9.0, 8.81],
            [11.0, 8.33],
            [14.0, 9.96],
            [6.0, 7.24],
            [4.0, 4.26],
            [12.0, 10.84],
            [7.0, 4.82],
            [5.0, 5.68]
          ],
          type: 'scatter'
        }]
      },
      radarChartOption: {
        radar: {
          indicator: [
            { name: '영업', max: 6500 },
            { name: '관리', max: 16000 },
            { name: '정보 기술', max: 30000 },
            { name: '고객 지원', max: 38000 },
            { name: '개발', max: 52000 },
            { name: '마케팅', max: 25000 }
          ]
        },
        series: [{
          name: '예산 대 지출',
          type: 'radar',
          data: [
            {
              value: [4200, 3000, 20000, 35000, 50000, 18000],
              name: '할당 예산'
            },
            {
              value: [5000, 14000, 28000, 26000, 42000, 21000],
              name: '실제 지출'
            }
          ]
        }]
      },
      heatmapChartOption: {
        tooltip: {
          position: 'top'
        },
        animation: false,
        grid: {
          height: '50%',
          top: '10%'
        },
        xAxis: {
          type: 'category',
          data: ['12a', '1a', '2a', '3a', '4a', '5a', '6a', '7a', '8a', '9a', '10a', '11a'],
          splitArea: {
            show: true
          }
        },
        yAxis: {
          type: 'category',
          data: ['Saturday', 'Friday', 'Thursday', 'Wednesday', 'Tuesday', 'Monday', 'Sunday'],
          splitArea: {
            show: true
          }
        },
        visualMap: {
          min: 0,
          max: 10,
          calculable: true,
          orient: 'horizontal',
          left: 'center',
          bottom: '15%'
        },
        series: [{
          name: 'Punch Card',
          type: 'heatmap',
          data: [[0, 0, 5], [0, 1, 1], [0, 2, 0], [0, 3, 0], [0, 4, 0], [0, 5, 0], [0, 6, 0], [0, 7, 0], [0, 8, 0], [0, 9, 0], [0, 10, 0], [0, 11, 2], [1, 0, 1], [1, 1, 2], [1, 2, 0], [1, 3, 1], [1, 4, 0], [1, 5, 0], [1, 6, 0], [1, 7, 0], [1, 8, 0], [1, 9, 0], [1, 10, 1], [1, 11, 0], [2, 0, 2], [2, 1, 1], [2, 2, 1], [2, 3, 3], [2, 4, 0], [2, 5, 0], [2, 6, 0], [2, 7, 0], [2, 8, 2], [2, 9, 0], [2, 10, 0], [2, 11, 1], [3, 0, 5], [3, 1, 2], [3, 2, 0], [3, 3, 0], [3, 4, 0], [3, 5, 0], [3, 6, 0], [3, 7, 0], [3, 8, 0], [3, 9, 0], [3, 10, 0], [3, 11, 2], [4, 0, 1], [4, 1, 1], [4, 2, 0], [4, 3, 0], [4, 4, 0], [4, 5, 0], [4, 6, 0], [4, 7, 0], [4, 8, 0], [4, 9, 0], [4, 10, 1], [4, 11, 2], [5, 0, 1], [5, 1, 0], [5, 2, 0], [5, 3, 0], [5, 4, 0], [5, 5, 0], [5, 6, 0], [5, 7, 0], [5, 8, 0], [5, 9, 0], [5, 10, 3], [5, 11, 0], [6, 0, 1], [6, 1, 0], [6, 2, 0], [6, 3, 0], [6, 4, 1], [6, 5, 0], [6, 6, 0], [6, 7, 0], [6, 8, 0], [6, 9, 1], [6, 10, 0], [6, 11, 0]],
          label: {
            show: true
          },
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowColor: 'rgba(0, 0, 0, 0.5)'
            }
          }
        }]
      },

      waveGaugeOption: {
        series: [{
          type: 'liquidFill',
          data: [0.6],
          color: ['#1890FF'],
          center: ['50%', '50%'],
          radius: '70%',
          amplitude: '8%',
          waveLength: '70%',
          phase: 'auto',
          period: 'auto',
          direction: 'right',
          shape: 'circle',
          waveAnimation: true,
          animationEasing: 'linear',
          animationEasingUpdate: 'linear',
          animationDuration: 300,
          animationDurationUpdate: 300,
          outline: {
            show: true,
            borderDistance: 8,
            itemStyle: {
              color: 'none',
              borderColor: '#294D99',
              borderWidth: 8,
              shadowBlur: 20,
              shadowColor: 'rgba(0, 0, 0, 0.25)'
            }
          },
          label: {
            show: true,
            color: '#294D99',
            insideColor: '#fff',
            fontSize: 50,
            fontWeight: 'bold',
            align: 'center',
            baseline: 'middle',
            position: 'inside'
          }
        }]
      }




    }
  }
}
</script>

<style scoped>
.chart {
  height: 400px;
}
</style>
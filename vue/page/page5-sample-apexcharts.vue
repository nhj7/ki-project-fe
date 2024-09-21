<template>
    <v-container fluid>
      <v-row>
        <v-col cols="12" md="6">
          <v-card>
            <v-card-title>라인 차트</v-card-title>
            <v-card-text>
              <apexchart type="line" height="350" :options="lineChartOptions" :series="lineChartSeries"></apexchart>
            </v-card-text>
          </v-card>
        </v-col>
        <v-col cols="12" md="6">
          <v-card>
            <v-card-title>바 차트</v-card-title>
            <v-card-text>
              <apexchart type="bar" height="350" :options="barChartOptions" :series="barChartSeries"></apexchart>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
      <v-row>
        <v-col cols="12" md="6">
          <v-card>
            <v-card-title>파이 차트</v-card-title>
            <v-card-text>
              <apexchart type="pie" height="350" :options="pieChartOptions" :series="pieChartSeries"></apexchart>
            </v-card-text>
          </v-card>
        </v-col>
        <v-col cols="12" md="6">
          <v-card>
            <v-card-title>도넛 차트</v-card-title>
            <v-card-text>
              <apexchart type="donut" height="350" :options="donutChartOptions" :series="donutChartSeries"></apexchart>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script>
  const comp = module.exports = {
    components: {
      apexchart: VueApexCharts
    },
    data() {
      return {
        lineChartOptions: {
          chart: {
            id: 'vuechart-example'
          },
          xaxis: {
            categories: [1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998]
          }
        },
        lineChartSeries: [{
          name: 'series-1',
          data: [30, 40, 35, 50, 49, 60, 70, 91]
        }],
        barChartOptions: {
          chart: {
            id: 'vuechart-example'
          },
          xaxis: {
            categories: ['월', '화', '수', '목', '금', '토', '일']
          }
        },
        barChartSeries: [{
          name: 'sales',
          data: [30, 40, 35, 50, 49, 60, 70]
        }],
        pieChartOptions: {
          chart: {
            id: 'vuechart-example'
          },
          labels: ['Team A', 'Team B', 'Team C', 'Team D', 'Team E']
        },
        pieChartSeries: [44, 55, 13, 43, 22],
        donutChartOptions: {
          chart: {
            id: 'vuechart-example'
          },
          labels: ['Team A', 'Team B', 'Team C', 'Team D', 'Team E']
        },
        donutChartSeries: [44, 55, 13, 43, 22]
      }
    }
  }
  </script>
  
  <style scoped>
  .v-card {
    height: 400px;
  }
  </style>
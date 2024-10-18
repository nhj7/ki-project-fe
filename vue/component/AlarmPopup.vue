<template>
    <v-dialog v-model="dialog" max-width="800px">
      <v-card>
        <v-card-title>
          <span class="headline">
            <v-icon>mdi-bell</v-icon>
            &nbsp;&nbsp;알람 목록
          </span>
        </v-card-title>
        <v-card-text>
          <v-data-table
            :headers="headers"
            :items="alarms"
            :items-per-page="5"
            class="elevation-1"
            @click:row="$vo.openDetectedDialog"
          >
            <template v-slot:[`item.severity`]="{ item }">
              <v-chip :color="getSeverityColor(item.severity)" small dark>
                {{ item.severity }}
              </v-chip>
            </template>
          </v-data-table>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="dialog = false">닫기</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </template>
  
  <script>
  const comp = module.exports = {
    props: ['value', 'alarms'],
    data() {
      return {
        dialog: this.value,
        headers: [
          { text: '발생시간', value: 'afEnddttm' },
          { text: '규칙ID', value: 'ruleId' },
          { text: '규칙명', value: 'ruleNm' },
          { text: '서비스명', value: 'svcNm' },
          
        ]
      };
    },
    watch: {
      value(newValue) {
        this.dialog = newValue;
      },
      dialog(newValue) {
        this.$emit('input', newValue);
      },
    },
    methods: {
      getSeverityColor(severity) {
        switch (severity) {
          case '심각':
            return 'red';
          case '경고':
            return 'orange';
          case '정보':
            return 'blue';
          default:
            return 'grey';
        }
      },
    },
  };
  </script>
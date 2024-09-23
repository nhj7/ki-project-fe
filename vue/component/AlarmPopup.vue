<template>
    <v-dialog v-model="dialog" max-width="800px">
      <v-card>
        <v-card-title>
          <span class="headline">알람 목록</span>
        </v-card-title>
        <v-card-text>
          <v-simple-table>
            <template v-slot:default>
              <thead>
                <tr>
                  <th>발생시간</th>
                  <th>시스템</th>
                  <th>심각도</th>
                  <th>서비스내용</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="alarm in alarms" :key="alarm.timestamp">
                  <td>{{ alarm.timestamp }}</td>
                  <td>{{ alarm.system }}</td>
                  <td>
                    <v-chip :color="getSeverityColor(alarm.severity)" small dark>
                      {{ alarm.severity }}
                    </v-chip>
                  </td>
                  <td>{{ alarm.description }}</td>
                </tr>
              </tbody>
            </template>
          </v-simple-table>
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
<template>
  <v-container fluid>
    <v-card>

      <v-card-text>
        <v-row>
          <v-col cols="6" md="2" sm="3" xs="4">
            <v-menu v-model="startDateMenu" :close-on-content-click="false" transition="scale-transition" offset-y
              max-width="290px" min-width="290px">
              <template v-slot:activator="{ on, attrs }">
                <v-text-field v-model="startDate" label="시작 일자" readonly v-bind="attrs" v-on="on" persistent-hint
                hide-details></v-text-field>
              </template>
              <v-date-picker v-model="startDate" no-title @input="startDateMenu = false"></v-date-picker>
            </v-menu>
          </v-col>
          <v-col cols="6" md="2" sm="3" xs="4">
            <v-text-field v-model="startTimeFormatted" label="시작 시간" persistent-hint 
              @input="formatTimeInput($event, 'startTime')" hide-details></v-text-field>
          </v-col>
          <v-col cols="6" md="2" sm="3" xs="4">
            <v-menu v-model="endDateMenu" :close-on-content-click="false" transition="scale-transition" offset-y
              max-width="290px" min-width="290px">
              <template v-slot:activator="{ on, attrs }">
                <v-text-field v-model="endDate" label="종료 일자" readonly v-bind="attrs" v-on="on" persistent-hint
                hide-details ></v-text-field>
              </template>
              <v-date-picker v-model="endDate" no-title @input="endDateMenu = false"></v-date-picker>
            </v-menu>
          </v-col>
          <v-col cols="6" md="2" sm="3" xs="4">
            <v-text-field v-model="endTimeFormatted" label="종료 시간" persistent-hint 
              @input="formatTimeInput($event, 'endTime')" hide-details></v-text-field>
          </v-col>
          <v-col cols="6" md="2" sm="3" xs="4">
            <v-btn :color="$config.color_btn" @click="fetchTransactions" small dense>&nbsp;&nbsp;검색&nbsp;&nbsp;</v-btn>
          </v-col>
          <v-col cols="6" md="2" sm="3" xs="4">
            <v-btn :color="$config.color_btn" @click="toggleDetailSearch" small dense>상세검색</v-btn>
          </v-col>
        </v-row>
        <!-- 상세 검색 영역 -->
        <v-expand-transition>
          <v-row v-if="showDetailSearch">
            <v-col cols="12">
              <v-card outlined>
                <v-card-text class="pa-3">
                  <v-row>
                    <v-col cols="6" md="3" sm="4" class="pa-1">
                      <v-text-field v-model="detailSearch.txId" label="트랜잭션 ID"></v-text-field>
                    </v-col>
                    <v-col cols="6" md="3" sm="4" class="pa-1">
                      <v-text-field v-model="detailSearch.ifId" label="인터페이스 ID"></v-text-field>
                    </v-col>
                    <v-col cols="6" md="3" sm="4" class="pa-1">
                      <v-text-field v-model="detailSearch.systemCd" label="시스템 코드"></v-text-field>
                    </v-col>
                    <v-col cols="6" md="3" sm="4" class="pa-1">
                      <v-select v-model="detailSearch.txStatus" :items="['정상', '오류']" label="상태"></v-select>
                    </v-col>
                    <!-- 필요에 따라 더 많은 상세 검색 필드를 추가할 수 있습니다 -->
                  </v-row>
                </v-card-text>
              </v-card>
            </v-col>
          </v-row>
        </v-expand-transition>
        <v-data-table :headers="headers" :items="transactions" :search="search" :items-per-page="15"
          class="elevation-1 small-font-table" @click:row="$vo.openTxDetailDialog">          
          <template v-slot:[`item.req_dttm`]="{ item }">
            {{ formatDateTime(item.req_dttm) }}
          </template>
          <template v-slot:[`item.res_dttm`]="{ item }">
            {{ formatDateTime(item.res_dttm) }}
          </template>
          <template v-slot:[`item.system_cd`]="{ item }">
            {{ item.system_cd.toUpperCase() }}
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>


  </v-container>
</template>

<script>
const comp = module.exports = {
  data() {
    return {
      search: '',
      startDttm: '',
      endDttm: '',
      headers: [
        { text: 'ID', value: 'id' },
        
        { text: '트랜잭션 ID', value: 'tx_id' },
        { text: '인터페이스 ID', value: 'if_id' },
        { text: '프로그램명', value: 'prg_nm' },
        { text: '시스템 코드', value: 'system_cd' },
        { text: '상태', value: 'tx_status' },
        { text: '요청 일시', value: 'req_dttm' },
        { text: '응답 일시', value: 'res_dttm' },
        { text: '응답 코드', value: 'res_cd' },
        { text: '응답 메시지', value: 'res_msg' },
        { text: '경과 시간(ms)', value: 'elapsed' },
      ],
      transactions: [],
      startDate: this.$util.getDate(0, '-'),
      startDateMenu: false,
      startTime: '',
      startTimeFormatted: '',
      endDate: this.$util.getDate(0, '-'),
      endDateMenu: false,
      endTime: '',
      endTimeFormatted: '',
      showDetailSearch: false,
      detailSearch: {
        txId: '',
        ifId: '',
        systemCd: '',
        txStatus: '',
      },
    }
  },
  computed: {

  },
  methods: {
    toggleDetailSearch() {
      this.showDetailSearch = !this.showDetailSearch
    },
    formatTimeInput(value, dataId) {
      //console.log('replaceNumber', value, dataId)
      // 숫자만 입력 가능하도록 처리
      try {
        this[dataId] = value.replace(/[^0-9]/g, '').slice(0, 6);
        this[dataId + 'Formatted'] = value.replace(/(\d{2})(?=\d)/g, '$1:');
      } catch (error) {
        console.error('replaceNumber 중 오류 발생:', error)
      }
    },
    timeFormatRule(v) {
      const pattern = /^([01]\d|2[0-3]):([0-5]\d):([0-5]\d)$/;
      return pattern.test(v) || '올바른 시간 형식이 아닙니다 (HH24:MI:SS)';
    },
    async fetchTransactions() {
      try {
        this.$loading.show('서비스 호출 내역을 조회 중입니다...')

        this.startDttm = this.startDate.replace(/-/g, '') + this.startTime;
        this.endDttm = this.endDate.replace(/-/g, '') + this.endTime;

        let response;
        if( this.$config.isSimulator) {
          response = this.$vo.getTxDataList(24);
        } else {
          response = await this.$axios.post('/api/gettxdata', {
            startDttm: this.startDttm,
          endDttm: this.endDttm,
            ...this.detailSearch,
          })
        }
        this.transactions = response.data.txDataList
      } catch (error) {
        console.error('트랜잭션 조회 중 오류 발생:', error)
      } finally {
        this.$loading.hide()
      }
    },
    formatDateTime(dateTime) {
      if (!dateTime) return ''
      return `${dateTime.substr(0, 4)}-${dateTime.substr(4, 2)}-${dateTime.substr(6, 2)} ${dateTime.substr(8, 2)}:${dateTime.substr(10, 2)}:${dateTime.substr(12, 2)}`
    },
  },
  watch: {
    startTime(newValue) {
      // startTime이 변경될 때 자동으로 콜론 추가
      if (newValue.length === 6) {
        this.displayStartTime = newValue.replace(/(\d{2})(\d{2})(\d{2})/, '$1:$2:$3');
      }
    }
  },
  mounted() {
    this.formatTimeInput(this.$util.getTime(-1, 0, ''), 'startTime')
    this.formatTimeInput(this.$util.getTime(0, 0, ''), 'endTime')
    this.fetchTransactions()
  },
}
</script>

<style scoped>
.v-data-table {
  margin-top: 20px;
}

.small-font-table {
  font-size: 0.75rem !important;
}

.small-font-table >>> .v-data-table-header {
  font-size: 0.8rem !important;
}

.small-font-table >>> .v-data-table__wrapper {
  overflow-x: auto;
}

.small-font-table td {
  padding: 0 8px !important;
  height: 32px !important;
}

.small-font-table th {
  padding: 0 8px !important;
  height: 36px !important;
}

</style>

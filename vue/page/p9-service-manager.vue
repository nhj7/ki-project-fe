<template>
  <v-container fluid>
    <v-row>
      <v-col cols="12">
        <v-card>
          
          <v-card-text>
            <v-treeview
              :items="treeItems"
              activatable="true"
              item-value="id"
              item-key="id"
              open-all              
              return-object
              class="elevation-1"
              dense              
            >
              <template v-slot:prepend="{ item, open }">
                <v-icon v-if="item.children && item.children.length > 0">
                  {{ open ? 'mdi-folder-open' : 'mdi-folder' }}
                </v-icon>
                <v-icon v-else-if="item.transactions && item.transactions.length > 0">
                  mdi-buffer
                </v-icon>
                <v-icon v-else>
                  mdi-file-document
                </v-icon>
              </template>
              <template v-slot:label="{ item }">
                <div class="d-flex justify-space-between align-center">
                  <div>
                    <strong>{{ item.serviceName || item.txName }}</strong> ({{ item.serviceName ? item.serviceID : item.txID }})
                  </div>
                  <!--div>
                    <v-btn icon small @click.stop="editService(item)">
                      <v-icon color="info">mdi-pencil</v-icon>
                    </v-btn>
                    <v-btn icon small @click.stop="deleteService(item)">
                      <v-icon color="error">mdi-delete</v-icon>
                    </v-btn>
                  </div-->
                </div>
              </template>
              <template v-slot:append="{ item }">
                <v-chip v-if="item.transactions" color="green" small>
                  {{ item.transactions.length }} 거래
                </v-chip>
              </template>
            </v-treeview>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- 서비스 등록 및 수정 다이얼로그 -->
    <v-dialog v-model="dialog" max-width="500px">
      <v-card>
        <v-card-title>
          <span class="headline">{{ isEdit ? '서비스 수정' : '서비스 등록' }}</span>
        </v-card-title>
        <v-card-text>
          <v-form ref="form" v-model="isFormValid">
            <v-text-field
              v-model="form.serviceID"
              label="서비스 ID"
              :rules="[v => !!v || '서비스 ID는 필수입니다.']"
              required
            ></v-text-field>
            <v-text-field
              v-model="form.serviceName"
              label="서비스명"
              :rules="[v => !!v || '서비스명은 필수입니다.']"
              required
            ></v-text-field>
            <v-text-field
              v-model="form.description"
              label="설명"
              :rules="[v => !!v || '설명은 필수입니다.']"
              required
            ></v-text-field>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1" text @click="closeDialog">취소</v-btn>
          <v-btn color="blue darken-1" text @click="submitForm">저장</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
module.exports = {
  name: 'ServiceManager',
  data() {
    return {
      dialog: false,
      isEdit: false,
      isFormValid: false,
      form: {
        serviceID: '',
        serviceName: '',
        description: '',
        transactions: [] // 트랜잭션 데이터 추가
      },
      activeNodes: [],
      headers: [
        { text: '서비스 ID', value: 'serviceID' },
        { text: '서비스명', value: 'serviceName' },
        { text: '설명', value: 'description' },
        { text: '액션', value: 'actions', sortable: false }
      ],
      services: [
        // 초기 서비스 데이터 예시
        {
          id : 1,
          serviceID: 'SV001',
          serviceName: '여신 한도조회',
          description: '사용자의 여신 한도를 조회하는 서비스입니다.',
          transactions: [
            {
              id : 11,
              txID: 'IF011',
              txName: 'NICE 신용조회',
              status: '성공',              
            },
            {
              id : 12,
              txID: 'IF012',
              txName: 'KCB 신용조회',
              status: '성공'
            },
            {
              id : 13,
              txID: 'IF013',
              txName: 'CSS 한도/금리 조회',
              status: '성공',              
            },
          ]
        },
        
        {
          id : 2,
          serviceID: 'SV002',
          serviceName: '모바일 뱅킹 로그인',
          description: '모바일 뱅킹 로그인 서비스입니다.',
          transactions: [
            {
              id : 20,
              txID: 'IF020',
              txName: '앱버전 체크(안드로이드/아이폰)',
              status: '성공'
            },
            {
              id : 21,
              txID: 'IF021',
              txName: 'FSB(중앙회) Open API 거래',
              status: '성공'
            },
            {
              id : 22,
              txID: 'IF022',
              txName: 'FDS 체크',
              status: '성공'
            },
            {
              id : 23,
              txID: 'IF023',
              txName: '계정계 로그인 조회',
              status: '성공'
            },
            {
              id : 24,
              txID: 'IF024',
              txName: '계정계2 로그인 조회',
              status: '성공'
            },            
          ]
        },

        {
          id : 3,
          serviceID: 'SV003',
          serviceName: '햇살론 대출실행',
          description: '여신 햇살론 상품 대출실행 서비스입니다.',
          transactions: [
            {
              id : 31,
              txID: 'IF031',
              txName: 'NICE 실시간대출조회',
              status: '성공',              
            },
            {
              id : 32,
              txID: 'IF032',
              txName: '서민금융진흥원 보증실행',
              status: '성공'
            },
            {
              id : 33,
              txID: 'IF033',
              txName: 'FSB(중앙회) 대출실행',
              status: '성공',              
            },
            {
              id : 34,
              txID: 'IF034',
              txName: '서민금융진흥원 대출통지',
              status: '성공'
            },
            {
              id : 35,
              txID: 'IF035',
              txName: '대출실행 회계 전표 처리',
              status: '성공',
            },
          ]
        },



        {
          id : 4,
          serviceID: 'SV004',
          serviceName: '여신 가상계좌 원리금 수납',
          description: '여신 상품 가상계좌 원리금 수납 서비스입니다.',
          transactions: [
            {
              id : 41,
              txID: 'IF041',
              txName: 'KIBNET 가상계좌 입금',
              status: '성공',              
            },
            {
              id : 42,
              txID: 'IF042',
              txName: 'FSB(중앙회) 원리금 수납',
              status: '성공'
            },
            {
              id : 43,
              txID: 'IF043',
              txName: 'FSB(중앙회) 원리금 수납',
              status: '성공',              
            },            
            {
              id : 45,
              txID: 'IF045',
              txName: '회계 전표 처리',
              status: '성공',
            },
          ]
        },


      ]
    };
  },
  computed: {
    treeItems() {
      return this.services.map(service => ({
        ...service,
        children: service.transactions ? service.transactions.map(tx => ({
          ...tx,
          serviceID: service.serviceID
        })) : []
      }));
    }
  },
  methods: {
    openDialog() {
      this.dialog = true;
      this.isEdit = false;
      this.resetForm();
    },
    closeDialog() {
      this.dialog = false;
      this.resetForm();
    },
    resetForm() {
      this.form = {
        serviceID: '',
        serviceName: '',
        description: '',
        transactions: []
      };
      if (this.$refs.form) {
        this.$refs.form.resetValidation();
      }
    },
    submitForm() {
      if (this.$refs.form.validate()) {
        if (this.isEdit) {
          this.updateService();
        } else {
          this.addService();
        }
        this.closeDialog();
      }
    },
    addService() {
      // 중복된 서비스 ID 확인
      const exists = this.services.find(service => service.serviceID === this.form.serviceID);
      if (exists) {
        this.$msg.showSnackbar('이미 존재하는 서비스 ID입니다.');
        return;
      }
      this.services.push({ ...this.form, transactions: [] });
      this.$msg.showSnackbar('서비스가 성공적으로 등록되었습니다.');
    },
    editService(item) {
      this.dialog = true;
      this.isEdit = true;
      this.form = { ...item };
    },
    updateService() {
      const index = this.services.findIndex(service => service.serviceID === this.form.serviceID);
      if (index !== -1) {
        this.$set(this.services, index, { ...this.form });
        this.$msg.showSnackbar('서비스가 성공적으로 수정되었습니다.');
      }
    },
    deleteService(item) {
      const index = this.services.indexOf(item);
      if (index !== -1) {
        this.services.splice(index, 1);
        this.$msg.showSnackbar('서비스가 성공적으로 삭제되었습니다.');
      }
    }
  },
  mounted() {
    //this.$msg.showSnackbar('서비스가 성공적으로 조회되었습니다.');
  }
};
</script>

<style scoped>
.headline {
  font-weight: bold;
}

.fixed-table {
  table-layout: fixed;
  width: 100%;
}

.small-select {
  font-size: 0.85rem;
  width: 80%;
}

.small-select ::v-deep .v-input__control {
  max-height: 20px;
}

.small-select ::v-deep .v-input__slot {
  max-height: 20px;
}

.small-select ::v-deep .v-select__selection {
  margin-top: 0;
  margin-bottom: 0;
}
</style>
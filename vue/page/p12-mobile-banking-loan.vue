<template>
  <v-container fluid>
    <v-row justify="center">
      <v-col cols="12" sm="8" md="6">
        <!-- 대출신청 및 한도조회 폼 -->
        <v-card class="mb-4 pb-0">
          <v-card-title class="text-center">대출신청 및 한도조회</v-card-title>
          <v-card-text dense>
            <v-form ref="form" v-model="valid">
              <v-row dense>
                <v-col cols="12">
                  <v-text-field v-model="loanData.name" label="이름" outlined dense
                    :rules="[rules.required]"></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-text-field v-model="loanData.phone" label="전화번호" outlined dense
                    :rules="[rules.required, rules.phone]"></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-text-field v-model="loanData.amount" label="대출 금액" outlined dense
                    :rules="[rules.required, rules.number]"></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-text-field v-model="loanData.period" label="대출 기간 (개월)" outlined dense
                    :rules="[rules.required, rules.number]"></v-text-field>
                </v-col>
              </v-row>
              <v-row dense>
                <v-col cols="6">
                  <v-text-field v-model="loanData.txSecond" label="처리 시간(초)" outlined dense
                    :rules="[rules.required, rules.number]"></v-text-field>
                </v-col>
                <v-col cols="6">
                  <v-select v-model="loanData.txStatus" :items="['처리완료', '처리오류']" label="처리 상태" outlined dense
                    :rules="[rules.required]"></v-select>
                </v-col>
              </v-row>
              <v-row dense>
                <!--v-col cols="6">
                  <v-btn :color="$config.color_btn" block @click="submitLoanApplication" small dense>신청하기</v-btn>              
                </v-col>-->
                <v-col cols="6">
                  <v-btn :color="$config.color_btn" block @click="checkLoanLimit" small dense>한도조회</v-btn>
                </v-col>
              </v-row>              
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
const comp = module.exports = {
  data() {
    return {
      valid: false,
      loanData: {
        name: '한경록',
        phone: '010-1234-5678',
        amount: '1000000',
        period: '12',
        txSecond: '1',
        txStatus: '처리완료'
      },
      rules: {
        required: value => !!value || '필수 입력 항목입니다.',
        phone: value => /^\d{3}-\d{3,4}-\d{4}$/.test(value) || '유효한 전화번호를 입력하세요.',
        number: value => !isNaN(value) || '숫자만 입력 가능합니다.'
      }
    };
  },
  methods: {
    async submitLoanApplication() {
      if (this.$refs.form.validate()) {
        // 대출 신청 데이터를 처리하는 로직을 여기에 추가합니다.
        console.log('대출 신청 데이터:', this.loanData);

        this.$loading.show();
        await this.$util.sleep(this.loanData.txSecond * 1000);
        this.$loading.hide();
        this.$msg.show({
          messageTitle: '모바일뱅킹 대출신청',
          messageCode: '0000',
          messageContent: '대출 신청이 완료되었습니다.',
          isError: false,
          showErrorDetails: false,
          errorDetails: ''
        });
      }
    },
    async checkLoanLimit() {
      if (this.$refs.form.validate()) {
        // 한도 조회 로직을 여기에 추가합니다.
        console.log('한도 조회 데이터:', this.loanData);
        this.$loading.show();
        await this.$util.sleep(this.loanData.txSecond * 1000);
        this.$loading.hide();
        this.$msg.show({
          messageTitle: '모바일뱅킹 대출신청',
          messageCode: '0000',
          messageContent: '한도 조회가 완료되었습니다.',
          isError: false,
          showErrorDetails: false,
          errorDetails: ''
        });
      }
    }
  }
};
</script>

<style scoped>
/* 모바일 대출신청 및 한도조회 스타일 추가 */
.v-card-title {
  font-size: 1.5rem;
  font-weight: bold;
}

.v-btn {
  font-size: 1.2rem;
  padding: 1rem;
}
</style>
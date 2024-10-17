<template>
  <v-container fluid>
    <v-row justify="center">
      <v-col cols="12" sm="8" md="6">
        <!-- 간편이체 폼 -->
        <v-card class="mb-4 pb-0">
          <v-card-title class="text-center">간편이체</v-card-title>
          <v-card-text dense>
            <v-form ref="form" v-model="valid">
              <v-row dense>
                <v-col cols="12">
                  <v-text-field v-model="transferData.sender" label="보내는 사람" outlined dense
                    :rules="[rules.required]"></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-text-field v-model="transferData.receiver" label="받는 사람" outlined dense
                    :rules="[rules.required]"></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-text-field  :value="formattedAmount" @input="updateAmount"
                    label="이체 금액" outlined dense :rules="[rules.required, rules.number]"></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-text-field v-model="transferData.date" label="이체 날짜" outlined dense :rules="[rules.required]"
                    type="date"></v-text-field>
                </v-col>
              </v-row>
              <v-row dense>
                <v-col cols="6">
                  <v-text-field  v-model="transferData.txSecond"
                    label="처리 시간(초)" outlined dense :rules="[rules.required, rules.number]"></v-text-field>
                </v-col>
                <v-col cols="6">
                  <v-select v-model="transferData.txStatus" :items="['처리완료', '처리오류']"
                    label="처리 상태" outlined dense :rules="[rules.required]"></v-select>
                </v-col>
              </v-row>
              <v-btn :color="$config.color_btn" block @click="submitTransfer" small dense>이체하기</v-btn>
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
      transferData: {
        sender: '나형주',
        receiver: '이민호',
        amount: '100000000',
        date: this.$util.formatDate(new Date(), '-'),
        txSecond: '2',
        txStatus: '처리완료'
      },
      rules: {
        required: value => !!value || '필수 입력 항목입니다.',
        number: value => {
          //console.log('value', value);
          if (!value) return true;
          return !isNaN(value.replace(/,/g, '')) || '숫자만 입력 가능합니다.';
        }
      }
    };
  },
  computed: {
    formattedAmount() {
      const formattedAmount = this.$util.numberWithComma(this.transferData.amount);
      console.log('formattedAmount', formattedAmount);
      return formattedAmount;
    }
  },
  methods: {
    async submitTransfer() {
      if (this.$refs.form.validate()) {
        // 이체 데이터를 처리하는 로직을 여기에 추가합니다.
        console.log('이체 데이터:', { header : { 
          prg_id : 'P11',
          prg_name : '간편이체',
          tx_id : 'T11',
          tx_name : '간편이체',
          tx_time : new Date().toISOString(),
          user_id : this.$session.userId,
          user_name : this.$session.userName,
          
        }, body : {
          ...this.transferData
        } });


        this.$loading.show('간편 이체 처리 중입니다.');
        await this.$util.sleep(this.transferData.txSecond * 1000);
        this.$loading.hide();
        //alert('이체가 완료되었습니다.');
        this.$msg.show({
          messageTitle: '모바일뱅킹 간편 이체',
          messageCode: this.transferData.txStatus === '처리완료' ? '0000' : '9999',
          messageContent: this.transferData.txStatus === '처리완료' ? '이체가 완료되었습니다.' : '이체가 실패하였습니다.',
          isError: this.transferData.txStatus === '처리오류',
          showErrorDetails: this.transferData.txStatus === '처리오류',
          errorDetails: this.transferData.txStatus === '처리오류' ? '처리 중 알수 없는 오류가 발생하였습니다.' : ''
        });
      }
    },
    updateAmount(value) {
      // 콤마 제거 후 숫자만 추출

      console.log('value', value);
      this.transferData.amount = value.replace(/[^\d]/g, '');
    }
  }
};
</script>

<style scoped>
/* 모바일 뱅킹 스타일 추가 */
.v-card-title {
  font-size: 1.5rem;
  font-weight: bold;
}

.v-btn {
  font-size: 1.2rem;
  padding: 1rem;
}
</style>
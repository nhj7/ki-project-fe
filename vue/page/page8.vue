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
                  <v-text-field v-model="transferData.amount" label="이체 금액" outlined dense
                    :rules="[rules.required, rules.number]"></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-text-field v-model="transferData.date" label="이체 날짜" outlined dense :rules="[rules.required]"
                    type="date"></v-text-field>
                </v-col>
              </v-row>
              <v-btn color="primary" block @click="submitTransfer">이체하기</v-btn>
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
        sender: '',
        receiver: '',
        amount: '',
        date: ''
      },
      rules: {
        required: value => !!value || '필수 입력 항목입니다.',
        number: value => !isNaN(value) || '숫자만 입력 가능합니다.'
      }
    };
  },
  methods: {
    submitTransfer() {
      if (this.$refs.form.validate()) {
        // 이체 데이터를 처리하는 로직을 여기에 추가합니다.
        console.log('이체 데이터:', this.transferData);
        alert('이체가 완료되었습니다.');
      }
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
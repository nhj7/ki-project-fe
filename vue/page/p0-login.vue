<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title class="headline">로그인</v-card-title>
          <v-card-text>
            <v-form ref="form" v-model="valid" lazy-validation>
              <v-text-field ref="userId" v-model="userId" :rules="userIdRules" label="아이디"
                :validate-on-blur="false"></v-text-field>
              <v-text-field v-model="password" :rules="passwordRules" label="패스워드" type="password"
                @keypress.enter="login" :validate-on-blur="false"></v-text-field>
              <v-btn color="success" @click="login">로그인</v-btn>
            </v-form>

            <v-divider class="mt-2 mb-2"></v-divider>

            <v-alert v-if="loginError" type="error" dismissible>{{
              loginErrorMessage
              }}</v-alert>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
// import axios from 'axios';
const comp = (module.exports = {
  data() {
    return {
      valid: false,
      userId: "",
      password: "",
      loginError: false,
      loginErrorMessage: "로그인 제한 중입니다.",
      userIdRules: [(v) => !!v || "아이디를 입력해주세요"],
      passwordRules: [(v) => !!v || "패스워드를 입력해주세요"],
    };
  },
  methods: {
    async login() {
      if (this.$refs.form.validate()) {
        try {
          const response = await axios.get("/mock/login_success.json", {
            userId: this.userId,
            password: this.password,
          });

          console.log("response", response);
          if (response.data?.header?.resultCode === "0000") {
            // 로그인 성공 시 페이지 이동
            Object.assign(this.$session, response.data.body);
            this.$router.push("/live-transaction-analytics");
          } else {
            // 로그인 실패 시 에러 메시지 표시
            this.$session.clear();
            this.loginErrorMessage = response.data.message || "로그인 실패";
            this.loginError = true;
          }
        } catch (error) {
          console.log("error", error);
          // API 호출 실패 시 에러 메시지 표시
          this.loginErrorMessage = error.response.data.message || "서버 오류";
          this.loginError = true;
        }
      }
    },
  },
  mounted() {
    this.$nextTick(() => {
      this.$refs.userId.focus();
    });
  },
});
</script>
<style scoped>
.v-container {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
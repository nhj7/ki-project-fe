<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" md="6">
        <v-card>
          <v-card-title class="headline">로그인</v-card-title>
          <v-card-text>
            <v-form ref="form" v-model="valid" lazy-validation>
              <v-text-field ref="userId" v-model="userId" :rules="userIdRules" label="아이디"
                validate-on-blur data-test="userId-input" hint="제공받은 아이디를 입력해주세요." clearable @input="userIdRules = []"></v-text-field>
              <v-text-field v-model="password" :rules="passwordRules" label="패스워드" type="password"
                @keypress.enter="login" :validate-on-blur="false" autocomplete="current-password" data-test="password-input" hint="제공받은 패스워드를 입력해주세요." clearable @input="passwordRules = []"></v-text-field>
              <v-btn color="success" @click="login" data-test="login-button" class="mt-4">로그인</v-btn>
            </v-form>

            <v-divider class="mt-2 mb-2"></v-divider>

            <v-alert v-if="loginError" type="error" dismissible data-test="login-error-message">{{
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
      userIdRules: [],
      passwordRules: [],
    };
  },
  methods: {
    async login() {

      this.userIdRules = [(v) => !!v || "아이디를 입력해주세요"];
      this.passwordRules = [(v) => !!v || "패스워드를 입력해주세요"];

      if (this.$refs.form.validate()) {
        try {
          /*
          const response = await axios.get("/mock/login-signin.json", {
            userId: this.userId,
            password: this.password,
          });
          */


          this.$loading.show('로그인 중...');
          const response = await request("/api/login-signin", "POST", {
            username: this.userId,
            password: this.password,
          });

          console.log("response", response);
          if (response.data?.header?.resultCode === "0000") {
          //if (response.data?.success) {

            //response.data.result.data.userId = this.userId;
            //response.data.result.data.userName = this.userId;           
            
            // 로그인 성공 시 페이지 이동
            Object.assign(this.$session, response.data.body);
            localStorage.setItem("accessToken", response.data.body.accessToken);
            localStorage.setItem("refreshToken", response.data.body.refreshToken);
            this.$router.push("/live-transaction-analytics");
          } else {
            // 로그인 실패 시 에러 메시지 표시
            this.$session.clear();
            this.loginErrorMessage = "로그인 실패";
            this.loginError = true;
          }
        } catch (error) {
          console.log("error", error);
          // API 호출 실패 시 에러 메시지 표시
          this.loginErrorMessage = error.response.data.message || "서버 오류";
          this.loginError = true;
        } finally {
          this.$loading.hide();
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
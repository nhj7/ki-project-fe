<template>
    <v-dialog v-model="dialog" max-width="800px">
        <v-card>
            <v-card-title class="headline">계정 설정</v-card-title>
            <v-card-text>
                <v-form ref="form" v-model="valid" lazy-validation>
                    <v-text-field v-model="userId" label="사용자 ID" readonly></v-text-field>
                    <v-text-field v-model="userName" :rules="userNameRules" label="사용자명"></v-text-field>
                    <v-text-field v-model="currentPassword" :rules="passwordRules" label="현재 비밀번호"
                        type="password"></v-text-field>
                    <v-text-field v-model="newPassword" :rules="passwordRules" label="새 비밀번호"
                        type="password"></v-text-field>
                    <v-text-field v-model="confirmPassword" :rules="confirmPasswordRules" label="새 비밀번호 확인"
                        type="password"></v-text-field>
                    <v-btn color="success" @click="updateAccountSettings">저장</v-btn>
                </v-form>
            </v-card-text>
        </v-card>
    </v-dialog>
</template>

<script>
const comp = module.exports = {
    props: ['value', 'alarms'],
    data() {
        return {
            valid: false,
            userId: this.$session.userId,
            userName: this.$session.userName,
            currentPassword: '',
            newPassword: '',
            confirmPassword: '',
            userNameRules: [
                v => !!v || '사용자명을 입력하세요',
                v => (v && v.length <= 20) || '사용자명은 20자 이내여야 합니다',
            ],
            passwordRules: [
                v => !!v || '비밀번호를 입력하세요',
                v => (v && v.length >= 6) || '비밀번호는 최소 6자 이상이어야 합니다',
            ],
            confirmPasswordRules: [
                v => !!v || '비밀번호 확인을 입력하세요',
                v => v === this.newPassword || '비밀번호가 일치하지 않습니다',
            ],
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
        updateAccountSettings() {
            if (this.$refs.form.validate()) {
                // 여기서 실제 계정 설정 업데이트 API 호출을 수행해야 합니다.
                console.log('계정 설정 업데이트:', {
                    userId: this.userId,
                    userName: this.userName,
                    currentPassword: this.currentPassword,
                    newPassword: this.newPassword,
                });
                // 예시로 로컬 세션 업데이트
                this.$session.userName = this.userName;
                this.$router.push('/');
            }
        },
    },
};
</script>
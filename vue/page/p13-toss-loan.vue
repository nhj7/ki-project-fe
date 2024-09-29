<template>

    <v-container fluid>
        <!-- 대출 승인 가능성 표시 -->
        <v-row justify="center">
            <v-col cols="12" sm="8" md="6">
                <v-card class="mb-4 pb-0">
                    <v-card-text class="text-center">
                        <v-row align="center" justify="center">
                            <v-col cols="4">
                                <v-img src="/assets/toss-ci.jpg" height="100" width="100" class="mx-auto"></v-img>
                                <div class="text-h6 font-weight-bold primary--text">TOSS</div>
                            </v-col>
                            <v-col cols="4">
                                <v-progress-circular :value="99" color="primary" size="150" width="15">
                                    <div class="text-h4 font-weight-bold">99%</div>
                                </v-progress-circular>
                                <div class="mt-2">승인 가능성</div>
                            </v-col>
                            <v-col cols="4">
                                <div class="text-h4 font-weight-bold">1000점</div>
                                <div>신용점수</div>
                            </v-col>
                        </v-row>
                    </v-card-text>
                </v-card>

                <!-- 대출 비교 옵션 -->
                <v-tabs v-model="tab" background-color="transparent" color="primary" grow>
                    <v-tab>여러 금융사 비교</v-tab>
                    <v-tab>토스뱅크 상품</v-tab>
                </v-tabs>

                <v-tabs-items v-model="tab">
                    <v-tab-item>
                        <v-card outlined class="mb-4">
                            <v-card-text>
                                <v-row dense>
                                    <v-col cols="12" sm="6">
                                        <v-text-field v-model="loanData.txSecond" label="처리 시간(초)" outlined dense
                                            :rules="[rules.required, rules.number]"></v-text-field>
                                    </v-col>
                                    <v-col cols="12" sm="6">
                                        <v-select v-model="loanData.txStatus" :items="['처리완료', '처리오류']" label="처리 상태"
                                            outlined dense :rules="[rules.required]"></v-select>
                                    </v-col>
                                </v-row>
                            </v-card-text>
                        </v-card>
                        <!-- 신용대출 한도 확인 버튼 -->
                        <v-btn color="primary" x-large block class="my-4" @click="checkLoanLimit">
                            신용대출 한도 확인하기
                        </v-btn>

                        <!-- 주택담보대출 비교 -->
                        <v-card outlined class="mb-4">
                            <v-card-title>
                                <v-icon left>mdi-home</v-icon>
                                주택담보대출
                            </v-card-title>
                            <v-card-text>
                                <div class="text-h6 font-weight-bold">최저 3.56%</div>
                                <div>14개 금융사 이자율 비교</div>
                            </v-card-text>
                        </v-card>

                        <!-- 카드론 정보 -->
                        <!--v-card outlined class="mb-4">
                            <v-card-title>
                                <v-icon left>mdi-credit-card</v-icon>
                                카드론
                            </v-card-title>
                            <v-card-text>
                                <div>즉시 입금</div>
                                <div>이자 지원 혜택</div>
                            </v-card-text>
                        </v-card-->

                        <!-- 대출 갈아타기 도구 -->
                        <v-card outlined class="mb-4">
                            <v-card-title>
                                <v-icon left>mdi-swap-horizontal</v-icon>
                                대출 갈아타기
                            </v-card-title>
                            <v-card-text>
                                <div>신용대출, 주택담보대출, 전세자금대출 등</div>
                            </v-card-text>
                        </v-card>
                    </v-tab-item>

                    <v-tab-item>
                        <!-- 토스뱅크 상품 내용 -->
                        <v-card outlined class="my-4">
                            <v-card-title>토스뱅크 대출 상품</v-card-title>
                            <v-card-text>
                                토스뱅크의 대출 상품 정보가 여기에 표시됩니다.
                            </v-card-text>
                        </v-card>
                    </v-tab-item>
                </v-tabs-items>

                <!-- 하단 메뉴 옵션 -->
                <v-list>
                    <v-list-item v-for="(item, index) in menuItems" :key="index" @click="navigateTo(item.route)">
                        <v-list-item-icon>
                            <v-icon>{{ item.icon }}</v-icon>
                        </v-list-item-icon>
                        <v-list-item-content>
                            <v-list-item-title>{{ item.title }}</v-list-item-title>
                        </v-list-item-content>
                        <v-list-item-icon>
                            <v-icon>mdi-chevron-right</v-icon>
                        </v-list-item-icon>
                    </v-list-item>
                </v-list>
            </v-col>
        </v-row>
    </v-container>

</template>

<script>
const comp = module.exports = {
    name: 'LoanApprovalScreen',
    data() {
        return {
            tab: null,
            menuItems: [
                { title: '내 대출관리', icon: 'mdi-account', route: '/loan-management' },
                { title: '대출 이자 계산기', icon: 'mdi-calculator', route: '/interest-calculator' },
                { title: '아파트 대출한도 계산기', icon: 'mdi-home-city', route: '/apartment-loan-calculator' },
            ],
            loanData: {
                txSecond: 1,
                txStatus: '처리완료',
            },
            rules: {
                required: value => !!value || '필수 입력 항목입니다.',
                phone: value => /^\d{3}-\d{3,4}-\d{4}$/.test(value) || '유효한 전화번호를 입력하세요.',
                number: value => !isNaN(value) || '숫자만 입력 가능합니다.'
            }
        };
    },
    methods: {
        navigateTo(route) {
            // 실제 라우팅 로직 구현
            console.log('Navigating to:', route);
        },
        async checkLoanLimit() {
            //if (this.$refs.form.validate()) {
                // 한도 조회 로직을 여기에 추가합니다.
                console.log('한도 조회 데이터:', this.loanData);
                this.$loading.show();
                await this.$util.sleep(this.loanData.txSecond * 1000);
                this.$loading.hide();
                this.$msg.show({
                    messageTitle: '토스 비교금리 조회',
                    messageCode: '0000',
                    messageContent: '토스 비교금리 조회가 완료되었습니다.',
                    isError: false,
                    showErrorDetails: false,
                    errorDetails: ''
                });
            //}
        }
    },
};
</script>

<style scoped>
.v-btn {
    text-transform: none;
}
</style>
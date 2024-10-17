<template>
    <v-container fluid v-bar>
        <v-row>
            <v-col>
                <!-- 조회 조건 -->
                <v-card class="mb-4 pb-0">
                    <v-card-text dense>
                        <v-row dense>
                            <v-col cols="6" md="2" sm="3" xs="4">
                                <v-menu v-model="startDateMenu" :close-on-content-click="false"
                                    transition="scale-transition" offset-y max-width="290px" min-width="290px">
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-text-field v-model="filters.startDate" label="시작 날짜" readonly v-bind="attrs"
                                            v-on="on" dense></v-text-field>
                                    </template>
                                    <v-date-picker v-model="filters.startDate" no-title
                                        @input="startDateMenu = false"></v-date-picker>
                                </v-menu>
                            </v-col>
                            <v-col cols="6" md="2" sm="3" xs="4">
                                <v-menu v-model="endDateMenu" :close-on-content-click="false"
                                    transition="scale-transition" offset-y max-width="290px" min-width="290px">
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-text-field v-model="filters.endDate" label="종료 날짜" readonly v-bind="attrs"
                                            v-on="on" dense hide-details></v-text-field>
                                    </template>
                                    <v-date-picker v-model="filters.endDate" no-title
                                        @input="endDateMenu = false"></v-date-picker>
                                </v-menu>
                            </v-col>
                            <v-col cols="12" sm="4" md="3">
                                <v-select v-model="filters.ruleId" :items="ruleIds" item-text="text" item-value="value"
                                    label="규칙 ID" dense hide-details></v-select>
                            </v-col>
                            <v-col cols="12" sm="12" md="12" class="d-flex justify-end align-center">
                                <v-btn :color="$config.color_btn" @click="search" small dense>조회</v-btn>
                            </v-col>
                        </v-row>
                    </v-card-text>
                </v-card>

                <!-- 규칙 감지 목록 -->
                <v-data-table :headers="headers" :items="ruleDetections" :items-per-page="10"
                    class="elevation-1 custom-table" :mobile-breakpoint="0" @click:row="$vo.openDetectedDialog" 
                    >
                    <template v-slot:[`item.txRatioYn`]="{ item }">
                        {{ item.txRatioYn == 'Y' ? '예' : '아니오' }}
                    </template>
                    <template v-slot:[`item.txErrRatioYn`]="{ item }">
                        {{ item.txErrRatioYn == 'Y' ? '예' : '아니오' }}
                    </template>
                    <template v-slot:[`item.actions`]="{ item }">
                        <v-btn small @click="$vo.openDetectedDialog(item)">상세</v-btn>
                    </template>
                    
                </v-data-table>
            </v-col>
        </v-row>
    </v-container>
</template>

<script>
const comp = module.exports = {
    data() {
        return {
            startDateMenu: false,
            endDateMenu: false,
            filters: {
                startDate: '',
                endDate: '',
                ruleId: '전체',
            },
            ruleIds: [],
            ruleDetections: [{
                ruleId: '1',
                ruleNm: '규칙1',
                svcId: '1',
                svcNm: '서비스1',
                txRatio: '100',
                txRatioYn: 'Y',
                txErrRatio: '100',
                txErrRatioYn: 'Y',
            }],
            headers: [
                { text: '규칙 ID', value: 'ruleId' },
                { text: '규칙명', value: 'ruleNm' },
                { text: '서비스 ID', value: 'svcId' },
                { text: '서비스명', value: 'svcNm' },
                { text: '거래량 비율', value: 'txRatio' },
                { text: '거래감지', value: 'txRatioYn' },
                { text: '오류율', value: 'txErrRatio' },
                { text: '오류감지', value: 'txErrRatioYn' },
                { text: '감지 시작 시간', value: 'afStartdttm' },
                { text: '상태', value: 'detectStatus' },
                { text: '액션', value: 'actions', sortable: false },
            ],
        };
    },
    methods: {
        async search() {
            try {
                this.$loading.show('규칙 감지 목록을 불러오는 중입니다...');
                // API 호출 로직 구현
                const response = await this.$axios.post('/api/rule-detections', {
                    startDate: this.filters.startDate.replace(/-/g, ''),
                    endDate: this.filters.endDate.replace(/-/g, ''),
                    ...(this.filters.ruleId !== '전체' ? { ruleId: this.filters.ruleId } : {}),
                });
                console.log('규칙 감지 목록 : ', response);
                for (let i = 0; i < response.data.length; i++) {
                    response.data[i].afStartdttm = this.$util.formatDttm(response.data[i].afStartdttm, '-', ':');
                    response.data[i].bfStartdttm = this.$util.formatDttm(response.data[i].bfStartdttm, '-', ':');
                    
                    if(!response.data[i].detectStatus){
                        response.data[i].detectStatus = '확인전';
                    }
                }
                this.ruleDetections = response.data;
            } catch (error) {
                console.error('규칙 감지 목록을 불러오는 중 오류가 발생했습니다:', error);
                this.ruleDetections = [];
            } finally {
                this.$loading.hide();
            }
        },
        getYnColor(yn) {
            return yn === 'Y' ? 'green' : 'red';
        },
        showDetails(item) {
            console.log('상세 정보:', item);
            // 상세 정보 표시 로직 구현
        },
        async fetchRuleIds() {
            try {
                const response = await this.$axios.post('/api/rule-list');
                console.log('규칙 ID 목록 조회 응답 : ', response);
                this.ruleIds = ['전체', ...response.data.body.rules.map(rule => {
                    return {
                        text: rule.id + ' - ' + rule.name,
                        value: rule.id
                    }
                })];
            } catch (error) {
                console.error('규칙 ID 목록을 불러오는 중 오류가 발생했습니다:', error);
                this.ruleIds = [];
            }
        },
    },
    created() {
        const dates = this.$util.setLastWeekDates();
        this.filters.startDate = dates.startDate;
        this.filters.endDate = dates.endDate;

        //console.log("app.vue created", this.$router);
    },
    async mounted() {
        await this.fetchRuleIds();
        await this.search();
    },
};
</script>

<style scoped></style>

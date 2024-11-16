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
                            <v-col cols="12" sm="4" md="3">
                                <v-select v-model="filters.detectStatus" :items="['전체', '확인전','확인중','조치중','모니터링중','완료']" item-text="text" item-value="value"
                                    label="감지상태" dense hide-details></v-select>
                            </v-col>
                            <v-col cols="12" sm="12" md="12" class="d-flex justify-end align-center">
                                <v-btn :color="$config.color_btn" @click="search" small dense>조회</v-btn>
                            </v-col>
                        </v-row>
                    </v-card-text>
                </v-card>

                
                <v-data-table :headers="headers" :items="ruleDetections" :items-per-page="10" 
                class="elevation-1 custom-table"  @click:row="$vo.openDetectedDialog">
                    <template v-slot:[`header.select`]>
                        <v-checkbox
                            v-model="selectAll"
                            @click="toggleSelectAll"
                            hide-details small
                        ></v-checkbox>
                    </template>
                    <template v-slot:[`item.select`]="{ item }">
                        <v-checkbox v-model="item.select" hide-details small @click.stop></v-checkbox>
                    </template>
                    <template v-slot:[`item.detectstatus`]="{ item }">
                        <v-chip :color="getDetectStatusColor(item.detectStatus)" small outlined>
                            {{ item.detectStatus }}
                        </v-chip>
                    </template>
                    <template v-slot:[`item.actions`]="{ item }">
                        <v-btn small @click="$vo.openDetectedDialog(item)">상세</v-btn>
                    </template>
                    
                </v-data-table>
            </v-col>
            
        </v-row>
        <v-row>
            <v-col cols="12" sm="12" md="1" class="d-flex align-center">
                <v-select :items="['확인전', '확인중', '조치중', '모니터링중', '완료']" item-text="text" item-value="value"
                    label="상태변경" dense hide-details v-model="batchChangeStatusValue"></v-select>
            </v-col>
            <v-col cols="12" sm="12" md="2" class="d-flex align-center">
                <v-btn :color="$config.color_btn" small @click="batchChangeStatus">일괄상태변경</v-btn>
            </v-col>
            
        </v-row>
    </v-container>
</template>

<script >
const comp = module.exports = {
    data() {
        return {
            startDateMenu: false,
            endDateMenu: false,
            selectAll : false,
            batchChangeStatusValue : '',
            filters: {
                startDate: '',
                endDate: '',
                ruleId: '전체',
                detectStatus : '전체',
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
                { text: '전체선택', value: 'select', sortable: false, align: 'center', width: '100px' },
                { text: '서비스 ID', value: 'svcId' },
                { text: '서비스명', value: 'svcNm' },
                { text: '규칙 ID', value: 'ruleId' },
                { text: '규칙명', value: 'ruleNm' },
                
                { text: '거래증감율(%)', value: 'txRatio' },
                
                { text: '오류증감율(%)', value: 'txErrRatio' },
                
                { text: '감지시간', value: 'afEnddttm' },
                { text: '상태', value: 'detectstatus', sortable: false },
                { text: '액션', value: 'actions', sortable: false },
            ],
        };
    },
    methods: {

        async batchChangeStatus() {
            console.log('batchChangeStatus : ', this.batchChangeStatusValue);
            try {
                this.$loading.show('일괄상태변경 중입니다...');
                for(let i = 0; i < this.ruleDetections.length; i++){
                    if(this.ruleDetections[i].select){
                        const response = await axios.post('/api/rule-detect-update', { id: this.ruleDetections[i].id + '', detectStatus: this.batchChangeStatusValue });
                        console.log('일괄상태변경 응답 : ', response);
                        this.ruleDetections[i].detectStatus = this.batchChangeStatusValue;
                    }
                    //await new Promise(resolve => setTimeout(resolve, 50));
                }
            } catch (error) {
                console.error('일괄상태변경 오류 : ', error);
            } finally {
                this.$loading.hide();
            }
        },
        toggleSelectAll() {
            this.ruleDetections.forEach(item => {
                item.select = this.selectAll;
            });
        },

        getDetectStatusColor(status) {
            switch (status) {
                case '확인전':
                    return 'red';
                case '확인중':
                    return 'orange';
                case '조치중':
                    return 'blue';
                case '모니터링중':
                    return 'green';
                case '완료':
                    return 'grey';
                default:
                    return 'grey';
            }
        },
        async search() {
            try {
                this.$loading.show('규칙 감지 목록을 불러오는 중입니다...');
                // API 호출 로직 구현
                let response;
                if( this.$config.isSimulator) {
                    response = this.$vo.getRuleDetectionsResponse();
                } else {
                    response = await this.$axios.post('/api/rule-detections', {
                        startDate: this.filters.startDate.replace(/-/g, ''),
                        endDate: this.filters.endDate.replace(/-/g, ''),
                        
                        ...(this.filters.ruleId !== '전체' ? { ruleId: this.filters.ruleId } : {}),
                        ...(this.filters.detectStatus !== '전체' ? { detectStatus: this.filters.detectStatus } : {}),
                    });
                }
                console.log('규칙 감지 목록 : ', response);
                for (let i = 0; i < response.data.length; i++) {
                    response.data[i].afStartdttm = this.$util.formatDttm(response.data[i].afStartdttm, '-', ':');
                    response.data[i].afEnddttm = this.$util.formatDttm(response.data[i].afEnddttm, '-', ':');
                    response.data[i].bfStartdttm = this.$util.formatDttm(response.data[i].bfStartdttm, '-', ':');
                    response.data[i].select = false;
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

                if( this.$config.isSimulator) {
                    response = this.$vo.getRuleListResponse();
                } else {
                    response = await this.$axios.post('/api/rule-list');
                }
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
                this.$msg.show({
                    messageTitle: this.$route.meta.title,
                    messageCode: error?.code,
                    messageContent: '규칙 ID 목록을 불러오는 중 오류가 발생했습니다.',
                    isError: true,
                    showErrorDetails: true,
                    errorDetails: `${error?.name} - ${error?.message} - ${error?.config?.url} - ${error?.config?.method}`
                });
                
            }
        },
    },
    created() {        
        this.filters.startDate = this.$util.getDate(-1, '-');
        this.filters.endDate = this.$util.getDate(0, '-');

        //console.log("app.vue created", this.$router);
    },
    async mounted() {
        await this.fetchRuleIds();
        await this.search();
    },
};
</script>

<style scoped></style>

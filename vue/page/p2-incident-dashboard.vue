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
                            <v-col cols="6" md="1" sm="2" xs="4">
                                <!--v-text-field v-model="filters.startTimeFormatted" label="시작 시간" persistent-hint
                                    @input="formatTimeInput($event, 'startTime')" hide-details dense></v-text-field-->
                                <v-select v-model="filters.startTime"
                                    :items="Array.from({length: 24}, (_, i) => i.toString().padStart(2, '0'))"
                                    label="시작 시간" dense hide-details :disabled="filters.useOnlyDate"></v-select>
                            </v-col>
                            <v-col cols="6" md="1" sm="2" xs="4">
                                <v-select v-model="filters.startTimeMinute"
                                    :items="Array.from({length: 60}, (_, i) => i.toString().padStart(2, '0'))"
                                    label="시작 분" dense hide-details :disabled="filters.useOnlyDate"></v-select>
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
                            <v-col cols="6" md="1" sm="2" xs="4">
                                <v-select v-model="filters.endTime"
                                    :items="Array.from({length: 24}, (_, i) => i.toString().padStart(2, '0'))"
                                    label="종료 시간" dense hide-details :disabled="filters.useOnlyDate"></v-select>
                                <!--v-text-field v-model="filters.endTimeFormatted" label="종료 시간" persistent-hint
                                    @input="formatTimeInput($event, 'endTime')" hide-details dense></v-text-field-->
                            </v-col>
                            <v-col cols="6" md="1" sm="2" xs="4">
                                <v-select v-model="filters.endTimeMinute"
                                    :items="Array.from({length: 60}, (_, i) => i.toString().padStart(2, '0'))"
                                    label="종료 분" dense hide-details :disabled="filters.useOnlyDate"></v-select>
                            </v-col>

                            <!-- 
                            <v-col cols="12" sm="8" md="6">
                                <v-select v-model="filters.systems" :items="systems" label="시스템" multiple chips
                                    dense hide-details>

                                    <template v-slot:prepend-item>
                                        <v-list-item ripple @mousedown.prevent @click="toggleAll('systems')">
                                            <v-list-item-action>
                                                <v-icon :color="isAllSelected('systems') ? 'primary darken-4' : ''">
                                                    {{ getIcon('systems') }}
                                                </v-icon>
                                            </v-list-item-action>
                                            <v-list-item-content>
                                                <v-list-item-title>전체</v-list-item-title>
                                            </v-list-item-content>
                                        </v-list-item>
                                        <v-divider class="mt-2"></v-divider>
                                    </template>
                                    <template
                                        v-slot:selection="{ item, index }">
                                        <span class="primary--text" v-if="index === 0">{{ filters.systems.join(', ')
                                            }}</span>
                                    </template>
                                </v-select>
                            </v-col>
                            -->
                            <v-col cols="12" sm="4" md="2">
                                <v-select v-model="filters.severities" :items="severities" label="심각도"
                                    dense hide-details @change="changeSeverity"></v-select>
                                <!--v-select v-model="filters.severities" :items="severities" label="심각도" dense
                                    multiple chips hide-details>
                                    <template v-slot:prepend-item>
                                        <v-list-item ripple @mousedown.prevent @click="toggleAll('severities')">
                                            <v-list-item-action>
                                                <v-icon :color="isAllSelected('severities') ? 'indigo darken-4' : ''">
                                                    {{ getIcon('severities') }}
                                                </v-icon>
                                            </v-list-item-action>
                                            <v-list-item-content>
                                                <v-list-item-title>전체</v-list-item-title>
                                            </v-list-item-content>
                                        </v-list-item>
                                        <v-divider class="mt-2"></v-divider>
                                    </template>
                                    <template
                                        v-slot:selection="{ item, index }">
                                        <span class="primary--text" v-if="index === 0">{{ filters.severities.join(', ')
                                            }}</span>
                                    </template>
                                </v-select-->

                            </v-col>
                            <!--v-col cols="12" sm="3" md="2" >
                                <v-checkbox v-model="filters.useOnlyDate" label="일자조회" dense hide-details @change="changeUseOnlyDate"></v-checkbox>
                            </v-col-->
                            <v-col cols="12" sm="12" md="12" class="d-flex justify-end align-center">
                                <v-btn :color="$config.color_btn" @click="search" small dense>조회</v-btn>
                            </v-col>



                        </v-row>

                    </v-card-text>
                </v-card>


                <!-- 장애 현황 요약 -->
                <!--v-card outlined class="mb-2 pa-0">
                    <v-card-text class="pb-0 pt-3"-->
                <!--v-row dense class="mb-2">
                    <v-col v-for="(item, index) in summaryItems" :key="index" cols="12" sm="6" md="3">
                        <v-card>
                            <v-card-text class="pa-2">
                                <div class="d-flex justify-space-between align-center">
                                    <span class="text-subtitle-1 font-weight-bold pl-6" :class="item.color">{{
                                    item.label
                                }}</span>
                                    <span class="text-subtitle-1 font-weight-bold pr-6" :class="item.color">{{
                                    item.value }}</span>
                                </div>
                            </v-card-text>
                        </v-card>
                    </v-col>
                </v-row-->
                <!--/v-card-text>
                </v-card-->

                <!-- 장애 목록 -->
                <v-data-table :headers="$vo.incidentHeaders" :items="incidents" :items-per-page="10"
                    class="elevation-1 custom-table" @click:row="showDetails">
                    <template v-slot:[`item.severity`]="{ item }">
                        <v-chip :text-color="getSeverityColor(item.severity)" outlined small >
                            {{ item.severity }}
                        </v-chip>
                    </template>
                    <template v-slot:[`item.status`]="{ item }">
                        <v-chip :text-color="getStatusColor(item.status)" outlined small >
                            {{ item.status }}
                        </v-chip>
                    </template>
                    <template v-slot:[`item.actions`]="{ item }">
                        <v-btn small @click="showDetails(item)">상세</v-btn>
                    </template>
                </v-data-table>
            </v-col>
        </v-row>

        

    </v-container>
</template>

<script>


const systems = ['소비자여신시스템', '일반여신시스템', '모바일앱', '통합웹'];
const severities = ['전체', '정상', '오류'];
const severities_color = ['blue', 'green', 'red' ];
const status = ['확인전', '조치중', '모니터링중', '완료'];

const comp = module.exports = {
    data() {
        return {

            startDateMenu: false,
            endDateMenu: false,
            systems: systems,
            severities: severities,
            status: status,
            filters: {
                systems: systems,
                severities: '전체',
                status: status,
                startDate: '',
                endDate: '',
                startTime: '',
                startTimeFormatted: '',
                endTime: '',
                endTimeFormatted: '',
                startTimeMinute: '',
                endTimeMinute: '',
                useOnlyDate: false,
            },            
            incidents: [],
            totalIncidents: 0,
            criticalIncidents: 0,
            warningIncidents: 0,
            infoIncidents: 0,
            detailDialog: false,
            selectedIncident: null,
            
        }
    },

    watch: {

    },
    computed: {
        summaryItems() {
            return [
                { label: '전체 건수', value: this.totalIncidents, color: '' },
                { label: '오류', value: this.criticalIncidents, color: 'red--text' },
                { label: '경고', value: this.warningIncidents, color: 'orange--text' },
                { label: '정보', value: this.infoIncidents, color: 'blue--text' },
            ];
        },        
    },
    methods: {
        changeUseOnlyDate() {
            console.log('changeUseOnlyDate : ', this.filters.useOnlyDate);
            this.filters.severities = this.filters.useOnlyDate ? '감지' : '전체';
        },
        changeSeverity() {
            console.log('changeSeverity : ', this.filters.severities);
            //this.filters.useOnlyDate = ['오류', '감지'].includes(this.filters.severities);
        },
        formatTimeInput(value, dataId) {
            //console.log('replaceNumber', value, dataId)
            // 숫자만 입력 가능하도록 처리
            try {
                this.filters[dataId] = value.replace(/[^0-9]/g, '').slice(0, 6);
                this.filters[dataId + 'Formatted'] = value.replace(/(\d{2})(?=\d)/g, '$1:');
            } catch (error) {
                console.error('replaceNumber 중 오류 발생:', error)
            }
        },
        
        async search() {
            // 실제 검색 로직 구현
            await this.fetchIncidents();
        },
        async fetchIncidents() {

            try {
                this.$loading.show('장애 목록을 불러오는 중입니다...');
                this.totalIncidents = 0;
                this.criticalIncidents = 0;
                this.warningIncidents = 0;
                this.infoIncidents = 0;
                this.incidents = [];

                console.log('조회 요청 : ', this.filters);

                await new Promise(resolve => setTimeout(resolve, 300)); // 예시: 0.5초 지연

                
                try {                    
                    const requestData = {
                        startDttm: this.filters.startDate.replace(/-/g, '') + this.filters.startTime + this.filters.startTimeMinute + '00',
                        endDttm: this.filters.endDate.replace(/-/g, '') + this.filters.endTime + this.filters.endTimeMinute + '00',
                        status: this.filters.severities, // 확인전, 조치중, 모니터링중, 완료
                    };                    
                    this.$loading.show('인시던트 목록을 불러오는 중입니다...');
                    
                    const response = await axios.post('/api/incidents', requestData);
                    console.log('조회 응답 : ', response);
                    if (response.data) {
                        this.incidents = response.data.map(incident => ({
                            guid : incident.guid,
                            svc_id : incident.svc_id,
                            timestamp: this.$util.formatDttm(incident.req_dttm, '-', ':'),
                            system: incident.system_cd,
                            severity: incident.res_cd == 'Succ' ? '정상' : '오류', // API 응답에 심각도 정보가 없어 임의로 설정
                            description: incident.svc_nm,
                            /* status: incident.status */
                        }));
                    } else {
                        console.error('API 응답 형식이 올바르지 않습니다:', response.data, error);
                        this.incidents = [];
                    }
                } catch (error) {
                    console.error('인시던트 목록을 불러오는 중 오류가 발생했습니다:', error);
                    this.incidents = [];
                } finally {
                    this.$loading.hide();
                }
                
                // 실제로는 API 호출을 통해 데이터를 가져와야 합니다.
                // 여기서는 예시 데이터를 사용합니다.
                /*
                this.incidents = [
                    { ruleId: '', ruleNm: '', guid: this.$util.uuid(), timestamp: '2023-05-01 10:30:00', system: '소비자금융시스템', severity: '오류', description: '여신 한도조회', status: '조치중' },
                    { ruleId: '', ruleNm: '',guid: this.$util.uuid(), timestamp: '2023-05-01 10:25:00', system: '소비자금융시스템', severity: '오류', description: '여신 한도조회', status: '완료' },
                    { ruleId: 'RULE-003', ruleNm: '10분간 거래 증가',guid: this.$util.uuid(), timestamp: '2023-05-01 10:27:00', system: '소비자금융시스템', severity: '감지', description: '여신 한도조회', status: '완료' },
                    { ruleId: 'RULE-004', ruleNm: '10분간 거래 증가',guid: this.$util.uuid(), timestamp: '2023-05-02 14:15:00', system: '일반여신시스템', severity: '감지', description: '여신 한도조회', status: '모니터링중' },

                    { ruleId: 'RULE-001', ruleNm: '10분간 거래 증가', guid: this.$util.uuid(), timestamp: '2023-05-03 09:00:00', system: '모바일앱', severity: '감지', description: '모바일 비대면 대출', status: '완료' },
                    { ruleId: 'RULE-001',ruleNm: '10분간 거래 증가',guid: this.$util.uuid(), timestamp: '2023-05-03 07:33:00', system: '모바일앱', severity: '감지', description: '모바일 비대면 대출', status: '조치중' },
                    { ruleId: '',ruleNm: '',guid: this.$util.uuid(), timestamp: '2023-05-03 07:23:00', system: '모바일앱', severity: '오류', description: '모바일 비대면 대출', status: '조치중' },
                    { ruleId: '',ruleNm: '',guid: this.$util.uuid(), timestamp: '2023-05-03 07:13:00', system: '모바일앱', severity: '오류', description: '모바일 비대면 대출', status: '조치중' },
                    { ruleId: '',ruleNm: '',guid: this.$util.uuid(), timestamp: '2023-05-03 07:03:00', system: '모바일앱', severity: '오류', description: '모바일 비대면 대출', status: '조치중' },
                    { ruleId: '',ruleNm: '',guid: this.$util.uuid(), timestamp: '2023-05-03 06:53:00', system: '모바일앱', severity: '오류', description: '모바일 비대면 대출', status: '조치중' },
                    { ruleId: '',ruleNm: '',guid: this.$util.uuid(), timestamp: '2023-05-03 06:43:00', system: '모바일앱', severity: '오류', description: '모바일 비대면 대출', status: '조치중' },
                    { ruleId: '',ruleNm: '',guid: this.$util.uuid(), timestamp: '2023-05-03 06:33:00', system: '모바일앱', severity: '오류', description: '모바일 비대면 대출', status: '조치중' },
                    { ruleId: '',ruleNm: '',guid: this.$util.uuid(), timestamp: '2023-05-03 06:23:00', system: '모바일앱', severity: '오류', description: '모바일 비대면 대출', status: '조치중' },
                    { ruleId: '',ruleNm: '',guid: this.$util.uuid(), timestamp: '2023-05-03 06:13:00', system: '모바일앱', severity: '오류', description: '모바일 비대면 대출', status: '조치중' },
                    { ruleId: '',ruleNm: '',guid: this.$util.uuid(), timestamp: '2023-05-03 06:03:00', system: '모바일앱', severity: '오류', description: '모바일 비대면 대출', status: '조치중' },
                    { ruleId: '',ruleNm: '',guid: this.$util.uuid(), timestamp: '2023-05-03 05:53:00', system: '모바일앱', severity: '오류', description: '모바일 비대면 대출', status: '조치중' },
                ];
                */

                


                this.updateIncidentSummary();

            } finally {
                this.$loading.hide();
            }
        },
        updateIncidentSummary() {
            this.totalIncidents = this.incidents.length;
            this.criticalIncidents = this.incidents.filter(i => i.severity === '오류').length;
            this.warningIncidents = this.incidents.filter(i => i.severity === '경고').length;
            this.infoIncidents = this.incidents.filter(i => i.severity === '정보').length;
        },
        getSeverityColor(severity) {
            const index = severities.indexOf(severity);

            if (index >= 0)
                return severities_color[index];
            else
                return 'grey';
        },
        getStatusColor(status) {
            if (!status) return 'grey';
            switch (status) {                
                case '정상': return 'green';
                default: return 'red';
            }
        },
        toggleAll(filterType) {
            this.filters[filterType] = this.$util.toggleAll(this[filterType], this.filters[filterType]);
        },
        isAllSelected(filterType) {
            return this.$util.isAllSelected(this[filterType], this.filters[filterType]);
        },
        getIcon(filterType) {
            return this.$util.getIcon(this.isAllSelected(filterType));
        },
        async showDetails(item) {
            console.log('showDetails : ', item);
            this.selectedIncident = item;            
            await this.$vo.openSvcDetailDialog(item);
        },
    },
    created() {
        const dates = this.$util.setLastWeekDates();
        this.filters.startDate = dates.endDate;
        this.filters.endDate = dates.endDate;

        this.filters.startTime = this.$util.getTime(-5, 0, '').slice(0, 2);
        this.filters.startTimeMinute = this.$util.getTime(-5, 0, '').slice(2, 4);
        this.filters.endTime = this.$util.getTime(0, 0, '').slice(0, 2);
        this.filters.endTimeMinute = this.$util.getTime(0, 0, '').slice(2, 4);
    },
    async mounted() {
        await this.search();

        //console.log('mounted : ', this.$vo.incidentHeaders);
        //await this.showDetails(this.incidents[0]);
    }
}
</script>

<style scoped></style>
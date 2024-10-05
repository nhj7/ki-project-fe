<template>
    <v-container fluid>
        <v-row>
            <v-col>
                <!-- 조회 조건 -->
                <v-card class="mb-4 pb-0">
                    <v-card-text dense>
                        <v-row dense>
                            <v-col cols="12" sm="8" md="6">
                                <v-select v-model="filters.systems" :items="systems" label="시스템" outlined multiple chips
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
                                        v-slot:selection="{ item, index }"><!-- eslint-disable-line vue/no-unused-vars -->
                                        <!--v-chip color="primary lighten-2">
                                            {{ item }}
                                        </v-chip-->
                                        <span class="primary--text" v-if="index === 0">{{ filters.systems.join(', ')
                                            }}</span>
                                    </template>
                                </v-select>
                            </v-col>
                            <v-col cols="12" sm="8" md="6">
                                <v-select v-model="filters.severities" :items="severities" label="심각도" outlined dense
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
                                        v-slot:selection="{ item, index }"><!-- eslint-disable-line vue/no-unused-vars -->
                                        <!--v-chip :color="getSeverityColor(item)">
                                            {{ item }}
                                        </v-chip-->
                                        <span class="primary--text" v-if="index === 0">{{ filters.severities.join(', ')
                                            }}</span>
                                    </template>
                                </v-select>
                            </v-col>
                        </v-row>
                        <v-row dense class="mt-3">
                            <v-col cols="12" sm="6" md="3">
                                <v-menu v-model="startDateMenu" :close-on-content-click="false"
                                    transition="scale-transition" offset-y max-width="290px" min-width="290px">
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-text-field v-model="filters.startDate" label="시작 날짜" readonly v-bind="attrs"
                                            v-on="on" outlined dense hide-details></v-text-field>
                                    </template>
                                    <v-date-picker v-model="filters.startDate" no-title
                                        @input="startDateMenu = false"></v-date-picker>
                                </v-menu>
                            </v-col>
                            <v-col cols="12" sm="6" md="3">
                                <v-menu v-model="endDateMenu" :close-on-content-click="false"
                                    transition="scale-transition" offset-y max-width="290px" min-width="290px">
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-text-field v-model="filters.endDate" label="종료 날짜" readonly v-bind="attrs"
                                            v-on="on" outlined dense hide-details></v-text-field>
                                    </template>
                                    <v-date-picker v-model="filters.endDate" no-title
                                        @input="endDateMenu = false"></v-date-picker>
                                </v-menu>
                            </v-col>
                            <v-col cols="12" sm="12" md="6" class="d-flex justify-end align-center">
                                <v-btn :color="$config.color_btn" @click="search" small dense>조회</v-btn>
                            </v-col>
                        </v-row>

                    </v-card-text>
                </v-card>


                <!-- 장애 현황 요약 -->
                <!--v-card outlined class="mb-2 pa-0">
                    <v-card-text class="pb-0 pt-3"-->
                <v-row dense class="mb-2">
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
                </v-row>
                <!--/v-card-text>
                </v-card-->

                <!-- 장애 목록 -->
                <v-data-table :headers="headers" :items="incidents" :items-per-page="10"
                    class="elevation-1 custom-table" :mobile-breakpoint="0" @click:row="showDetails">
                    <template v-slot:[`item.severity`]="{ item }">
                        <v-chip :color="getSeverityColor(item.severity)" dark small>
                            {{ item.severity }}
                        </v-chip>
                    </template>
                    <template v-slot:[`item.status`]="{ item }">
                        <v-chip :color="getStatusColor(item.status)" dark small>
                            {{ item.status }}
                        </v-chip>
                    </template>
                    <template v-slot:[`item.actions`]="{ item }">
                        <v-btn small  @click="showDetails(item)">상세</v-btn>
                    </template>
                </v-data-table>
            </v-col>
        </v-row>

        <!-- 상세 정보 팝업 -->
        <v-dialog v-model="detailDialog" max-width="80%">
            <v-card>
                <v-card-title>
                    <v-icon>mdi-information-outline</v-icon>
                    &nbsp;&nbsp; 서비스 상세 정보
                </v-card-title>
                <v-divider></v-divider>
                <v-card-text>
                    <v-simple-table class="fixed-table mb-2">
                        <template v-slot:default>
                            <tbody>
                                <tr v-for="(row, index) in groupedIncidentDetails" :key="index">
                                    <template v-for="(value, key) in row">
                                        <td class="label-column">{{ getHeaderText(key) }}<!--eslint-disable-line-->
                                        </td>
                                        <td class="value-column"><!--eslint-disable-line-->
                                            <template v-if="key !== 'status'">{{ value }}</template>
                                            <v-select v-else v-model="selectedIncident.status" :items="status" dense
                                                outlined hide-details class="small-select"></v-select>
                                        </td>
                                    </template>
                                </tr>
                            </tbody>
                        </template>
                    </v-simple-table>
                    <v-divider></v-divider>
                    <v-card-subtitle>
                        <v-icon>mdi-list-box</v-icon>
                        &nbsp;&nbsp; 서비스 상세 거래 목록
                    </v-card-subtitle>
                    <v-data-table :headers="detailTransactionHeaders" :items="detailTransactions" :items-per-page="5"
                        class="elevation-1" dense :height="200" fixed-header>
                        <template v-slot:[`item.status`]="{ item }">
                            <v-chip :color="getStatusColor(item.status)" small>
                                {{ item.status }}
                            </v-chip>
                        </template>
                    </v-data-table>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn :color="$config.color_btn" text @click="detailDialog = false">닫기</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

    </v-container>
</template>

<script>


const systems = ['소비자금융시스템', '일반여신시스템', '모바일앱', '통합웹'];
const severities = ['심각', '경고', '정보'];
const severities_color = ['red', 'orange', 'blue'];
const status = ['조치중', '모니터링중', '완료'];

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
                severities: severities.slice(0, 2),
                status: status,
                startDate: '',
                endDate: '',
            },
            headers: [
                { text: '발생시간', align: 'start', sortable: true, value: 'timestamp' },
                { text: '시스템', value: 'system' },
                { text: '심각도', value: 'severity' },
                { text: '서비스내용', value: 'description' },
                { text: '상태', value: 'status' },
                { text: '상세', value: 'actions', sortable: false },
            ],
            incidents: [],
            totalIncidents: 0,
            criticalIncidents: 0,
            warningIncidents: 0,
            infoIncidents: 0,
            detailDialog: false,
            selectedIncident: null,
            detailTransactionHeaders: [
                { text: 'GUID', value: 'guid' },
                { text: '프로그램 ID', value: 'programId' },
                { text: '거래 시간', value: 'transactionTime' },
                { text: '거래 유형', value: 'transactionType' },
                { text: '사용자 ID', value: 'userId' },
                { text: '금액', value: 'amount' },
                { text: '상태', value: 'status' },
            ],
            detailTransactions: [],
        }
    },

    watch: {

    },
    computed: {
        summaryItems() {
            return [
                { label: '전체 건수', value: this.totalIncidents, color: '' },
                { label: '심각', value: this.criticalIncidents, color: 'red--text' },
                { label: '경고', value: this.warningIncidents, color: 'orange--text' },
                { label: '정보', value: this.infoIncidents, color: 'blue--text' },
            ];
        },
        groupedIncidentDetails() {
            const grouped = [];
            const keys = Object.keys(this.selectedIncident);
            for (let i = 0; i < keys.length; i += 3) {
                const row = {};
                row[keys[i]] = this.selectedIncident[keys[i]];
                if (i + 1 < keys.length) {
                    row[keys[i + 1]] = this.selectedIncident[keys[i + 1]];
                }
                if (i + 2 < keys.length) {
                    row[keys[i + 2]] = this.selectedIncident[keys[i + 2]];
                }
                grouped.push(row);
            }
            return grouped;
        }
    },
    methods: {
        getHeaderText(key) {
            const header = this.headers.find(h => h.value === key);
            return header ? header.text : key;
        },
        async search() {
            // 실제 검색 로직 구현
            this.fetchIncidents();
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

                /*
                try {                    
                    const requestData = {
                        startDate: this.filters.startDate,
                        endDate: this.filters.endDate,
                        status: this.filters.status
                    };                    
                    this.$loading.show('인시던트 목록을 불러오는 중입니다...');
                    
                    const response = await request( '/api/incidents', 'POST', requestData);
                    
                    if (response.data && response.data.incidents) {
                        this.incidents = response.data.incidents.map(incident => ({
                            timestamp: incident.createdAt,
                            system: '시스템', // API 응답에 시스템 정보가 없어 임의로 설정
                            severity: '심각', // API 응답에 심각도 정보가 없어 임의로 설정
                            description: incident.title,
                            status: incident.status
                        }));
                    } else {
                        console.error('API 응답 형식이 올바르지 않습니다:', response.data);
                        this.incidents = [];
                    }
                } catch (error) {
                    console.error('인시던트 목록을 불러오는 중 오류가 발생했습니다:', error);
                    this.incidents = [];
                } finally {
                    this.$loading.hide();
                }
                */
                // 실제로는 API 호출을 통해 데이터를 가져와야 합니다.
                // 여기서는 예시 데이터를 사용합니다.
                
                this.incidents = [
                    { timestamp: '2023-05-01 10:30:00', system: '소비자금융시스템', severity: '심각', description: '대출 한도조회 오류', status: '조치중' },
                    { timestamp: '2023-05-01 10:25:00', system: '소비자금융시스템', severity: '심각', description: '1원 송금 오류', status: '완료' },
                    { timestamp: '2023-05-01 10:27:00', system: '소비자금융시스템', severity: '심각', description: '네이버페이 한도조회 오류', status: '완료' },
                    { timestamp: '2023-05-02 14:15:00', system: '일반여신시스템', severity: '경고', description: '스크래핑 오류', status: '모니터링중' },

                    { timestamp: '2023-05-03 09:00:00', system: '모바일앱', severity: '경고', description: '일반 점검', status: '완료' },
                    { timestamp: '2023-05-03 07:33:00', system: '모바일앱', severity: '심각', description: '중앙회 API 오류', status: '조치중' },
                    { timestamp: '2023-05-03 07:23:00', system: '모바일앱', severity: '심각', description: '중앙회 API 오류', status: '조치중' },
                    { timestamp: '2023-05-03 07:13:00', system: '모바일앱', severity: '심각', description: '중앙회 API 오류', status: '조치중' },
                    { timestamp: '2023-05-03 07:03:00', system: '모바일앱', severity: '심각', description: '중앙회 API 오류', status: '조치중' },
                    { timestamp: '2023-05-03 06:53:00', system: '모바일앱', severity: '심각', description: '중앙회 API 오류', status: '조치중' },
                    { timestamp: '2023-05-03 06:43:00', system: '모바일앱', severity: '심각', description: '중앙회 API 오류', status: '조치중' },
                    { timestamp: '2023-05-03 06:33:00', system: '모바일앱', severity: '심각', description: '중앙회 API 오류', status: '조치중' },
                    { timestamp: '2023-05-03 06:23:00', system: '모바일앱', severity: '심각', description: '중앙회 API 오류', status: '조치중' },
                    { timestamp: '2023-05-03 06:13:00', system: '모바일앱', severity: '심각', description: '중앙회 API 오류', status: '조치중' },
                    { timestamp: '2023-05-03 06:03:00', system: '모바일앱', severity: '심각', description: '중앙회 API 오류', status: '조치중' },
                    { timestamp: '2023-05-03 05:53:00', system: '모바일앱', severity: '심각', description: '중앙회 API 오류', status: '조치중' },
                ];  
                

                console.log('조회 응답 : ', this.incidents);


                this.updateIncidentSummary();

            } finally {
                this.$loading.hide();
            }
        },
        updateIncidentSummary() {
            this.totalIncidents = this.incidents.length;
            this.criticalIncidents = this.incidents.filter(i => i.severity === '심각').length;
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
            if (true) return 'grey';
            switch (status) {
                case '조치중': return 'red';
                case '모니터링중': return 'orange';
                case '완료': return 'green';
                default: return 'grey';
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
        showDetails(item) {
            this.selectedIncident = item;
            this.fetchDetailTransactions(item.guid);
            this.detailDialog = true;
        },
        fetchDetailTransactions(incidentGuid) {
            // 실제로는 API를 호출하여 데이터를 가져와야 합니다.
            
            // 여기서는 예시 데이터를 사용합니다.
            
            this.detailTransactions = [
                { guid: 'tx001', programId: 'PROG001', transactionTime: '2023-05-01 10:30:15', transactionType: '입금', userId: 'user123', amount: 50000, status: '성공' },
                { guid: 'tx002', programId: 'PROG002', transactionTime: '2023-05-01 10:31:20', transactionType: '출금', userId: 'user456', amount: 30000, status: '실패' },
                { guid: 'tx003', programId: 'PROG001', transactionTime: '2023-05-01 10:32:30', transactionType: '조회', userId: 'user789', amount: 0, status: '성공' },
                { guid: 'tx003', programId: 'PROG001', transactionTime: '2023-05-01 10:32:30', transactionType: '조회', userId: 'user789', amount: 0, status: '성공' },
                { guid: 'tx003', programId: 'PROG001', transactionTime: '2023-05-01 10:32:30', transactionType: '조회', userId: 'user789', amount: 0, status: '성공' },
                { guid: 'tx003', programId: 'PROG001', transactionTime: '2023-05-01 10:32:30', transactionType: '조회', userId: 'user789', amount: 0, status: '성공' },
                { guid: 'tx003', programId: 'PROG001', transactionTime: '2023-05-01 10:32:30', transactionType: '조회', userId: 'user789', amount: 0, status: '성공' },
                { guid: 'tx003', programId: 'PROG001', transactionTime: '2023-05-01 10:32:30', transactionType: '조회', userId: 'user789', amount: 0, status: '성공' },
                { guid: 'tx003', programId: 'PROG001', transactionTime: '2023-05-01 10:32:30', transactionType: '조회', userId: 'user789', amount: 0, status: '성공' },
                { guid: 'tx003', programId: 'PROG001', transactionTime: '2023-05-01 10:32:30', transactionType: '조회', userId: 'user789', amount: 0, status: '성공' },
                { guid: 'tx003', programId: 'PROG001', transactionTime: '2023-05-01 10:32:30', transactionType: '조회', userId: 'user789', amount: 0, status: '성공' },
                // ... 더 많은 거래 데이터 ...
            ];
            
        },

    },
    created() {
        const dates = this.$util.setLastWeekDates();
        this.filters.startDate = dates.startDate;
        this.filters.endDate = dates.endDate;
    },
    mounted() {
        this.search();
    }
}
</script>

<<style scoped>
@media (max-width: 600px) {
    .v-data-table .v-data-table__wrapper {
        overflow-x: auto;
    }
}




    
</style>
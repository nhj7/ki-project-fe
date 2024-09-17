<template>
    <v-container>
        <v-row>
            <v-col>
                <!-- 조회 조건 -->
                <v-card class="mb-4 pb-0">
                    <v-card-text dense class="mb-2">
                        <v-row dense>
                            <v-col cols="12" sm="8" md="6">
                                <v-select v-model="filters.projects" :items="projects" label="프로젝트" outlined dense
                                    multiple chips hide-details>
                                    <template v-slot:prepend-item>
                                        <v-list-item ripple @mousedown.prevent @click="toggleAll('projects')">
                                            <v-list-item-action>
                                                <v-icon :color="isAllSelected('projects') ? 'primary darken-4' : ''">
                                                    {{ getIcon('projects') }}
                                                </v-icon>
                                            </v-list-item-action>
                                            <v-list-item-content>
                                                <v-list-item-title>전체</v-list-item-title>
                                            </v-list-item-content>
                                        </v-list-item>
                                        <v-divider class="mt-2"></v-divider>
                                    </template>
                                    
                                    <template v-slot:selection="{ item, index }"><!-- eslint-disable-line vue/no-unused-vars -->
                                        <!--v-chip color="primary">
                                            {{ item }}
                                        </v-chip-->
                                        <span class="primary--text" v-if="index === 0">{{ filters.projects.join(', ') }}</span>
                                    </template>
                                </v-select>
                            </v-col>
                            <v-col cols="12" sm="8" md="6">
                                <v-select v-model="filters.testTypes" :items="testTypes" label="테스트 유형" outlined dense
                                    multiple chips hide-details>
                                    <template v-slot:prepend-item>
                                        <v-list-item ripple @mousedown.prevent @click="toggleAll('testTypes')">
                                            <v-list-item-action>
                                                <v-icon :color="isAllSelected('testTypes') ? 'indigo darken-4' : ''">
                                                    {{ getIcon('testTypes') }}
                                                </v-icon>
                                            </v-list-item-action>
                                            <v-list-item-content>
                                                <v-list-item-title>전체</v-list-item-title>
                                            </v-list-item-content>
                                        </v-list-item>
                                        <v-divider class="mt-2"></v-divider>
                                    </template>
                                    <template v-slot:selection="{ item, index }"><!-- eslint-disable-line vue/no-unused-vars -->
                                        <!--v-chip color="primary">
                                            {{ item }}
                                        </v-chip--> 
                                        <span class="primary--text" v-if="index === 0">{{ filters.testTypes.join(', ') }}</span>
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
                                            v-on="on" outlined dense hide-details ></v-text-field>
                                    </template>
                                    <v-date-picker v-model="filters.startDate" no-title
                                        @input="startDateMenu = false"></v-date-picker>
                                </v-menu>
                            </v-col>
                            <v-col cols="12" sm="6" md="3">
                                <v-menu v-model="endDateMenu" :close-on-content-click="false"
                                    transition="scale-transition" offset-y max-width="290px" min-width="290px">
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-text-field v-model="filters.endDate" label="종료 날짜" readonly v-bind="attrs" v-on="on"
                                            outlined dense hide-details class="primary--text"></v-text-field>
                                    </template>
                                    <v-date-picker v-model="filters.endDate" no-title
                                        @input="endDateMenu = false"></v-date-picker>
                                </v-menu>
                            </v-col>
                            <v-col cols="12" sm="12" md="6" class="d-flex justify-end align-center">
                                <v-btn color="primary" @click="search" small dense>조회</v-btn>
                            </v-col>
                        </v-row>
                    </v-card-text>
                </v-card>

                <!-- 테스트 수행 현황 요약 -->
                <v-row dense class="mb-4">
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

                <!-- 테스트 수행 목록 -->
                <v-data-table :headers="headers" :items="testResults" :items-per-page="10"
                    class="elevation-1 custom-table" :mobile-breakpoint="0">
                    <template v-slot:[`item.testType`]="{ item }">
                        <v-chip :color="getTestTypeColor(item.testType)" dark small>
                            {{ item.testType }}
                        </v-chip>
                    </template>
                    <template v-slot:[`item.status`]="{ item }">
                        <v-chip :color="getStatusColor(item.status)" dark small>
                            {{ item.status }}
                        </v-chip>
                    </template>
                </v-data-table>
            </v-col>
        </v-row>
    </v-container>
</template>

<script>
const projects = ['소비자금융시스템', '일반여신시스템', '모바일앱', '통합웹'];
const testTypes = ['단위 테스트', '통합 테스트', 'E2E 테스트', '성능 테스트'];
const testTypes_color = ['blue', 'green', 'purple', 'orange'];
const statuses = ['성공', '실패', '진행 중', '대기 중'];

const comp = module.exports = {
    data() {
        return {            
            startDateMenu: false,
            endDateMenu: false,
            projects: projects,
            testTypes: testTypes,
            statuses: statuses,
            filters: {
                projects: projects,
                testTypes: testTypes,
                statuses: statuses,
                startDate : '',
                endDate : ''
            },
            headers: [
                { text: '실행 시간', align: 'start', sortable: true, value: 'executionTime' },
                { text: '프로젝트', value: 'project' },
                { text: '테스트 유형', value: 'testType' },
                { text: '테스트 스위트', value: 'testSuite' },
                { text: '상태', value: 'status' },
                { text: '성공률', value: 'successRate' },
                { text: '소요 시간', value: 'duration' },
            ],
            testResults: [],
            totalTests: 0,
            successfulTests: 0,
            failedTests: 0,
            inProgressTests: 0,
            loading: false,
            loadingText: '',
            loadingInterval: null,
        }
    },
    computed: {
        summaryItems() {
            return [
                { label: '전체 테스트', value: this.totalTests, color: '' },
                { label: '성공', value: this.successfulTests, color: 'green--text' },
                { label: '실패', value: this.failedTests, color: 'red--text' },
                { label: '진행 중', value: this.inProgressTests, color: 'orange--text' },
            ];
        },
    },
    methods: {
        async search() {
            this.fetchTestResults();
        },
        async fetchTestResults() {            
            try {
                this.$loading.show('테스트 결과를 불러오는 중입니다...');
                this.totalTests = 0;
                this.successfulTests = 0;
                this.failedTests = 0;
                this.inProgressTests = 0;
                this.testResults = [];

                console.log('조회 요청 : ', this.filters);

                await new Promise(resolve => setTimeout(resolve, 300));

                this.testResults = [
                    { executionTime: '2023-05-01 10:30:00', project: '소비자금융시스템', testType: '단위 테스트', testSuite: '로그인 기능', status: '성공', successRate: '100%', duration: '2m 30s' },
                    { executionTime: '2023-05-01 11:15:00', project: '소비자금융시스템', testType: '통합 테스트', testSuite: '결제 프로세스', status: '실패', successRate: '80%', duration: '5m 45s' },
                    { executionTime: '2023-05-02 09:00:00', project: '일반여신시스템', testType: 'E2E 테스트', testSuite: '사용자 등록 플로우', status: '진행 중', successRate: 'N/A', duration: '10m 20s' },
                    { executionTime: '2023-05-02 14:30:00', project: '모바일앱', testType: '성능 테스트', testSuite: '데이터베이스 조회', status: '성공', successRate: '95%', duration: '15m 10s' },
                    { executionTime: '2023-05-03 08:45:00', project: '통합웹', testType: '통합 테스트', testSuite: '알림 시스템', status: '대기 중', successRate: 'N/A', duration: 'N/A' },
                ];

                console.log('조회 응답 : ', this.testResults);

                this.updateTestSummary();
            } finally {
                this.$loading.hide();
            }
        },
        updateTestSummary() {
            this.totalTests = this.testResults.length;
            this.successfulTests = this.testResults.filter(t => t.status === '성공').length;
            this.failedTests = this.testResults.filter(t => t.status === '실패').length;
            this.inProgressTests = this.testResults.filter(t => t.status === '진행 중').length;
        },
        getTestTypeColor(testType) {
            const index = testTypes.indexOf(testType);
            if (index >= 0)
                return testTypes_color[index];
            else
                return 'grey';
        },
        getStatusColor(status) {
            switch (status) {
                case '성공': return 'green';
                case '실패': return 'red';
                case '진행 중': return 'orange';
                case '대기 중': return 'grey';
                default: return 'grey';
            }
        },
        toggleAll(filterType) {
            if (this.filters[filterType].length === this[filterType].length) {
                this.filters[filterType] = [];
            } else {
                this.filters[filterType] = [...this[filterType]];
            }
        },
        isAllSelected(filterType) {
            return this.filters[filterType].length === this[filterType].length;
        },
        getIcon(filterType) {
            return this.isAllSelected(filterType) ? 'mdi-checkbox-marked' : 'mdi-checkbox-blank-outline';
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

<style scoped>
@media (max-width: 600px) {
    .v-data-table .v-data-table__wrapper {
        overflow-x: auto;
    }
}

.custom-primary-text input {
  color: var(--v-primary-base) !important;
}


</style>
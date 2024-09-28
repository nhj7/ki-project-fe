<template>
    <v-container fluid>
        <v-card>
            <v-card-title>
                거래 장애 탐지 룰셋 설정
                <v-spacer></v-spacer>
                <v-btn color="primary" @click="addRule">
                    새 규칙 추가
                </v-btn>
            </v-card-title>
            <v-card-text>
                <v-data-table :headers="headers" :items="rules" :items-per-page="10" class="elevation-1">
                    <template v-slot:[`item.actions`]="{ item }">
                        <v-icon small class="mr-2" @click="editRule(item)">
                            mdi-pencil
                        </v-icon>
                        <v-icon small @click="deleteRule(item)">
                            mdi-delete
                        </v-icon>
                    </template>
                </v-data-table>
            </v-card-text>
        </v-card>

        <v-dialog v-model="dialog" max-width="600px">
            <v-card>
                <v-card-title>
                    <span class="headline">{{ formTitle }}</span>
                </v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols="12">
                                <v-text-field v-model="editedItem.name" label="규칙 이름"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-select v-model="editedItem.type" :items="ruleTypes" label="규칙 유형"></v-select>
                            </v-col>
                            <v-col cols="12" v-if="editedItem.type === '거래 부재'">
                                <v-text-field v-model="editedItem.duration" label="기간 (분)" type="number"></v-text-field>
                            </v-col>
                            <v-col cols="12" v-if="editedItem.type === '오류율 증가'">
                                <v-select v-model="editedItem.comparisonPeriod" :items="comparisonPeriods"
                                    label="비교 기간"></v-select>
                            </v-col>
                            <v-col cols="12" v-if="editedItem.type === '오류율 증가'">
                                <v-text-field v-model="editedItem.threshold" label="임계값 (%)"
                                    type="number"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-textarea v-model="editedItem.action" label="조치 사항"></v-textarea>
                            </v-col>
                        </v-row>
                    </v-container>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="close">취소</v-btn>
                    <v-btn color="blue darken-1" text @click="save">저장</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script>
const comp = module.exports = {
    name: 'RuleConfiguration',
    data: function () {
        return {
            dialog: false,
            headers: [
                { text: '규칙 이름', value: 'name' },
                { text: '규칙 유형', value: 'type' },
                { text: '조건', value: 'condition' },
                { text: '조치 사항', value: 'action' },
                { text: '작업', value: 'actions', sortable: false }
            ],
            rules: [

            ],
            editedIndex: -1,
            editedItem: {
                name: '',
                type: '',
                duration: '',
                comparisonPeriod: '',
                threshold: '',
                action: ''
            },
            defaultItem: {
                name: '',
                type: '',
                duration: '',
                comparisonPeriod: '',
                threshold: '',
                action: ''
            },
            ruleTypes: ['거래 부재', '오류율 증가', '응답지연', '거래증가', '반복수행'],
            comparisonPeriods: ['1시간', '1일', '1주일', '1개월']
        }
    },
    computed: {
        formTitle: function () {
            return this.editedIndex === -1 ? '새 규칙' : '규칙 편집'
        }
    },
    methods: {
        async fetchRules() {
            try {
                this.$loading.show('룰셋을 불러오는 중입니다...');
                // 실제로는 서버에서 룰셋을 가져와야 합니다.
                // 여기서는 가상의 트랜잭션을 사용합니다.
                await new Promise(resolve => setTimeout(resolve, 250));

                this.rules = [
                    // 여기에 기존의 rules 데이터를 넣으세요
                    {
                        name: '1시간 무거래 탐지',
                        type: '거래 부재',
                        condition: '1시간 동안 거래 없음',
                        action: '시스템 관리자에게 알림 발송'
                    },
                    {
                        name: '시간당 오류율 급증',
                        type: '오류율 증가',
                        condition: '이전 1시간 대비 오류율 50% 이상 증가',
                        action: '담당자 호출 및 로그 분석 시작'
                    },
                    {
                        name: '일일 오류율 이상',
                        type: '오류율 증가',
                        condition: '전일 대비 오류율 30% 이상 증가',
                        action: '일일 리포트에 포함 및 원인 분석 요청'
                    },
                    {
                        name: '주간 거래량 감소',
                        type: '거래 부재',
                        condition: '이전 주 대비 거래량 40% 이상 감소',
                        action: '비즈니스 팀에 보고 및 마케팅 활동 검토'
                    },                    
                    {
                        name: '특정 거래 유형 오류 증가',
                        type: '오류율 증가',
                        condition: '특정 거래 유형의 오류율이 전체 평균 대비 100% 이상 증가',
                        action: '해당 거래 유형에 대한 상세 로그 분석 및 개발팀 리뷰 요청'
                    },                    
                    {
                        name: '대량 거래 처리 지연',
                        type: '거래 부재',
                        condition: '1분 내 100건 이상의 거래 요청 중 80% 이상 처리 지연',
                        action: '로드 밸런서 및 서버 자원 즉시 점검, 필요시 자동 스케일 아웃'
                    },
                    {
                        name: '거래 처리 응답 지연',
                        type: '응답지연',
                        condition: '평균 거래 처리 시간 60초 이상 지속 (정상: 30초 이내)',
                        action: '시스템 리소스 점검 및 데이터베이스 쿼리 최적화 검토'
                    },                    
                    {
                        name: '갑작스러운 거래량 증가',
                        type: '거래증가',
                        condition: '10분 내 거래량이 전일 동시간대 대비 200% 이상 증가',
                        action: '자동 스케일 아웃 트리거 및 마케팅팀에 확인'
                    },
                    {
                        name: '특정 서비스 거래 급증',
                        type: '거래증가',
                        condition: '특정 서비스 시간당 거래량이 평균의 100% 이상 증가',
                        action: '해당 서비스 확인 및 검토'
                    },
                    {
                        name: '동일 서비스 반복 시도',
                        type: '반복수행',
                        condition: '단일 사용자가 1분 내 10회 이상 동일 서비스 시도',
                        action: '해당 사용자 알림'
                    }
                ];
            } catch (error) {
                console.error('룰셋을 불러오는 중 오류가 발생했습니다:', error);
            } finally {
                this.$loading.hide();
            }
        },
        addRule: function () {
            this.editedIndex = -1
            this.editedItem = Object.assign({}, this.defaultItem)
            this.dialog = true
        },
        editRule: function (item) {
            this.editedIndex = this.rules.indexOf(item)
            this.editedItem = Object.assign({}, item)
            this.dialog = true
        },
        deleteRule: function (item) {
            const index = this.rules.indexOf(item)
            confirm('이 규칙을 삭제하시겠습니까?') && this.rules.splice(index, 1)
        },
        close: function () {
            this.dialog = false
            this.$nextTick(() => {
                this.editedItem = Object.assign({}, this.defaultItem)
                this.editedIndex = -1
            })
        },
        save: function () {
            let condition = ''
            if (this.editedItem.type === '거래 부재') {
                condition = `${this.editedItem.duration}분 동안 거래 없음`
            } else if (this.editedItem.type === '오류율 증가') {
                condition = `이전 ${this.editedItem.comparisonPeriod} 대비 오류율 ${this.editedItem.threshold}% 이상 증가`
            }
            this.editedItem.condition = condition

            if (this.editedIndex > -1) {
                Object.assign(this.rules[this.editedIndex], this.editedItem)
            } else {
                this.rules.push(this.editedItem)
            }
            this.close()
        }
    },
    // 컴포넌트에 mounted 훅 추가
    mounted() {
        this.fetchRules();
    },
}
</script>

<style scoped>
/* 필요한 경우 여기에 스타일을 추가하세요 */
</style>
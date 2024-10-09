<template>
    <v-container fluid>
        <v-card>
            <v-card-title class="pa-2">
                <v-spacer></v-spacer>
                <v-btn :color="$config.color_btn" @click="addRule" small dense>
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
                    <template v-slot:[`item.condition`]="{ item }">
                        {{ formatCondition(item.condition) }}
                    </template>
                </v-data-table>
            </v-card-text>
        </v-card>

        <v-dialog v-model="dialog" max-width="680px">
            <v-card>
                <v-card-title>
                    <span class="headline">{{ formTitle }}</span>
                </v-card-title>
                <v-card-text>
                    <v-container>
                        <v-row>
                            <v-col cols="6">
                                <v-text-field v-model="editedItem.id" label="규칙 ID"></v-text-field>
                            </v-col>
                            <v-col cols="6">
                                <v-text-field v-model="editedItem.name" label="규칙 이름"></v-text-field>
                            </v-col>
                            <v-col cols="12" sm="6" md="4">
                                <v-select v-model="editedItem.condition.type" :items="ruleTypes"
                                    label="규칙 유형"></v-select>
                            </v-col>
                            <v-col cols="12" sm="6" md="4">
                                <v-select v-model="editedItem.condition.direction"
                                    :items="editedItem.condition.type === '거래량' ? [...ruleDirections, '무거래'] : ruleDirections"
                                    label="방향"></v-select>
                            </v-col>
                            <v-col cols="12" sm="6" md="4">
                                <v-switch v-model="editedItem.enabled" label="사용여부"></v-switch>
                            </v-col>

                            <v-col cols="12" sm="6" md="4" v-if="['거래량', '오류율','반복수행'].includes(editedItem.condition.type)">
                                <v-text-field v-model="editedItem.condition.duration" label="기간"
                                    type="number"></v-text-field>
                            </v-col>
                            <v-col cols="12" sm="6" md="4" v-if="['거래량', '오류율','반복수행'].includes(editedItem.condition.type)">
                                <v-select v-model="editedItem.condition.unit" :items="units"
                                    label="단위"></v-select>
                            </v-col>                                
                           
                            <v-col cols="4" v-if="['오류율','응답시간','반복수행'].includes(editedItem.condition.type)">
                                <v-text-field v-model="editedItem.condition.threshold" label="임계값 (%)"
                                    type="number"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field :value="formatCondition(editedItem.condition)" readonly label="규칙설명" ></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-textarea v-model="editedItem.action" label="조치 사항" rows="3"></v-textarea>
                            </v-col>
                        </v-row>
                    </v-container>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn :color="$config.color_btn" @click="close" small>취소</v-btn>
                    <v-btn :color="$config.color_btn" @click="save" small>저장</v-btn>
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
                { text: '규칙 유형', value: 'condition.type' },
                { text: '조건', value: 'condition' },
                { text: '조치 사항', value: 'action' },
                { text: '작업', value: 'actions', sortable: false }
            ],
            rules: [

            ],
            editedIndex: -1,
            editedItem: {
                name: '',
                condition: {
                    type: '',
                    duration: '',
                    comparisonPeriod: '',
                    threshold: '',
                },
                action: ''
            },
            defaultItem: {
                name: '',
                condition: {
                    type: '',
                    duration: '',
                    comparisonPeriod: '',
                    threshold: '',
                },
                action: ''
            },
            ruleTypes: ['거래량', '오류율', '응답시간', '반복수행'],
            comparisonPeriods: ['1시간', '1일', '1주일', '1개월'],
            units: ['분', '시간', '일', '주', '월'],
            ruleDirections: ['증가', '감소']
        }
    },
    computed: {
        formTitle: function () {
            return this.editedIndex === -1 ? '새 규칙' : '규칙 편집'
        }
    },
    methods: {
        formatCondition: function (condition) {
            switch (condition.type) {
                case '거래량':
                    if( condition.duration && condition.unit && condition.direction)
                        return `${condition.duration}${condition.unit} 동안 ${condition.type} ${condition.direction}`;
                    else
                        return `${condition.direction?'':'방향'} ${condition.duration?'':'기간'} ${condition.unit?'':'단위'}를 선택해주세요`;
                case '오류율':
                    if( condition.duration && condition.unit && condition.threshold && condition.direction)
                        return `이전 ${condition.duration}${condition.unit} 대비 오류율 ${condition.threshold}% 이상 ${condition.direction}`;
                    else
                        return `${condition.direction?'':'방향'} ${condition.duration?'':'기간'} ${condition.unit?'':'단위'} ${condition.threshold?'':'임계값'} 을 선택해주세요`;
                case '응답시간':
                    if( condition.duration && condition.unit && condition.threshold && condition.direction)
                        return `이전 서비스 평균 ${condition.duration}${condition.unit} 대비 응답시간 ${condition.threshold}% 이상 ${condition.direction}`;
                    else
                        return `${condition.direction?'':'방향'} ${condition.duration?'':'기간'} ${condition.unit?'':'단위'} ${condition.threshold?'':'임계값'} 을 선택해주세요`;
                case '반복수행':
                    if( condition.duration && condition.unit && condition.threshold)
                        return `단일 사용자가 ${condition.duration}${condition.unit} 내 ${condition.threshold}회 이상 동일 거래 시도`;
                    else
                        return `${condition.duration?'':'기간'} ${condition.unit?'':'단위'} ${condition.threshold?'':'임계값'} 을 선택해주세요`;
                default:
                    return '규칙 유형을 선택해주세요';
            }
        },
        async fetchRules() {
            try {
                this.$loading.show('룰셋을 불러오는 중입니다...');
                // 실제로는 서버에서 룰셋을 가져와야 합니다.
                // 여기서는 가상의 트랜잭션을 사용합니다.
                await new Promise(resolve => setTimeout(resolve, 250));
                try {
                    const response = await this.$axios.post('/api/rule-list');
                    if (response.data && response.data.body && response.data.body.rules) {
                        this.rules = response.data.body.rules;
                    } else {
                        console.error('API 응답 형식이 올바르지 않습니다.');
                    }
                } catch (error) {
                    console.error('룰셋을 가져오는 중 오류가 발생했습니다:', error);
                }
                
                /*
                this.rules = [
                    // 여기에 기존의 rules 데이터를 넣으세요
                    {
                        id: 'RULE-001',
                        name: '1시간 무거래 탐지',
                        condition: {
                            type: '거래량',
                            direction: '무거래',
                            duration: '1',
                            unit: '시간',
                        },
                        action: '시스템 관리자에게 알림 발송',
                        enabled: true
                    },
                    {
                        id: 'RULE-002',
                        name: '시간당 오류율 급증',
                        condition: {
                            type: '오류율',
                            direction: '증가',
                            duration: '1',
                            unit: '시간',
                            threshold: 50,
                        },
                        action: '담당자 호출 및 로그 분석 시작',
                        enabled: true
                    },
                    {
                        id: 'RULE-003',
                        name: '일일 오류율 이상',
                        condition: {
                            type: '오류율',
                            direction: '증가',
                            duration: '1',
                            unit: '일',
                            threshold: 50,
                        },
                        action: '일일 리포트에 포함 및 원인 분석 요청',
                        enabled: true
                    },
                    {
                        id: 'RULE-004',
                        name: '주간 거래량 감소',
                        condition: {
                            type: '거래량',
                            direction: '감소',
                            duration: '1',
                            unit: '주',
                            threshold: 50,
                        },
                        action: '비즈니스 팀에 보고 및 마케팅 활동 검토',
                        enabled: true
                    },                    
                    {
                        id: 'RULE-005',
                        name: '거래 처리 응답 지연',
                        condition: {
                            type: '응답시간',
                            direction: '증가',
                            duration: '1',
                            unit: '시간',
                            threshold: 60,
                        },
                        action: '시스템 리소스 점검 및 데이터베이스 쿼리 최적화 검토',
                        enabled: true
                    },
                    {
                        id: 'RULE-006',
                        name: '갑작스러운 거래량 증가',
                        condition: {
                            type: '거래량',
                            direction: '증가',
                            duration: '10',
                            unit: '분',
                            threshold: 200,
                        },
                        action: '자동 스케일 아웃 트리거 및 마케팅팀에 확인',
                        enabled: true
                    },                    
                    {
                        id: 'RULE-007',
                        name: '동일 서비스 반복 시도',
                        condition: {
                            type: '반복수행',
                            duration: '1',
                            unit: '분',
                            threshold: 10,
                        },
                        action: '해당 사용자 알림',
                        enabled: true
                    }
                ];
                */

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
            console.log('editRule', item);
            this.editedIndex = this.rules.indexOf(item)
            //this.editedItem = Object.assign({}, item)
            this.editedItem = JSON.parse(JSON.stringify(item));
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
            //this.editedItem.condition = condition

            if (this.editedIndex > -1) {
                Object.assign(this.rules[this.editedIndex], this.editedItem)
            } else {
                this.rules.push(this.editedItem)
            }
            this.close()
        }
    },
    // 컴포넌트에 mounted 훅 추가
    async mounted() {
        await this.fetchRules();
        //this.editRule(this.rules[0]);
    },
}
</script>

<style scoped>
/* 필요한 경우 여기에 스타일을 추가하세요 */
</style>
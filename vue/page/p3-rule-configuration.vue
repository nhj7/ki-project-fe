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
                <v-data-table :headers="headers" :items="rules" :items-per-page="10" class="elevation-1" @click:row="editRule">
                    <template v-slot:[`item.actions`]="{ item }">
                        <v-icon small class="mr-2" @click="editRule(item)">
                            mdi-pencil
                        </v-icon>
                        <!--v-icon small @click="deleteRule(item)">
                            mdi-delete
                        </v-icon-->
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
                    <v-icon :color="$route.meta.iconColor || 'primary'" class="mr-2">{{ $route.meta.icon }}</v-icon>
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

                            <v-col cols="12" sm="6" md="4"
                                >
                                <v-text-field v-model="editedItem.condition.duration" label="기간"
                                    type="number"></v-text-field>
                            </v-col>
                            <v-col cols="12" sm="6" md="4"
                                >
                                <v-select v-model="editedItem.condition.unit" :items="units" label="단위"></v-select>
                            </v-col>

                            <v-col cols="4" >
                                <v-text-field v-model="editedItem.condition.threshold" label="임계값 (%)"
                                    type="number"></v-text-field>
                            </v-col>
                            <v-col cols="12">
                                <v-text-field :value="formatCondition(editedItem.condition)" readonly
                                    label="규칙설명"></v-text-field>
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
                { text: '규칙 ID', value: 'id' },
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
                    if (condition.duration && condition.unit && condition.direction)
                        return `${condition.duration}${condition.unit} 동안 ${condition.type} ${condition.direction}`;
                    else
                        return `${condition.direction ? '' : '방향'} ${condition.duration ? '' : '기간'} ${condition.unit ? '' : '단위'}를 선택해주세요`;
                case '오류율':
                    if (condition.duration && condition.unit && condition.threshold && condition.direction)
                        return `이전 ${condition.duration}${condition.unit} 대비 오류율 ${condition.threshold}% 이상 ${condition.direction}`;
                    else
                        return `${condition.direction ? '' : '방향'} ${condition.duration ? '' : '기간'} ${condition.unit ? '' : '단위'} ${condition.threshold ? '' : '임계값'} 을 선택해주세요`;
                case '응답시간':
                    if (condition.duration && condition.unit && condition.threshold && condition.direction)
                        return `이전 서비스 평균 ${condition.duration}${condition.unit} 대비 응답시간 ${condition.threshold}% 이상 ${condition.direction}`;
                    else
                        return `${condition.direction ? '' : '방향'} ${condition.duration ? '' : '기간'} ${condition.unit ? '' : '단위'} ${condition.threshold ? '' : '임계값'} 을 선택해주세요`;
                case '반복수행':
                    if (condition.duration && condition.unit && condition.threshold)
                        return `단일 사용자가 ${condition.duration}${condition.unit} 내 ${condition.threshold}회 이상 동일 거래 시도`;
                    else
                        return `${condition.duration ? '' : '기간'} ${condition.unit ? '' : '단위'} ${condition.threshold ? '' : '임계값'} 을 선택해주세요`;
                default:
                    return '규칙 유형을 선택해주세요';
            }
        },
        async fetchRules() {
            try {
                this.$loading.show('룰셋을 불러오는 중입니다...');
                // 실제로는 서버에서 룰셋을 가져와야 합니다.
                // 여기서는 가상의 트랜잭션을 사용합니다.
                //await new Promise(resolve => setTimeout(resolve, 250));
                try {
                    let response;
                    if( this.$config.isSimulator) {
                        response = this.$vo.getRuleListResponse();
                    } else {
                        response = await this.$axios.post('/api/rule-list');
                    }
                    console.log('룰셋 조회 응답 : ', response);
                    if (response.data && response.data.body && response.data.body.rules) {
                        this.rules = response.data.body.rules;
                    } else {
                        console.error('API 응답 형식이 올바르지 않습니다.');
                    }
                } catch (error) {
                    console.error('룰셋을 가져오는 중 오류가 발생했습니다:', error);
                }

                /*
                this.rules = 
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
        async save() {
            //this.editedItem.condition = condition



            try {
                this.$loading.show('룰셋을 저장하는 중입니다...');
                console.log('룰셋 저장 요청 : ', this.editedItem);
                const response = await this.$axios.post('/api/rule-save', this.editedItem);
                console.log('룰셋 저장 응답 : ', response);

                if (response.data && response.data.header && response.data.header.resultCode == '0000') {
                    if (this.editedIndex > -1) {
                        Object.assign(this.rules[this.editedIndex], this.editedItem)
                    } else {
                        this.rules.push(this.editedItem)
                    }
                    this.$msg.showSnackbar('룰셋이 성공적으로 저장되었습니다.');
                } else {
                    this.$msg.showSnackbar(`룰셋 저장에 실패하였습니다. 관리자에게 문의해주세요. ${response?.data?.header?.resultMessag}`, 'error', 3000);
                }
            } catch (error) {
                console.error('룰셋 저장 중 오류가 발생했습니다:', error);
            } finally {
                this.$loading.hide();
            }

            console.log('저장된 룰셋 : ', this.rules);
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
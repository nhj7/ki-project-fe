<template>
    <v-card>
      <v-card-title>
        <span class="headline">{{ title }}</span>
      </v-card-title>
      <v-card-text>
        <v-container>
          <v-row>
            <v-col cols="12">
              <v-text-field v-model="ruleName" label="규칙 이름"></v-text-field>
            </v-col>
          </v-row>
          <v-row v-for="(condition, index) in conditions" :key="index">
            <v-col cols="3">
              <v-select v-model="condition.metric" :items="metrics" label="지표"></v-select>
            </v-col>
            <v-col cols="2">
              <v-select v-model="condition.operator" :items="operators" label="연산자"></v-select>
            </v-col>
            <v-col cols="3">
              <v-text-field v-model="condition.value" label="값" type="number"></v-text-field>
            </v-col>
            <v-col cols="2">
              <v-select v-model="condition.unit" :items="timeUnits" label="시간 단위"></v-select>
            </v-col>
            <v-col cols="2">
              <v-btn icon @click="removeCondition(index)">
                <v-icon>mdi-delete</v-icon>
              </v-btn>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12">
              <v-btn :color="$config.color_btn" @click="addCondition">조건 추가</v-btn>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12">
              <v-select v-model="logicalOperator" :items="['AND', 'OR']" label="논리 연산자"></v-select>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12">
              <v-select v-model="selectedTemplate" :items="templates" label="템플릿" @change="applyTemplate"></v-select>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12">
              <v-textarea v-model="previewText" label="조건식 미리보기" readonly></v-textarea>
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12">
              <v-textarea v-model="action" label="조치 사항"></v-textarea>
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
  </template>
  
  <script>
  
  const comp = module.exports = {
    name: 'RuleConditionBuilder',
    props: {
      title: {
        type: String,
        default: '새 규칙'
      },
      editedRule: {
        type: Object,
        default: () => ({})
      }
    },
    data() {
      return {
        ruleName: '',
        conditions: [{ metric: '', operator: '', value: '', unit: '' }],
        logicalOperator: 'AND',
        action: '',
        metrics: ['거래량', '오류율', '응답 시간'],
        operators: ['>', '<', '=', '≥', '≤'],
        timeUnits: ['분', '시간', '일'],
        templates: ['10분 무거래 탐지', '시간당 오류율 급증'],
        selectedTemplate: '',
      }
    },
    computed: {
      previewText() {
        return this.conditions.map(c =>
          `${c.metric} ${c.operator} ${c.value} ${c.unit}`
        ).join(` ${this.logicalOperator} `)
      }
    },
    methods: {
      addCondition() {
        this.conditions.push({ metric: '', operator: '', value: '', unit: '' })
      },
      removeCondition(index) {
        this.conditions.splice(index, 1)
      },
      applyTemplate() {
        // 템플릿 적용 로직
        if (this.selectedTemplate === '10분 무거래 탐지') {
          this.conditions = [{
            metric: '거래량',
            operator: '=',
            value: '0',
            unit: '분'
          }]
          this.ruleName = '10분 무거래 탐지'
          this.action = '시스템 관리자에게 알림 발송'
        } else if (this.selectedTemplate === '시간당 오류율 급증') {
          this.conditions = [{
            metric: '오류율',
            operator: '>',
            value: '50',
            unit: '시간'
          }]
          this.ruleName = '시간당 오류율 급증'
          this.action = '담당자 호출 및 로그 분석 시작'
        }
      },
      close() {
        this.$emit('close')
      },
      save() {
        const rule = {
          name: this.ruleName,
          condition: this.previewText,
          action: this.action
        }
        this.$emit('save', rule)
      }
    },
    created() {
      if (this.editedRule.name) {
        this.ruleName = this.editedRule.name
        this.action = this.editedRule.action
        // 여기에 조건 파싱 로직 추가
      }
    }
  }
  </script>
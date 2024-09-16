<template>
<v-container fluid>
    <v-row>
    <v-col cols="12">
        <v-card>
        <v-card-title>
            대화로 금융 보고서를 작성해보세요.
        </v-card-title>

        <v-card-text>
            <div class="chat-container">
            <v-list dense>
                <v-list-item
                v-for="(message, index) in messages"
                :key="index"
                :class="{'sent': message.sent, 'received': !message.sent}"
                >
                <v-list-item-content v-if="message.sent">
                    <v-list-item-title>{{ message.text }}</v-list-item-title>
                </v-list-item-content>

                <v-list-item-content v-else>
                    <v-row>
                        <v-col cols="auto">
                            <v-img src="/assets/ci.png" :width="30" cover />
                        </v-col>
                        <v-col>
                            <v-list-item-title>{{ message.text }}</v-list-item-title>
                        </v-col>
                    </v-row>
                    
                    
                </v-list-item-content>
                </v-list-item>
            </v-list>
            </div>
        </v-card-text>

        <v-divider></v-divider>

        <v-card-actions>
            <v-row no-gutters>
                <v-col>
                    <v-text-field
                    v-model="inputMessage"
                    label="Type your message..."
                    @keyup.enter="sendMessage"
                    dense
                    outlined
                    full-width
                    ></v-text-field>
                </v-col>
                <v-col cols="auto">
                    <v-btn color="primary" @click="sendMessage">Send</v-btn>
                </v-col>                    
            </v-row>
        </v-card-actions>
        </v-card>
    </v-col>
    </v-row>
</v-container>
</template>

<script>
const comp = module.exports = {
    data() {
        return {
            inputMessage: ''
            , messages: [
                { text: '안녕하세요. 필요한 보고서가 무엇인가요? 예) 최근 일주일 간의 대출 실적 리스트를 만들어줘. 고객명, 대출일자, 대출금액 항목이 필요해.', sent: false },
                { text: '사용자 입력 메세지', sent: true },
            ]
            , "data":"나현준, 나예준"
        }
    }
    , methods : {
        sendMessage() {
            if (this.inputMessage.trim() !== '') {
                // Add the user's message to the messages array
                this.messages.push({ text: this.inputMessage, sent: true });
                
                // Clear the input field
                this.inputMessage = '';

                // Simulate a bot response (you can replace this with an API call)
                setTimeout(() => {
                this.messages.push({
                    text: '가상의 보고서 응답입니다. 다운로드 링크',
                    sent: false,
                });
                }, 1000);
            }
        },
    } // methods
}
</script>
<style scoped>
.chat-container {
  max-height: 400px;
  overflow-y: auto;
}

.sent {
  text-align: right;
  border-radius : 1.5em;
  background-color:whitesmoke;
  margin-bottom : 0.25em;
}

.theme--dark .sent{
    background-color:darkgray;
}

.received {
  text-align: left;
}

v-list-item {
  margin-bottom: 10px;
}
</style>
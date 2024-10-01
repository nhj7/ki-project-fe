<template>
  <v-container fluid>
    <v-card>
      <v-card-title>

        <v-spacer></v-spacer>
        <v-btn color="primary" @click="openUserDialog">
          사용자 등록
        </v-btn>
      </v-card-title>
      <v-card-text>
        <v-data-table :headers="headers" :items="users" :items-per-page="10" class="elevation-1" @click:row="editUser" data-cy="user-management-table">
          <template v-slot:[`item.actions`]="{ item }">
            <v-icon small class="mr-2" @click="editUser(item)">
              mdi-pencil
            </v-icon>
            <v-icon small @click.stop="deleteUser(item)">
              mdi-delete
            </v-icon>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>

    <!-- 사용자 등록/수정 다이얼로그 -->
    <v-dialog v-model="dialog" max-width="500px" @after-leave="onDialogClosed">
      <v-card>
        <v-card-title>
          <v-icon>mdi-account</v-icon> &nbsp;
          {{ formTitle }}
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12" sm="6" md="4">
                <v-text-field v-model="editedItem.userId" label="사용자 ID"></v-text-field>
              </v-col>
              <v-col cols="12" sm="6" md="4">
                <v-text-field v-model="editedItem.userName" label="사용자 이름"></v-text-field>
              </v-col>
              <v-col cols="12" sm="6" md="4">
                <v-select v-model="editedItem.userType" :items="['admin', 'user']" label="사용자 유형"></v-select>
              </v-col>
              <v-col cols="12" sm="6" md="4">
                <v-select v-model="editedItem.userStatus" :items="['정상', '휴면', '잠금']" label="사용자 상태"></v-select>
              </v-col>
              <v-col cols="12" sm="6" md="4">
                <v-text-field v-model="editedItem.password" label="비밀번호" type="password"
                  :placeholder="editedIndex === -1 ? '비밀번호 입력' : '변경 시에만 입력'"></v-text-field>
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
  data() {
    return {
      dialog: false,
      headers: [
        { text: '사용자 ID', value: 'userId' },
        { text: '사용자 이름', value: 'userName' },
        { text: '사용자 유형', value: 'userType' },
        { text: '사용자 상태', value: 'userStatus' },
        { text: '로그인 상태', value: 'loginStatus' },
        { text: '마지막 로그인', value: 'lastLoginDate' },
        { text: '작업', value: 'actions', sortable: false },
      ],
      users: [],
      editedIndex: -1,
      editedItem: {
        userId: '',
        userName: '',
        userType: '',
        userStatus: '',
        loginStatus: '',
        lastLoginDate: '',

        password: '',
      },
      defaultItem: {
        userId: '',
        userName: '',
        userType: '',
        userStatus: '',
        loginStatus: '',
        lastLoginDate: '',

        password: '',
      },
    }
  },
  computed: {
    formTitle() {
      return this.editedIndex === -1 ? '사용자 등록' : '사용자 수정'
    },
  },
  watch: {
    dialog(val) {
      val || this.close()
    },
  },
  created() {
    this.initialize()
  },
  methods: {
    async initialize() {
      // 여기서 실제 API를 호출하여 사용자 목록을 가져와야 합니다.
      // 지금은 예시 데이터를 사용합니다.

      const response = await request('/api/user-list', 'get');
      console.log("response", response);

      this.users = response.data.body;
      /*
      this.users = [
        {
          userId: 'admin',
          userName: '나형주1',
          userType: 'admin',
          userStatus: '정상',
          loginStatus: '로그인',
          lastLoginDate: '2024-05-01 12:00:00',
        },
        // 더 많은 사용자 데이터...
      ]*/
    },

    editUser(item) {
      this.editedIndex = this.users.indexOf(item)
      this.editedItem = Object.assign({}, item)
      this.editedItem.password = '' // 수정 시 비밀번호 필드 초기화
      this.dialog = true
    },

    deleteUser(item) {
      const index = this.users.indexOf(item)
      confirm('이 사용자를 삭제하시겠습니까?') && this.users.splice(index, 1)
    },
    close() {
      this.dialog = false
      /*
      this.$nextTick(() => {
        this.editedItem = Object.assign({}, this.defaultItem)
        this.editedIndex = -1
      })
      */
    },
    onDialogClosed() {
      console.log('onDialogClosed')
      this.editedItem = Object.assign({}, this.defaultItem)
      this.editedIndex = -1
    },
   async save() {
      if (this.editedIndex > -1) {
        // 사용자 수정
        const updatedUser = Object.assign({}, this.users[this.editedIndex], this.editedItem)
        if (!this.editedItem.password) {
          // 비밀번호가 입력되지 않았다면 기존 비밀번호 유지
          delete updatedUser.password
        }
        Object.assign(this.users[this.editedIndex], updatedUser)
      } else {
        // 새 사용자 등록

        const res = await request("/api/login-signup", "POST", {
          name: this.editedItem.userName,
          username: this.editedItem.userId,          
          password: this.editedItem.password,
        });

        console.log("res", res);

        this.users.push(this.editedItem)
      }
      this.close()
    },
    openUserDialog() {
      this.editedItem = Object.assign({}, this.defaultItem)
      this.editedIndex = -1
      this.dialog = true
    },
  },
}
</script>
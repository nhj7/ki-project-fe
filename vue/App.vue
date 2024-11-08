<template>
  <v-app dark>
    <v-navigation-drawer v-model="drawer" :mini-variant="miniVariant" :clipped="clipped" fixed app
      class="custom-nav-drawer">
      <v-list-item @click.stop="drawer = !drawer">
        <v-list-item-content>
          <v-list-item-title class="title">
            <v-row>
              <v-col cols="6" md="6" class="text-right primary--text">
                <v-tooltip bottom>
                  <template v-slot:activator="{ on, attrs }">
                    <v-list-item v-bind="attrs" v-on="on" @click.stop="drawer = !drawer" class="primary--text">
                      {{ title }}
                    </v-list-item>
                  </template>
                  <span class="primary--text">Korea Investment Service Quality Management</span>
                </v-tooltip>

                <!--v-img src="/assets/ci.png" :width="30" cover /-->
              </v-col>
              <v-col cols="6" md="6" d-flex justify-start> </v-col>
            </v-row>

            <!--v-icon class="float-right">mdi-close</v-icon-->
          </v-list-item-title>
          <v-list-item-subtitle class="primary--text">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 한국투자 서비스 품질 관리 시스템
          </v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
      <v-divider></v-divider>
      <v-list expand dense>
        <!--v-list-item>
          <v-btn icon @click.stop="miniVariant = !miniVariant">
            <v-icon>mdi-{{ `chevron-${miniVariant ? "right" : "left"}` }}</v-icon>
          </v-btn>
          <v-btn icon @click.stop="clipped = !clipped">
            <v-icon>mdi-application</v-icon>
          </v-btn>
          <v-btn icon @click.stop="fixed = !fixed">
            <v-icon>mdi-minus</v-icon>
          </v-btn>
        </v-list-item-->

        <v-divider></v-divider>

        <template v-for="(route, i) in this.$router.options.routes.filter(
            (route) => route.meta && route.meta.showInMenu
          )">
          <v-list-group v-model="route.meta.isGroupOpen" v-if="route.subRoutes" :key="i" :prepend-icon="route.meta.icon"
            no-action dense @click="updateGroupState(route, $event)">
            <template v-slot:activator>
              <v-list-item-content class="lnb-item rounded-lg">
                <v-list-item-title>{{ route.meta.title }}</v-list-item-title>
              </v-list-item-content>
            </template>

            <v-list-item v-for="subItem in route.subRoutes" :key="subItem.path" :to="subItem.path" link
              class="lnb-subItem rounded-lg pl-4">
              <v-list-item-action dense>
                <v-icon :color="$route?.path === subItem?.path ? findRouteByPath(subItem.path).meta.iconColor : ''">{{ findRouteByPath(subItem.path).meta.icon }}</v-icon>
              </v-list-item-action>
              <v-list-item-content dense>
                <v-list-item-title>{{
                  findRouteByPath(subItem.path).meta.title
                  }}</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list-group>

          <v-list-item v-else :key="route.path" :to="route.path" class="lnb-item rounded-lg" dense>
            <v-list-item-action>
              <v-icon :color="$route?.path === route?.path ? route.meta.iconColor : ''">{{ route.meta.icon }}</v-icon>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title>
                {{ route.meta.title }}
              </v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </template>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar :clipped-left="clipped" fixed app flat class="app-bar-with-border">
      <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
      <!--v-img src="/assets/ci4.jpg" :width="150" @click.stop="drawer = !drawer" /-->
      <router-link to="/" class="text-decoration-none">
        <v-toolbar-title class="text-h6 cursor-pointer d-flex align-center flex-row">
          <v-img src="/assets/ci0.png" :width="100" cover style="top: -7px;"></v-img>
          <span>한국투자</span>
        </v-toolbar-title>
      </router-link>
      <v-spacer></v-spacer>
      <!--v-btn icon @click.stop="rightDrawer = !rightDrawer">
                        <v-icon>mdi-cog</v-icon>
                    </v-btn-->
      <v-menu offset-y v-if="$session.userName">
        <template v-slot:activator="{ on, attrs }">
          <v-btn text v-bind="attrs" v-on="on">
            <v-icon>mdi-account-circle</v-icon>
            {{ $session.userName + "님" || "" }}
          </v-btn>
        </template>
        <v-list>
          <v-list-item @click="goToAccountSettings">
            <v-list-item-title>계정 설정</v-list-item-title>
          </v-list-item>
          <v-list-item @click="logout">
            <v-list-item-title>로그아웃</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>

      <account-settings v-model="accountSettingsVisible"></account-settings>

      <v-btn text @click="logout">
        <v-icon>{{ $session.userName ? "mdi-logout" : "mdi-login" }}</v-icon>
        {{ $session.userName ? "로그아웃" : "로그인" }}
      </v-btn>
      <v-btn icon @click="showAlarmPopup">
        <v-badge :content="alarmCount" :value="alarmCount > 0" color="error" overlap>
          <v-icon>mdi-bell{{this.alarmPopupVisible ? '' : '-outline'}}</v-icon>
        </v-badge>
      </v-btn>
      <v-btn icon @click="toggleDarkTheme">
        <v-icon>{{ themeIcon }}</v-icon>
      </v-btn>
    </v-app-bar>

    <alarm-popup v-model="alarmPopupVisible" :alarms="alarms"></alarm-popup>

    <v-main>
      <v-container fluid class="pt-0">
        <div class="d-flex align-center">
          <h2 class="text-subtitle-2 mb-1 d-flex align-center cursor-pointer flex-grow-1"
            @click.stop="drawer = !drawer">
            <v-icon size="24" :color="this.$route.meta.iconColor || 'primary'" class="mr-2">
              {{ this.$route.meta.icon }}
            </v-icon>
            {{ this.$route.meta.title }}
          </h2>
          <div class="d-flex flex-nowrap">
            <v-btn icon @click="$router.go(-1)">
              <v-icon>mdi-arrow-left</v-icon>
            </v-btn>
            <v-btn icon @click="$router.go(1)">
              <v-icon>mdi-arrow-right</v-icon>
            </v-btn>
          </div>
        </div>
        <v-divider class=""></v-divider>
        <!--component :is="currentView"></component-->
        <div class="router-view-container flex-grow-1">
          <router-view></router-view>
          <v-snackbar v-model="$msg.snackbar" :color="$msg.snackbarColor" :timeout="$msg.snackbarTimeout">
            {{ $msg.snackbarText }}
            <v-btn color="white" text @click="$msg.snackbar = false">닫기</v-btn>
          </v-snackbar>
          <v-overlay :value="$loading.isLoading" :opacity="0.05" absolute class="d-flex align-center justify-center">
            <v-card class="loading-card pa-4 d-flex flex-column align-center" elevation="0" color="transparent">
              <v-progress-circular :size="70" :width="7" color="primary" indeterminate>
                <v-icon size="40" color="primary">mdi-magnify</v-icon>
              </v-progress-circular>
              <v-card-text class="text-center pt-4">
                <span class="text-body-1 primary--text">{{ $loading.displayText }}</span>
              </v-card-text>
            </v-card>
          </v-overlay>
        </div>

        <!-- 메시지 팝업 -->
        <v-dialog v-if="$msg" v-model="$msg.showMessagePopup" max-width="700px" @keydown.enter="$msg.hide"
          @keydown.space="$msg.hide">
          <v-card>
            <v-card-title class="headline d-flex justify-space-between align-center">
              <div>
                <v-icon left :color="$msg.isError ? 'error' : 'primary'">{{ $msg.messageIcon }}</v-icon>
                {{ $msg.messageTitle }} 결과
              </div>
              <v-btn icon large @click="$msg.hide">
                <v-icon>mdi-close</v-icon>
              </v-btn>
            </v-card-title>
            <v-card-text>
              <v-simple-table>
                <template v-slot:default>
                  <tbody>
                    <tr>
                      <td style="width: 20%;"><strong>거래 종류:</strong></td>
                      <td>{{ $msg.messageTitle }}</td>
                    </tr>
                    <tr>
                      <td><strong>메시지 코드:</strong></td>
                      <td>{{ $msg.messageCode }}</td>
                    </tr>
                    <tr>
                      <td><strong>메시지 내용:</strong></td>
                      <td>{{ $msg.messageContent }}</td>
                    </tr>
                    <v-expand-transition>
                      <tr v-if="$msg.showErrorDetails">
                        <td><strong>오류 상세:</strong></td>
                        <td><v-textarea v-model="$msg.errorDetails" outlined readonly auto-grow rows="3" row-height="20"
                            hide-details class="error-details"></v-textarea></td>
                      </tr>
                    </v-expand-transition>
                  </tbody>
                </template>
              </v-simple-table>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn v-if="$msg.isError" color="primary" text @click="$msg.toggleErrorDetails">
                {{ $msg.showErrorDetails ? '접기' : '자세히' }}
              </v-btn>
              <v-btn color="primary" x-large rounded text @click="$msg.hide">닫기</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog><!-- 메시지 팝업 -->

        <!-- 상세 정보 팝업 -->
        <v-dialog v-model="$vo.svcDetailDialog" max-width="80%" transition="" :retain-focus="false">
          <v-card class="dialog-card">
            <v-divider color="grey"></v-divider>
            <v-card-title class="d-flex justify-space-between align-center">
              <div>
                <v-icon :color="$route.meta.iconColor || 'primary'" class="mr-2">{{ $route.meta.icon }}</v-icon>
                &nbsp;&nbsp; 서비스 상세 정보
              </div>
              <v-btn icon @click="$vo.svcDetailDialog = false">
                <v-icon>mdi-close</v-icon>
              </v-btn>
            </v-card-title>
            <v-divider></v-divider>
            <v-card-text>
              <v-simple-table class="fixed-table mb-2">
                <template v-slot:default>
                  <tbody>
                    <tr v-for="(row, index) in $vo.groupedIncidentDetails" :key="index">
                      <template v-for="(value, key) in row">
                        <td class="label-column">{{ $vo.getHeaderText(key) }}<!--eslint-disable-line-->
                        </td>
                        <td class="value-column"><!--eslint-disable-line-->
                          <template v-if="key !== 'status'">{{ value }}</template>
                          <v-select v-else v-model="$vo.selectedIncident.status" :items="status" dense outlined
                            hide-details class="small-select"></v-select>
                        </td>
                      </template>
                    </tr>
                  </tbody>
                </template>
              </v-simple-table>
              <v-divider></v-divider>
              <v-card-subtitle class="text-subtitle-1">
                <v-icon>mdi-list-box</v-icon>
                &nbsp;&nbsp; 서비스 상세 거래 목록
              </v-card-subtitle>
              <v-data-table :headers="$vo.detailTransactionHeaders" :items="$vo.detailTransactions" :items-per-page="7"
                class="elevation-1" dense :height="230" fixed-header @click:row="$vo.openTxDetailDialog"
                :item-class="rowClasses" hide-default-footer>
                <template v-slot:[`item.status`]="{ item }">
                  <v-chip small :text-color="$vo.getStatusColor(item.status)" outlined>
                    {{ item.status }}
                  </v-chip>
                </template>
              </v-data-table>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn :color="$config.color_btn" @click="$vo.svcDetailDialog = false" small>닫기</v-btn>
            </v-card-actions>
            <v-divider color="grey"></v-divider>
          </v-card>
        </v-dialog><!-- detailDialog -->


        <!-- 전문 상세 정보 다이얼로그 -->
        <v-dialog v-model="$vo.tx.detailDialog" max-width="70%" transition="" :retain-focus="false">
          <v-card class="dialog-card">
            <v-divider color="grey"></v-divider>
            <v-card-title class="d-flex justify-space-between align-center">
              <div>
                <v-icon :color="$route.meta.iconColor || 'primary'" class="mr-2">{{ $route.meta.icon }}</v-icon>
                &nbsp;&nbsp; 전문 상세 정보
              </div>
              <v-btn icon @click="$vo.tx.detailDialog = false">
                <v-icon>mdi-close</v-icon>
              </v-btn>
            </v-card-title>
            <v-divider></v-divider>
            <v-card-text>
              <!-- 상단 정보 테이블 -->
              <v-simple-table class="fixed-table mb-4" dense>
                <template v-slot:default>
                  <tbody>
                    <tr>
                      <td class="label-column">트랜잭션 ID</td>
                      <td class="value-column">{{ $vo.tx.selectedTx.tx_id }}</td>
                      <td class="label-column">인터페이스 ID</td>
                      <td class="value-column">{{ $vo.tx.selectedTx.if_id }}</td>
                      <td class="label-column">프로그램명</td>
                      <td class="value-column">{{ $vo.tx.selectedTx.prg_nm }}</td>
                    </tr>
                    <tr>

                      <td class="label-column">시스템 코드</td>
                      <td class="value-column">{{ $vo.tx.selectedTx.system_cd }}</td>
                      <td class="label-column">상태</td>
                      <td class="value-column">
                        <v-chip :color="$vo.getStatusColor($vo.tx.selectedTx.status)" small outlined>
                          {{ $vo.tx.selectedTx.status }}
                        </v-chip>
                      </td>
                      <td class="label-column">경과 시간</td>
                      <td class="value-column">{{ $vo.tx.selectedTx.elapsed }}</td>
                    </tr>
                    <tr>

                      <td class="label-column">요청일시</td>
                      <td class="value-column">{{ $util.formatDttm($vo.tx.selectedTx.req_dttm, '-', ':') }}</td>
                      <td class="label-column">응답일시</td>
                      <td class="value-column">{{ $util.formatDttm($vo.tx.selectedTx.res_dttm, '-', ':') }}</td>

                    </tr>
                    <tr>
                      <td class="label-column">응답코드</td>
                      <td class="value-column">{{ $vo.tx.selectedTx.res_cd }}</td>
                      <td class="label-column">응답메시지</td>
                      <td class="value-column" colspan="3">{{ $vo.tx.selectedTx.res_msg }}</td>

                    </tr>
                  </tbody>
                </template>
              </v-simple-table>

              <!-- 요청부와 응답부 테이블 -->
              <v-row>
                <v-col cols="6" class="message-column">
                  <v-card-subtitle class="text-subtitle-1 pb-0">

                    &nbsp;&nbsp; 요청 전문
                    <v-icon>mdi-arrow-right-bold</v-icon>
                  </v-card-subtitle>
                  <v-data-table :headers="$vo.keyValueHeaders" :items="$vo.tx.requestItems" :items-per-page="-1"
                    hide-default-footer dense class="elevation-1">
                    <template v-slot:[`item.value`]="{ item }">
                      <pre>{{ item.value }}</pre>
                    </template>
                  </v-data-table>
                </v-col>
                <v-divider vertical></v-divider>
                <v-col cols="6" class="message-column">
                  <v-card-subtitle class="text-subtitle-1 pb-0">
                    <v-icon>mdi-arrow-left-bold</v-icon>
                    &nbsp;&nbsp; 응답 전문
                  </v-card-subtitle>
                  <v-data-table :headers="$vo.keyValueHeaders" :items="$vo.tx.responseItems" :items-per-page="-1"
                    hide-default-footer dense class="elevation-1">
                    <template v-slot:[`item.value`]="{ item }">
                      <pre>{{ item.value }}</pre>
                    </template>
                  </v-data-table>
                </v-col>
              </v-row>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn :color="$config.color_btn" @click="$vo.tx.detailDialog = false" small>닫기</v-btn>
            </v-card-actions>
            <v-divider color="grey"></v-divider>
          </v-card>
        </v-dialog>


        <v-dialog v-model="$vo.detected.dialog" max-width="800px" transition="" :retain-focus="false">
          <v-card>
            <v-card-title class="headline">
              <v-row>
                <v-col cols="10">
                  <v-icon :color="$route.meta.iconColor || 'primary'" class="mr-2">{{ $route.meta.icon }}</v-icon>
                  이상징후 감지 상세
                </v-col>
                <v-col cols="2">
                  <v-select v-model="$vo.detected.selectedDetected.detectStatus"
                    :items="['확인전','확인중','조치중', '모니터링중','완료']" dense hide-details
                    @change="$vo.updateDetectedStatus($event)"></v-select>
                </v-col>
              </v-row>
            </v-card-title>
            <v-card-text>
              <v-simple-table dense>
                <template v-slot:default>
                  <tbody>
                    <tr>
                      <td>규칙 ID</td>
                      <td>{{ $vo.detected.selectedDetected.ruleId }}</td>
                      <td>규칙명</td>
                      <td>{{ $vo.detected.selectedDetected.ruleNm }}</td>
                    </tr>
                    <tr>

                      <td>서비스 ID</td>
                      <td>{{ $vo.detected.selectedDetected.svcId }}</td>
                      <td>서비스명</td>
                      <td>{{ $vo.detected.selectedDetected.svcNm }}</td>
                    </tr>
                    <tr>


                      <td
                        :class="[$vo.detected.selectedDetected.txZeroYn, $vo.detected.selectedDetected.txRatioYn].includes('Y') ? 'border-red' : ''">
                        이전 서비스 건수</td>
                      <td
                        :class="[$vo.detected.selectedDetected.txZeroYn, $vo.detected.selectedDetected.txRatioYn].includes('Y') ? 'border-red' : ''">
                        {{ $vo.detected.selectedDetected.bfSvcCnt }}</td>
                      <td
                        :class="[$vo.detected.selectedDetected.txZeroYn, $vo.detected.selectedDetected.txRatioYn].includes('Y') ? 'border-red' : ''">
                        이후 서비스 건수</td>
                      <td
                        :class="[$vo.detected.selectedDetected.txZeroYn, $vo.detected.selectedDetected.txRatioYn].includes('Y') ? 'border-red' : ''">
                        {{ $vo.detected.selectedDetected.afSvcCnt }}</td>
                    </tr>

                    <tr>
                      <td
                        :class="[$vo.detected.selectedDetected.txZeroYn, $vo.detected.selectedDetected.txRatioYn].includes('Y') ? 'border-red' : ''">
                        거래량 비율</td>
                      <td
                        :class="[$vo.detected.selectedDetected.txZeroYn, $vo.detected.selectedDetected.txRatioYn].includes('Y') ? 'border-red' : ''">
                        {{ $vo.detected.selectedDetected.txRatio }}%</td>
                      <td
                        :class="[$vo.detected.selectedDetected.txZeroYn, $vo.detected.selectedDetected.txRatioYn].includes('Y') ? 'border-red' : ''">
                        거래량 감지</td>
                      <td
                        :class="[$vo.detected.selectedDetected.txZeroYn, $vo.detected.selectedDetected.txRatioYn].includes('Y') ? 'border-red' : ''">
                        <v-chip
                          :color=" [$vo.detected.selectedDetected.txZeroYn, $vo.detected.selectedDetected.txRatioYn].includes('Y') ? 'red' : 'green'"
                          small outlined>
                          {{ [$vo.detected.selectedDetected.txZeroYn,
                          $vo.detected.selectedDetected.txRatioYn].includes("Y") ? "예" : "아니오" }}
                        </v-chip>
                        {{ $vo.detected.selectedDetected.txZeroYn =="Y"?"(거래량 없음)":"" }}
                        {{ $vo.detected.selectedDetected.txRatioYn =="Y"?`(거래량 비율 ${$vo.detected.selectedDetected.direction} - ${$vo.detected.selectedDetected.duration}분, ${$vo.detected.selectedDetected.threshold}%)`:"" }}
                      </td>
                    </tr>
                    <tr>

                      <td :class="[$vo.detected.selectedDetected.txErrRatioYn].includes('Y') ? 'border-red' : ''">이전 오류
                        건수</td>
                      <td :class="[$vo.detected.selectedDetected.txErrRatioYn].includes('Y') ? 'border-red' : ''">{{
                        $vo.detected.selectedDetected.bfErrCnt }}</td>
                      <td :class="[$vo.detected.selectedDetected.txErrRatioYn].includes('Y') ? 'border-red' : ''">이후 오류
                        건수</td>
                      <td :class="[$vo.detected.selectedDetected.txErrRatioYn].includes('Y') ? 'border-red' : ''">{{
                        $vo.detected.selectedDetected.afErrCnt }}</td>
                    </tr>
                    <tr>
                      <td :class="[$vo.detected.selectedDetected.txErrRatioYn].includes('Y') ? 'border-red' : ''">오류 비율
                      </td>
                      <td :class="[$vo.detected.selectedDetected.txErrRatioYn].includes('Y') ? 'border-red' : ''">{{
                        $vo.detected.selectedDetected.txErrRatio }}%</td>
                      <td :class="[$vo.detected.selectedDetected.txErrRatioYn].includes('Y') ? 'border-red' : ''">오류율 감지</td>
                      <td :class="[$vo.detected.selectedDetected.txErrRatioYn].includes('Y') ? 'border-red' : ''">
                        <v-chip :color="$vo.detected.selectedDetected.txErrRatioYn == 'Y' ? 'red' : 'green'" small
                          outlined>
                          {{ $vo.detected.selectedDetected.txErrRatioYn == 'Y' ? '예' : '아니오' }}
                        </v-chip>
                        {{ $vo.detected.selectedDetected.txErrRatioYn == 'Y' ? `(오류율 ${$vo.detected.selectedDetected.direction} - ${$vo.detected.selectedDetected.duration}분, ${$vo.detected.selectedDetected.threshold}%)` : "" }}
                      </td>
                    </tr>
                    <tr>
                      <td>이전 감지 일시</td>
                      <td>{{ $vo.detected.selectedDetected.bfStartdttm }}</td>
                      <td>이후 감지 일시</td>
                      <td>{{ $vo.detected.selectedDetected.afStartdttm }}</td>
                    </tr>
                    <tr>
                      <td>유형</td>
                      <td>{{ $vo.detected.selectedDetected.type }}</td>
                      <td>기간</td>
                      <td>{{ $vo.detected.selectedDetected.duration }}분 {{ $vo.detected.selectedDetected.direction }}
                      </td>
                    </tr>
                    <tr>
                      <td>임계값</td>
                      <td>{{ $vo.detected.selectedDetected.threshold }}%</td>
                      <td>등록 일시</td>
                      <td>{{ $vo.detected.selectedDetected.regDttm }}</td>
                    </tr>
                  </tbody>
                </template>
              </v-simple-table>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="$vo.detected.dialog = false">닫기</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>





      </v-container>
    </v-main>

    <v-navigation-drawer v-model="rightDrawer" :right="right" temporary fixed>
      <v-list>
        <v-list-item @click.stop="rightDrawer = !rightDrawer">
          <v-list-item-action>
            <v-icon light>mdi-close</v-icon>
          </v-list-item-action>
          <v-list-item-title>close</v-list-item-title>
        </v-list-item>

        <v-divider></v-divider>

        <v-list-item @click="toggleDarkTheme">
          <v-list-item-action>
            <v-icon>
              {{ isDark ? "mdi-lightbulb-off" : "mdi-lightbulb-on" }}
            </v-icon>
          </v-list-item-action>
          <v-list-item-title>
            {{ isDark ? "dark" : "light" }}
          </v-list-item-title>
        </v-list-item>

        <v-list-item>
          <v-list-item-action>
            <v-icon>mdi-invert-colors</v-icon>
          </v-list-item-action>
          <v-list-item-title> color on </v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-footer absolute fixed inset padless>
      <v-spacer></v-spacer>
      <span class="text-center">
        &copy; {{ new Date().getFullYear() }} 한국투자 {{ title }}. All rights reserved.
      </span>
      <v-spacer></v-spacer>
    </v-footer>

    <v-snackbar>
      snackbar
      <template v-slot:action="{ attrs }">
        <v-btn color="red" text v-bind="attrs">Close</v-btn>
      </template>
    </v-snackbar>
  </v-app>
</template>
<script>

const LoadingPlugin = {
  install(Vue) {
    const loading = new Vue({
      data: {
        isLoading: false,
        loadingText: '로딩 중...',
        elapsedTime: 0,
        timerInterval: null,
      },
      methods: {
        show(text = '로딩 중...') {
          this.isLoading = true;
          this.loadingText = text;
          this.elapsedTime = 0;
          this.startTimer();
        },
        hide() {
          this.isLoading = false;
          this.stopTimer();
        },
        startTimer() {
          this.stopTimer(); // 기존 타이머가 있다면 중지
          this.timerInterval = setInterval(() => {
            this.elapsedTime++;
          }, 1000);
        },
        stopTimer() {
          if (this.timerInterval) {
            clearInterval(this.timerInterval);
            this.timerInterval = null;
          }
        },
        getFormattedTime() {
          const minutes = Math.floor(this.elapsedTime / 60);
          const seconds = this.elapsedTime % 60;
          return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        }
      },
      computed: {
        displayText() {
          return `${this.loadingText} (${this.getFormattedTime()})`;
        }
      }
    });

    Vue.prototype.$loading = loading;
  }
};

Vue.use(LoadingPlugin);

const MessagePlugin = {
  install(Vue) {
    const message = new Vue({
      data: {
        showMessagePopup: false,
        messageIcon: "mdi-information",
        messageCode: "0000",
        messageTitle: "메시지 제목",
        messageContent: "메시지 내용",
        errorDetails: "오류 상세",
        isError: false,
        showErrorDetails: false,
        snackbar: false,
        snackbarColor: 'success',
        snackbarText: '',
        snackbarTimeout: 1000,
      },
      methods: {
        show(options = {}) {
          Object.assign(this.$data, options);
          this.showMessagePopup = true;
        },
        hide() {
          this.showMessagePopup = false;
          this.showErrorDetails = false;
        },
        toggleErrorDetails() {
          this.showErrorDetails = !this.showErrorDetails;
        },
        showSnackbar(text, color = 'success', timeout = 1000) {
          this.snackbarText = text;
          this.snackbarColor = color;
          this.snackbar = true;
          this.snackbarTimeout = timeout;
        }
      }
    });

    Vue.prototype.$msg = message;
  }
};
Vue.use(MessagePlugin);


const VoPlugin = {
  install(Vue) {
    const vo = new Vue({
      data: {
        svcDetailDialog: false,
        selectedIncident: {},
        groupedIncidentDetails: [],
        incidentHeaders: [
          { text: '발생시간', align: 'start', sortable: true, value: 'timestamp' },
          { text: '서비스ID', value: 'svc_id' },
          { text: '시스템', value: 'system' },
          { text: '심각도', value: 'severity' },
          { text: '서비스내용', value: 'description' },
          { text: '상세', value: 'actions', sortable: false },
        ],
        incidents: {

        },
        detailTransactionHeaders: [
          { text: '거래ID', value: 'tx_id' },
          { text: '프로그램 ID', value: 'if_id' },
          { text: '프로그램 명', value: 'prg_nm' },
          { text: '거래 시간', value: 'transactionTime' },
          { text: '처리 시간(초)', value: 'elapsed' },
          { text: '상태', value: 'status' },
        ],
        detailTransactions: [],
        tx: {
          detailDialog: false,
          selectedTx: {
            transactionId: '',
            interfaceId: '',
            programName: '',
            systemCode: '',
            status: '',
            requestDateTime: '',
            responseDateTime: '',
            responseCode: '',
            responseMessage: '',
            elapsedTime: '',
            requestItems: [],
            responseItems: []
          },
          requestItems: [],
          responseItems: []
        },
        detected: {
          dialog: false,
          selectedDetected: {},
        },
        keyValueHeaders: [
          { text: 'Key', value: 'key' },
          { text: 'Value', value: 'value' }
        ],
      },
      methods: {
        set(options = {}) {
          Object.assign(this.$data, options);
        },
        async openTxDetailDialog(tx) {
          console.log('openTxDetailDialog', tx);
          this.tx.selectedTx = tx;
          this.setKeyValueItems(tx.req_json, 'requestItems');
          this.setKeyValueItems(tx.res_json, 'responseItems');
          this.tx.detailDialog = true;
        },
        async openDetectedDialog(detected) {
          console.log('openDetectedDialog', detected);
          this.detected.selectedDetected = detected;
          this.detected.dialog = true;
        },
        async updateDetectedStatus(status) {
          console.log('updateDetectedStatus', status);
          try {
            const response = await axios.post('/api/rule-detect-update', { id: this.detected.selectedDetected.id + '', detectStatus: status });
            console.log('updateDetectedStatus 응답 : ', response);
          } catch (error) {
            console.error('updateDetectedStatus 오류 : ', error);
          }
        },
        setKeyValueItems(_json, items) {
          const json = _json ? JSON.parse(_json) : {};
          console.log('setKeyValueItems', json, items, this.tx[items]);
          this.tx[items]?.splice(0, this.tx[items].length);
          Object.entries(json).forEach(([key, value]) => {
            this.tx[items].push({ key, value });
          });
        },
        async openSvcDetailDialog(incident) {
          this.selectedIncident = incident;
          this.setGroupedIncidentDetails();
          await this.fetchDetailTransactions(incident.guid);
          this.svcDetailDialog = true;
        },
        setGroupedIncidentDetails() {
          //console.log('groupedIncidentDetails', this.selectedIncident);
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
          this.groupedIncidentDetails = grouped;
        },
        getHeaderText(key) {
          const header = this.incidentHeaders.find(h => h.value === key);
          return header ? header.text : key;
        },
        getStatusColor(status) {
          if (!status) return 'grey';
          switch (status) {
            case '정상': return 'grey';
            default: return 'red';
          }
        },
        async fetchDetailTransactions(incidentGuid) {
          console.log('fetchDetailTransactions : ', incidentGuid);
          try {
            this.$loading.show('거래 목록을 불러오는 중입니다...');

            const response = await axios.post('/getGuidData', { guid: incidentGuid });

            if (response.data) {
              response.data.sort((a, b) => a.if_id.localeCompare(b.if_id));
              this.detailTransactions = response.data.map(transaction => ({
                ...transaction,
                transactionTime: this.$util.formatDttm(transaction.req_dttm, '-', ':'),
                elapsed: transaction.elapsed ? (transaction.elapsed / 1000).toFixed(2) : '',
                status: transaction.tx_status,
              }));
            } else {
              console.error('API 응답 형식이 올바르지 않습니다:', response.data, error);
              this.detailTransactions = [];
            }
            console.log('fetchDetailTransactions 응답 : ', response);
          } catch (error) {

          } finally {
            this.$loading.hide();
          }
          /*
          this.detailTransactions = [
              { guid: 'tx001', txId: 'tx001', programId: 'PROG001', programNm: 'NICE 신용조회', transactionTime: '2023-05-01 10:30:15', processTime: '15', status: '성공' },
              { guid: 'tx002', txId: 'tx002', programId: 'PROG002', programNm: 'NICE 신용조회', transactionTime: '2023-05-01 10:31:20', processTime: '20', status: '실패' },
              { guid: 'tx003', txId: 'tx003', programId: 'PROG001', programNm: 'NICE 신용조회', transactionTime: '2023-05-01 10:32:30', processTime: '30', status: '성공' },
              { guid: 'tx004', txId: 'tx004', programId: 'PROG001', programNm: 'NICE 신용조회', transactionTime: '2023-05-01 10:32:30', processTime: '30', status: '성공' },
              { guid: 'tx005', txId: 'tx005', programId: 'PROG001', programNm: 'NICE 신용조회', transactionTime: '2023-05-01 10:32:30', processTime: '30', status: '성공' },
              { guid: 'tx006', txId: 'tx006', programId: 'PROG001', programNm: 'NICE 신용조회', transactionTime: '2023-05-01 10:32:30', processTime: '30', status: '성공' },
              { guid: 'tx007', txId: 'tx007', programId: 'PROG001', programNm: 'NICE 신용조회', transactionTime: '2023-05-01 10:32:30', processTime: '30', status: '성공' },
              { guid: 'tx008', txId: 'tx008', programId: 'PROG001', programNm: 'NICE 신용조회', transactionTime: '2023-05-01 10:32:30', processTime: '30', status: '성공' },
              // ... 더 많은 거래 데이터 ...
          ];
          */
        },
      }
    });

    Vue.prototype.$vo = vo;
  }
};
Vue.use(VoPlugin);


const data = {
  currentView: "",
  isDark: false,
  clipped: true,
  drawer: false,
  fixed: true,
  isCoinSrchHide: true,
  miniVariant: false,
  right: true,
  rightDrawer: false,
  title: "KI-SQM",
  groupStates: [true, true],
  alarmCount: 0,
  alarms: [],
  userName: "나형주",
  alarmPopupVisible: false,
  accountSettingsVisible: false,
  groupOpened: true,
  snackbar: false,
  snackbarColor: 'success',
  snackbarText: '',
  alarmInterval: null,
};

const comp = (module.exports = {
  name: "App",
  data() {
    return data;
  }, // end data
  computed: {
    themeIcon() {
      return this.isDark ? "mdi-weather-night" : "mdi-weather-sunny";
    },
  },
  watch: {

  },
  methods: {
    rowClasses(item) {
      return item.status !== '정상' ? 'error-row' : '';
    },
    goToAccountSettings() {

      this.accountSettingsVisible = true;
      //console.log("goToAccountSettings", this.accountSettingsVisible);
    },
    logout() {
      this.$session.clear();
      this.$router.push("/login");
    },
    toggleDarkTheme() {
      data.isDark = !data.isDark;
      this.$vuetify.theme.dark = data.isDark;
      //console.log('toggleDarkTheme', this.$vuetify.theme.dark);
      localStorage.setItem("darkTheme", this.isDark);

      if (data.isDark) {
        document.body.style.backgroundColor = '#1e1e1e';
      } else {
        document.body.style.backgroundColor = '#fff';
      }
      this.updateScrollbarColor(data.isDark);
    },
    findRouteByPath(path) {
      return this.$router.options.routes.find((route) => route.path === path);
    },
    updateGroupState(route, value) {
      //console.log("updateGroupState", route, value);
      route.meta.isGroupOpen = !route.meta.isGroupOpen;
      //this.groupStates[0] = value;
    },
    showAlarmPopup() {      
      this.alarmPopupVisible = true;
    },
    
    updateScrollbarColor(isDark) {
      const style = document.createElement('style');
      const color = isDark ? 'grey' : 'darkgray';
      const hoverColor = isDark ? 'darkgray' : 'grey';

      style.textContent = `
          html ::-webkit-scrollbar {
            width: 14px; /* 스크롤바 전체 너비 */
          }
          html ::-webkit-scrollbar-track {
            background: transparent; /* 트랙 배경을 투명하게 */
          }
          html ::-webkit-scrollbar-thumb {
            background-color: ${color};
            border-radius: 8px;
            border: 4px solid transparent;
            background-clip: content-box;
          }
          html ::-webkit-scrollbar-thumb:hover {
            background-color: ${hoverColor};
          }
      `;

      // 기존 스타일 제거
      const existingStyle = document.getElementById('scrollbar-style');
      if (existingStyle) {
        existingStyle.remove();
      }
      // 새 스타일 추가
      style.id = 'scrollbar-style';
      document.head.appendChild(style);
    },
    async alarmSearch() {
      try {
        //this.$loading.show('알람 감지 목록을 불러오는 중입니다...');
        // API 호출 로직 구현
        const response = await this.$axios.post('/api/rule-detections', {
          startDate: this.$util.formatDate(),
          endDate: this.$util.formatDate(),
          detectStatus : '확인전'
        });
        console.log('알람 감지 목록 : ', response);
        for (let i = 0; i < response.data.length; i++) {
          response.data[i].afStartdttm = this.$util.formatDttm(response.data[i].afStartdttm, '-', ':');
          response.data[i].afEnddttm = this.$util.formatDttm(response.data[i].afEnddttm, '-', ':');
          response.data[i].bfStartdttm = this.$util.formatDttm(response.data[i].bfStartdttm, '-', ':');

          if (!response.data[i].detectStatus) {
            response.data[i].detectStatus = '확인전';
          }
        }
        if( response.data.length > 0) {
          if( response.data.length > this.alarmCount) {
            for(let i = 0; i < response.data.length - this.alarmCount; i++) {
              response.data[i].isNew = true;
            }
            if( this.$route.path === '/p1-live-transaction-analytics') {
              this.showAlarmPopup();
            }
          }
        }
        this.alarms = response.data;
        this.alarmCount = response.data.length;
        //this.ruleDetections = response.data;
      } catch (error) {
        console.error('규칙 감지 목록을 불러오는 중 오류가 발생했습니다:', error);
        //this.ruleDetections = [];
      } finally {
        //this.$loading.hide();
      }
    },
  },
  async mounted() {
    //console.log("App.vue mounted", Object.keys(this.$options.components));

    this.drawer = window.innerWidth >= 1264; // Vuetify의 lg 브레이크포인트
    await this.alarmSearch();
    this.alarmInterval = setInterval(this.alarmSearch, 30 * 1000);
  },
  components: {
    "alarm-popup": loadVue("/component/AlarmPopup"),
    "account-settings": loadVue("/component/AccountSettings"),
  },
  beforeDestroy() {
    clearInterval(this.alarmInterval);
  },
  beforeCreate() {

    this.$router.options.routes.forEach(route => {
      if (route.subRoutes && route.subRoutes.some(subRoute => subRoute.path === this.$router.currentRoute.path)) {
        if (route.meta) {
          route.meta.isGroupOpen = true;
        } else {
          route.meta = { isGroupOpen: true };
        }
      }
    });
  },
  async created() {
    //console.log("app.vue created", this.$router);
    //this.$router.addRoutes(router);

    { // ===== 테마 설정 =====
      const savedTheme = localStorage.getItem("darkTheme");
      console.log('savedTheme : ', savedTheme);
      if( savedTheme == undefined) {
        console.log('savedTheme undefined : ', savedTheme);
        this.toggleDarkTheme();
      }

      if (savedTheme !== null) {        
        const parsedTheme = JSON.parse(savedTheme);
        if (this.isDark !== parsedTheme) {
          this.toggleDarkTheme();
        }
      }
    } // end 테마 설정



  },
});

const globalMethods = {
  setLastWeekDates() {
    const today = new Date();
    const lastWeek = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
    return {
      endDate: this.formatDate(today, '-'),
      startDate: this.formatDate(lastWeek, '-'),
    };
  },
  formatDate(date, sep = '') {
    if (!date) date = new Date();
    if (date instanceof Date) {
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      return `${year}${sep}${month}${sep}${day}`;
    } else {
      return `${date.substr(0, 4)}${sep}${date.substr(4, 2)}${sep}${date.substr(6, 2)}`;
    }
  },
  formatDttm(dttm, sep1 = '', sep2 = '') {
    if (!dttm) return '';
    if (dttm instanceof Date) {
      const year = dttm.getFullYear();
      const month = String(dttm.getMonth() + 1).padStart(2, "0");
      const day = String(dttm.getDate()).padStart(2, "0");
      return `${year}${sep1}${month}${sep1}${day}`;
    } else {
      return `${dttm.substr(0, 4)}${sep1}${dttm.substr(4, 2)}${sep1}${dttm.substr(6, 2)} ${dttm.substr(8, 2)}${sep2}${dttm.substr(10, 2)}${sep2}${dttm.substr(12, 2)}`;
    }
  },
  /**
   * 날짜를 가져오는 함수
   * @param {number} days 날짜 차이
   * @returns {string} 날짜
   */
  getDate(days = 0, sep = '') {
    const date = new Date();
    date.setDate(date.getDate() + days);
    return this.formatDate(date, sep);
  },
  getTime(min = 0, sec = 0, sep = '') {
    const now = new Date();
    now.setMinutes(now.getMinutes() + min);
    now.setSeconds(now.getSeconds() + sec);
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const seconds = String(now.getSeconds()).padStart(2, '0');
    return `${hours}${sep}${minutes}${sep}${seconds}`;
  },
  getCurrentDateTime() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const seconds = String(now.getSeconds()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  },
  /**
   * 날짜를 가져오는 함수
   * @param {Date} date 날짜
   * @returns {string} 날짜
   */
  getDateTime(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    const seconds = String(date.getSeconds()).padStart(2, '0');
    return `${year}${month}${day}${hours}${minutes}${seconds}`;
  },
  uuidv4() {
    const HEX = '0123456789ABCDEF';  // 대문자로 변경
    let uuid = '';
    for (let i = 0; i < 32; i++) {  // 32로 변경 (하이픈 제거)
      if (i === 12) {
        uuid += '4';
      } else if (i === 16) {
        uuid += HEX[(Math.random() * 4 | 8)];
      } else {
        uuid += HEX[(Math.random() * 16 | 0)];
      }
    }
    return uuid;
  },
  uuid() {
    const HEX = '0123456789ABCDEF';
    const timestamp = new Date().getTime().toString(16).toUpperCase(); // 시간 요소 추가
    let uuid = timestamp;
    while (uuid.length < 16) { // 나머지 8자리는 랜덤
      uuid += HEX[(Math.random() * 16 | 0)];
    }
    return uuid;
  },
  toggleAll(array, selectedArray) {
    if (selectedArray.length === array.length) {
      return [];
    } else {
      return [...array];
    }
  },
  isAllSelected(array, selectedArray) {
    return selectedArray.length === array.length;
  },
  getIcon(isSelected) {
    return isSelected ? "mdi-checkbox-marked" : "mdi-checkbox-blank-outline";
  },
  numberWithComma(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  },
  async sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
};

Vue.prototype.$util = globalMethods;





</script>
<style scoped>
.router-view-container {
  position: relative;
  /* height: calc(100vh - 28px); */
  /* 예상 상단 바 높이를 뺀 값 */
  overflow-y: auto;
  flex-grow: 1;
}

.loading-overlay {
  display: flex;
  align-items: flex-start;
  justify-content: center;
}

.loading-content {
  margin-top: 85%;
  /* 상단에서의 거리를 조절 */
  display: flex;
  flex-direction: column;
  align-items: center;
}

.v-main {
  padding-top: 64px !important;
  /* 상단 바 높이에 맞춰 조정 */
}

.v-main>.container {
  height: calc(100vh - 47px);
  /* 상단 바 높이를 뺀 전체 높이 */
}

.theme--dark .v-list-item--active {
  color: rgb(33, 150, 243);
  /* color: burlywood; */
  /* color : rgb(var(--v-primary-lighten1)); */
}

.theme--light .v-list-item--active {
  color: rgb(33, 150, 243);
  /* color : #5E35B1; */
  /* color : rgb(var(--v-primary-lighten1)); */
}

.pa-0 {
  padding: 0px;
}

.v-list-group {
  width: 100%;
}

.v-list-group__header {
  padding: 0px;
  width: 100%;
  display: flex;
}

.app-bar-with-border {

  border-bottom: 1px solid rgba(255, 255, 255, 0.12) !important;

  /* 라이트 모드 */
}

.theme--dark .app-bar-with-border {
  border-bottom: 1px solid rgba(255, 255, 255, 0.05) !important;
  /* 다크 모드 */
}

.v-text-field input {
  color: var(--v-primary-base) !important;
}

.cursor-pointer {
  cursor: pointer;
}

.v-data-table-header th {
  background-color: var(--v-accent-lighten5) !important;

  font-weight: bold !important;
  cursor: pointer !important;
  transition: background-color 0.2s, color 0.2s !important;
}

.v-data-table-header th:hover {
  background-color: var(--v-accent-lighten4) !important;
}

.v-data-table-header th.active {
  background-color: var(--v-accent-lighten3) !important;
}

.v-data-table-header th .v-data-table-header__icon {
  color: var(--v-accent-base) !important;
}

/* 다크 테마 대응 */
.theme--dark .v-data-table-header th {
  background-color: var(--v-grey-darken4) !important;
  font-weight: bold !important;
  cursor: pointer !important;
  color: var(--v-grey-lighten5) !important;
  transition: background-color 0.2s, color 0.2s !important;
}

.theme--dark .v-data-table-header th:hover {
  background-color: var(--v-grey-darken3) !important;
}

.theme--dark .v-data-table-header th.active {
  background-color: var(--v-grey-darken2) !important;
}

.theme--dark .v-data-table-header th .v-data-table-header__icon {
  color: var(--v-grey-lighten1) !important;
}

/* 점선 스타일의 divider 추가 */
.v-divider.theme--light {
  border-style: dashed !important;
  border-width: 1px !important;
  border-color: rgba(0, 0, 0, 0.12) !important;
}

.v-divider.theme--dark {
  border-style: dashed !important;
  border-width: 1px !important;
}

.custom-table {
  border-top: 1px solid var(--v-primary-lighten5);
}

/*
.custom-table .v-data-table__wrapper>table>tbody>tr>td {
    /* border-bottom: none !important;
}
*/

.lnb-item {
  margin-bottom: 4px;
  /* 원하는 간격 크기로 조정 가능 */
  border-radius: 8px !important;
  /* 모서리 둥글기 정도 */
  /* transition: background-color 0.3s ease;  부드러운 배경색 전환 효과 */
}

.lnb-item .v-list-item__title {
  font-size: 0.75rem;
}

.lnb-subItem {
  margin-bottom: 2px;
  /* 원하는 간격 크기로 조정 가능 */
  border-radius: 8px !important;
  /* 모서리 둥글기 정도 */
  /* transition: background-color 0.3s ease;  부드러운 배경색 전환 효과 */
}

.lnb-subItem .v-list-item__title {
  font-size: 0.8rem !important;
}

/* v-list 자체의 패딩 조정 */
.v-list {
  padding: 8px;
  /* v-list의 내부 여백 조정 */
  border-radius: 8px !important;
  /* 모서리 둥글기 정도 */
}

.v-list-item--link:before {
  border-radius: 8px !important;
  /* 모서리 둥글기 정도 */
}

.small-select {
  font-size: 0.85rem;
  width: 80%;
}

.small-select ::v-deep .v-input__control {
  max-height: 20px;
}

.small-select ::v-deep .v-input__slot {
  max-height: 20px;
}

.small-select ::v-deep .v-select__selection {
  margin-top: 0;
  margin-bottom: 0;
}



/* 새로운 스타일 추가 */
.theme--dark .custom-nav-drawer {
  background-color: #121212 !important;
  /* v-app-bar의 기본 다크모드 색상 */
}

.v-data-table__wrapper table tbody tr:hover {
  background-color: rgba(0, 0, 0, 0.02) !important;
  /* 라이트 테마 */
  cursor: pointer;
}

/* 다크 테마 대응 */
.theme--dark .v-data-table__wrapper table tbody tr:hover {
  background-color: rgba(255, 255, 255, 0.03) !important;
}

.v-list-item__action {
  margin: 0px 0;
}

.v-list-group .v-list--dense .v-list-item {
  min-height: 33px !important;
}

.error-details textarea {
  font-size: 12px !important;
  /* 원하는 크기로 조정 */
  line-height: 1.2 !important;
  /* 줄 간격 조정 */
}

.v-select .v-select__selections {
  color: var(--v-primary-base) !important;
}



.fixed-table {
  table-layout: fixed;
  width: 100%;
}

.fixed-table .label-column {
  width: 70px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  background-color: var(--v-grey-lighten1);
  color: var(--v-primary-darken1);
}

.fixed-table .value-column {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  background-color: #f5f5f5;
  border-radius: 4px;
}


/* 다크 모드 대응 */
.theme--dark .fixed-table .label-column {
  background-color: var(--v-grey-darken4);
  color: var(--v-grey-lighten4);
}

.theme--dark .fixed-table .value-column {
  background-color: #333333;
}

.error-row {
  color: var(--v-error-base) !important;
  /* 연한 빨간색 */
  font-weight: bold;
}

.text-decoration-none {
  text-decoration: none;
  color: inherit;
}

.border-red {
  background-color: var(--v-accent-lighten3) !important;
}

.theme--dark .border-red {
  background-color: rgba(255, 255, 255, 0.12) !important;
}
</style>

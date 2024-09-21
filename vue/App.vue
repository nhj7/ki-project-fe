<template>
    <v-app dark>
        <v-navigation-drawer v-model="drawer" :mini-variant="miniVariant" :clipped="clipped" fixed app
            class="custom-nav-drawer">
            <v-list-item @click.stop="drawer = !drawer">
                <v-list-item-content>
                    <v-list-item-title class="title">
                        <v-row>
                            <v-col cols="6" md="6" class="text-right">
                                <v-tooltip bottom>
                                    <template v-slot:activator="{ on, attrs }">
                                        <v-list-item v-bind="attrs" v-on="on" @click.stop="drawer = !drawer">{{
            "KI-SQMS"
        }}</v-list-item>
                                    </template>
                                    <span>Korea Investment Service Quality Management System</span>
                                </v-tooltip>

                                <!--v-img src="/assets/ci.png" :width="30" cover /-->
                            </v-col>
                            <v-col cols="6" md="6" d-flex justify-start>

                            </v-col>
                        </v-row>

                        <!--v-icon class="float-right">mdi-close</v-icon-->
                    </v-list-item-title>
                    <v-list-item-subtitle>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 한국투자 서비스 품질 관리 시스템
                    </v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>
            <v-divider></v-divider>
            <v-list>
                <v-list-item>
                    <v-btn icon @click.stop="miniVariant = !miniVariant">
                        <v-icon>mdi-{{ `chevron-${miniVariant ? "right" : "left"}` }}</v-icon>
                    </v-btn>
                    <v-btn icon @click.stop="clipped = !clipped">
                        <v-icon>mdi-application</v-icon>
                    </v-btn>
                    <v-btn icon @click.stop="fixed = !fixed">
                        <v-icon>mdi-minus</v-icon>
                    </v-btn>
                </v-list-item>

                <v-divider></v-divider>


                <template
                    v-for="(route, i) in this.$router.options.routes.filter(route => route.meta && route.meta.showInMenu)">

                    <v-list-group v-model="groupStates[i]" v-if="route.subRoutes" :key="i"
                        :prepend-icon="route.meta.icon" no-action @input="updateGroupState(route.name, $event)">
                        <template v-slot:activator>
                            <v-list-item-content class="lnb-item rounded-lg  ">
                                <v-list-item-title>{{ route.meta.title }}</v-list-item-title>
                            </v-list-item-content>
                        </template>

                        <v-list-item v-for="subItem in route.subRoutes" :key="subItem.path" :to="subItem.path" link
                            class="lnb-subItem rounded-lg pl-4 ">
                            <v-list-item-action>
                                <v-icon>{{ findRouteByPath(subItem.path).meta.icon }}</v-icon>
                            </v-list-item-action>
                            <v-list-item-content>
                                <v-list-item-title>{{ findRouteByPath(subItem.path).meta.title }}</v-list-item-title>
                            </v-list-item-content>
                        </v-list-item>
                    </v-list-group>

                    <v-list-item v-else :key="route.path" :to="route.path" class="lnb-item rounded-lg  " dense>

                        <v-list-item-action>
                            <v-icon>{{ route.meta.icon }}</v-icon>
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
            <v-toolbar-title class="text-h6 cursor-pointer" @click.stop="drawer = !drawer">한국투자</v-toolbar-title>
            <v-spacer></v-spacer>
            <!--v-btn icon @click.stop="rightDrawer = !rightDrawer">
                        <v-icon>mdi-cog</v-icon>
                    </v-btn-->
            <v-btn icon @click="toggleDarkTheme">
                <v-icon>{{ themeIcon }}</v-icon>
            </v-btn>
        </v-app-bar>

        <v-main>
            <v-container lass="fill-height pa-0" fluid>
                <h2 class="text-subtitle-2 mb-2 d-flex align-center">
                    <v-icon size="24" :color="this.$route.meta.iconColor || 'primary'" class="mr-2">{{
            this.$route.meta.icon
        }}</v-icon>
                    {{ this.$route.meta.title }}
                </h2>
                <v-divider class=""></v-divider>
                <!--component :is="currentView"></component-->
                <div class="router-view-container flex-grow-1">
                    <router-view></router-view>
                    <v-overlay :value="$loading.isLoading" :opacity="0.05" absolute class="loading-overlay">
                        <div class="loading-content">
                            <v-progress-circular :size="70" :width="7" color="primary" indeterminate>
                                <v-icon size="40" color="primary">mdi-magnify</v-icon>
                            </v-progress-circular>
                            <div class="loading-text mt-4 primary--text">
                                {{ $loading.loadingText }}
                            </div>
                        </div>
                    </v-overlay>
                </div>
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
                    <v-list-item-title>
                        color on
                    </v-list-item-title>
                </v-list-item>
            </v-list>
        </v-navigation-drawer>

        <v-footer absolute fixed inset padless>
            <v-spacer />
            <span>
                All content &copy; {{ "KI-FDS" }}.
                {{ new Date().getFullYear() }} All rights reserved.
            </span>
            <v-spacer />
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

const data = {
    currentView: '',
    isDark: false,
    clipped: true,
    drawer: true,
    fixed: true,
    isCoinSrchHide: true,
    miniVariant: false,
    right: true,
    rightDrawer: false,
    title: "KI-RS",
    groupStates: [true, true]
}



const comp = module.exports = {
    name: "App"
    , data() {
        return data;
    }, // end data
    computed: {
        themeIcon() {
            return this.isDark ? 'mdi-weather-night' : 'mdi-weather-sunny';
        }
    },
    methods: {
        toggleDarkTheme() {
            data.isDark = !data.isDark;
            this.$vuetify.theme.dark = data.isDark;
            console.log(this.$vuetify.theme.dark);
            localStorage.setItem('darkTheme', this.isDark);
        },
        findRouteByPath(path) {
            return this.$router.options.routes.find(route => route.path === path);
        },
        updateGroupState(group, value) {
            console.log("updateGroupState", this.groupStates, group, value);
            this.groupStates[0] = value;
        },
    }
    , mounted() {
        //console.log("App.vue mounted");

    }
    , components: {

    }, created() {
        //console.log("app.vue created", this, this.$options.components);
        //this.$router.addRoutes(router);
        const savedTheme = localStorage.getItem('darkTheme');
        if (savedTheme !== null) {
            this.isDark = JSON.parse(savedTheme);
            this.$vuetify.theme.dark = this.isDark;
        }
    }
}

const globalMethods = {
    setLastWeekDates() {
        const today = new Date();
        const lastWeek = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
        return {
            endDate: this.formatDate(today),
            startDate: this.formatDate(lastWeek)
        };
    },
    formatDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
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
        return isSelected ? 'mdi-checkbox-marked' : 'mdi-checkbox-blank-outline';
    },
    numberWithComma(x) {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
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
    height: calc(100vh - 64px);
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
    font-size: 0.5rem !important;
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

.fixed-table {
    table-layout: fixed;
    width: 100%;
}

.fixed-table .label-column {
    width: 70px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    background-color: var(--v-primary-lighten5);
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
    background-color: var(--v-primary-darken4);
    color: var(--v-primary-lighten4);
}

.theme--dark .fixed-table .value-column {
    background-color: #333333;
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
</style>
<template>
    <v-app>
        <v-navigation-drawer v-model="drawer" :mini-variant="miniVariant" :clipped="clipped" fixed app>
            <v-list-item @click.stop="drawer = !drawer">
                <v-list-item-content>
                    <v-list-item-title class="title">
                        <v-row>
                            <v-col cols="6" md="6" class="text-right">
                                <v-list-item @click.stop="drawer = !drawer">{{ title }}</v-list-item>
                                <!--v-img src="/assets/ci.png" :width="30" cover /-->
                            </v-col>
                            <v-col cols="6" md="6" d-flex justify-start>

                            </v-col>
                        </v-row>

                        <!--v-icon class="float-right">mdi-close</v-icon-->
                    </v-list-item-title>
                    <v-list-item-subtitle>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 대화형 금융 분석 보고서 생성 시스템
                    </v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>
            <v-divider></v-divider>
            <v-list>
                <v-list-item>
                    <v-btn icon @click.stop="miniVariant = !miniVariant">
                        <v-icon>mdi-{{ `chevron-${miniVariant ? "right" : "left"}` }}</v-icon>
                    </v-btn>
                    <!--v-btn icon @click.stop="clipped = !clipped">
                        <v-icon>mdi-application</v-icon>
                    </v-btn-->
                    <!--v-btn icon @click.stop="fixed = !fixed">
                        <v-icon>mdi-minus</v-icon>
                    </v-btn-->
                </v-list-item>

                <v-divider></v-divider>
                
                <v-list-item
                    v-for="(route, i) in this.$router.options.routes.filter(route => route.meta && route.meta.showInMenu)"
                    :key="i" :to="route.path" class="lnb-item rounded-lg">

                    <v-list-item-action>
                        <v-icon>{{ route.meta.icon }}</v-icon>
                    </v-list-item-action>
                    <v-list-item-content>
                        <v-list-item-title>
                            {{ route.meta.title }}
                        </v-list-item-title>
                    </v-list-item-content>
                    
                </v-list-item>


            </v-list>
        </v-navigation-drawer>

        <v-app-bar :clipped-left="clipped" fixed app flat class="app-bar-with-border">
            <v-row>
                <v-col cols="auto" class="d-flex align-center cursor-pointer" @click.stop="drawer = !drawer">
                    <v-app-bar-nav-icon></v-app-bar-nav-icon>
                    <!--v-img src="/assets/ci4.jpg" :width="150" @click.stop="drawer = !drawer" /-->
                    <h1 class="text-h6">한국투자</h1>
                </v-col>
                <v-col cols="auto" class="d-flex align-right">
                    <v-btn icon @click.stop="rightDrawer = !rightDrawer">
                        <v-icon>mdi-cog</v-icon>
                    </v-btn>
                </v-col>
            </v-row>
        </v-app-bar>

        <v-main>
            <v-container>
                <h2 class="text-subtitle-2 mb-2 d-flex align-center">
                    <v-icon size="24" :color="this.$route.meta.iconColor || 'primary'" class="mr-2">{{
            this.$route.meta.icon
        }}</v-icon>
                    {{ this.$route.meta.title }}
                </h2>
                <v-divider class=""></v-divider>
                <!--component :is="currentView"></component-->
                <router-view></router-view>
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

                <v-list-item @click="setDarkTheme">
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

        <v-overlay :value="$loading.isLoading" :opacity="0.5">
            <v-progress-circular :size="70" :width="7" color="primary" indeterminate>
                <v-icon size="40" color="white">mdi-magnify</v-icon>
            </v-progress-circular>
            <div class="loading-text mt-4">
                {{ $loading.loadingText }}
            </div>
        </v-overlay>

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
}



const comp = module.exports = {
    name: "App"
    , data() {
        return data;
    } // end data
    , methods: {
        setDarkTheme() {
            data.isDark = !data.isDark;
            this.$vuetify.theme.dark = data.isDark;
            console.log(this.$vuetify.theme.dark);
        }
    }
    , mounted() {
        console.log("App.vue mounted");
    }
    , components: {

    }, created() {
        console.log("app.vue created", this, this.$options.components);
        //this.$router.addRoutes(router);
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
    }
};

Vue.prototype.$util = globalMethods;

</script>

<style scoped>
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
    border-bottom: 2px solid silver !important;
    /* 두께와 색상 지정 */
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
  border-color: rgba(255, 255, 255, 0.12) !important;
}



.custom-table {
    border-top: 1px solid var(--v-primary-lighten5);
}

.custom-table .v-data-table__wrapper > table > tbody > tr > td {
  /* border-bottom: none !important; */
}

.lnb-item {
  margin-bottom: 4px; /* 원하는 간격 크기로 조정 가능 */
  border-radius: 8px !important; /* 모서리 둥글기 정도 */
  /* transition: background-color 0.3s ease;  부드러운 배경색 전환 효과 */
}

/* v-list 자체의 패딩 조정 */
.v-list {
  padding: 8px; /* v-list의 내부 여백 조정 */
  border-radius: 8px !important; /* 모서리 둥글기 정도 */
}

.v-list-item--link:before {
  border-radius: 8px !important; /* 모서리 둥글기 정도 */
}    
</style>
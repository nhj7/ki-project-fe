<template>
    <v-app>
        <v-navigation-drawer v-model="drawer" :mini-variant="miniVariant" :clipped="clipped" fixed app>
            <v-list-item @click.stop="drawer = !drawer">
                <v-list-item-content>
                    <v-list-item-title class="title">
                        <v-row>
                            <v-col cols="6" md="6" class="text-right">
                                <v-img src="/assets/ci.png" :width="30" cover />
                            </v-col>
                            <v-col cols="6" md="6" d-flex justify-start>
                                <v-list-item>{{ title }}</v-list-item>
                            </v-col>
                        </v-row>
                        

                        
                        
                        <!--v-icon class="float-right">mdi-close</v-icon-->
                    </v-list-item-title>
                    <v-list-item-subtitle>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 한국투자 금융이상거래탐지 시스템
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
                <v-divider></v-divider>
                <v-list-item  v-for="(item, i) in items" :key="i" v-on:click="setCurrentView(item.to, this)" :to="item.to">
                    <v-list-item-action>
                        <v-icon>{{ item.icon }}</v-icon>
                    </v-list-item-action>
                    <v-list-item-content>
                        <v-list-item-title :inner-text.prop="item.title" />
                    </v-list-item-content>
                </v-list-item>
            </v-list>
        </v-navigation-drawer>

        <v-app-bar :clipped-left="clipped" fixed app flat>
            <v-row>
                <v-col cols="auto" class="d-flex align-center">                
                    <v-img src="/assets/ci3.jpg" :width="200" @click.stop="drawer = !drawer"/>                    
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
                            {{
            $vuetify.theme.dark ? "mdi-lightbulb-off" : "mdi-lightbulb-on"
        }}
                        </v-icon>
                    </v-list-item-action>
                    <v-list-item-title>
                        {{
                $vuetify.theme.dark ? "dark" : "light"
            }}
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
    clipped: true,
    drawer: true,
    fixed: true,
    isCoinSrchHide: true,
    items: [
        {
            icon: "mdi-chart-areaspline",
            title: "통계",
            to: "/page1"
        }

        , {
            icon: "mdi-chat-processing",
            title: "레포트",
            to: "/page2"
        }
        , {
            icon: "mdi-newspaper-variant",
            title: "분석",
            to: "/page3"
        }

        , {
            icon: "mdi-dev-to",
            title: "룰셋관리",
            to: "/page4"
        }
        , {
            icon: "mdi-application",
            title: "환경설정",
            to: "/page5"
        }
    ],
    miniVariant: false,
    right: true,
    rightDrawer: false,
    title: "KI-FDS",
}

const comp = module.exports = {
    name: "App"
    , data() {
        return data;
    } // end data
    , methods: {
        setDarkTheme: () => {
            //goClick(link);
        }, setCurrentView: function (name, item) {
            console.log("setCurrentView", name, item);
            data.currentView = name.trim();

            item.active = true;
            //gtag('config', 'UA-109501118-1', { 'page_path': name });
            //setToggle(li);
        }
    }
    , mounted: function () {
        console.log("App mounted");
    }
    , components: {
        
    }, created(){
        console.log("app created", this, this.$options.components);
        
    }
}





</script>

<style scoped>
    .v-list-item--active{
        color : rgb(33, 150, 243);
        /* color : rgb(var(--v-primary-lighten1)); */
    }
    .v-navigation-drawer--is-mouseover{
        /* background-color : rgb(66, 200, 250); */ 
    }
</style>
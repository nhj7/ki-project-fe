<template>
    <v-container fluid>
        <v-row>
            <v-col cols="12">
                <h2 class="text-center mb-6">한국투자 서비스 품질 관리 시스템에 오신 것을 환영합니다.</h2>
            </v-col>
        </v-row>
        <v-row>
            <v-col v-for="(page, index) in this.$router.options.routes.filter(
            (route) => route.meta && route.meta.showInMenu && !route.meta.hideInWelcom)" :key="index" cols="12" sm="6" md="4">
                <v-card class="mx-auto" max-width="400" height="100%">
                    <v-card-title class="headline">
                        <v-icon left :color="page.meta.iconColor || 'primary'">{{ page.meta.icon }}</v-icon>
                        {{ page.meta.title }}
                    </v-card-title>
                    <v-card-text>
                        <p>{{ page.meta.description }}</p>
                    </v-card-text>
                    <v-card-actions>
                        <v-btn :to="page.path" text color="primary">
                            이동하기
                            <v-icon right>mdi-arrow-right</v-icon>
                        </v-btn>
                    </v-card-actions>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>
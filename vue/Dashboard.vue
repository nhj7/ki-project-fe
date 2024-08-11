<template>
    <v-card>
        <v-card-title>
            Main Dashboard {{ name }}
        </v-card-title>
        <v-card-text>
            Welcome to your Admin Dashboard.
        </v-card-text>
    </v-card>
</template>

<script>
const comp = module.exports = {
    name: "Dashboard"
    , data: function () {
        return {            
            name : "Dashboard"
        }
    }
    , methods: {
        goClick: function (link) {
            goClick(link);
        }
        , goCreator: function (link) {
            goCreator(link);

        }
        , resetCount: function () {
            resetCount();
        }
    }
    , mounted: function () {
        
    }
}
</script>

<style scoped></style>
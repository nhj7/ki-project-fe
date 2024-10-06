<template>
    <v-container>
        <!-- 다른 컴포넌트들 -->
        <v-row>
            <v-col cols="12" sm="12" md="12">
                <v-card>
                    <v-card-title></v-card-title>
                    <v-card-text md="2">
                        <div class="d-flex justify-space-around">
                            <div v-for="(system, index) in systems" :key="index" class="system-container">
                                <div class="text-center">{{ system.name }}</div>
                                <div :id="`cylinder-${index}`" class="cylinder-container"></div>
                            </div>
                        </div>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>

<script>


const comp = module.exports = {
    // ... 기존 코드 ...
    data() {
        return {
            // ... 기존 데이터 ...
            systems: [
                { name: '여신', transactions: 0, maxTransactions: 100 },
                { name: '모바일 ', transactions: 0, maxTransactions: 100 },
                { name: '수신', transactions: 0, maxTransactions: 100 },
            ],
        };
    },
    methods: {
        // ... 기존 메서드 ...
        initializeCylinders() {
            this.systems.forEach((system, index) => {
                const svg = d3.select(`#cylinder-${index}`)
                    .append('svg')
                    .attr('width', '100%')
                    .attr('height', 100)
                    .style('display', 'block')
                    .style('margin', 'auto');  // 높이를 100으로 변경

                const gradient = svg.append('defs')
                    .append('linearGradient')
                    .attr('id', `gradient-${index}`)
                    .attr('x1', '0%')
                    .attr('y1', '0%')
                    .attr('x2', '0%')
                    .attr('y2', '100%');

                gradient.append('stop')
                    .attr('offset', '0%')
                    .attr('stop-color', '#4CAF50');

                gradient.append('stop')
                    .attr('offset', '100%')
                    .attr('stop-color', '#2196F3');

                svg.append('rect')
                    .attr('x', 17)  // x 위치를 5로 변경
                    .attr('y', 5)  // y 위치를 5로 변경
                    .attr('width', 45)  // 너비를 90으로 변경
                    .attr('height', 90)  // 높이를 90으로 변경
                    .attr('rx', 10)  // 모서리 반경을 10으로 변경
                    .attr('ry', 10)  // 모서리 반경을 10으로 변경
                    .style('fill', 'none')
                    .style('stroke', '#ccc');

                svg.append('rect')
                    .attr('class', 'fill-rect')
                    .attr('x', 17)  // x 위치를 5로 변경
                    .attr('y', 95)  // y 위치를 95로 변경
                    .attr('width', 45)  // 너비를 90으로 변경
                    .attr('height', 0)
                    .attr('rx', 10)  // 모서리 반경을 10으로 변경
                    .attr('ry', 10)  // 모서리 반경을 10으로 변경
                    .style('fill', `url(#gradient-${index})`);
            });
        },
        updateCylinders() {
            this.systems.forEach((system, index) => {
                const height = (system.transactions / system.maxTransactions) * 90;  // 최대 높이를 90으로 변경
                d3.select(`#cylinder-${index}`)
                    .select('.fill-rect')
                    .transition()
                    .duration(1000)
                    .attr('y', 95 - height)  // y 위치 계산 변경
                    .attr('height', height);
            });
        },
        simulateTransactions() {
            setInterval(() => {
                this.systems.forEach(system => {
                    system.transactions = Math.floor(Math.random() * 50);
                });
                this.updateCylinders();
            }, 500);
        },
    },
    mounted() {
        // ... 기존 mounted 로직 ...
        this.initializeCylinders();
        this.simulateTransactions();
    },
};
</script>

<style scoped>
.system-container {
    width: 10%;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.cylinder-container {
    width: 100%;
    height: 100px;
}
</style>
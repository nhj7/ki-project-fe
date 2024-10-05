<template>
    <v-container fluid>
        <v-row>
            <v-col cols="12">
                <v-card>
                    <v-card-title>D3.js 물결 게이지 차트</v-card-title>
                    <v-card-text>
                        <div id="wave-gauge"></div>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>
<script>

const comp = module.exports = {
    data() {
        return {
            usage: 50,
            svg: null,
            wave: null,
            waveGroup: null,
            waveGroupXPosition: null,
            width: 300,
            height: 300,
            radius: 150,
            fillColor: "steelblue",
            waveHeight: 0.05,
            waveCount: 3,
            waveRiseTime: 1000,
            waveAnimateTime: 1800,
            waveOffset: 0,
            textSize: 0.5,
            textColor: "#045681",
            circleThickness: 0.05,
            circleFillGap: 0.05,
            circleColor: "#178BCA",
            updateInterval: 3000
        };
    },
    mounted() {
        this.initChart();
        this.animateChart();
        setInterval(() => {
            this.usage = Math.random() * 100;
            this.updateChart(this.usage); 
        }, this.updateInterval);
    },
    methods: {
        initChart() {
            const svg = d3.select("#wave-gauge")
                .append("svg")
                .attr("width", this.width)
                .attr("height", this.height)
                .append("g")
                .attr("transform", `translate(${this.width / 2},${this.height / 2})`);

            const circleThickness = this.radius * this.circleThickness;
            const circleFillGap = this.radius * this.circleFillGap;
            const fillCircleMargin = circleThickness + circleFillGap;
            const fillCircleRadius = this.radius - fillCircleMargin;

            const waveHeight = fillCircleRadius * this.waveHeight;
            const waveLength = this.width / this.waveCount;
            const waveClipCount = 1 + this.waveCount;
            const waveClipWidth = waveLength * waveClipCount;

            // Outer circle
            svg.append("circle")
                .attr("cx", 0)
                .attr("cy", 0)
                .attr("r", this.radius)
                .style("fill", this.circleColor);

            // Text
            const text = svg.append("text")
                .attr("text-anchor", "middle")
                .attr("dy", "0em")
                .style("font-size", `${this.textSize}em`)
                .style("fill", this.textColor);

            // Wave group
            const waveGroup = svg.append("defs")
                .append("clipPath")
                .attr("id", "waveClip");

            const wave = waveGroup.append("path")
                .attr("d", `M0,0 Q${waveLength / 4},${waveHeight} ${waveLength / 2},0 T${waveLength},0 V${2 * this.radius}H0Z`)
                .attr("T", "0");

            // Wave rectangle
            svg.append("rect")
                .attr("x", -this.radius)
                .attr("y", -this.radius)
                .attr("width", 2 * this.radius)
                .attr("height", 2 * this.radius)
                .attr("clip-path", "url(#waveClip)")
                .style("fill", this.fillColor);

            this.svg = svg;
            this.wave = wave;
            this.waveGroup = waveGroup;
            this.text = text;
        },
        animateChart() {
            this.waveGroup.attr("transform", `translate(${this.waveOffset},0)`);

            this.wave.attr("d", (d) => {
                const waveHeight = this.radius * this.waveHeight * 2;
                const waveLength = this.width / this.waveCount;
                return `M0,0 Q${waveLength / 4},${waveHeight} ${waveLength / 2},0 T${waveLength},0 V${2 * this.radius}H0Z`;
            });

            this.wave.transition()
                .duration(this.waveAnimateTime)
                .ease(d3.easeLinear)
                .attr("transform", `translate(${this.width},0)`)
                .on("end", () => this.animateChart());
        },
        updateChart(value) {
            const fillPercent = Math.max(0, Math.min(1, value / 100));
            const waveHeight = this.radius * this.waveHeight * 2;
            const waveRiseScale = d3.scaleLinear()
                .range([0, waveHeight])
                .domain([0, 1]);

            const newHeight = waveRiseScale(fillPercent);
            const waveScaleX = d3.scaleLinear().range([0, this.width]).domain([0, 1]);
            const waveScaleY = d3.scaleLinear().range([0, waveHeight]).domain([0, 1]);

            this.waveGroup.transition()
                .duration(this.waveRiseTime)
                .attr("transform", `translate(${waveScaleX(1)},${newHeight})`);

            this.text.text(`${Math.round(fillPercent * 100)}%`);
        }
    }
};
</script>

<style scoped>
#wave-gauge {
    width: 300px;
    height: 300px;
    margin: 0 auto;
}
</style>
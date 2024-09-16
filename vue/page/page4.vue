<template>
    <v-container>
        <v-row>
            <v-col cols="12" md="6">
                <v-text-field v-model="logoText" label="로고 텍스트" outlined></v-text-field>
                <v-select v-model="selectedFont" :items="fonts" label="폰트 선택" outlined></v-select>
                <v-slider v-model="fontSize" min="10" max="100" label="글자 크기" thumb-label></v-slider>
                <v-row>
                    <v-col cols="6">
                        <v-text-field v-model="textColorInput" label="폰트 색상 입력" outlined
                            @input="updateColorFromInput"></v-text-field>
                    </v-col>
                    <v-col cols="6">
                        <v-text-field v-model="textColor" label="폰트 색상" outlined @input="updateColor"></v-text-field>
                    </v-col>
                    <v-col cols="6">
                        <v-color-picker v-model="textColor" hide-mode-switch hide-inputs
                            @input="updateColor"></v-color-picker>
                    </v-col>
                </v-row>
                <v-btn color="primary" @click="saveLogo">로고 저장</v-btn>
            </v-col>
            <v-col cols="12" md="6">
                <canvas ref="logoCanvas" width="400" height="200" style="border: 1px solid #ccc;"></canvas>
            </v-col>
        </v-row>
    </v-container>
</template>

<script>
const comp = module.exports = {
    data() {
        return {
            logoText: '로고 텍스트',
            selectedFont: 'Arial',
            fontSize: 40,
            textColor: '#000000',
            textColorInput: '#000000',
            fonts: ['Arial', 'Helvetica', 'Times New Roman', 'Courier', 'Verdana', 'Georgia', 'Palatino', 'Garamond', 'Bookman', 'Comic Sans MS', 'Trebuchet MS', 'Arial Black', 'Impact'],
        }
    },
    watch: {
        logoText() {
            this.drawLogo()
        },
        selectedFont() {
            this.drawLogo()
        },
        fontSize() {
            this.drawLogo()
        },
    },
    mounted() {
        this.drawLogo()
    },
    methods: {
        drawLogo() {
            const canvas = this.$refs.logoCanvas
            const ctx = canvas.getContext('2d')

            // 캔버스 초기화
            ctx.clearRect(0, 0, canvas.width, canvas.height)

            // 텍스트 설정
            ctx.font = `${this.fontSize}px ${this.selectedFont}`
            ctx.fillStyle = this.textColor
            ctx.textAlign = 'center'
            ctx.textBaseline = 'middle'

            // 텍스트 그리기
            ctx.fillText(this.logoText, canvas.width / 2, canvas.height / 2)
        },
        saveLogo() {
            const canvas = this.$refs.logoCanvas
            const link = document.createElement('a')
            link.download = 'logo.png'
            link.href = canvas.toDataURL('image/png')
            link.click()
        },
        updateColor() {
            // 색상 입력이 유효한지 확인
            if (this.isValidColor(this.textColor)) {
                this.drawLogo()
            } else {
                // 유효하지 않은 색상일 경우 기본값으로 설정
                this.textColor = '#000000'
            }
        },
        isValidColor(color) {
            // 색상 이름 또는 16진수 코드인지 확인
            const s = new Option().style
            s.color = color
            return s.color !== ''
        },
        convertNameToHex(color) {
            // 임시 요소를 생성하여 색상 이름을 16진수로 변환
            const temp = document.createElement('div');
            temp.style.color = color;
            document.body.appendChild(temp);
            const computedColor = getComputedStyle(temp).color;
            document.body.removeChild(temp);

            // RGB 값을 16진수로 변환
            if (computedColor.startsWith('rgb')) {
                const rgb = computedColor.match(/\d+/g);
                return `#${parseInt(rgb[0]).toString(16).padStart(2, '0')}${parseInt(rgb[1]).toString(16).padStart(2, '0')}${parseInt(rgb[2]).toString(16).padStart(2, '0')}`;
            }

            return color; // 이미 16진수 형식이면 그대로 반환
        },
        updateColorFromInput() {
            if (this.isValidColor(this.textColorInput)) {
                this.textColor = this.convertNameToHex(this.textColorInput);
                this.drawLogo();
            } else {
                // 유효하지 않은 색상일 경우 기본값으로 설정                
                //this.textColor = '#000000';
            }
        },
        updateColorFromPicker() {
            this.textColorInput = this.textColor;
            this.drawLogo();
        },
    },
}
</script>
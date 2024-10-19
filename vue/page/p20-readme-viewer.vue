<template>
    <v-container fluid>
        <v-card>
            <v-card-text>
                <div v-html="parsedContent"></div>
            </v-card-text>
        </v-card>
    </v-container>
</template>

<script>

const data = {
    readmeContent: '',
};

const renderer = new marked.Renderer();
renderer.link = function(link) {    
    return `<a href="${link.href}" title="${link.text}" target="_blank">${link.text}</a>`;
};
// marked 옵션에 렌더러 적용
marked.setOptions({
    renderer: renderer,
});

const comp = module.exports = {
    name: 'ReadmeViewer',
    data() {
        return data;
    },
    computed: {
        parsedContent() {
            return this.readmeContent ? marked.parse(this.readmeContent) : '';
        },
    },
    async mounted() {
        await this.fetchReadmeContent();
    },
    methods: {
        async fetchReadmeContent() {
            try {
                const response = await fetch('/README.md');
                this.readmeContent = await response.text();
            } catch (error) {
                console.error('README.md 파일을 불러오는 데 실패했습니다:', error);
                this.readmeContent = '# README 파일을 불러오는 데 실패했습니다.';
            }
        },
    },
};

</script>
<style scoped>
/* 마크다운 스타일링 */
h1 {
    font-size: 1.7em;
    margin-bottom: 1em;
    margin-top: 0.5em;
}

h2 {
    font-size: 1.5em;
    margin-top: 2em;
    margin-bottom: 0.75em;
}

h3 {
    margin-top: 0.5em;
    margin-bottom: 0.5em;
}

p {
    margin-top: 0.5em;
    margin-bottom: 0.5em;
}

ul, ol {
    margin-bottom: 1em;
    padding-left: 2em;
}

li {
    margin-bottom: 0.25em;
}

code {
    background-color: #f0f0f0;
    padding: 0.2em 0.4em;
    border-radius: 3px;
}

pre {
    background-color: #f0f0f0;
    padding: 1em;
    border-radius: 5px;
    overflow-x: auto;
}

.theme--dark pre {
    background-color: #302d2d;
}

img {
    width: 50%;
}


</style>

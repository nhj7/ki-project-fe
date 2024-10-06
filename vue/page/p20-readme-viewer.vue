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
const comp = module.exports = {
    name: 'ReadmeViewer',
    data() {
        return {
            readmeContent: '',
        };
    },
    computed: {
        parsedContent() {
            return marked.parse(this.readmeContent);
        },
    },
    mounted() {
        this.fetchReadmeContent();
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
:deep(h1) {
    font-size: 2em;
    margin-bottom: 0.5em;
}

:deep(h2) {
    font-size: 1.5em;
    margin-top: 1em;
    margin-bottom: 0.5em;
}

:deep(p) {
    margin-bottom: 1em;
}

:deep(ul),
:deep(ol) {
    margin-bottom: 1em;
    padding-left: 2em;
}

:deep(li) {
    margin-bottom: 0.5em;
}

:deep(code) {
    background-color: #f0f0f0;
    padding: 0.2em 0.4em;
    border-radius: 3px;
}

:deep(pre) {
    background-color: #f0f0f0;
    padding: 1em;
    border-radius: 5px;
    overflow-x: auto;
}
</style>
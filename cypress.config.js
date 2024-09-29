const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    viewportWidth: 1280, // 원하는 너비로 설정
    viewportHeight: 720, // 원하는 높이로 설정
  },

  component: {
    devServer: {
      framework: "vue",
      bundler: "webpack",
    },
  },
});

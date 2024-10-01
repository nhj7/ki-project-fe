const { defineConfig } = require("cypress");

module.exports = defineConfig({
  projectId: "2ac3ir",
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    viewportWidth: 1280, // 원하는 너비로 설정
    viewportHeight: 720, // 원하는 높이로 설정
  },
  env : {
    localUrl: "http://127.0.0.1:5500",
    adminUser: "admin",
    adminPass: "admin"
  },  
});

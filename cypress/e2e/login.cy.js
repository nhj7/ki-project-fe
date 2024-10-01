describe('로그인 페이지', () => {
  beforeEach(() => {
    cy.visit(`${Cypress.env('localUrl')}/#login`)
  })

  it('유효한 자격 증명으로 로그인 및 로그인 체크', () => {
    cy.get('[data-test="userId-input"]').type('admin')
    cy.get('[data-test="password-input"]').type('admin')
    //cy.get('[data-test="userId-input"]').type('admin')
    //cy.get('button').contains('로그인').click()
    cy.get('[data-test="login-button"]').click()
    cy.url().should('include', '/live-transaction-analytics')
    cy.window().its('localStorage.accessToken').should('exist')
    cy.window().its('localStorage.refreshToken').should('exist')
    cy.visit(`${Cypress.env('localUrl')}/`)
    cy.intercept('POST', '/api/login-check', (req) => {
      // 요청 로그 출력
      console.log('Request:', req);  
      req.reply((res) => {
        // 응답 로그 출력
        console.log('Response:', res);
      });
    }).as('loginCheck');
    cy.wait('@loginCheck');
    cy.window().its('Vue.prototype.$session').should('deep.include', {
      userId: 'admin',
    });
    cy.window().its('localStorage.accessToken').should('exist')
    cy.window().its('localStorage.refreshToken').should('exist')
  })

  it('잘못된 자격 증명으로 로그인 실패', () => {
    cy.get('[data-test="userId-input"]').type('wronguser')
    cy.get('[data-test="password-input"]').type('wrongpass')
    cy.get('[data-test="login-button"]').click()
    cy.get('[data-test="login-error-message"]').should('contain', '로그인 실패')
  })

  it('빈 필드로 로그인 시도', () => {
    cy.get('[data-test="login-button"]').click()
    cy.get('.v-messages').should('contain', '아이디를 입력해주세요')
    cy.get('.v-messages').should('contain', '패스워드를 입력해주세요')
  })

  it('아이디만 입력하고 로그인 시도', () => {
    cy.get('[data-test="userId-input"]').type('admin')
    cy.get('[data-test="login-button"]').click()
    cy.get('.v-messages').should('contain', '패스워드를 입력해주세요')
  })

  it('패스워드만 입력하고 로그인 시도', () => {
    cy.get('[data-test="password-input"]').type('admin')
    cy.get('[data-test="login-button"]').click()
    cy.get('.v-messages').should('contain', '아이디를 입력해주세요')
  })



  it('서버 오류 시 에러 메시지 표시', () => {
    cy.intercept('POST', '/api/login-signin', {
      statusCode: 500,
      body: { message: '서버 오류' }
    }).as('loginRequest')

    cy.get('[data-test="userId-input"]').type('admin')
    cy.get('[data-test="password-input"]').type('admin')
    cy.get('[data-test="login-button"]').click()
    cy.wait('@loginRequest')
    cy.get('[data-test="login-error-message"]').should('contain', '로그인 실패')
  })
})
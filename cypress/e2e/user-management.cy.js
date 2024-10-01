describe('사용자 관리 페이지', () => {
  beforeEach(() => {
    // 테스트 실행 전 로그인 상태 가정
    cy.window().then((win) => {
      win.localStorage.setItem('accessToken', 'fake-token');
    });

    // 사용자 목록 API 요청 인터셉트
    cy.intercept('GET', '/api/user-list',
        (req) => {
            // 요청 로그 출력
            console.log('Request:', req);        
            req.reply((res) => {
              // 응답 로그 출력
              console.log('Response:', res);
            });
    }).as('getUserList');
    // 로그인 처리
    cy.visit(`${Cypress.env('localUrl')}/#user-management`);
    cy.get('[data-test="userId-input"]').type(Cypress.env('adminUser'));
    cy.get('[data-test="password-input"]').type(Cypress.env('adminPass'));
    cy.get('[data-test="login-button"]').click();
    
    // 로그인 성공 확인

    cy.window().its('localStorage.accessToken').should('exist');
    cy.window().its('localStorage.refreshToken').should('exist');
    // 사용자 관리 페이지 방문
    
  });

  it('사용자 목록을 정상적으로 가져와 표시한다', () => {
    
    cy.visit(`${Cypress.env('localUrl')}/#/user-management`);
    // API 요청 완료 대기
    cy.wait('@getUserList');
    // 사용자 목록 테이블이 존재하는지 확인
    cy.get('.v-data-table').should('exist');
    // 사용자 목록에 최소 1개 이상의 행이 있는지 확인
    cy.get('.v-data-table tbody tr').should('have.length.at.least', 2);
  });
});

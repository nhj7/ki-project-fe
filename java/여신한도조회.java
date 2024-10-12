package java;
public class 여신한도조회 {
    public static void main(String[] args) {
        boolean isSuccess = true;
        try {
            // 나이스 신용조회
            // kcb 신용조회
            // CSS 한도/금리 조회
        } catch (Exception e) {
            // 에러 체크
            isSuccess = false;
        } finally {
            // 서비스 인서트
            if( isSuccess ) {
                // 성공
            } else {
                // 실패
            }
        }
    }
}
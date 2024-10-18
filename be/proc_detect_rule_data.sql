CREATE DEFINER=`kisb`@`%` PROCEDURE `kisb`.`proc_detect_rule_data`()
BEGIN
    -- RuleSet 테이블에서 데이터를 가져오는 커서 선언
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_action VARCHAR(255);
    DECLARE v_direction VARCHAR(255);
    DECLARE v_duration INT;
    DECLARE v_name VARCHAR(255);
    DECLARE v_rule_id VARCHAR(255);
    DECLARE v_threshold INT;
    DECLARE v_type VARCHAR(255);
    DECLARE v_unit VARCHAR(255);
    DECLARE v_enabled BIT(1);

    DECLARE ruleset_cursor CURSOR FOR 
        SELECT action, direction, duration, name, rule_id, threshold, type, unit, enabled
        FROM kisb.RuleSet
        WHERE enabled = 1;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
   
    -- 임시 테이블이 존재할 경우 삭제
    DROP TEMPORARY TABLE IF EXISTS temp;
   DROP TEMPORARY TABLE IF EXISTS temp_rule;
   
    -- 임시 테이블 생성
    CREATE TEMPORARY TABLE temp (
        id INT AUTO_INCREMENT PRIMARY KEY, -- id를 자동 증가로 설정
        txt VARCHAR(8000)
    );
   
   CREATE TEMPORARY TABLE temp_rule (
      `rule_id` varchar(255) NOT NULL,
      `rule_nm` varchar(255) NOT NULL,
	  `svc_id` varchar(255) NOT NULL,
	  `svc_nm` varchar(255) NOT NULL,
	  `svc_cnt` bigint(20) DEFAULT NULL,
	  `bf_svc_cnt` bigint(20) DEFAULT NULL,
	  `bf_err_cnt` bigint(20) DEFAULT NULL,
	  `af_svc_cnt` bigint(20) DEFAULT NULL,
	  `af_err_cnt` bigint(20) DEFAULT NULL,
	  `tx_zero_yn` char(1) DEFAULT NULL,
	  `tx_ratio` decimal(10,2) DEFAULT NULL,
	  `tx_err_ratio` decimal(10,2) DEFAULT NULL,
	  `tx_ratio_yn` char(1) DEFAULT NULL,
	  `tx_err_ratio_yn` char(1) DEFAULT NULL,
	  `bf_startDttm` varchar(14) DEFAULT NULL,
	  `bf_endDttm` varchar(14) DEFAULT NULL,
	  `af_startDttm` varchar(14) DEFAULT NULL,
	  `af_endDttm` varchar(14) DEFAULT NULL,
	  `type` varchar(255) DEFAULT NULL,
	  `duration` varchar(255) DEFAULT NULL,
	  `direction` varchar(255) DEFAULT NULL,
	  `threshold` int(11) DEFAULT NULL
	  
	);

    SET time_zone = 'Asia/Seoul';
    
    -- 커서 열기
    OPEN ruleset_cursor;
    
    -- 룰셋 데이터를 순회하며 처리
    read_loop: LOOP
        FETCH ruleset_cursor INTO v_action, v_direction, v_duration, v_name, v_rule_id, v_threshold, v_type, v_unit, v_enabled;
        
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 룰셋 데이터 출력 (실제 감지 로직은 여기에 추가될 예정)
        INSERT INTO temp (txt) VALUES (
            CONCAT('규칙 ID: ', v_rule_id, 
                   ', 이름: ', v_name, 
                   ', 유형: ', v_type, 
                   ', 방향: ', v_direction, 
                   ', 기간: ', v_duration, 
                   ', 단위: ', v_unit, 
                   ', 임계값: ', v_threshold, 
                   ', 조치사항: ', v_action)
        );
       
        -- '시간' 단위를 '분'으로 변환
        IF v_unit = '시간' THEN 
            SET v_duration = v_duration * 60;
        END IF;

        -- 현재 시간을 00분 형태로 계산하고 v_duration으로 나눈 나머지 확인
        SET @current_minutes = MINUTE(NOW());
        IF @current_minutes % v_duration != 0 THEN
			INSERT INTO temp (txt) VALUES( CONCAT(
            	v_duration, '-', @current_minutes ,' : 미동작', '-' , v_type, ' 로그 - v_direction : ', v_direction,', '
	            , DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration * 2 MINUTE) , '%Y%m%d%H%i%s') 
	            , ', '
	            , DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration MINUTE), '%Y%m%d%H%i%s')
	            , ', '
	            , DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
            ));
			ITERATE read_loop;
        END IF;
       
        -- 로직 상태 체크 경우
        IF v_type <> '반복수행' THEN
            INSERT INTO temp (txt) VALUES( CONCAT(
            	'거래량 로그 - v_direction : ', v_direction,', '
	            , DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration * 2 MINUTE) , '%Y%m%d%H%i%s') 
	            , ', '
	            , DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration MINUTE), '%Y%m%d%H%i%s')
	            , ', '
	            , DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
            ));
           
           
			-- 거래량을 가져오는 쿼리
           
           INSERT INTO temp_rule (
           rule_id, rule_nm,
			    svc_id, svc_nm, svc_cnt, bf_svc_cnt, bf_err_cnt, af_svc_cnt, af_err_cnt,
			    tx_zero_yn, tx_ratio, tx_err_ratio, tx_ratio_yn, tx_err_ratio_yn,
			    bf_startDttm, bf_endDttm, af_startDttm, af_endDttm, type, duration, direction, threshold
			)
			
           
			SELECT
				v_rule_id as rule_id
			    , v_name as rule_nm
				, svc_id
				, svc_nm
				, svc_cnt
				, bf_svc_cnt
				, bf_err_cnt
				, af_svc_cnt
				, af_err_cnt
				, CASE WHEN bf_svc_cnt > 0 AND af_svc_cnt = 0 and v_type = '거래량' THEN 'Y' ELSE 'N' END AS tx_zero_yn -- 무거래 적중인 경우 'Y'
				, case when af_svc_cnt > 0 and bf_svc_cnt  > 0 then ( af_svc_cnt / bf_svc_cnt)*100 else 0 end tx_ratio -- 거래증감율
				, case when af_err_cnt > 0 and bf_err_cnt  > 0 then ( af_err_cnt / bf_err_cnt)*100 else 0 end tx_err_ratio -- 에러증감율
				
				, case when v_type = '거래량' and af_svc_cnt > 0 and bf_svc_cnt  > 0 and v_threshold > 0 then 
					case when v_direction = '증가' then 
						case when ( af_svc_cnt / bf_svc_cnt)*100 >= v_threshold then 'Y' else 'N' end 
						else  case when ( af_svc_cnt / bf_svc_cnt)*100 <= v_threshold then 'Y' else 'N' end  end
					else 'N' end as tx_ratio_yn -- 증가나 감소 적중인 경우 'Y'
				-- 에러증감율에 대한 적중 여부
				
				, case when v_type = '오류율' and af_err_cnt > 0 and bf_err_cnt  > 0 and v_threshold > 0 then 
				    case when v_direction = '증가' then 
				        case when ( af_err_cnt / bf_err_cnt) * 100 >= v_threshold then 'Y' else 'N' end 
				    else 
				        case when ( af_err_cnt / bf_err_cnt ) * 100 <= v_threshold then 'Y' else 'N' end  
				    end
				else 'N' end as tx_err_ratio_yn -- 에러증감율 적중 여부 'Y'	
				
				, DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration * 2 MINUTE) , '%Y%m%d%H%i%s') as bf_startDttm
				, DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration MINUTE), '%Y%m%d%H%i%s') as bf_endDttm
				, DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration MINUTE), '%Y%m%d%H%i%s') as af_startDttm
				, DATE_FORMAT(NOW(), '%Y%m%d%H%i%s') as af_endDttm
				, v_type as type
				, v_duration as duration
				, v_direction as direction 
				, v_threshold as threshold
			FROM (
				SELECT
				    al.svc_id
					, al.svc_nm
					, al.svc_cnt
					, nvl(bf.svc_cnt,0) as bf_svc_cnt
					, nvl(bf.err_cnt,0) as bf_err_cnt
					, nvl(af.svc_cnt,0) as af_svc_cnt
					, nvl(af.err_cnt,0) as af_err_cnt
							
				FROM (
					SELECT
						'all' as dvcd
						, svc_id
						, svc_nm
						, nvl(count(*),0) as svc_cnt
						, nvl(sum( case when al.res_cd <> 'Succ' then 1 else 0 end ),0) as err_cnt
					FROM svcdata al
					WHERE al.req_dttm BETWEEN DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration * 2 MINUTE) , '%Y%m%d%H%i%s')
					                   AND DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 0 MINUTE), '%Y%m%d%H%i%s')
					group by al.svc_id
				) al
				LEFT OUTER JOIN (
					SELECT 
						'bf' as dvcd 
						, bf.svc_id
						, nvl(count(bf.svc_id),0) as svc_cnt 
						, nvl(sum( case when bf.res_cd <> 'Succ' then 1 else 0 end ),0) as err_cnt
						, DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration* 2 MINUTE) , '%Y%m%d%H%i%s') as startDttm
						, DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration MINUTE), '%Y%m%d%H%i%s') as endDttm
					FROM svcdata bf
					WHERE bf.req_dttm BETWEEN DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration * 2 MINUTE) , '%Y%m%d%H%i%s')
					                   AND DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration MINUTE), '%Y%m%d%H%i%s')
					group by bf.svc_id
				) bf ON al.svc_id = bf.svc_id
				LEFT OUTER JOIN ( 
					SELECT  
						'af'
						, af.svc_id
						, nvl(count(af.svc_id),0) as svc_cnt
						, nvl(sum( case when af.res_cd <> 'Succ' then 1 else 0 end ),0) as err_cnt
						, DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration MINUTE), '%Y%m%d%H%i%s') as startDttm
						, DATE_FORMAT(NOW(), '%Y%m%d%H%i%s') as endDttm
					FROM svcdata af 
					WHERE req_dttm BETWEEN DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_duration MINUTE), '%Y%m%d%H%i%s')
					AND DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
					GROUP BY af.svc_id 
				) af ON al.SVC_ID = af.SVC_ID
				WHERE 1=1
			) TMP WHERE 1=1;
		
            	
            
            
        
        END IF; -- 거래량 처리
        
    END LOOP;
    
    -- 커서 닫기
    CLOSE ruleset_cursor;
   
    
   
    INSERT INTO kisb.ruledata
	(rule_id, rule_nm, svc_id, svc_nm, svc_cnt, bf_svc_cnt, bf_err_cnt, af_svc_cnt, af_err_cnt, tx_zero_yn, tx_ratio, tx_err_ratio, tx_ratio_yn, tx_err_ratio_yn, bf_startDttm, bf_endDttm, af_startDttm, af_endDttm, `type`, duration, direction, threshold, detect_status)
    
	select 
    	rule_id, rule_nm, svc_id, svc_nm, svc_cnt, bf_svc_cnt, bf_err_cnt, af_svc_cnt, af_err_cnt, tx_zero_yn, tx_ratio, tx_err_ratio, tx_ratio_yn, tx_err_ratio_yn, bf_startDttm, bf_endDttm,af_startDttm, af_endDttm,`type`, duration, direction, threshold , '확인전'
    from temp_rule
    where 1=1
    and 1 = case 
	    when type = '거래량' and direction = '무거래' and tx_zero_yn = 'Y' then 1
	    when type = '거래량' and direction in ('증가','감소') and tx_ratio_yn = 'Y' then 1
	    when type = '오류율' and direction in ('증가','감소') and tx_err_ratio_yn = 'Y' then 1
	else 0 end;
	INSERT INTO temp(txt)
	SELECT concat(ROW_COUNT(), '행 탐지') ;

	select * from temp_rule;

	-- 임시 테이블 데이터 출력
    SELECT * FROM temp;
   -- 작업 테이블 데이터 출력(디버깅용)
   
END
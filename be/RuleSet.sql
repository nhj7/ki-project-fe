-- kisb.RuleSet definition
-- make mysql

CREATE TABLE `RuleSet` (
  `action` varchar(255) DEFAULT NULL COMMENT '조치사항(설명)',
  `direction` varchar(255) DEFAULT NULL COMMENT '데이터방향',
  `duration` varchar(255) DEFAULT NULL COMMENT '기간',
  `name` varchar(255) DEFAULT NULL COMMENT '룰명칭',
  `rule_id` varchar(255) DEFAULT NULL COMMENT '룰ID',
  `threshold` int(11) DEFAULT NULL COMMENT '임계값',
  `type` varchar(255) DEFAULT NULL COMMENT '규칙유형',
  `unit` varchar(255) DEFAULT NULL COMMENT '단위',
  `enabled` bit(1) DEFAULT NULL COMMENT '사용여부',
  UNIQUE KEY `RuleSet_pk` (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
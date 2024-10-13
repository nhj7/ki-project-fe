-- kisb.svcdata definition

CREATE TABLE `svcdata` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `guid` varchar(255) DEFAULT NULL,
  `req_dttm` varchar(255) DEFAULT NULL,
  `res_cd` varchar(255) DEFAULT NULL,
  `svc_id` varchar(255) DEFAULT NULL,
  `svc_nm` varchar(255) DEFAULT NULL,
  `svc_status` varchar(255) DEFAULT NULL,
  `system_cd` varchar(255) DEFAULT NULL,
  `res_dttm_date` varchar(10) GENERATED ALWAYS AS (substr(`req_dttm`,1,10)) VIRTUAL,
  `res_dt` varchar(10) GENERATED ALWAYS AS (substr(`req_dttm`,1,8)) VIRTUAL,
  PRIMARY KEY (`id`),
  KEY `idx_svc_res_dt_guid` (`res_dt`,`guid`),
  KEY `idx_svcdata_res_dt_guid` (`res_dt`,`guid`),
  KEY `idx_svcdata_req_dttm` (`req_dttm` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=170745 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
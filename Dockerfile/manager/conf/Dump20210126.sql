CREATE DATABASE  IF NOT EXISTS `klevr` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `klevr`;
-- MariaDB dump 10.18  Distrib 10.5.8-MariaDB, for Win64 (AMD64)
CREATE USER 'klevr'@'%' identified by 'klevr';
GRANT ALL PRIVILEGES ON klevr.* to `klevr`@`%`;
--
-- Host: 192.168.10.10    Database: klevr
-- ------------------------------------------------------
-- Server version	10.5.8-MariaDB-1:10.5.8+maria~focal

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `AGENTS`
--

DROP TABLE IF EXISTS `AGENTS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AGENTS` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '에이전트 ID',
  `AGENT_KEY` varchar(45) DEFAULT NULL COMMENT '에이전트 고유 식별 키 (향후 unique 키로 만들어야 함 - 현재는 개발중)',
  `GROUP_ID` bigint(20) unsigned NOT NULL COMMENT '에이전트 그룹 ID',
  `IS_ACTIVE` tinyint(1) NOT NULL DEFAULT 0 COMMENT '에이전트 활성 여부',
  `LAST_ALIVE_CHECK_TIME` timestamp NULL DEFAULT NULL COMMENT '마스터를 통해 마지막 에이전트 생존 확인 시간',
  `LAST_ACCESS_TIME` timestamp NULL DEFAULT NULL COMMENT '마지막 agent가 매니저에 직접 엑세스한 타임스탬프',
  `IP` varchar(45) DEFAULT NULL COMMENT '에이전트 IP (동일 에이전트 그룹간 통신 가능한 IP)',
  `PORT` int(11) DEFAULT NULL,
  `HMAC_KEY` varchar(100) DEFAULT NULL COMMENT '전송 데이터 위변조 검사용 키',
  `ENC_KEY` varchar(100) DEFAULT NULL COMMENT '전송구간 데이터 암호화 키',
  `CREATED_AT` timestamp NULL DEFAULT current_timestamp(),
  `UPDATED_AT` timestamp NULL DEFAULT current_timestamp(),
  `DELETED_AT` timestamp NULL DEFAULT NULL,
  `CPU` varchar(50) DEFAULT NULL,
  `MEMORY` varchar(50) DEFAULT NULL,
  `DISK` varchar(50) DEFAULT NULL,
  `VERSION` varchar(45) DEFAULT NULL COMMENT '에이전트 버전',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='Agent 테이블\n전체 agent 정보를 관리';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AGENT_GROUPS`
--

DROP TABLE IF EXISTS `AGENT_GROUPS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AGENT_GROUPS` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '그룹 ID',
  `GROUP_NAME` varchar(200) NOT NULL COMMENT '그룹 이름',
  `USER_ID` bigint(20) unsigned NOT NULL COMMENT '사용자 ID',
  `PLATFORM` varchar(45) NOT NULL COMMENT '플랫폼(baremetal, k8s, aws 등)',
  `CREATED_AT` timestamp NULL DEFAULT current_timestamp(),
  `UPDATED_AT` timestamp NULL DEFAULT current_timestamp(),
  `DELETED_AT` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `UNQ_01` (`USER_ID`,`PLATFORM`,`GROUP_NAME`),
  KEY `IDX_01` (`USER_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='agent 그룹 관리 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `API_AUTHENTICATIONS`
--

DROP TABLE IF EXISTS `API_AUTHENTICATIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `API_AUTHENTICATIONS` (
  `API_KEY` varchar(100) NOT NULL COMMENT 'API key',
  `GROUP_ID` bigint(20) unsigned NOT NULL COMMENT '그룹 ID',
  `CREATED_AT` timestamp NULL DEFAULT current_timestamp(),
  `UPDATED_AT` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='인증 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PAGE_MEMBERS`
--

DROP TABLE IF EXISTS `PAGE_MEMBERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PAGE_MEMBERS` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(45) COLLATE utf8_bin NOT NULL,
  `USER_PASSWORD` varchar(45) COLLATE utf8_bin NOT NULL,
  `ACTIVATED` tinyint(1) NOT NULL DEFAULT 0,
  `API_KEY` varchar(100) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PAGE 사용자 인증';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PRIMARY_AGENTS`
--

DROP TABLE IF EXISTS `PRIMARY_AGENTS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PRIMARY_AGENTS` (
  `GROUP_ID` bigint(20) unsigned NOT NULL COMMENT '에이전트의 group ID',
  `AGENT_ID` bigint(20) unsigned NOT NULL COMMENT '에이전트 ID',
  `CREATED_AT` timestamp NULL DEFAULT current_timestamp(),
  `UPDATED_AT` timestamp NULL DEFAULT current_timestamp(),
  `DELETED_AT` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`GROUP_ID`,`AGENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Primary 에이전트 관리 테이블\n그룹별 하나의 primary 에이전트를 관리한다.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TASKS`
--

DROP TABLE IF EXISTS `TASKS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TASKS` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `TASK_TYPE` varchar(45) DEFAULT NULL COMMENT 'atOnce(한번만 실행), iteration(반복 수행), longTerm(장기간 수행)',
  `SCHEDULE` timestamp NULL DEFAULT NULL COMMENT 'TASK 수행 일정 (연월일시분 or null:즉시)',
  `ZONE_ID` bigint(20) unsigned NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `AGENT_KEY` varchar(45) DEFAULT NULL COMMENT 'TASK를 수행할 에이전트 key',
  `EXE_AGENT_KEY` varchar(45) DEFAULT NULL COMMENT 'TASK가 실제 수행된 에이전트 key',
  `STATUS` varchar(45) NOT NULL COMMENT 'TASK 상태',
  `CREATED_AT` timestamp NULL DEFAULT current_timestamp(),
  `UPDATED_AT` timestamp NULL DEFAULT current_timestamp(),
  `DELETED_AT` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_TASKS_01` (`SCHEDULE`),
  KEY `IDX_TASKS_02` (`DELETED_AT`),
  KEY `IDX_TASKS_03` (`STATUS`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='TASK 수행 정보 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TASK_DETAIL`
--

DROP TABLE IF EXISTS `TASK_DETAIL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TASK_DETAIL` (
  `TASK_ID` bigint(20) unsigned NOT NULL,
  `CRON` varchar(45) DEFAULT NULL COMMENT 'TASK 타입이 iteration일 경우 반복 실행 cron 주기',
  `UNTIL_RUN` timestamp NULL DEFAULT NULL COMMENT 'TASK 타입이 iteration일 경우 실행 기한',
  `TIMEOUT` int(11) DEFAULT 0 COMMENT 'TASK 실행 timeout 시간 (seconds)',
  `EXE_AGENT_CHANGEABLE` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'TASK를 수행할 에이전트 변동 가능 여부',
  `TOTAL_STEP_COUNT` int(11) DEFAULT NULL COMMENT '전체 TASK STEP 수',
  `CURRENT_STEP` int(11) DEFAULT NULL COMMENT '현재 진행중인 TASK STEP 번호 (대기 or 실행중)',
  `HAS_RECOVER` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'RECOVER STEP 존재 여부',
  `PARAMETER` text DEFAULT NULL COMMENT 'TASK 실행 파라미터(JSON)',
  `CALLBACK_URL` varchar(300) DEFAULT NULL COMMENT 'TASK 완료 결과를 전달받을 URL(Klevr manager 외의 별도 등록 서버)',
  `RESULT` text DEFAULT NULL COMMENT 'TASK 수행 결과물',
  `FAILED_STEP` int(11) DEFAULT NULL,
  `IS_FAILED_RECOVER` tinyint(1) NOT NULL DEFAULT 0,
  `SHOW_LOG` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'TASK LOG(STDOUT/STDERR) 출력 여부',
  `EVENT_HOOK_SENDING_TYPE` VARCHAR(45) NULL DEFAULT NULL COMMENT '이벤트 훅 전송 조건',
  PRIMARY KEY (`TASK_ID`),
  CONSTRAINT `FK` FOREIGN KEY (`TASK_ID`) REFERENCES `TASKS` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='TASK 실행 상세 정보 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TASK_LOCK`
--

DROP TABLE IF EXISTS `TASK_LOCK`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TASK_LOCK` (
  `TASK` varchar(45) NOT NULL COMMENT 'lock을 잡은 task 명',
  `INSTANCE_ID` varchar(45) NOT NULL COMMENT 'lock을 잡은 인스턴스 ID',
  `LOCK_DATE` timestamp NULL DEFAULT NULL COMMENT 'lock이 걸린 일시',
  PRIMARY KEY (`TASK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='배치성 작업을 위해 lock을 관리하는 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TASK_LOGS`
--

DROP TABLE IF EXISTS `TASK_LOGS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TASK_LOGS` (
  `TASK_ID` bigint(20) unsigned NOT NULL,
  `LOGS` mediumtext DEFAULT NULL,
  PRIMARY KEY (`TASK_ID`),
  CONSTRAINT `FK_TASK_LOGS` FOREIGN KEY (`TASK_ID`) REFERENCES `TASKS` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='TASK의 수행 로그 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TASK_STEPS`
--

DROP TABLE IF EXISTS `TASK_STEPS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TASK_STEPS` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `TASK_ID` bigint(20) unsigned NOT NULL,
  `SEQ` int(11) DEFAULT NULL COMMENT '실행 순서',
  `COMMAND_NAME` varchar(100) NOT NULL COMMENT '커맨드명',
  `COMMAND_TYPE` varchar(45) NOT NULL COMMENT '커맨드 타입(reserved, inline)',
  `RESERVED_COMMAND` varchar(100) DEFAULT NULL COMMENT '예약어 커맨드명',
  `INLINE_SCRIPT` text DEFAULT NULL COMMENT 'Inline 스크립트',
  `IS_RECOVER` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'recover 스텝 여부',
  PRIMARY KEY (`ID`),
  KEY `FK_TASK_STEPS_idx` (`TASK_ID`),
  CONSTRAINT `FK_TASK_STEPS` FOREIGN KEY (`TASK_ID`) REFERENCES `TASKS` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-01-26 10:38:12

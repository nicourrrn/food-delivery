-- MariaDB dump 10.19  Distrib 10.6.7-MariaDB, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: test_delivery
-- ------------------------------------------------------
-- Server version	10.6.7-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `baskets`
--

DROP TABLE IF EXISTS `baskets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `baskets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` int(11) NOT NULL,
  `coordinates_to_id` int(11) DEFAULT NULL,
  `paid` tinyint(1) DEFAULT 0,
  `closed` tinyint(1) DEFAULT 0,
  `editable` tinyint(1) DEFAULT 1,
  `final_price` float DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `baskets_coordinates_id_fk` (`coordinates_to_id`),
  KEY `baskets_client_info_user_id_fk` (`client_id`),
  CONSTRAINT `baskets_client_info_user_id_fk` FOREIGN KEY (`client_id`) REFERENCES `client_info` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `baskets_coordinates_id_fk` FOREIGN KEY (`coordinates_to_id`) REFERENCES `coordinates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `baskets`
--

LOCK TABLES `baskets` WRITE;
/*!40000 ALTER TABLE `baskets` DISABLE KEYS */;
/*!40000 ALTER TABLE `baskets` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_baskets` BEFORE UPDATE ON `baskets` FOR EACH ROW BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP();
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `client_coordinates`
--

DROP TABLE IF EXISTS `client_coordinates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `client_coordinates` (
  `client_id` int(11) NOT NULL,
  `coordinate_id` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  KEY `users_coordinates_coordinates_id_fk` (`coordinate_id`),
  KEY `users_coordinates_users_id_fk` (`client_id`),
  CONSTRAINT `users_coordinates_coordinates_id_fk` FOREIGN KEY (`coordinate_id`) REFERENCES `coordinates` (`id`) ON DELETE CASCADE,
  CONSTRAINT `users_coordinates_users_id_fk` FOREIGN KEY (`client_id`) REFERENCES `client_info` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_coordinates`
--

LOCK TABLES `client_coordinates` WRITE;
/*!40000 ALTER TABLE `client_coordinates` DISABLE KEYS */;
INSERT INTO `client_coordinates` VALUES (42,19,NULL,'2022-02-15 15:32:23'),(43,20,NULL,'2022-02-15 15:32:23'),(44,21,NULL,'2022-02-15 15:32:23'),(45,22,NULL,'2022-02-15 15:32:32'),(46,23,NULL,'2022-02-15 15:32:32'),(47,24,NULL,'2022-02-15 15:32:32'),(48,25,NULL,'2022-02-15 16:00:08'),(49,26,NULL,'2022-02-15 16:00:08'),(50,27,NULL,'2022-02-15 16:00:08'),(53,28,NULL,'2022-02-15 16:00:35'),(54,29,NULL,'2022-02-15 16:00:35'),(55,30,NULL,'2022-02-15 16:00:35'),(66,31,NULL,'2022-02-15 16:03:10'),(67,32,NULL,'2022-02-15 16:03:10'),(68,33,NULL,'2022-02-15 16:03:10'),(70,34,NULL,'2022-02-15 16:08:55'),(71,35,NULL,'2022-02-15 16:08:55'),(72,36,NULL,'2022-02-15 16:08:55'),(83,37,NULL,'2022-02-15 16:12:29'),(84,38,NULL,'2022-02-15 16:12:29'),(85,39,NULL,'2022-02-15 16:12:29'),(87,40,NULL,'2022-02-15 16:13:11'),(88,41,NULL,'2022-02-15 16:13:11'),(89,42,NULL,'2022-02-15 16:13:11'),(91,43,NULL,'2022-02-15 16:14:31'),(92,44,NULL,'2022-02-15 16:14:31'),(93,45,NULL,'2022-02-15 16:14:31'),(95,46,NULL,'2022-02-15 16:15:25'),(96,47,NULL,'2022-02-15 16:15:25'),(97,48,NULL,'2022-02-15 16:15:25'),(99,49,NULL,'2022-02-15 16:15:55'),(100,50,NULL,'2022-02-15 16:15:55'),(101,51,NULL,'2022-02-15 16:15:55'),(103,52,NULL,'2022-02-15 16:16:39'),(104,53,NULL,'2022-02-15 16:16:39'),(105,54,NULL,'2022-02-15 16:16:39'),(107,55,NULL,'2022-02-15 16:17:06'),(108,56,NULL,'2022-02-15 16:17:06'),(109,57,NULL,'2022-02-15 16:17:06'),(111,58,NULL,'2022-02-15 16:18:27'),(112,59,NULL,'2022-02-15 16:18:27'),(113,60,NULL,'2022-02-15 16:18:27'),(115,61,NULL,'2022-02-15 16:20:10'),(116,62,NULL,'2022-02-15 16:20:10'),(117,63,NULL,'2022-02-15 16:20:10'),(119,64,NULL,'2022-02-15 16:24:42'),(120,65,NULL,'2022-02-15 16:24:42'),(121,66,NULL,'2022-02-15 16:24:42'),(123,67,NULL,'2022-02-15 16:26:27'),(124,68,NULL,'2022-02-15 16:26:27'),(125,69,NULL,'2022-02-15 16:26:27'),(127,70,NULL,'2022-02-15 16:27:25'),(128,71,NULL,'2022-02-15 16:27:25'),(129,72,NULL,'2022-02-15 16:27:25'),(131,73,NULL,'2022-02-15 16:28:41'),(132,74,NULL,'2022-02-15 16:28:41'),(133,75,NULL,'2022-02-15 16:28:41'),(135,76,NULL,'2022-02-15 16:30:46'),(136,77,NULL,'2022-02-15 16:30:46'),(137,78,NULL,'2022-02-15 16:30:46'),(139,79,NULL,'2022-02-15 16:31:32'),(140,80,NULL,'2022-02-15 16:31:32'),(141,81,NULL,'2022-02-15 16:31:32'),(146,82,NULL,'2022-02-15 16:33:11'),(147,83,NULL,'2022-02-15 16:33:11'),(148,84,NULL,'2022-02-15 16:33:11'),(153,85,NULL,'2022-02-15 16:33:59'),(154,86,NULL,'2022-02-15 16:33:59'),(155,87,NULL,'2022-02-15 16:33:59'),(158,88,NULL,'2022-02-15 16:36:12'),(159,89,NULL,'2022-02-15 16:36:12'),(160,90,NULL,'2022-02-15 16:36:12'),(163,91,NULL,'2022-02-15 16:36:49'),(164,92,NULL,'2022-02-15 16:36:49'),(165,93,NULL,'2022-02-15 16:36:49'),(168,94,NULL,'2022-02-15 16:37:32'),(169,95,NULL,'2022-02-15 16:37:32'),(170,96,NULL,'2022-02-15 16:37:32'),(173,97,NULL,'2022-02-15 16:39:11'),(174,98,NULL,'2022-02-15 16:39:11'),(175,99,NULL,'2022-02-15 16:39:11'),(178,100,NULL,'2022-02-15 16:39:55'),(179,101,NULL,'2022-02-15 16:39:55'),(180,102,NULL,'2022-02-15 16:39:55'),(185,104,NULL,'2022-02-15 16:41:19'),(186,105,NULL,'2022-02-15 16:41:19'),(187,106,NULL,'2022-02-15 16:41:19'),(192,108,NULL,'2022-02-15 16:42:15'),(193,109,NULL,'2022-02-15 16:42:15'),(194,110,NULL,'2022-02-15 16:42:15'),(199,112,NULL,'2022-02-15 16:42:33'),(200,113,NULL,'2022-02-15 16:42:33'),(201,114,NULL,'2022-02-15 16:42:33'),(206,116,NULL,'2022-02-15 16:43:24'),(207,117,NULL,'2022-02-15 16:43:24'),(208,118,NULL,'2022-02-15 16:43:24'),(229,129,NULL,'2022-02-15 16:43:38'),(230,130,NULL,'2022-02-15 16:43:38'),(231,131,NULL,'2022-02-15 16:43:38'),(252,142,NULL,'2022-02-15 16:48:46'),(253,143,NULL,'2022-02-15 16:48:46'),(254,144,NULL,'2022-02-15 16:48:46'),(256,145,NULL,'2022-02-15 16:48:57'),(257,146,NULL,'2022-02-15 16:48:57'),(258,147,NULL,'2022-02-15 16:48:57'),(260,148,NULL,'2022-02-15 16:51:37'),(261,149,NULL,'2022-02-15 16:51:37'),(262,150,NULL,'2022-02-15 16:51:37'),(264,151,NULL,'2022-02-15 16:52:12'),(265,152,NULL,'2022-02-15 16:52:12'),(266,153,NULL,'2022-02-15 16:52:12'),(268,154,NULL,'2022-02-15 16:52:35'),(269,155,NULL,'2022-02-15 16:52:35'),(270,156,NULL,'2022-02-15 16:52:35'),(291,167,NULL,'2022-02-15 16:52:39'),(292,168,NULL,'2022-02-15 16:52:39'),(293,169,NULL,'2022-02-15 16:52:39'),(314,180,NULL,'2022-02-15 16:59:29'),(315,181,NULL,'2022-02-15 16:59:29'),(316,182,NULL,'2022-02-15 16:59:29'),(318,183,NULL,'2022-02-15 16:59:56'),(319,184,NULL,'2022-02-15 16:59:56'),(320,185,NULL,'2022-02-15 16:59:56');
/*!40000 ALTER TABLE `client_coordinates` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_client_coordinates` BEFORE UPDATE ON `client_coordinates` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `client_info`
--

DROP TABLE IF EXISTS `client_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `client_info` (
  `user_id` int(11) NOT NULL,
  `phone` varchar(16) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  KEY `client_info_users_id_fk` (`user_id`),
  CONSTRAINT `client_info_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client_info`
--

LOCK TABLES `client_info` WRITE;
/*!40000 ALTER TABLE `client_info` DISABLE KEYS */;
INSERT INTO `client_info` VALUES (21,'637-892-5110',NULL,'2022-02-15 15:14:18'),(22,'394-865-1271',NULL,'2022-02-15 15:14:18'),(23,'614-352-1078',NULL,'2022-02-15 15:14:18'),(24,'172-103-9548',NULL,'2022-02-15 15:16:14'),(25,'365-110-7824',NULL,'2022-02-15 15:16:14'),(26,'748-935-2106',NULL,'2022-02-15 15:16:14'),(27,'101-482-7365',NULL,'2022-02-15 15:16:46'),(28,'643-891-0152',NULL,'2022-02-15 15:16:46'),(29,'256-108-1347',NULL,'2022-02-15 15:16:46'),(30,'378-106-1952',NULL,'2022-02-15 15:17:05'),(31,'814-391-0257',NULL,'2022-02-15 15:17:05'),(32,'914-835-2106',NULL,'2022-02-15 15:17:05'),(33,'961-107-3482',NULL,'2022-02-15 15:17:45'),(34,'106-493-8127',NULL,'2022-02-15 15:17:45'),(35,'961-437-8102',NULL,'2022-02-15 15:17:45'),(36,'472-563-1981',NULL,'2022-02-15 15:17:54'),(37,'915-461-0873',NULL,'2022-02-15 15:17:54'),(38,'213-581-0694',NULL,'2022-02-15 15:17:54'),(39,'831-497-5621',NULL,'2022-02-15 15:20:30'),(40,'473-261-0859',NULL,'2022-02-15 15:20:30'),(41,'295-310-4168',NULL,'2022-02-15 15:20:30'),(42,'681-037-4512',NULL,'2022-02-15 15:32:23'),(43,'723-941-5610',NULL,'2022-02-15 15:32:23'),(44,'354-916-2108',NULL,'2022-02-15 15:32:23'),(45,'573-461-2891',NULL,'2022-02-15 15:32:32'),(46,'237-465-1891',NULL,'2022-02-15 15:32:32'),(47,'108-257-3649',NULL,'2022-02-15 15:32:32'),(48,'871-091-4362',NULL,'2022-02-15 16:00:08'),(49,'357-624-1089',NULL,'2022-02-15 16:00:08'),(50,'195-107-3246',NULL,'2022-02-15 16:00:08'),(53,'101-476-9583',NULL,'2022-02-15 16:00:35'),(54,'210-851-3496',NULL,'2022-02-15 16:00:35'),(55,'610-842-1397',NULL,'2022-02-15 16:00:35'),(66,'943-276-1018',NULL,'2022-02-15 16:03:10'),(67,'793-641-8510',NULL,'2022-02-15 16:03:10'),(68,'954-311-0827',NULL,'2022-02-15 16:03:10'),(70,'482-561-9103',NULL,'2022-02-15 16:08:55'),(71,'816-107-4239',NULL,'2022-02-15 16:08:55'),(72,'251-971-0648',NULL,'2022-02-15 16:08:55'),(83,'107-629-5418',NULL,'2022-02-15 16:12:29'),(84,'106-831-9245',NULL,'2022-02-15 16:12:29'),(85,'315-107-9826',NULL,'2022-02-15 16:12:29'),(87,'589-276-3410',NULL,'2022-02-15 16:13:11'),(88,'141-095-7328',NULL,'2022-02-15 16:13:11'),(89,'101-549-2678',NULL,'2022-02-15 16:13:11'),(91,'128-476-9510',NULL,'2022-02-15 16:14:31'),(92,'618-743-9105',NULL,'2022-02-15 16:14:31'),(93,'678-310-2451',NULL,'2022-02-15 16:14:31'),(95,'486-127-5391',NULL,'2022-02-15 16:15:25'),(96,'310-152-6849',NULL,'2022-02-15 16:15:25'),(97,'415-732-8961',NULL,'2022-02-15 16:15:25'),(99,'371-628-5910',NULL,'2022-02-15 16:15:55'),(100,'638-479-1025',NULL,'2022-02-15 16:15:55'),(101,'211-086-7943',NULL,'2022-02-15 16:15:55'),(103,'619-710-3428',NULL,'2022-02-15 16:16:39'),(104,'437-865-1109',NULL,'2022-02-15 16:16:39'),(105,'710-593-6241',NULL,'2022-02-15 16:16:39'),(107,'162-845-7310',NULL,'2022-02-15 16:17:06'),(108,'751-062-9184',NULL,'2022-02-15 16:17:06'),(109,'927-451-1036',NULL,'2022-02-15 16:17:06'),(111,'875-264-1093',NULL,'2022-02-15 16:18:27'),(112,'749-512-8103',NULL,'2022-02-15 16:18:27'),(113,'910-782-1643',NULL,'2022-02-15 16:18:27'),(115,'613-459-1082',NULL,'2022-02-15 16:20:10'),(116,'829-617-5410',NULL,'2022-02-15 16:20:10'),(117,'347-912-6510',NULL,'2022-02-15 16:20:10'),(119,'171-035-6498',NULL,'2022-02-15 16:24:42'),(120,'165-742-9810',NULL,'2022-02-15 16:24:42'),(121,'210-935-1684',NULL,'2022-02-15 16:24:42'),(123,'536-748-9121',NULL,'2022-02-15 16:26:27'),(124,'924-110-5837',NULL,'2022-02-15 16:26:27'),(125,'593-710-6428',NULL,'2022-02-15 16:26:27'),(127,'594-187-3106',NULL,'2022-02-15 16:27:25'),(128,'462-710-8315',NULL,'2022-02-15 16:27:25'),(129,'738-610-9541',NULL,'2022-02-15 16:27:25'),(131,'347-158-9261',NULL,'2022-02-15 16:28:41'),(132,'235-104-8679',NULL,'2022-02-15 16:28:41'),(133,'104-762-5318',NULL,'2022-02-15 16:28:41'),(135,'869-510-1427',NULL,'2022-02-15 16:30:46'),(136,'249-768-5103',NULL,'2022-02-15 16:30:46'),(137,'101-892-4573',NULL,'2022-02-15 16:30:46'),(139,'625-893-4710',NULL,'2022-02-15 16:31:32'),(140,'751-431-0628',NULL,'2022-02-15 16:31:32'),(141,'964-257-3101',NULL,'2022-02-15 16:31:32'),(146,'106-251-4897',NULL,'2022-02-15 16:33:11'),(147,'210-758-4196',NULL,'2022-02-15 16:33:11'),(148,'351-102-6894',NULL,'2022-02-15 16:33:11'),(153,'957-132-1086',NULL,'2022-02-15 16:33:59'),(154,'319-582-1047',NULL,'2022-02-15 16:33:59'),(155,'925-841-3106',NULL,'2022-02-15 16:33:59'),(158,'716-589-1032',NULL,'2022-02-15 16:36:12'),(159,'725-146-3910',NULL,'2022-02-15 16:36:12'),(160,'362-475-1098',NULL,'2022-02-15 16:36:12'),(163,'106-173-8592',NULL,'2022-02-15 16:36:49'),(164,'671-581-0349',NULL,'2022-02-15 16:36:49'),(165,'891-072-5163',NULL,'2022-02-15 16:36:49'),(168,'978-246-1051',NULL,'2022-02-15 16:37:32'),(169,'841-016-9732',NULL,'2022-02-15 16:37:32'),(170,'487-395-2611',NULL,'2022-02-15 16:37:32'),(173,'671-948-1023',NULL,'2022-02-15 16:39:11'),(174,'956-471-0312',NULL,'2022-02-15 16:39:11'),(175,'857-103-2941',NULL,'2022-02-15 16:39:11'),(178,'386-192-1075',NULL,'2022-02-15 16:39:55'),(179,'754-863-9101',NULL,'2022-02-15 16:39:55'),(180,'768-310-4521',NULL,'2022-02-15 16:39:55'),(185,'107-628-9145',NULL,'2022-02-15 16:41:19'),(186,'568-472-1910',NULL,'2022-02-15 16:41:19'),(187,'265-487-1013',NULL,'2022-02-15 16:41:19'),(192,'358-941-0671',NULL,'2022-02-15 16:42:15'),(193,'836-174-9251',NULL,'2022-02-15 16:42:15'),(194,'685-231-7104',NULL,'2022-02-15 16:42:15'),(199,'109-647-5821',NULL,'2022-02-15 16:42:33'),(200,'451-023-6879',NULL,'2022-02-15 16:42:33'),(201,'318-265-7109',NULL,'2022-02-15 16:42:33'),(206,'795-641-0381',NULL,'2022-02-15 16:43:24'),(207,'963-410-8572',NULL,'2022-02-15 16:43:24'),(208,'102-857-3649',NULL,'2022-02-15 16:43:24'),(229,'856-741-2109',NULL,'2022-02-15 16:43:38'),(230,'872-610-9543',NULL,'2022-02-15 16:43:38'),(231,'105-386-1427',NULL,'2022-02-15 16:43:38'),(252,'467-510-1239',NULL,'2022-02-15 16:48:46'),(253,'156-710-8923',NULL,'2022-02-15 16:48:46'),(254,'106-758-1493',NULL,'2022-02-15 16:48:46'),(256,'510-791-6324',NULL,'2022-02-15 16:48:57'),(257,'110-843-6975',NULL,'2022-02-15 16:48:57'),(258,'104-391-7562',NULL,'2022-02-15 16:48:57'),(260,'185-467-2910',NULL,'2022-02-15 16:51:37'),(261,'627-519-8310',NULL,'2022-02-15 16:51:37'),(262,'731-109-5628',NULL,'2022-02-15 16:51:37'),(264,'359-710-6824',NULL,'2022-02-15 16:52:12'),(265,'429-356-7101',NULL,'2022-02-15 16:52:12'),(266,'210-561-8934',NULL,'2022-02-15 16:52:12'),(268,'231-697-4581',NULL,'2022-02-15 16:52:35'),(269,'851-031-6497',NULL,'2022-02-15 16:52:35'),(270,'531-018-6479',NULL,'2022-02-15 16:52:35'),(291,'953-102-4867',NULL,'2022-02-15 16:52:39'),(292,'921-875-3641',NULL,'2022-02-15 16:52:39'),(293,'651-104-8793',NULL,'2022-02-15 16:52:39'),(314,'102-176-5849',NULL,'2022-02-15 16:59:29'),(315,'103-546-7982',NULL,'2022-02-15 16:59:29'),(316,'105-923-4817',NULL,'2022-02-15 16:59:29'),(318,'391-061-5427',NULL,'2022-02-15 16:59:56'),(319,'410-365-1972',NULL,'2022-02-15 16:59:56'),(320,'879-456-1031',NULL,'2022-02-15 16:59:56');
/*!40000 ALTER TABLE `client_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_client_info` BEFORE UPDATE ON `client_info` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `coordinates`
--

DROP TABLE IF EXISTS `coordinates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coordinates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) DEFAULT NULL,
  `x` float DEFAULT NULL,
  `y` float DEFAULT NULL,
  `humanized` varchar(128) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coordinates`
--

LOCK TABLES `coordinates` WRITE;
/*!40000 ALTER TABLE `coordinates` DISABLE KEYS */;
INSERT INTO `coordinates` VALUES (10,'distinctio',0.870946,0.758652,'',NULL,'2022-02-15 15:17:45'),(11,'asperiores',0.479818,0.566283,'',NULL,'2022-02-15 15:17:45'),(12,'pariatur',0.05163,0.322469,'',NULL,'2022-02-15 15:17:45'),(13,'asperiores',0.0737947,0.309095,'',NULL,'2022-02-15 15:17:54'),(14,'velit',0.75346,0.727679,'',NULL,'2022-02-15 15:17:54'),(15,'esse',0.122423,0.313895,'',NULL,'2022-02-15 15:17:54'),(16,'impedit',0.151909,0.352112,'',NULL,'2022-02-15 15:20:30'),(17,'voluptatem',0.713398,0.257874,'',NULL,'2022-02-15 15:20:30'),(18,'dolores',0.524669,0.505423,'',NULL,'2022-02-15 15:20:30'),(19,'ab',0.213874,0.889154,'',NULL,'2022-02-15 15:32:23'),(20,'blanditiis',0.125116,0.22662,'',NULL,'2022-02-15 15:32:23'),(21,'temporibus',0.627565,0.169008,'',NULL,'2022-02-15 15:32:23'),(22,'consequatur',0.0335025,0.768286,'',NULL,'2022-02-15 15:32:32'),(23,'modi',0.219252,0.863903,'',NULL,'2022-02-15 15:32:32'),(24,'id',0.332241,0.101381,'',NULL,'2022-02-15 15:32:32'),(25,'blanditiis',0.109683,0.0328318,'',NULL,'2022-02-15 16:00:08'),(26,'tenetur',0.458103,0.117014,'',NULL,'2022-02-15 16:00:08'),(27,'soluta',0.405007,0.06044,'',NULL,'2022-02-15 16:00:08'),(28,'dolorum',0.430208,0.86003,'',NULL,'2022-02-15 16:00:35'),(29,'deserunt',0.112998,0.322587,'',NULL,'2022-02-15 16:00:35'),(30,'dolor',0.939764,0.390406,'',NULL,'2022-02-15 16:00:35'),(31,'et',0.132085,0.802879,'',NULL,'2022-02-15 16:03:10'),(32,'quia',0.895645,0.0373866,'',NULL,'2022-02-15 16:03:10'),(33,'necessitatibus',0.781625,0.356343,'',NULL,'2022-02-15 16:03:10'),(34,'et',0.766363,0.0627229,'',NULL,'2022-02-15 16:08:55'),(35,'eum',0.245249,0.970173,'',NULL,'2022-02-15 16:08:55'),(36,'ipsum',0.618155,0.139501,'',NULL,'2022-02-15 16:08:55'),(37,'itaque',0.88372,0.806028,'',NULL,'2022-02-15 16:12:29'),(38,'sed',0.346574,0.78363,'',NULL,'2022-02-15 16:12:29'),(39,'nulla',0.190995,0.565293,'',NULL,'2022-02-15 16:12:29'),(40,'omnis',0.671759,0.00898527,'',NULL,'2022-02-15 16:13:11'),(41,'facilis',0.581453,0.68087,'',NULL,'2022-02-15 16:13:11'),(42,'ipsa',0.441315,0.929699,'',NULL,'2022-02-15 16:13:11'),(43,'ea',0.592716,0.544747,'',NULL,'2022-02-15 16:14:31'),(44,'impedit',0.205882,0.612362,'',NULL,'2022-02-15 16:14:31'),(45,'labore',0.828777,0.74046,'',NULL,'2022-02-15 16:14:31'),(46,'in',0.714632,0.505383,'',NULL,'2022-02-15 16:15:25'),(47,'minima',0.0961156,0.869031,'',NULL,'2022-02-15 16:15:25'),(48,'illo',0.250237,0.240182,'',NULL,'2022-02-15 16:15:25'),(49,'commodi',0.0448584,0.288179,'',NULL,'2022-02-15 16:15:55'),(50,'porro',0.26854,0.311363,'',NULL,'2022-02-15 16:15:55'),(51,'nisi',0.3009,0.906023,'',NULL,'2022-02-15 16:15:55'),(52,'sapiente',0.982723,0.601209,'',NULL,'2022-02-15 16:16:39'),(53,'harum',0.752841,0.368733,'',NULL,'2022-02-15 16:16:39'),(54,'non',0.98654,0.903366,'',NULL,'2022-02-15 16:16:39'),(55,'consequuntur',0.671407,0.637142,'',NULL,'2022-02-15 16:17:06'),(56,'vel',0.767272,0.143582,'',NULL,'2022-02-15 16:17:06'),(57,'asperiores',0.747604,0.370318,'',NULL,'2022-02-15 16:17:06'),(58,'corrupti',0.351599,0.20084,'',NULL,'2022-02-15 16:18:27'),(59,'nam',0.588461,0.765418,'',NULL,'2022-02-15 16:18:27'),(60,'aperiam',0.869982,0.126246,'',NULL,'2022-02-15 16:18:27'),(61,'dignissimos',0.82513,0.534261,'',NULL,'2022-02-15 16:20:10'),(62,'maxime',0.751543,0.496204,'',NULL,'2022-02-15 16:20:10'),(63,'consequatur',0.365798,0.20033,'',NULL,'2022-02-15 16:20:10'),(64,'asperiores',0.706596,0.707759,'',NULL,'2022-02-15 16:24:42'),(65,'commodi',0.227614,0.9464,'',NULL,'2022-02-15 16:24:42'),(66,'enim',0.0438798,0.430639,'',NULL,'2022-02-15 16:24:42'),(67,'voluptas',0.314582,0.174642,'',NULL,'2022-02-15 16:26:27'),(68,'deserunt',0.118735,0.30557,'',NULL,'2022-02-15 16:26:27'),(69,'recusandae',0.461191,0.778895,'',NULL,'2022-02-15 16:26:27'),(70,'modi',0.320167,0.135686,'',NULL,'2022-02-15 16:27:25'),(71,'nemo',0.492909,0.304283,'',NULL,'2022-02-15 16:27:25'),(72,'veritatis',0.396906,0.739279,'',NULL,'2022-02-15 16:27:25'),(73,'doloremque',0.232072,0.936539,'',NULL,'2022-02-15 16:28:41'),(74,'cupiditate',0.883347,0.747987,'',NULL,'2022-02-15 16:28:41'),(75,'hic',0.255101,0.214495,'',NULL,'2022-02-15 16:28:41'),(76,'tenetur',0.349808,0.926216,'',NULL,'2022-02-15 16:30:46'),(77,'cupiditate',0.256873,0.518712,'',NULL,'2022-02-15 16:30:46'),(78,'repudiandae',0.750814,0.607449,'',NULL,'2022-02-15 16:30:46'),(79,'laborum',0.672854,0.25551,'',NULL,'2022-02-15 16:31:32'),(80,'reiciendis',0.992952,0.127027,'',NULL,'2022-02-15 16:31:32'),(81,'ipsum',0.890074,0.564792,'',NULL,'2022-02-15 16:31:32'),(82,'et',0.104563,0.357212,'',NULL,'2022-02-15 16:33:11'),(83,'possimus',0.586428,0.896204,'',NULL,'2022-02-15 16:33:11'),(84,'est',0.248332,0.609091,'',NULL,'2022-02-15 16:33:11'),(85,'sit',0.436038,0.275172,'',NULL,'2022-02-15 16:33:59'),(86,'architecto',0.101041,0.397765,'',NULL,'2022-02-15 16:33:59'),(87,'dicta',0.571703,0.652189,'',NULL,'2022-02-15 16:33:59'),(88,'perspiciatis',0.981651,0.108075,'',NULL,'2022-02-15 16:36:12'),(89,'reiciendis',0.451884,0.812938,'',NULL,'2022-02-15 16:36:12'),(90,'ut',0.125661,0.779164,'',NULL,'2022-02-15 16:36:12'),(91,'itaque',0.493079,0.860518,'',NULL,'2022-02-15 16:36:49'),(92,'doloribus',0.382701,0.0376271,'',NULL,'2022-02-15 16:36:49'),(93,'dicta',0.731577,0.570083,'',NULL,'2022-02-15 16:36:49'),(94,'rerum',0.96975,0.471662,'',NULL,'2022-02-15 16:37:32'),(95,'ab',0.960787,0.0646319,'',NULL,'2022-02-15 16:37:32'),(96,'sunt',0.221503,0.843737,'',NULL,'2022-02-15 16:37:32'),(97,'dolore',0.351321,0.585886,'',NULL,'2022-02-15 16:39:11'),(98,'nulla',0.61797,0.287492,'',NULL,'2022-02-15 16:39:11'),(99,'nobis',0.714078,0.145897,'',NULL,'2022-02-15 16:39:11'),(100,'eos',0.305047,0.246643,'',NULL,'2022-02-15 16:39:55'),(101,'expedita',0.267304,0.801802,'',NULL,'2022-02-15 16:39:55'),(102,'quia',0.548721,0.904144,'',NULL,'2022-02-15 16:39:55'),(104,'modi',0.0299527,0.984339,'',NULL,'2022-02-15 16:41:19'),(105,'qui',0.620581,0.322284,'',NULL,'2022-02-15 16:41:19'),(106,'est',0.626121,0.524688,'',NULL,'2022-02-15 16:41:19'),(108,'sapiente',0.614348,0.622568,'',NULL,'2022-02-15 16:42:15'),(109,'dolorem',0.342596,0.358424,'',NULL,'2022-02-15 16:42:15'),(110,'aliquid',0.5055,0.11104,'',NULL,'2022-02-15 16:42:15'),(112,'consequatur',0.982861,0.961622,'',NULL,'2022-02-15 16:42:33'),(113,'aperiam',0.274803,0.778125,'',NULL,'2022-02-15 16:42:33'),(114,'dignissimos',0.561636,0.686064,'',NULL,'2022-02-15 16:42:33'),(116,'sit',0.642159,0.180406,'',NULL,'2022-02-15 16:43:24'),(117,'aspernatur',0.632648,0.656232,'',NULL,'2022-02-15 16:43:24'),(118,'ducimus',0.812014,0.733941,'',NULL,'2022-02-15 16:43:24'),(119,'Lady Noemy Ruecker',0.995386,0.836677,'',NULL,'2022-02-15 16:43:24'),(120,'Ms. Raina Pfannerstill',0.382324,0.827351,'',NULL,'2022-02-15 16:43:24'),(121,'Prof. Vanessa Shields',0.496082,0.949426,'',NULL,'2022-02-15 16:43:24'),(122,'Ms. Mollie Beer',0.454095,0.887424,'',NULL,'2022-02-15 16:43:24'),(123,'Dr. Reva Bayer',0.396688,0.9809,'',NULL,'2022-02-15 16:43:24'),(124,'Dr. Dasia Auer',0.347929,0.567802,'',NULL,'2022-02-15 16:43:24'),(125,'Miss Jazlyn Cruickshank',0.157709,0.902588,'',NULL,'2022-02-15 16:43:24'),(126,'Prof. Maggie Gorczany',0.646092,0.0799423,'',NULL,'2022-02-15 16:43:24'),(127,'Queen Fleta Klein',0.645797,0.0190879,'',NULL,'2022-02-15 16:43:24'),(128,'Miss Neoma Gulgowski',0.941074,0.320255,'',NULL,'2022-02-15 16:43:24'),(129,'aut',0.132033,0.490031,'',NULL,'2022-02-15 16:43:38'),(130,'neque',0.179472,0.179489,'',NULL,'2022-02-15 16:43:38'),(131,'doloremque',0.198525,0.98033,'',NULL,'2022-02-15 16:43:38'),(132,'Prof. Kattie Altenwerth',0.416664,0.636055,'',NULL,'2022-02-15 16:43:38'),(133,'Prof. Daisy Bashirian',0.953126,0.610933,'',NULL,'2022-02-15 16:43:38'),(134,'Lady Delphia Mante',0.975071,0.482992,'',NULL,'2022-02-15 16:43:38'),(135,'Queen Shania Moore',0.22435,0.473491,'',NULL,'2022-02-15 16:43:38'),(136,'Dr. Meggie O\"Conner',0.370967,0.817633,'',NULL,'2022-02-15 16:43:38'),(137,'Lady Janice Abshire',0.0478879,0.652776,'',NULL,'2022-02-15 16:43:38'),(138,'Miss Karli Spencer',0.881585,0.855134,'',NULL,'2022-02-15 16:43:38'),(139,'Queen Ericka Schulist',0.396047,0.826661,'',NULL,'2022-02-15 16:43:38'),(140,'Prof. Shanelle Goyette',0.946182,0.135162,'',NULL,'2022-02-15 16:43:38'),(141,'Mrs. Katherine Weber',0.995645,0.442956,'',NULL,'2022-02-15 16:43:38'),(142,'dolorem',0.358199,0.0680741,'',NULL,'2022-02-15 16:48:46'),(143,'illum',0.711578,0.140529,'',NULL,'2022-02-15 16:48:46'),(144,'illum',0.720175,0.0381324,'',NULL,'2022-02-15 16:48:46'),(145,'omnis',0.861751,0.770607,'',NULL,'2022-02-15 16:48:57'),(146,'voluptatibus',0.466399,0.889253,'',NULL,'2022-02-15 16:48:57'),(147,'exercitationem',0.975689,0.664002,'',NULL,'2022-02-15 16:48:57'),(148,'quaerat',0.0432204,0.717408,'',NULL,'2022-02-15 16:51:37'),(149,'atque',0.164478,0.273839,'',NULL,'2022-02-15 16:51:37'),(150,'cum',0.495024,0.717542,'',NULL,'2022-02-15 16:51:37'),(151,'molestiae',0.223158,0.400307,'',NULL,'2022-02-15 16:52:12'),(152,'qui',0.503509,0.274219,'',NULL,'2022-02-15 16:52:12'),(153,'dolores',0.350075,0.942903,'',NULL,'2022-02-15 16:52:12'),(154,'aliquam',0.864825,0.793366,'',NULL,'2022-02-15 16:52:35'),(155,'sunt',0.167419,0.811036,'',NULL,'2022-02-15 16:52:35'),(156,'magnam',0.414416,0.177734,'',NULL,'2022-02-15 16:52:35'),(157,'Dr. Sim Marquardt',0.314432,0.767908,'',NULL,'2022-02-15 16:52:35'),(158,'Prof. Keyon Sporer',0.435849,0.306508,'',NULL,'2022-02-15 16:52:35'),(159,'King Colten Sipes',0.329474,0.370974,'',NULL,'2022-02-15 16:52:35'),(160,'Dr. Damien Schaden',0.792564,0.177525,'',NULL,'2022-02-15 16:52:35'),(161,'Lord Sidney Mills',0.681695,0.158304,'',NULL,'2022-02-15 16:52:35'),(162,'Dr. Peter Kub',0.306297,0.129474,'',NULL,'2022-02-15 16:52:35'),(163,'Prof. Bobbie Sawayn',0.247388,0.338356,'',NULL,'2022-02-15 16:52:35'),(164,'Dr. Shaun Thiel',0.792033,0.892209,'',NULL,'2022-02-15 16:52:35'),(165,'Dr. Christophe Bosco',0.131454,0.281554,'',NULL,'2022-02-15 16:52:35'),(166,'Prof. Joshuah Luettgen',0.583945,0.393446,'',NULL,'2022-02-15 16:52:35'),(167,'non',0.614086,0.749321,'',NULL,'2022-02-15 16:52:39'),(168,'voluptatem',0.590848,0.738643,'',NULL,'2022-02-15 16:52:39'),(169,'iure',0.167674,0.0239435,'',NULL,'2022-02-15 16:52:39'),(170,'Mr. Rashad Greenfelder',0.757926,0.491194,'',NULL,'2022-02-15 16:52:39'),(171,'Prince Abraham Mertz',0.214759,0.465243,'',NULL,'2022-02-15 16:52:39'),(172,'King Wayne Schimmel',0.303913,0.986996,'',NULL,'2022-02-15 16:52:39'),(173,'Prof. Lambert Ryan',0.67105,0.440887,'',NULL,'2022-02-15 16:52:39'),(174,'King Jovan Rutherford',0.669177,0.606752,'',NULL,'2022-02-15 16:52:39'),(175,'Lord Koby Anderson',0.364706,0.543851,'',NULL,'2022-02-15 16:52:39'),(176,'Prince Nestor Hauck',0.317207,0.0768792,'',NULL,'2022-02-15 16:52:39'),(177,'Lord Keaton Gulgowski',0.944977,0.0968167,'',NULL,'2022-02-15 16:52:39'),(178,'Prince Garfield Kreiger',0.674334,0.732796,'',NULL,'2022-02-15 16:52:39'),(179,'Lord Josh Rowe',0.507709,0.512627,'',NULL,'2022-02-15 16:52:39'),(180,'ipsam',0.0579779,0.0744091,'',NULL,'2022-02-15 16:59:29'),(181,'non',0.277432,0.661298,'',NULL,'2022-02-15 16:59:29'),(182,'dolores',0.776996,0.137208,'',NULL,'2022-02-15 16:59:29'),(183,'eius',0.46537,0.938561,'',NULL,'2022-02-15 16:59:56'),(184,'iusto',0.386959,0.580219,'',NULL,'2022-02-15 16:59:56'),(185,'suscipit',0.275871,0.147115,'',NULL,'2022-02-15 16:59:56');
/*!40000 ALTER TABLE `coordinates` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_coordinates` BEFORE UPDATE ON `coordinates` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `last_visit` timestamp NULL DEFAULT NULL,
  `user_agent` varchar(128) DEFAULT NULL,
  `refresh_key` varchar(64) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `devices_users_id_fk` (`user_id`),
  CONSTRAINT `devices_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_devices` BEFORE UPDATE ON `devices` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `ingredients`
--

DROP TABLE IF EXISTS `ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ingredients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ingredients_name_uindex` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredients`
--

LOCK TABLES `ingredients` WRITE;
/*!40000 ALTER TABLE `ingredients` DISABLE KEYS */;
INSERT INTO `ingredients` VALUES (11,'veritatis',NULL,'2022-02-15 16:52:35'),(12,'repudiandae',NULL,'2022-02-15 16:52:35'),(13,'in',NULL,'2022-02-15 16:52:35'),(14,'doloribus',NULL,'2022-02-15 16:52:35'),(15,'blanditiis',NULL,'2022-02-15 16:52:35'),(16,'distinctio',NULL,'2022-02-15 16:52:35'),(19,'nostrum',NULL,'2022-02-15 16:52:35'),(20,'cum',NULL,'2022-02-15 16:52:35'),(25,'ut',NULL,'2022-02-15 16:52:35'),(71,'ea',NULL,'2022-02-15 16:52:39'),(73,'officiis',NULL,'2022-02-15 16:52:39'),(74,'pariatur',NULL,'2022-02-15 16:52:39'),(77,'iste',NULL,'2022-02-15 16:52:39'),(79,'molestias',NULL,'2022-02-15 16:52:39'),(85,'quia',NULL,'2022-02-15 16:52:39'),(91,'quam',NULL,'2022-02-15 16:52:39'),(97,'impedit',NULL,'2022-02-15 16:52:39');
/*!40000 ALTER TABLE `ingredients` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_ingredients` BEFORE UPDATE ON `ingredients` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `product_ingredients`
--

DROP TABLE IF EXISTS `product_ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_ingredients` (
  `product_id` int(11) DEFAULT NULL,
  `ingredient_id` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  KEY `product_ingredients_ingredients_id_fk` (`ingredient_id`),
  KEY `product_ingredients_products_id_fk` (`product_id`),
  CONSTRAINT `product_ingredients_ingredients_id_fk` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`),
  CONSTRAINT `product_ingredients_products_id_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_ingredients`
--

LOCK TABLES `product_ingredients` WRITE;
/*!40000 ALTER TABLE `product_ingredients` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_ingredients` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_product_ingredients` BEFORE UPDATE ON `product_ingredients` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supl_id` int(11) DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image` text DEFAULT NULL,
  `price` float DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `products_supplier_info_user_id_fk` (`supl_id`),
  KEY `products_products_types_id_fk` (`type_id`),
  CONSTRAINT `products_products_types_id_fk` FOREIGN KEY (`type_id`) REFERENCES `products_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `products_supplier_info_user_id_fk` FOREIGN KEY (`supl_id`) REFERENCES `supplier_info` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (32,209,'Queen Ines Kulas','','',0.982628,2,NULL,'2022-02-15 16:43:24'),(33,211,'Ms. Kaylah Lehner','','',0.0482273,1,NULL,'2022-02-15 16:43:24'),(34,213,'Dr. Natalie Hermann','','',0.585262,2,NULL,'2022-02-15 16:43:24'),(35,215,'Miss Annabel Champlin','','',0.339406,2,NULL,'2022-02-15 16:43:24'),(36,217,'Princess Joanne Corkery','','',0.773881,1,NULL,'2022-02-15 16:43:24'),(37,219,'Queen Minerva Heaney','','',0.874027,2,NULL,'2022-02-15 16:43:24'),(38,221,'Ms. Citlalli Mills','','',0.103148,2,NULL,'2022-02-15 16:43:24'),(39,223,'Dr. Nayeli Gerhold','','',0.553584,2,NULL,'2022-02-15 16:43:24'),(40,225,'Mrs. Charlene Gleichner','','',0.593312,2,NULL,'2022-02-15 16:43:24'),(41,227,'Lady Marlee Jacobson','','',0.539401,1,NULL,'2022-02-15 16:43:24'),(42,232,'Mrs. Summer Klein','','',0.779425,1,NULL,'2022-02-15 16:43:38'),(43,234,'Princess Jaclyn Armstrong','','',0.663054,2,NULL,'2022-02-15 16:43:38'),(44,236,'Princess Mabelle Watsica','','',0.971438,1,NULL,'2022-02-15 16:43:38'),(45,238,'Mrs. Marjolaine Murphy','','',0.588979,1,NULL,'2022-02-15 16:43:38'),(46,240,'Prof. Alexanne Gutmann','','',0.114064,1,NULL,'2022-02-15 16:43:38'),(47,242,'Ms. Constance Bergnaum','','',0.898153,1,NULL,'2022-02-15 16:43:38'),(48,244,'Queen Mollie Miller','','',0.360719,1,NULL,'2022-02-15 16:43:38'),(49,246,'Lady Georgiana Sipes','','',0.622025,2,NULL,'2022-02-15 16:43:38'),(50,248,'Queen Minerva Mertz','','',0.821409,2,NULL,'2022-02-15 16:43:38'),(51,250,'Prof. Gail Rosenbaum','','',0.134413,1,NULL,'2022-02-15 16:43:38'),(55,271,'Dr. Hugh O\"Hara','','',0.17617,1,NULL,'2022-02-15 16:52:35'),(56,273,'Prof. Ambrose Robel','','',0.462659,1,NULL,'2022-02-15 16:52:35'),(57,275,'Lord Kayden Koss','','',0.890824,2,NULL,'2022-02-15 16:52:35'),(58,277,'Dr. Rudy Herzog','','',0.891118,1,NULL,'2022-02-15 16:52:35'),(59,279,'King Stephan Daniel','','',0.733978,1,NULL,'2022-02-15 16:52:35'),(60,281,'Prince Talon Treutel','','',0.0544434,2,NULL,'2022-02-15 16:52:35'),(61,283,'Prince Orville Wilderman','','',0.415856,2,NULL,'2022-02-15 16:52:35'),(62,285,'Lord Hayley Hudson','','',0.214879,2,NULL,'2022-02-15 16:52:35'),(63,287,'Mr. Llewellyn Sanford','','',0.408197,2,NULL,'2022-02-15 16:52:35'),(64,289,'Prof. Nico Wolf','','',0.129367,2,NULL,'2022-02-15 16:52:35'),(65,294,'Mr. Valentin Walker','','',0.720247,1,NULL,'2022-02-15 16:52:39'),(66,296,'Lord Tristian Williamson','','',0.537765,2,NULL,'2022-02-15 16:52:39'),(67,298,'Mr. Emanuel Olson','','',0.867475,1,NULL,'2022-02-15 16:52:39'),(68,300,'Mr. Axel Adams','','',0.127429,1,NULL,'2022-02-15 16:52:39'),(69,302,'Lord Reese Hermann','','',0.148252,1,NULL,'2022-02-15 16:52:39'),(70,304,'King Jarod Halvorson','','',0.00933782,2,NULL,'2022-02-15 16:52:39'),(71,306,'Prince Rupert Sipes','','',0.681107,2,NULL,'2022-02-15 16:52:39'),(72,308,'Prof. Florencio Swaniawski','','',0.0375912,2,NULL,'2022-02-15 16:52:39'),(73,310,'Dr. Sigrid Torphy','','',0.801382,2,NULL,'2022-02-15 16:52:39'),(74,312,'Mr. Tracey Hintz','','',0.813157,2,NULL,'2022-02-15 16:52:39');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_products` BEFORE UPDATE ON `products` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `products_basket`
--

DROP TABLE IF EXISTS `products_basket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products_basket` (
  `product_id` int(11) DEFAULT NULL,
  `basket_id` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  KEY `products_basket_baskets_id_fk` (`basket_id`),
  KEY `products_basket_products_id_fk` (`product_id`),
  CONSTRAINT `products_basket_baskets_id_fk` FOREIGN KEY (`basket_id`) REFERENCES `baskets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `products_basket_products_id_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products_basket`
--

LOCK TABLES `products_basket` WRITE;
/*!40000 ALTER TABLE `products_basket` DISABLE KEYS */;
/*!40000 ALTER TABLE `products_basket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products_branch`
--

DROP TABLE IF EXISTS `products_branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products_branch` (
  `product_id` int(11) DEFAULT NULL,
  `branch_id` int(11) DEFAULT NULL,
  `exist` tinyint(1) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  KEY `products_branch_products_id_fk` (`product_id`),
  KEY `products_branch_supl_branches_id_fk` (`branch_id`),
  CONSTRAINT `products_branch_products_id_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `products_branch_supl_branches_id_fk` FOREIGN KEY (`branch_id`) REFERENCES `supl_branches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products_branch`
--

LOCK TABLES `products_branch` WRITE;
/*!40000 ALTER TABLE `products_branch` DISABLE KEYS */;
/*!40000 ALTER TABLE `products_branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products_types`
--

DROP TABLE IF EXISTS `products_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `products_types_name_uindex` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products_types`
--

LOCK TABLES `products_types` WRITE;
/*!40000 ALTER TABLE `products_types` DISABLE KEYS */;
INSERT INTO `products_types` VALUES (1,'smoke',NULL,'2022-02-15 16:31:21'),(2,'box',NULL,'2022-02-15 16:31:27');
/*!40000 ALTER TABLE `products_types` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_products_types` BEFORE UPDATE ON `products_types` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `supl_branches`
--

DROP TABLE IF EXISTS `supl_branches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supl_branches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coordinate_id` int(11) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `open_time` time DEFAULT NULL,
  `close_time` time DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `supl_branches_coordinates_id_fk` (`coordinate_id`),
  KEY `supl_branches_supplier_info_user_id_fk` (`supplier_id`),
  CONSTRAINT `supl_branches_coordinates_id_fk` FOREIGN KEY (`coordinate_id`) REFERENCES `coordinates` (`id`) ON DELETE CASCADE,
  CONSTRAINT `supl_branches_supplier_info_user_id_fk` FOREIGN KEY (`supplier_id`) REFERENCES `supplier_info` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supl_branches`
--

LOCK TABLES `supl_branches` WRITE;
/*!40000 ALTER TABLE `supl_branches` DISABLE KEYS */;
INSERT INTO `supl_branches` VALUES (1,NULL,NULL,'10:30:00','19:00:00',NULL,NULL,'2022-02-15 16:35:59'),(9,119,'bfPPDDJ.net','10:00:00','19:00:00',209,NULL,'2022-02-15 16:43:24'),(10,120,'uKrVUug.org','10:00:00','19:00:00',211,NULL,'2022-02-15 16:43:24'),(11,121,'ObvxruV.info','10:00:00','19:00:00',213,NULL,'2022-02-15 16:43:24'),(12,122,'TtZUfUD.com','10:00:00','19:00:00',215,NULL,'2022-02-15 16:43:24'),(13,123,'uIgsTXQ.org','10:00:00','19:00:00',217,NULL,'2022-02-15 16:43:24'),(14,124,'ctLvidq.org','10:00:00','19:00:00',219,NULL,'2022-02-15 16:43:24'),(15,125,'BtJqwNG.info','10:00:00','19:00:00',221,NULL,'2022-02-15 16:43:24'),(16,126,'ukKHFwY.org','10:00:00','19:00:00',223,NULL,'2022-02-15 16:43:24'),(17,127,'VNpcFvh.biz','10:00:00','19:00:00',225,NULL,'2022-02-15 16:43:24'),(18,128,'hZnlFrC.info','10:00:00','19:00:00',227,NULL,'2022-02-15 16:43:24'),(19,132,'DfuVClZ.ru','10:00:00','19:00:00',232,NULL,'2022-02-15 16:43:38'),(20,133,'YJRgUHs.com','10:00:00','19:00:00',234,NULL,'2022-02-15 16:43:38'),(21,134,'WlAtNmg.biz','10:00:00','19:00:00',236,NULL,'2022-02-15 16:43:38'),(22,135,'gQoClKC.ru','10:00:00','19:00:00',238,NULL,'2022-02-15 16:43:38'),(23,136,'mgDSXmW.ru','10:00:00','19:00:00',240,NULL,'2022-02-15 16:43:38'),(24,137,'waWMFTl.net','10:00:00','19:00:00',242,NULL,'2022-02-15 16:43:38'),(25,138,'vAujUQf.info','10:00:00','19:00:00',244,NULL,'2022-02-15 16:43:38'),(26,139,'rDNDKQe.ru','10:00:00','19:00:00',246,NULL,'2022-02-15 16:43:38'),(27,140,'bbwPJkD.com','10:00:00','19:00:00',248,NULL,'2022-02-15 16:43:38'),(28,141,'jZVVNYI.ru','10:00:00','19:00:00',250,NULL,'2022-02-15 16:43:38'),(29,157,'GGhxuUU.ru','10:00:00','19:00:00',271,NULL,'2022-02-15 16:52:35'),(30,158,'ltnnXeY.net','10:00:00','19:00:00',273,NULL,'2022-02-15 16:52:35'),(31,159,'uZPeDWg.ru','10:00:00','19:00:00',275,NULL,'2022-02-15 16:52:35'),(32,160,'XCTVxOW.ru','10:00:00','19:00:00',277,NULL,'2022-02-15 16:52:35'),(33,161,'YTsnSBp.com','10:00:00','19:00:00',279,NULL,'2022-02-15 16:52:35'),(34,162,'RhCOLsB.org','10:00:00','19:00:00',281,NULL,'2022-02-15 16:52:35'),(35,163,'PmXYshM.biz','10:00:00','19:00:00',283,NULL,'2022-02-15 16:52:35'),(36,164,'bsmFxeD.info','10:00:00','19:00:00',285,NULL,'2022-02-15 16:52:35'),(37,165,'jwOaKBU.org','10:00:00','19:00:00',287,NULL,'2022-02-15 16:52:35'),(38,166,'JGRLpli.info','10:00:00','19:00:00',289,NULL,'2022-02-15 16:52:35'),(39,170,'VBObnKt.biz','10:00:00','19:00:00',294,NULL,'2022-02-15 16:52:39'),(40,171,'rTvlprM.biz','10:00:00','19:00:00',296,NULL,'2022-02-15 16:52:39'),(41,172,'LGXWClt.ru','10:00:00','19:00:00',298,NULL,'2022-02-15 16:52:39'),(42,173,'lvCBnMI.info','10:00:00','19:00:00',300,NULL,'2022-02-15 16:52:39'),(43,174,'nhNIdyY.net','10:00:00','19:00:00',302,NULL,'2022-02-15 16:52:39'),(44,175,'iHGUeFc.ru','10:00:00','19:00:00',304,NULL,'2022-02-15 16:52:39'),(45,176,'EZkIFYS.ru','10:00:00','19:00:00',306,NULL,'2022-02-15 16:52:39'),(46,177,'WelErcA.ru','10:00:00','19:00:00',308,NULL,'2022-02-15 16:52:39'),(47,178,'xjOQUAF.com','10:00:00','19:00:00',310,NULL,'2022-02-15 16:52:39'),(48,179,'dXuaelv.biz','10:00:00','19:00:00',312,NULL,'2022-02-15 16:52:39');
/*!40000 ALTER TABLE `supl_branches` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_supl_branches` BEFORE UPDATE ON `supl_branches` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `supplier_info`
--

DROP TABLE IF EXISTS `supplier_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplier_info` (
  `user_id` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `supplier_type_id` int(11) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`user_id`),
  KEY `supplier_info_suppliers_types_id_fk` (`supplier_type_id`),
  CONSTRAINT `supplier_info_suppliers_types_id_fk` FOREIGN KEY (`supplier_type_id`) REFERENCES `supplier_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `supplier_info_users_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_info`
--

LOCK TABLES `supplier_info` WRITE;
/*!40000 ALTER TABLE `supplier_info` DISABLE KEYS */;
INSERT INTO `supplier_info` VALUES (73,'',1,'',NULL,'2022-02-15 16:08:55'),(74,'',2,'',NULL,'2022-02-15 16:08:55'),(75,'',1,'',NULL,'2022-02-15 16:08:55'),(76,'',1,'',NULL,'2022-02-15 16:08:55'),(77,'',1,'',NULL,'2022-02-15 16:08:55'),(78,'',2,'',NULL,'2022-02-15 16:08:55'),(79,'',2,'',NULL,'2022-02-15 16:08:55'),(80,'',2,'',NULL,'2022-02-15 16:08:55'),(81,'',1,'',NULL,'2022-02-15 16:08:55'),(82,'',2,'',NULL,'2022-02-15 16:08:55'),(209,'',1,'',NULL,'2022-02-15 16:43:24'),(211,'',2,'',NULL,'2022-02-15 16:43:24'),(213,'',1,'',NULL,'2022-02-15 16:43:24'),(215,'',2,'',NULL,'2022-02-15 16:43:24'),(217,'',1,'',NULL,'2022-02-15 16:43:24'),(219,'',1,'',NULL,'2022-02-15 16:43:24'),(221,'',1,'',NULL,'2022-02-15 16:43:24'),(223,'',1,'',NULL,'2022-02-15 16:43:24'),(225,'',2,'',NULL,'2022-02-15 16:43:24'),(227,'',1,'',NULL,'2022-02-15 16:43:24'),(232,'',1,'',NULL,'2022-02-15 16:43:38'),(234,'',2,'',NULL,'2022-02-15 16:43:38'),(236,'',1,'',NULL,'2022-02-15 16:43:38'),(238,'',2,'',NULL,'2022-02-15 16:43:38'),(240,'',2,'',NULL,'2022-02-15 16:43:38'),(242,'',1,'',NULL,'2022-02-15 16:43:38'),(244,'',2,'',NULL,'2022-02-15 16:43:38'),(246,'',2,'',NULL,'2022-02-15 16:43:38'),(248,'',2,'',NULL,'2022-02-15 16:43:38'),(250,'',1,'',NULL,'2022-02-15 16:43:38'),(271,'',2,'',NULL,'2022-02-15 16:52:35'),(273,'',2,'',NULL,'2022-02-15 16:52:35'),(275,'',2,'',NULL,'2022-02-15 16:52:35'),(277,'',2,'',NULL,'2022-02-15 16:52:35'),(279,'',2,'',NULL,'2022-02-15 16:52:35'),(281,'',2,'',NULL,'2022-02-15 16:52:35'),(283,'',2,'',NULL,'2022-02-15 16:52:35'),(285,'',1,'',NULL,'2022-02-15 16:52:35'),(287,'',2,'',NULL,'2022-02-15 16:52:35'),(289,'',2,'',NULL,'2022-02-15 16:52:35'),(294,'',2,'',NULL,'2022-02-15 16:52:39'),(296,'',1,'',NULL,'2022-02-15 16:52:39'),(298,'',2,'',NULL,'2022-02-15 16:52:39'),(300,'',1,'',NULL,'2022-02-15 16:52:39'),(302,'',2,'',NULL,'2022-02-15 16:52:39'),(304,'',2,'',NULL,'2022-02-15 16:52:39'),(306,'',1,'',NULL,'2022-02-15 16:52:39'),(308,'',2,'',NULL,'2022-02-15 16:52:39'),(310,'',1,'',NULL,'2022-02-15 16:52:39'),(312,'',1,'',NULL,'2022-02-15 16:52:39');
/*!40000 ALTER TABLE `supplier_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_supplier_info` BEFORE UPDATE ON `supplier_info` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `supplier_types`
--

DROP TABLE IF EXISTS `supplier_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplier_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `suppliers_types_name_uindex` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier_types`
--

LOCK TABLES `supplier_types` WRITE;
/*!40000 ALTER TABLE `supplier_types` DISABLE KEYS */;
INSERT INTO `supplier_types` VALUES (1,'sport',NULL,'2022-02-15 16:05:19'),(2,'hookah',NULL,'2022-02-15 16:05:19');
/*!40000 ALTER TABLE `supplier_types` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_suppliers_types` BEFORE UPDATE ON `supplier_types` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `login` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `pass_hash` varchar(64) NOT NULL,
  `user_type_id` int(11) NOT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `client_email_uindex` (`email`),
  UNIQUE KEY `client_login_uindex` (`login`),
  KEY `users_users_types_id_fk` (`user_type_id`),
  CONSTRAINT `users_users_types_id_fk` FOREIGN KEY (`user_type_id`) REFERENCES `users_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=322 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (9,'King Kristofer Steuber','YYWwibG','mkmbhSg@kGKNmZR.org','$2a$10$Crjvz9crV/wS0TpOl32JHu2uBhQ/yCYKeXNNtFFqdnxhepCmC1dHW',1,NULL,'2022-02-15 15:10:11'),(10,'Dr. Donald Satterfield','oZBHbLm','wYuLMQE@ovMvWdr.ru','$2a$10$1HDapTt1UIh7f1TtQvCtOeCWB4oJf44dL4e0r4nQHds0Bx5kzY5Nm',1,NULL,'2022-02-15 15:10:11'),(11,'Mr. Zachary Haag','HMvayFJ','ugLuRfK@eoFABIx.org','$2a$10$n3sgpuYxIN7pUj4aSG6Xy..fc8D5DSH8PH1MemSgLgF7nD1PUp6ye',1,NULL,'2022-02-15 15:10:11'),(12,'Lord Deshawn Barrows','BgnWxTr','gRQXjBS@YwNTcaG.org','$2a$10$qcppDqX6AibJLRzOWKSkEetjm3/ejywdDiWnHNv57FIF10CQZz5uO',1,NULL,'2022-02-15 15:10:35'),(13,'Dr. Raymundo Schaden','FwVkPOr','qGhTfpw@AnIGpBL.com','$2a$10$7tx5xR051wwtCb5eakRUyuHc9OuFZuZWxQcn8B0xn/1Hp5ZOqVUWq',1,NULL,'2022-02-15 15:10:35'),(14,'Mr. Abel Corkery','oLCACfl','nFOsyAd@JEhrBjv.biz','$2a$10$fx5reIMMaWQ2vqeqMWTnn.CekiZIrLs3zvBt4RGpS.EzGzQ3vK1Bu',1,NULL,'2022-02-15 15:10:35'),(15,'Lady Skyla Dare','XGAPuVF','Uctssqv@bRsbbXE.org','$2a$10$DUCFFL/LU2.VxND0bkEUIOqV5zRLreKiOYYH8bY.S069sFXJVemMu',1,NULL,'2022-02-15 15:11:04'),(16,'Dr. Delfina Bogisich','cFGRvQx','mNkmNaP@gDTUWUV.com','$2a$10$Hpb6Sh0otJvxShicYmBjS.FlH0Z5SjcJRJOoX.cwlcP37z1IOliu2',1,NULL,'2022-02-15 15:11:04'),(17,'Mrs. Telly Ruecker','aruQFPa','GoIpIqd@tMtlclQ.biz','$2a$10$.4wISaLfUcsJEwktJ./z6.XZxxN5UgT5JoL8nbmqGPD4/PhWbHsJ2',1,NULL,'2022-02-15 15:11:04'),(18,'Miss Cierra Ernser','kRiYqcw','LXynZuR@ISXObYE.info','$2a$10$7JxmVAguhOsGBkNJ0vliJ.uVgDPc8JuHG5Ymove3boHMZhWRKg2vu',1,NULL,'2022-02-15 15:11:42'),(19,'Mrs. Ruthie Schiller','iZeMdpZ','heVZVUK@dUDxUmS.org','$2a$10$ZR7XWgPO2IFhglu4V5xhpeAuc3OrchaaYKZpstGPsElzfUh8PqDai',1,NULL,'2022-02-15 15:11:42'),(20,'Princess Dandre Koelpin','SWryhOc','VrkBCme@kXJftos.info','$2a$10$8LyJTBzjPkcwG9LwWij5lO/ewPrVezBKCEGt0J/dfKBQjx6wXg21C',1,NULL,'2022-02-15 15:11:42'),(21,'Mr. Weston Greenfelder','sNeZpkC','CWYgxFn@Kyhuelj.ru','$2a$10$59JKPEGUFCJUnYKsEeySP.wFc.HmUsUuMnHsKJsf.MaC1rdGwDhy6',1,NULL,'2022-02-15 15:14:18'),(22,'Dr. Humberto Reilly','aPeceOG','WBcYNpm@TMMjtWq.com','$2a$10$yMNRBlHizov8vK.mpItBBuwqMc2cFA.G/tWBrbdk9FRXo6N0JkZTK',1,NULL,'2022-02-15 15:14:18'),(23,'Prof. Louie Ferry','liqbuLi','xnkQHLT@YasqYRk.info','$2a$10$VjtBGZ.hURXS3KvTo.7qkuhLYtyvSSEViSflHNbVzkWGK0yzxoOja',1,NULL,'2022-02-15 15:14:18'),(24,'Queen Beaulah Hoeger','JQmfccH','gRBRRNB@xjPqlnb.biz','$2a$10$1fUB6DyV0Yu5oYreArJECerFhVhOH5xqWhQU6OITsYfGs1ijDR90G',1,NULL,'2022-02-15 15:16:14'),(25,'Prof. Felicita Upton','uTFXSiQ','ZUdPqoZ@AgyaFUL.com','$2a$10$/0gI31A/cPuczCMb0NO5UONux5.Z9sf7ZkwmenLKk9c4owsMG3Xfa',1,NULL,'2022-02-15 15:16:14'),(26,'Mrs. Sonia Hirthe','pIhaHxN','VajNTIn@gTcPfdc.net','$2a$10$ssxkaN6wvf/Er8DNvBSXVexNIofFuIqVgwFDXG6t/UopYwYM8PxYm',1,NULL,'2022-02-15 15:16:14'),(27,'Dr. Mason Dibbert','UwDlABh','MPTTURe@CsBQMWY.com','$2a$10$/xAIMtchuCz9TEJvc9SqHOrQ36umQu4zS8oy/mADLdE6N4.y4pep6',1,NULL,'2022-02-15 15:16:46'),(28,'Lord Lonnie Mitchell','rWDbdQb','nBsxMbo@vXgHhNu.com','$2a$10$DoF9cNk5qHi8MtvVycG/GOrkdVYppla05g8SMXr4ry8TLQ/cU5PrW',1,NULL,'2022-02-15 15:16:46'),(29,'Prof. Raymundo O\"Conner','CggPGHf','JDgVGZe@ngPAZdd.ru','$2a$10$BUXx3ZQJvT1X0kZbgZiLduil9AbNBLD3fZF/GQDjRqlPf6bx2NFpq',1,NULL,'2022-02-15 15:16:46'),(30,'Lady Nettie Runolfsson','qilyWgj','Yfgyoap@ehmPMyr.com','$2a$10$qL8zb2w2qRCdjQPO55750uHhAfA8z25strn.tt5iVzJQGX1cNzoHO',1,NULL,'2022-02-15 15:17:05'),(31,'Miss Oma Maggio','rgfvIpE','RLqZUtw@EjnsJNV.org','$2a$10$olmxyOeSQ2IP1E1FZeo3DucSzadaTqmyDtvI6.nIoXIoJNT0jnR2u',1,NULL,'2022-02-15 15:17:05'),(32,'Princess Cheyanne Oberbrunner','ZDPxITN','kiDjBcD@XpSQbQs.org','$2a$10$4f7psC9jlmKwYBobYD7qsuBRk0Nf9hepxvZUvPlmjFa.OzM83K5MK',1,NULL,'2022-02-15 15:17:05'),(33,'King Jesse McCullough','NeujKvA','nQmZufm@LcxXEXK.biz','$2a$10$ON93f3wINBaEQIMPCyrTjOIFZRRpY5TvJ0gSNfdWR7bMgsG9FDbju',1,NULL,'2022-02-15 15:17:45'),(34,'Mr. Demond Ritchie','wRCWZcX','MbBLqQF@TOeOnlw.org','$2a$10$A.BEwb/hqIO76LiwJJkroefcDz3NwCPtTuCRqvFePy0UZVSuZbKwK',1,NULL,'2022-02-15 15:17:45'),(35,'Dr. Delbert Labadie','QuOVUTA','jUmCKEK@CNpjTjN.net','$2a$10$0eGE2JDG7PaNLfecI4na.Os81jihiEQuUmpFbRVqPLk2hXsHdOxq.',1,NULL,'2022-02-15 15:17:45'),(36,'Queen Katelin Walker','GTBqFec','qNMNZoX@Kmomqpw.ru','$2a$10$TY1MbvofLZVQcfPUrDJykulhEgykwwrqhtWrr2GM4p7maHzF4iCZO',1,NULL,'2022-02-15 15:17:54'),(37,'Ms. Alize Waelchi','XDiUEbB','trhLEOM@HsnJTHB.net','$2a$10$MdvmAl.oGrPkkBBvW65FcukSYJrOQD6QsQWjs2FJSfIvpj5fADEDa',1,NULL,'2022-02-15 15:17:54'),(38,'Princess Ashley Wilkinson','TFDUEZb','Wprmptf@KAnIPBD.biz','$2a$10$WzgJ3sWBKpCijKQPiaXMWeujLHGm1RevmHuXIADYG.bdl/TfUC0FO',1,NULL,'2022-02-15 15:17:54'),(39,'Dr. Enrique Dach','revymMF','vpqhgsN@qBMPLuR.biz','$2a$10$Mx8kEzPkS/f6BBODcBJfR.knI92W8B9vfE7n.GMQnJ7.Lwf5jpxlC',1,NULL,'2022-02-15 15:20:30'),(40,'Prince Lewis Luettgen','mOYVunU','IIFXvOv@CngCKUt.info','$2a$10$mnbk/gT/BXQXvRfiMxEmpunyagOZDSjEFge5PGGxR5ycNQdvzNoWm',1,NULL,'2022-02-15 15:20:30'),(41,'Prince Jett Collins','FWHcBsG','jqMVoFe@VOtjjby.org','$2a$10$PER/GLEBfyIUNb7q4pv0GOQ8ABeZazd9ewr42NLTHKfXPNrwCtXzK',1,NULL,'2022-02-15 15:20:30'),(42,'Mr. Danny Gutmann','ISwCVhp','yUvhrIo@FeBTpET.net','$2a$10$567j2fEqlsUdcZivfSTP8OVvQGKIoyLgEfZlWnfxtL8f2jadmlEDa',1,NULL,'2022-02-15 15:32:23'),(43,'Mr. Elbert Gottlieb','jyPhXkM','tPFxlyA@AlKbjKh.org','$2a$10$tc.G/FXTBeccgSJVrw7N0.Y7ccwyrBLwdPMCeJPr9eeXCDn8ABWfy',1,NULL,'2022-02-15 15:32:23'),(44,'Prince Skylar Gorczany','YnwlwaS','ibPxAqf@RoEUnOa.org','$2a$10$YDMzjrmVkt2APbJB28jfsetzzSIt8QcBR3LPpxsO0aRfbEzL87YM6',1,NULL,'2022-02-15 15:32:23'),(45,'Princess Bernadette Bins','rNvnnUT','VUoUxSW@FNQuXwa.ru','$2a$10$/ydKgH1lDxJBAAGKWdedK.uwerQ4WXruqmzA7CVZxtSin5RZqMB3a',1,NULL,'2022-02-15 15:32:32'),(46,'Lady Nichole Connelly','bcFOtQl','MGUNiMu@ffmLCeo.com','$2a$10$PsLFkSXGjZK.zCnv4QRfUeD.NS5SRPglOYeRJii5iLkBNlB.HDfgq',1,NULL,'2022-02-15 15:32:32'),(47,'Prof. Myriam Harber','fpwHSae','hLRkMGV@oaoVOjd.biz','$2a$10$au0Zu0XrnpljzjjPf1i4xenCdVnJvKXHLUJug3tHuta5ORU0nwRhW',1,NULL,'2022-02-15 15:32:32'),(48,'Miss Mozelle Johns','bnJpDYU','SFmxRQS@JmQDWOu.biz','$2a$10$lTAC70XIsnZ9KWrUzOrRyeVrNFLgAiD/Q9tsyqA.cVIzMO5Ws5zpW',1,NULL,'2022-02-15 16:00:08'),(49,'Mrs. Angela Barrows','RGubHKA','svtgXEJ@uYlVuDp.biz','$2a$10$yvL9Wq18kG2TDGe4rJm3QOcqAmnlQXka5iht0qawUqbpHKmuOMo6S',1,NULL,'2022-02-15 16:00:08'),(50,'Lady Elenor Wisozk','iapyHOv','JKksTZD@FMTalPx.ru','$2a$10$EgNEX8wusacmW3lJLnyrV.kNdnddxG4dmL4bAbpuoxDdOrz0X7qmy',1,NULL,'2022-02-15 16:00:08'),(53,'Prof. Coleman McGlynn','xqiTxne','acMKhpj@nvRoCSr.com','$2a$10$CwBT0Xr.dB0BBSNPHpqN9OCyZ6x1m6uPPEo5LJWLVA5XLvNr38rga',1,NULL,'2022-02-15 16:00:35'),(54,'Prof. Nigel Borer','aZZJCGn','smdbncu@CwtOUgl.com','$2a$10$0QArh0O6NfTTWfkIfNIAReiP9msFmvI03.XlvflL.TK8RPDODk9pa',1,NULL,'2022-02-15 16:00:35'),(55,'Mr. Kenton Corkery','XxHXeeI','BRcHDvk@LmKCrPs.org','$2a$10$.4Pp7BaYkKEz7QsM67OpKuhc1lGPlHY.ObjP9Pb2c0czJ0ZDDV95y',1,NULL,'2022-02-15 16:00:35'),(56,'Dr. Gabe Langosh','mqnIKrg','tLbFThN@XIpZyld.ru','$2a$10$t5S7XZQVPyqgLAFTwLZNkuMMk47rZLut9YbK66Tqp9hikQi3OWU2y',2,NULL,'2022-02-15 16:00:35'),(57,'Prince Jaleel Hudson','MginkNQ','DhHJWdh@HRJqZXL.org','$2a$10$aDzHNu32sCHngzaF.uFYYeWG/w3T8f6eEssAI17OsKhm.Z18HozCO',2,NULL,'2022-02-15 16:00:35'),(58,'Lord Ken Stark','JLWftRO','uqAoNUN@gqGgSxk.com','$2a$10$vjf4mJ8T5ljkZq3td3D7pONxhdT8NdmT0/H1bsG6e/yy5lqkXZZnK',2,NULL,'2022-02-15 16:00:35'),(59,'Dr. Bennie Lehner','diWJxIN','WCyvMCs@ekIROWZ.com','$2a$10$CGnK63mp2i3iosLLO/LCCeuIAPOmy7jtV2Bqv6c/7ZKa90EPuOfLy',2,NULL,'2022-02-15 16:00:35'),(60,'Prince Osborne Hirthe','bsbvnOj','ercBHAc@eyTgjst.info','$2a$10$FVb/G/B.h8LFItshrVAk9e0mro2/zLmv1CtNUtcJMUlnoMiTvTtXi',2,NULL,'2022-02-15 16:00:35'),(61,'Prof. Elwin Treutel','QepFIua','KBxFNwK@JeKMkCG.org','$2a$10$fXFwewvh946Pywiae.id1eF17M.UvFMF/AqIkdnNjm3gVKK4W4jIG',2,NULL,'2022-02-15 16:00:35'),(62,'Prince Gonzalo Thiel','cMKBZOW','CGMMiut@VyFDqXC.net','$2a$10$YbqTpbNiT9AplR1jlGrKzeuXYZ6NauRXvObO2abi3x0njbajtvRky',2,NULL,'2022-02-15 16:00:35'),(63,'Prof. Charlie Fisher','lFOSmoR','ljkIjMe@iCfXRUg.ru','$2a$10$Lugg4O7yEvh1xMJwizpEQOo8.1vYzS0QiVZdBgzA9ttsakwhxJyj.',2,NULL,'2022-02-15 16:00:35'),(64,'Mr. Kaley Murazik','tUDLALG','CnKqcOC@vkbDdig.biz','$2a$10$l5gjeKhECdPVhMlaLTAKhOa3RNlOKzRW6sANeD03Y.cm/nHfr6sd2',2,NULL,'2022-02-15 16:00:35'),(65,'Mr. Zechariah Zieme','jtPKuwd','YdusdbU@fhCMcay.biz','$2a$10$LFDPRjYJ2jxUKk7krMecpOZc9Sgedx8FLpvVloBb07S52RwpXdnXe',2,NULL,'2022-02-15 16:00:35'),(66,'Mr. Thomas Rolfson','UwbfWab','ruhHXeT@KEIUKAr.com','$2a$10$RUwmUJpQVWQnbGnyIQ/Ssu83nFsMpYwYHmXsIgpnrM0c/fIehXB9G',1,NULL,'2022-02-15 16:03:10'),(67,'Prof. Zack Beatty','pGVXuwF','AuwMKtB@Jnxuwym.info','$2a$10$pUre8yI8MUpQFaTKvJMlg.h96VYoesk2OmbhpjWypKnFWEWUUatm6',1,NULL,'2022-02-15 16:03:10'),(68,'Dr. Osborne Keebler','lJrcBbB','gwXJEoC@FJIXsCX.org','$2a$10$HwqAqYsJbhu08EicOg8fZ.qNXX4mxfswvUK7D6HBzMKmf1.fYm2Ve',1,NULL,'2022-02-15 16:03:10'),(70,'Princess Janessa Rice','pBpPPKO','anaAbZI@PVjyUea.net','$2a$10$V.YgFc.rBirT9a.Djqz7aeArWybaEB2Kyd6EDLmmFWivcYESgQKr.',1,NULL,'2022-02-15 16:08:55'),(71,'Lady Ada Eichmann','UWwJPJG','ZYPYlpV@YoGJXAy.com','$2a$10$i3oOcCE.xkcKn6SwEOVHBuX/OAAigEezg5b/wD70HY/unWbY5WHVe',1,NULL,'2022-02-15 16:08:55'),(72,'Prof. Carrie Nolan','mVoLQJv','UIfoktb@UbDxxTP.com','$2a$10$MwWLLV9XX1i04MT8X5biY.bFjFvu1KHTvjMfKGkLaEzSJdjm92Epm',1,NULL,'2022-02-15 16:08:55'),(73,'Lady Karlee Ferry','feakJDg','XDnepaC@IGaPihC.info','$2a$10$KTd9YoGvBQD6MoU4fLKLZerozbttlGc7Kyfe.YV71GE4B2kqNbB5K',2,NULL,'2022-02-15 16:08:55'),(74,'Prof. Tierra Jacobson','yqCmYIB','dhYlAUy@ACTHwZD.net','$2a$10$Lf5NTP8Mj9SkFoePMZYzUOeM48XyS1PJK2CQYr2K54ElY5g6eQogO',2,NULL,'2022-02-15 16:08:55'),(75,'Queen Damaris Mills','fHQtTBe','XJROrMk@XXpBgJx.info','$2a$10$/OJ51P0ZZbLj3RmL29utfuZjDa3YJgaAlLnDI8TqUums.pLIE0Xy.',2,NULL,'2022-02-15 16:08:55'),(76,'Mrs. Tiana Cummerata','giMmIRX','YnRomFD@fiQXoXy.info','$2a$10$o0kWSy1kWTsApOILtvh1M.xITf.PXYcMDa03LbR5/akwweWP5KFT6',2,NULL,'2022-02-15 16:08:55'),(77,'Prof. Samantha Leffler','xySyBbn','FaOYDiZ@rPDmCEr.net','$2a$10$bA9pz2p4dD/ko0b5pptKtuW5aAf1ywJUrsxQ4akN3svsn3Jh7qiVO',2,NULL,'2022-02-15 16:08:55'),(78,'Dr. Adrienne Romaguera','KKbjclE','xtjcJtl@YbQQpoF.info','$2a$10$QIQVk/qV8TgskFf7fwHfZOSkFeBR0uxV4R018TEPRktO.4I4Qf0pW',2,NULL,'2022-02-15 16:08:55'),(79,'Mrs. Earline Sauer','pUjVTbq','rbRNPlQ@skAVQKk.org','$2a$10$RQWtHM8OSeYXX3Bbk.dmfuRq8AR/yYSqRfAN4r8E3/tF.5jdTtwPW',2,NULL,'2022-02-15 16:08:55'),(80,'Mrs. Georgette Gislason','SBwSqCg','XFrckcY@xXnlyDG.ru','$2a$10$zxPE5bbuHKXhkqFF.Esf9OR/q3zdTlqL98vO6zc6d8GJ3VQeDdswK',2,NULL,'2022-02-15 16:08:55'),(81,'Princess Adah Nicolas','hWgXlKt','CisqEGD@JSohaFg.com','$2a$10$aVhL0o6AXDpRKrTAgEwSiOSw/YtpNKghgUYTL/KpTYJoLlE2dGocm',2,NULL,'2022-02-15 16:08:55'),(82,'Ms. Hope Kreiger','douNXFo','rVfjKUa@pfLtFqa.info','$2a$10$u9wht6r1NHwUFMk/TvuqaucKwHlDnc08KrbWgEmBSMvg6nHyD9LXG',2,NULL,'2022-02-15 16:08:55'),(83,'Prof. Oma Emard','qZNERxl','kYuTxEl@fFDOGiR.net','$2a$10$uD.olyvqR0a.0iZn3CXrwOnOLPdONnVBUlocrHqv41ktgl0kxy2E2',1,NULL,'2022-02-15 16:12:29'),(84,'Lady Gretchen Mills','gdWPjAt','BSagXrS@oLbvmMt.net','$2a$10$SQFBk9AwB0R5crp1fXF3FOjs6V08JDHWvf.Bl2jNhPg9WWNIWg7JW',1,NULL,'2022-02-15 16:12:29'),(85,'Dr. Janessa Bailey','pwRFsyJ','ZfeWGSm@diwiXXY.biz','$2a$10$KxyJzKyZ3MDqSjydeq09/O5ipiDMQoZe88E6vBAYSKDqYmqkKe4Ma',1,NULL,'2022-02-15 16:12:29'),(87,'Mr. Wellington Bauch','DKVUYsE','yVFeFtP@QAWhvUR.biz','$2a$10$i067KrR9FhJOJJTzQ8bTb.bm3LOl3sN6FQ9ImIBGOJEdhrSOIIFOS',1,NULL,'2022-02-15 16:13:11'),(88,'Prof. Adrien Wolff','BFitcLS','nXKmWlX@EPfvYGx.net','$2a$10$TLYaZCTjnmUnS/mKoBrw/e4bEufdppefpC.H.5mAC0QMiVIYb.uAy',1,NULL,'2022-02-15 16:13:11'),(89,'Dr. Keagan Bradtke','kblkaHJ','GPwpYJQ@hTyNyER.com','$2a$10$GPbskOnqpB.rz6nJWsPSv.NhrYVt6p.ddm.RXB.46.VX0OGQ0VlY2',1,NULL,'2022-02-15 16:13:11'),(91,'Dr. Brandyn Zulauf','fKFagls','iuETcvI@BOUQRAu.biz','$2a$10$HFAHIOxfiTC2GnrltpueQOWvP750FzU5nDxxYVSgA3HKG3GxBYini',1,NULL,'2022-02-15 16:14:31'),(92,'Queen Brenda Hermann','YaVdHel','IYekhab@PJdoxTL.net','$2a$10$1reXhJ5vcErIfgmpkboChe9yn.Xfku.3xaE7M89KAyA7hu/4rCfCi',1,NULL,'2022-02-15 16:14:31'),(93,'Mrs. Cassie Denesik','kWetKuo','XMUBffo@dgaPlta.biz','$2a$10$Z88Yf/zZftzVYVKZ1HR1D.Pbr7rcD.NwcFK3eutvtxxRRfhjVx2Nm',1,NULL,'2022-02-15 16:14:31'),(95,'King Izaiah Will','vQaCWKE','MkakREG@TkhHtQr.org','$2a$10$LOY8CFwlCVVHmq8lNMCdc.wj3CkZA608KVyioLZU76fwq5tnu8hUe',1,NULL,'2022-02-15 16:15:25'),(96,'Dr. Oswald Baumbach','xXWMtjJ','bDwFsLX@SioBVIi.info','$2a$10$zguT7oZvvxow8r4HpQH8iewsSjm5dyQRSXi3qMZM1Ud3EcgFFyfae',1,NULL,'2022-02-15 16:15:25'),(97,'Prince Chester Simonis','LRoMXlq','rKQoVAK@xGflTeG.biz','$2a$10$LWKS5It2V32qSO/82Dgk2Osnz19KgpbaCQCHKjnAfU33oCrcX2iX6',1,NULL,'2022-02-15 16:15:25'),(99,'Lord Axel Parisian','dDJeEMx','xkOorwc@dKwjCdA.info','$2a$10$gsrQz2ADMn2X7FAGoCdqC.vufYJnF9WZ8X/bLM/l1fXi5coPQRhF2',1,NULL,'2022-02-15 16:15:55'),(100,'Prof. Louie Franecki','ppPpUik','vycTTUG@wEOQcLy.net','$2a$10$INGXCzBT9Z.Y9usHSZFSiec08cvMiyP44ydvxlVEpG1gUJoY4cmdW',1,NULL,'2022-02-15 16:15:55'),(101,'King Kurt Dicki','JytUovm','wNIhGlo@sUoTlPD.ru','$2a$10$LNEbSOiEPGQ0gvTeDw2Mh.7rAsCZ3EPbUhqDz5lPtrp0bdxorLGXS',1,NULL,'2022-02-15 16:15:55'),(103,'Dr. Suzanne Reichert','tojYTqg','ZVjEkpc@KjryFbq.info','$2a$10$4F.LGN4ECoXHnskDW9Y3puv0a9TnnJ6ynOqSkkXAZcQwS4o5E5oyy',1,NULL,'2022-02-15 16:16:39'),(104,'Ms. Mona Pouros','UDjduAo','ZQCiMKY@QAJiFxs.net','$2a$10$BLeWGlHvBTPj6mPE1YfMoOFhScpwxTGTeP6RooZ7khoSoIX/hPBBS',1,NULL,'2022-02-15 16:16:39'),(105,'Queen Alba Corkery','fwUFFHp','wSoSkNM@vGObcxf.ru','$2a$10$t9mcpf7Jwa3pCw74LMBz4.p.QkjqnJ1TmuOWrNrXoc0NlN5iG5LS.',1,NULL,'2022-02-15 16:16:39'),(107,'Miss Eunice Runolfsdottir','wdwLPSo','xyVWVJO@aByZiDh.biz','$2a$10$Oct.s0CEdT2jCy4A6IQIo.OzLLMlivOEapX5N9frr6fI1gqu47Z3u',1,NULL,'2022-02-15 16:17:06'),(108,'Ms. Meaghan Wolf','xxZPGgo','xtaDCee@vlSfnmg.org','$2a$10$glZ9Avrm5Ecb5pyO3RQU.eOnZcPVeTggHKZ6x42TAIJgEzoX5vDA2',1,NULL,'2022-02-15 16:17:06'),(109,'Dr. Jazmyn Fahey','pDXqOWh','cbYxHxU@ouytNpg.org','$2a$10$YtP1Rm/sr5RztMuqxd5pTuf.4JQi9e1oZnvlshMiKQz8ZrGCAdrPO',1,NULL,'2022-02-15 16:17:06'),(111,'Mr. Randi Gleason','kFtNfZT','jlQIOdQ@MeInGnn.com','$2a$10$XOsZ.OnZ/oXt0D.BHzFiJ.uwlBqelE.tRM7LFaMWlo1AAYLRTtl72',1,NULL,'2022-02-15 16:18:27'),(112,'Lord Camryn Hermiston','ceTiJXg','mfyLqkg@BfRNGAd.biz','$2a$10$wHKhr3UQhr0IzwnUz3PXD.sBGuSciH2JOEav8rU8PMvSDhiVg0aHa',1,NULL,'2022-02-15 16:18:27'),(113,'Prince Dallin Kuhn','TDmOKyS','SrknZRg@uHeTOHH.org','$2a$10$tz2jNbvs8urXLTqMXisaBO9QkRIE6MVxl5/RH5VOA024OCAbcoZse',1,NULL,'2022-02-15 16:18:27'),(115,'Ms. Gerda Heidenreich','ISZkvLq','XJmFALK@MPDbQMV.info','$2a$10$vy9rhbDdi6oriVmfCqKyYuyBhCPZP3G.sm1RAIYzaTMXrmr/TThe.',1,NULL,'2022-02-15 16:20:10'),(116,'Queen Briana Schaefer','MnMtPtg','PvKUGqg@pGCfyhT.biz','$2a$10$MpGn8/Lbkih.U5PABS5ZO.jQmhzwgJgMCtlJRCliZB5biJ9oc1SQ2',1,NULL,'2022-02-15 16:20:10'),(117,'Lady Beatrice Pouros','EJLwbHu','hOaXiaw@AvbGTsb.com','$2a$10$DDXZeD/TSJ8fNp55RXr1o.Eh.o48YwYmKkc4uYpm3ctMFY3WhUSmS',1,NULL,'2022-02-15 16:20:10'),(119,'Miss Loyce Boyer','MBYkLbN','pOoqyxw@HqHEGNY.biz','$2a$10$kcRKLRcYL0G7Lhqnk8U2S.TEsD5ziDXbmWJueoPbNUAWWMYe8/wRS',1,NULL,'2022-02-15 16:24:42'),(120,'Mrs. Lisa Bartell','RpjsJuB','uvCdxXc@yYsZhYR.com','$2a$10$qy4TcPCcHPGQGuVmqeDMjORrtO8PGBosJt.FbZCvhh7lvkw/7LItm',1,NULL,'2022-02-15 16:24:42'),(121,'Queen Clare Okuneva','lGhXPRQ','cWaHkdh@xVTrsKp.info','$2a$10$Y7Ki7yNasdhgF0nz4k8lQuwpefuIHiVx6wpZW5QasKPsIEo8OVQQO',1,NULL,'2022-02-15 16:24:42'),(123,'Prof. Jett Bartell','HvasgKR','aneqSUK@TPPINLv.org','$2a$10$sXAW.UxR6rfQ5eoWlkGMMeddiV7oAoD2d4iCvEAjI/FG7.t0pUFGa',1,NULL,'2022-02-15 16:26:27'),(124,'Mr. Darron Swift','GWaepki','RIdaLCn@pFEuRMV.ru','$2a$10$trwKaPrHx5bV7nSwgftZIuYC8VXvUL0OxSz1s7I0W6YucgE.zBXoK',1,NULL,'2022-02-15 16:26:27'),(125,'Prince Jett Lockman','imnNWNk','nITmZlY@TqHfFUa.info','$2a$10$6BKULuc6azCo/QYfdFn6bOouBncFODLbvXcv.gJMaCLMiuGQX8tPe',1,NULL,'2022-02-15 16:26:27'),(127,'King Chelsey Hudson','RVPjLRb','adaZGiQ@PctftFZ.org','$2a$10$vdw.w0MYnEjMRGuroDaJkOpEhJcHueNc8WkG.ODhR5PHX/1RtfIkm',1,NULL,'2022-02-15 16:27:25'),(128,'King Davon Gorczany','YkIiLhL','bTTbqBa@auPQpGL.ru','$2a$10$FyNCOLC//HRz0zKdQzPX7umPWtnK0rBEYQcE6SwM0eW/ExP2OpAgi',1,NULL,'2022-02-15 16:27:25'),(129,'Dr. Jovan Mante','wKYlFRB','KhUNdJE@xnGaUGi.org','$2a$10$hbw5QF92.orSVzPtWnYxd.3efibemWtfsz0a0GoLjwykIXyHjp9E.',1,NULL,'2022-02-15 16:27:25'),(131,'Mr. Yogesh Fay','ElDNpil','mPtFyuN@USQVeMm.info','$2a$10$4mFzs6LnlgPCV1i9KcKWBOTXCig2hjiUFfTknx5QxNKYbZ9AfEbkq',1,NULL,'2022-02-15 16:28:41'),(132,'Prof. Art Lockman','ZegQJdl','GdYcplU@dGDaQqi.com','$2a$10$hHtUMhpjB0x67e4B5tlvUexZqDlBnsYZthW8vvvhbgOnE8.gjLbZy',1,NULL,'2022-02-15 16:28:41'),(133,'Mr. Mario Jacobs','UGFdGJh','HOQQdfP@wWSMUXN.info','$2a$10$Kt.dtmjQn8R137Z5qMjQ.O/xLh0FLjzUWnkPJtqy/hK.EsIs/JBFe',1,NULL,'2022-02-15 16:28:41'),(135,'Prof. Lloyd Franecki','mnpTGva','URtniLq@LndxlvK.net','$2a$10$5LkBNfmjsS1yu36NZY7yyunL1GVfsuyqkr7HTz/8hsHZAe9VMBuz6',1,NULL,'2022-02-15 16:30:46'),(136,'Lord Bud Bergnaum','PbdifCn','ELXgjwk@TqqrKdZ.com','$2a$10$leKMUISVs5MMSyx4XDEPqe5Qjaf5vZHh8el2qTkG1BKCEP2Ug82jy',1,NULL,'2022-02-15 16:30:46'),(137,'Mr. Elwin Ratke','TaWDFmT','cyGBymJ@XmwPqwK.com','$2a$10$GfTDA33mWVE1zuo3pgl7yeSOHJre9/rvWNfDnnDOQ8lQgqJKzNc6W',1,NULL,'2022-02-15 16:30:46'),(139,'Miss Genoveva Rippin','TTHNPlV','ORqGgaE@DhmqRWZ.net','$2a$10$HUqkMumcxrPW21bBAFp4qOX3KlDQwt085sdOJtDzdcokAE9bboUY2',1,NULL,'2022-02-15 16:31:32'),(140,'Lady Holly Padberg','tRsVFia','gnJIAIC@beNYLnK.com','$2a$10$gFTKBjrrRa2x3.KC8.GxkuopjFjswPNlHw9Bh.nyLMDkJctOmxkG.',1,NULL,'2022-02-15 16:31:32'),(141,'Miss Erna Daugherty','LsThhQb','VxTQAPm@CHVHADe.info','$2a$10$ScKwR47UtE/R2mXYVPJpE.weM/DpwtjJsRkkw5astadkearGvoq.G',1,NULL,'2022-02-15 16:31:32'),(146,'Queen Rebeca Pacocha','ujMxWPT','ogMbFif@pUAtKyi.net','$2a$10$zl8NmGaHuTxcYs8Fzm4WfOmOCjxMlA93eaAyt9Ea8unms6XyCFZta',1,NULL,'2022-02-15 16:33:11'),(147,'Ms. Monique Osinski','SRalcCr','vWpMvHl@JhpDUHy.info','$2a$10$3yXvmAj0eSrQGo0jwYE/z.JLiVLH3UYXMxugk/I/raGOTJmBimJua',1,NULL,'2022-02-15 16:33:11'),(148,'Mrs. Sabina Braun','sgYSVvP','adYLJJi@VAYlHhN.ru','$2a$10$MHI3sNXkpGk82g6dQrmcOO.A1KeFeoDYaonUuWHJK/zk353BAtiKe',1,NULL,'2022-02-15 16:33:11'),(153,'Princess Antoinette Lockman','HeUZohi','wQGhZeb@DCFSiBE.info','$2a$10$ppu91.ZjaLQL3WXtHZk8C.eZVWc9F7Okw0isfRKzt9oLf436hEaeu',1,NULL,'2022-02-15 16:33:59'),(154,'Lady Annabell Johnson','NGLfAWA','RVcXeEV@UOMwqVp.biz','$2a$10$L1q4hPlmZLIc.685/suGfe4MY86zN5BAw5KuiAotC275LP2Is5mUW',1,NULL,'2022-02-15 16:33:59'),(155,'Miss Kaya Hauck','aKwIHww','Eohvjef@gKjXQCA.org','$2a$10$aABWszGwL.7Fs4L9KjHKQOxz5KbA.2byuta7ptqfVa/VswpFvcUJu',1,NULL,'2022-02-15 16:33:59'),(158,'Miss Kathlyn Corkery','nNjCkqP','xBsRGZr@akhRDAd.org','$2a$10$dxGc7GltS0sfFTpL/EKCsuC5vrtXockYKK22HersP7SBC09d6oaUO',1,NULL,'2022-02-15 16:36:12'),(159,'Princess Eldora Vandervort','smOfMbj','wlyhOpc@hQbcrBr.info','$2a$10$ZY1rsWFLbg1HxqiawQWAP.uAZiSDYTKooPRSquQosShZnGcrZoRdi',1,NULL,'2022-02-15 16:36:12'),(160,'Dr. Aurore O\"Kon','cTXOiyU','lLHqCZX@hYaZyve.com','$2a$10$VgxR5UijAKGAlx5GoVxHgui2U8HYRevbpxHEvMiUJq83hlRstXKkq',1,NULL,'2022-02-15 16:36:12'),(163,'Ms. Lexi Schimmel','mexseFp','sNcRMCD@RKCTtfL.net','$2a$10$h4UvksqBDhfZgAiSRB1VkeAUhMmATovgETfxQDO9evGhWlZ.twPyS',1,NULL,'2022-02-15 16:36:49'),(164,'Miss Lexie Schaden','LjFFsJJ','kJLKNlf@AUkIVdU.org','$2a$10$R97Dr/zh1lDbTgwb43teDeEWmOZtyxCHpo/F/v4qbEYylXBUTxsDe',1,NULL,'2022-02-15 16:36:49'),(165,'Mrs. Mazie McLaughlin','SkFpvGq','XXpWkSs@CothRyJ.biz','$2a$10$p.i/AurqnQxVZMv5gb7O3uDwJ7JOBPHYnr2ylc9i6j4Q2vooAINIK',1,NULL,'2022-02-15 16:36:49'),(168,'Prof. Ima Hackett','CcKgmvR','FOTfGQZ@vWHkURT.org','$2a$10$MBkM7EDA/2a6T7400JcTyu528culuwuJloBlApIfU38qkXR/MF6.O',1,NULL,'2022-02-15 16:37:32'),(169,'Princess Kayla Reinger','uBJiTsf','VVBElqw@EmYTZIS.net','$2a$10$OKjU650a5gylTuqPEE5CR.tCuBWpXkV0t/p0bZGDHhR8gDf9HSn7u',1,NULL,'2022-02-15 16:37:32'),(170,'Dr. Clarissa Boyle','xJitcES','rAQDkwT@yhMjpUx.net','$2a$10$Jjd2/GtNkKEiboq.ZBUf8eE9JtaOUqjhhmBRKMXXic3l8VZA.MKc2',1,NULL,'2022-02-15 16:37:32'),(173,'Dr. Jaylon Murphy','fZjSEGT','oGBaosd@ULMAMgE.net','$2a$10$wNYFYEUKRB5lpfuJ9nsPFuYk/4vXcoWWOPQPSa1C7bi//FjIL/IIm',1,NULL,'2022-02-15 16:39:11'),(174,'Dr. Ransom Walter','sGWwAaH','BwqIwqE@gcVvbgA.ru','$2a$10$0EnPeHPdt/d55Q8YTKwlYuKBKye2R9eIlLgUVcUufB0VW8Y246dj.',1,NULL,'2022-02-15 16:39:11'),(175,'Lord Theron Fay','SrKNTpk','cpmPymC@vscAWhe.ru','$2a$10$e7tF8jn3/3qt0ErbNAvDmOEt5P23dL1Px7TdM4etkDl7pD6SSeBL.',1,NULL,'2022-02-15 16:39:11'),(178,'Lord Edgardo Harvey','wtMfxui','LaEKPMN@vILGZqd.ru','$2a$10$HfQBtOzxWobGVn6HPjdCmugry6EQCPnQ.bA8pBZcyG.xlmNDm7LWu',1,NULL,'2022-02-15 16:39:55'),(179,'Prof. Rowan Kerluke','TEftQZy','WYEjXaw@FpCDUGO.info','$2a$10$YYqUOa0z0pHysluR0VfU0.PTVnyBmAxQDj7l45h5bJrJwhf0z3Qwu',1,NULL,'2022-02-15 16:39:55'),(180,'Mr. Hester Tillman','hCeoclo','mnLsETW@mxwPXjU.net','$2a$10$9meptLaCYaD0DbK5i793YOyX8j9E7elh0VzHnAsj.0lR1VXprypci',1,NULL,'2022-02-15 16:39:55'),(185,'Miss Vicky Hoeger','bwCjNQR','JbdkJRc@YtLivRh.biz','$2a$10$3OY.vrCp.bLaIXtvdrSHhu1orjhnylPTOjcWx46mxejbfCxH.C4vu',1,NULL,'2022-02-15 16:41:19'),(186,'Ms. Michelle Jakubowski','dNJBJNh','dylGJMU@ECFydhA.net','$2a$10$uC/qYBxihpS0CPG4/k4euOaazk8tdz3dxs707scvEAsgmHslvGOQK',1,NULL,'2022-02-15 16:41:19'),(187,'Queen Lacey Emard','dwnGYEV','yvlSJpy@dqpoJMa.biz','$2a$10$BjplJwfJS9SNEIUUP8BNouuHbPODfzpaKH8wOfA.v0ZKfuMyLpRN.',1,NULL,'2022-02-15 16:41:19'),(192,'King Tyrique Schuster','AvnKWMX','ZBdVyGB@lZpCYsh.biz','$2a$10$wY8odvpvC5HZjK26UsN5ju83pyKN3bSNmq24oGYOjIMDqWi5eFcaO',1,NULL,'2022-02-15 16:42:15'),(193,'King Jayson Hayes','hfDXNmd','GIvgDyn@nfvhYrV.biz','$2a$10$Ct8M2ghurp25T97OkNfE2.mQfNczYNyQa/b23qe0xLfaskAGuN4vS',1,NULL,'2022-02-15 16:42:15'),(194,'King Coleman Yundt','kkPryYT','WMhwIpW@HiYhRkK.net','$2a$10$IEZPe4TmJ7ZgGBOocUTs/OwEVAnd606b4XG713PmYfe9q96DU9Ul2',1,NULL,'2022-02-15 16:42:15'),(199,'Prince Keith Metz','IMGbwWW','HfeuBWP@MrGgjOM.biz','$2a$10$3GXKNPeVDpUVuBmx9TMAHu5IwqXJsWTmG5nYE34DeBvgcp5U6Iy8i',1,NULL,'2022-02-15 16:42:33'),(200,'Prof. Godfrey Pfeffer','lDmbsFh','DIYZYIu@cEWwusR.com','$2a$10$.K9fbLhynPMtpwj9kThyxuhSQOFZweBuWVYy8SXcO2S.qnIrXaTue',1,NULL,'2022-02-15 16:42:33'),(201,'King Jarrod Von','iCflLIH','mFNnOJP@KcuQHSp.com','$2a$10$vwFWlRtZtVsm8/V2e52ZiOXSRhJCyZRih2aEYLE3hqDgrhtTfwu8.',1,NULL,'2022-02-15 16:42:33'),(206,'Queen Veronica Beatty','oXbcPVU','fkMdcKU@VCWApic.com','$2a$10$ynd5Ksng7J8aCD3NajF/HOs4POvr9VS9Xp6M9Na5ZFjFO.6/LPVwS',1,NULL,'2022-02-15 16:43:24'),(207,'Ms. Dominique Durgan','wjRElxY','KyVmDXR@NPQysFE.org','$2a$10$530OKIjFeqzZ/6O8riQB9e.uLt9B9TOoPKNo0mT.AjvtQXyXsAGOK',1,NULL,'2022-02-15 16:43:24'),(208,'Dr. Maureen Murray','NkCiwlV','GhRlUhN@LruxAWx.biz','$2a$10$CWYBA1CU6GQGbWczIvjqE.TelB6kQmEfVNK2it8HhFhJZVm4h/hxW',1,NULL,'2022-02-15 16:43:24'),(209,'Lady Hallie Prohaska','oAYAbeo','AsrYJTK@bpaAljO.ru','$2a$10$g11Cx2IKKbJ6OJt2kWTT4e02Y8dLJWzLbdFglLtsSPk8bl2qN1hi.',2,NULL,'2022-02-15 16:43:24'),(210,'Prof. Alyce Carter','HPGVplw','cmynTnV@GUUVAYF.org','$2a$10$osQOtc1pLuZghDN3RjTxJ.KngcnlQJISemyauxgfCRyTuKO8nKJyS',3,NULL,'2022-02-15 16:43:24'),(211,'Queen Brionna Conroy','iMPmxGX','HFuDfSR@TCeUVne.biz','$2a$10$eMNVIZzqhuvXJD9FOb1EPu9Y1N2.txYBuZnsw1MJ4k7UTnquCJlIO',2,NULL,'2022-02-15 16:43:24'),(212,'Dr. Ena Zieme','uiBljfS','WqjpPfy@RpKyueK.biz','$2a$10$f/UDb3IcoUpVyicCjUo/Te1e/B4B/uEtrfsgxBubjzWaf6K82E96W',3,NULL,'2022-02-15 16:43:24'),(213,'Lady Reyna Skiles','hLtMdOt','DUmXXAM@xrFRMAw.com','$2a$10$FQ1aAFHQWyJbFiEA1iotx.l3C2avOHP0TJSi.HqarmnSkuXerfQU2',2,NULL,'2022-02-15 16:43:24'),(214,'Mrs. Frederique Towne','ayDMrwL','fdIQKRD@RcrSgqw.info','$2a$10$XrRvFJ0J9fALPiy1P2pYkep.Bse4TvGjgwmzxqqO8eD54ibCyHvTe',3,NULL,'2022-02-15 16:43:24'),(215,'Ms. Britney Gottlieb','fgWeSmJ','IlHyTfR@KFNKlBy.ru','$2a$10$.xivEZ.KUg49pBaL.d9lAO195KzNZyD1pLKxkoiz2pUVI4V5DgFIa',2,NULL,'2022-02-15 16:43:24'),(216,'Lady Candace Reichert','BKwOIiX','FuNaxOI@fJgFraZ.biz','$2a$10$3a7PcjVa8.9miaLiNclntuHipdZ/3OIHfFW3RHs1dPnbH7TrPfRMG',3,NULL,'2022-02-15 16:43:24'),(217,'Lady Yazmin Murphy','LXKOWJp','wZXLbQd@SfWxQCD.org','$2a$10$wynTDxk5maHtG8oNjjbIIuZKFdPJf/aPhtNv2E14ykFH17EVOr1JG',2,NULL,'2022-02-15 16:43:24'),(218,'Lady Maia Ebert','lXIcWkP','eWtPyfm@iSBqRTr.info','$2a$10$EwJuJfJ37dgQ4HpEDi3Pn.3fT5/QqkUBen9zeKJKXGgLHfYcZNRZ2',3,NULL,'2022-02-15 16:43:24'),(219,'Queen Dejah Eichmann','sgCCYOY','fTpVmca@WCmbpsN.ru','$2a$10$.wTNY.A8Lak66WPjp4I2s.E2zcvlgQWegRKEP9haydyi14SqLfy8W',2,NULL,'2022-02-15 16:43:24'),(220,'Dr. Shyann Gislason','VTVUcxK','fURsdyd@IlBHfGR.ru','$2a$10$3Uw6OsLTPk4D6wdUrEnLduTzVHhFsbifFyz7VXjkhBnQnJd12kolK',3,NULL,'2022-02-15 16:43:24'),(221,'Ms. Jackie Lehner','naXyOUH','xvHFcNH@fWdfgCs.com','$2a$10$ieNkeALYArEaPb5JKcTgK.RirX2y5rJ.CuXPdedFcjoQ43mtpK3Aq',2,NULL,'2022-02-15 16:43:24'),(222,'Lady Lyla Hansen','ynvVMaC','tcxcoOE@oYPrkCY.info','$2a$10$HUcTZZy/ITg/Q6Sq8qrYYuk2uObRbX1c0X2zracyWSVfj6TkLHXne',3,NULL,'2022-02-15 16:43:24'),(223,'Miss Verda Hayes','RnMbsoH','gvxtLOL@cnEYLgI.info','$2a$10$x19.E5tcrHPzebtxSlV6Ou29o.a/UvfyOYeN/M/oJllnXpHgHHQ3e',2,NULL,'2022-02-15 16:43:24'),(224,'Mrs. Hope Howell','FURBaHv','HLGiQAO@GpFfiOI.com','$2a$10$PSJI8NOQ1yY4G.H5zVQGAOwCEyHLAEFJ3mouUKZKNSaJkjvv24IUG',3,NULL,'2022-02-15 16:43:24'),(225,'Lady Nola Zboncak','NxXhvxL','hrdQNTK@TpWNnJL.org','$2a$10$LsDyC7KGqvqREptN3jlLq.2zr.Gs3gbuM40NrYxervHn2U4rbJyBy',2,NULL,'2022-02-15 16:43:24'),(226,'Queen Dulce Bogan','uwqXyJF','yFQLAgH@mCqtmOY.biz','$2a$10$9AEX2muoNM/VcuwYf8yIM.UE5WgFVVggLFGYZxPEXJDQXzFT6FGa6',3,NULL,'2022-02-15 16:43:24'),(227,'Princess Esmeralda Kirlin','lBypRrq','rbiDSmq@FVOqfeI.biz','$2a$10$blL0StIYc9NfnPOO4Tc/iuXUUUCc6ge97hRDNve2kMNj3Ax/r9aU.',2,NULL,'2022-02-15 16:43:24'),(228,'Princess Eugenia Padberg','JTkkLXS','CmZiKeO@xnSACWF.biz','$2a$10$H6/Djmwni6gFECprTCTnmueFq1XGiGHXXCeT041OMArtLx5VQPsim',3,NULL,'2022-02-15 16:43:24'),(229,'Princess Marta Barrows','dfACWqH','bWYTPMh@XlqZefh.ru','$2a$10$CZEeQVwguPWcSMF09A2YsOqlt74msKbisTf0nXq57Gg7ZWH5pezGm',1,NULL,'2022-02-15 16:43:38'),(230,'Lady Priscilla Larkin','EpwHmdG','MlqKFiE@nHPBJLp.info','$2a$10$2r2wf.EW56VtBVjweFyCyOl4e9c0auhW8KCZ1JsRdo01qB/vCyw1S',1,NULL,'2022-02-15 16:43:38'),(231,'Miss Shanny Kilback','FJQtOTf','AwtgyVY@cwjGmXQ.com','$2a$10$SVfojEoNOrgn6Gtnt/Kvl.oPPB/aWufnZ4h89Klc6..XqtIVGV1sS',1,NULL,'2022-02-15 16:43:38'),(232,'Queen Mae Walker','CvAAnKr','owqbLcF@PsjjMGZ.com','$2a$10$prMNXs79hS8Ailn5t/9SS.KqbVM85Vp1G1DM4CQE0NMK7z6le5VA2',2,NULL,'2022-02-15 16:43:38'),(233,'Mrs. Ophelia Upton','BIKdNfu','vZPTBlZ@MOJIaNL.com','$2a$10$5F6B/hKQp1lYK5sjN6u3QubHgFyZVKgzxXgZPftvNIIjy/iGweGo6',3,NULL,'2022-02-15 16:43:38'),(234,'Ms. Mariam Dietrich','Pixwowk','xktmKSM@rcHPPyN.biz','$2a$10$gJtIPbdoSh9hmcO84nADIes4mqG61fg3oxoC9zcylMPnONtIOPOKy',2,NULL,'2022-02-15 16:43:38'),(235,'Prof. Ophelia Doyle','pruNrrM','PfhGNWo@oWeNpyu.ru','$2a$10$Jt4KwIUMLevdVEnF/Br.W.iMkD0rGt2vbHATJx3kboqQUF9eUTDU.',3,NULL,'2022-02-15 16:43:38'),(236,'Ms. Elouise Hahn','JUqYyuZ','jNKUCKD@YRkKyxU.biz','$2a$10$emh0z2huohK63IC1gx57t.P5LFpfoeQowjmIoZp1/Sx/HEhNCYQYC',2,NULL,'2022-02-15 16:43:38'),(237,'Princess Bernadine Pfannerstill','FyXLnKv','RoMvcVd@HFgXMoA.com','$2a$10$bH.gmnbGtEJUiqKgq/bu5.eGP3Nf9GRp5ajxM2LHRfdBQYD3dlw0e',3,NULL,'2022-02-15 16:43:38'),(238,'Ms. Lauren Conn','wqbPyNC','XDIuptX@pmganKT.info','$2a$10$9MQlejiZx8RZnxyr/NR8NulPCMerh09kZgsTvSURW1NoLb3m5Shie',2,NULL,'2022-02-15 16:43:38'),(239,'Princess Millie Doyle','lGDtsIA','TlNKmWV@msNBRJs.biz','$2a$10$QpnsFDshXc2xBXo0euZzXOwJ5NiKqR4bXQa3cJKROZAUtIXHI3fjW',3,NULL,'2022-02-15 16:43:38'),(240,'Princess Jackeline Stracke','QvYQZrQ','eciTeOg@BnVgBdA.info','$2a$10$u.7vqmLmIW56FwH0TdA1luOxwSHGqpOAh3CqpAdpjWCzKofyYIjYq',2,NULL,'2022-02-15 16:43:38'),(241,'Lady Tina Welch','OCKToKD','VCnYvVl@PnbaynQ.com','$2a$10$.dwrSwGv2GF5SV6piIJiOutNzNlv5Mn6hPbCDp5c1qJ8/cIo3ZMOG',3,NULL,'2022-02-15 16:43:38'),(242,'Lady Abbigail Keeling','LhAxWhw','pXmPkqE@HkUZtIB.com','$2a$10$fz1OdX9BuAdovxFGvbsTB.1AAtWgyu9S0pLU0ZM5EDqLXCmeL/rPe',2,NULL,'2022-02-15 16:43:38'),(243,'Prof. Hollie Frami','xCYaZCH','HuRUtOO@DKAZgQu.org','$2a$10$VRXKILa/eGGpZaHepsYp9.uOckoQVVRo.agli6Uowdr38nFMXyUUu',3,NULL,'2022-02-15 16:43:38'),(244,'Mrs. Kiana Marvin','XJHKLnL','ymZWweu@FAOVRBN.net','$2a$10$wN/CyxBK1b/w3/2hVN/WHenB1pJyywejDsZHyj1TmanJxD9O50hpy',2,NULL,'2022-02-15 16:43:38'),(245,'Ms. Blanca Lynch','PuaIsgC','ilsCvMW@mZMQprl.info','$2a$10$bwN4cEWwOlE9qteRXJ2TI.d/YFSwjV6eeHvPYcqq98Qpa.U7jp5wu',3,NULL,'2022-02-15 16:43:38'),(246,'Miss Tressa Hodkiewicz','MYCURRA','qAYqEwt@UUWdyvx.info','$2a$10$9/0T/tWexQR2Tn7klXGSk.R21Lpoayo1dmNbqSdIvu.xJciKjxyLe',2,NULL,'2022-02-15 16:43:38'),(247,'Miss Lori West','gqpOBmn','JBUMNom@lJJBnlu.net','$2a$10$uRE74gc5nusSCHun/qXheOhz1rgOhRz/Y87vMXPUQTnhzNLM3GTHu',3,NULL,'2022-02-15 16:43:38'),(248,'Ms. Jana Maggio','GIBuMdl','XvamYLK@fyexuUj.biz','$2a$10$ZTX7HwrjFCJQk3eM1XUvy.pI6O/gi0AGwczOlNpXyNrbX7.vyHm6e',2,NULL,'2022-02-15 16:43:38'),(249,'Ms. Destiney McLaughlin','VOOjfEZ','hXDAYDD@AMZaNia.info','$2a$10$Q8YlUCioR91DMUcTSZ7cWeJIjbblAQnoEaB4y6KO5zdGZri7k8I4G',3,NULL,'2022-02-15 16:43:38'),(250,'Mrs. Tierra Hagenes','LvPtVDb','KwvnUib@UNuQUex.com','$2a$10$LJhqQkJn/.ny6LtdeuDvQeW96uyJvMTTKZPMwsZ0pfWWTogNnnSL.',2,NULL,'2022-02-15 16:43:38'),(251,'Princess Letha Blanda','JDpgXZH','wriWSeM@XpBjVaE.org','$2a$10$.BheAVe/Xg.tNvQecGuiiuVAU0KpghSbFO0t5rL/FEnW5ns0z1XDy',3,NULL,'2022-02-15 16:43:38'),(252,'King Tyrese Morissette','DcRFKDQ','bbLQfhr@GpKACkd.biz','$2a$10$g9hZ6kE7UoSpGRy5jH1fZuzJpc5M.xPmbCJErc01VPBlQzeKQ69vy',1,NULL,'2022-02-15 16:48:46'),(253,'Prof. Ernest Kohler','aKyxGFL','UPPZDbr@eWgwpWP.net','$2a$10$ENeQ5K.xc8giwoeldCP/ZetX4u4h3dbR6iAdaUnpTGICe8GG9kR6G',1,NULL,'2022-02-15 16:48:46'),(254,'Prof. Nestor Wintheiser','DKiXrMQ','hjNAECq@IBwLVyn.info','$2a$10$lrOBXVD/GV7Dcw68kuHrfeqe0Wo.3OVASnhlg3AsE68y.SEgMRWK.',1,NULL,'2022-02-15 16:48:46'),(256,'Miss Clare Borer','NKmKHWa','NosCHjl@oowkLcf.biz','$2a$10$2vHcj3an8O9cZBz0rZswSuhpp6nXyVAxLs99.aPx14EX1nIU6H6Cu',1,NULL,'2022-02-15 16:48:57'),(257,'Dr. Eveline Cole','uZgFjwd','mmmYsVK@kPcuNxl.info','$2a$10$n5Iloy9U8PzgiC3GABkVKuAE4VQwnNZ73oFZvjdQ4BWl88ObzA4hq',1,NULL,'2022-02-15 16:48:57'),(258,'Prof. Leanne Blick','SEpNeQP','lRlncXF@ntqYUbw.biz','$2a$10$7aNS3plefWjKLaAoN5Ykz.vMO7CJuoT9KdzNHo8cy09j441xx1Nk2',1,NULL,'2022-02-15 16:48:57'),(260,'Prof. Mya Corwin','Vdvmqtj','fegoTsT@aGdwwDa.info','$2a$10$8b3w8RUSqr/8qAoPQ4PM6uUUTv0X6SC9ZIXzLCFbaBR78Ia9vYawu',1,NULL,'2022-02-15 16:51:37'),(261,'Ms. Gracie Littel','sHdisgS','fgLlFAH@sDlCIjH.net','$2a$10$TsZLtdHyd3yfzqJRhi1S4OY9KTSl78gLyk5YdmrHKMfsfbxGSutjS',1,NULL,'2022-02-15 16:51:37'),(262,'Queen Mayra Yost','WdISOhc','oVyHTFJ@iCRbHLg.com','$2a$10$Q8JpwK.lzwIDqBjujv.RfOrpZGS5QpfKbDIf4ALMIBjzH43p9ryW2',1,NULL,'2022-02-15 16:51:37'),(264,'Mr. Ashton Kirlin','KGcHaIu','JWcmtQZ@SedQigY.com','$2a$10$1xj8DyYsTLcZHULjvJzIXeKTRmrdKMLSnmH1AhWkaETkYCQTQ8VXK',1,NULL,'2022-02-15 16:52:12'),(265,'King Drake Jacobi','SSXjoDK','SpQqLii@FStbSMU.ru','$2a$10$PoBDzWhSI1GP0JoYMmCqCupIaJrHqcxwxv5qKXnduUZbPTAjRtB1i',1,NULL,'2022-02-15 16:52:12'),(266,'Prince Jamey Schinner','TUOMNaj','vgrrVVy@tDshaZi.net','$2a$10$Ru/.pW963m2xCNT/b4q1gOQ.WBMXp8mN7TtL72EY4cibM1NxR/Ubi',1,NULL,'2022-02-15 16:52:12'),(268,'Prof. Wallace Gutkowski','bRCKUTo','mVJKUDf@FRSmHbl.com','$2a$10$zWvPj6d.ZipNTgiCVwgyLePRGGEhMZ7Q4hIlWfh2KrpiUpX1OJNsq',1,NULL,'2022-02-15 16:52:35'),(269,'Mr. Riley Erdman','ZeKMaPe','ePHwGkg@uXwsegt.info','$2a$10$IkWpdvVhWIs/RBOUl0FEfeleM7KEYE.hXJDoRy43PTc4zZoucU58e',1,NULL,'2022-02-15 16:52:35'),(270,'Prof. Raymond Langosh','ZVKfusr','WptkkWR@gcQianW.org','$2a$10$bYCypntChdVARzUjtmecQ.1BeRW95mcwoFjmzE8z/vnFsJ.DcrGNW',1,NULL,'2022-02-15 16:52:35'),(271,'Prof. Murl Dietrich','EiSSYgV','GHGNkbw@CQxoKlK.biz','$2a$10$oTBqI2QfUfIFHIdecdqVQeAwyrqV7YwybYfWBf7Bui/zovqYudkz2',2,NULL,'2022-02-15 16:52:35'),(272,'Dr. Alec Lubowitz','gVsdnda','hWbcIyO@ykSGNox.org','$2a$10$JORclBMFRPLgmg7yLmS4O.fL6X5Xks5m9ZayYWBrP1TvC3N1imWBm',3,NULL,'2022-02-15 16:52:35'),(273,'Dr. Maxine Schultz','wsrTFSf','pMcLTtk@gwIfiht.ru','$2a$10$BOXguhiXf3Q4Nj382i1z8.SW/rqClLkKlR7FY3FuTj/JPkwOZng9G',2,NULL,'2022-02-15 16:52:35'),(274,'Mr. Pietro Grant','KYJmyTc','qHmdjde@MPCqEgG.info','$2a$10$ZlYyqddElocM8O8HMBMJvuwwmmC91.IfnbCamz1zZKWnKb/VVF1TW',3,NULL,'2022-02-15 16:52:35'),(275,'Prince Ricky Kutch','fvYeljf','tMNTwAZ@MQRYomG.ru','$2a$10$jfoR55Mj5a9xiY6LGaxWoeInXMxqX7.xrfhNEU303GQ4sjQS9CVWC',2,NULL,'2022-02-15 16:52:35'),(276,'Prince Keith Schmidt','MnDvLtS','myigMrU@TeHiITw.com','$2a$10$7rGPy9C6zjCWgSQCAMU3reJE/3ETFiqAUkxKkTUVwVqWXR5dGNkQy',3,NULL,'2022-02-15 16:52:35'),(277,'Prof. Wendell Kreiger','ulWFSyv','qCvJbKD@tmJrInh.org','$2a$10$7JPBN1Le/0//FnX5TeOHaeitCre.NgnGNpFeuqyDt2dh0vcr1Umlu',2,NULL,'2022-02-15 16:52:35'),(278,'King Landen Wehner','ahLYbsN','WEKyxwM@rnkuElv.org','$2a$10$8COn79zcGgJaJT51uniISuD8T1rfKzZWIPUzqMy8zHP3kH7iZ7ozm',3,NULL,'2022-02-15 16:52:35'),(279,'Dr. Montana Deckow','dKTyvWO','bExJinm@YdHXnuv.biz','$2a$10$78Tho5DmGVXaRFCmNlKz.OmX6saVBUU7sSXGffxOs7p2G8/3HjnXu',2,NULL,'2022-02-15 16:52:35'),(280,'Prince Olin Botsford','BuGRamM','IgiHqaI@GddjJQC.ru','$2a$10$Vd5vzJkL4ZUyXrfpBo4y2epGsQmveBxbPV09iEXPJTlvIN4wYPZqS',3,NULL,'2022-02-15 16:52:35'),(281,'Prince Christopher Marvin','iAFWYTr','BwyGRYr@fepDfJf.net','$2a$10$31uRe1jbYtlrlHzT0OTowe/SpKkrpgARY6fML0ZO.QRtJPjvTzKq2',2,NULL,'2022-02-15 16:52:35'),(282,'Mr. Danial Keeling','Kgufmgo','mHadbNt@wonIcLx.net','$2a$10$tNaiSKsnLZYuyMy6TSIgTuIz772lE/2gLScIfs0WxCwTCackXwdTS',3,NULL,'2022-02-15 16:52:35'),(283,'Dr. Marcos Wuckert','gpoKQTb','FHDGgXT@DKGhwoj.org','$2a$10$Xez4kabl7s8N/MwkZlASH.ZERag8.KXwvmkrEJx.irer4U9SLA6SO',2,NULL,'2022-02-15 16:52:35'),(284,'King Isai Kassulke','purLgfx','WVQVCFf@YfFZqfn.biz','$2a$10$/nJouoLKoyIhfOpZ3QG9/O98bD3DXaI9rBeKrB7KVrXtgGZyRDXrK',3,NULL,'2022-02-15 16:52:35'),(285,'Mr. Florencio Kuvalis','gloxLJF','LILUsoS@jFdXiwy.net','$2a$10$GT8BSi0jH0qN4SxAmOo2gedePu4aC7zmadg8UGgP39HYX50MrmWWm',2,NULL,'2022-02-15 16:52:35'),(286,'Mr. Lloyd Shanahan','ciHyhfD','GgBmDDn@GXfVaYG.biz','$2a$10$4atB3eBXRed3xWFzBetqV./51SrJIaAjf0UnwYzhlH2nBdamNqSPu',3,NULL,'2022-02-15 16:52:35'),(287,'Prince Jaleel Homenick','VwKbLvU','ivwhnAB@xQfsNEv.biz','$2a$10$5JGmQ9tZ7YURAoB2uYwsUO6sbqlilyQeZVmGQ0FTZCQgm8NHbgriK',2,NULL,'2022-02-15 16:52:35'),(288,'Lord Gideon Hane','sNsuDaH','LrHwoAb@NBfqHff.biz','$2a$10$.yqqL3kS7U32N1hl.wV1A.GnYUDrnoouYb1zRdli5DjAzsMBhgPwW',3,NULL,'2022-02-15 16:52:35'),(289,'Prince Judd Reichert','mfjtZwd','guvmNWH@uebaRjb.ru','$2a$10$e6TnimvUjlflN/GOtl8C9uQXtsT2msuaWJU8s6WCC9/giZjBgGjgS',2,NULL,'2022-02-15 16:52:35'),(290,'Prof. Ethan Hodkiewicz','LqYoXGZ','XDeSwEk@WAvEixR.info','$2a$10$B0k8LKT6vha0n.SO8jbIdeyGsd2VqiRKK.Eh5QzHK311XDoIfDaPG',3,NULL,'2022-02-15 16:52:35'),(291,'King Mavis Haley','SKoExnG','rxqMVUE@rAbIdUO.info','$2a$10$BuPSHW5PSL5.pwiyutc22O6N.HOk6IYx6kxXtUubqLl3BCAg.Qso6',1,NULL,'2022-02-15 16:52:39'),(292,'Prince Davin Lemke','guJYWVd','HxVBGiG@ejyJwDR.com','$2a$10$uj5d2NTB/b.mI0oEc5jt9O0Cet9E0vXCyi.GR6iFqmi10OrpYWGAi',1,NULL,'2022-02-15 16:52:39'),(293,'Prince Dudley Walsh','aBLkbtv','aMJxOZx@MLZhfxp.ru','$2a$10$r2oPFoMLD6528KIkdBCXf.w4DNKWQq5dhS0aHnVATiJGFeWadHyGC',1,NULL,'2022-02-15 16:52:39'),(294,'Lord Olin Rau','QSOFjoI','eqVdkKu@VWtLeeK.net','$2a$10$tI51e/qXagmQjkqxJtnTpOwKFxy8MU6wWfyNkGBm.M6YtTlxS9R5.',2,NULL,'2022-02-15 16:52:39'),(295,'Dr. Deven Lueilwitz','lhYyLYW','GZGLwlF@dIdSGVW.net','$2a$10$SKhns7tbw4Ua6Z0KFCsckO0qjdNOYETUn8Bl/SbwFtAmryCdEcae6',3,NULL,'2022-02-15 16:52:39'),(296,'Dr. Jabari Ernser','QSTYodA','oybuCWN@hLnwGsY.com','$2a$10$OLcSKViSuQeRASvrh5Ivvep17mCYPNkQmWz3fdWFmUDAc2A7M.VCy',2,NULL,'2022-02-15 16:52:39'),(297,'Mr. Cicero Kshlerin','SbRruMX','lOIXneH@kilNCjv.com','$2a$10$/77huGfDbuq6yJYp48jGC.R1ffgdwJpKZmACDxSsooCIVJMBJ3rJC',3,NULL,'2022-02-15 16:52:39'),(298,'Mr. Garnett Koepp','FAZGDgo','bMhMgBb@YrYmgbm.info','$2a$10$jZZarkCCvOB1uOoj1VLkse6kYcLl9VxuEuoJaonNrfJBwlIa3Yy0C',2,NULL,'2022-02-15 16:52:39'),(299,'Dr. Kennith Botsford','YnMwBCX','iqvMpES@JVyXgnm.info','$2a$10$Ox/iWGxBIjjm7rcUYxf3V..xGQgezXj.4c3GeA3kJ6teZKRLEgbmO',3,NULL,'2022-02-15 16:52:39'),(300,'Prince Jovani Tillman','FlgAXaF','rWkjaAS@UaHoraT.info','$2a$10$yMOklUR8D9KQ.N9wHiR0Se3jUI7/s4hOx4Kj5N33jcOhEkzirkoZK',2,NULL,'2022-02-15 16:52:39'),(301,'Dr. Afton Spinka','bTGecbe','BrNCPJy@mwFJWTy.biz','$2a$10$1ZpENfMGf9k3qEYFIfNor.BCzsZMLnrc/t5EiHTm0Np8AREANEvQK',3,NULL,'2022-02-15 16:52:39'),(302,'King Gerhard Ebert','YXlUUir','UKIaVZS@KoNrmpm.ru','$2a$10$sH6VA/9xOlHOgsbjGOudF.XcBiOXNw4DaAIUO0ipcrBbC2Y60pVlS',2,NULL,'2022-02-15 16:52:39'),(303,'Prince Jennings Harvey','HewPaum','JYGhHxl@eZCkEDd.com','$2a$10$YpwJAMzKpTCwEp/6GNGired1wrU0P1q8N6I82LsVL49/czQAAwZmK',3,NULL,'2022-02-15 16:52:39'),(304,'Lord Erling Macejkovic','agRZONx','AHICZgh@pFYnaeW.com','$2a$10$mKa5xVUWF5RxsPMg7JWBQ.zqpSvcUlXfxJtAo3VM5GasWIh0xMeTa',2,NULL,'2022-02-15 16:52:39'),(305,'Prof. Dallas Anderson','tvalqBm','BkiotiS@upwDTOf.info','$2a$10$P4mEbhfVjc7zibIp0q3Gy.UzfedYhMVyEjTRaQakxH4fx6geEN8G.',3,NULL,'2022-02-15 16:52:39'),(306,'Lord Rudy Kuhn','FTXsrFp','qWSPCSX@iMygnDV.ru','$2a$10$tlE7QVo.Rh73Ls.YVDPM1.FBD0Dv6m.2jilaUL3haj2MEz8lr47Ym',2,NULL,'2022-02-15 16:52:39'),(307,'Prof. Ellsworth Balistreri','XIAdJhk','fuLZucx@aToOjFM.org','$2a$10$3riWcN2GLl1d/nyUUQhB6eSLNRcRTfAzhX.5uOpJZUVDQodSEo/lm',3,NULL,'2022-02-15 16:52:39'),(308,'Dr. Randy Brekke','aCYnrxf','HojNRUH@DtgKMWH.com','$2a$10$nJ3BabFzyChX0Jmi8KAXIukQx.I5BsY0U/Xtw4uF6ZjBfBGjB1Pwq',2,NULL,'2022-02-15 16:52:39'),(309,'King Marty Little','tGHqjlV','CoYvlSx@GvtBqnm.com','$2a$10$dw/7UKqgWXsxD0OdQETuEO1Zo2txPrfeboEEpGIYYMlK1hZ9nFZa.',3,NULL,'2022-02-15 16:52:39'),(310,'Prof. Enrique Hansen','JFaZGgk','liuaATS@FKodJxD.biz','$2a$10$9aHMjhdpjnsBKJuDQ8cSg.oI.jZGKL0r/mZZiRDUNoLUcn3kYk7Qu',2,NULL,'2022-02-15 16:52:39'),(311,'Mr. Julius Brown','NkKtGRY','ReVNvEf@eJwlMqK.biz','$2a$10$YW8b.orUioUCWnrGnEUxouATqvLmxPrrmiWlqzuDqXCVxA3jWhaj6',3,NULL,'2022-02-15 16:52:39'),(312,'King Jimmie Hamill','YTcXMtX','QfyUnuZ@FnTLwUI.biz','$2a$10$VcLI/BqtDTL9K.WBXRjuLuLSPGJLiBYwvSXso4DhuZzM6k7TOXXO.',2,NULL,'2022-02-15 16:52:39'),(313,'Prince Peyton Metz','XdoHnOT','tsUAKjm@VCObTeI.net','$2a$10$FW.YhBUzvAisFyS0q2OEmefx4vgEFmonrgRJFe3regbArgWksHOb6',3,NULL,'2022-02-15 16:52:39'),(314,'Dr. Jimmy Marquardt','uXfxoJf','sSgROZD@UefPaZJ.net','$2a$10$uaQ2TB58ofnebiSosSATseq6b95uD/vLhAV.7Di184La/UFXYnnHu',1,NULL,'2022-02-15 16:59:29'),(315,'Prof. Adrain Bechtelar','BwmIxLX','qXdBVfV@aCMhEhL.ru','$2a$10$GokJ74o17IzzNCANr1L7yeTj70booyecrTNNwEvJZSLCEJZX6xDl6',1,NULL,'2022-02-15 16:59:29'),(316,'Prince Ellsworth Thiel','aCPoeqx','NLUCGCr@VhcKcVt.biz','$2a$10$Lle1sQEcNay1sdfIwTzWpOTUJJixtq0Ck2hEcFuL9dmRXg7pd1oxq',1,NULL,'2022-02-15 16:59:29'),(318,'Princess Nayeli Jaskolski','pHjjZDY','UMDMJkT@ejlJwYM.biz','$2a$10$VZUet5B6pcosxX5MdTqj0eiZ4X7mVelsZmZ9n5bB.wquO/0CVZ32O',1,NULL,'2022-02-15 16:59:56'),(319,'Princess Orpha Kessler','FxqfhLd','mOyUPRr@vFNifYS.com','$2a$10$/rMIDggVBPfsJec1ggehOO/e5JTAuohlegNdzu2m1YQCdFKB.MS9q',1,NULL,'2022-02-15 16:59:56'),(320,'Miss Ardith Rowe','LASoZlh','AabWmyA@GLWyQFn.com','$2a$10$c75FBl7QUORDF5DFle4PSOR7rznUHznGCvzg4Lk.kd168j3sMtZea',1,NULL,'2022-02-15 16:59:56');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_users` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `users_types`
--

DROP TABLE IF EXISTS `users_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_types_name_uindex` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_types`
--

LOCK TABLES `users_types` WRITE;
/*!40000 ALTER TABLE `users_types` DISABLE KEYS */;
INSERT INTO `users_types` VALUES (1,'Client',NULL,'2022-02-15 13:32:52'),(2,'Supplier',NULL,'2022-02-15 13:32:52'),(3,'Branch',NULL,'2022-02-15 13:32:52');
/*!40000 ALTER TABLE `users_types` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updated_at_users_types` BEFORE UPDATE ON `users_types` FOR EACH ROW BEGIN
SET NEW.updated_at = CURRENT_TIMESTAMP();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-15 19:02:47

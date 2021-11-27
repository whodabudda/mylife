-- MySQL dump 10.13  Distrib 5.6.24, for Win64 (x86_64)
--
-- Host: localhost    Database: mylife_development
-- ------------------------------------------------------
-- Server version	5.6.21-log

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
-- Dumping data for table `duser_metrics`
--

LOCK TABLES `duser_metrics` WRITE;
/*!40000 ALTER TABLE `duser_metrics` DISABLE KEYS */;
INSERT INTO `duser_metrics`(value,occur_dttm,duser_id,metric_id,created_at,updated_at,id) VALUES (120,'2015-10-27 17:46:00',1,1,'2015-10-27 17:46:30','2015-10-27 17:46:30',1),(70,'2015-10-27 17:46:00',1,2,'2015-10-27 17:47:42','2015-10-27 17:47:42',2),(194,'2015-03-12 05:00:00',2,1,'2015-10-27 18:50:57','2015-12-02 19:45:15',3),(90,'2015-02-12 06:00:00',2,2,'2015-10-27 18:51:16','2015-12-02 20:17:50',4),(144,'2015-11-26 09:00:00',2,1,'2015-11-19 15:02:25','2016-02-15 22:58:38',5),(120,'2015-10-19 14:48:00',2,1,'2015-11-19 15:49:05','2015-11-19 15:49:05',7),(61,'2015-10-19 14:48:00',2,2,'2015-11-19 15:49:38','2015-12-12 22:23:39',8),(182,'2015-11-01 15:48:00',2,1,'2015-11-19 15:50:15','2015-12-27 05:15:04',9),(91,'2015-11-01 15:48:00',2,2,'2015-11-19 15:50:36','2015-12-09 16:37:17',10),(800,'2015-12-23 16:23:00',2,5,'2015-11-19 16:23:20','2016-02-07 16:04:19',12),(1000,'2015-11-26 08:00:00',2,5,'2015-11-19 16:47:10','2016-02-15 04:00:24',13),(150,'2015-12-16 18:31:00',2,1,'2015-12-16 18:31:39','2015-12-16 18:31:39',21),(120,'2015-12-23 17:54:00',2,4,'2015-12-23 17:54:27','2015-12-23 17:54:27',25),(97,'2015-12-24 22:00:00',2,7,'2015-12-23 22:00:49','2016-02-07 16:37:50',26),(66,'2015-11-01 15:48:00',2,3,'2015-12-26 00:19:53','2015-12-27 18:56:50',27),(90,'2015-12-16 18:31:00',2,2,'2016-01-22 19:27:02','2016-02-08 16:12:40',372),(70,'2015-11-27 10:34:00',2,3,'2016-01-22 19:27:09','2016-02-07 16:21:27',373),(70,'2015-11-28 09:00:00',2,2,'2016-01-24 22:33:25','2016-02-08 16:12:40',399),(80,'2015-11-27 10:34:00',2,2,'2016-01-24 22:34:22','2016-02-07 16:21:27',400),(80,'2015-11-26 09:00:00',2,3,'2016-01-24 22:36:47','2016-02-15 04:05:35',401),(30,'2015-12-23 22:00:00',2,7,'2016-01-26 15:49:23','2016-02-07 16:02:48',402),(63,'2015-12-25 22:00:00',2,7,'2016-01-26 15:51:16','2016-02-07 16:02:48',403),(130,'2015-11-28 09:00:00',2,1,'2016-01-26 16:12:45','2016-02-08 16:12:40',405),(160,'2015-12-29 17:54:00',2,4,'2016-01-26 16:19:47','2016-01-26 16:20:25',406),(120,'2016-01-08 09:01:00',2,1,'2016-01-26 21:08:07','2016-02-15 04:04:59',425),(55,'2016-01-08 09:01:00',2,3,'2016-01-26 21:20:27','2016-02-15 04:04:59',426),(70,'2016-01-08 09:01:00',2,2,'2016-01-26 21:22:44','2016-02-15 04:04:59',428),(60,'2016-01-11 09:30:00',2,7,'2016-01-27 14:30:49','2016-02-15 04:04:59',430),(1500,'2016-01-11 09:01:00',2,5,'2016-01-27 14:30:50','2016-02-15 04:04:59',431),(144,'2016-01-13 09:01:00',2,1,'2016-01-27 14:30:50','2016-02-15 04:04:46',432),(80,'2016-01-15 09:01:00',2,2,'2016-01-27 14:32:25','2016-02-15 04:05:00',433),(140,'2015-11-27 10:34:00',2,1,'2016-02-02 21:54:47','2016-02-08 16:12:40',436),(90,'2015-11-28 09:00:00',2,3,'2016-02-04 16:25:45','2016-02-08 16:11:06',437),(65,'2015-12-16 18:31:00',2,3,'2016-02-08 16:10:46','2016-02-08 16:11:06',439),(60,'2015-11-26 09:00:00',2,2,'2016-02-10 14:10:10','2016-02-15 04:01:00',443);
/*!40000 ALTER TABLE `duser_metrics` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-12-04 12:39:28

use dbcav;

-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: dbcav
-- ------------------------------------------------------
-- Server version	5.7.14

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
-- Dumping data for table `sectores`
--

LOCK TABLES `sectores` WRITE;
/*!40000 ALTER TABLE `sectores` DISABLE KEYS */;
INSERT INTO `sectores` VALUES (2,NULL,'Intendencia Unica','Intendencia','2017-01-02 19:39:30',NULL,NULL),(6,2,'Sectretaria de ABL','Secretaria','2017-01-02 19:50:34',NULL,'2017-01-03 19:55:16'),(7,2,'Secretaria Seguridad','Secretaria','2017-01-02 19:51:08',NULL,'2017-01-04 18:39:50'),(10,2,'Sec. Comercio','Secretaria','2017-01-03 18:36:48',NULL,'2017-01-04 18:41:13'),(11,6,'Of. Limpieza Bocacalles','Oficina','2017-01-03 18:45:47',NULL,'2017-01-04 18:41:46'),(12,7,'of. Policial 1','Oficina','2017-01-03 19:05:39',NULL,'2017-01-04 18:42:25'),(13,7,'Of. Policial 2','Oficina','2017-01-03 19:30:19',NULL,'2017-01-04 18:42:46'),(14,10,'Of. Mercados','Oficina','2017-01-03 19:30:38',NULL,'2017-01-04 18:43:22'),(15,10,'Of. Trueque','Oficina','2017-01-03 19:31:25',NULL,'2017-01-04 18:43:52'),(16,7,'Of. Seg Informatica','Oficina','2017-01-04 18:45:24',NULL,NULL);
/*!40000 ALTER TABLE `sectores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,0,'Gawron','Daniel','dwgawron@hotmail.com','5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8'),(20,3,'WalterApellido','Walter','walter@walter.com','f18f9d8baa2fa0cb58562a87b426733853e0a4e9'),(25,3,'Ramirez','Pablo','pablo_ram@hotmail.com','707d14912bb250caf67dfe0ea4035681fbfc4f56'),(26,3,'Juarez','Juan','jjuarez@hotmail.com','9d24de3ac7b5fbbe776a6d90fe25a7e3c74a29cc'),(27,3,'gonzalez','gonzalo','ggonzalez@hotmail.com','9d24de3ac7b5fbbe776a6d90fe25a7e3c74a29cc'),(28,2,'poli1','poli1','poli1@hotmail.com','fd7d570d77b1a657f6e828c6cf8deea15f093224'),(29,2,'trrrr','trrrrr','trrrrrrr','a94a8fe5ccb19ba61c4c0873d391e987982fbbd3');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `usuariosxsector`
--

LOCK TABLES `usuariosxsector` WRITE;
/*!40000 ALTER TABLE `usuariosxsector` DISABLE KEYS */;
INSERT INTO `usuariosxsector` VALUES (29,7),(25,11),(28,12),(20,16),(26,16),(27,16);
/*!40000 ALTER TABLE `usuariosxsector` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-01-10 13:49:47


/*	lleno los finde semana 2017 */
CALL llenarFeriados('2017-01-01','2017-12-31');

/*		inserto solo dos feriados de prueba los de carnaval		*/
INSERT INTO feriados (fecha) VALUES ('2017-02-27');
INSERT INTO feriados (fecha) VALUES ('2017-02-28');


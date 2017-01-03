CREATE DATABASE  IF NOT EXISTS `dbcav` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `dbcav`;
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
-- Table structure for table `barrios`
--

DROP TABLE IF EXISTS `barrios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `barrios` (
  `id_barrio` int(11) NOT NULL AUTO_INCREMENT,
  `barrio` varchar(45) NOT NULL,
  PRIMARY KEY (`id_barrio`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `calles`
--

DROP TABLE IF EXISTS `calles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calles` (
  `id_calle` int(11) NOT NULL AUTO_INCREMENT,
  `calle` text NOT NULL,
  PRIMARY KEY (`id_calle`)
) ENGINE=InnoDB AUTO_INCREMENT=653 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ci_sessions`
--

DROP TABLE IF EXISTS `ci_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ci_sessions` (
  `id` varchar(40) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int(10) unsigned NOT NULL DEFAULT '0',
  `data` blob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ci_sessions_timestamp` (`timestamp`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `domicilio`
--

DROP TABLE IF EXISTS `domicilio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domicilio` (
  `id_domicilio` int(11) NOT NULL AUTO_INCREMENT,
  `id_calle` int(11) DEFAULT NULL,
  `altura` int(11) DEFAULT NULL,
  `entrecalles` text,
  `id_barrio` int(11) NOT NULL,
  PRIMARY KEY (`id_domicilio`),
  KEY `id_barrio_idx` (`id_barrio`),
  KEY `id_cale_idx` (`id_calle`),
  CONSTRAINT `id_barrio` FOREIGN KEY (`id_barrio`) REFERENCES `barrios` (`id_barrio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `id_calle` FOREIGN KEY (`id_calle`) REFERENCES `calles` (`id_calle`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `domicilio_reclamo`
--

DROP TABLE IF EXISTS `domicilio_reclamo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domicilio_reclamo` (
  `id_domicilio` int(11) NOT NULL AUTO_INCREMENT,
  `id_calle` int(11) DEFAULT NULL,
  `altura_inicio` int(11) NOT NULL,
  `altura_fin` int(11) NOT NULL,
  `entrecalles` text NOT NULL,
  `barrio` varchar(45) NOT NULL,
  PRIMARY KEY (`id_domicilio`),
  KEY `id_calle_idx` (`id_calle`),
  CONSTRAINT `id_calle_reclamo` FOREIGN KEY (`id_calle`) REFERENCES `calles` (`id_calle`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `domiciliosxvecinos`
--

DROP TABLE IF EXISTS `domiciliosxvecinos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `domiciliosxvecinos` (
  `id_domiciliosxvecinos` int(11) NOT NULL AUTO_INCREMENT,
  `id_vecino` int(11) NOT NULL,
  `id_domicilio` int(11) NOT NULL,
  `fecha_alta` datetime DEFAULT NULL,
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_domiciliosxvecinos`),
  KEY `id_vecino_idx` (`id_vecino`),
  KEY `id_domicilio_idx` (`id_domicilio`),
  CONSTRAINT `id_domicilio` FOREIGN KEY (`id_domicilio`) REFERENCES `domicilio` (`id_domicilio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `id_vecino` FOREIGN KEY (`id_vecino`) REFERENCES `vecino` (`id_vecino`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `encuestas`
--

DROP TABLE IF EXISTS `encuestas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `encuestas` (
  `id_encuesta` int(11) NOT NULL AUTO_INCREMENT,
  `id_reclamo` int(11) DEFAULT NULL,
  `tiempo` tinyint(4) DEFAULT NULL,
  `nota` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_encuesta`),
  KEY `id_reclamo_idx` (`id_reclamo`),
  CONSTRAINT `id_reclamo` FOREIGN KEY (`id_reclamo`) REFERENCES `reclamos` (`id_reclamo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `localidades`
--

DROP TABLE IF EXISTS `localidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `localidades` (
  `id_localidad` int(11) NOT NULL AUTO_INCREMENT,
  `localidades` text NOT NULL,
  PRIMARY KEY (`id_localidad`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `localidadxcalle`
--

DROP TABLE IF EXISTS `localidadxcalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `localidadxcalle` (
  `id_loc` int(11) NOT NULL,
  `id_calle` int(11) NOT NULL,
  PRIMARY KEY (`id_loc`,`id_calle`),
  KEY `id_calle_idx` (`id_calle`),
  CONSTRAINT `id_callexlocalidad` FOREIGN KEY (`id_calle`) REFERENCES `calles` (`id_calle`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `id_localidadxcalle` FOREIGN KEY (`id_loc`) REFERENCES `localidades` (`id_localidad`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reclamos`
--

DROP TABLE IF EXISTS `reclamos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reclamos` (
  `id_reclamo` int(11) NOT NULL AUTO_INCREMENT,
  `id_vecino` int(11) NOT NULL,
  `id_tipo_reclamo` int(11) NOT NULL,
  `id_operador` int(11) NOT NULL,
  `id_responsable` int(11) DEFAULT NULL,
  `estado` tinyint(4) DEFAULT NULL,
  `datestamp_ini` datetime DEFAULT NULL,
  `datestamp_lastchange` datetime DEFAULT NULL,
  `id_lastchanger` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_reclamo`),
  KEY `id_vecino_idx` (`id_vecino`),
  KEY `id_op_id_us_idx` (`id_operador`),
  KEY `id_resp_id_us_idx` (`id_responsable`),
  KEY `id_last_id_us_idx` (`id_lastchanger`),
  CONSTRAINT `id_last_id_us` FOREIGN KEY (`id_lastchanger`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `id_op_id_us` FOREIGN KEY (`id_operador`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `id_resp_id_us` FOREIGN KEY (`id_responsable`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `id_vecino_reclamo` FOREIGN KEY (`id_vecino`) REFERENCES `vecino` (`id_vecino`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sectores`
--

DROP TABLE IF EXISTS `sectores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sectores` (
  `id_sector` int(11) NOT NULL AUTO_INCREMENT,
  `id_padre` int(11) DEFAULT NULL,
  `denominacion` varchar(45) DEFAULT NULL,
  `tipo` varchar(25) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT NULL,
  `fecha_cierre` datetime DEFAULT NULL,
  PRIMARY KEY (`id_sector`),
  KEY `id_padre_sector_idx` (`id_padre`),
  CONSTRAINT `id_padre_sector` FOREIGN KEY (`id_padre`) REFERENCES `sectores` (`id_sector`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tiporeclamo`
--

DROP TABLE IF EXISTS `tiporeclamo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tiporeclamo` (
  `id_tipo_reclamo` int(11) NOT NULL AUTO_INCREMENT,
  `tiempo_respuesta_hs` int(11) NOT NULL,
  `id_responsable` int(11) NOT NULL,
  PRIMARY KEY (`id_tipo_reclamo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `perfil_level` tinyint(4) NOT NULL DEFAULT '3',
  `apellido` varchar(45) DEFAULT NULL,
  `nombre` varchar(45) DEFAULT NULL,
  `email` text,
  `password` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuariosxsector`
--

DROP TABLE IF EXISTS `usuariosxsector`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuariosxsector` (
  `id_usuario` int(11) NOT NULL,
  `id_sector` int(11) NOT NULL,
  PRIMARY KEY (`id_usuario`,`id_sector`),
  KEY `id_us_sector_idx` (`id_sector`),
  CONSTRAINT `id_integrante` FOREIGN KEY (`id_usuario`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `id_us_sector` FOREIGN KEY (`id_sector`) REFERENCES `sectores` (`id_sector`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vecino`
--

DROP TABLE IF EXISTS `vecino`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vecino` (
  `id_vecino` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(45) NOT NULL,
  `Apellido` varchar(45) NOT NULL,
  `mail` varchar(45) DEFAULT NULL,
  `tel` bigint(20) DEFAULT NULL,
  `cel` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id_vecino`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-12-31 18:54:53

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema dbcav
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema dbcav
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dbcav` DEFAULT CHARACTER SET utf8 ;
USE `dbcav` ;

-- -----------------------------------------------------
-- Table `dbcav`.`barrios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`barrios` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`barrios` (
  `id_barrio` INT(11) NOT NULL AUTO_INCREMENT,
  `barrio` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_barrio`))
ENGINE = InnoDB
AUTO_INCREMENT = 69
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`calles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`calles` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`calles` (
  `id_calle` INT(11) NOT NULL AUTO_INCREMENT,
  `calle` TEXT NOT NULL,
  PRIMARY KEY (`id_calle`))
ENGINE = InnoDB
AUTO_INCREMENT = 653
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`ci_sessions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`ci_sessions` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`ci_sessions` (
  `id` VARCHAR(40) NOT NULL,
  `ip_address` VARCHAR(45) NOT NULL,
  `timestamp` INT(10) UNSIGNED NOT NULL DEFAULT '0',
  `data` BLOB NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `ci_sessions_timestamp` (`timestamp` ASC))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`direcciones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`direcciones` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`direcciones` (
  `id_direccion` INT(11) NOT NULL,
  `nombre` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id_direccion`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`domicilio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`domicilio` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`domicilio` (
  `id_domicilio` INT(11) NOT NULL AUTO_INCREMENT,
  `id_calle` INT(11) NULL DEFAULT NULL,
  `altura` INT(11) NULL DEFAULT NULL,
  `entrecalles` TEXT NULL DEFAULT NULL,
  `id_barrio` INT(11) NOT NULL,
  PRIMARY KEY (`id_domicilio`),
  INDEX `id_barrio_idx` (`id_barrio` ASC),
  INDEX `id_cale_idx` (`id_calle` ASC),
  CONSTRAINT `id_barrio`
    FOREIGN KEY (`id_barrio`)
    REFERENCES `dbcav`.`barrios` (`id_barrio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_calle`
    FOREIGN KEY (`id_calle`)
    REFERENCES `dbcav`.`calles` (`id_calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`domicilio_reclamo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`domicilio_reclamo` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`domicilio_reclamo` (
  `id_domicilio` INT(11) NOT NULL AUTO_INCREMENT,
  `id_calle` INT(11) NULL DEFAULT NULL,
  `altura_inicio` INT(11) NOT NULL,
  `altura_fin` INT(11) NOT NULL,
  `entrecalles` TEXT NOT NULL,
  `barrio` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_domicilio`),
  INDEX `id_calle_idx` (`id_calle` ASC),
  CONSTRAINT `id_calle_reclamo`
    FOREIGN KEY (`id_calle`)
    REFERENCES `dbcav`.`calles` (`id_calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`vecino`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`vecino` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`vecino` (
  `id_vecino` INT(11) NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `Apellido` VARCHAR(45) NOT NULL,
  `mail` VARCHAR(45) NULL DEFAULT NULL,
  `tel` BIGINT(20) NULL DEFAULT NULL,
  `cel` BIGINT(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id_vecino`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`domiciliosxvecinos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`domiciliosxvecinos` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`domiciliosxvecinos` (
  `id_domiciliosxvecinos` INT(11) NOT NULL AUTO_INCREMENT,
  `id_vecino` INT(11) NOT NULL,
  `id_domicilio` INT(11) NOT NULL,
  `fecha_alta` DATETIME NULL DEFAULT NULL,
  `fecha_baja` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id_domiciliosxvecinos`),
  INDEX `id_vecino_idx` (`id_vecino` ASC),
  INDEX `id_domicilio_idx` (`id_domicilio` ASC),
  CONSTRAINT `id_domicilio`
    FOREIGN KEY (`id_domicilio`)
    REFERENCES `dbcav`.`domicilio` (`id_domicilio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_vecino`
    FOREIGN KEY (`id_vecino`)
    REFERENCES `dbcav`.`vecino` (`id_vecino`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`tiporeclamo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`tiporeclamo` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`tiporeclamo` (
  `id_tipo_reclamo` INT(11) NOT NULL,
  `tiempo_respuesta_hs` INT(11) NOT NULL,
  `id_direccion` INT(11) NOT NULL,
  PRIMARY KEY (`id_tipo_reclamo`),
  INDEX `id_direccion_idx` (`id_direccion` ASC),
  CONSTRAINT `id_direccion`
    FOREIGN KEY (`id_direccion`)
    REFERENCES `dbcav`.`direcciones` (`id_direccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`user` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `perfil_level` TINYINT(4) NOT NULL DEFAULT '3',
  `apellido` VARCHAR(45) NULL DEFAULT NULL,
  `nombre` VARCHAR(45) NULL DEFAULT NULL,
  `mail` TEXT NULL DEFAULT NULL,
  `password` VARCHAR(45) NULL DEFAULT NULL,
  `loginuser` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`reclamos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`reclamos` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`reclamos` (
  `id_reclamo` INT(11) NOT NULL AUTO_INCREMENT,
  `id_vecino` INT(11) NOT NULL,
  `id_tipo_reclamo` INT(11) NOT NULL,
  `id_operador` INT(11) NOT NULL,
  `id_responsable` INT(11) NULL DEFAULT NULL,
  `estado` TINYINT(4) NULL DEFAULT NULL,
  `datestamp_ini` DATETIME NULL DEFAULT NULL,
  `datestamp_lastchange` DATETIME NULL DEFAULT NULL,
  `id_lastchanger` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id_reclamo`),
  INDEX `id_tipo_reclamo_idx` (`id_tipo_reclamo` ASC),
  INDEX `id_vecino_idx` (`id_vecino` ASC),
  INDEX `id_op_id_us_idx` (`id_operador` ASC),
  INDEX `id_resp_id_us_idx` (`id_responsable` ASC),
  INDEX `id_last_id_us_idx` (`id_lastchanger` ASC),
  CONSTRAINT `id_tipo_reclamo`
    FOREIGN KEY (`id_tipo_reclamo`)
    REFERENCES `dbcav`.`tiporeclamo` (`id_tipo_reclamo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_vecino_reclamo`
    FOREIGN KEY (`id_vecino`)
    REFERENCES `dbcav`.`vecino` (`id_vecino`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_op_id_us`
    FOREIGN KEY (`id_operador`)
    REFERENCES `dbcav`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_resp_id_us`
    FOREIGN KEY (`id_responsable`)
    REFERENCES `dbcav`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_last_id_us`
    FOREIGN KEY (`id_lastchanger`)
    REFERENCES `dbcav`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`encuestas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`encuestas` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`encuestas` (
  `id_encuesta` INT(11) NOT NULL AUTO_INCREMENT,
  `id_reclamo` INT(11) NULL DEFAULT NULL,
  `tiempo` TINYINT(4) NULL DEFAULT NULL,
  `nota` TINYINT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`id_encuesta`),
  INDEX `id_reclamo_idx` (`id_reclamo` ASC),
  CONSTRAINT `id_reclamo`
    FOREIGN KEY (`id_reclamo`)
    REFERENCES `dbcav`.`reclamos` (`id_reclamo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`localidades`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`localidades` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`localidades` (
  `id_localidad` INT(11) NOT NULL AUTO_INCREMENT,
  `localidades` TEXT NOT NULL,
  PRIMARY KEY (`id_localidad`))
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`localidadxcalle`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`localidadxcalle` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`localidadxcalle` (
  `id_loc` INT(11) NOT NULL,
  `id_calle` INT(11) NOT NULL,
  PRIMARY KEY (`id_loc`, `id_calle`),
  INDEX `id_calle_idx` (`id_calle` ASC),
  CONSTRAINT `id_callexlocalidad`
    FOREIGN KEY (`id_calle`)
    REFERENCES `dbcav`.`calles` (`id_calle`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_localidadxcalle`
    FOREIGN KEY (`id_loc`)
    REFERENCES `dbcav`.`localidades` (`id_localidad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`secretarias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`secretarias` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`secretarias` (
  `id_secretaria` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL DEFAULT NULL,
  `id_secretario` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id_secretaria`),
  CONSTRAINT `id_direcciones`
    FOREIGN KEY (`id_secretaria`)
    REFERENCES `dbcav`.`direcciones` (`id_direccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbcav`.`usuariosxdireccion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbcav`.`usuariosxdireccion` ;

CREATE TABLE IF NOT EXISTS `dbcav`.`usuariosxdireccion` (
  `id_usuario` INT(11) NOT NULL,
  `id_direccion` INT(11) NOT NULL,
  PRIMARY KEY (`id_usuario`, `id_direccion`),
  INDEX `id_direccion_idx` (`id_direccion` ASC),
  CONSTRAINT `id_direccionxusuario`
    FOREIGN KEY (`id_direccion`)
    REFERENCES `dbcav`.`direcciones` (`id_direccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_integrante`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `dbcav`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema dbcav
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema dbcav
-- -----------------------------------------------------

USE `dbcav` ;

-- -----------------------------------------------------
-- Table `dbcav`.`tr_grupos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbcav`.`tr_grupos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbcav`.`tr_tipo_tramite`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbcav`.`tr_tipo_tramite` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tr_grupo_id` INT NOT NULL,
  `titulo` VARCHAR(45) NULL,
  `desc` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_tipo_tramite_grupos1_idx` (`tr_grupo_id` ASC),
  CONSTRAINT `fk_tipo_tramite_grupos1`
    FOREIGN KEY (`tr_grupo_id`)
    REFERENCES `dbcav`.`tr_grupos` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbcav`.`tr_paso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbcav`.`tr_paso` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(45) NULL,
  `desc` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbcav`.`tr_pasos_x_tramite`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbcav`.`tr_pasos_x_tramite` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_sector` INT(11) NULL,
  `orden` INT NOT NULL DEFAULT 1,
  `tr_tipo_tramite_id` INT NOT NULL,
  `tr_paso_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_tr_pasos_x_tramite_tr_tipo_tramite1_idx` (`tr_tipo_tramite_id` ASC),
  INDEX `fk_tr_pasos_x_tramite_tr_paso1_idx` (`tr_paso_id` ASC),
  CONSTRAINT `fk_tr_pasos_x_tramite_tr_tipo_tramite1`
    FOREIGN KEY (`tr_tipo_tramite_id`)
    REFERENCES `dbcav`.`tr_tipo_tramite` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tr_pasos_x_tramite_tr_paso1`
    FOREIGN KEY (`tr_paso_id`)
    REFERENCES `dbcav`.`tr_paso` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbcav`.`tr_formularios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbcav`.`tr_formularios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `codigo_interno` VARCHAR(20) NULL,
  `titulo` VARCHAR(45) NULL,
  `desc` TEXT NULL,
  `tr_paso_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_tr_formularios_tr_paso1_idx` (`tr_paso_id` ASC),
  CONSTRAINT `fk_tr_formularios_tr_paso1`
    FOREIGN KEY (`tr_paso_id`)
    REFERENCES `dbcav`.`tr_paso` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbcav`.`tr_tramite`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbcav`.`tr_tramite` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_vecino` INT(11) NOT NULL,
  `pasos_completados` INT(1) NOT NULL DEFAULT 0,
  `desc` TEXT NULL,
  `tr_tipo_tramite_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_tr_tramite_tr_tipo_tramite1_idx` (`tr_tipo_tramite_id` ASC),
  CONSTRAINT `fk_tr_tramite_tr_tipo_tramite1`
    FOREIGN KEY (`tr_tipo_tramite_id`)
    REFERENCES `dbcav`.`tr_tipo_tramite` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



ALTER TABLE `dbcav`.`tr_tramite` 
ADD INDEX `fk_vecino_cav_idx` (`id_vecino` ASC);
ALTER TABLE `dbcav`.`tr_tramite` 
ADD CONSTRAINT `fk_vecino_cav`
  FOREIGN KEY (`id_vecino`)
  REFERENCES `dbcav`.`vecino` (`id_vecino`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

  
ALTER TABLE `dbcav`.`tr_pasos_x_tramite` 
ADD INDEX `fk_tr_pasos_sector_idx` (`id_sector` ASC);
ALTER TABLE `dbcav`.`tr_pasos_x_tramite` 
ADD CONSTRAINT `fk_tr_pasos_sector`
  FOREIGN KEY (`id_sector`)
  REFERENCES `dbcav`.`sectores` (`id_sector`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

  
ALTER TABLE `dbcav`.`tr_pasos_x_tramite` 
CHANGE COLUMN `orden` `orden` INT(11) NOT NULL DEFAULT '1' AFTER `tr_paso_id`,
ADD COLUMN `tiempo_estimado` INT(3) NOT NULL DEFAULT '24' AFTER `orden`;


/* agregados de checklist */ 

ALTER TABLE `dbcav`.`tr_paso` 
ADD COLUMN `check_list_json` TEXT NULL DEFAULT NULL AFTER `desc`;

INSERT INTO `dbcav`.`user` (`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('13','Test','Operadortramite','operator_tr','7a52f614ef66df14cc65dc2ef015a281e3fcc079');




ALTER TABLE `dbcav`.`tr_paso` 
ADD COLUMN `id_sector` INT(11) NOT NULL AFTER `id`;

ALTER TABLE `dbcav`.`tr_pasos_x_tramite` 
DROP FOREIGN KEY `fk_tr_pasos_sector`;
ALTER TABLE `dbcav`.`tr_pasos_x_tramite` 
DROP COLUMN `id_sector`,
DROP INDEX `fk_tr_pasos_sector_idx` ;


ALTER TABLE `dbcav`.`tr_paso` 
ADD INDEX `sector_x_paso_idx` (`id_sector` ASC);
ALTER TABLE `dbcav`.`tr_paso` 
ADD CONSTRAINT `sector_x_paso`
  FOREIGN KEY (`id_sector`)
  REFERENCES `dbcav`.`sectores` (`id_sector`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

  
  ALTER TABLE `dbcav`.`tr_formularios` 
ADD COLUMN `file_name` TEXT NOT NULL AFTER `id`;

ALTER TABLE `dbcav`.`tr_pasos_x_tramite` 
RENAME TO  `dbcav`.`tr_pasos_x_tipo_tramite` ;

INSERT INTO `dbcav`.`tr_grupos` (`id`, `nombre`) VALUES ('1', 'Vecino');
INSERT INTO `dbcav`.`tr_grupos` (`id`, `nombre`) VALUES ('2', 'Comercio');
INSERT INTO `dbcav`.`tr_grupos` (`id`, `nombre`) VALUES ('3', 'Transporte');
INSERT INTO `dbcav`.`tr_grupos` (`id`, `nombre`) VALUES ('4', 'Tramites Sociales');

/* 10/01/2018				*/

ALTER TABLE `dbcav`.`tr_tramite` 
CHANGE COLUMN `desc` `obs` TEXT NULL DEFAULT NULL ;

ALTER TABLE `dbcav`.`tr_tramite` 
ADD COLUMN `tr_fecha_tramite` DATETIME NOT NULL AFTER `tr_tipo_tramite_id`;




ALTER TABLE `dbcav`.`sectores` 
ADD COLUMN `fecha_modificacion` DATETIME NULL DEFAULT NULL AFTER `fecha_cierre`;

ALTER TABLE `dbcav`.`usuariosxsector` 
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id_usuario`);

CREATE TABLE `dbcav`.`feriados` (
  `fecha` DATE NOT NULL,
  PRIMARY KEY (`fecha`));

  
use dbcav;

DROP PROCEDURE IF EXISTS llenarFeriados;
DELIMITER |
CREATE PROCEDURE llenarFeriados(dateStart DATE, dateEnd DATE)
BEGIN
  WHILE dateStart <= dateEnd DO
        IF(	dayname(dateStart) = 'Saturday') THEN
			INSERT INTO feriados (fecha) VALUES (dateStart);
			SET dateStart = date_add(dateStart, INTERVAL 1 DAY);
		ELSEIF ( dayname(dateStart) = 'Sunday' ) THEN
			INSERT INTO feriados (fecha) VALUES (dateStart);
			SET dateStart = date_add(dateStart, INTERVAL 5 DAY);
		ELSE
			SET dateStart = date_add(dateStart, INTERVAL 1 DAY);
        END IF;
  END WHILE;
END;
|
DELIMITER ; 



/* 	
SET lc_time_names = 'es_ES';
SELECT year(fecha) as anio,  monthname(fecha) mes, dayname(fecha) dia, fecha FROM dbcav.feriados 
WHERE dayname(fecha) != 'Sabado' AND dayname(fecha) != 'Domingo' and year(fecha) >= year(current_date())
ORDER BY fecha ;
SET lc_time_names = 'en_US';
 */
 
  
/*		MARCA	*/
 
 ALTER TABLE `dbcav`.`reclamos` 
ADD COLUMN `descripcion` TEXT NULL AFTER `estado`;


ALTER TABLE `dbcav`.`tiporeclamo` 
ADD COLUMN `descripcion` TEXT NULL AFTER `id_responsable`,
ADD COLUMN `titulo` VARCHAR(45) NOT NULL AFTER `descripcion`,
ADD COLUMN `estado_activo` BIT NOT NULL  DEFAULT TRUE AFTER `titulo` ;

/*		MARCA	13/01/17	*/

ALTER TABLE `dbcav`.`domicilio` 
ADD COLUMN `dpto` INT NOT NULL AFTER `id_barrio`,
ADD COLUMN `piso` INT NOT NULL AFTER `dpto`;

ALTER TABLE `dbcav`.`domicilio` 
CHANGE COLUMN `entrecalles` `entrecalle1` TINYTEXT NULL DEFAULT NULL ,
ADD COLUMN `entrecalle2` TINYTEXT NULL DEFAULT NULL AFTER `entrecalle1`;

ALTER TABLE `dbcav`.`domicilio` 
CHANGE COLUMN `entrecalle1` `entrecalle1_id` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `entrecalle2` `entrecalle2_id` INT(11) NULL DEFAULT NULL ;


ALTER TABLE `dbcav`.`vecino` 
CHANGE COLUMN `tel` `tel_fijo` VARCHAR(20) NULL DEFAULT NULL ,
CHANGE COLUMN `cel` `tel_movil` VARCHAR(20) NULL DEFAULT NULL ;

ALTER TABLE `dbcav`.`domicilio` 
DROP FOREIGN KEY `id_calle`;
ALTER TABLE `dbcav`.`domicilio` 
CHANGE COLUMN `id_calle` `id_calle` INT(11) NOT NULL ,
CHANGE COLUMN `altura` `altura` INT(11) NOT NULL ,
CHANGE COLUMN `entrecalle1_id` `entrecalle1_id` INT(11) NOT NULL ,
CHANGE COLUMN `entrecalle2_id` `entrecalle2_id` INT(11) NOT NULL ,
CHANGE COLUMN `dpto` `dpto` INT(11) NULL ,
CHANGE COLUMN `piso` `piso` INT(11) NULL ;
ALTER TABLE `dbcav`.`domicilio` 
ADD CONSTRAINT `id_calle`
  FOREIGN KEY (`id_calle`)
  REFERENCES `dbcav`.`calles` (`id_calle`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `dbcav`.`vecino` 
ADD COLUMN `DNI` INT(20) NOT NULL AFTER `Apellido`;

ALTER TABLE `dbcav`.`domicilio_reclamo` 
ADD COLUMN `columna_electrica` VARCHAR(20) NULL AFTER `barrio`;

ALTER TABLE `dbcav`.`reclamos` 
ADD COLUMN `molestar_dia_hs` TINYTEXT NULL AFTER `id_lastchanger`,
ADD COLUMN `molestar_al_tel_fijo` BIT NULL AFTER `molestar_dia_hs`,
ADD COLUMN `molestar_al_tel_mov` BIT NULL AFTER `molestar_al_tel_fijo`,
ADD COLUMN `molestar_al_domicilio` BIT NULL AFTER `molestar_al_tel_mov`,
ADD COLUMN `comentarios` TEXT NULL AFTER `molestar_al_domicilio`;


ALTER TABLE `dbcav`.`reclamos` 
DROP FOREIGN KEY `id_resp_id_us`;
ALTER TABLE `dbcav`.`reclamos` 
DROP COLUMN `id_responsable`,
DROP INDEX `id_resp_id_us_idx` ;

ALTER TABLE `dbcav`.`reclamos` 
ADD INDEX `id_tipo_reclamo_idx` (`id_tipo_reclamo` ASC);
ALTER TABLE `dbcav`.`reclamos` 
ADD CONSTRAINT `id_tipo_reclamo`
  FOREIGN KEY (`id_tipo_reclamo`)
  REFERENCES `dbcav`.`tiporeclamo` (`id_tipo_reclamo`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
 ALTER TABLE `dbcav`.`reclamos` 
CHANGE COLUMN `estado` `estado` VARCHAR(20) NOT NULL ,
CHANGE COLUMN `molestar_al_tel_fijo` `molestar_al_tel_fijo` BIT(1) NULL ,
CHANGE COLUMN `molestar_al_tel_mov` `molestar_al_tel_mov` BIT(1) NULL ,
CHANGE COLUMN `molestar_al_domicilio` `molestar_al_domicilio` BIT(1) NULL ,
ADD COLUMN `codigo_reclamo` VARCHAR(13) NOT NULL AFTER `comentarios`,
ADD COLUMN `fecha_alta_reclamo` DATETIME NOT NULL AFTER `codigo_reclamo`;

ALTER TABLE `dbcav`.`domicilio_reclamo` 
CHANGE COLUMN `entrecalles` `entrecalle1_id` INT(11) NOT NULL ,
CHANGE COLUMN `barrio` `id_barrio` INT(11) NOT NULL ,
ADD COLUMN `entrecalle2_id` INT(11) NOT NULL AFTER `entrecalle1_id`,
ADD INDEX `id_dom_rec_calle1_idx` (`entrecalle1_id` ASC);
ALTER TABLE `dbcav`.`domicilio_reclamo` 
ADD CONSTRAINT `id_dom_rec_calle1`
  FOREIGN KEY (`entrecalle1_id`)
  REFERENCES `dbcav`.`calles` (`id_calle`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  ALTER TABLE `dbcav`.`domicilio_reclamo` 
ADD INDEX `id_dom_rec_calle2_idx` (`entrecalle2_id` ASC);
ALTER TABLE `dbcav`.`domicilio_reclamo` 
ADD CONSTRAINT `id_dom_rec_calle2`
  FOREIGN KEY (`entrecalle2_id`)
  REFERENCES `dbcav`.`calles` (`id_calle`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  ALTER TABLE `dbcav`.`domicilio_reclamo` 
ADD INDEX `id_dom_rec_barrio_idx` (`id_barrio` ASC);
ALTER TABLE `dbcav`.`domicilio_reclamo` 
ADD CONSTRAINT `id_dom_rec_barrio`
  FOREIGN KEY (`id_barrio`)
  REFERENCES `dbcav`.`barrios` (`id_barrio`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  ALTER TABLE `dbcav`.`reclamos` 
DROP COLUMN `descripcion`;

ALTER TABLE `dbcav`.`reclamos` 
DROP COLUMN `datestamp_ini`,
CHANGE COLUMN `fecha_alta_reclamo` `fecha_alta_reclamo` DATETIME NOT NULL AFTER `fecha_modif_reclamo`,
CHANGE COLUMN `datestamp_lastchange` `fecha_modif_reclamo` DATETIME NULL DEFAULT NULL ;

ALTER TABLE `dbcav`.`reclamos` 
ADD COLUMN `id_dom_reclamo` INT(11) NOT NULL AFTER `id_operador`,
ADD INDEX `id_dom_reclamo_idx` (`id_dom_reclamo` ASC);
ALTER TABLE `dbcav`.`reclamos` 
ADD CONSTRAINT `id_dom_reclamo`
  FOREIGN KEY (`id_dom_reclamo`)
  REFERENCES `dbcav`.`domicilio_reclamo` (`id_domicilio`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

  
  /*		MARCA	18/01/17	*/
  
  ALTER TABLE `dbcav`.`domicilio` 
ADD COLUMN `altura_fin` INT(11) NULL DEFAULT NULL AFTER `piso`,
ADD COLUMN `columna_luminaria` INT(11) NULL DEFAULT NULL AFTER `altura_fin`;

/* puede que no esten porq los cargue yo  lo importante es borrar todos los reclamos antes de borrar los domicilios de reclamos y depues ponerle la foren key a domicilios*/
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='1';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='2';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='3';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='4';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='5';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='6';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='7';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='8';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='9';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='10';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='11';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='12';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='13';

	

ALTER TABLE `dbcav`.`domicilio_reclamo` 
DROP FOREIGN KEY `id_dom_rec_calle2`,
DROP FOREIGN KEY `id_dom_rec_calle1`,
DROP FOREIGN KEY `id_dom_rec_barrio`,
DROP FOREIGN KEY `id_calle_reclamo`;
ALTER TABLE `dbcav`.`domicilio_reclamo` 
DROP INDEX `id_dom_rec_barrio_idx` ,
DROP INDEX `id_dom_rec_calle2_idx` ,
DROP INDEX `id_dom_rec_calle1_idx` ,
DROP INDEX `id_calle_idx` ;

/* puede que no esten porq los cargue yo */
DELETE FROM `dbcav`.`domicilio_reclamo` WHERE `id_domicilio`='1';
DELETE FROM `dbcav`.`domicilio_reclamo` WHERE `id_domicilio`='2';
DELETE FROM `dbcav`.`domicilio_reclamo` WHERE `id_domicilio`='3';



ALTER TABLE `dbcav`.`reclamos` 
DROP FOREIGN KEY `id_dom_reclamo`;
ALTER TABLE `dbcav`.`reclamos` 
ADD INDEX `id_dom_reclamo_idx` (`id_dom_reclamo` ASC),
DROP INDEX `id_dom_reclamo_idx` ;
ALTER TABLE `dbcav`.`reclamos` 
ADD CONSTRAINT `id_dom_reclamo`
  FOREIGN KEY (`id_dom_reclamo`)
  REFERENCES `dbcav`.`domicilio` (`id_domicilio`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  /* ACA HAY QUE   DROPERAR LA TABLA DE domicilo_reclamos	a mano */ 

  ALTER TABLE `dbcav`.`reclamos` 
ADD COLUMN `observaciones` TEXT NULL DEFAULT NULL AFTER `codigo_reclamo`,
ADD COLUMN `domicilio_restringido` BIT(1) NULL DEFAULT FALSE AFTER `observaciones`;




/* LIMPIAMOS LA BASE ANTES DE CARGAR los scripts de la data posta */

/* BORRAR TODOS LOS RECLAMOS PRIMERO */


DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='29';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='31';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='32';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='25';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='28';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='20';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='26';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='27';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='30';

/* ACA BORRO TODOS LOS USUARIOS MENOS EL ADMINISTRADOR */
DELETE FROM `dbcav`.`user` WHERE `id`='20';
DELETE FROM `dbcav`.`user` WHERE `id`='25';
DELETE FROM `dbcav`.`user` WHERE `id`='26';
DELETE FROM `dbcav`.`user` WHERE `id`='27';
DELETE FROM `dbcav`.`user` WHERE `id`='28';
DELETE FROM `dbcav`.`user` WHERE `id`='29';
DELETE FROM `dbcav`.`user` WHERE `id`='30';
DELETE FROM `dbcav`.`user` WHERE `id`='31';
DELETE FROM `dbcav`.`user` WHERE `id`='32';


/* ACA BORRO SECTORES MENOS LA INTENDENCIA, SI LA LLEGO A BORRAR TENDRIA Q VOLVER A CREARLA*/

DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='11';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='12';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='13';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='14';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='15';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='16';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='17';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='6';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='7';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='10';



DELETE FROM `dbcav`.`domiciliosxvecinos` WHERE `id_domiciliosxvecinos`='3';
DELETE FROM `dbcav`.`domiciliosxvecinos` WHERE `id_domiciliosxvecinos`='4';
DELETE FROM `dbcav`.`domiciliosxvecinos` WHERE `id_domiciliosxvecinos`='5';


DELETE FROM `dbcav`.`vecino` WHERE `id_vecino`='6';
DELETE FROM `dbcav`.`vecino` WHERE `id_vecino`='7';
DELETE FROM `dbcav`.`vecino` WHERE `id_vecino`='8';

DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='4';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='5';


DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='5';

/* carga de SECTORES POSTA */

INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('18','2','SEGURIDAD','SECRETARIO','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('27','18','transito ','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('28','18','proteccion ciudadana ','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('19','2','HACIENDA ','SECRETARIA','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('29','19','rentas','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('20','2','CULTURA','SECRETARIA','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('30','20','cultura','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('21','2','GOBIERNO ','SECRETARIA','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('31','21','cementerio ','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('64','21','INSP. GENERAL','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('65','21','licencias','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('66','21','tierrasy viviendas','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('67','21','legal y tecnica','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('68','21','relac. Institucionales','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('22','2','SALUD','SECRETARIA','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('32','22','hospital ','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('33','22','salud','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('23','2','O.PUBLICAS','SECRETARIA','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('34','23','contralor','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('35','23','delegaciones ','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('36','23','plazas','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('37','23','espacios verdes','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('38','23','infraestructura ','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('39','23','luminarias','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('40','23','hidraulica ','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('41','23','obras particulares','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('42','23','ordenamiento territorial','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('43','23','servicios','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('24','2','JEFGABINETE','SECRETARIA','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('44','24','direccion ','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('25','2','D.SOSTENIBLE','SECRETARIA','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('45','25','d-sostenible','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('46','25','forestacion ','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('47','25','acumar','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('26','2','D. SOCIAL','SECRETARIA','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('48','26','adultos mayores','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('49','26','casa del joven','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('50','26','sede cai','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('51','26','sede cic ','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('52','26','cooperativas','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('53','26','deportes','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('54','26','discapacidad','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('55','26','logistica','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('56','26','microemprendimiento','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('57','26','niñez, adolescencia y flia','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('58','26','niñez, adolescencia y flia','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('59','26','pensiones CNPA','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('60','26','plan vida ','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('61','26','envion','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('62','26','servicio comunitario','Direccion/Oficina','2017-02-19 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('63','26','tiket nacion ','Direccion/Oficina','2017-02-19 12:45:34',null,null);

/* USUARIOS   */ 
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('3','1','SALERNO','CARLOS','seguridadee@gmail.com','c03f51fb3bed5a91243e7ec950cdd39ffaf7bc88');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('4','2','LEGUIZAMON','JULIO ','transitomee@gmail.com','43e9c17b38a4aca87dddf82873e1998166228a30');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('5','2','ZARATE','ALEJANDRO','seguridadee@gmail.com','5ae9984717762bad907bc3ce99f99bedd3139f61');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('6','1','LOPEZ ALONSO','INDIANA','haciendaeecheverria@gmail.com','87c7a10f06c2a12d43294c1d3bcd05d2e5280c62');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('7','2','GARCIA','LUCIANA','lgarcia@estebanecheverria.gob.ar','d08cd7ccdc9fac048288aa5bb0978ed9f3c55f1e');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('8','1','RODRIGUEZ PARISE','LEONARDO ','subsecretario.cultura@estebanecheverria.gob.ar','1abc6174d14e5fcf0dec8ad5e18d1ef7166e207d');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('10','1','BERTINO','FABIANA ','fabianabertinoee@gmail.com','5eb8df907b0e0a2ed1a102de333b63c4729bd0e3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('11','2','Lolisio','Sergio','','6bd7560be9243bf28f952e58faae2c179c5a2260');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('12','2','Garabaglia','Jose Luis','','fc137b0cca93acc32d134419e42e1e596bc7e24c');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('13','2','Buonomo','Alejandro','','367830e537ca62d9ee4126507e4fc262b5e8650c');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('14','2','Cañete','Gustavo','','c581903a680849231f01cddc5eccbf41118949e9');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('15','2','Consoli','Enrique','','f61d323ef96d08db14b4b94c6085b9374ff1c005');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('16','1','FERRARIS','VERONICA','pvferraris@gmail.com','30412510ae5eeac80929b2dd729d2f83df40e5db');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('17','1','SIBILLIA','PABLO','mrososa@hotmail.com','f4e6d9171f4c567237c369d664ffe1e6f31933aa');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('18','1','URCHIPIA','MIGUEL','jefaturauradegabinete@estebanecheverria.gob.ar','b62a014af4719432a48c7a4d23a30349b5d34251');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('19','2','ACUÑA','ABEL','','829b8c6e1ac506715d6bd1657b1ddb5c7afc494d');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('20','1','LAUTARO','LORENZO','agenciamedioambiente@gmail.com','65ea9b22bff685fa74958a405172d78363b11d71');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('21','1','FERRO','PAULA','desarrollosocial@estebanecheverria.gob.ar','726cadca2ec503cc850185d5cc1c84a581c693a1');


/* usuarios por sector*/ 
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('3','18');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('4','27');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('5','28');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('6','19');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('7','29');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('8','20');

INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('10','21');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('11','31');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('12','64');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('13','65');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('14','66');

INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('15','68');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('16','22');

INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('17','23');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('18','24');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('19','44');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('20','25');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('21','26');



/* vuelvo a crear a operador de prueba walter para que haya alguno */

INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('2','3','walterApellido','waltername','walter@walter.com','f18f9d8baa2fa0cb58562a87b426733853e0a4e9');

/* faltan los reclamos de 3 secretarias porq no tienen horarios y hay un par que les puse -1 porq no tenian hora*/

INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','4','con ruedas.','Auto Abandonado');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','4','micros/ remises.','habilitacion de tansporte ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('12','4','obstruccin de garage.','obstruccion vehicular ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('12','4','interseccion.','corte de calle');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','5','varios.','búsqueda de choferes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','5','seguridad.','consultas');


INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','7','consultas/ asesoramiento.','vehiculo municipalizado ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','7','motos / autos.','alta ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','7','motos / autos.','bajas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','7','automotor / motos.','libre deuda');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','7','consultas / asesoramiento. ','ingresos brutos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','7','CAP 1 vencimientos / pagos.','tributo municipal por la propiedad ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','7','cap IV/ V/ X tasas varias. ','tasas de seguridad e higiene ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','7','ordenanza vigente. ','ordenanza tributaria ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','7','consultas varias.','compras');


INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','casa de la cultura.','espacios culturales municipales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','centro cultural El Telegrafo.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','centro cultural El galpon de la Estacion.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','Puerta Historica.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','Museo historico La Campana.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','archivo historico municipal.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','colegios.','visitas guiadas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','entidades.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','pedidos.','murales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','restauracion.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','muralistas.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','prestamo de sonido/escenario/sillas.','eventos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','convocatoria de artistas.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','redes culturales.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','pintura/escultura/dibujo/fotografia.','exposiciones y presentaciones');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','libros.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','ensamble musical municipal.','cultura va a la escuela');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','cine.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','inscripciones.','escuela de  artes y oficios');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','certificados de estudio.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','postulacion docente.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('72','8','cursos.','');


INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','11','corte de pasto / mejoras.','cementerio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','12','fuera de horario.','venta de bebidas alcoholicas ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','12','general/ consultas.','habilitacion comercial ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','12','general/ consultas.','habilitacion industrial ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','12','industrias/ quintas.','ruidos molestos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','13','consultas generales.','licencias');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','14','tramite bien de familia.','escrituras');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','14','tramite. ','escritura social');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','14','tramite. ','regularizacion dominal');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('8','14','tramite. ','solicitud de vivienda ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','14','compras en el distrito.','defensa al consumidor');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','14','asesoramiento .','divorcio/ alimentos/ tenencia');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','15','','cultos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','15','','educacion ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','15','','entidad de bien publico ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','15','','eventos entidades');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','15','','eximicion impositiva entidades');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','15','','subsidios entidades');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','15','','personeria juridica entidades');


INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','ambulancia.','ambulancia');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','analisis de agua y alimentos / celiacos.','bromatologia');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','consultas/especialidades/turnos.','consultorios externos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','libretas sanitarias.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','epidemiologia/enfermedades con tratamiento.','epidemiologia');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','enfermeria.','escuela de enfermeria');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','fumigaciones/casas/comercios.','fumigaciones');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','hospitales.','hospital');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','unidades sanitarias.','');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','kinesiologia/aparatos/rehabilitaciones.','rehabilitaciones');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','clinicos/pediatria/espec/enf/entrega leche.','unidades sanitarias');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','vacunatorio/operativos/vacunas.','vacunacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','16','castraciones/vacunacion.','zoonosis');


INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','17','agua y cloacas.','agua');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','17','agua y colacas.','cloacas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','17','falata de suministro.','edesur');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','17','varios.','telefonica');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','17','','videocable');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','17','','otro');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('7','17','tapadas.','bocas de tormenta');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('7','17','via publica.','escombros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('30','17','tierra.','mejorado de calle');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('10','17','','zanjeo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('7','17','via publica / vereda.','ramas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('10','17','','pluviales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('7','17','','basural / otros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('30','17','reparacion /reposicion de mobiliario.','plazas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('-1','17','plazas.','corte de cesped/ mantenimiento ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('-1','17','bacheo.','bacheo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('-1','17','personalmente por mesa general de entradas.','pavimentacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('-1','17','calle asfaltada.','repavimentacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('7','17','quemada.','reparacion luminaria');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('7','17','fue retirada.','reposicion luminaria');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('7','17','farol doble.','columna luminaria');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('7','17','luminarias.','material/ poste  luminaria');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('7','17','quebrado.','cambio de poste luminaria');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('-1','17','cursos de agua.','hidraulica');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','17','consultas.','obras particulares');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','17','denuncias.','obras en infraccion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('48','17','zonificacion.','zonificacion ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('7','17','obstruccion. ','bocas de tormenta');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('30','17','tierra.','mejorado de calle');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('10','17','zanjeo.','zanjeo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('7','17','via publica.','ramas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('10','17','pluviales.','pluviales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`descripcion`,`titulo`)VALUES('7','17','varios.','otros');



/*  25/02/17 */

ALTER TABLE `dbcav`.`domicilio` 
CHANGE COLUMN `entrecalle1_id` `entrecalle1_id` INT(11) NULL DEFAULT NULL ,
CHANGE COLUMN `entrecalle2_id` `entrecalle2_id` INT(11) NULL DEFAULT NULL ;

CREATE TABLE `observaciones` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `userId` int(11) DEFAULT NULL,
  `body` varchar(320) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

ALTER TABLE `dbcav`.`observaciones` 
CHANGE COLUMN `body` `body` TEXT NULL DEFAULT NULL ;


ALTER TABLE `dbcav`.`reclamos` 
DROP COLUMN `observaciones`;

CREATE TABLE `dbcav`.`observacionesxreclamo` (
  `id_obs` INT(11) NOT NULL,
  `id_reclamo` INT(11) NOT NULL,
  PRIMARY KEY (`id_obs`, `id_reclamo`)) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
  
  
  ALTER TABLE `dbcav`.`observacionesxreclamo` 
ADD CONSTRAINT `id_obs`
  FOREIGN KEY (`id_obs`)
  REFERENCES `dbcav`.`observaciones` (`ID`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  

  ALTER TABLE `dbcav`.`observacionesxreclamo` 
ADD INDEX `id_obs_reclamo_idx` (`id_reclamo` ASC);
ALTER TABLE `dbcav`.`observacionesxreclamo` 
ADD CONSTRAINT `id_obs_reclamo`
  FOREIGN KEY (`id_reclamo`)
  REFERENCES `dbcav`.`reclamos` (`id_reclamo`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

  
  
  /*		21/03/2017	*/
  
  /*	crear la carpeta upload y sacarle el modo lectura		 file permissions to 777.	*/
  /*	modificar el archivo router			*/
	/*			*/
	
	
	/* lo de las imagenes quedo para despues */
/* 20/03/2017 */

ALTER TABLE `dbcav`.`reclamos` 
ADD COLUMN `fecha_visto` DATETIME NULL DEFAULT NULL AFTER `domicilio_restringido`;


/* creacion del funcion  */

USE `dbcav`;
DROP function IF EXISTS `dias_habiles_transcurridos`;

DELIMITER $$
USE `dbcav`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `dias_habiles_transcurridos`( fecha_inicio DATE, fecha_fin DATE) RETURNS int(11)
BEGIN
	RETURN (SELECT DATEDIFF( fecha_fin ,fecha_inicio  ) - COUNT(*) FROM dbcav.feriados where 
	fecha between fecha_inicio and fecha_fin);
END$$

DELIMITER ;


ALTER TABLE `dbcav`.`reclamos` 
ADD COLUMN `contactado_verificado` BIT(1) NULL DEFAULT NULL AFTER `fecha_visto`;

/*	Tabla para observaciones especiales del supervisor		*/

CREATE TABLE `dbcav`.`obs_esp_sup_x_reclamo` (
  `id_obs` INT(11) NOT NULL,
  `id_reclamo` INT(11) NOT NULL,
  PRIMARY KEY (`id_obs`, `id_reclamo`),
  INDEX `id_reclamos_obs_esp_idx` (`id_reclamo` ASC),
  CONSTRAINT `id_obs_esp`
    FOREIGN KEY (`id_obs`)
    REFERENCES `dbcav`.`observaciones` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_reclamos_obs_esp`
    FOREIGN KEY (`id_reclamo`)
    REFERENCES `dbcav`.`reclamos` (`id_reclamo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

/*	Tabla para verificacion de reclamos contacados por parte de la oficina		*/
CREATE TABLE `dbcav`.`llamadas_verificadoras` (
  `id` INT(11) NOT NULL,
  `id_reclamo_asociado` INT(11) NOT NULL,
  `fecha_llamada` DATETIME NOT NULL,
  `correctitud` BIT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `id_verificador_reclamo_idx` (`id_reclamo_asociado` ASC),
  CONSTRAINT `id_verificador_reclamo`
    FOREIGN KEY (`id_reclamo_asociado`)
    REFERENCES `dbcav`.`reclamos` (`id_reclamo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
	
ALTER TABLE `dbcav`.`llamadas_verificadoras` 
CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT ;	




/* borrar observaciones, reclamos, tipo de reclamo, secretarias, oficinas y vecinos y domicilio */ 


DELETE FROM `dbcav`.`observacionesxreclamo` WHERE `id_obs`='25' and`id_reclamo`='1';
DELETE FROM `dbcav`.`observacionesxreclamo` WHERE `id_obs`='26' and`id_reclamo`='1';
DELETE FROM `dbcav`.`observacionesxreclamo` WHERE `id_obs`='27' and`id_reclamo`='2';
DELETE FROM `dbcav`.`observacionesxreclamo` WHERE `id_obs`='28' and`id_reclamo`='7';
DELETE FROM `dbcav`.`observacionesxreclamo` WHERE `id_obs`='30' and`id_reclamo`='7';
DELETE FROM `dbcav`.`observacionesxreclamo` WHERE `id_obs`='29' and`id_reclamo`='9';

DELETE FROM `dbcav`.`observaciones` WHERE `ID`='25';
DELETE FROM `dbcav`.`observaciones` WHERE `ID`='26';
DELETE FROM `dbcav`.`observaciones` WHERE `ID`='27';
DELETE FROM `dbcav`.`observaciones` WHERE `ID`='28';
DELETE FROM `dbcav`.`observaciones` WHERE `ID`='29';
DELETE FROM `dbcav`.`observaciones` WHERE `ID`='30';

DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='1';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='2';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='3';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='4';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='5';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='6';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='7';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='8';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='9';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='10';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='11';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='12';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='13';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='14';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='15';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='16';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='17';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='18';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='19';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='20';
DELETE FROM `dbcav`.`reclamos` WHERE `id_reclamo`='21';


DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='3';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='6';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='8';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='10';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='22';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='16';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='17';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='18';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='20';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='21';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='4';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='5';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='7';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='11';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='19';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='12';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='13';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='14';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id_usuario`='15';


DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='27';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='28';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='29';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='30';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='31';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='32';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='33';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='34';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='35';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='36';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='37';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='38';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='39';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='40';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='41';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='42';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='43';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='44';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='45';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='46';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='47';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='48';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='49';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='50';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='51';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='52';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='53';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='54';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='55';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='56';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='57';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='58';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='59';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='60';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='61';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='62';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='63';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='64';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='65';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='66';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='67';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='68';

DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='18';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='19';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='20';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='21';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='22';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='23';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='24';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='25';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='26';

DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='2';


DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='6';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='7';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='8';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='9';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='10';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='11';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='12';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='13';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='14';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='15';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='16';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='17';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='18';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='19';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='20';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='21';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='22';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='23';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='24';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='25';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='26';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='27';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='28';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='29';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='30';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='31';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='32';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='33';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='34';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='35';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='36';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='37';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='38';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='39';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='40';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='41';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='42';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='43';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='44';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='45';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='46';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='47';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='48';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='49';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='50';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='51';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='52';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='53';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='54';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='55';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='56';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='57';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='58';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='59';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='60';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='61';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='62';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='63';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='64';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='65';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='66';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='67';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='68';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='69';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='70';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='71';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='72';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='73';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='74';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='75';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='76';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='77';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='78';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='79';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='80';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='81';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='82';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='83';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='84';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='85';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='86';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='87';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='88';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='89';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='90';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='91';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='92';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='93';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='94';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='95';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='96';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='97';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='98';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='99';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='100';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='101';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='102';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='103';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='104';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='105';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='106';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='107';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='108';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='109';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='110';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='111';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='112';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='113';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='114';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='115';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='116';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='117';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='118';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='119';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='120';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='121';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='122';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='123';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='124';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='125';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='126';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='127';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='128';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='129';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='130';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='131';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='132';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='133';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='134';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='135';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='136';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='137';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='138';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='139';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='140';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='141';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='142';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='143';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='144';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='145';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='146';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='147';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='148';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='149';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='150';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='151';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='152';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='153';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='154';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='155';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='156';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='157';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='158';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='159';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='160';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='161';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='162';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='163';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='164';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='165';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='166';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='167';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='168';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='169';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='170';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='171';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='172';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='173';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='174';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='175';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='176';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='177';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='178';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='179';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='180';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='181';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='182';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='183';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='184';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='185';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='186';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='187';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='188';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='189';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='190';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='191';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='192';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='193';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='194';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='195';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='196';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='197';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='198';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='199';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='200';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='201';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='202';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='203';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='204';
DELETE FROM `dbcav`.`tiporeclamo` WHERE `id_tipo_reclamo`='205';

DELETE FROM `dbcav`.`user` WHERE `id`='3';
DELETE FROM `dbcav`.`user` WHERE `id`='4';
DELETE FROM `dbcav`.`user` WHERE `id`='5';
DELETE FROM `dbcav`.`user` WHERE `id`='6';
DELETE FROM `dbcav`.`user` WHERE `id`='7';
DELETE FROM `dbcav`.`user` WHERE `id`='8';
DELETE FROM `dbcav`.`user` WHERE `id`='10';
DELETE FROM `dbcav`.`user` WHERE `id`='11';
DELETE FROM `dbcav`.`user` WHERE `id`='12';
DELETE FROM `dbcav`.`user` WHERE `id`='13';
DELETE FROM `dbcav`.`user` WHERE `id`='14';
DELETE FROM `dbcav`.`user` WHERE `id`='15';
DELETE FROM `dbcav`.`user` WHERE `id`='16';
DELETE FROM `dbcav`.`user` WHERE `id`='17';
DELETE FROM `dbcav`.`user` WHERE `id`='18';
DELETE FROM `dbcav`.`user` WHERE `id`='19';
DELETE FROM `dbcav`.`user` WHERE `id`='20';
DELETE FROM `dbcav`.`user` WHERE `id`='21';

DELETE FROM `dbcav`.`domiciliosxvecinos` WHERE `id_domiciliosxvecinos`='1';
DELETE FROM `dbcav`.`domiciliosxvecinos` WHERE `id_domiciliosxvecinos`='2';
DELETE FROM `dbcav`.`domiciliosxvecinos` WHERE `id_domiciliosxvecinos`='3';
DELETE FROM `dbcav`.`domiciliosxvecinos` WHERE `id_domiciliosxvecinos`='4';
DELETE FROM `dbcav`.`domiciliosxvecinos` WHERE `id_domiciliosxvecinos`='5';
DELETE FROM `dbcav`.`domiciliosxvecinos` WHERE `id_domiciliosxvecinos`='6';
DELETE FROM `dbcav`.`domiciliosxvecinos` WHERE `id_domiciliosxvecinos`='7';
DELETE FROM `dbcav`.`domiciliosxvecinos` WHERE `id_domiciliosxvecinos`='8';
DELETE FROM `dbcav`.`domiciliosxvecinos` WHERE `id_domiciliosxvecinos`='9';

DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='1';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='2';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='3';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='4';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='6';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='7';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='8';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='9';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='13';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='15';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='16';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='17';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='18';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='19';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='20';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='21';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='22';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='23';
DELETE FROM `dbcav`.`domicilio` WHERE `id_domicilio`='24';

DELETE FROM `dbcav`.`vecino` WHERE `id_vecino`='1';
DELETE FROM `dbcav`.`vecino` WHERE `id_vecino`='2';
DELETE FROM `dbcav`.`vecino` WHERE `id_vecino`='3';
DELETE FROM `dbcav`.`vecino` WHERE `id_vecino`='4';
DELETE FROM `dbcav`.`vecino` WHERE `id_vecino`='5';
DELETE FROM `dbcav`.`vecino` WHERE `id_vecino`='6';
DELETE FROM `dbcav`.`vecino` WHERE `id_vecino`='7';
DELETE FROM `dbcav`.`vecino` WHERE `id_vecino`='8';
DELETE FROM `dbcav`.`vecino` WHERE `id_vecino`='9';

/*   cambio de tabla de userxsector	*/

ALTER TABLE `dbcav`.`usuariosxsector` 
DROP FOREIGN KEY `id_integrante`;
ALTER TABLE `dbcav`.`usuariosxsector` 
CHANGE COLUMN `id_usuario` `id` INT(11) NOT NULL ;
ALTER TABLE `dbcav`.`usuariosxsector` 
ADD CONSTRAINT `id_integrante`
  FOREIGN KEY (`id`)
  REFERENCES `dbcav`.`user` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
ALTER TABLE `dbcav`.`usuariosxsector` 
DROP FOREIGN KEY `id_integrante`;
ALTER TABLE `dbcav`.`usuariosxsector` 
CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT ,
ADD COLUMN `id_usuario` INT(11) NOT NULL AFTER `id`;
ALTER TABLE `dbcav`.`usuariosxsector` 
ADD CONSTRAINT `id_integrante`
  FOREIGN KEY (`id`)
  REFERENCES `dbcav`.`user` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

  /*
  aca falla como loco lo unico que hice en realidad es agregarle el id auto incremental y mantener las foregn keys
  
  
ALTER TABLE `dbcav`.`usuariosxsector` 
DROP FOREIGN KEY `id_integrante`;
ALTER TABLE `dbcav`.`usuariosxsector` 
ADD INDEX `id_integrante_idx` (`id_usuario` ASC),
DROP PRIMARY KEY;
ALTER TABLE `dbcav`.`usuariosxsector` 
ADD CONSTRAINT `id_integrante`
  FOREIGN KEY (`id_usuario`)
  REFERENCES `dbcav`.`user` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  */

  ALTER TABLE `dbcav`.`usuariosxsector` 
ADD INDEX `id_integrante_idx` (`id_usuario` ASC);
ALTER TABLE `dbcav`.`usuariosxsector` 
ADD CONSTRAINT `id_integrante`
  FOREIGN KEY (`id_usuario`)
  REFERENCES `dbcav`.`user` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
/*	INSERTS de SECRETARIAS */

INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('1',null,'INTENDENCIA','INTENDENCIA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('2','1','O.PUBLICAS','SECRETARIA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('3','1','SEC SEGURIDAD','SECRETARIA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('4','1','SUB SECRETARIA','SECRETARIA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('5','1','SECRETARIA DE GOBIERNO','SECRETARIA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('6','1','SUB SEC- DESARROLLO SOSTENIBLE','SECRETARIA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('7','1','SECRETARIA DE D SOCIAL','SECRETARIA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('8','1','JEFATURA DE GABINETE','SECRETARIA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('9','1','SECRETARIA DE SALUD','SECRETARIA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('10','1','SECRETARIA DE HACIENDA','SECRETARIA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('11','1','SECRETARIA DE COORDINACION ','SECRETARIA','2017-04-07 12:45:34',null,null);

/*	INSERTS de OFICINAS */

INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('12','2','Infraestructura','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('13','2','Quatrovial','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('14','2','Ilubaires','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('15','2','Delegacion Monte Grande Sur','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('16','2','Luis Guillon','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('17','2','Jaguel Caning','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('18','2','Barrio Malvinas','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('19','2','9 de Abril','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('20','2','Obras Particulares','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('21','2','Espacios verdes','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('22','2','Servicios','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('23','3','Proteccin Ciudadana','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('24','4','Cultura ','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('25','4','Telegrafo','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('26','5','Cementerio ','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('27','4','Inspección General ','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('28','5','Direc Licencias','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('29','5','SUB SECRETARIA','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('30','5','LEGAL Y TECNICA','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('31','5','entidades ','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('32','6','Jefe de Inspecciones','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('33','6','Forestacion ','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('34','6','Jefe de Inspecciones','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('35','6','Director de Control Ambiental','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('36','6','D.SOSTENIBLE','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('37','6','Director de Control Ambiental','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('38','6','Jefe de Inspecciones','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('39','7','Adultos mayores','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('40','7','Casa del joven','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('41','7','Sede cai','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('42','7','Sede cic ','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('43','7','Cooperativas','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('44','7','Deportes','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('45','7','Discapacidad','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('46','7','Logistica','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('47','7','Microemprendimiento','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('48','7','Niñez, adolescencia y flia','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('49','7','Plan vida ','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('50','7','Envion','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('51','7','Servicio comunitario','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('52','7','Tiket nacion ','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('53','8','Defensa civil','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('54','8','Jefatura','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('55','9','Dirección Gestión de Pacientes','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('56','9','Direccion Ejecutiva Hospital Santamarina','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('57','9','Libretas Sanitarias','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('58','9','Bromatologia','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('59','9','Epidemiologia','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('60','9','Dir general de Atencion Primaria U Sanitarias','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('61','9','Escuela de Enfermeria','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('62','9','Coordinación Centro de Zoonosis Urbana','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('63','10','Alumbrado ','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('64','10','Automotor','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('65','10','Rentas','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('66','11','Direccion del cav','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('67','3','Secretaria','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('68','3','Transito ','OFICINA','2017-04-07 12:45:34',null,null);
INSERT INTO `dbcav`.`sectores`(`id_sector`,`id_padre`,`denominacion`,`tipo`,`fecha_creacion`,`fecha_cierre`,`fecha_modificacion`)VALUES('69','2','Arquitectura ','OFICINA','2017-04-07 12:45:34',null,null);

UPDATE `dbcav`.`sectores` SET `denominacion`='SUB SECRETARIA DE CULTURA' WHERE `id_sector`='4';



INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('30','2','Moreno','Hernan','consultasredcloacalee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('31','2','Serrano','Walter','depquatrovial@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('32','2','Griggione','Carlos','carlos.Griggione@ilubaires.com.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('33','2','Troncoso','Alberto','montegrandesurcav@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('34','2','Covella','Franco','guilloncav@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('35','2','Martone','Pablo','jaguelcav@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('36','2','Veregara','Carlos','malvinascav@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('37','2','Rodriguez','Jorge','9deabrilcav@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('38','2','Herrera','Andres','infraestructuracav@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('39','2','Javier','Bodega','hidraulicacav@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('40','2','Maidana','Andres','obrasparticularescav@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('41','2','Iriarte','Virginia','plazascav@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('42','2','Salvadeo','Emiliano','mantenimientoplazascav@gmai.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('43','2','Sosa','Ramon','serviciospublicoscav@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('44','2','Salerno','Carlos','seguridadee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('45','2','Leguizamon','Julio','transitomee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('46','2','Zarate','Alejandro','seguridadee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('47','2','Rodriguez','Parise','subsecretario.cultura@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('48','2','Godoy','Sabrina','visitasguiadasee@hotmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('49','2','Artencio','Elizabeth','eventos.cultura@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('51','2','Andrada','Mauricio','telegrafo.cultura@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('52','2','Elizabeth','Artencio','eventos.cultura@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('53','2','Battaglia','Viviana','direccionemaoee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('54','2','Gerra','Marcelo','mgerra@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('55','2','Garabaglia','Jose Luis','joseluisgaravaglia@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('56','2','Bonomo','Alejandro','dralejandrobonomo@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('57','2','Cañete','Gustavo','tierras_ee@hotmail.com ','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('58','2','Rosetti','Rosario','echeverriaomic@gmail.com ','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('59','2','Consoli','Enrique','direcciondeentidades@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('60','2','Campos','Hugo','agenciamedioambiente@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('61','2','Ibarra','Victoria','agenciamedioambiente@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('62','2','Pipito','Hernan','agenciamedioambiente@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('63','2','Lorenzo','Lautaro','agenciamedioambiente@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('64','2','Valentino','Emiliano','emilianovalentino@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('65','2','Pacheco','Florencia','pachecoflorencia@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('84','2','Concetti','Sebastian','Sebaconcetti@hotmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('66','2','privada','Desarrollo','desarrollosocial@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('83','2','Burgos','Andrea','aburgosfaller@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('67','2','Milagros','Chiessa','mechiessa@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('68','2','Acuña','Abel','estebanecheverriadefensacivil@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('69','2','Urchipia','Miguel','jefaturadegabinete@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('70','2','Amarilla','Veronica','amarrillaveronica@hotmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('71','2','Carabia','Marcela Maria','direccionsantamarina@yahoo.com.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('72','2','Nieto','Marcela','ssalud.ee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('73','2','Aguerregohen','Carolina','bromatologiaee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('74','2','barreto','celeste','bromatologiaee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('75','2','Martinez','Gricelda','epieecheverria@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('76','2','Leyes','Mirta','atencionprimariaee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('77','2','Gromatovich','Maria','escuelaenf.santamarina@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('78','2','Giordano','Jose','ssalud.ee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('79','2','Pisciotto','Mariel','alumbrado@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('80','2','Ulecias','Gabriel','gulecias@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('81','2','Crespo','Gricelda','gcrespo@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('82','4','Fredes','Constanza','cavee@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');

INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('85','1','Scbilia','Pablo','pscibilia@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('86','1','Bickham','Mirta','porevita@hotmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('87','1','Salerno','Carlos','seguridadee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('88','1','Zarate','Alejandro','seguridadee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('89','1','Rodriguez Parise','Leonardo','subsecretario.cultura@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('90','1','Artencio','Elizabeth','ssprivada.cultura@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('91','1','Ferraris','Veronica','pvferraris@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('92','1','Andrea','Andrea','ssalud.ee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('93','1','Suarez','Gaston','gsuarez@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('94','1','Garcia','Luciana','lgarcia@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('95','1','Bertino','Fabiana','fabianabertinoee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('96','1','Pedreyra','Veronica','fabianabertinoee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('97','1','Urchipia','Miguel Angel','jefaturadegabinete@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('98','1','Acuña','Abel','estebanecheverriadefensacivil@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('99','1','Ferro','Cecilia','desarrollosocial@estebanecheverria.gob.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('100','1','Del Gaudio','Claudia','candidelgaudio@yahoo.com.ar','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('101','1','Lorenzo','Lautaro','agenciamedioambiente@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');

INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('105','3','Canevalli','Daniela','dcanevalli@operador','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('106','3','Coronel','Nahuel','ncoronel@operador','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('107','3','Ledesma','Giuliana','gledesma@operador','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('108','3','Escurra','Yanet','yescurra@operador','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('109','3','Capra','Silvina','scapra@operador','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('110','3','Poletto','Ignacio','ipoletto@operador','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('111','3','Benavente','Guadalupe','gbenavente@operador','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('112','3','Carreras','Ainara','acarreras@operador','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('113','3','Pacheco','Ana Laura','apacheco@operador','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('114','3','González','Damián','dgonzalez@operador','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('115','3','Rojas','Analía','arojas@operador','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('116','3','Antonucci','Guido','gantonucci@operador','49b74c397ca892ae17b32f62b2e22af4070bdcd3');



INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('102','2','Moreno','Hernan','consultasredcloacalee@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');

INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('103','2','Sakihara','Norberto','luminariascav@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');
INSERT INTO `dbcav`.`user`(`id`,`perfil_level`,`apellido`,`nombre`,`email`,`password`)VALUES('104','2','Verri','Lucas','luminariascav@gmail.com','49b74c397ca892ae17b32f62b2e22af4070bdcd3');




INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('30','12');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('31','13');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('32','14');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('33','15');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('34','16');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('35','17');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('36','18');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('37','19');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('38','19');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('39','19');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('40','20');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('41','69');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('42','21');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('43','22');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('44','68');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('45','67');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('46','23');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('47','24');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('48','24');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('49','24');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('49','24');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('51','25');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('52','25');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('53','25');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('54','26');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('55','27');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('56','28');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('57','29');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('58','30');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('59','31');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('60','32');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('61','33');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('60','34');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('62','35');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('63','36');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('62','37');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('60','38');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('64','39');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('64','40');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('65','41');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('84','43');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('64','44');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('64','45');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('66','46');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('64','47');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('83','48');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('65','49');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('67','50');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('65','51');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('65','52');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('68','53');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('69','54');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('70','55');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('71','56');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('72','57');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('73','58');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('74','59');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('75','60');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('76','60');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('85','2');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('86','2');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('87','3');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('88','3');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('89','4');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('90','4');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('91','9');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('92','9');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('93','10');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('94','10');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('95','5');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('96','5');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('97','8');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('98','8');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('99','7');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('100','7');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('101','6');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('102','15');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('102','16');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('102','17');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('102','18');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('102','19');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('102','20');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('102','21');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('102','22');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('102','68');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('102','69');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('103','12');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('103','13');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('103','14');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('104','12');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('104','13');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('104','14');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('77','61');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('78','62');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('79','63');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('80','64');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('81','65');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('82','66');

INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('105','66');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('106','66');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('107','66');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('108','66');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('109','66');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('110','66');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('111','66');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('112','66');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('113','66');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('114','66');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('115','66');
INSERT INTO `dbcav`.`usuariosxsector`(`id_usuario`,`id_sector`)VALUES('116','66');



ALTER TABLE `dbcav`.`tiporeclamo` 
CHANGE COLUMN `titulo` `titulo` VARCHAR(100) NOT NULL ;


INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','30','Denuncia por conexinon clandestina - Aysa');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','30','Denuncia por nueva red de cloacas - Aysa');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','30','Denuncia por nueva red de agua - Aysa');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','30','Conexión clandestina - Aysa');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','30','Desborde de cloaca - Aysa');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','30','Falta de agua - Aysa');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','30','Perdida de agua en vereda  - Aysa');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','30','Perdida de agua en calzada  - Aysa');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','30','Solicitud de sercicio - Aysa');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','30','Solicitud de red de Agua - Aysa');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Brazo caido -luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Brazo por caer - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Colgante caido -luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Colgante por caer -luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Artefacto perita caido - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Artefacto perita por caer -luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Cables cortados - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Cables colgando - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Poste pedido de corrimiento - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Reposicion de columna - luminarias Zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Columna por care  - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Columna caida - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Poste por caer - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Poste sostenido por los cables - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Poste por caido  - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Brazo lampara apagada - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Colgante lampara apagada - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Lampara perdida  - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Brazo  encendida permanentemente  - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Colgante encendida permanentemente  - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Preita encendida permanentemente - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Brazo faltante - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Brazo roto - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Colgante roto - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Colgante faltante - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Lampara perita faltante - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Lamara perita rota - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Brazo prende y apaga - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Columna prende y apaga  - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','31','Perita prende y apaga - luminarias zona 1');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Brazo caido -luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Brazo por caer - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Colgante caido -luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Colgante por caer -luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Artefacto perita caido - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Artefacto perita por caer -luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Cables cortados - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Cables colgando - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Poste pedido de corrimiento - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Reposicion de columna - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Columna por care  - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Columna caida - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Poste por caer - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Poste sostenido por los cables - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Poste por caido  - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Brazo lampara apagada - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Colgante lampara apagada - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Lampara perdida  - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Brazo  encendida permanentemente  - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Colgante encendida permanentemente  - luminarias zona21');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Preita encendida permanentemente - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Brazo faltante - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Brazo roto - luminarias zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Colgante roto - luminarias Zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Colgante faltante - luminarias Zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Lampara perita faltante - luminarias Zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Lamara perita rota - luminarias Zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Brazo prende y apaga - luminarias Zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Columna prende y apaga  - luminarias Zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Perita prende y apaga - luminarias Zona 2');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Semaforo en desperfecto ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Columna semaforo quebrada ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Columna de semaforo inclinada');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','32','Otros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','33','Boca de tormenta tapada');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','33','Boca de tormenta rota ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','33','Mejorado de calle de tierra ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','33','Recoleccion de escombros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','33','Recoleccion de ramas ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','33','Pedido de colocacion caños pluviales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','33','Zanjeo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','33','Cambio de caños pluviales rotos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','33','Autos quemados');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','33','Otros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','34','Boca de tormenta tapada');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','34','Boca de tormenta rota ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','34','Mejorado de calle de tierra ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','34','Recoleccion de escombros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','34','Zanjeo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','34','Recoleccion de ramas ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','34','Pedido de colocacion caños pluviales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','34','Cambio de caños pluviales rotos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','34','Autos quemados');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','34','Otros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','35','Boca de tormenta tapada');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','35','Boca de tormenta rota ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','35','Mejorado de calle de tierra ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','35','Perfilado de calle tierra');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','35','Recoleccion de escombros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','35','Recoleccion de ramas ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','35','Zanjeo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','35','Pedido de colocacion caños pluviales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','35','Cambio de caños pluviales rotos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','35','Autos quemados');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','35','Otros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','36','Boca de tormenta tapada');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','36','Boca de tormenta rota ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','36','Mejorado de calle de tierra ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','36','Recoleccion de escombros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','36','Recoleccion de ramas ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','36','Zanjeo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','36','Pedido de colocacion caños pluviales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','36','Cambio de caños pluviales rotos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','36','Autos Quemados');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','36','Otros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','36','Boca de tormenta tapada');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','37','Boca de tormenta rota ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','37','Mejorado de calle de tierra ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','37','Recoleccion de escombros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','37','Recoleccion de ramas ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','37','Pedido de colocacion caños pluviales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','37','Zanjeo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','37','Cambio de caños pluviales rotos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','37','Autos quemados');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','37','Otros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Inconvenientes en obras nuevas - Edesur');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Cables caidos - Edesur');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Cables cortados - Edesur');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Corrimiento de poste - Edesur');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Falta de suministro  - Edesur');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Poste caido  - Edesur');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Poste quebrado  - Edesur');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Otros  - Edesur');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Inconvenientes en obras nuevas - Edesur');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Corrimiento de poste - Video cable ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Poste sostenido por cables - Video cable');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Poste inclinado - video cable');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Poste quebrado - video cable');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Otros - video cable');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Perdida en via publica - Metro gas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Inconvenientes en obras nuevas  - Metro gas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Otros  - Metro gas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Inconvenientes en obra nueva  - Telefonica');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Corrimiento de poste  - Telefonica');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Poste quebrado   - Telefonica');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Poste caido  - Telefonica');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Poste inclinado  - Telefonica');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Bacheo - Pavimento');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Reparacion de cordon - Pavimento');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Solicitud de construccion  - Pavimento');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Reparacion de juntas - Pavimento');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','38','Otros - pavimento');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','39','Escurrimiento en curso de agua - hidraulica');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','39','Escurrimiento de agua rectificacion de pendiente - hidraulica');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','39','Otros - Hidraulica');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','40','Construccion en infraccion ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','40','Construccion sin permiso ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','40','Obra sin cartel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','40','Construccion sin bandeja de proteccion ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','41','Arreglo de moviliario');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','41','Construccion ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','41','Diceño');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','42','Corte de cesped');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','43','Reparacion garitas de colectivo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','43','pedido de instalacion garitas de colectivo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','43','Otros garitas de colectivo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','44','Micros habilitacion de tansporte ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','45','Remis habilitacion de tansporte ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','45','Obstrucción vehicular de garage');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','45','Interseccion corte de Calles');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','45','Búsqueda de choferes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','46','Auto avandonado Con ruedas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','46','Seguridad consultas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','47','Casa de la cultura - solicitud de espacios culturales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','47','Centro cultural El Telegrafo - Solicitud de espacios culturales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','47','Centro cultural El galpon de la Estacion - Solicitud de espacios culturales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','47','Puerta Historica - Solicitud de espacios culturales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','47','Museo historico La Campana - Solicitud de espacios culturales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','47','Otros - Solicitud de espacios culturales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','47','Archivo Historico Municipal - Solicitud de espacios culturales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','48','Visitas guiadas - Colegios.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','48','Visitas guiadas -  Entidades.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','48','Pedidos de Visitas guiadas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','48','Visitas guiadas - Restauracion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','48','Visitas guiadas - Muralistas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','48','Otros - Visitas guiadas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','49','Prestamo de sonido - Eventos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','49','Escenario - Eventos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','49','Sillas  - Eventos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','49','Convocatoria de artistas  - Eventos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','49','Redes culturales  - Eventos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','49','Otros  - Eventos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','49','Murales Pedidos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','49','Restauracion de Murales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','49','Muralistas Murales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','51','Exposiciones y presentaciones - Pintura');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','51','Exposiciones y presentaciones de Escultura ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','51','Exposiciones y presentaciones de Dibujo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','51','Exposiciones y presentaciones de Fotografia');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','51','Exposiciones y presentaciones de Libros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','52','Ensamble musical municipal - Cultura va a la escuela');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','52','Cine - Cultura va a la escuela');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','53','Inscripciones');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','53','Certificados de estudio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','53','Postulacion docente');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','53','Cursos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','53','Otros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','54','Corte de pasto');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','54','Mejoras');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','54','Otros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','55','Fuera de horario ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','55','Menores de edad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','55','Tramites - Habilitacion comercial ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','55','Consultas - Habilitacion comercial ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','55','Tramites - Habilitacion Industrial ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','55','Consultas - Habilitacion Industrial');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','55','Industrias - Ruidos molestos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','55','Quintas Ruidos molestos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','56','Consultas - Licencias');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','56','Tramites - Licencias');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','57','Tramite bien de familia - Escrituras');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','57','Tramite - Escritura');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','57','Tramite - Regularización Dominial');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','57','Tramite - Solicitud de Vivienda');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','58','Defensa al Consumidor - Compras en el Distrito ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','58','Consultas Generales - Divorcio/ Alimentos/ Tenencia');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','59','Solo lo respectivo a subsidios - Cultos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','59','Solo lo respectivo a Subsidios - -Educación');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','59','Clubes - Entidad de bien publico ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','59','Eventos - Eventos Entidades');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','59','Eximicion  Impositiva Entidades');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','59','Entidades - Subsidios');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','59','personas - personeria juridica entidades');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','59','Otros - personeria juridica entidades');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','60','Provision de tanque agua potable.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','60','Adecuacion de cerco perimetral.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','60','Notificación al vecino por reparacion de Vereda');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','60','Construccion de vereda');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','60','Infracción Limpieza de Lote Baldio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','60','Arboles deteriorados.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','61','Poda programada.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','61','Despeje de luminaria.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','61','Infracción por quema de podas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','60','Quema');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','60','No se presto Recolección de residuos domiciliarios');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','62','Animal Muerto inferior a 30 kg');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','62','No paso el barrendero por la cuadra');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','62','Achique ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','62','Denuncia por Personal de la empresa que pide dadivas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','62','Denuncia por Propinas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','62','Otros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','62','Recoleccion de residuos margenes de arroyos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','63','Mantenimiento de arroyos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','63','Denuncias - industrias');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','62','Consultas - industrias');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','62','Ruidos molestos casas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','62','Ruidos molestos Establecimientos industriales ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','62','Ruidos molestos otros');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','60','Vuelco clandestino de efluentes (aguas servidas).');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','60','Vuelco clandestino de residuos.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','60','Transporte no autorizado de residuos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Convenio con geriatricos del distrito - Adultos mayores a 60 años');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Programa nacional de cuidados domiciliarios - Adultos mayores a 60 años');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Entrega de alimentos - Adultos mayores a 60 años');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Pensiones provisionales - Adultos mayores a 60 años');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Apoyo escolar.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Talleres de embarazo adolescente y crianza.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Plan fines.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','65','Sede CAI - Consultas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','65','Sede CIC - Consultas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','84','Plan Cooperativas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Inscripcion  Actividades - Deportes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Obesidad - Deportes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Capacidades diferentes - Deportes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Colonia de vacaciones - Deportes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Asesoramiento - Discapacidad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Inicio de Curatela - Discapacidad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Atencion psicologica - Discapacidad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Atencion psicopedagogica - Discapacidad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Pases de transporte de nacion y provincia - Discapacidad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Traslados a Hospitales - Discapacidad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Traslado a centros - Discapacidad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','66','Traslado de personas - Logistica');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Agricultura familiar y periurbana');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Capacitacion y produccion horticola');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Entrega de kit de semillas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','64','Microemprendimientos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','83','Asistencia violencia familiar');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','83','Asesoramiento legalderechos de niñez y ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','83','Adolescencia.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','83','Violencia de genero');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','65','Entrega de ajuares');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','65','Entrega de tarjetas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','67','Condiciones - Envión');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','67','Sedes - Envión');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','65','Pedidos de anteojos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','65','Pedido de Lentes de Contacto ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','65','Pedido de Silla de Ruedas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','65','Provision de alimentos ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','65','Provisión dev Pañales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','65','Provisión de Leche');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','65','Emergencias Habitacionales');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','65','Solicitud de arjeta para provisión de alimentos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','68','Poda de ramas de arboles en riesgo.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','68','Vallado de la zona por riesgoa caída de postes, ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','68','Bache peligroso');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','68','Rescate de animal autóctono');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','68','Inundación por lluvia o desbordes de arroyos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','68','Reposicion de banderas en plazas del distrito');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','68','Dependencias municipales, comisarias,etc');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','68','Tareas Conjuntas con bomberos voluntarios');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','68','Prevención por derrame o escape de sustancias peligrosas ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','68','Control de caudal de rios y arroyos.');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','69','Proteger y Promover los derechos humanos de personas que habitan en el Municpio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','69','Eventos - Veteranos de Guerra');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','69','Otros - Veteranos de Guerra');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','70','Pedido de Ambulancia');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','70','Demoras en la unidad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','70','Atencion medica');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','71','Atencion Medica ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','71','Otorgamiento de turno ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','71','Atencion Administrativa ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','71','Espera prolongada en la atencion de Guardia');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','71','Falta de Limpieza');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','71','Falta de insumos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','71','Seguridad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','71','Falta de Medicacion ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','71','Condiciones de infraestructura ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','71','Derivaciones');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','71','Mala comida ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','72','Mala atencion ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','72','Solicitusd de informacion ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','72','Mala Atencion ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','72','Solicitud de informacion ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','72','Reclamo en la atencion ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','72','Solicitud de Informacion ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','73','Intoxicacion Alimentaria  - Casa de comidas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','73','Intoxicacion Alimentaria  - fabrica de Comidas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','73','Denuncia a comercio por productos en mal estado');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','73','Informacion  -  anallisis de agua');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','74','Mala atencion - anallisis de agua');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','74','varicela - Enfermedad contagiosa en barrios');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','74','Meningitis - Enfermedad contagiosa en barrios');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','74','Hepatitis - Enfermedad contagiosa en barrios');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','74','Paperas - Enfermedad contagiosa en barrios');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','74','Dengue - Enfermedad contagiosa en barrios');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','74','Otros - Enfermedad contagiosa en barrios');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','74','Varicela - Brotes en escuelas/ jardines/ comedores/ clubes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Meningitis - Brotes en escuelas/ jardines/ comedores/ clubes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Hepatitis - Brotes en escuelas/ jardines/ comedores/ clubes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Paperas - Brotes en escuelas/ jardines/ comedores/ clubes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Dengue - Brotes en escuelas/ jardines/ comedores/ clubes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Otros - Brotes en escuelas/ jardines/ comedores/ clubes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Presencia de arañas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Presencia de Alacranes');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Presencia de Vinchucas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Presencia de murcielagos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Presencia de Mosquitos');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Solicitud de Fumigacion en domicilio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','solicitud de información Fumigacion en domicilio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Reclamo por  Fumigacion en  ambienta');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Solicitusd de Informacion  por Fumigacion en  ambiental');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','75','Pedido de Desratizacion ambiental');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria Nº 1 Gamarra');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 1  Gamarra');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 1 Gamarra');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 1 Gamarra');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria  Nº 1 Gamarra');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 1 Gamarra');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 1 Gamarra');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 1 Gamarra');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria Nº 2 La Morita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 2 La Morita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 2 La Morita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 2 La Morita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 2 La Morita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 2 La Morita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 2 La Morita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 2 La Morita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria 3 El Jaguel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 3 El Jaguel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 3 El Jaguel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº3 El Jaguel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 3 El Jaguel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 3 El Jaguel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 3 El Jaguel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 3 El Jaguel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 4 San Pedrito');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 4 San Pedrito');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 4 San Pedrito');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 4 San Pedrito');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 4 San Pedrito');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 4 San Pedrito');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 4 San Pedrito');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 4 San Pedrito');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 5 San Francisco');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 5 San Francisco');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 5 San Francisco');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 5 San Francisco');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 5 San Francisco');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 5 San Francisco');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 5 San Francisco');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 5 San Francisco');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 6 - 9 de Abril');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 6 - 9 de Abril');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 6 - 9 de Abril');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 6 - 9 de Abril');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 6 - 9 de Abril');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 6 - 9 de Abril');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 6 - 9 de Abril');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 6 - 9 de Abril');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 7 Las Flores');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 7 Las Flores');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 7 Las Flores');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 7 Las Flores');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 7 Las Flores');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 7 Las Flores');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 7 Las Flores');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 7 Las Flores');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 8 Santa Isabel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 8 Santa Isabel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 8 Santa Isabel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 8 Santa Isabel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 8 Santa Isabel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 8 Santa Isabel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 8 Santa Isabel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 8 Santa Isabel');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 9 San Ignacio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 9 San Ignacio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 9 San Ignacio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 9 San Ignacio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 9 San Ignacio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 9 San Ignacio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 9 San Ignacio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 9 San Ignacio');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 10 El Zaizar');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 10 El Zaizar');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 10 El Zaizar');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 10 El Zaizar');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 10 El Zaizar');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 10 El Zaizar');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 10 El Zaizar');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 10 El Zaizar');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 11 Parish Robertson');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 11 Parish Robertson');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 11 Parish Robertson');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 11 Parish Robertson');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 11 Parish Robertson');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 11 Parish Robertson');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 11 Parish Robertson');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 11 Parish Robertson');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 12 Gral. San Martín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 12 Gral. San Martín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 12 Gral. San Martín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 12 Gral. San Martín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 12 Gral. San Martín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 12 Gral. San Martín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 12 Gral. San Martín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 12 Gral. San Martín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 13 Santa Catalina');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 13 Santa Catalina');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 13 Santa Catalina');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 13 Santa Catalina');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 13 Santa Catalina');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 13 Santa Catalina');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 13 Santa Catalina');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 13 Santa Catalina');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 14 Montana');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 14 Montana');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 14 Montana');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 14 Montana');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 14 Montana');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 14 Montana');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 14 Montana');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 14 Montana');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 15 Santa Rita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 15 Santa Rita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 15 Santa Rita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 15 Santa Rita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 15 Santa Rita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 15 Santa Rita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 15 Santa Rita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 15 Santa Rita');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 16 Las Colinas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 16 Las Colinas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 16 Las Colinas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 16 Las Colinas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 16 Las Colinas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 16 Las Colinas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 16 Las Colinas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 16 Las Colinas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 17 Sagrado Corazón de María');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 17 Sagrado Corazón de María');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 17 Sagrado Corazón de María');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 17 Sagrado Corazón de María');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 17 Sagrado Corazón de María');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 17 Sagrado Corazón de María');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 17 Sagrado Corazón de María');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 17 Sagrado Corazón de María');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 18 San Sebastián');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 18 San Sebastián');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 18 San Sebastián');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 18 San Sebastián');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 18 San Sebastián');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 18 San Sebastián');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 18 San Sebastián');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 18 San Sebastián');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 19 El Fortín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 19 El Fortín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 19 El Fortín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 19 El Fortín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 19 El Fortín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 19 El Fortín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 19 El Fortín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 19 El Fortín');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Sanitaria  Nº 21 ');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  - Unidad Sanitaria Nº 20 Altos de Monte Grande');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Movil 21');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  -  Unidad Movil 21');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  -  Unidad Movil 21');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   -  Unidad Movil 21');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  -  Unidad Movil 21');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  -  Unidad Movil 21');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  -  Unidad Movil 21');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  -  Unidad Movil 21');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Unidad Movil 22');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  -  Unidad Movil 22');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  -  Unidad Movil 22');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   -  Unidad Movil 22');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  -  Unidad Movil 22');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  -  Unidad Movil 22');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  -  Unidad Movil 22');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  -  Unidad Movil 22');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion administrativa en - Otro');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion de enfermeria  -  Otro');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion medica  -  Otro');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turno   - Otro');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de turnos  -  Otro');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Falta de Remedios  -  Otro');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Limpieza  -  Otro');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada en la atencion  -  Otro');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Pedido de Informacion sobre vacunación');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Reclamo administrativa - Centro de rehabilitacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala atencion Medica - Centro de rehabilitacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Mala Atencion Kinesiologia - Centro de rehabilitacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Espera prolongada  - Centro de rehabilitacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Lista de espera - Centro de rehabilitacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Otorgamiento de turno  - Centro de rehabilitacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Pedido de informacion  - Centro de rehabilitacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Pileta sucia - Centro de rehabilitacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Reclamo sobre certificado de discapacidad - Centro de rehabilitacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','76','Informe de discapacidad  - Centro de rehabilitacion');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','77','Pedido de informacion - Escuela de Enfermeeria');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','77','Reclamo - Escuela de Enfermeeria');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Mala atencion Administrativa - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Atencion de enfermeria - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Atencion medica  - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Falta de Insumos - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Falta de Remedios - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Limpieza - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Espera prolongada en la atencion  - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Castraciones - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Pedido de vacunas - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Mala Atencion  - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Perros peligrosos en la via publica - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Mordedura de perros - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Mordedura de, gatos - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Mordedura de murcielagos - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Mordedura de ratas - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Caballos en la via publica - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','78','Turnos - Zonoosis');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','79','No llegan las boletas al contribuyente - Tributo Municipal Por La Propiedad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','79','Cambio de domicilio de envío de la boleta - Tributo Municipal Por La Propiedad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','79','Cambio de Titular/ Contribuyente - Tributo Municipal Por La Propiedad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','79','Exenciones - Tributo Municipal Por La Propiedad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','79','Verificación de pagos erróneos - Tributo Municipal Por La Propiedad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','79','Acreditacio de Pago no registrado - Tributo Municipal Por La Propiedad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','79','Pago duplicado - Tributo Municipal Por La Propiedad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','79','Otras consultas  - Tributo Municipal Por La Propiedad');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','No llegan las boletas al contribuyente - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','Cambio de domicilio de envío de la boleta  - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','Cambio de Titularidad de Automotores  - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','Cambio de titularidad de Motos  - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','Exenciones  - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','Altas  - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','Baja por cambio de radicación  - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','Robo  - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','Destruccion   - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','Desarme  - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','Hurto  - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','Libre Deuda  - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','80','Otras consultas   - patentes automotor y moto vehiculo');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','81','Altas - Tasa por inspeccion de seguridad  he higiene');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','81','Bajas - Tasa por inspeccion de seguridad  he higiene');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','81','Presentación Declaración Jurada Web - Tasa por inspeccion de seguridad  he higiene');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','81','Exenciones - Tasa por inspeccion de seguridad  he higiene');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','81','Otras consultas  - Tasa por inspeccion de seguridad  he higiene');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','82','Desarrollo Sostenible - Cav, Consultas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','82','Gobierno - Cav, Consultas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','82','Salud - Cav, Consultas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','82','Jefatura de Gabinete  - Cav, Consultas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','82','Hacienda  - Cav, Consultas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','82','Cultura - Cav, Consultas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','82','Desarrollo Social  - Cav, Consultas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','82','Obras Pública - Cav, Consultas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','82','Seguridad - Cav, Consultas');
INSERT INTO `dbcav`.`tiporeclamo`(`tiempo_respuesta_hs`,`id_responsable`,`titulo`)VALUES('48','82','Otros - Cav, Consultas');


/*    EN MONTEGRANDE */

UPDATE `dbcav`.`user` SET `apellido`='Rodriguez Parise' WHERE `id`='47';
UPDATE `dbcav`.`user` SET `apellido`='Rodriguez Parise' WHERE `id`='89';


UPDATE `dbcav`.`user` SET `email`='inspeccionambientalecheverria@gmail.com' WHERE `id`='60';
UPDATE `dbcav`.`user` SET `email`='hernanpipito@yahoo.com.ar' WHERE `id`='62';

UPDATE `dbcav`.`user` SET `email`='giordanodogos@hotmail.com' WHERE `id`='78';
UPDATE `dbcav`.`user` SET `email`='lorenzo_lautaro@estebanecheverria.gob.ar' WHERE `id`='63';

UPDATE `dbcav`.`user` SET `email`='bromatologiaee_carolina@estebanecheverria.gob.ar' WHERE `id`='73';
UPDATE `dbcav`.`user` SET `apellido`='Barreto', `nombre`='Celeste', `email`='bromatologiaee_celeste@estebanecheverria.gob.ar' WHERE `id`='74';
UPDATE `dbcav`.`user` SET `email`='seguridadee_salerno@estebanecheverria.gob.ar' WHERE `id`='44';
UPDATE `dbcav`.`user` SET `email`='seguridadee_zarate@estebanecheverria.gob.ar' WHERE `id`='46';

UPDATE `dbcav`.`tiporeclamo` SET `id_responsable`='49' WHERE `id_tipo_reclamo`='790';
UPDATE `dbcav`.`tiporeclamo` SET `id_responsable`='49' WHERE `id_tipo_reclamo`='791';

DELETE FROM `dbcav`.`user` WHERE `id`='52';



/*   cambios con respecto a mails repetidos entre coordinador y secretario */

UPDATE `dbcav`.`user` SET `email`='seguridad_coord@estebanecheverria.gob.ar' WHERE `id`='88';
UPDATE `dbcav`.`user` SET `email`='lautarolorenzo1973@hotmail.com' WHERE `id`='101';


UPDATE `dbcav`.`user` SET `email`='defensa_civil@estebanecheverria.gob.ar' WHERE `id`='68';
UPDATE `dbcav`.`user` SET `email`='lorenzo_lautaro@estebanecheverria.gob.ar' WHERE `id`='63';
UPDATE `dbcav`.`user` SET `email`='red_cloacal_ee@estebanecheverria.gob.ar' WHERE `id`='30';
UPDATE `dbcav`.`user` SET `email`='logistica_desarrollo@estebanecheverria.gob.ar' WHERE `id`='66';
UPDATE `dbcav`.`user` SET `email`='subsecretaria_cultura@estebanecheverria.gob.ar' WHERE `id`='47';
UPDATE `dbcav`.`user` SET `email`='urchipia_miguel@estebanecheverria.gob.ar' WHERE `id`='69';

INSERT INTO `dbcav`.`user`
(`id`, `perfil_level`, `apellido`, `nombre`, `email`,`password`) VALUES
('0','Lage','Carlos','clage@estebanecheverria.gob.ar','d00972f2c0796cd00ed2404e07230dcf220e438c');




/*	en produccion				*/

ALTER TABLE `dbcav`.`user` 
ADD COLUMN `sectores_multiples` BIT(1) NULL DEFAULT false AFTER `password`;


UPDATE `dbcav`.`user` SET `sectores_multiples`=b'1' WHERE `id`='102';
UPDATE `dbcav`.`user` SET `sectores_multiples`=b'1' WHERE `id`='103';
UPDATE `dbcav`.`user` SET `sectores_multiples`=b'1' WHERE `id`='104';

UPDATE `dbcav`.`user` SET `sectores_multiples`=b'1' WHERE `id`='60';




/* borre otras que estaban duplicadas  */ 

DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='21';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='23';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='36';


/*  BORRAR relacione malas */

DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='124';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='123';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='122';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='121';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='120';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='119';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='118';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='117';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='116';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='115';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='114';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='111';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='113';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='65';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='57';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='37';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='34';
DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='15';

DELETE FROM `dbcav`.`usuariosxsector` WHERE `id`='33';


DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='38';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='39';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='40';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='41';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='43';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='44';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='45';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='47';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='49';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='52';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='68';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='70';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='71';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='76';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='77';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='78';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='79';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='80';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='81';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='82';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='83';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='84';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='85';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='86';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='87';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='88';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='89';
DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='90';


DELETE FROM `dbcav`.`sectores` WHERE `id_sector`='34';

/* ----------------------------------------------------------------------------------------------------   */


INSERT INTO `dbcav`.`barrios`(`id_barrio`,`barrio`) VALUES (69,'LAS TALITAS');

UPDATE `dbcav`.`barrios` SET `barrio`='DESCONOCIDO' WHERE `id_barrio`='1';



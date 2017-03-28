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
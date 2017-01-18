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

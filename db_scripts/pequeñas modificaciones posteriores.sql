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


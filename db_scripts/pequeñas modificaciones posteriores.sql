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

/*		MARCA	*/
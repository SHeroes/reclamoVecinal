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

/*	lleno los finde semana 2017 */
CALL llenarFeriados('2017-01-01','2017-12-31');

/* 	
SET lc_time_names = 'es_ES';
SELECT year(fecha) as anio,  monthname(fecha) mes, dayname(fecha) dia, fecha FROM dbcav.feriados 
WHERE dayname(fecha) != 'Sabado' AND dayname(fecha) != 'Domingo' and year(fecha) >= year(current_date())
ORDER BY fecha ;
SET lc_time_names = 'en_US';
 */

/*		inserto solo dos feriados de prueba los de carnaval		*/
INSERT INTO feriados (fecha) VALUES ('2017-02-27');
INSERT INTO feriados (fecha) VALUES ('2017-02-28');


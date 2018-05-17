/*
id reclamo		40914
id vecino		11237
codigo rec 		0018600/2018



id domicilio 14166

id calle 215



Longitud: -58.4562500
Latitud: -34.8184400


calle numero, localidad, buenos aires

*/


ALTER TABLE `dbcav`.`domicilio` 
ADD COLUMN `id_loc` INT(11) NULL DEFAULT NULL AFTER `columna_luminaria`,
ADD COLUMN `lng` FLOAT NULL DEFAULT NULL AFTER `id_loc`,
ADD COLUMN `lat` FLOAT NULL DEFAULT NULL AFTER `lng`,
ADD INDEX `id_loc_dom_idx` (`id_loc` ASC);
ALTER TABLE `dbcav`.`domicilio` 
ADD CONSTRAINT `id_loc_dom`
  FOREIGN KEY (`id_loc`)
  REFERENCES `dbcav`.`localidades` (`id_localidad`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


INSERT INTO `dbcav`.`localidades` (`id_localidad`, `localidades`) VALUES ('6', 'Llavallol');
INSERT INTO `dbcav`.`localidades` (`id_localidad`, `localidades`) VALUES ('7', 'Ezeiza');
INSERT INTO `dbcav`.`localidades` (`id_localidad`, `localidades`) VALUES ('8', 'Esteban Echeverría');
INSERT INTO `dbcav`.`localidades` (`id_localidad`, `localidades`) VALUES ('9', 'Desconocida');
INSERT INTO `dbcav`.`localidades` (`id_localidad`, `localidades`) VALUES ('10', 'Otra');

UPDATE `dbcav`.`calles` SET `calle`='Alvear, Gral' WHERE `id_calle`='24';
UPDATE `dbcav`.`calles` SET `calle`='General Rondeau' WHERE `id_calle`='527';


ALTER TABLE `dbcav`.`domicilio` 
ADD COLUMN `id_loc_vec` INT(11) NULL DEFAULT NULL AFTER `id_loc`;
  
  
/*	
	HASTA ACA YA ESTA 
*/

ALTER TABLE `dbcav`.`domicilio` 
CHANGE COLUMN `lat` `lat` FLOAT NULL DEFAULT NULL AFTER `id_loc_vec`;


CREATE TABLE `dbcav`.`reclamos_edesur` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_reclamo_asociado` INT(11) NOT NULL,
  `ticket_edesur` VARCHAR(45) NOT NULL,
  `nro_cliente_edesur` VARCHAR(45) NOT NULL,
  `estado_servicio` BIT(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  INDEX `relacion_reclamos_idx` (`id_reclamo_asociado` ASC),
  CONSTRAINT `relacion_reclamos`
    FOREIGN KEY (`id_reclamo_asociado`)
    REFERENCES `dbcav`.`reclamos` (`id_reclamo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `dbcav`.`reclamos` 
DROP FOREIGN KEY `id_op_id_us`;
ALTER TABLE `dbcav`.`reclamos` 
CHANGE COLUMN `id_operador` `id_operador` INT(11) NULL DEFAULT NULL ;
ALTER TABLE `dbcav`.`reclamos` 
ADD CONSTRAINT `id_op_id_us`
  FOREIGN KEY (`id_operador`)
  REFERENCES `dbcav`.`user` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;	


  
  


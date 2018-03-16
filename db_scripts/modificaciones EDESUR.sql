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
  
  



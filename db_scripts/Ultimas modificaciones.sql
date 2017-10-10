use dbcav;

ALTER TABLE `dbcav`.`reclamos` 
ADD COLUMN `reitero` TINYINT NOT NULL DEFAULT 0 AFTER `contactado_verificado`;

/* ------------------------------------------------------------------------------- */
/* JUNIO 		2017		 */ 



CREATE TABLE `dbcav`.`upload_x_reclamo` (
  `id_upload_x_reclamo` INT(11) NOT NULL AUTO_INCREMENT,
  `id_reclamo` INT(11) NOT NULL,
  `file_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_upload_x_reclamo`),
  INDEX `upload_reclamo_idx` (`id_reclamo` ASC),
  CONSTRAINT `upload_reclamo`
    FOREIGN KEY (`id_reclamo`)
    REFERENCES `dbcav`.`reclamos` (`id_reclamo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

		
ALTER TABLE `dbcav`.`reclamos` 
ADD COLUMN `flag_imagenes` BIT(1) NULL DEFAULT b'0' AFTER `reitero`;


ALTER TABLE `dbcav`.`upload_x_reclamo` 
CHANGE COLUMN `file_name` `file_name` TEXT NOT NULL ;

/* 
AGOSTO 	2017
*/

ALTER TABLE `dbcav`.`reclamos` 
ADD COLUMN `redes_sociales` BIT(1) NOT NULL DEFAULT b'0' AFTER `fecha_visto`,
ADD COLUMN `reclamoscol` VARCHAR(45) NULL AFTER `flag_imagenes`;

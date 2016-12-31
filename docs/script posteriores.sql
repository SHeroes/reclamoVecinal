
USE `dbcav` ;

ALTER TABLE `dbcav`.`user` 
CHANGE COLUMN `mail` `email` TEXT NULL DEFAULT NULL ;

ALTER TABLE `dbcav`.`user` 
DROP COLUMN `loginuser`;


ALTER TABLE `dbcav`.`secretarias` 
DROP FOREIGN KEY `id_direcciones`;

ALTER TABLE `dbcav`.`direcciones` 
ADD COLUMN `id_secretaria` INT NULL AFTER `nombre`,
ADD INDEX `id_dir_sec_idx` (`id_secretaria` ASC);
ALTER TABLE `dbcav`.`direcciones` 
ADD CONSTRAINT `id_dir_sec`
  FOREIGN KEY (`id_secretaria`)
  REFERENCES `dbcav`.`secretarias` (`id_secretaria`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  
  /*	26/12	*/
  
  
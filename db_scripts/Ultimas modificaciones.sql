use dbcav;

ALTER TABLE `dbcav`.`reclamos` 
ADD COLUMN `reitero` TINYINT NOT NULL DEFAULT 0 AFTER `contactado_verificado`;


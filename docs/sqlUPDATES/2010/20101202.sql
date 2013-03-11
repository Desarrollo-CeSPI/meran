
ALTER TABLE `adq_recomendacion` DROP COLUMN `usr_socio_id` , ADD COLUMN `usr_socio_id` INT(11) NOT NULL  AFTER `adq_ref_tipo_recomendacion_id` , 
  ADD CONSTRAINT `fk_adq_recomendacion_adq_ref_tipo_recomendacion1`
  FOREIGN KEY (`adq_ref_tipo_recomendacion_id` )
  REFERENCES `adq_ref_tipo_recomendacion` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION, 
  ADD CONSTRAINT `fk_adq_recomendacion_usr_socio1`
  FOREIGN KEY (`usr_socio_id` )
  REFERENCES `usr_socio` (`id_socio` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
, ADD INDEX `fk_adq_recomendacion_adq_ref_tipo_recomendacion1` (`adq_ref_tipo_recomendacion_id` ASC) 
, ADD INDEX `fk_adq_recomendacion_usr_socio1` (`usr_socio_id` ASC) ;

ALTER TABLE `adq_recomendacion_detalle` CHANGE COLUMN `adq_recomendacion_id` `adq_recomendacion_id` INT(11) NOT NULL  AFTER `reserva_material` , 
  ADD CONSTRAINT `fk_adq_recomendacion_detalle_adq_recomendacion1`
  FOREIGN KEY (`adq_recomendacion_id` )
  REFERENCES `adq_recomendacion` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
, ADD INDEX `fk_adq_recomendacion_detalle_adq_recomendacion1` (`adq_recomendacion_id` ASC) ;


CREATE  TABLE IF NOT EXISTS `adq_ref_tipo_recomendacion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `tipo_recomendacion` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

ALTER TABLE `adq_recomendacion` DROP FOREIGN KEY `fk_adq_recomendacion_usr_socio1` ;

ALTER TABLE `adq_recomendacion` DROP COLUMN `usr_socio_id` , ADD COLUMN `usr_socio_id` INT(11) NOT NULL  AFTER `adq_ref_tipo_recomendacion_id` , 
  ADD CONSTRAINT `fk_adq_recomendacion_usr_socio1`
  FOREIGN KEY (`usr_socio_id` )
  REFERENCES `usr_socio` (`id_socio` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
, DROP INDEX `fk_adq_recomendacion_usr_socio1` 
, ADD INDEX `fk_adq_recomendacion_usr_socio1` (`usr_socio_id` ASC) ;


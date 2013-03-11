SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

ALTER TABLE `ref_adq_moneda` RENAME TO  `adq_ref_moneda` ;

ALTER TABLE `adq_proveedor` CHANGE COLUMN `nombre` `nombre` VARCHAR(255) NOT NULL  , CHANGE COLUMN `apellido` `apellido` VARCHAR(255) NOT NULL  , CHANGE COLUMN `nro_doc` `nro_doc` VARCHAR(21) NOT NULL  , CHANGE COLUMN `razon_social` `razon_social` VARCHAR(255) NOT NULL  , CHANGE COLUMN `domicilio` `domicilio` VARCHAR(255) NOT NULL  , CHANGE COLUMN `telefono` `telefono` VARCHAR(32) NOT NULL  , CHANGE COLUMN `fax` `fax` VARCHAR(32) NULL DEFAULT NULL  , CHANGE COLUMN `email` `email` VARCHAR(255) NULL DEFAULT NULL  , 
  ADD CONSTRAINT `fk_adq_proveedor_usr_ref_tipo_documento1`
  FOREIGN KEY (`usr_ref_tipo_documento_id` )
  REFERENCES `usr_ref_tipo_documento` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION, 
  ADD CONSTRAINT `fk_adq_proveedor_ref_localidad1`
  FOREIGN KEY (`ref_localidad_id` )
  REFERENCES `ref_localidad` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

CREATE  TABLE IF NOT EXISTS `adq_ref_proveedor_moneda` (
  `adq_ref_moneda_id` INT(11) NOT NULL ,
  `adq_proveedor_id` INT(11) NOT NULL ,
  PRIMARY KEY (`adq_ref_moneda_id`, `adq_proveedor_id`) ,
  INDEX `fk_adq_ref_moneda_has_adq_proveedor_adq_proveedor1` (`adq_proveedor_id` ASC) ,
  CONSTRAINT `fk_adq_ref_moneda_has_adq_proveedor_adq_ref_moneda1`
    FOREIGN KEY (`adq_ref_moneda_id` )
    REFERENCES `adq_ref_moneda` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_adq_ref_moneda_has_adq_proveedor_adq_proveedor1`
    FOREIGN KEY (`adq_proveedor_id` )
    REFERENCES `adq_proveedor` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = MyIsam;

alter table `adq_ref_proveedor_moneda` ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


alter table ref_localidad engine=MyIsam;
alter table ref_dpto_partido engine=MyIsam;
alter table ref_provincia engine=MyIsam;


ALTER TABLE `ref_provincia` CHANGE COLUMN `PAIS` `ref_pais_id` INT(11) NOT NULL ,  CHANGE COLUMN `PROVINCIA` `id` VARCHAR(11) NOT NULL DEFAULT '0'  , 
  ADD CONSTRAINT `fk_ref_provincia_ref_pais1`
  FOREIGN KEY (`ref_pais_id` )
  REFERENCES `meran`.`ref_pais` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
, DROP PRIMARY KEY 
, ADD PRIMARY KEY (`id`) 
, ADD INDEX `fk_ref_provincia_ref_pais1` (`ref_pais_id` ASC) ;

ALTER TABLE `ref_dpto_partido` CHANGE COLUMN `PROVINCIA` `ref_provincia_id` VARCHAR(11) NOT NULL  ,  CHANGE COLUMN `DPTO_PARTIDO` `id` VARCHAR(11) NOT NULL DEFAULT ''  , 
  ADD CONSTRAINT `fk_ref_dpto_partido_ref_provincia1`
  FOREIGN KEY (`ref_provincia_id` )
  REFERENCES `meran`.`ref_provincia` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
, DROP PRIMARY KEY 
, ADD PRIMARY KEY (`id`) 
, ADD INDEX `fk_ref_dpto_partido_ref_provincia1` (`ref_provincia_id` ASC) ;

ALTER TABLE `ref_localidad` CHANGE COLUMN `DPTO_PARTIDO` `ref_dpto_partido_id` VARCHAR(11) NOT NULL  , 
  ADD CONSTRAINT `fk_ref_localidad_ref_dpto_partido1`
  FOREIGN KEY (`ref_dpto_partido_id` )
  REFERENCES `meran`.`ref_dpto_partido` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
, ADD INDEX `fk_ref_localidad_ref_dpto_partido1` (`ref_dpto_partido_id` ASC) ;


alter table ref_localidad engine=InnoDB;
alter table ref_dpto_partido engine=InnoDB;
alter table ref_provincia engine=InnoDB;


-- -----------------------------------------------------
-- Table `adq_forma_envio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `adq_forma_envio` ;

CREATE  TABLE IF NOT EXISTS `adq_forma_envio` (
  `id` INT NOT NULL ,
  `nombre` VARCHAR(100) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `adq_proveedor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `adq_proveedor` ;

CREATE  TABLE IF NOT EXISTS `adq_proveedor` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `nombre` VARCHAR(255) NOT NULL ,
  `apellido` VARCHAR(255) NOT NULL ,
  `nro_doc` VARCHAR(21) NOT NULL ,
  `razon_social` VARCHAR(255) NOT NULL ,
  `cuit_cuil` INT(11) NOT NULL ,
  `domicilio` VARCHAR(255) NOT NULL ,
  `telefono` VARCHAR(32) NOT NULL ,
  `fax` VARCHAR(32) NULL DEFAULT NULL ,
  `email` VARCHAR(255) NULL DEFAULT NULL ,
  `activo` INT(1) NOT NULL ,
  `plazo_reclamo` INT(11) NULL DEFAULT NULL ,
  `usr_ref_tipo_documento_id` INT(11) NOT NULL ,
  `ref_localidad_id` INT(11) NOT NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_adq_proveedor_usr_ref_tipo_documento1`
    FOREIGN KEY (`usr_ref_tipo_documento_id` )
    REFERENCES `usr_ref_tipo_documento` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_adq_proveedor_ref_localidad1`
    FOREIGN KEY (`ref_localidad_id` )
    REFERENCES `ref_localidad` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = MyIsam;

CREATE INDEX `fk_adq_proveedor_usr_ref_tipo_documento1` ON `adq_proveedor` (`usr_ref_tipo_documento_id` ASC) ;

CREATE INDEX `fk_adq_proveedor_ref_localidad1` ON `adq_proveedor` (`ref_localidad_id` ASC) ;


-- -----------------------------------------------------
-- Table `adq_proveedor_forma_envio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `adq_proveedor_forma_envio` ;

CREATE  TABLE IF NOT EXISTS `adq_proveedor_forma_envio` (
  `adq_forma_envio_id` INT NOT NULL ,
  `adq_proveedor_id` INT(11) NOT NULL ,
  PRIMARY KEY (`adq_forma_envio_id`, `adq_proveedor_id`) ,
  CONSTRAINT `fk_adq_forma_envio_has_adq_proveedor_adq_forma_envio1`
    FOREIGN KEY (`adq_forma_envio_id` )
    REFERENCES `adq_forma_envio` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_adq_proveedor_forma_envio_adq_proveedor1`
    FOREIGN KEY (`adq_proveedor_id` )
    REFERENCES `adq_proveedor` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = MyIsam;

CREATE INDEX `fk_adq_proveedor_forma_envio_adq_proveedor1` ON `adq_proveedor_forma_envio` (`adq_proveedor_id` ASC) ;


alter table adq_proveedor engine=InnoDB;
alter table adq_proveedor_forma_envio engine=InnoDB;





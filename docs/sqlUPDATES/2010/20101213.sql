-- materiales

CREATE TABLE IF NOT EXISTS `adq_tipo_material` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`nombre` varchar(45) NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;



CREATE TABLE `adq_proveedor_tipo_material` (
    `proveedor_id` INT( 11 ) NOT NULL ,
    `tipo_material_id` INT( 11 ) NOT NULL ,
    PRIMARY KEY ( `proveedor_id`,`tipo_material_id` )
) ENGINE = InnoDB;


ALTER TABLE `adq_proveedor_tipo_material` 
    ADD CONSTRAINT `fk_adq_proveedor_adq_proveedor_tipo_material1`
    FOREIGN KEY (`proveedor_id` )
    REFERENCES `adq_proveedor` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION, 
    ADD CONSTRAINT `fk_adq_tipo_material_adq_proveedor_tipo_material1`
    FOREIGN KEY (`tipo_material_id` )
    REFERENCES `adq_tipo_material` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
    
    
-- envios

CREATE TABLE IF NOT EXISTS `adq_forma_envio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `adq_proveedor_forma_envio` (
  `adq_forma_envio_id` int(11) NOT NULL,
  `adq_proveedor_id` int(11) NOT NULL,
  PRIMARY KEY (`adq_forma_envio_id`,`adq_proveedor_id`),
) ENGINE=InnoDB;

ALTER TABLE `adq_proveedor_forma_envio`
  ADD CONSTRAINT `fk_adq_forma_envio_has_adq_proveedor_adq_forma_envio1` FOREIGN KEY (`adq_forma_envio_id`) REFERENCES `adq_forma_envio` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_adq_proveedor_forma_envio_adq_proveedor1` FOREIGN KEY (`adq_proveedor_id`) REFERENCES `adq_proveedor` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;




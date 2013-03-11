    DROP TABLE IF EXISTS circ_reserva ,circ_prestamo, circ_sancion;

    RENAME TABLE reserves TO circ_reserva;
    RENAME TABLE sanctions TO circ_sancion;
    RENAME TABLE issues TO circ_prestamo;

    ALTER TABLE `circ_reserva` CHANGE biblioitemnumber `id2` INT( 11 ) NOT NULL FIRST , CHANGE itemnumber `id3` INT( 11 ) NULL AFTER `id2` ;
    ALTER TABLE `circ_prestamo` CHANGE itemnumber `id3` INT( 11 ) NOT NULL FIRST ;


    ALTER TABLE circ_reserva CHANGE `reservenumber` `id_reserva` INT(11) NOT NULL AUTO_INCREMENT FIRST,
      CHANGE `reservedate` `fecha_reserva` VARCHAR(20) NOT NULL,
      CHANGE `constrainttype` `estado` CHAR(1) NULL DEFAULT NULL, 
      CHANGE `branchcode` `id_ui` VARCHAR(4) NULL DEFAULT NULL, 
      CHANGE `notificationdate` `fecha_notificacion` VARCHAR(20) NULL DEFAULT NULL, 
      CHANGE `reminderdate` `fecha_recordatorio` VARCHAR(20) NULL DEFAULT NULL;
    ALTER TABLE circ_reserva  ADD `nro_socio` VARCHAR( 16 ) NOT NULL DEFAULT '0' AFTER id_reserva ;
    ALTER TABLE circ_reserva  DROP `cancellationdate`,  DROP `reservenotes`,  DROP `priority`,  DROP `found`;
    ALTER TABLE `circ_reserva` DROP `cancellationdate`;
    ALTER TABLE `circ_reserva` DROP `reservenotes`;

    ALTER TABLE circ_prestamo 
      CHANGE `issuecode` `tipo_prestamo` CHAR( 2 ) NOT NULL DEFAULT 'DO',
      CHANGE `date_due` `fecha_prestamo` VARCHAR( 20 ) NULL DEFAULT NULL ,
      CHANGE `branchcode` `id_ui_origen` CHAR( 4 ) NULL DEFAULT NULL ,
      CHANGE `issuingbranch` `id_ui_prestamo` CHAR( 18 ) NULL DEFAULT NULL ,
      CHANGE `returndate` `fecha_devolucion` VARCHAR( 20 ) NULL DEFAULT NULL ,
      CHANGE `lastreneweddate` `fecha_ultima_renovacion` VARCHAR( 20 ) NULL DEFAULT NULL ,
      CHANGE `renewals` `renovaciones` TINYINT( 4 ) NULL DEFAULT NULL;
    ALTER TABLE circ_prestamo DROP `return`;
    ALTER TABLE `circ_prestamo` CHANGE id `id_prestamo` INT( 11 ) NOT NULL AUTO_INCREMENT FIRST ;
    ALTER TABLE `circ_prestamo` ADD `agregacion_temp` VARCHAR( 255 ) NULL ;
    ALTER TABLE circ_prestamo  ADD `nro_socio` VARCHAR( 16 ) NOT NULL DEFAULT '0'  AFTER `id_prestamo` ;

    ALTER TABLE `circ_sancion` CHANGE `sanctionnumber` `id_sancion` INT( 11 ) NOT NULL AUTO_INCREMENT ,
        CHANGE `sanctiontypecode` `tipo_sancion` INT( 11 ) NULL DEFAULT '0',
        CHANGE `reservenumber` `id_reserva` INT( 11 ) NULL DEFAULT NULL ,
        CHANGE `startdate` `fecha_comienzo` DATE NOT NULL DEFAULT '0000-00-00',
        CHANGE `enddate` `fecha_final` DATE NOT NULL DEFAULT '0000-00-00',
        CHANGE `delaydays` `dias_sancion` INT( 11 ) NULL DEFAULT '0',
        CHANGE `itemnumber` `id3` INT( 11 ) NULL DEFAULT NULL ;
    ALTER TABLE `circ_sancion`  ADD `nro_socio` VARCHAR( 16 ) NOT NULL DEFAULT '0'  AFTER id_reserva ;


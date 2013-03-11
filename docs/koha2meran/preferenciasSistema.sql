
-- Preferencias que no se utilizan más --
DELETE FROM `pref_preferencia_sistema` WHERE `variable` IN 
('acquisitions', 'authoritysep', 'autoBarcode', 'checkdigit', 'marc','marcflavour',
 'maxoutstanding', 'maxvirtualcopy','maxvirtualprint');

-- Modificaciones a la tabla --
ALTER TABLE `pref_preferencia_sistema` DROP PRIMARY KEY ;

ALTER TABLE `pref_preferencia_sistema` ADD `id` INT( 11 ) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;

ALTER TABLE `pref_preferencia_sistema` ADD `categoria` VARCHAR( 255 ) NOT NULL DEFAULT 'sistema';

-- Referencias de las variables que ya existen!!!!!!!!!!
UPDATE `pref_preferencia_sistema` SET `type`='text';

UPDATE `pref_preferencia_sistema` SET `options` = 'ui|nombre', `type` = 'referencia' WHERE `variable` = 'defaultbranch';

UPDATE `pref_preferencia_sistema` SET `options` = 'nivel_bibliografico|description', `type` = 'referencia' WHERE `variable` = 'defaultlevel';
UPDATE `pref_preferencia_sistema` SET `variable` = 'defaultNivelBibliografico' WHERE `variable` = 'defaultlevel';

UPDATE `pref_preferencia_sistema` SET `options` = 'soporte|description', `type` = 'referencia' WHERE `variable` = 'defaultsuport';

UPDATE `pref_preferencia_sistema` SET `type`='bool' WHERE `variable` IN 
('autoActivarPersona','opacSearchAnonymous','logSearchOPAC','logSearchINTRA','ldapenabled','keeppasswordalive',
'insecure','habilitar_irregulares','habilitar_https','EnabledMailSystem','circulation','circularDesdeDetalleUsuario',
'circularDesdeDetalleDelRegistro','CheckUpdateDataEnabled','autoMemberNum','opacUnavail','permite_cambio_password_desde_opac',
'print_renew', 'reminderMail', 'sanctions', 'selectHomeBranch', 'showHistoricReserves','showMenuItem_circ_devolucion_renovacion',
'showMenuItem_circ_prestamos', 'susp', 'UploadPictureFromOPAC', 'usercourse', 'viewDetail', 'operacion_fuera_horario');

UPDATE `pref_preferencia_sistema` SET value='0' WHERE `type` =  'bool' AND  value='no';

UPDATE `pref_preferencia_sistema` SET value='1' WHERE `type` =  'bool' AND  value='yes';

-- Nuevas preferencias (separadas para que no fallen todas)--
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'auto-nro_socio_from_dni', '1', 'Preferencia que configura el auto-generar de nro de socio. Si es 0, es el autogenerar *serial*, sino sera el documento.', NULL, 'bool', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'autoActivarPersona', '1', 'Activa por defecto un alta de una persona', NULL, 'bool', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'circularDesdeDetalleDelRegistro', '1', 'se permite (=1) circular desde el detalle del registro', NULL, 'bool', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'circularDesdeDetalleUsuario', '1', 'se permite (=1) circular desde el detalle del usuario', NULL, 'bool', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'defaultCategoriaSocio', 'ES', 'Categoria de Socio por defecto', 'tipo_socio|description', 'referencia', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'defaultDisponibilidad', '0', 'Disponibilidad por defecto', 'disponibilidad|nombre', 'referencia', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'defaultissuetype', 'DO', 'Es el tipo de préstamo por defecto de la biblioteca', 'tipo_prestamo|descripcion', 'referencia', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'defaultTipoDoc', 'DNI', 'Tipo de Documento de Usuario por defecto', 'tipo_documento_usr|descripcion', 'referencia', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'defaultTipoNivel3', 'LIB', 'Tipo de Documento por defecto', 'tipo_ejemplar|nombre', 'referencia', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'habilitar_https', '1', 'habilita https (=1) o no (=0)', NULL, 'bool', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'libreDeuda', '11111', 'variable que limita la impresion del documento de libre deuda', NULL, 'text', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'paginas', '10', 'Cantidad de paginas que va a  mostrar el paginador.', '', 'text', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'permite_cambio_password_desde_opac', '1', 'permite (=1) o no (=0) el cambio de password desde el OPAC', NULL, 'bool', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'puerto_para_https', '444', 'puerto para https', NULL, 'text', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'showMenuItem_circ_devolucion_renovacion', '1', 'Preferencia que configura si el menu item dado se muestra o no en el menu (1 sí ; 0 no).', NULL, 'bool', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'showMenuItem_circ_prestamos', '1', 'Preferencia que configura si el menu item dado se muestra o no en el menu (1 sí ; 0 no).', NULL, 'bool', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'split_by_levels', '1', 'Para mostrar en el OPAC el detalle dividido por niveles o no', NULL, NULL, 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'titulo_nombre_ui', 'Biblioteca - U.N.L.P.', '', NULL, 'text', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'z3950_ cant_resultados', '25', 'Cantidad de resultados por servidor en una busqueda z3950 MAX para devoler todos', NULL, 'text', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'longitud_barcode', '3', 'cantidad de caracteres que conforman el barcode', NULL, NULL, 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'limite_resultados_autocompletables', '20', 'limite de resultados a mostrar en los campos autocompletables', NULL, NULL, 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'perfil_opac', '1', 'Id del perfil de visualizacion para OPAC', NULL, NULL, 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'detalle_resumido', '1', 'Muestra el detalle desde el OPAC en forma resumida', NULL, NULL, 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'google_map', '', '', NULL, NULL, 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'tema_opac_test', 'test', 'Un tema para el OPAC', NULL, NULL, 'temas_opac');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'tema_opac_default', 'default', 'Un tema para el OPAC', NULL, NULL, 'temas_opac');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'tema_intra_test', 'test', 'Un tema para el INTRA', NULL, NULL, 'temas_intra');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'tema_intra_default', 'default', 'Un tema para el INTRA', NULL, NULL, 'temas_intra');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'tema_opac', 'default', 'El tema por defecto para OPAc', '', '', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'tema_intra', 'default', 'El tema por defecto para INTRANET', NULL, NULL, 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'port_mail', '587', 'puerto del servidor de mail', NULL, 'text', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'username_mail', 'kkohatesting@yahoo.com.ar', 'usuario de la cuenta de mail', NULL, 'text', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'password_mail', 'pato123', 'password de la cuenta de mail', NULL, 'text', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'smtp_server', 'smtp.live.com', 'Servidor SMTP', NULL, 'text', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'smtp_metodo', 'TLS', 'Método de encriptación usado por el servidor SMTP para la autenticación', NULL, 'text', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'indexado', '1', '=1 indica que el indice se encuentra actualizado, 0 caso contrario (NO TOCAR)', NULL , 'bool', 'sistema');
 INSERT INTO `pref_preferencia_sistema` (`variable`, `value`, `explanation`, `options`, `type`, `categoria`) VALUES
( 'operacion_fuera_horario', '0', 'Se permiten las operaciones de la INTRANET fuera de horario?', NULL , 'bool', 'sistema');

UPDATE pref_preferencia_sistema SET variable='defaultUI' where variable = 'defaultbranch';
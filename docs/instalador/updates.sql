USE reemplazarDATABASE;
#UPDATES PARA ACTUALIZACIONES DE SANDBOX

#agregar al actualizar el numero de version actual (0.9.3) y los updates.sql con un postFix que sea el numero de version

ALTER TABLE   circ_prestamo  ADD   fecha_vencimiento_reporte  VARCHAR( 20 ) NOT NULL;

# APARTIR DE ACA ES LA v0.9.3

INSERT INTO   pref_tabla_referencia  (
 id  ,
 nombre_tabla  ,
 alias_tabla  ,
 campo_busqueda  ,
 client_title 
)
VALUES (
NULL ,  'cat_ref_tipo_nivel3',  'tipo_ejemplar',  'nombre',  'Tipo de Documento'
);

ALTER TABLE   cat_estructura_catalogacion  CHANGE   itemtype    itemtype  VARCHAR( 8 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;

ALTER TABLE   usr_persona  CHANGE   foto    foto  VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL;


## 13/02/2013

UPDATE pref_preferencia_sistema 
SET value = '200'
WHERE (variable = 'limite_resultados_autocompletables');


## 22/02/2013

INSERT INTO   pref_preferencia_sistema  ( id ,  variable ,  value ,  explanation ,  options ,  type ,  categoria ,  label ,  explicacion_interna ,  revisado ) VALUES (NULL, 'origen_catalogacion', 'AgLpU', 'Origen de Catalogacion (Campo 40 a en exportación Isis MARC)', NULL, 'text', 'sistema', 'Origen de Catalogación', 'Origen de Catalogacion (Campo 40 a en exportación Isis MARC)', '0');

## 25/02/2013

UPDATE pref_preferencia_sistema SET explanation = 'Habilita/Deshabilita la búsqueda en servidores externos Meran. También permite que sistemas externos busquen sobre este MERAN.' WHERE variable = "external_search";


## 15/03/2013  - Nuevo codigo de ref_idioma paraa la exportación de ROBLE

--
-- Estructura de tabla para la tabla  ref_idioma 
--

DROP TABLE IF EXISTS  ref_idioma ;
CREATE TABLE IF NOT EXISTS  ref_idioma  (
   id  int(11) NOT NULL AUTO_INCREMENT,
   idLanguage  char(2) DEFAULT NULL,
   marc_code  varchar(3) DEFAULT NULL,
   description  varchar(30) DEFAULT NULL,
  PRIMARY KEY ( id ),
  UNIQUE KEY  marc_code  ( marc_code )
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=141 ;

--
-- Volcar la base de datos para la tabla  ref_idioma 
--

INSERT INTO  ref_idioma  ( id ,  idLanguage ,  marc_code ,  description ) VALUES
(1, 'ab', 'abk', 'Abkhaziano'),
(2, 'aa', 'aar', 'Afar'),
(3, 'af', 'afr', 'Afrikaans'),
(4, 'sq', 'alb', 'Albano'),
(5, 'de', 'ger', 'Alemán'),
(6, 'am', 'amh', 'Amárico'),
(7, 'en', 'eng', 'Inglés'),
(8, 'ar', 'ara', 'Árabe'),
(9, 'hy', 'arm', 'Armenio'),
(10, 'as', 'asm', 'Asamés'),
(11, 'ay', 'aym', 'Aymara'),
(12, 'az', 'aze', 'Azerí'),
(13, 'ba', 'bak', 'Bashkir'),
(14, 'eu', 'baq', 'Vasco'),
(15, 'be', 'bel', 'Bielorruso'),
(16, 'bn', 'ben', 'Bengalí'),
(17, 'dz', 'dzo', 'Bhutaní'),
(18, 'bi', 'bis', 'Bislama'),
(19, 'bh', 'bih', 'Bihari'),
(20, 'my', 'bur', 'Birmano'),
(21, 'br', 'bre', 'Bretón'),
(22, 'bg', 'bul', 'Búlgaro'),
(23, 'ks', 'kas', 'Cachemir'),
(24, 'ca', 'cat', 'Catalán'),
(25, 'zh', 'chi', 'Chino'),
(26, 'sn', 'sna', 'Shona'),
(27, 'si', 'sin', 'Singalés'),
(28, 'ko', 'kor', 'Coreano'),
(29, 'co', 'cos', 'Corso'),
(30, 'hr', 'hrv', 'Croata'),
(31, 'da', 'dan', 'Danés'),
(32, 'es', 'spa', 'Español'),
(33, 'eo', 'epo', 'Esperanto'),
(34, 'et', 'est', 'Estonio'),
(35, 'fo', 'fao', 'Feroés'),
(36, 'fj', 'fij', 'Fidji'),
(37, 'fi', 'fin', 'Finlandés'),
(38, 'fr', 'fre', 'Francés'),
(39, 'fy', 'fry', 'Frisón'),
(40, 'gd', 'gla', 'Gaélico'),
(41, 'gl', 'glg', 'Gallego'),
(42, 'cy', 'wel', 'Galés'),
(43, 'ka', 'geo', 'Georgiano'),
(44, 'gu', 'guj', 'Gujarati'),
(45, 'el', 'gre', 'Griego'),
(46, 'kl', 'kal', 'Groenlandés'),
(47, 'gn', 'grn', 'Guaraní'),
(48, 'ha', 'hau', 'Hausa'),
(49, 'he', 'heb', 'Hebreo'),
(50, 'hi', 'hin', 'Hindi'),
(51, 'hu', 'hun', 'Húngaro'),
(52, 'id', 'ind', 'Indonesio'),
(53, 'ia', 'ina', 'Interlingua'),
(54, 'ie', 'ile', 'Interlingue'),
(55, 'iu', 'iku', 'Inuktitut'),
(56, 'ik', 'ipk', 'Inupiak'),
(57, 'ga', 'gle', 'Irlandés'),
(58, 'is', 'ice', 'Islandés'),
(59, 'it', 'ita', 'Italiano'),
(60, 'ja', 'jpn', 'Japonés'),
(61, 'jw', NULL, 'Javanés'),
(62, 'kn', 'kan', 'Kannada'),
(63, 'kk', 'kaz', 'Kazaj'),
(64, 'km', 'khm', 'Camboyano'),
(65, 'rw', 'kin', 'Kinyarwanda'),
(66, 'ky', 'kir', 'Kirghiz'),
(67, 'rn', 'run', 'Kirundi'),
(68, 'ku', 'kur', 'Kurdo'),
(69, 'lo', 'lao', 'Laosiano'),
(70, 'la', 'lat', 'Latín'),
(71, 'lv', 'lav', 'Letón'),
(72, 'ln', 'lin', 'Lingala'),
(73, 'lt', 'lit', 'Lituano'),
(74, 'mk', 'mac', 'Macedonio'),
(75, 'ms', 'may', 'Malayo'),
(76, 'ml', 'mal', 'Malayalam'),
(77, 'mg', 'mlg', 'Malgache'),
(78, 'mt', 'mlt', 'Maltés'),
(79, 'mi', 'mao', 'Maori'),
(80, 'mr', 'mar', 'Marathi'),
(81, 'mo', NULL, 'Moldavo'),
(82, 'mn', 'mon', 'Mongol'),
(83, 'na', 'nau', 'Nauri'),
(84, 'nl', 'dut', 'Holandés'),
(85, 'ne', 'nep', 'Nepalí'),
(86, 'no', 'nor', 'Noruego'),
(87, 'oc', 'oci', 'Occitán'),
(88, 'or', 'ori', 'Oriya'),
(89, 'om', 'orm', 'Oromo'),
(90, 'ug', 'uig', 'Uigur'),
(91, 'wo', 'wol', 'Uolof'),
(92, 'ur', 'urd', 'Urdu'),
(93, 'uz', 'uzb', 'Uzbeko'),
(94, 'ps', 'pus', 'Pastún'),
(95, 'pa', 'pan', 'Panjabi'),
(96, 'fa', 'per', 'Farsi'),
(97, 'pl', 'pol', 'Polaco'),
(98, 'pt', 'por', 'Portugués'),
(99, 'qu', 'que', 'Quechua'),
(100, 'rm', 'roh', 'Reto-romance'),
(101, 'ro', 'rum', 'Rumano'),
(102, 'ru', 'rus', 'Ruso'),
(103, 'sm', 'smo', 'Samoano'),
(104, 'sg', 'sag', 'Sango'),
(105, 'sa', 'san', 'Sánscrito'),
(106, 'sc', 'srd', 'Sardo'),
(107, 'sr', 'srp', 'Serbio'),
(108, 'sh', NULL, 'Serbocroata'),
(109, 'tn', 'tsn', 'Setchwana'),
(110, 'sd', 'snd', 'Sindhi'),
(111, 'ss', 'ssw', 'Siswati'),
(112, 'sk', 'slo', 'Eslovaco'),
(113, 'sl', 'slv', 'Esloveno'),
(114, 'so', 'som', 'Somalí'),
(115, 'sw', 'swa', 'Swahili'),
(116, 'st', 'sot', 'Sesotho'),
(117, 'sv', 'swe', 'Sueco'),
(118, 'su', 'sun', 'Sundanés'),
(119, 'tg', 'tgk', 'Tayic'),
(120, 'tl', 'tgl', 'Tagalo'),
(121, 'ta', 'tam', 'Tamil'),
(122, 'tt', 'tat', 'Tatar'),
(123, 'cs', 'cze', 'Checo'),
(124, 'tw', 'twi', 'Twi'),
(125, 'te', 'tel', 'Telugu'),
(126, 'th', 'tha', 'Thai'),
(127, 'bo', 'tib', 'Tibetano'),
(128, 'ti', 'tir', 'Tigrinya'),
(129, 'to', 'ton', 'Tonga'),
(130, 'ts', 'tso', 'Tsonga'),
(131, 'tr', 'tur', 'Turco'),
(132, 'tk', 'tuk', 'Turcmeno'),
(133, 'uk', 'ukr', 'Ucraniano'),
(134, 'vi', 'vie', 'Vietnamita'),
(135, 'vo', 'vol', 'Volapuk'),
(136, 'xh', 'xho', 'Xhosa'),
(137, 'yi', 'yid', 'Yidish'),
(138, 'yo', 'yor', 'Yoruba'),
(139, 'za', 'zha', 'Zhuang'),
(140, 'zu', 'zul', 'Zulú');

INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('LIB','Libro',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('SOFT','Software',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('REV','Revista',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('TES','Tesis',1,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('ELE','Documento Electrónico',0,NULL,1,0);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('CDR','CD-ROM',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('SEW','Publicacion seriada (web)',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('SER','Publicacion seriada',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('CAT','Catálogo',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('ART','Artículo',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('LEG','Legislación',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('REF','Obra de referencia',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('WEB','Sitio web',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('VID','Video grabación',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('DCD','Documento de cátedra docente',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('FOT','Fotocopia',0,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('SEM','Seminarios',1,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('DCA','Documento de cátedra',1,NULL,1,1);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('ANA','Analítica',1,NULL,1,0);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('VAL','Documento para valoración',NULL,NULL,1,0);
INSERT IGNORE INTO  cat_ref_tipo_nivel3  (id_tipo_doc, nombre, notforloan, agregacion_temp, disponible, enable_nivel3) 
VALUES ('FOL','Folleto',NULL,NULL,1,0);


INSERT IGNORE INTO  usr_regularidad  ( id ,  usr_estado_id ,  usr_ref_categoria_id ,  condicion ) VALUES
(1, 1, 1, 1),
(2, 2, 1, 0),
(3, 3, 1, 0),
(4, 4, 1, 0),
(5, 8, 1, 1),
(6, 9, 1, 1),
(7, 1, 3, 1),
(8, 2, 3, 1),
(9, 3, 3, 1),
(10, 4, 3, 1),
(11, 8, 3, 1),
(12, 9, 3, 1),
(13, 1, 5, 1),
(14, 2, 5, 1),
(15, 3, 5, 1),
(16, 4, 5, 1),
(17, 8, 5, 1),
(18, 9, 5, 1),
(19, 10, 1, 0),
(20, 10, 3, 1),
(21, 10, 5, 1),
(22, 11, 1, 0),
(23, 11, 3, 1),
(24, 11, 5, 1),
(25, 1, 2, 0),
(26, 1, 4, 0),
(27, 1, 6, 1),
(28, 1, 7, 1),
(29, 1, 8, 1),
(30, 1, 9, 1),
(31, 2, 2, 0),
(32, 2, 4, 0),
(33, 2, 6, 0),
(34, 2, 7, 1),
(35, 2, 8, 1),
(36, 2, 9, 1),
(37, 3, 2, 0),
(38, 3, 4, 0),
(39, 3, 6, 0),
(40, 3, 7, 1),
(41, 3, 8, 0),
(42, 3, 9, 1),
(43, 4, 2, 0),
(44, 4, 4, 0),
(45, 4, 6, 0),
(46, 4, 7, 1),
(47, 4, 8, 0),
(48, 4, 9, 1),
(49, 5, 1, 0),
(50, 5, 2, 1),
(51, 5, 3, 1),
(52, 5, 4, 1),
(53, 5, 5, 1),
(54, 5, 6, 1),
(55, 5, 7, 1),
(56, 5, 8, 1),
(57, 5, 9, 1),
(58, 6, 1, 1),
(59, 6, 2, 1),
(60, 6, 3, 1),
(61, 6, 4, 1),
(62, 6, 5, 1),
(63, 6, 6, 1),
(64, 6, 7, 1),
(65, 6, 8, 1),
(66, 6, 9, 1),
(67, 7, 1, 0),
(68, 7, 2, 0),
(69, 7, 3, 1),
(70, 7, 4, 0),
(71, 7, 5, 1),
(72, 7, 6, 0),
(73, 7, 7, 1),
(74, 7, 8, 0),
(75, 7, 9, 1),
(76, 8, 2, 0),
(77, 8, 4, 0),
(78, 8, 6, 0),
(79, 8, 7, 1),
(80, 8, 8, 0),
(81, 8, 9, 1),
(82, 9, 2, 0),
(83, 9, 4, 0),
(84, 9, 6, 0),
(85, 9, 7, 1),
(86, 9, 8, 0),
(87, 9, 9, 1),
(88, 10, 1, 0),
(89, 10, 2, 0),
(90, 10, 3, 1),
(91, 10, 4, 0),
(92, 10, 5, 1),
(93, 10, 6, 0),
(94, 10, 7, 1),
(95, 10, 8, 0),
(96, 10, 9, 0),
(97, 11, 1, 0),
(98, 11, 2, 0),
(99, 11, 3, 1),
(100, 11, 4, 0),
(101, 11, 5, 1),
(102, 11, 6, 0),
(103, 11, 7, 1),
(104, 11, 8, 0),
(105, 11, 9, 1);

## 25/02/2014

ALTER TABLE   ref_nivel_bibliografico  CHANGE   description    description  VARCHAR( 255 );

## 11/04/2014

ALTER TABLE   cat_ref_tipo_nivel3  ADD   enable_from_new_register  INT( 1 ) NOT NULL DEFAULT  '1' AFTER   enable_nivel3 ;
UPDATE  pref_preferencia_sistema SET   categoria  =  'sistema' WHERE  variable = 'timeout';

## 24/04/2014

ALTER TABLE   usr_socio  CHANGE   cumple_requisito    cumple_requisito  VARCHAR( 255 ) NOT NULL;

## 12/05/2014
UPDATE usr_socio SET cumple_requisito = '0000000000:00:00' WHERE cumple_requisito = '0000-00-00' and nro_socio <> 'kohaadmin';

## 15/05/2014
update pref_preferencia_sistema set categoria="sistema" where variable ='titulo_nombre_ui' ;

## 20/05/2014

CREATE TABLE indice_sugerencia (
	id			INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
	keyword		VARCHAR(255) NOT NULL,
	trigrams	VARCHAR(255) NOT NULL,
	freq		INTEGER NOT NULL,
	UNIQUE(keyword)
);

INSERT INTO  pref_preferencia_sistema (id ,variable ,value ,explanation ,options ,type ,categoria ,label ,explicacion_interna ,revisado)
VALUES 
( NULL ,  'nombre_indice_sugerencia_sphinx',  'sugerencia',  'Indice de sugerencias de Sphinx a utilizar', NULL ,  'text',  'interna',  'Nombre Indice Sugerencia Sphinx', 'Indice de sugerencias de Sphinx a utilizar',  '0'),
( NULL ,  'distancia_sugerencia_sphinx',  '3',  'Distancia de Levenshtein (Distancia entre palabras) mínima que se acepta para dar una sugerencia.', NULL ,  'text',  'sistema', 'Distancia sugerencia sphinx',  'Distancia de Levenshtein (Distancia entre palabras) mínima que se acepta para dar una sugerencia.',  '0'),
( NULL , 'ocurrencia_sugerencia_sphinx', '10', 'Cantidad mínima de ocurrencias que debe tener una palabra para ingresar a la lista de sugerencias.', NULL, 'text', 'sistema', 'Ocurrencias Sugerencia Sphinx', 'Cantidad mínima de ocurrencias que debe tener una palabra para ingresar a la lista de sugerencias.', '0');


##28/05/014 ##

ALTER TABLE  circ_sancion ADD  motivo_sancion TEXT NOT NULL;

### 0.10.0 ###
## 02/06/2014 ## FIX NOT NULL!

ALTER TABLE  circ_sancion CHANGE  motivo_sancion  motivo_sancion TEXT NULL;

## 03/06/2014 ##
INSERT INTO pref_preferencia_sistema( id, variable, value, explanation, options, type , categoria, label, explicacion_interna, revisado ) 
VALUES (
NULL ,  'mostrar_barcode_en_etiqueta',  '0',  'Muestra el nrp. de inventario en el lomo de la etiqueta.', NULL ,  'bool',  'sistema',  'Mostrar nro. inventario en etiqueta', 'Muestra el nrp. de inventario en el lomo de la etiqueta.',  '0'
);

## 06/06/2014 ##
ALTER TABLE  rep_historial_sancion ADD  motivo_sancion TEXT  NULL;

## 09/06/2014 ##
ALTER TABLE  indice_busqueda ADD  promoted INT( 11 ) NOT NULL DEFAULT  '0';

## 10/06/2014 ##

INSERT INTO pref_preferencia_sistema (variable, value, explanation, options, type, categoria, label, explicacion_interna, revisado) VALUES
('user_data_validation_required_or_days', '0', 'Cantidad de días desde la última modificación de datos que se esperan para requerirle al usuario actualizar sus datos. El 0 deshabilita esta comprobación.', NULL, 'text', 'sistema', 'Actualización de datos censales', 'Actualización de datos censales', 0);


## 16/06/2014 ##

INSERT INTO pref_preferencia_sistema (variable, value, explanation, options, type, categoria, label, explicacion_interna, revisado) VALUES
('opac_only_state_available', '0', 'Evita visualizar registros desde el opac donde los ejemplares no están disponibles, cualquiera sea el motivo (baja, perdido,en procesos técnicos, etc.).', NULL, 'bool', 'sistema', 'Visualizar sólo registros disponibles en el OPAC', 'Evita visualizar registros desde el opac donde los ejemplares no están disponibles, cualquiera sea el motivo (baja, perdido,en procesos técnicos, etc.).', 0);

### 0.10.1 ###

## 24/06/2014 ##
INSERT INTO  pref_preferencia_sistema (variable, value, explanation, options, type, categoria, label, explicacion_interna, revisado)
VALUES ('piwik_code',  '',  'Código para loguear estadísticas web con Piwik', NULL ,  'texta',  'sistema',  'Código para Estadísticas (Piwik)', 'Código para loguear estadísticas web con Piwik',  '0');

INSERT INTO pref_preferencia_sistema (variable, value, explanation, options, type, categoria, label, explicacion_interna, revisado) VALUES
('user_data_validation_required_intra', '0', 'Permite o no la actualización de datos censales desde la Intranet.', NULL, 'bool', 'sistema', 'Actualización de datos censales desde la Intranet', 'Permite o no la actualización de datos censales desde la Intranet', 0);

INSERT INTO pref_preferencia_sistema (variable, value, explanation, options, type, categoria, label, explicacion_interna, revisado) VALUES
('user_data_validation_required_opac', '0', 'Permite o no la actualización de datos censales desde el Opac.', NULL, 'bool', 'sistema', 'Actualización de datos censales desde el Opac', 'Permite o no la actualización de datos censales desde el Opac', 0);

## 26/06/2014 ##
ALTER TABLE  pref_preferencia_sistema ADD UNIQUE (variable);

## 27/06/2014 ##

INSERT INTO pref_preferencia_sistema (variable, value, explanation, options, type, categoria, label, explicacion_interna, revisado) VALUES ('verificar_duplicidad_de_registros', '1', 'Verifica la duplicidad de los registros a partir del Título, Autor y Autores secundarios', NULL, 'bool', 'sistema', 'Verificar duplicidad de registros', 'Verifica la duplicidad de los registros a partir del Título, Autor y Autores secundarios', '1');

ALTER TABLE  cat_registro_marc_n3 ADD  created_by INT( 11 ) NOT NULL AFTER  created_at;

## 03/07/2014 ##
ALTER TABLE  usr_socio ADD  last_login_all TIMESTAMP NOT NULL AFTER  last_login;

## 14/07/2014 ##
# Historial de Circulacion, de paso se acomoda que esta lo viejo en ingles y lo nuevo en español

UPDATE rep_historial_circulacion SET tipo_operacion="DEVOLUCION" WHERE tipo_operacion="devolucion";
UPDATE rep_historial_circulacion SET tipo_operacion="PRESTAMO" WHERE tipo_operacion="prestamo";
UPDATE rep_historial_circulacion SET tipo_operacion="CANCELACION" WHERE tipo_operacion="cancelacion" OR tipo_operacion="cancel";
UPDATE rep_historial_circulacion SET tipo_operacion="RENOVACION" WHERE tipo_operacion="renovacion" OR tipo_operacion="renew";
UPDATE rep_historial_circulacion SET tipo_operacion="RESERVA" WHERE tipo_operacion="reserva" OR tipo_operacion="reserve";
UPDATE rep_historial_circulacion SET tipo_operacion="ESPERA" WHERE tipo_operacion="espera" OR tipo_operacion="queue";
UPDATE rep_historial_circulacion SET tipo_operacion="NOTIFICACION" WHERE tipo_operacion="notificacion" OR tipo_operacion="notification";
UPDATE rep_historial_circulacion SET tipo_operacion="NOTIFICACION CANCELACION" WHERE tipo_operacion="notification cancelation";

### 0.10.2 ###
# se rompieron los dumps por las tablas de usuarios anonimizados.
ALTER TABLE  usr_socio_anonymous  CHANGE   cumple_requisito    cumple_requisito  VARCHAR( 255 ) NOT NULL;
ALTER TABLE  usr_socio_anonymous ADD  last_login_all TIMESTAMP NOT NULL AFTER  last_login;
ALTER TABLE  usr_persona DROP id_categoria;

DROP TABLE IF EXISTS ref_colaborador;
CREATE TABLE IF NOT EXISTS ref_colaborador (
  id int(11) NOT NULL AUTO_INCREMENT,
  codigo varchar(10) DEFAULT NULL,
  descripcion text NOT NULL,
  abreviatura varchar(10) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=214 ;


INSERT INTO ref_colaborador (id, codigo, descripcion, abreviatura) VALUES
(1, 'acp', 'Art copyist', ''),
(2, 'act', 'Actor', 'act.'),
(3, 'adp', 'Adaptador (Música)', 'adp.'),
(4, 'aft', 'autor de epílogo, colofón', ''),
(5, 'anl', 'Analista', 'anl'),
(6, 'anm', 'Animador', 'anm'),
(7, 'ann', 'Anotador', 'ant'),
(8, 'ant', 'Control bibliográfico', 'cbo'),
(9, 'app', 'Solicitante', 'slc'),
(10, 'aqt', 'Autor de citas o resúmenes de texto', ''),
(11, 'arc', 'arquitecto', 'aqt'),
(12, 'ard', 'Director artístico', 'dar'),
(13, 'arr', 'Arreglista (Música)', 'arr.'),
(14, 'art', 'Artista', 'art'),
(15, 'asg', 'Cesionario / Apoderado', ''),
(16, 'asn', 'Nombre asociado', 'asoc.'),
(17, 'att', 'Nombre atribuido', 'atr'),
(18, 'auc', 'Subastador', 'sub.'),
(19, 'aud', 'Autor de diálogo', 'aud'),
(20, 'aui', 'Autor de la introducción', 'aui'),
(21, 'aus', 'Autor del guión / Guionista', 'aug'),
(22, 'aut', 'Autor', 'aut.'),
(23, 'bdd', 'Diseñador de encuadernación', ''),
(24, 'bjd', 'Diseñador de sobrecubierta', ''),
(25, 'bkd', 'Diseñador de libro', ''),
(26, 'bkp', 'Productor de libro', ''),
(27, 'bnd', 'Encuadernador', 'enc.'),
(28, 'bpd', 'Diseñador de exlibris', ''),
(29, 'bsl', 'Librero', 'lib'),
(30, 'ccp', 'Conceptor', ''),
(31, 'chr', 'Coreógrafo', ''),
(32, 'clb', 'Colaborador', 'col.'),
(33, 'cli', 'Cliente', ''),
(34, 'cll', 'Calígrafo', ''),
(35, 'clt', 'Collotyper', ''),
(36, 'cmm', 'Comentarista', ''),
(37, 'cmp', 'Compositor', 'com.'),
(38, 'cmt', 'Tipógrafo / Compositor', ''),
(39, 'cng', 'Cinematógrafo / Dir de fotografía', ''),
(40, 'cnd', 'Conductor', 'cond.'),
(41, 'cns', 'Censor / Crítico', ''),
(42, 'coe', 'Contendiente legal', ''),
(43, 'col', 'Coleccionista', ''),
(44, 'com', 'Compilador', 'comp.'),
(45, 'cos', 'Concursante / contendiente', ''),
(46, 'cot', 'contendiente demandante o recurrente', ''),
(47, 'cov', 'Diseñador de cubierta', ''),
(48, 'cpc', 'Demandante de Derechos de autor ', ''),
(49, 'cpe', 'Demandante legal', ''),
(50, 'cph', 'Titular (o propietario) de derecho de autor', ''),
(51, 'cpl', 'Querellante', ''),
(52, 'cpt', 'Demandante-recurrente', ''),
(53, 'cre', 'Creador', 'cre'),
(54, 'crp', 'Corresponsal', 'crp'),
(55, 'crr', 'Corrector', 'crr'),
(56, 'csl', 'Consultor', 'csl'),
(57, 'csp', 'Consultor a un proyecto', 'csp'),
(58, 'cst', 'Diseñador de vestuario', ''),
(59, 'ctb', 'Colaborador', 'col.'),
(60, 'cte', 'Contestee-appellee', ''),
(61, 'ctg', 'Cartógrafo', 'ctg'),
(62, 'ctr', 'Contratista', 'ctr'),
(63, 'cts', 'Contestee', ''),
(64, 'ctt', 'Contestee-appellant', ''),
(65, 'cur', 'Curador', 'cur'),
(66, 'cwt', 'Comentariasta de texto escrito', ''),
(67, 'dfd', 'Demandado', 'dmd'),
(68, 'dfe', 'Defensor-apelado', ''),
(69, 'dft', 'Defensor apelante', ''),
(70, 'dgg', 'Degree grantor', ''),
(71, 'dis', 'Disertante', 'dis.'),
(72, 'dln', 'Delineador', ''),
(73, 'dnc', 'Bailarín', ''),
(74, 'dnr', 'Donante', ''),
(75, 'dpc', 'Pintor', ''),
(76, 'dpt', 'Depositante', ''),
(77, 'drm', 'Dibujante', 'dib'),
(78, 'drt', 'Director', 'dir.'),
(79, 'dsr', 'Diseñador', 'dis.'),
(80, 'dst', 'Distribidor', 'dist.'),
(81, 'dtc', 'Donante de datos?', ''),
(82, 'dte', '(Aquel a quien se dedica)', ''),
(83, 'dtm', 'Gestor de datos', ''),
(84, 'dto', 'Dedicante', ''),
(85, 'dub', 'Autor incierto', ''),
(86, 'edt', 'Editor', 'ed.'),
(87, 'egr', 'Grabador', 'grab'),
(88, 'elg', 'Electricista', 'elec'),
(89, 'elt', '(el que hace electrotipos)', ''),
(90, 'eng', 'Ingeniero', 'ing'),
(91, 'etr', 'Acuafortista / Grabador de aguafuerte', ''),
(92, 'exp', 'Experto', 'exp'),
(93, 'fac', 'Facsimilist', ''),
(94, 'fld', 'Director (de campo?)', ''),
(95, 'flm', 'Editor de cine', 'edc.'),
(96, 'fmo', 'propietario', ''),
(97, 'fpy', 'First party', ''),
(98, 'fnd', 'Fundador', 'fnd'),
(99, 'frg', 'Falsificador', ''),
(100, 'gis', 'Especialista en información geográfica', ''),
(101, '-grt', 'Técnico gráfico', 'tgr.'),
(102, 'hnr', 'Homenajeado / Premiado', ''),
(103, 'hst', 'Anfitrión', ''),
(104, 'ill', 'Ilustrador', 'il.'),
(105, 'ilu', 'Iluminador', 'ilu.'),
(106, 'ins', 'Apuntador /el que escribe o apunta', 'ap.'),
(107, 'inv', 'Inventor / Creador', 'inv.'),
(108, 'itr', 'Instrumentalista', 'itr.'),
(109, 'ive', 'Entrevistado', ''),
(110, 'ivr', 'Entrevistador', ''),
(111, 'lbr', 'Laboratorio / Oficina / Taller', ''),
(112, 'lbt', 'Libretista', 'lbt.'),
(113, 'ldr', 'Director de laboratorio', 'dlab'),
(114, 'led', 'Leader=Conductor', ''),
(115, 'lee', 'Libelee-appellee', ''),
(116, 'lel', 'Libelee', ''),
(117, 'len', 'Prestador / Prestamista', ''),
(118, 'let', 'Libelee-appellant', ''),
(119, 'lgd', 'Diseñador de iluminación', ''),
(120, 'lie', 'Libelant-appellee', ''),
(121, 'lil', 'Demandante', ''),
(122, 'lit', 'Demandante apelante', ''),
(123, 'lsa', 'Paisajista', ''),
(124, 'lse', 'Concesionario', ''),
(125, 'lso', 'Licenciante', ''),
(126, 'ltg', 'Litógrafo', 'ltg.'),
(127, 'lyr', 'Lírico', 'lir'),
(128, 'mcp', 'Copista de música', 'cpm.'),
(129, 'mfr', 'Fabricante', ''),
(130, 'mdc', 'Metadata contact', ''),
(131, 'mod', 'Moderador', 'mod.'),
(132, 'mon', 'Instructor', 'ins.'),
(133, 'mrk', 'Editor de marcado', 'edm.'),
(134, 'msd', 'Director musical', 'dmu.'),
(135, 'mte', 'grabador /Tallador (de metal)', ''),
(136, 'mus', 'Músico', 'mus.'),
(137, 'nrt', 'Narrador', 'nrrd.'),
(138, 'opn', 'Adversario', ''),
(139, 'org', 'Autor / Iniciador', ''),
(140, 'orm', 'Organizador de la reunión', ''),
(141, 'oth', 'Otro', ''),
(142, 'own', 'Propietario', 'prop.'),
(143, 'pat', 'Patrocinador', ''),
(144, 'pbd', 'Director editorial', 'ded.'),
(145, 'pbl', 'Editor', 'ed.'),
(146, 'pdr', 'Director de proyecto', 'dirp.'),
(147, 'pfr', 'Corrector de pruebas', ''),
(148, 'pht', 'Fotógrafo', 'fot.'),
(149, 'plt', 'Platemaker', ''),
(150, 'pma', 'Agencia autorizada', ''),
(151, 'pmn', 'Gerente de producción', ''),
(152, 'pop', 'Impresor de placas', ''),
(153, 'ppm', 'Fabricante de papel', ''),
(154, 'ppt', 'Titiritero', 'tit.'),
(155, 'prc', 'Process contact', ''),
(156, 'prd', 'personal de producción', ''),
(157, 'prf', 'Intérprete/ ejecutante', 'int.'),
(158, 'prg', 'programador', 'prog.'),
(159, 'prm', 'Impresor', ''),
(160, 'pro', 'productor', 'prod.'),
(161, 'prt', 'Impresor', 'impr.'),
(162, 'pta', 'Patent applicant', ''),
(163, 'pte', 'Plaintiff -appellee', ''),
(164, 'ptf', 'demandante', ''),
(165, 'pth', 'titular de la patente', ''),
(166, 'ptt', 'Plaintiff-appellant', ''),
(167, 'rbr', '(persona q marca o ilumina en rojo)', ''),
(168, 'rce', 'Ingeniero de grabación', ''),
(169, 'rcp', 'Receptor/ beneficiario', 'rec.'),
(170, 'red', 'redactor', 'red.'),
(171, 'ren', 'representante', ''),
(172, 'res', 'investigador', ''),
(173, 'rev', 'crítico', 'cri.'),
(174, 'rps', 'repositorio / depósito', ''),
(175, 'rpt', 'reportero', 'rpt.'),
(176, 'rpy', 'responsable', ''),
(177, 'rse', 'Respondent-appellee', ''),
(178, 'rsg', 'Restager', ''),
(179, 'rsp', 'demandado', ''),
(180, 'rst', 'Respondent-appellant', ''),
(181, 'rth', 'Research team head', ''),
(182, 'rtm', 'Research team member', ''),
(183, 'sad', 'asesor científico', 'aci.'),
(184, 'sce', 'guionista', 'gui.'),
(185, 'scl', 'escultor', 'esc'),
(186, 'scr', 'escriba', 'escr'),
(187, 'sds', 'diseñador de sonido', 'dis.'),
(188, 'sec', 'secretario', 'sec.'),
(189, 'sgn', 'firmante', 'fir.'),
(190, 'sht', 'Supporting host', ''),
(191, 'sng', 'cantante', 'cnt.'),
(192, 'spk', 'orador', 'ord.'),
(193, 'spn', 'patrocinador', ''),
(194, 'spy', 'Second party', ''),
(195, 'srv', 'topógrafo', 'top.'),
(196, 'std', 'Set designer', ''),
(197, 'stl', 'cuentista/ narrador / escritor', 'narr.'),
(198, 'stm', 'director de escena', 'dire.'),
(199, 'stn', 'Standards body', ''),
(200, 'str', 'Stereotyper', ''),
(201, 'tcd', 'director técnico', 'dirt.'),
(202, 'tch', 'profesor /', 'prof.'),
(203, 'ths', 'asesor de tesis', 'ate.'),
(204, 'trc', 'transcriptor', 'trs.'),
(205, 'trl', 'traductor', 'tr.'),
(206, 'tyd', 'diseñador tipográfico / de tipos', ''),
(207, 'tyg', 'tipógrafo', 'tip.'),
(208, 'vdg', 'camarógrafo', 'cam.'),
(209, 'voc', 'vocalista', 'voc.'),
(210, 'wam', 'Writer of accompanying material', ''),
(211, 'wdc', 'talador???', ''),
(212, 'wde', 'grabador en madera??', ''),
(213, 'wit', 'testigo?', '');

### 0.10.3 ###
ALTER TABLE  usr_socio CHANGE  cumple_requisito  cumple_requisito VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT  '0000000000:00:00';

#Para acomodar categorías de pref_preferencia_sistema
UPDATE pref_preferencia_sistema SET categoria = 'interna' WHERE categoria LIKE 'interna%';
UPDATE pref_preferencia_sistema SET categoria = 'sistema' WHERE categoria LIKE 'sistema%';
UPDATE pref_preferencia_sistema SET categoria = 'circulacion' WHERE categoria LIKE 'circulacion%';

#OAI PMH

INSERT INTO pref_preferencia_sistema (variable, value, explanation, options, type, categoria, label, explicacion_interna, revisado) VALUES
('OAI-PMH', '0', 'OAI-PMH', NULL, 'bool', 'sistema', 'Servicio OAI-PMH', '1 = OAI-PMH server is enabled - 0 = OAI-PMH server is disabled', 0);

INSERT INTO pref_preferencia_sistema (variable, value, explanation, options, type, categoria, label, explicacion_interna, revisado) VALUES
('OAI-PMH:archiveID', 'meran_id', 'OAI-PMH:archiveID', NULL, 'text', 'sistema', 'OAI-PMH:archiveID', 'OAI-PMH:archiveID', 0);


INSERT INTO pref_preferencia_sistema (variable, value, explanation, options, type, categoria, label, explicacion_interna, revisado) VALUES
('OAI-PMH:MaxCount', '50', 'OAI-PMH:MaxCount', NULL, 'text', 'sistema', 'OAI-PMH:archiveID', 'OAI-PMH:archiveID', 0);


### Nueva traduccion de Colaboradores ###

DROP TABLE IF EXISTS ref_colaborador;
CREATE TABLE IF NOT EXISTS ref_colaborador (
  id int(11) NOT NULL AUTO_INCREMENT,
  codigo varchar(10) DEFAULT NULL,
  descripcion text NOT NULL,
  abreviatura varchar(10) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=131 ;

INSERT INTO ref_colaborador (id, codigo, descripcion, abreviatura) VALUES
(1, 'act', 'Actor', 'act.'),
(2, 'adp', 'Adaptador (Música)', 'adp.'),
(3, 'anl', 'Analista', 'anl.'),
(4, 'hst', 'Anfitrión', 'anf.'),
(5, 'anm', 'Animador', 'anm.'),
(6, 'ann', 'Anotador', 'ant.'),
(7, 'ins', 'Apuntador ', 'ap.'),
(8, 'arc', 'Arquitecto', 'aqt.'),
(9, 'arr', 'Arreglista (Música)', 'arr.'),
(10, 'art', 'Artista', 'art.'),
(11, 'sad', 'Asesor científico', 'aci.'),
(12, 'ths', 'Asesor de tesis', 'ate.'),
(13, 'aqt', 'Autor de citas o resúmenes de texto', 'acr.'),
(14, 'aud', 'Autor de diálogo', 'aud.'),
(15, 'aui', 'Autor de la introducción', 'aui.'),
(16, 'blr', 'Bailarín', 'blr.'),
(17, 'cll', 'Calígrafo', 'clg.'),
(18, 'cam', 'Camarógrafo', 'cam.'),
(19, 'cnt', 'Cantante', 'cnt.'),
(20, 'ctg', 'Cartógrafo', 'ctg.'),
(21, 'cng', 'Cinematógrafo ', 'cnm.'),
(22, 'cli', 'Cliente', 'cli.'),
(23, 'clb', 'Colaborador', 'col.'),
(24, 'col', 'Coleccionista', 'clcc.'),
(25, 'cmm', 'Comentarista', 'cmn.'),
(26, 'com', 'Compilador', 'comp.'),
(27, 'cmp', 'Compositor', 'cmp.'),
(28, 'cnd', 'Conductor', 'cnd.'),
(29, 'csl', 'Consultor', 'csl.'),
(30, 'csp', 'Consultor a un proyecto', 'csp.'),
(31, 'ctr', 'Contratista', 'ctr.'),
(32, 'ant', 'Control bibliográfico', 'cbo.'),
(33, 'mcp', 'Copista de música', 'cpm.'),
(34, 'chr', 'Coreógrafo', 'cor.'),
(35, 'crr', 'Corrector', 'crr.'),
(36, 'pfr', 'Corrector de pruebas', 'cpr.'),
(37, 'crp', 'Corresponsal', 'crp.'),
(38, 'cre', 'Creador', 'cre.'),
(39, 'rev', 'Crítico', 'crt.'),
(40, 'cur', 'Curador', 'cur.'),
(41, 'dto', 'Dedicante', 'ddc.'),
(42, 'dfd', 'Demandado', 'dmd.'),
(43, 'lil', 'Demandante', 'dmn.'),
(44, 'dpt', 'Depositante', 'dps.'),
(45, 'drm', 'Dibujante', 'dib.'),
(46, 'dsr', 'Director', 'dir.'),
(47, 'ard', 'Director artístico', 'dar.'),
(48, 'stm', 'Director de escena', 'dire.'),
(49, 'ldr', 'Director de laboratorio', 'dlab.'),
(50, 'pdr', 'Director de proyecto', 'dirp.'),
(51, 'pbd', 'Director editorial', 'ded.'),
(52, 'msd', 'Director musical', 'dmu.'),
(53, 'tcd', 'Director técnico', 'dirt.'),
(54, 'cov', 'Diseñador ', 'dsñ.'),
(55, 'sds', 'Diseñador de sonido', 'dñs.'),
(56, 'lgd', 'Diseñador de iluminación', 'dñi.'),
(57, 'cst', 'Diseñador de vestuario', 'dñv'),
(58, 'dis', 'Disertante', 'dis.'),
(59, 'dst', 'Distribuidor', 'dst.'),
(60, 'dnr', 'Donante', 'don.'),
(61, 'edt', 'Editor', 'ed.'),
(62, 'flm', 'Editor de cine', 'edc.'),
(63, 'mrk', 'Editor de marcado', 'edm.'),
(64, 'elg', 'Electricista', 'elc.'),
(65, 'bnd', 'Encuadernador', 'enc.'),
(66, 'ive', 'Entrevistado', 'eno.'),
(67, 'ivr', 'Entrevistador', 'enr.'),
(68, 'scr', 'Escriba', 'escr.'),
(69, 'scl', 'Escultor', 'esc.'),
(70, 'gis', 'Especialista en información geográfica', 'egr.'),
(71, 'exp', 'Experto', 'exp.'),
(72, 'mfr', 'Fabricante', 'fbr.'),
(73, 'ppm', 'Fabricante de papel', 'ftp.'),
(74, 'frg', 'Falsificador', 'fsf.'),
(75, 'sgn', 'Firmante', 'fir.'),
(76, 'pht', 'Fotógrafo', 'fot.'),
(77, 'fnd', 'Fundador', 'fnd.'),
(78, 'pmn', 'Gerente de producción', 'gpr.'),
(79, 'dtm', 'Gestor de datos', 'gdt.'),
(80, 'egr', 'Grabador', 'grb.'),
(81, 'mte', 'Tallador ', 'tll.'),
(82, 'sce', 'Guionista', 'gui.'),
(83, 'hnr', 'Homenajeado ', 'hmn.'),
(84, 'ilu', 'Iluminador', 'ilu.'),
(85, 'ill', 'Ilustrador', 'il.'),
(86, 'prt', 'Impresor', 'impr.'),
(87, 'pop', 'Impresor de placas', 'imp.'),
(88, 'eng', 'Ingeniero', 'ing.'),
(89, 'rce', 'Ingeniero de grabación', 'igr.'),
(90, 'mon', 'Instructor', 'ins.'),
(91, 'itr', 'Instrumentalista', 'itr.'),
(92, 'prf', 'Intérprete', 'int.'),
(93, 'inv', 'Inventor / Creador', 'inv.'),
(94, 'res', 'Investigador', 'inv.'),
(95, 'bsl', 'Librero', 'lib'),
(96, 'lbt', 'Libretista', 'lbt.'),
(97, 'lyr', 'Lírico', 'lir.'),
(98, 'ltg', 'Litógrafo', 'ltg.'),
(99, 'mod', 'Moderador', 'mod.'),
(100, 'mus', 'Músico', 'mus.'),
(101, 'nrt', 'Narrador', 'narr.'),
(102, 'asn', 'Nombre asociado', 'asoc.'),
(103, 'att', 'Nombre atribuido', 'atr.'),
(104, 'spk', 'Orador', 'ord.'),
(105, 'lsa', 'Paisajista', 'psj.'),
(106, 'pat', 'Patrocinador', 'ptc.'),
(107, 'prd', 'Personal de producción', 'ppr.'),
(108, 'dpc', 'Pintor', 'pnt.'),
(109, 'pro', 'Productor', 'prd.'),
(110, 'tch', 'Profesor ', 'prof.'),
(111, 'prg', 'Programador', 'prog.'),
(112, 'prl', 'Prologuista', 'prol.'),
(113, 'own', 'Propietario', 'prop.'),
(114, 'cpl', 'Querellante', 'qrll.'),
(115, 'rcp', 'Receptor', 'rec.'),
(116, 'red', 'Redactor', 'red.'),
(117, 'rpt', 'Reportero', 'rpt.'),
(118, 'ren', 'Representante', 'rep.'),
(119, 'rpy', 'Responsable', 'resp.'),
(120, 'rev', 'Revisor', 'rev.'),
(121, 'sec', 'Secretario', 'sec.'),
(122, 'app', 'Solicitante', 'slc.'),
(123, 'auc', 'Subastador', 'sub.'),
(124, 'grt', 'Técnico gráfico', 'tgr.'),
(125, 'cmt', 'Tipógrafo ', 'tpg.'),
(126, 'ppt', 'Titiritero', 'tit.'),
(127, 'srv', 'Topógrafo', 'top.'),
(128, 'trl', 'Traductor', 'tr.'),
(129, 'trc', 'Transcriptor', 'trs.'),
(130, 'voc', 'Vocalista', 'voc.');


### 0.10.4 ###
#Error codigo en colaborador
UPDATE ref_colaborador SET  codigo =  'cri' WHERE  ref_colaborador.id =39;


### 0.10.5 ###
DELETE FROM pref_preferencia_sistema WHERE variable ="KohaAdminEmailAddress";

UPDATE `cat_estructura_catalogacion`  SET fijo = 0 WHERE  `campo` LIKE  '910' AND  `subcampo` LIKE  'a' AND  `itemtype` LIKE  'CDR';

#Socios Duplicados
ALTER TABLE usr_socio ADD UNIQUE (id_persona);

UPDATE cat_ref_tipo_nivel3 SET enable_nivel3 = 0 WHERE 1; 

UPDATE cat_ref_tipo_nivel3 SET enable_nivel3 = 1 WHERE id_tipo_doc NOT IN ('ANA', 'ELE', 'SEW', 'WEB');

ALTER TABLE  `pref_unidad_informacion` ADD  `nombre_largo` VARCHAR( 255 ) NOT NULL AFTER  `nombre`;

UPDATE  `pref_unidad_informacion` SET nombre_largo =  nombre;
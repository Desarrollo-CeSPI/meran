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

## 02/06/2014 ## FIX NOT NULL!

ALTER TABLE  circ_sancion CHANGE  motivo_sancion  motivo_sancion TEXT NULL;
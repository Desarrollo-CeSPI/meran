-- Cosas que faltan en Exactas
ALTER TABLE `borrowers` ADD COLUMN `usercourse` date  DEFAULT NULL AFTER changepassword;
UPDATE biblioitems  SET itemtype = 'LIB' WHERE itemtype = 'MON' or itemtype = '';
UPDATE biblioitems  SET itemtype = 'TES' WHERE itemtype = 'tesi';


TRUNCATE TABLE itemtypes;
INSERT INTO `itemtypes` (`itemtype`, `description`, `notforloan`) VALUES
( 'LIB', 'Libro', 0),
( 'SOFT', 'Software', 0),
( 'REV', 'Revista', 0),
( 'TES', 'Tesis', 1),
( 'ELE', 'Documento Electrónico', 0),
( 'CDR', 'CD-ROM', 0),
( 'SEW', 'Publicacion seriada (web)', 0),
( 'SER', 'Publicacion seriada', 0),
( 'CAT', 'Catálogo', 0),
( 'ART', 'Artículo', 0),
( 'LEG', 'Legislación', 0),
( 'REF', 'Obra de referencia', 0),
( 'WEB', 'Sitio web', 0),
( 'VID', 'Video grabación', 0),
( 'DCD', 'Documento de cátedra docente', 0),
( 'FOT', 'Fotocopia', 0),
( 'SEM', 'Seminarios', 1),
( 'DCA', 'Documento de cátedra', 1),
( 'ANA', 'Analítica', 1),
( 'FOL', 'Folleto', 0),
( 'VAL', 'Documento para valoración', 0);

DROP TABLE IF EXISTS `cat_portada_registro`;
CREATE TABLE IF NOT EXISTS `cat_portada_registro` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `isbn` varchar(50) DEFAULT NULL,
  `small` varchar(500) DEFAULT NULL,
  `medium` varchar(500) DEFAULT NULL,
  `large` varchar(500) DEFAULT NULL,
  UNIQUE KEY `id_2` (`id`),
  UNIQUE KEY `isbn` (`isbn`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


DROP TABLE IF EXISTS `cat_control_seudonimo_autor`;
CREATE TABLE IF NOT EXISTS `cat_control_seudonimo_autor` (
  `id_autor` int(11) NOT NULL,
  `id_autor_seudonimo` int(11) NOT NULL,
  PRIMARY KEY (`id_autor`,`id_autor_seudonimo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcar la base de datos para la tabla `cat_control_seudonimo_autor`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_control_seudonimo_editorial`
--

DROP TABLE IF EXISTS `cat_control_seudonimo_editorial`;
CREATE TABLE IF NOT EXISTS `cat_control_seudonimo_editorial` (
  `id_editorial` int(11) NOT NULL,
  `id_editorial_seudonimo` int(11) NOT NULL,
  PRIMARY KEY (`id_editorial`,`id_editorial_seudonimo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcar la base de datos para la tabla `cat_control_seudonimo_editorial`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_control_seudonimo_tema`
--

DROP TABLE IF EXISTS `cat_control_seudonimo_tema`;
CREATE TABLE IF NOT EXISTS `cat_control_seudonimo_tema` (
  `id_tema` int(11) NOT NULL,
  `id_tema_seudonimo` int(11) NOT NULL,
  PRIMARY KEY (`id_tema`,`id_tema_seudonimo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcar la base de datos para la tabla `cat_control_seudonimo_tema`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_control_sinonimo_autor`
--

DROP TABLE IF EXISTS `cat_control_sinonimo_autor`;
CREATE TABLE IF NOT EXISTS `cat_control_sinonimo_autor` (
  `id` int(11) NOT NULL,
  `autor` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`autor`),
  KEY `autor` (`autor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_control_sinonimo_editorial`
--

DROP TABLE IF EXISTS `cat_control_sinonimo_editorial`;
CREATE TABLE IF NOT EXISTS `cat_control_sinonimo_editorial` (
  `id` int(11) NOT NULL,
  `editorial` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`editorial`),
  KEY `editorial` (`editorial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcar la base de datos para la tabla `cat_control_sinonimo_editorial`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_control_sinonimo_tema`
--

DROP TABLE IF EXISTS `cat_control_sinonimo_tema`;
CREATE TABLE IF NOT EXISTS `cat_control_sinonimo_tema` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tema` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`tema`),
  KEY `tema` (`tema`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Volcar la base de datos para la tabla `cat_control_sinonimo_tema`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_encabezado_campo_opac`
--

DROP TABLE IF EXISTS `cat_encabezado_campo_opac`;
CREATE TABLE IF NOT EXISTS `cat_encabezado_campo_opac` (
  `idencabezado` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  `orden` int(11) NOT NULL,
  `linea` tinyint(1) NOT NULL DEFAULT '0',
  `nivel` tinyint(1) NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idencabezado`),
  KEY `nombre` (`nombre`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Volcar la base de datos para la tabla `cat_encabezado_campo_opac`
--

INSERT INTO `cat_encabezado_campo_opac` (`idencabezado`, `nombre`, `orden`, `linea`, `nivel`, `visible`) VALUES
(1, 'Encabezado 1', -1, 0, 2, 1),
(2, 'Encabezado 3', 0, 0, 3, 1),
(3, 'Encabezado 2', 0, 0, 2, 1),
(4, 'Encabezado Nivel 1', 0, 0, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_encabezado_item_opac`
--

DROP TABLE IF EXISTS `cat_encabezado_item_opac`;
CREATE TABLE IF NOT EXISTS `cat_encabezado_item_opac` (
  `idencabezado` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(4) NOT NULL DEFAULT '',
  PRIMARY KEY (`idencabezado`,`itemtype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcar la base de datos para la tabla `cat_encabezado_item_opac`
--

INSERT INTO `cat_encabezado_item_opac` (`idencabezado`, `itemtype`) VALUES
(1, 'ACT'),
(1, 'LIB'),
(2, 'ACT'),
(2, 'LIB'),
(3, 'LIB'),
(4, 'LIB');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cat_estructura_catalogacion`
--

DROP TABLE IF EXISTS `cat_estructura_catalogacion`;
CREATE TABLE IF NOT EXISTS `cat_estructura_catalogacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campo` char(3) DEFAULT NULL,
  `subcampo` char(1) DEFAULT NULL,
  `itemtype` varchar(4) DEFAULT NULL,
  `liblibrarian` varchar(255) DEFAULT NULL,
  `tipo` varchar(255) DEFAULT NULL,
  `referencia` tinyint(1) NOT NULL DEFAULT '0',
  `nivel` tinyint(1) NOT NULL,
  `obligatorio` tinyint(1) NOT NULL DEFAULT '0',
  `intranet_habilitado` int(11) DEFAULT '0',
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  `edicion_grupal` tinyint(4) NOT NULL DEFAULT '1',
  `idinforef` int(11) DEFAULT NULL,
  `idCompCliente` varchar(255) DEFAULT NULL,
  `fijo` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'modificable = 0, No \r\nmodificable = 1',
  `repetible` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'repetible = 1 \r\n(es petible)',
  `rules` varchar(255) DEFAULT NULL,
  `grupo` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `campo` (`campo`),
  KEY `subcampo` (`subcampo`),
  KEY `itemtype` (`itemtype`),
  KEY `indiceTodos` (`campo`,`subcampo`,`itemtype`),
  KEY `idinforef` (`idinforef`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=150 ;


--
-- Estructura de tabla para la tabla `cat_estructura_catalogacion_opac`
--

DROP TABLE IF EXISTS `cat_estructura_catalogacion_opac`;
CREATE TABLE IF NOT EXISTS `cat_estructura_catalogacion_opac` (
  `idestcatopac` int(11) NOT NULL AUTO_INCREMENT,
  `campo` char(3) DEFAULT NULL,
  `subcampo` char(1) DEFAULT NULL,
  `textpred` varchar(255) DEFAULT NULL,
  `textsucc` varchar(255) DEFAULT NULL,
  `separador` varchar(3) DEFAULT NULL,
  `idencabezado` int(11) NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idestcatopac`),
  KEY `campo` (`campo`,`subcampo`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=16 ;

--
-- Volcar la base de datos para la tabla `cat_estructura_catalogacion_opac`
--

INSERT INTO `cat_estructura_catalogacion_opac` (`idestcatopac`, `campo`, `subcampo`, `textpred`, `textsucc`, `separador`, `idencabezado`, `visible`) VALUES
(1, '245', 'a', 'Titulo', '*', ' ', 1, 1),
(2, '245', 'h', 'Medio nuevo', '---', '/', 1, 1),
(3, '995', 'c', 'Unid. Info.', '', '', 2, 1),
(4, '995', 'd', 'Unid. Info. Orig.', '', '', 2, 1),
(5, '995', 'e', 'Estado', '', '', 2, 1),
(6, '995', 'o', 'Disponibilidad', '', '', 2, 1),
(7, '995', 't', 'Sig. Top.', '', '', 2, 1),
(8, '020', 'a', 'ISBN:', '', '', 1, 1),
(9, '022', 'a', 'ISSN', '', '', 3, 1),
(10, '041', 'h', 'Cod. Idioma de la Version Orig.', '', '', 3, 1),
(11, '043', 'a', 'Codigo de Area Geografica', '', '', 3, 1),
(15, '020', 'a', 'asd', '', '', 3, 1);

--
-- Estructura de tabla para la tabla `cat_visualizacion_intra`
--

DROP TABLE IF EXISTS `cat_visualizacion_intra`;
CREATE TABLE IF NOT EXISTS `cat_visualizacion_intra` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campo` char(3) DEFAULT NULL,
  `subcampo` char(1) DEFAULT NULL,
  `vista_intra` varchar(255) DEFAULT NULL,
  `tipo_ejemplar` char(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `campo` (`campo`,`subcampo`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=26 ;

--
-- Estructura de tabla para la tabla `cat_visualizacion_opac`
--

DROP TABLE IF EXISTS `cat_visualizacion_opac`;
CREATE TABLE IF NOT EXISTS `cat_visualizacion_opac` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campo` char(3) DEFAULT NULL,
  `tipo_ejemplar` char(3) DEFAULT NULL,
  `pre` varchar(255) DEFAULT NULL,
  `inter` varchar(255) DEFAULT NULL,
  `post` varchar(255) DEFAULT NULL,
  `subcampo` char(1) DEFAULT NULL,
  `vista_opac` varchar(255) DEFAULT NULL,
  `vista_campo` varchar(255) DEFAULT NULL,
  `orden` int(11) NOT NULL,
  `orden_subcampo` int(11) NOT NULL,
  `nivel` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `campo_2` (`campo`,`tipo_ejemplar`,`subcampo`,`nivel`),
  UNIQUE KEY `campo_3` (`campo`,`subcampo`,`tipo_ejemplar`,`nivel`),
  KEY `campo` (`campo`,`subcampo`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=210 ;

--
-- Estructura de tabla para la tabla `pref_informacion_referencia`
--

DROP TABLE IF EXISTS `pref_informacion_referencia`;
CREATE TABLE IF NOT EXISTS `pref_informacion_referencia` (
  `idinforef` int(11) NOT NULL AUTO_INCREMENT,
  `idestcat` int(11) NOT NULL,
  `referencia` varchar(255) DEFAULT NULL,
  `orden` varchar(255) DEFAULT NULL,
  `campos` varchar(255) DEFAULT NULL,
  `separador` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`idinforef`),
  KEY `idestcat` (`idestcat`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=33 ;


--
-- Estructura de tabla para la tabla `pref_palabra_frecuente`
--

DROP TABLE IF EXISTS `pref_palabra_frecuente`;
CREATE TABLE IF NOT EXISTS `pref_palabra_frecuente` (
  `word` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcar la base de datos para la tabla `pref_palabra_frecuente`
--

INSERT INTO `pref_palabra_frecuente` (`word`) VALUES
('an'),
('A'),
('THE'),
('EL'),
('LOS'),
('LA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pref_servidor_z3950`
--

DROP TABLE IF EXISTS `pref_servidor_z3950`;
CREATE TABLE IF NOT EXISTS `pref_servidor_z3950` (
  `servidor` varchar(255) DEFAULT NULL,
  `puerto` int(11) DEFAULT NULL,
  `base` varchar(255) DEFAULT NULL,
  `usuario` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `nombre` text,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `sintaxis` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Volcar la base de datos para la tabla `pref_servidor_z3950`
--

INSERT INTO `pref_servidor_z3950` (`servidor`, `puerto`, `base`, `usuario`, `password`, `nombre`, `id`, `habilitado`, `sintaxis`) VALUES
('z3950.loc.gov', 7090, 'voyager', NULL, NULL, 'Library of Congress', 1, 1, 'UNIMARC');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pref_tabla_referencia`
--

DROP TABLE IF EXISTS `pref_tabla_referencia`;
CREATE TABLE IF NOT EXISTS `pref_tabla_referencia` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nombre_tabla` varchar(40) DEFAULT NULL,
  `alias_tabla` varchar(20) DEFAULT NULL,
  `campo_busqueda` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `campo_busqueda` (`campo_busqueda`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=19 ;



--
-- Estructura de tabla para la tabla `pref_tabla_referencia_conf`
--

DROP TABLE IF EXISTS `pref_tabla_referencia_conf`;
CREATE TABLE IF NOT EXISTS `pref_tabla_referencia_conf` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tabla` varchar(255) DEFAULT NULL,
  `campo` varchar(255) DEFAULT NULL,
  `campo_alias` varchar(255) DEFAULT NULL,
  `visible` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=30 ;



--
-- Estructura de tabla para la tabla `pref_tabla_referencia_info`
--

DROP TABLE IF EXISTS `pref_tabla_referencia_info`;
CREATE TABLE IF NOT EXISTS `pref_tabla_referencia_info` (
  `orden` varchar(20) DEFAULT NULL,
  `referencia` varchar(30) NOT NULL DEFAULT '',
  `similares` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`referencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Estructura de tabla para la tabla `pref_tabla_referencia_rel_catalogo`
--

DROP TABLE IF EXISTS `pref_tabla_referencia_rel_catalogo`;
CREATE TABLE IF NOT EXISTS `pref_tabla_referencia_rel_catalogo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alias_tabla` varchar(32) DEFAULT NULL,
  `tabla_referente` varchar(32) DEFAULT NULL,
  `campo_referente` varchar(32) DEFAULT NULL,
  `sub_campo_referente` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=18 ;

--
-- Estructura de tabla para la tabla `usr_estado`
--

DROP TABLE IF EXISTS `usr_estado`;
CREATE TABLE IF NOT EXISTS `usr_estado` (
  `id_estado` int(11) NOT NULL AUTO_INCREMENT,
  `categoria` char(2) DEFAULT NULL,
  `fuente` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_estado`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

--
-- Volcar la base de datos para la tabla `usr_estado`
--

INSERT INTO `usr_estado` (`id_estado`, `categoria`, `fuente`, `nombre`) VALUES
(1, NULL, 'GUARANI', 'ACTIVO REGULAR'),
(2, NULL, 'GUARANI', 'ACTIVO IRREGULAR'),
(3, NULL, 'GUARANI', 'INACTIVO REGULAR'),
(4, NULL, 'GUARANI', 'INACTIVO IRREGULAR'),
(5, NULL, 'MERAN', 'INDIFERENTE'),
(6, NULL, 'MERAN', 'HABILITADO'),
(7, NULL, 'MERAN', 'DESHABILITADO'),
(8, NULL, 'GUARANI', 'EGRESADO REGULAR'),
(9, NULL, 'GUARANI', 'EGRESADO IRREGULAR'),
(10, NULL, 'GUARANI', 'PASIVO REGULAR'),
(11, NULL, 'GUARANI', 'PASIVO IRREGULAR');



DROP TABLE IF EXISTS `cat_pref_mapeo_koha_marc`;

CREATE TABLE IF NOT EXISTS `cat_pref_mapeo_koha_marc` (
  `idmap` int(11) NOT NULL auto_increment,
  `tabla` varchar(100) NOT NULL,
  `campoTabla` varchar(100) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `campo` varchar(3) NOT NULL,
  `subcampo` varchar(1) NOT NULL,
  PRIMARY KEY  (`idmap`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT  INTO `cat_pref_mapeo_koha_marc` (`tabla`, `campoTabla`, `nombre`, `campo`, `subcampo`) VALUES
( 'colaboradores', 'idColaborador', 'Nombre Personal', '700', 'a'),
( 'additionalauthors', 'author', 'Nombre Personal', '700', 'a'),
( 'biblio', 'abstract', 'Nota de resumen, etc.', '520', 'a'),
( 'biblio', 'author', 'Nombre Personal', '100', 'a'),
( 'biblio', 'notes', 'Entrada principal del original', '534', 'a'),
( 'biblio', 'seriestitle', 'Numero de Clasificacion Decimal Universal', '080', 'a'),
( 'biblio', 'title', 'Titulo', '245', 'a'),
( 'biblio', 'unititle', 'Resto del ti­tulo', '245', 'b'),
( 'biblioitems', 'dewey', 'Call number prefix (NR)', '852', 'k'),
( 'biblioitems', 'idCountry', 'Codigo ISO (R)', '043', 'c'),
( 'biblioitems', 'illus', 'Otros detalles fi­sicos', '300', 'b'),
( 'biblioitems', 'issn', 'ISSN', '022', 'a'),
( 'biblioitems', 'itemtype', 'Tipo de documento', '910', 'a'),
( 'biblioitems', 'lccn', 'LC control number', '010', 'a'),
( 'biblioitems', 'notes', 'Nota General', '500', 'a'),
( 'biblioitems', 'number', 'Mencion de edicion', '250', 'a'),
( 'biblioitems', 'pages', 'Extension', '300', 'a'),
( 'biblioitems', 'place', 'Lugar de publicacion, distribucion, etc.', '260', 'a'),
( 'biblioitems', 'publicationyear', 'Fecha de publicacion, distribucion, etc.', '260', 'c'),
( 'biblioitems', 'seriestitle', 'Ti­tulo', '440', 'a'),
( 'biblioitems', 'size', 'Dimensiones', '300', 'c'),
( 'biblioitems', 'subclass', 'Call number suffix (NR)', '852', 'm'),
( 'biblioitems', 'url', 'Identificador Uniforme de Recurso (URI)', '856', 'u'),
( 'biblioitems', 'volume', 'Number of part/section of a work', '440', 'v'),
( 'biblioitems', 'volumeddesc', 'Ti­tulo', '440', 'p'),
( 'bibliosubject', 'subject', 'Topico o nombre geografico', '650', 'a'),
( 'bibliosubtitle', 'subtitle', 'Ti­tulo propiamente dicho/Ti­tulo corto', '246', 'a'),
( 'isbns', 'isbn', 'ISBN', '020', 'a'),
( 'items', 'barcode', 'Codigo de Barras', '995', 'f'),
( 'items', 'booksellerid', 'Nombre del vendedor', '995', 'a'),
( 'items', 'bulk', 'Signatura Topografica', '995', 't'),
( 'items', 'dateaccessioned', 'Fecha de acceso', '995', 'm'),
( 'items', 'holdingbranch', 'Unidad de Informacion', '995', 'c'),
( 'items', 'homebranch', 'Unidad de Informacion de Origen', '995', 'd'),
( 'items', 'itemnotes', 'Notas del item', '995', 'u'),
( 'items', 'notforloan', 'Disponibilidad', '995', 'o'),
( 'items', 'price', 'Precio de compra', '995', 'p'),
( 'items', 'replacementprice', 'Precio de reemplazo', '995', 'r'),
( 'items', 'wthdrawn', 'Estado', '995', 'e'),
( 'publisher', 'publisher', 'Nombre de la editorial, distribuidor, etc.', '260', 'b'),
( 'biblioitems', 'classification', '', '900', 'b'),
( 'biblioitems', 'idLanguage', '', '041', 'h'),
( 'biblioitems', 'fasc', 'Fasciculo', '863', 'b'),
( 'biblioitems', 'idSupport', '', '245', 'h');

DROP TABLE IF EXISTS `cat_registro_marc_n1`;

CREATE TABLE IF NOT EXISTS `cat_registro_marc_n1` (
  `id` int(11) NOT NULL auto_increment,
  `marc_record` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

DROP TABLE IF EXISTS `cat_registro_marc_n2`;

CREATE TABLE IF NOT EXISTS `cat_registro_marc_n2` (
  `id` int(11) NOT NULL auto_increment,
  `marc_record` text NOT NULL,
  `id1` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

DROP TABLE IF EXISTS `cat_registro_marc_n3`;

CREATE TABLE IF NOT EXISTS `cat_registro_marc_n3` (
  `id` int(11) NOT NULL auto_increment,
  `marc_record` text NOT NULL,
  `id1` int(11) NOT NULL,
  `id2` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `cat_registro_marc_n3_n1` (`id1`),
  KEY `cat_registro_marc_n3_n2` (`id2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

ALTER TABLE `cat_registro_marc_n3` ADD `codigo_barra` VARCHAR( 255 ) NOT NULL AFTER `id1` , ADD `signatura` VARCHAR( 255 ) NOT NULL AFTER `codigo_barra` ;

DROP TABLE IF EXISTS `cat_z3950_cola`;

CREATE TABLE IF NOT EXISTS `cat_z3950_cola` (
  `id` int(11) NOT NULL auto_increment,
  `busqueda` text,
  `cola` datetime NOT NULL,
  `comienzo` datetime default NULL,
  `fin` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

DROP TABLE IF EXISTS `cat_z3950_resultado`;

CREATE TABLE IF NOT EXISTS `cat_z3950_resultado` (
  `id` int(11) NOT NULL auto_increment,
  `servidor_id` tinyint(4) NOT NULL,
  `registro` longtext character set utf8,
  `cola_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

DROP TABLE IF EXISTS `contacto`;

CREATE TABLE IF NOT EXISTS `contacto` (
  `id` int(11) NOT NULL auto_increment,
  `trato` varchar(255) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(255) NOT NULL,
  `direccion` varchar(255) default NULL,
  `codigo_postal` varchar(255) default NULL,
  `ciudad` varchar(255) default NULL,
  `pais` varchar(255) default NULL,
  `telefono` varchar(255) default NULL,
  `email` varchar(255) NOT NULL,
  `asunto` varchar(255) NOT NULL,
  `mensaje` text NOT NULL,
  `leido` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `indice_busqueda`;

CREATE TABLE IF NOT EXISTS `indice_busqueda` (
  `id` int(11) NOT NULL auto_increment,
  `titulo` text,
  `autor` text,
  `string` text NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  FULLTEXT KEY `string` (`string`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `perm_catalogo`;

CREATE TABLE IF NOT EXISTS `perm_catalogo` (
  `ui` varchar(4) NOT NULL,
  `tipo_documento` varchar(4) NOT NULL,
  `datos_nivel1` varbinary(8) NOT NULL default '00000',
  `datos_nivel2` varbinary(8) NOT NULL default '00000',
  `datos_nivel3` varbinary(8) NOT NULL default '00000',
  `estantes_virtuales` varbinary(8) NOT NULL default '00000',
  `estructura_catalogacion_n1` varbinary(8) NOT NULL default '00000',
  `estructura_catalogacion_n2` varbinary(8) NOT NULL default '00000',
  `estructura_catalogacion_n3` varbinary(8) NOT NULL default '00000',
  `tablas_de_refencia` varbinary(8) NOT NULL default '00000',
  `control_de_autoridades` varbinary(8) NOT NULL default '00000',
  `usuarios` varchar(8) NOT NULL default '00000000',
  `sistema` varchar(8) NOT NULL default '00000001',
  `undefined` varchar(8) NOT NULL default '00000001',
  `id` int(11) NOT NULL auto_increment,
  `id_persona` int(11) unsigned NOT NULL,
  `nro_socio` varchar(16) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `id_persona` (`ui`,`tipo_documento`,`nro_socio`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

DROP TABLE IF EXISTS `perm_circulacion`;

CREATE TABLE IF NOT EXISTS `perm_circulacion` (
  `nro_socio` varchar(16) NOT NULL,
  `ui` varchar(4) NOT NULL,
  `tipo_documento` varchar(4) NOT NULL,
  `catalogo` varbinary(8) NOT NULL,
  `prestamos` varbinary(8) NOT NULL,
  PRIMARY KEY  (`nro_socio`,`ui`,`tipo_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `perm_general`;

CREATE TABLE IF NOT EXISTS `perm_general` (
  `nro_socio` varchar(16) NOT NULL,
  `ui` varchar(4) NOT NULL,
  `tipo_documento` varchar(4) NOT NULL,
  `preferencias` varbinary(8) NOT NULL,
  `reportes` varchar(8) NOT NULL default '00000000',
  `permisos` varchar(8) NOT NULL default '00000000',
  PRIMARY KEY  (`nro_socio`,`ui`,`tipo_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ref_tipo_operacion`;

CREATE TABLE IF NOT EXISTS `ref_tipo_operacion` (
  `id` int(11) NOT NULL auto_increment,
  `descripcion` varchar(20) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `pref_servidor_z3950`;

CREATE TABLE IF NOT EXISTS `pref_servidor_z3950` (
  `servidor` varchar(255) default NULL,
  `puerto` int(11) default NULL,
  `base` varchar(255) default NULL,
  `usuario` varchar(255) default NULL,
  `password` varchar(255) default NULL,
  `nombre` text,
  `id` int(11) NOT NULL auto_increment,
  `habilitado` tinyint(1) NOT NULL default '1',
  `sintaxis` varchar(80) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `pref_servidor_z3950` (`servidor`, `puerto`, `base`, `usuario`, `password`, `nombre`, `id`, `habilitado`, `sintaxis`) VALUES ('z3950.loc.gov', 7090, 'voyager', NULL, NULL, 'Library of Congress', 1, 1, 'UNIMARC');

DROP TABLE IF EXISTS `ref_disponibilidad`;
CREATE TABLE IF NOT EXISTS `ref_disponibilidad` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL DEFAULT '',
  `codigo` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `ref_disponibilidad` (`id`, `nombre`, `codigo`) VALUES
(0, 'Domiciliario', 'CIRC0000'),
(1, 'Sala de Lectura', 'CIRC0001');

DROP TABLE IF EXISTS `ref_estado`;

CREATE TABLE IF NOT EXISTS `ref_estado` (
  `id` int(11) NOT NULL ,
  `nombre` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ref_estado`;
CREATE TABLE IF NOT EXISTS `ref_estado` (
  `id` tinyint(5) NOT NULL,
  `nombre` varchar(255) NOT NULL DEFAULT '',
  `codigo` varchar(8) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  UNIQUE KEY `nombre_2` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


INSERT INTO `ref_estado` (`id`, `nombre`, `codigo`) VALUES
(1, 'Perdido', 'STATE005'),
(2, 'Compartido', 'STATE001'),
(3, 'Disponible', 'STATE002'),
(4, 'Baja', 'STATE000'),
(5, 'Ejemplar deteriorado', 'STATE003'),
(6, 'En Encuadernacion', 'STATE004'),
(7, 'En Etiquetado', 'STATE006'),
(8, 'En Impresiones', 'STATE007'),
(9, 'En procesos tecnicos', 'STATE008');


CREATE TABLE IF NOT EXISTS `usr_ref_tipo_documento` (
  `id` int(11) NOT NULL auto_increment,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(250) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

INSERT INTO `usr_ref_tipo_documento` (`id`, `nombre`, `descripcion`) VALUES
(1, 'DNI', 'DNI'),
(2, 'LC', 'LC'),
(3, 'LE', 'LE'),
(4, 'PAS', 'PAS');

CREATE TABLE IF NOT EXISTS `usr_estado` (
  `id_estado` int(11) NOT NULL auto_increment,
  `regular` tinyint(1) NOT NULL default '0',
  `categoria` char(2) NOT NULL,
  `fuente` varchar(255) NOT NULL default 'koha',
  PRIMARY KEY  (`id_estado`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT INTO `usr_estado` (`id_estado`, `regular`, `categoria`, `fuente`) VALUES
(20, 1, 'NN', 'ES UNA FUENTE DEFAULT, PREGUNTARLE A EINAR....'),
(46, 1, 'NN', 'MONO TU FUCKING KOHAADMIN SUPERLIBRARIAN'),
(47, 1, 'NN', 'ES UNA FUENTE DEFAULT, PREGUNTARLE A EINAR....');


DROP TABLE IF EXISTS cat_rating;

CREATE TABLE IF NOT EXISTS cat_rating (
  nro_socio varchar(11) NOT NULL,
  id2 int(11) NOT NULL,
  rate float NOT NULL,
  review text,
  PRIMARY KEY  (nro_socio,id2)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `cat_favoritos_opac`;

CREATE TABLE IF NOT EXISTS `cat_favoritos_opac` (
  `nro_socio` varchar(16) character set utf8 NOT NULL,
  `id1` int(11) NOT NULL,
  PRIMARY KEY  (`nro_socio`,`id1`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE  IF NOT EXISTS `sys_novedad` (
`id` INT( 16 ) NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`usuario` VARCHAR( 16 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`fecha` TIMESTAMP NOT NULL ,
`titulo` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`categoria` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`contenido` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL
) ENGINE = MYISAM;

CREATE TABLE IF NOT EXISTS `cat_rating` (
  `nro_socio` varchar(11) NOT NULL,
  `id2` int(11) NOT NULL,
  `rate` float NOT NULL,
  PRIMARY KEY  (`nro_socio`,`id2`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `cat_favoritos_opac`;

CREATE TABLE IF NOT EXISTS `cat_favoritos_opac` (
  `nro_socio` varchar(16) character set utf8 NOT NULL,
  `id1` int(11) NOT NULL,
  PRIMARY KEY  (`nro_socio`,`id1`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE  IF NOT EXISTS `sys_novedad` (
`id` INT( 16 ) NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`usuario` VARCHAR( 16 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`fecha` TIMESTAMP NOT NULL ,
`titulo` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`categoria` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
`contenido` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL
) ENGINE = MYISAM;


-- ADQUISICIONES --

CREATE TABLE IF NOT EXISTS `adq_forma_envio` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `adq_item` (
  `id_item` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(255) NOT NULL,
  `precio` float NOT NULL,
  PRIMARY KEY (`id_item`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `adq_proveedor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(255) NOT NULL,
  `nro_doc` varchar(21) NOT NULL,
  `razon_social` varchar(255) NOT NULL,
  `cuit_cuil` int(11) NOT NULL,
  `domicilio` varchar(255) NOT NULL,
  `telefono` varchar(32) NOT NULL,
  `fax` varchar(32) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `activo` int(1) NOT NULL,
  `plazo_reclamo` int(11) DEFAULT NULL,
  `usr_ref_tipo_documento_id` int(11) DEFAULT NULL,
  `ref_localidad_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_adq_proveedor_usr_ref_tipo_documento1` (`usr_ref_tipo_documento_id`),
  KEY `fk_adq_proveedor_ref_localidad1` (`ref_localidad_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `adq_proveedor_forma_envio` (
  `adq_forma_envio_id` int(11) NOT NULL,
  `adq_proveedor_id` int(11) NOT NULL,
  PRIMARY KEY (`adq_forma_envio_id`,`adq_proveedor_id`),
  KEY `fk_adq_proveedor_forma_envio_adq_proveedor1` (`adq_proveedor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `adq_proveedor_item` (
  `id_proveedor` int(11) NOT NULL,
  `id_item` int(11) NOT NULL,
  PRIMARY KEY (`id_proveedor`,`id_item`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `adq_ref_moneda` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;


CREATE TABLE IF NOT EXISTS `adq_ref_proveedor_moneda` (
  `adq_ref_moneda_id` int(11) NOT NULL,
  `adq_proveedor_id` int(11) NOT NULL,
  PRIMARY KEY (`adq_ref_moneda_id`,`adq_proveedor_id`),
  KEY `fk_adq_ref_moneda_has_adq_proveedor_adq_proveedor1` (`adq_proveedor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE  `ref_estado_presupuesto` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`nombre` VARCHAR( 255 ) NOT NULL
) ENGINE = MYISAM ;

DROP TABLE IF EXISTS `usr_ref_categoria_socio`;
CREATE TABLE IF NOT EXISTS `usr_ref_categoria_socio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categorycode` char(2) NOT NULL DEFAULT '',
  `description` text,
  `enrolmentperiod` smallint(6) DEFAULT NULL,
  `upperagelimit` smallint(6) DEFAULT NULL,
  `dateofbirthrequired` tinyint(1) DEFAULT NULL,
  `finetype` varchar(30) DEFAULT NULL,
  `bulk` tinyint(1) DEFAULT NULL,
  `enrolmentfee` decimal(28,6) DEFAULT NULL,
  `overduenoticerequired` tinyint(1) DEFAULT NULL,
  `issuelimit` smallint(6) DEFAULT NULL,
  `reservefee` decimal(28,6) DEFAULT NULL,
  `borrowingdays` smallint(30) NOT NULL DEFAULT '14',
  PRIMARY KEY (`id`),
  UNIQUE KEY `categorycode` (`categorycode`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

INSERT INTO `usr_ref_categoria_socio` (`id`, `categorycode`, `description`) VALUES
(1, 'ES', 'Estudiante'),
(2, 'IN', 'Investigador'),
(3, 'DO', 'Docente'),
(4, 'ND', 'No Docente'),
(5, 'EG', 'Egresado'),
(6, 'PG', 'Postgrado'),
(7, 'EX', 'Usuario externo'),
(8, 'IB', 'Interbibliotecario'),
(9, 'BB', 'Bibliotecario');

-- DA ERROR FIXME
ALTER TABLE `adq_proveedor`
  ADD CONSTRAINT `fk_adq_proveedor_ref_localidad1` FOREIGN KEY (`ref_localidad_id`) REFERENCES `ref_localidad` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_adq_proveedor_usr_ref_tipo_documento1` FOREIGN KEY (`usr_ref_tipo_documento_id`) REFERENCES `usr_ref_tipo_documento` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;



-- DATOS


--
-- Volcar la base de datos para la tabla `cat_estructura_catalogacion`
--

INSERT  INTO `cat_estructura_catalogacion` (`id`, `campo`, `subcampo`, `itemtype`, `liblibrarian`, `tipo`, `referencia`, `nivel`, `obligatorio`, `intranet_habilitado`, `visible`, `edicion_grupal`, `idinforef`, `idCompCliente`, `fijo`, `repetible`, `rules`, `grupo`) VALUES
(51, '245', 'a', 'ALL', 'Título', 'text', 0, 1, 1, 2, 1, 1, NULL, '1', 1, 0, 'alphanumeric_total:true', 0),
(66, '110', 'a', 'LIB', 'Autor corporativo', 'auto', 1, 1, 0, 1, 1, 1, 78, 'bf8e17616267c51064becf693e64501e', 0, 0, ' alphanumeric_total:true ', 0),
(68, '245', 'h', 'LIB', 'Medio', 'combo', 1, 2, 0, 4, 1, 1, 149, 'dbd4ba15b96cf63914351cdb163467b2', 0, 0, ' alphanumeric_total:true ', 0),
(107, '080', 'a', 'LIB', 'CDU', 'text', 0, 1, 0, 3, 1, 1, 0, 'ea0c6caa38d898989866335e1af0844e', 0, 1, ' alphanumeric_total:true ', 1),
(116, '700', 'a', 'LIB', 'Autor secundario/Colaboradores', 'auto', 1, 1, 0, 12, 1, 1, 143, '496705e6cd65f25e4e41ef8f26d0027e', 0, 1, ' alphanumeric_total:true ', 10),
(120, '710', 'a', 'REV', 'Nombre de la entidad o jurisdicción', 'auto', 1, 1, 0, 16, 1, 1, 64, '538f99c8e5537a6307385edc614e65cf', 0, 1, ' alphanumeric_total:true ', 14),
(124, '245', 'b', 'LIB', 'Resto del título', 'text', 0, 1, 0, 20, 1, 1, NULL, '21f6e655816f1ac4b941bc13908197e3', 0, 1, ' alphanumeric_total:true ', 18),
(132, '650', 'a', 'LIB', 'Temas (controlado)', 'auto', 1, 1, 0, 28, 1, 1, 88, '357a2f17fd0088cb1f0e8370b62d7452', 0, 1, ' alphanumeric_total:true ', 26),
(135, '653', 'a', 'LIB', 'Palabras claves (no controlado)', 'text', 0, 1, 0, 31, 1, 1, NULL, 'eea199e92303ba203519cd460a662188', 0, 1, ' alphanumeric_total:true ', 29),
(138, '041', 'a', 'LIB', 'Idioma', 'combo', 1, 2, 0, 9, 1, 1, 148, 'c304616fe1434ba4235a146010b98aa3', 0, 1, ' alphanumeric_total:true ', 32),
(140, '250', 'a', 'LIB', 'Edición', 'text', 0, 2, 0, 11, 1, 1, NULL, '665d8ec1b8a444dcf4d8732f09022742', 0, 1, ' alphanumeric_total:true ', 34),
(142, '300', 'a', 'LIB', 'Extensión/Páginas', 'text', 0, 2, 0, 13, 1, 1, NULL, '6982e2c38b57af9484301752acba4d44', 0, 1, ' alphanumeric_total:true ', 36),
(143, '440', 'a', 'LIB', 'Serie', 'text', 0, 2, 0, 14, 1, 1, NULL, '484e5d9090c3ba6b66ebad0c0e1150d2', 0, 1, ' alphanumeric_total:true ', 37),
(144, '440', 'p', 'LIB', 'Subserie', 'text', 0, 2, 0, 15, 1, 1, NULL, '5c9badf652343301382222dee9d8cd81', 0, 1, ' alphanumeric_total:true ', 38),
(145, '440', 'v', 'LIB', 'Número de la serie ', 'text', 0, 2, 0, 16, 1, 1, NULL, '2c1cdfad0546433f47440881acc9dc1a', 0, 1, ' alphanumeric_total:true ', 39),
(146, '500', 'a', 'LIB', 'Nota general', 'text', 0, 2, 0, 17, 1, 1, NULL, 'd92774dab9a0b65d987d0d10fcc5ee96', 0, 1, ' alphanumeric_total:true ', 40),
(152, '710', 'g', 'REV', 'Sigla', 'text', 0, 1, 0, 33, 1, 1, NULL, 'ce7d0b9c0192b1668ec7854f96366d4f', 0, 1, ' alphanumeric_total:true ', 0),
(157, '260', 'b', 'REV', 'Editor', 'text', 0, 2, 0, 10, 1, 1, NULL, '158837737c411171b07f555cf9911e09', 0, 1, ' alphanumeric_total:true ', 0),
(159, '362', 'a', 'REV', 'Fecha de inicio - cese', 'text', 0, 2, 0, 12, 1, 1, NULL, 'c1e31ba3b3372929907cdd9505868ad9', 0, 1, ' alphanumeric_total:true ', 0),
(162, '710', 'b', 'REV', 'Entidad subordinada', 'texta', 0, 1, 0, 35, 1, 1, NULL, '11238f8ecd94de929e600086aad33c5e', 0, 1, ' alphanumeric_total:true ', 0),
(166, '300', 'a', 'TES', 'Páginas', 'text', 0, 2, 0, 10, 1, 1, NULL, '52b02598a81d62f2639c1129422ed40e', 0, 1, ' digits:true ', 0),
(167, '110', 'b', 'LIB', 'Entidad subordinada', 'auto', 1, 1, 0, 33, 1, 1, 261, 'e70d29c5813261bccda451db1e131bcc', 0, 1, ' digits:true ', 0),
(170, '250', 'b', 'SEM', 'Editor', 'text', 0, 2, 0, 8, 1, 1, NULL, 'c017c66d4f430c276dd18b91e70e0c87', 0, 1, ' alphanumeric_total:true ', 0),
(173, '300', 'b', 'LIB', 'Otros detalles físicos (NR)', 'text', 0, 2, 0, 22, 1, 1, NULL, '8e7937b4a461334ac4069b343fd4be6f', 0, 1, ' alphanumeric_total:true ', 0),
(174, '300', 'c', 'LIB', 'Dimensiones (R)', 'text', 0, 2, 0, 23, 1, 1, NULL, 'a95bd9b45f6f4b63f13455acc09ea98b', 0, 1, ' alphanumeric_total:true ', 0),
(179, '240', 'a', 'REV', 'Título uniforme (NR)', 'text', 0, 1, 0, 27, 1, 1, NULL, 'c6a6287394c22748b31ccfff8f1c61d6', 0, 1, ' alphanumeric_total:true ', 0),
(181, '246', 'f', 'REV', 'Designación del volumen, número, fecha', 'text', 0, 1, 0, 29, 1, 1, NULL, '3a5781978b3aa10341d0ac52c7848f9a', 0, 1, ' alphanumeric_total:true ', 0),
(187, '310', 'b', 'REV', 'Fecha de frecuencia actual de la publicación (NR)', 'text', 0, 2, 0, 16, 1, 1, NULL, '13b3d3af3c0ed21bf82d8893b3ae2785', 0, 1, ' alphanumeric_total:true ', 0),
(190, '500', 'a', 'REV', 'Nota general (NR)', 'text', 0, 2, 0, 17, 1, 1, NULL, '8b5faa32fa5cb921206b056cc2ab12b3', 0, 1, ' alphanumeric_total:true ', 0),
(196, '100', 'b', 'LIB', 'Numeración (NR)', 'text', 0, 1, 0, 34, 1, 1, NULL, 'fd5bf619a9599f761aeb2b06e2c78794', 0, 1, ' alphanumeric_total:true ', 0),
(197, '100', 'c', 'LIB', 'Títulos y otras palabras asociadas con el nombre (R)', 'text', 0, 1, 0, 35, 1, 1, NULL, '1e93b93d6f843a21faefb43198be5a0f', 0, 1, ' alphanumeric_total:true ', 0),
(198, '100', 'd', 'LIB', 'Fecha de nacimiento y muerte', 'calendar', 0, 1, 0, 36, 1, 1, NULL, 'c2aef632843117206593b3da4b4eb2a4', 0, 1, ' dateITA:true ', 0),
(203, '250', 'a', 'FOT', 'Edición', 'text', 0, 2, 0, 4, 1, 1, NULL, '1ca43551e6b3b7ae1867b5600286b28d', 0, 1, ' alphanumeric_total:true ', 0),
(205, '260', 'b', 'FOT', 'Editor', 'text', 0, 2, 0, 6, 1, 1, NULL, 'eee370a1798db8697e8d4ddc01645289', 0, 1, ' alphanumeric_total:true ', 0),
(206, '260', 'c', 'FOT', 'Fecha', 'text', 0, 2, 0, 7, 1, 1, NULL, '3b20c6955b6abba2acdf75bd0e4eec0c', 0, 1, ' alphanumeric_total:true ', 0),
(207, '440', 'a', 'FOT', 'Serie', 'text', 0, 2, 0, 8, 1, 1, NULL, '21bbc9fb703e5091daab09a783505185', 0, 1, ' alphanumeric_total:true ', 0),
(208, '440', 'p', 'FOT', 'Subserie', 'text', 0, 2, 0, 9, 1, 1, NULL, '0926182ee4f15005e157065a66aecaea', 0, 1, ' alphanumeric_total:true ', 0),
(209, '440', 'v', 'FOT', 'Número de la serie', 'text', 0, 2, 0, 10, 1, 1, NULL, '3e8dcc89ce341656d1c90360df6c0d76', 0, 1, ' alphanumeric_total:true ', 0),
(210, '300', 'a', 'FOT', 'Descripción física', 'text', 0, 2, 0, 11, 1, 1, NULL, 'ca37509585fba624c5a6824da36022cd', 0, 1, ' alphanumeric_total:true ', 0),
(211, '500', 'a', 'FOT', 'Nota general ', 'text', 0, 2, 0, 12, 1, 1, NULL, '925becd7ae41c7e7b7300d01264f605b', 0, 1, ' alphanumeric_total:true ', 0),
(212, '773', 'd', 'FOT', 'Lugar, editor y fecha de publicación de la parte mayor', 'text', 0, 2, 0, 13, 1, 1, NULL, '6e01cf17a1e90bccafb06983dfb1ecf6', 0, 1, ' alphanumeric_total:true ', 0),
(213, '773', 'g', 'FOT', 'Ubicación de la parte', 'text', 0, 2, 0, 14, 1, 1, NULL, '9f74adedc3e487dd09fb1d40b156f896', 0, 1, ' alphanumeric_total:true ', 0),
(214, '773', 't', 'FOT', 'Título y mención de la parte mayor', 'text', 0, 2, 0, 15, 1, 1, NULL, '9f77f316a27cb3a8cec0ec3f3b11bfda', 0, 1, ' alphanumeric_total:true ', 0),
(215, '260', 'a', 'FOT', 'Lugar', 'auto', 1, 2, 0, 15, 1, 1, 150, '17780c5ea89df2b9ad8dbf66eda4015d', 0, 1, ' alphanumeric_total:true ', 0),
(216, '100', 'a', 'DCA', 'Autor', 'auto', 1, 1, 0, 18, 1, 1, 77, '8463a7ead2190cbca46501e1522d2010', 0, 1, ' alphanumeric_total:true ', 0),
(217, '260', 'a', 'DCA', 'Lugar', 'auto', 1, 2, 0, 4, 1, 1, 76, '0b3baf9f2c23e842482b50668a72af41', 0, 1, ' alphanumeric_total:true ', 0),
(218, '260', 'b', 'DCA', 'Editor', 'text', 0, 2, 0, 5, 1, 1, NULL, '08caa243955d91b91498180d13e3fa41', 0, 1, ' alphanumeric_total:true ', 0),
(219, '260', 'c', 'DCA', 'Fecha', 'calendar', 0, 2, 0, 6, 1, 1, NULL, 'e0f9c80ff3e651fc0e786681f81dbffd', 0, 1, ' alphanumeric_total:true ', 0),
(220, '300', 'a', 'DCA', 'Extensión/Páginas', 'text', 0, 2, 0, 7, 1, 1, NULL, '8db011e4e5f8cd1dda43b19724d64c36', 0, 1, ' alphanumeric_total:true ', 0),
(221, '440', 'a', 'DCA', 'Serie', 'text', 0, 2, 0, 8, 1, 1, NULL, '8e03eaab572412f997af83cb4d993e63', 0, 1, ' alphanumeric_total:true ', 0),
(222, '440', 'p', 'DCA', 'Subserie', 'text', 0, 2, 0, 9, 1, 1, NULL, '88bbd6dad17c4693455940239ab8e03c', 0, 1, ' alphanumeric_total:true ', 0),
(223, '440', 'v', 'DCA', 'Número', 'text', 0, 2, 0, 10, 1, 1, NULL, 'f7bd311eb4473e6df290689803ff1f1a', 0, 1, ' alphanumeric_total:true ', 0),
(224, '500', 'a', 'DCA', 'Nota general', 'text', 0, 2, 0, 11, 1, 1, NULL, 'b87ab2596026ff6efb3f4dedaa382cdd', 0, 1, ' alphanumeric_total:true ', 0),
(225, '700', 'b', 'LIB', 'Número asociado al nombre', 'text', 0, 1, 0, 3, 1, 1, NULL, 'd68a4311b8773c73495f6397f0dcabe8', 0, 1, ' alphanumeric_total:true ', 0),
(226, '700', 'c', 'LIB', 'Títulos y otras palabras asociadas con el nombre', 'text', 0, 1, 0, 2, 1, 1, NULL, '9670663cf1362fa2de186daa80b65700', 0, 1, ' alphanumeric_total:true ', 0),
(227, '700', 'd', 'LIB', 'Fecha de nacimento y muerte', 'text', 0, 1, 0, 3, 1, 1, NULL, '815574e5acfdbf4261651a3cf2c2ca16', 0, 1, ' alphanumeric_total:true ', 0),
(228, '700', 'e', 'LIB', 'Función', 'text', 0, 1, 0, 2, 1, 1, 0, '89a16936399743ab6537c00fd84de07a', 0, 1, ' alphanumeric_total:true ', 0),
(229, '773', 't', 'LIB', 'Título y mención de resp. del documento fuente', 'text', 0, 2, 0, 19, 1, 1, NULL, 'a991d2c5d6905b32db1eaa70342a8962', 0, 1, ' alphanumeric_total:true ', 0),
(230, '773', 'd', 'LIB', 'Lugar, editor y fecha (documento fuente)', 'text', 0, 2, 0, 20, 1, 1, NULL, '313e1387022292da1cf7b87cf67a293d', 0, 1, ' alphanumeric_total:true ', 0),
(231, '773', 'g', 'LIB', 'Parte relacionada (ubicación de la parte)', 'text', 0, 2, 0, 21, 1, 1, NULL, '1aeadd22f8a43c45283e79c4d12b620a', 0, 1, ' alphanumeric_total:true ', 0),
(232, '041', 'a', 'DCA', 'Idioma', 'combo', 1, 2, 0, 9, 1, 1, 110, 'ee3459db0a48b344488061909c0c96e5', 0, 1, ' alphanumeric_total:true ', 0),
(233, '650', 'a', 'DCA', 'temas (controlado)', 'auto', 1, 1, 0, 2, 1, 1, 89, 'af1cfb16220f155838b1e3d8bbac14d5', 0, 1, ' alphanumeric_total:true ', 0),
(234, '653', 'a', 'DCA', 'Palabras claves (no controlado)', 'text', 0, 1, 0, 3, 1, 1, NULL, 'a048da02607307e067b5d1e4ca7c4bee', 0, 1, ' alphanumeric_total:true ', 0),
(235, '110', 'a', 'DCA', 'Autor corporativo', 'auto', 1, 1, 0, 2, 1, 1, 93, 'a1a1350b2f0ffb80723e603b6105eeef', 0, 1, ' alphanumeric_total:true ', 0),
(236, '110', 'b', 'DCA', 'Entidad subordinada', 'auto', 1, 1, 0, 2, 1, 1, 97, '3f953984408ceec2965c058426cf6eef', 0, 1, ' alphanumeric_total:true ', 0),
(237, '700', 'a', 'DCA', 'Autor secundario', 'auto', 1, 1, 0, 2, 1, 1, 91, 'd4a08dc643606dc1e6169762710cf116', 0, 1, ' alphanumeric_total:true ', 0),
(238, '700', 'e', 'DCA', 'Función', 'text', 0, 1, 0, 2, 1, 1, NULL, '611244f681343b56cac4e9bc0341f63f', 0, 1, ' alphanumeric_total:true ', 0),
(239, '080', 'a', 'DCA', 'CDU', 'text', 0, 1, 0, 2, 1, 1, NULL, 'd80534925707ab93b53f9fdb83da509f', 0, 1, ' alphanumeric_total:true ', 0),
(240, '900', 'b', 'REV', 'Nivel bibliografico', 'text', 1, 2, 0, 13, 1, 1, 238, 'ba9c2821f1553be4bb52e5cd2b24cb53', 0, 1, ' alphanumeric_total:true ', 0),
(241, '910', 'a', 'REV', 'Tipo de documento', 'combo', 1, 2, 1, 7, 1, 1, 122, '91fd6a6a083b0b1fba81f52b686d09f0', 1, 1, ' alphanumeric_total:true ', 0),
(242, '900', 'b', 'DCA', 'Nivel bibliografico', 'text', 0, 2, 0, 10, 1, 1, NULL, 'ae8bf4c011e2b889d43c2750ac1fe293', 0, 1, ' alphanumeric_total:true ', 0),
(243, '910', 'a', 'DCA', 'Tipo de documento', 'text', 0, 2, 1, 6, 1, 1, NULL, '47a1ddefee6dbd1e1d48eea3e9866459', 1, 1, ' alphanumeric_total:true ', 0),
(244, '080', 'a', 'DCD', 'CDU', 'text', 0, 1, 0, 2, 1, 1, NULL, '6da523b4dcff731ad8b6e04eeed6b658', 0, 1, ' alphanumeric_total:true ', 0),
(245, '100', 'a', 'DCD', 'Autor', 'auto', 1, 1, 0, 2, 1, 1, 94, '7eba44017ef8689f7d66bf860243f7d8', 0, 1, ' alphanumeric_total:true ', 0),
(248, '650', 'a', 'DCD', 'Temas (controlado)', 'auto', 1, 1, 0, 2, 1, 1, 101, '1bbf2189a2744958f7f4a5eab17b0f4a', 0, 1, ' alphanumeric_total:true ', 0),
(249, '653', 'a', 'DCD', 'Palabras claves (no controlado)', 'text', 0, 1, 0, 2, 1, 1, NULL, 'd827b366de9a62b46f35d98fd3cca4bc', 0, 1, ' alphanumeric_total:true ', 0),
(250, '700', 'a', 'DCD', 'Autor secundario', 'auto', 1, 1, 0, 2, 1, 1, 106, '480c2a2a8f5025d4847b6f5445d53a02', 0, 1, ' alphanumeric_total:true ', 0),
(251, '700', 'e', 'DCD', 'Función', 'text', 0, 1, 0, 3, 1, 1, NULL, '2dbc9a57ba5d9b81e624585a90c0c423', 0, 1, ' alphanumeric_total:true ', 0),
(252, '110', 'a', 'DCD', 'Autor corporativo', 'auto', 1, 1, 0, 2, 1, 1, 107, 'fb0ec3bfa41a301eca2b871eeaff3ede', 0, 1, ' alphanumeric_total:true ', 0),
(253, '110', 'b', 'DCD', 'Entidad subordinada', 'auto', 1, 1, 0, 3, 1, 1, 108, 'fe5d1af48488acdf6ba5d6cfdb212b54', 0, 1, ' alphanumeric_total:true ', 0),
(254, '041', 'a', 'DCD', 'Idioma', 'combo', 1, 2, 0, 1, 1, 1, 109, '1bc8a25f686f436744d7b529c45f0dbe', 0, 1, ' alphanumeric_total:true ', 0),
(255, '260', 'a', 'DCD', 'Lugar ', 'text', 0, 2, 0, 2, 1, 1, NULL, '1912d7b1406c1e6b4db9c4f449497fbc', 0, 1, ' alphanumeric_total:true ', 0),
(256, '260', 'b', 'DCD', 'Editor', 'text', 0, 2, 0, 3, 1, 1, NULL, '0b5d0008268a956661c386eb9e028786', 0, 1, ' alphanumeric_total:true ', 0),
(257, '260', 'c', 'DCD', 'Fecha ', 'text', 0, 2, 0, 4, 1, 1, NULL, '0c38b9e0add94b98d79311245b29e5b7', 0, 1, ' alphanumeric_total:true ', 0),
(258, '300', 'a', 'DCD', 'Extensión/Páginas', 'text', 0, 2, 0, 5, 1, 1, NULL, 'b511d53be952b277e5d563a846c32c77', 0, 1, ' alphanumeric_total:true ', 0),
(259, '440', 'a', 'DCD', 'Serie', 'text', 0, 2, 0, 6, 1, 1, NULL, '36dfcca8f57a30dafc57e3247cdfd9f7', 0, 1, ' alphanumeric_total:true ', 0),
(260, '440', 'p', 'DCD', 'Subserie', 'text', 0, 2, 0, 7, 1, 1, NULL, '4d9d520745e72cd9772478d30ad2ea78', 0, 1, ' alphanumeric_total:true ', 0),
(261, '440', 'v', 'DCD', 'Número', 'text', 0, 2, 0, 8, 1, 1, NULL, '530657e9fbf30df062105db336525a91', 0, 1, ' alphanumeric_total:true ', 0),
(262, '500', 'a', 'DCD', 'Nota general ', 'text', 0, 2, 0, 9, 1, 1, NULL, '72232966314ddd76b9e8415bcf4d78aa', 0, 1, ' alphanumeric_total:true ', 0),
(263, '900', 'b', 'DCD', 'Nivel bibliografico', 'text', 0, 2, 0, 10, 1, 1, NULL, 'ad014a05d2a21cc7aa07ecd655def9e4', 0, 1, ' alphanumeric_total:true ', 0),
(264, '910', 'a', 'DCD', 'Tipo de documento', 'text', 0, 2, 1, 6, 1, 1, NULL, 'c695d0ce05cf0c87867c119192cf83f1', 1, 1, ' alphanumeric_total:true ', 0),
(265, '080', 'a', 'TES', 'CDU', 'text', 0, 1, 0, 2, 1, 1, NULL, '3bf5051f7db74faed5931613b905bc6e', 0, 1, ' alphanumeric_total:true ', 0),
(266, '100', 'a', 'TES', 'Autor', 'auto', 1, 1, 0, 2, 1, 1, 119, '4713353344e672c60b12476570671c33', 0, 1, ' alphanumeric_total:true ', 0),
(267, '100', 'd', 'TES', 'Fecha de nacimiento y muerte', 'calendar', 0, 1, 0, 3, 1, 1, NULL, '92035ccdf9cde6432cf59470e9b1c401', 0, 1, ' alphanumeric_total:true ', 0),
(268, '700', 'a', 'TES', 'Autor secundario/Colaboradores', 'auto', 1, 1, 0, 2, 1, 1, 114, '8b182290b35d9f458c4fc58892fa3994', 0, 1, ' alphanumeric_total:true ', 0),
(269, '700', 'e', 'TES', 'Función', 'text', 0, 1, 0, 2, 1, 1, NULL, 'c9a8747e61ef069566a74ff08add9d89', 0, 1, ' alphanumeric_total:true ', 0),
(270, '650', 'a', 'TES', 'Temas (controlado)', 'auto', 1, 1, 0, 2, 1, 1, 117, '1fb052e60f604f631c3785a98df90f84', 0, 1, ' alphanumeric_total:true ', 0),
(271, '653', 'a', 'TES', 'Palabras claves (no controlado)', 'text', 0, 1, 0, 2, 1, 1, NULL, '4b69608689208bbc715b7a8d85a2ecaf', 0, 1, ' alphanumeric_total:true ', 0),
(272, '041', 'a', 'TES', 'Idioma', 'combo', 1, 2, 0, 2, 1, 1, 118, 'd11c085eebaa452a7b4986c5f84afb8c', 0, 1, ' digits:true ', 0),
(273, '260', 'a', 'TES', 'Lugar', 'auto', 1, 2, 0, 3, 1, 1, 120, '71a869e7f105ef5f97faf75b910c9380', 0, 1, ' alphanumeric_total:true ', 0),
(274, '260', 'b', 'TES', 'Editor', 'text', 0, 2, 0, 4, 1, 1, NULL, '9048aed9af70bf2733c789850102c0cd', 0, 1, ' alphanumeric_total:true ', 0),
(275, '260', 'c', 'TES', 'Fecha ', 'calendar', 0, 2, 0, 5, 1, 1, NULL, 'de448182a028ddc62f881a64446b3acc', 0, 1, ' dateITA:true ', 0),
(277, '502', 'b', 'TES', 'Tipo de grado', 'text', 0, 2, 0, 7, 1, 1, NULL, '1e3c38d59a684a80576b7f1c9577eaf3', 0, 1, ' alphanumeric_total:true ', 0),
(278, '502', 'c', 'TES', 'Nombre de la institución otorgante', 'text', 0, 2, 0, 8, 1, 1, NULL, '4d486d99dbaba9179db32cd96df4c97c', 0, 1, ' alphanumeric_total:true ', 0),
(279, '502', 'd', 'TES', 'Año de grado otorgado', 'text', 0, 2, 0, 9, 1, 1, NULL, '05f788ded9f65c5a139a39c70993738c', 0, 1, ' alphanumeric_total:true ', 0),
(280, '260', 'a', 'REV', 'Lugar', 'auto', 1, 2, 0, 15, 1, 1, 121, '372a9f2c8015cc3242c37ec660bc83c9', 0, 1, ' alphanumeric_total:true ', 0),
(281, '246', 'a', 'REV', 'Variante del título', 'text', 0, 1, 0, 2, 1, 1, NULL, '668171c193e270880a06b6996431e774', 0, 1, ' alphanumeric_total:true ', 0),
(282, '110', 'a', 'REV', 'Autor corporativo', 'auto', 1, 1, 0, 2, 1, 1, 124, '25320613319b16f3bbeb342ee91b1303', 0, 1, ' alphanumeric_total:true ', 0),
(283, '110', 'b', 'REV', 'Entidad subordinada', 'auto', 1, 1, 0, 2, 1, 1, 126, '443efa19185b98fee8a41a86d16a6425', 0, 1, ' alphanumeric_total:true ', 0),
(285, '863', 'a', 'REV', 'Volumen', 'text', 0, 2, 0, 16, 1, 1, NULL, '98a0b279468735013be9de9504e00bd1', 0, 1, ' alphanumeric_total:true ', 0),
(286, '863', 'b', 'REV', 'Número', 'text', 0, 2, 0, 17, 1, 1, NULL, '2bbd5daf8f10feb41b49653515ba2887', 0, 1, ' alphanumeric_total:true ', 0),
(287, '863', 'i', 'REV', 'Año', 'text', 0, 2, 0, 18, 1, 1, NULL, 'b19ac05e7f553256a6a2c5e3458524fa', 0, 1, ' alphanumeric_total:true ', 0),
(288, '041', 'a', 'REV', 'Código de idioma para texto o pista de sonido o título separado (R)', 'auto', 1, 2, 0, 19, 1, 1, 128, 'f27314e050fd60b21b56f5e445a00bd0', 0, 1, ' alphanumeric_total:true ', 0),
(289, '245', 'b', 'FOT', 'Resto del título (NR)', 'text', 0, 1, 0, 2, 1, 1, NULL, '88a27b9d27a76b5cae15f7f364a2ccbd', 0, 1, ' alphanumeric_total:true ', 0),
(290, '080', 'a', 'FOT', 'CDU', 'text', 0, 1, 0, 2, 1, 1, NULL, '4d45d15bfdb8ac5b43da43ca392e0c17', 0, 1, ' alphanumeric_total:true ', 0),
(292, '100', 'a', 'FOT', 'Autor', 'auto', 1, 1, 0, 2, 1, 1, 159, '1c776e09f1f10160e2ed4d0bb142238d', 0, 1, ' alphanumeric_total:true ', 0),
(293, '100', 'b', 'FOT', 'Numeración (NR)', 'text', 0, 1, 0, 3, 1, 1, NULL, 'ba95a5375d025f75e91a513b8ea24363', 0, 1, ' alphanumeric_total:true ', 0),
(294, '100', 'c', 'FOT', 'Títulos y otras palabras asociadas con el nombre (R)', 'text', 0, 1, 0, 2, 1, 1, NULL, 'cf6ba23a2c275073b7dc65dda42ff824', 0, 1, ' alphanumeric_total:true ', 0),
(295, '100', 'd', 'FOT', 'Fechas asociadas con el nombre (NR)', 'text', 0, 1, 0, 2, 1, 1, NULL, 'cb248ddf055e3ed7b3b890bfe4390516', 0, 1, ' alphanumeric_total:true ', 0),
(296, '110', 'a', 'FOT', 'Autor corporativo', 'auto', 1, 1, 0, 2, 1, 1, 160, '1ed441750cc808949c1934de696db4fd', 0, 1, ' alphanumeric_total:true ', 0),
(297, '110', 'b', 'FOT', 'Entidad subordinada', 'auto', 1, 1, 0, 2, 1, 1, 161, 'c0ab88c817a47ab84787b8f8788b0c7d', 0, 1, ' alphanumeric_total:true ', 0),
(299, '650', 'a', 'FOT', 'Temas (controlados)', 'auto', 1, 1, 0, 2, 1, 1, 162, '99f7c5e12cddef20e32d2999e2f712d3', 0, 1, ' alphanumeric_total:true ', 0),
(304, '653', 'a', 'FOT', 'Palabras claves (no controlado)', 'text', 0, 1, 0, 5, 1, 1, NULL, 'd658571aa9daa2d9a9cde07f8749a3cd', 0, 1, ' alphanumeric_total:true ', 0),
(305, '700', 'a', 'FOT', 'Autor secundario/Colaboradores', 'auto', 1, 1, 0, 6, 1, 1, 163, '39f025806bbc598b0a88c4fa1ca8f96b', 0, 1, ' alphanumeric_total:true ', 0),
(306, '700', 'b', 'FOT', 'Numeración', 'text', 0, 1, 0, 7, 1, 1, NULL, 'd310f0895a17ec29759339c4122c1528', 0, 1, ' alphanumeric_total:true ', 0),
(307, '700', 'c', 'FOT', 'Títulos y otras palabras asociadas con el nombre', 'text', 0, 1, 0, 8, 1, 1, NULL, '023cc3e4c877ed7b55960b447139e7f6', 0, 1, ' alphanumeric_total:true ', 0),
(308, '700', 'd', 'FOT', 'Fechas de nacimiento y muerte', 'calendar', 0, 1, 0, 9, 1, 1, NULL, '5a24ccdf144188630ac81d2e7b37f2cf', 0, 1, ' alphanumeric_total:true ', 0),
(309, '700', 'e', 'FOT', 'Función', 'text', 0, 1, 0, 10, 1, 1, NULL, '69e747d0fdb1d475236ce3fe25607671', 0, 1, ' alphanumeric_total:true ', 0),
(310, '900', 'b', 'FOT', 'Nivel bibliografico', 'combo', 1, 2, 0, 13, 1, 1, 164, 'c3606946ef2b6695c127f57e0a74afc9', 0, 1, ' alphanumeric_total:true ', 0),
(311, '910', 'a', 'FOT', 'Tipo de documento', 'combo', 1, 2, 1, 7, 1, 1, 165, '2962c3f1a040d491b10c00f5000a61a7', 1, 1, ' alphanumeric_total:true ', 0),
(312, '111', 'a', 'LIB', 'Nombre de la reunión', 'text', 0, 1, 0, 2, 1, 1, NULL, '58fef3280e991934f9639da16642bf47', 0, 1, ' alphanumeric_total:true ', 0),
(315, '111', 'n', 'FOT', 'Número de la reunión', 'text', 0, 1, 0, 3, 1, 1, NULL, 'b8a2e864b55385c8cd6633ca06c7f5cd', 0, 1, ' alphanumeric_total:true ', 0),
(316, '111', 'd', 'FOT', 'Fecha de la reunión', 'calendar', 0, 1, 0, 4, 1, 1, NULL, 'cf7426063068fc4a789320bf64e2615a', 0, 1, ' alphanumeric_total:true ', 0),
(317, '111', 'c', 'FOT', 'Lugar de la reunión', 'auto', 1, 1, 0, 5, 1, 1, 132, 'a3467909c71023b93b18fe234fab1c14', 0, 1, ' alphanumeric_total:true ', 0),
(318, '111', 'n', 'LIB', 'Número de la reunión', 'text', 0, 1, 0, 2, 1, 1, NULL, '8751c2ccd2ece8da7a19c2a20a839a4a', 0, 1, ' alphanumeric_total:true ', 0),
(319, '111', 'd', 'LIB', 'Fecha de la reunión', 'calendar', 0, 1, 0, 2, 1, 1, NULL, 'f9624e8e52ab15e934897f32122d6bcd', 0, 1, ' alphanumeric_total:true ', 0),
(320, '111', 'c', 'LIB', 'Lugar de la reunión', 'auto', 1, 1, 0, 2, 1, 1, 235, '1dbd53bb10384eeb711b7bc0d0072f29', 0, 1, ' alphanumeric_total:true ', 0),
(322, '910', 'a', 'ANA', 'Tipo de documento', 'combo', 1, 2, 1, 10, 1, 1, 250, '102655d2d2e23c7ab41878e4ad9c84b2', 1, 1, ' alphanumeric_total:true ', 0),
(323, '900', 'b', 'LIB', 'Nivel bibliografico', 'combo', 1, 2, 0, 20, 1, 1, 147, '6becd17a2634cb1d4f49d1266ee62c5b', 0, 1, ' alphanumeric_total:true ', 0),
(324, '260', 'a', 'LIB', 'Lugar', 'auto', 1, 2, 0, 18, 1, 1, 151, 'a7dba4ca62f31b094ec67c065b8244c8', 0, 1, ' alphanumeric_total:true ', 0),
(325, '260', 'b', 'LIB', 'Editor', 'auto', 1, 2, 0, 19, 1, 1, 257, '632546631c044616b8b15c5eaef2c5cb', 0, 1, ' digits:true ', 0),
(326, '260', 'c', 'LIB', 'Fecha ', 'text', 0, 2, 0, 20, 1, 1, NULL, 'ede39fc9c490e561b88f7ee281dd05be', 0, 1, ' alphanumeric_total:true ', 0),
(327, '505', 'a', 'LIB', 'Nota normalizada', 'text', 0, 2, 0, 20, 1, 1, NULL, 'cfec8cf48f982f278df0bdbf9b59545d', 0, 1, ' alphanumeric_total:true ', 0),
(328, '505', 'g', 'LIB', 'Volumen', 'text', 0, 2, 0, 21, 1, 1, NULL, '8567dd350b957fd789a94fbd8cb3920d', 0, 1, ' alphanumeric_total:true ', 0),
(329, '505', 't', 'LIB', 'Descripción del volumen', 'text', 0, 2, 0, 22, 1, 1, NULL, '62bf05615bba052b98d80a16db43c3df', 0, 1, ' alphanumeric_total:true ', 0),
(330, '505', 'a', 'FOT', 'Nota normalizada', 'text', 0, 2, 0, 15, 1, 1, NULL, '8af7cd0fc50c245beb151f7430a93d5e', 0, 1, ' alphanumeric_total:true ', 0),
(331, '505', 'g', 'FOT', 'Volumen', 'text', 0, 2, 0, 16, 1, 1, NULL, '26162739dd9f296f813a62dd5d38e17c', 0, 1, ' alphanumeric_total:true ', 0),
(332, '505', 't', 'FOT', 'Descripción del volumen', 'text', 0, 2, 0, 17, 1, 1, NULL, '6e3e5eeb564b4cf2aecf9af69b678ed5', 0, 1, ' alphanumeric_total:true ', 0),
(336, '080', 'a', 'CDR', 'CDU', 'text', 0, 1, 0, 2, 1, 1, NULL, 'fe4f17ce80b250817068c99894928289', 0, 1, ' alphanumeric_total:true ', 0),
(337, '100', 'a', 'CDR', 'Autor', 'auto', 1, 1, 0, 2, 1, 1, 171, 'dae39828da8dbd62e18626ed2a2d6f48', 0, 1, ' alphanumeric_total:true ', 0),
(338, '100', 'b', 'CDR', 'Numeración', 'text', 0, 1, 0, 2, 1, 1, NULL, '126ad0ebeea77d744ce0a12dae1a979b', 0, 1, ' alphanumeric_total:true ', 0),
(339, '100', 'c', 'CDR', 'Títulos y otras palabras asociadas con el nombre', 'text', 0, 1, 0, 2, 1, 1, NULL, '0cc7aab522c7e6523d07c1d1b45657aa', 0, 1, ' alphanumeric_total:true ', 0),
(340, '100', 'd', 'CDR', 'Fechas de nacimiento y muerte', 'text', 0, 1, 0, 2, 1, 1, NULL, '7110f52963568ed12ea0f9c029cf1447', 0, 1, ' alphanumeric_total:true ', 0),
(341, '110', 'a', 'CDR', 'Autor corporativo', 'auto', 1, 1, 0, 2, 1, 1, 173, '73351c532c5991d84434bc545c9bcc17', 0, 1, ' alphanumeric_total:true ', 0),
(342, '110', 'b', 'CDR', 'Entidad subordinada', 'auto', 1, 1, 0, 2, 1, 1, 175, '2ce80d26de7b9c31cfe19421c4a3ee1f', 0, 1, ' alphanumeric_total:true ', 0),
(343, '111', 'a', 'CDR', 'Nombre de la reunión', 'text', 0, 1, 0, 2, 1, 1, NULL, '369b8fa4495d95305622b3027e5dc72f', 0, 1, ' alphanumeric_total:true ', 0),
(344, '111', 'n', 'CDR', 'Número de la reunión', 'text', 0, 1, 0, 2, 1, 1, NULL, '766b036591dcccf6acc2e109403e61de', 0, 1, ' alphanumeric_total:true ', 0),
(345, '111', 'd', 'CDR', 'Fecha de la reunión', 'text', 0, 1, 0, 3, 1, 1, NULL, 'ad00dc0ad488023138b3e63226c35d50', 0, 1, ' alphanumeric_total:true ', 0),
(346, '111', 'c', 'CDR', 'Lugar de la reunión', 'auto', 1, 1, 0, 2, 1, 1, 177, '8ff959bb9cd5a88dfd78658af8b0e8bc', 0, 1, ' alphanumeric_total:true ', 0),
(347, '245', 'b', 'CDR', 'Resto del título', 'text', 0, 1, 0, 2, 1, 1, NULL, 'b4c85997493ddebd06280867f03b8cf2', 0, 1, ' alphanumeric_total:true ', 0),
(348, '650', 'a', 'CDR', 'Temas (controlado)', 'auto', 1, 1, 0, 2, 1, 1, 211, 'af1a9cad897645f35a382aecc13a19c6', 0, 1, ' alphanumeric_total:true ', 0),
(349, '653', 'a', 'CDR', 'Palabras claves (no controlado)', 'text', 0, 1, 0, 2, 1, 1, NULL, 'f26c6fc8c6dc6f03804039f502c27d70', 0, 1, ' alphanumeric_total:true ', 0),
(350, '700', 'a', 'CDR', 'Autor secundario/Colaboradores', 'auto', 1, 1, 0, 2, 1, 1, 181, 'f33c8e1cdb5fcf61c731de2229745a46', 0, 1, ' alphanumeric_total:true ', 0),
(351, '700', 'b', 'CDR', 'Número asociado al nombre', 'text', 0, 1, 0, 2, 1, 1, NULL, 'd5eafb260bf9e46108e79a28372035d5', 0, 1, ' alphanumeric_total:true ', 0),
(352, '700', 'c', 'CDR', 'Títulos y otras palabras asociadas con el nombre', 'text', 0, 1, 0, 2, 1, 1, NULL, '5fdc7d5eb2ad23dd7391f89d7e600bb0', 0, 1, ' alphanumeric_total:true ', 0),
(353, '700', 'd', 'CDR', 'Fechas de nacimiento y muerte', 'text', 0, 1, 0, 2, 1, 1, NULL, '619c8da4a2d0f7c3827ad983fa49da8c', 0, 1, ' alphanumeric_total:true ', 0),
(354, '700', 'e', 'CDR', 'Función', 'text', 0, 1, 0, 2, 1, 1, NULL, '5e647d19341462a3064d17c3b1a39782', 0, 1, ' alphanumeric_total:true ', 0),
(355, '020', 'a', 'CDR', 'ISBN', 'text', 0, 2, 0, 1, 1, 1, NULL, 'fee55477650e11ec9f2fd8c33fbb6255', 0, 1, ' alphanumeric_total:true ', 0),
(356, '041', 'a', 'CDR', 'Idioma', 'combo', 1, 2, 0, 2, 1, 1, 194, 'e380b75c8f6710835714437ee55f813f', 0, 1, ' alphanumeric_total:true ', 0),
(357, '245', 'h', 'CDR', 'Medio', 'combo', 1, 2, 0, 3, 1, 1, 195, '530f094bc48c793b573de0ee5fd44922', 0, 1, ' alphanumeric_total:true ', 0),
(358, '250', 'a', 'CDR', 'Edición', 'text', 0, 2, 0, 4, 1, 1, NULL, 'd9b0fefab015a978a03dd9498cf12582', 0, 1, ' alphanumeric_total:true ', 0),
(359, '260', 'a', 'CDR', 'Lugar', 'auto', 1, 2, 0, 5, 1, 1, 193, '0f7afc48fc856bef17040062562aca13', 0, 1, ' alphanumeric_total:true ', 0),
(360, '260', 'b', 'CDR', 'Editor', 'text', 0, 2, 0, 6, 1, 1, NULL, '6998617a088c9d0e8db8b72d9a0c9068', 0, 1, ' alphanumeric_total:true ', 0),
(361, '260', 'c', 'CDR', 'Fecha ', 'text', 0, 2, 0, 7, 1, 1, NULL, '900287ea7f144b1b27da72bc5ae56b34', 0, 1, ' alphanumeric_total:true ', 0),
(362, '440', 'a', 'CDR', 'Serie', 'text', 0, 2, 0, 8, 1, 1, NULL, '12d6a978a77fb11fb08cfef18a7b1bcb', 0, 1, ' alphanumeric_total:true ', 0),
(363, '440', 'p', 'CDR', 'Subserie', 'text', 0, 2, 0, 9, 1, 1, NULL, '320848a83845e32f13906866a8bdaad5', 0, 1, ' alphanumeric_total:true ', 0),
(364, '440', 'v', 'CDR', 'Número de la serie', 'text', 0, 2, 0, 10, 1, 1, NULL, '5d1f51d6041efde46e3116712ae1ad77', 0, 1, ' alphanumeric_total:true ', 0),
(365, '500', 'a', 'CDR', 'Nota general ', 'text', 0, 2, 0, 11, 1, 1, NULL, 'c5521745452bfd70c8907ced5f644213', 0, 1, ' alphanumeric_total:true ', 0),
(366, '505', 'a', 'CDR', 'Nota normalizada', 'text', 0, 2, 0, 12, 1, 1, NULL, '1c4a7675af85cab74bc58b105dafe3a6', 0, 1, ' alphanumeric_total:true ', 0),
(367, '505', 'g', 'CDR', 'Volumen', 'text', 0, 2, 0, 13, 1, 1, NULL, 'bbe3ddf7f9d885362518fb826601257e', 0, 1, ' alphanumeric_total:true ', 0),
(368, '505', 't', 'CDR', 'Descripción del volumen', 'text', 0, 2, 0, 14, 1, 1, NULL, '5b28e9f202592c69207905f1dc611cb4', 0, 1, ' alphanumeric_total:true ', 0),
(369, '900', 'b', 'CDR', 'nivel bibliografico', 'combo', 1, 2, 0, 15, 1, 1, 186, 'ee4115f3f164b311d57315cc779631ea', 0, 1, ' alphanumeric_total:true ', 0),
(371, '910', 'a', 'CDR', 'Tipo de documento', 'combo', 1, 2, 1, 7, 1, 1, 189, 'b018ddac638c1d6af58f3e84b34238af', 1, 1, ' alphanumeric_total:true ', 0),
(372, '043', 'c', 'LIB', 'País', 'combo', 1, 2, 0, 23, 1, 1, 197, 'f719c4e32af057260f957c79460ee965', 0, 1, ' alphanumeric_total:true ', 0),
(376, '650', 'a', 'ANA', 'Temas', 'auto', 1, 1, 0, 3, 1, 1, 215, '9d3cf36046777fc75e35b60b672892af', 0, 1, ' alphanumeric_total:true ', 0),
(379, '080', 'a', 'ANA', 'CDU', 'text', 0, 1, 0, 5, 1, 1, NULL, 'b4be3602917b255fc71650c6b4502e67', 0, 1, ' alphanumeric_total:true ', 0),
(382, '653', 'a', 'ANA', 'Palabras claves (no controlado)', 'text', 0, 1, 0, 4, 1, 1, NULL, '7c579257812de2ba5c5cf98db6986ea5', 0, 1, ' alphanumeric_total:true ', 0),
(383, '700', 'a', 'ANA', 'Autor secundario/Colaboradores', 'auto', 1, 1, 0, 4, 1, 1, 207, '22997abb9e23131b7fc77a7dc37beca8', 0, 1, ' alphanumeric_total:true ', 0),
(384, '700', 'e', 'ANA', 'Función', 'text', 0, 1, 0, 4, 1, 1, NULL, '1cae00cebdc27054b19a081cfc8fbf57', 0, 1, ' alphanumeric_total:true ', 0),
(385, '041', 'a', 'ANA', 'Idioma', 'combo', 1, 2, 0, 3, 1, 1, 208, 'ecbf4343e20f8d344f71ce2c184bd914', 0, 1, ' alphanumeric_total:true ', 0),
(391, '910', 'a', 'LIB', 'Tipo de documento', 'combo', 1, 2, 1, 13, 1, 1, 212, '2ac545d0ac9af315d139d38c904cb643', 1, 1, ' alphanumeric_total:true ', 0),
(393, '245', 'b', 'ELE', 'Resto del título', 'text', 0, 1, 0, 2, 1, 1, NULL, '0e9d06e5be41c8e8dd27105d59fe9501', 0, 1, ' alphanumeric_total:true ', 0),
(394, '110', 'a', 'ELE', 'Autor corporativo', 'auto', 1, 1, 0, 2, 1, 1, 220, 'f39871f82d76920d0c9385ab34948f86', 0, 1, ' alphanumeric_total:true ', 0),
(395, '110', 'b', 'ELE', 'Entidad subordinada', 'auto', 1, 1, 0, 3, 1, 1, 221, 'ef79741a7b05365668c1c725c2d23366', 0, 1, ' alphanumeric_total:true ', 0),
(401, '111', 'a', 'ELE', 'Nombre de la reunión', 'text', 0, 1, 0, 4, 1, 1, NULL, '2711d3fa3957d4866942a68337d6d576', 0, 1, ' alphanumeric_total:true ', 0),
(402, '111', 'n', 'ELE', 'Número de la reunión', 'text', 0, 1, 0, 5, 1, 1, NULL, '07ca1e4c318bf51a536189725b440b5e', 0, 1, ' alphanumeric_total:true ', 0),
(403, '111', 'd', 'ELE', 'Fecha de la reunión', 'text', 0, 1, 0, 6, 1, 1, NULL, '2ad33665f1f45296550a46f40a14a429', 0, 1, ' alphanumeric_total:true ', 0),
(404, '111', 'c', 'ELE', 'Lugar de la reunión', 'text', 0, 1, 0, 7, 1, 1, NULL, '6776b988069fc4e96078554001654fba', 0, 1, ' alphanumeric_total:true ', 0),
(405, '650', 'a', 'ELE', 'Temas (controlado)', 'auto', 1, 1, 0, 8, 1, 1, 224, 'fb3d84dd3846f30b32b0b38976a824dd', 0, 1, ' alphanumeric_total:true ', 0),
(406, '653', 'a', 'ELE', 'Palabras claves (no controlado)', 'text', 0, 1, 0, 9, 1, 1, NULL, 'b678e0ae292554094a72a2571c0d11c8', 0, 1, ' alphanumeric_total:true ', 0),
(407, '700', 'a', 'ELE', 'Autor secundario/Colaboradores', 'auto', 1, 1, 0, 10, 1, 1, 223, '1d72d56ab5f7e8f34ecb3c503caaa00f', 0, 1, ' alphanumeric_total:true ', 0),
(408, '700', 'e', 'ELE', 'Función', 'text', 0, 1, 0, 11, 1, 1, NULL, 'c19657299c72a0d1e60c1a16663e5f23', 0, 1, ' alphanumeric_total:true ', 0),
(409, '041', 'a', 'ELE', 'Idioma', 'combo', 1, 2, 0, 1, 1, 1, 225, 'aff5f872f3bf3df88570d547a3e4f025', 0, 1, ' alphanumeric_total:true ', 0),
(410, '043', 'c', 'ELE', 'País', 'combo', 1, 2, 0, 2, 1, 1, 226, 'a035134c45b7dc1dc6ec16dcf611eefa', 0, 1, ' alphanumeric_total:true ', 0),
(411, '245', 'h', 'ELE', 'Medio', 'combo', 1, 2, 0, 3, 1, 1, 227, '2e39bf987edb9f917e613bff3ca19490', 0, 1, ' alphanumeric_total:true ', 0),
(412, '260', 'a', 'ELE', 'Lugar ', 'auto', 1, 2, 0, 4, 1, 1, 228, 'c09a3c4b035a6faecdbcab2f4267ee44', 0, 1, ' alphanumeric_total:true ', 0),
(413, '260', 'b', 'ELE', 'Editor', 'text', 0, 2, 0, 5, 1, 1, NULL, 'c4a21e6bdb9a89450b4c14acc4209b7a', 0, 1, ' alphanumeric_total:true ', 0),
(414, '260', 'c', 'ELE', 'Fecha ', 'text', 0, 2, 0, 6, 1, 1, NULL, '4a34cdecc351107b3bee7004420ba7d6', 0, 1, ' alphanumeric_total:true ', 0),
(415, '300', 'a', 'ELE', 'Páginas', 'text', 0, 2, 0, 7, 1, 1, NULL, 'b633ef10c152201f8c5406b97cdc9019', 0, 1, ' alphanumeric_total:true ', 0),
(416, '500', 'a', 'ELE', 'Nota general ', 'text', 0, 2, 0, 8, 1, 1, NULL, 'da0c83346dc93562ac009c4b7109687a', 0, 1, ' alphanumeric_total:true ', 0),
(417, '900', 'b', 'ELE', 'nivel bibliografico', 'combo', 1, 2, 0, 9, 1, 1, 229, '04fd89e264131a605052d33b861f7dbe', 0, 1, ' alphanumeric_total:true ', 0),
(418, '910', 'a', 'ELE', 'Tipo de documento', 'combo', 1, 2, 1, 6, 1, 1, 230, 'ea8d903dc272eab3544d572778529e55', 1, 1, ' alphanumeric_total:true ', 0),
(419, '863', 'a', 'ELE', 'Volumen', 'text', 0, 2, 0, 11, 1, 1, NULL, 'f86d9bddcd633c5c517fac1a77cb96d2', 0, 1, ' alphanumeric_total:true ', 0),
(420, '863', 'b', 'ELE', 'Número', 'text', 0, 2, 0, 12, 1, 1, NULL, '89e33dc44c448e20b81d33e7722fef86', 0, 1, ' alphanumeric_total:true ', 0),
(421, '863', 'i', 'ELE', 'Año', 'text', 0, 2, 0, 13, 1, 1, NULL, 'cd1bfe2c4c741b21f14e42a71b919092', 0, 1, ' alphanumeric_total:true ', 0),
(422, '100', 'a', 'LIB', 'Autor', 'auto', 1, 1, 0, 2, 1, 1, 282, 'e6e5f6ffdaf060db3d18148da10e18c2', 0, 1, ' digits:true ', 0),
(423, '100', 'a', 'ELE', 'Autor', 'auto', 1, 1, 0, 2, 1, 1, 234, 'c80c9a9eb6ff3d2b538a0af1d25cddd6', 0, 1, ' alphanumeric_total:true ', 0),
(424, '440', 'a', 'ELE', 'Serie', 'text', 0, 2, 0, 14, 1, 1, NULL, '73adf86aa3fee78abc386e1613c114c7', 0, 1, ' alphanumeric_total:true ', 0),
(425, '440', 'p', 'ELE', 'Subserie', 'text', 0, 2, 0, 15, 1, 1, NULL, 'df4b32147a3988867ee4a5be76c98e9e', 0, 1, ' alphanumeric_total:true ', 0),
(426, '440', 'v', 'ELE', 'Número de la serie', 'text', 0, 2, 0, 16, 1, 1, NULL, 'a0bf78317d22720bf5babf1d0569448a', 0, 1, ' alphanumeric_total:true ', 0),
(427, '022', 'a', 'ELE', 'ISSN', 'text', 0, 2, 0, 17, 1, 1, NULL, 'd2b395f0c58866b3e0de362972a8ecfc', 0, 1, ' alphanumeric_total:true ', 0),
(428, '534', 'a', 'LIB', 'Nota/Versión original', 'text', 0, 1, 0, 22, 1, 1, NULL, '74381a3cd860eaec92d76a05b412dc86', 0, 1, ' alphanumeric_total:true ', 0),
(429, '210', 'a', 'REV', 'Título abreviado', 'text', 0, 1, 0, 10, 1, 1, NULL, '8dbde1bbbb84e0604527cbd6aec35fe4', 0, 1, ' alphanumeric_total:true ', 0),
(430, '222', 'a', 'REV', 'Título clave', 'text', 0, 1, 0, 11, 1, 1, NULL, '9c2d22c1f9c98ebd1e91d67ae5d7ec6c', 0, 1, ' alphanumeric_total:true ', 0),
(431, '222', 'b', 'REV', 'Calificador (cualificador)', 'text', 0, 1, 0, 12, 1, 1, NULL, 'cbd483aa663c42f17067d81fd11442d5', 0, 1, ' alphanumeric_total:true ', 0),
(432, '856', 'u', 'ELE', 'URL/URI', 'text', 0, 1, 0, 14, 1, 1, NULL, '11e47f9dc7f2434b1d40ab6a120c555f', 0, 1, ' alphanumeric_total:true ', 0),
(433, '247', 'a', 'REV', 'Título anterior', 'text', 0, 1, 0, 13, 1, 1, NULL, 'f97ec3e9e67a0c13c667883670f39f2b', 0, 1, ' alphanumeric_total:true ', 0),
(434, '247', 'f', 'REV', 'Fecha o designación secuencial ', 'text', 0, 1, 0, 14, 1, 1, NULL, '3712d44e244619fc5d02608a1b05dd2f', 0, 1, ' alphanumeric_total:true ', 0),
(435, '247', 'g', 'REV', 'Información miscelánea ', 'text', 0, 1, 0, 15, 1, 1, NULL, '7747e124b039057ba81c5673b5bf3bd7', 0, 1, ' alphanumeric_total:true ', 0),
(436, '247', 'x', 'REV', 'ISSN ', 'text', 0, 1, 0, 16, 1, 1, NULL, '47118f26e7ff622b348cfab31bc60332', 0, 1, ' alphanumeric_total:true ', 0),
(437, '321', 'a', 'REV', 'Frecuencia anterior de publicación ', 'text', 0, 1, 0, 17, 1, 1, NULL, '727c84a7597ac06669ddf6905962ad4b', 0, 1, ' alphanumeric_total:true ', 0),
(438, '321', 'b', 'REV', 'Fechas de frecuencia anterior de publicación ', 'text', 0, 1, 0, 18, 1, 1, NULL, '7f3eac03346ccdf75e320ca6b16c8359', 0, 1, ' alphanumeric_total:true ', 0),
(442, '245', 'b', 'REV', 'Resto del título', 'text', 0, 1, 0, 19, 1, 1, NULL, 'ff987e541f1901291471d8c232f7edd9', 0, 1, ' alphanumeric_total:true ', 0),
(443, '080', 'a', 'SEM', 'CDU', 'text', 0, 1, 0, 2, 1, 1, NULL, '91d48d06df795565192d01069575f2de', 0, 1, ' alphanumeric_total:true ', 0),
(444, '100', 'a', 'SEM', 'Autor', 'auto', 1, 1, 0, 3, 1, 1, 239, 'a99fa365b6d5983d71a3cb801819356e', 0, 1, ' digits:true ', 0),
(445, '100', 'b', 'SEM', 'Numeración', 'text', 0, 1, 0, 4, 1, 1, NULL, '166914d05f9914a6378f214737a8cb52', 0, 1, ' alphanumeric_total:true ', 0),
(446, '100', 'c', 'SEM', 'Títulos y otras palabras asociadas con el nombre', 'text', 0, 1, 0, 5, 1, 1, NULL, '73dc5edb10bb1e8cd60ccc6fa4368e4d', 0, 1, ' alphanumeric_total:true ', 0),
(447, '100', 'd', 'SEM', 'Fechas asociadas con el nombre ', 'text', 0, 1, 0, 6, 1, 1, NULL, '8b70ecb65ab8ee927985f26675747477', 0, 1, ' alphanumeric_total:true ', 0),
(448, '110', 'a', 'SEM', 'Autor corporativo', 'auto', 1, 1, 0, 7, 1, 1, 240, '8df638839079ba4812ab6ae94f359d0d', 0, 1, ' digits:true ', 0),
(449, '110', 'b', 'SEM', 'Entidad subordinada', 'auto', 1, 1, 0, 8, 1, 1, 241, '39f2a5a7fcd16932854209b13a924ce8', 0, 1, ' digits:true ', 0),
(450, '245', 'b', 'SEM', 'Resto del título', 'text', 0, 1, 0, 9, 1, 1, NULL, 'd60a65446c0e668538130f80aaa4cc83', 0, 1, ' alphanumeric_total:true ', 0),
(451, '534', 'a', 'SEM', 'Nota/Versión original ', 'text', 0, 1, 0, 10, 1, 1, NULL, '884d36c500cb795c826ca12812159ab1', 0, 1, ' alphanumeric_total:true ', 0),
(452, '650', 'a', 'SEM', 'Temas (controlado)', 'auto', 1, 1, 0, 11, 1, 1, 242, '2fb13946cc1f31e4e45f3084e9ed3280', 0, 1, ' digits:true ', 0),
(453, '653', 'a', 'SEM', 'Palabras claves (no controlado)', 'text', 0, 1, 0, 12, 1, 1, NULL, 'e2b06c23ac15e56bc2ec025b7526ae31', 0, 1, ' alphanumeric_total:true ', 0),
(454, '700', 'a', 'SEM', 'Autor secundario/Colaboradores ', 'auto', 1, 1, 0, 13, 1, 1, 243, '74c4b7004e1fa4d305cf11a99faf2922', 0, 1, ' digits:true ', 0),
(455, '700', 'b', 'SEM', 'Número asociado al nombre', 'text', 0, 1, 0, 14, 1, 1, NULL, 'd99091826b2e1d37877fe1e792bb9603', 0, 1, ' alphanumeric_total:true ', 0),
(456, '700', 'c', 'SEM', 'Títulos y otras palabras asociadas con el nombre', 'text', 0, 1, 0, 15, 1, 1, NULL, '517da7c3805c69c75b9880c4b8e7e56c', 0, 1, ' alphanumeric_total:true ', 0),
(457, '700', 'd', 'SEM', 'Fecha de nacimento y muerte ', 'text', 0, 1, 0, 16, 1, 1, NULL, '793097a29726c68c75c4a3e518e4431a', 0, 1, ' alphanumeric_total:true ', 0),
(458, '700', 'e', 'SEM', 'Función', 'text', 0, 1, 0, 17, 1, 1, NULL, '858a0c16d6b7dc1f1edc09a448b417aa', 0, 1, ' alphanumeric_total:true ', 0),
(459, '020', 'a', 'SEM', 'ISBN', 'text', 0, 2, 0, 2, 1, 1, NULL, 'd4d9baacb5d9cc48430e3fbefe585eee', 0, 1, ' alphanumeric_total:true ', 0),
(460, '041', 'a', 'SEM', 'Idioma', 'combo', 1, 2, 0, 3, 1, 1, 244, 'ea6948ee70908327ce917a87b34b8a63', 0, 1, ' digits:true ', 0),
(461, '043', 'c', 'SEM', 'País', 'combo', 1, 2, 0, 4, 1, 1, 245, '5f1b2ebfa02d2be622da1ec0ae608061', 0, 1, ' digits:true ', 0),
(462, '245', 'h', 'SEM', 'Medio', 'combo', 1, 2, 0, 5, 1, 1, 246, '11850d0845f83e1cff14c4b7c12ec7ab', 0, 1, ' digits:true ', 0),
(463, '250', 'a', 'SEM', 'Edición', 'text', 0, 2, 0, 6, 1, 1, NULL, 'eee83eccff01c1c07e040a750c8524f9', 0, 1, ' alphanumeric_total:true ', 0),
(464, '260', 'a', 'SEM', 'Lugar', 'combo', 1, 2, 0, 7, 1, 1, 247, 'ea0b29b65a9fa65495e63f183a867e0d', 0, 1, ' digits:true ', 0),
(465, '260', 'b', 'SEM', 'Editor', 'text', 0, 2, 0, 8, 1, 1, NULL, 'ee87596f741ac2b186288ddb831a2f5c', 0, 1, ' alphanumeric_total:true ', 0),
(466, '260', 'c', 'SEM', 'Fecha', 'text', 0, 2, 0, 9, 1, 1, NULL, 'e39933c43829eaa22c2dccc7d72c5295', 0, 1, ' alphanumeric_total:true ', 0),
(467, '300', 'a', 'SEM', 'Extensión/Páginas', 'text', 0, 2, 0, 10, 1, 1, NULL, 'e2e1018136580c1430cdf68d63de1ab8', 0, 1, ' alphanumeric_total:true ', 0),
(468, '300', 'b', 'SEM', 'Otros detalles físicos', 'text', 0, 2, 0, 11, 1, 1, NULL, '5877ad881a6252df97f45b0a0fcab03b', 0, 1, ' alphanumeric_total:true ', 0),
(469, '300', 'c', 'SEM', 'Dimensiones', 'text', 0, 2, 0, 12, 1, 1, NULL, '07d02141d3c2ed5dca9b4115ecbe6a29', 0, 1, ' alphanumeric_total:true ', 0),
(470, '440', 'a', 'SEM', 'Serie ', 'text', 0, 2, 0, 13, 1, 1, NULL, '0b7b5ca98dea318be167187592b30a41', 0, 1, ' alphanumeric_total:true ', 0),
(471, '440', 'p', 'SEM', 'Subserie', 'text', 0, 2, 0, 14, 1, 1, NULL, '395a42af2332534bd9408b67fb4f1cc0', 0, 1, ' alphanumeric_total:true ', 0),
(472, '440', 'v', 'SEM', 'Número de la serie', 'text', 0, 2, 0, 15, 1, 1, NULL, 'da1855e0a34a6750d37d2454a8b52b80', 0, 1, ' alphanumeric_total:true ', 0),
(473, '500', 'a', 'SEM', 'Nota general', 'text', 0, 2, 0, 16, 1, 1, NULL, 'bc4b1a400cbdf1fdbb7719167571ad49', 0, 1, ' alphanumeric_total:true ', 0),
(474, '505', 'a', 'SEM', 'Nota normalizada', 'text', 0, 2, 0, 17, 1, 1, NULL, '087c1f8614cab0b4087c02a672c5bdcd', 0, 1, ' alphanumeric_total:true ', 0),
(475, '505', 'g', 'SEM', 'Volumen', 'text', 0, 2, 0, 18, 1, 1, NULL, '674c253be860d15b7dcb27ee97ccc0c9', 0, 1, ' alphanumeric_total:true ', 0),
(476, '505', 't', 'SEM', 'Descripción del volumen', 'text', 0, 2, 0, 19, 1, 1, NULL, '684232a770f9f50ccef7cd7729a7d74c', 0, 1, ' alphanumeric_total:true ', 0),
(477, '900', 'b', 'SEM', 'nivel bibliografico', 'combo', 1, 2, 0, 20, 1, 1, 248, 'e41e64f6180b4e7da0ad8c94e0ae032b', 0, 1, ' digits:true ', 0),
(478, '910', 'a', 'SEM', 'Tipo de documento', 'combo', 1, 2, 1, 11, 1, 1, 249, '5aa574f5d26fd89864d2b7b8e66aab25', 1, 1, ' digits:true ', 0),
(479, '041', 'a', 'FOT', 'Idioma', 'combo', 1, 2, 0, 18, 1, 1, 254, '2ee1ac3fffd5d70afdc53eab8d1102be', 0, 1, ' alphanumeric_total:true ', 0),
(480, '043', 'c', 'FOT', 'País', 'combo', 1, 2, 0, 19, 1, 1, 252, '5236b2fa12e780d3fde8f8ff2f04dc7c', 0, 1, ' digits:true ', 0),
(481, '245', 'h', 'FOT', 'Medio', 'combo', 1, 2, 0, 20, 1, 1, 255, 'fe0c12a9997c97284cc15056d43df3f8', 0, 1, ' digits:true ', 0),
(482, '100', 'a', 'ANA', 'Autor', 'auto', 1, 1, 0, 7, 1, 1, 256, '473d23493d6bfb2f8d85fa74355247b6', 0, 1, ' digits:true ', 0),
(484, '856', 'u', 'REV', 'URL/URI', 'text', 0, 1, 0, 20, 1, 1, NULL, '05a718ae024fae5101977ab22da24f6d', 0, 1, ' alphanumeric_total:true ', 0),
(485, '510', 'c', 'ANA', 'Ubicación dentro de la fuente (NR)', 'text', 0, 1, 0, 8, 1, 1, NULL, 'e3ae786bdbbf4a936ce66ef3e40a0793', 0, 1, ' alphanumeric_total:true ', 0),
(495, '900', 'g', 'ALL', 'Carga', 'text', 0, 3, 0, 9, 1, 1, NULL, '5f4501dba83f2874220cc9b19cd00ef8', 0, 1, ' alphanumeric_total:true ', 0),
(496, '900', 'h', 'ALL', 'Modificación/Baja', 'text', 0, 3, 0, 10, 1, 1, NULL, 'b98dec6e4f42ed7a2b3ee327aeb64a38', 0, 1, ' alphanumeric_total:true ', 0),
(497, '900', 'i', 'ALL', 'Notas del catalogador', 'texta', 0, 3, 0, 11, 1, 1, NULL, '844feb9851dab2abf4a22217d1acd79a', 0, 1, ' alphanumeric_total:true ', 0),
(498, '900', 'j', 'ALL', 'Control de registro', 'text', 0, 3, 0, 12, 1, 1, NULL, 'c23b19ef18069b9f15a05e77e0ee2a1a', 0, 1, ' alphanumeric_total:true ', 0),
(501, '995', 'c', 'LIB', 'Unidad de Información', 'combo', 1, 3, 1, 5, 1, 1, 281, '2e9cf9c285fae2c00b1c42d5a97e8aaf', 0, 1, ' alphanumeric_total:true ', 0),
(502, '995', 'd', 'LIB', 'Unidad de Información de Origen', 'combo', 1, 3, 1, 6, 1, 1, 280, 'd9630ffad0054eba402aa75bbf853ac8', 0, 1, ' alphanumeric_total:true ', 0),
(503, '245', 'b', 'ANA', 'Resto del título (NR)', 'text', 0, 1, 0, 10, 1, 1, NULL, '422dd620757f9e370c9dc75d66663ab5', 0, 1, ' alphanumeric_total:true ', 0),
(504, '859', 'e', 'REV', 'Procedencia', 'text', 0, 2, 0, 18, 1, 1, NULL, '5d8a8db60ef23b3070e2bc84151331e2', 0, 1, ' alphanumeric_total:true ', 0),
(505, '300', 'a', 'LIB', 'Extensión (R)', 'text', 0, 1, 0, 22, 1, 1, NULL, '53a617b4db8b919682ce8b832ca5738a', 0, 1, ' alphanumeric_total:true ', 0),
(506, '500', 'a', 'TES', 'Nota general (NR)', 'text', 0, 2, 0, 9, 1, 1, NULL, '0c0f49c942b12b425287196bc85ec9b2', 0, 1, ' alphanumeric_total:true ', 0),
(507, '910', 'a', 'TES', 'Tipo de documento', 'combo', 1, 2, 1, 10, 1, 1, 275, '638d3dc0e0faf0294476d80e3af02077', 0, 1, ' digits:true ', 0),
(508, '995', 'c', 'ALL', 'Unidad de Información', 'combo', 1, 3, 1, 5, 1, 1, 276, '143935d9a7a13fa47006651f0a30c811', 0, 1, ' digits:true ', 0),
(509, '995', 'd', 'ALL', 'Unidad de Información de Origen', 'combo', 1, 3, 1, 6, 1, 1, 277, 'abae75e9d28b17a939d5987d3b32ea46', 0, 1, ' digits:true ', 0),
(510, '995', 'e', 'ALL', 'Estado', 'combo', 1, 3, 1, 7, 1, 1, 279, 'faa66bd9eed267e6fdd1e1d3a8058934', 0, 1, ' digits:true ', 0),
(511, '995', 'f', 'ALL', 'Código de Barras', 'text', 0, 3, 0, 8, 1, 1, NULL, 'b5dfe1fda14b1063f531a1ac6ba27bcc', 0, 1, ' alphanumeric_total:true ', 0),
(512, '995', 'm', 'ALL', 'Fecha de acceso', 'text', 0, 3, 0, 9, 1, 1, NULL, 'be58c5a2149fcbf70bdf9f5cca4ff7e4', 0, 1, ' alphanumeric_total:true ', 0),
(513, '995', 'o', 'ALL', 'Disponibilidad', 'combo', 1, 3, 1, 10, 1, 1, 278, 'df8af7bf6e82ca41d87359dfee68ce6b', 0, 1, ' digits:true ', 0),
(514, '995', 'p', 'ALL', 'Precio de compra', 'text', 0, 3, 0, 11, 1, 1, NULL, '993015834fea443da73123010db786d9', 0, 1, ' alphanumeric_total:true ', 0),
(515, '995', 't', 'ALL', 'Signatura Topográfica', 'text', 0, 3, 0, 12, 1, 1, NULL, 'c3cc7e32ba65d58db46d05cf769c8fcb', 0, 1, ' alphanumeric_total:true ', 0),
(516, '995', 'u', 'ALL', 'Notas del item', 'texta', 0, 3, 0, 13, 1, 1, NULL, 'ba3cc59c5b706d8d74dd997a03ff2c44', 0, 1, ' alphanumeric_total:true ', 0),
(517, '856', 'u', 'ALL', 'URL/URI', 'text', 0, 1, 0, 2, 1, 1, NULL, '69cdc1146196bce382e8468b2b8da71e', 0, 1, ' alphanumeric_total:true ', 0),
(518, '310', 'a', 'REV', 'Frecuencia', 'text', 0, 1, 0, 22, 1, 1, NULL, '52593085e471cbc2385db33b127bac3e', 0, 1, ' alphanumeric_total:true ', 0),
(519, '020', 'a', 'LIB', 'ISBN', 'text', 0, 1, 0, 24, 1, 1, NULL, '01f5c03ff814761c1608c7f51671154c', 0, 1, ' alphanumeric_total:true ', 0),
(521, '022', 'a', 'REV', 'ISSN', 'text', 0, 2, 0, 17, 1, 1, NULL, '8870936569bbcccfa2ea0bbb0184fa62', 0, 1, ' alphanumeric_total:true ', 0),
(522, '300', 'a', 'ANA', 'Páginas', 'text', 0, 1, 0, 11, 1, 1, NULL, '0a12da437ffbb62e8d5d20660166cb85', 0, 1, ' alphanumeric_total:true ', 0),
(523, '245', 'b', 'TES', 'Resto del título', 'text', 0, 1, 0, 10, 1, 1, NULL, '39ae4cb5746a5a7f774e46222108b99b', 0, 1, ' alphanumeric_total:true ', 0),
(524, '856', 'u', 'REV', 'URL', 'text', 0, 2, 0, 14, 1, 1, NULL, '6cdd459cb7caaf4c55c5178b8c5c4d56', 0, 1, ' alphanumeric_total:true ', 0),
(525, '520', 'a', 'LIB', 'Nota de resumen', 'texta', 0, 1, 0, 25, 1, 1, NULL, '2ea98806ce4e42d6659319ed75427267', 0, 1, ' alphanumeric_total:true ', 0);

--
-- Volcar la base de datos para la tabla `cat_visualizacion_intra`
--

INSERT INTO `cat_visualizacion_intra` (`id`, `campo`, `pre`, `inter`, `post`, `subcampo`, `vista_intra`, `tipo_ejemplar`, `orden`, `nivel`, `vista_campo`, `orden_subcampo`) VALUES
(836, '245', NULL, NULL, NULL, 'a', 'Título', 'ALL', 188, 1, 'Titulo', 1),
(837, '245', NULL, NULL, NULL, 'b', 'Resto del título', 'ALL', 188, 1, 'Titulo', 3),
(838, '250', NULL, NULL, NULL, 'a', 'Edición', 'LIB', 38, 2, 'Edición', 0),
(839, '260', ':&nbsp;', NULL, NULL, 'b', 'Editor', 'LIB', 54, 2, 'Lugar, editor y fecha', 2),
(840, '300', NULL, NULL, NULL, 'a', 'Descripción física', 'LIB', 346, 2, 'Páginas', 0),
(841, '440', '.&nbsp;', NULL, NULL, 'p', 'Subserie', 'LIB', 216, 2, 'Serie', 2),
(842, '440', '&nbsp;;&nbsp', NULL, NULL, 'v', 'Número', 'LIB', 216, 2, 'Serie', 3),
(843, '500', NULL, NULL, NULL, 'a', 'Notas', 'LIB', 244, 2, 'Nota general', 0),
(844, '505', NULL, NULL, NULL, 'a', 'Nota normalizada', 'LIB', 40, 2, 'Volumen/descripción', 0),
(845, '500', NULL, NULL, NULL, 'a', 'Notas', 'REV', 244, 2, 'Nota general', 0),
(846, '041', NULL, NULL, NULL, 'a', 'Idioma', 'REV', 66, 2, 'Idioma', 2),
(847, '362', NULL, NULL, NULL, 'a', 'Situación de la publicación', 'REV', 58, 2, 'Fecha de inicio - cese', 0),
(848, '910', NULL, NULL, NULL, 'a', 'Tipo de Documento', 'REV', 251, 2, NULL, 0),
(849, '650', ' -', NULL, ' -', 'a', 'Término controlado', 'ALL', 199, 1, 'Temas', 0),
(850, '653', ' -', NULL, ' -', 'a', 'Palabras claves (no controlado)', 'ALL', 298, 1, 'Palabras claves', 1),
(851, '245', ']', NULL, ']', 'h', 'DGM', 'LIB', 188, 1, 'TÍTULO PROPIAMENTE DICHO (NR)', 2),
(852, '110', NULL, NULL, NULL, 'b', 'Entidad subordinada', 'LIB', 78, 1, 'Autor corporativo', 2),
(853, '995', NULL, NULL, NULL, 'c', 'Unidad de Información', 'LIB', 309, 3, 'Datos del Ejemplar', 88),
(854, '995', NULL, NULL, NULL, 'd', 'Unidad de Información de Origen', 'LIB', 309, 3, 'Datos del Ejemplar', 89),
(855, '995', NULL, NULL, NULL, 'e', 'Estado', 'LIB', 309, 3, 'Datos del Ejemplar', 90),
(856, '995', NULL, NULL, NULL, 'f', 'Código de Barras', 'LIB', 309, 3, 'Datos del Ejemplar', 91),
(857, '995', NULL, NULL, NULL, 'o', 'Disponibilidad', 'LIB', 309, 3, 'Datos del Ejemplar', 92),
(858, '995', NULL, NULL, NULL, 't', 'Signatura Topográfica', 'LIB', 309, 3, 'Datos del Ejemplar', 93),
(859, '210', NULL, NULL, NULL, 'a', 'Título abreviado (NR)', 'REV', 78, 1, 'Titulo abreviado', 101),
(860, '222', NULL, NULL, NULL, 'a', 'Título clave (NR)', 'REV', 101, 1, 'Título clave', 102),
(861, '222', NULL, NULL, NULL, 'b', 'Calificador (o cualificador)', 'REV', 101, 1, 'Título clave', 103),
(862, '240', NULL, NULL, NULL, 'a', 'Título uniforme (NR)', 'REV', 102, 1, 'Título uniforme', 103),
(863, '246', NULL, NULL, NULL, 'a', 'Variantes del título', 'REV', 104, 1, 'Variantes del título', 105),
(864, '246', NULL, NULL, NULL, 'f', 'Designación del volumen, número, fecha', 'REV', 104, 1, 'Variantes del título', 106),
(865, '247', NULL, NULL, NULL, 'a', 'Título anterior', 'REV', 105, 1, 'Título anterior', 107),
(866, '247', NULL, NULL, NULL, 'f', 'Fecha o designación secuencial (NR)', 'REV', 105, 1, 'Título anterior', 108),
(867, '247', NULL, NULL, NULL, 'g', 'Información miscelánea (NR)', 'REV', 105, 1, 'Título anterior', 109),
(868, '247', NULL, NULL, NULL, 'x', 'ISSN (NR)', 'REV', 105, 1, 'Título anterior', 110),
(869, '700', NULL, NULL, NULL, 'e', 'Función', 'REV', 77, 1, 'Autores secundarios/Colaboradores', 3),
(870, '321', NULL, NULL, NULL, 'a', 'Frecuencia anterior de publicación (NR)', 'REV', 116, 1, 'Frecuencia anterior', 128),
(871, '321', NULL, NULL, NULL, 'b', 'Fechas de frecuencia anterior de publicación (NR)', 'REV', 116, 1, 'Frecuencia anterior', 129),
(872, '700', NULL, NULL, NULL, 'a', 'Autor secundario/Colaborador', 'FOT', 77, 1, 'Autores secundarios/Colaboradores', 1),
(873, '250', NULL, NULL, NULL, 'a', 'Edición', 'FOT', 38, 2, 'Edición', 149),
(874, '300', NULL, NULL, NULL, 'a', 'Descripción física', 'FOT', 346, 2, 'Páginas', 150),
(875, '440', NULL, NULL, NULL, 'a', 'Serie', 'FOT', 216, 2, 'Serie', 1),
(876, '500', NULL, NULL, NULL, 'a', 'Nota general', 'FOT', 244, 2, 'Nota general', 152),
(877, '773', NULL, NULL, NULL, 'a', 'Título (documento fuente)', 'FOT', 66, 2, 'Analíticas', 153),
(878, '773', NULL, NULL, NULL, 'd', 'Lugar, editor y fecha de la parte mayor', 'FOT', 66, 2, 'Analíticas', 154),
(879, '773', NULL, NULL, NULL, 'g', 'Ubicación de la parte', 'FOT', 66, 2, 'Analíticas', 155),
(880, '773', NULL, NULL, NULL, 't', 'Título y mención de la parte mayor', 'FOT', 66, 2, 'Analíticas', 156),
(881, '300', NULL, NULL, NULL, 'a', 'Descripción física', 'DCA', 346, 2, 'Páginas', 160),
(882, '440', NULL, NULL, NULL, 'a', 'Serie', 'DCA', 216, 2, 'Serie', 161),
(883, '700', NULL, NULL, NULL, 'a', 'Autor secundario', 'TES', 77, 1, 'Autores secundarios/Colaboradores', 164),
(884, '300', NULL, NULL, NULL, 'a', 'Extensión/Páginas', 'TES', 346, 2, 'Páginas', 165),
(885, '700', NULL, NULL, NULL, 'a', 'Autor secundario/Colaboradores', 'DCA', 77, 1, 'Autores secundarios/Colaboradores', 167),
(886, '041', NULL, NULL, NULL, 'a', 'Idioma', 'DCA', 66, 2, 'Idioma', 168),
(887, '500', NULL, NULL, NULL, 'a', 'Nota general', 'DCA', 244, 2, 'Nota general', 169),
(888, '910', NULL, NULL, NULL, 'a', 'Tipo de documento', 'DCA', 251, 2, 'Tipo de documento', 171),
(889, '900', NULL, NULL, NULL, 'b', 'Nivel bibliografico', 'DCA', 250, 2, 'Nivel bibliográfico', 172),
(890, '502', NULL, NULL, NULL, 'a', 'Nota de tesis', 'TES', 192, 2, 'Nota de tesis', 173),
(891, '502', NULL, NULL, NULL, 'b', 'Tipo de grado', 'TES', 192, 2, 'Nota de tesis', 174),
(892, '502', NULL, NULL, NULL, 'c', 'Nombre de la institución otorgante', 'TES', 192, 2, 'Nota de tesis', 175),
(893, '502', NULL, NULL, NULL, 'd', 'Año de grado otorgado', 'TES', 192, 2, 'Nota de tesis', 176),
(894, '100', NULL, NULL, NULL, 'a', 'Autor', 'TES', 1, 1, 'Autor', 1),
(895, '110', NULL, NULL, NULL, 'a', 'Autor corporativo', 'REV', 78, 1, 'Autor corporativo', 1),
(896, '863', NULL, NULL, NULL, 'a', 'Volumen', 'REV', 65, 2, 'Año, Vol., Número', 2),
(897, '863', '(', NULL, ')', 'b', 'Número', 'REV', 65, 2, 'Año, Vol., Número', 3),
(898, '863', NULL, NULL, NULL, 'i', 'Año', 'REV', 65, 2, 'Año, Vol., Número', 1),
(899, '100', NULL, NULL, NULL, 'a', 'Autor', 'FOT', 1, 1, 'Autor', 181),
(900, '100', ')', NULL, ')', 'd', 'Fechas de nacimiento y muerte', 'FOT', 1, 1, 'Autor', 184),
(901, '110', NULL, NULL, NULL, 'a', 'Autor corporativo', 'FOT', 78, 1, 'Autor corporativo', 185),
(902, '110', NULL, NULL, NULL, 'b', 'Entidad subordinada', 'FOT', 78, 1, 'Autor corporativo', 186),
(903, '700', ')', NULL, ')', 'e', 'Función', 'FOT', 77, 1, 'Autores secundarios/Colaboradores', 2),
(904, '110', NULL, NULL, NULL, 'a', 'Autor corporativo', 'LIB', 78, 1, 'Autor corporativo', 1),
(905, '260', NULL, NULL, NULL, 'b', 'Editor', 'FOT', 54, 2, 'Lugar, editor y fecha', 2),
(906, '020', NULL, NULL, NULL, 'a', 'ISBN', 'FOT', 221, 2, 'ISBN', 188),
(907, '505', NULL, NULL, NULL, 'a', 'Nota normalizada', 'FOT', 40, 2, 'Volumen/descripción', 191),
(908, '250', NULL, NULL, NULL, 'a', 'Edición', 'TES', 38, 2, 'Edición', 187),
(909, '020', NULL, NULL, NULL, 'a', 'ISBN', 'TES', 221, 2, 'ISBN', 193),
(910, '500', NULL, NULL, NULL, 'a', 'Nota general', 'TES', 244, 2, 'Nota general', 194),
(911, '111', NULL, NULL, NULL, 'a', 'Nombre de la reunión', 'LIB', 195, 1, 'Congresos, conferencias, etc.', 195),
(912, '111', NULL, NULL, NULL, 'n', 'Número de la reunión', 'LIB', 195, 1, 'Congresos, conferencias, etc.', 196),
(913, '111', NULL, NULL, NULL, 'd', 'Fecha de la reunión', 'LIB', 195, 1, 'Congresos, conferencias, etc.', 197),
(914, '111', NULL, NULL, NULL, 'c', 'Lugar de la reunión', 'LIB', 195, 1, 'Congresos, conferencias, etc.', 198),
(915, '700', '-', NULL, '-', 'a', 'Autor secundario/Colaborador', 'LIB', 77, 1, 'Autores secundarios/Colaboradores', 1),
(916, '700', ')', NULL, ')', 'e', 'Función', 'LIB', 77, 1, 'Autores secundarios/Colaboradores', 5),
(917, '111', NULL, NULL, NULL, '-', 'Autor secundario/Colaborador', 'FOT', 195, 1, 'Congresos, conferencias, etc.', 200),
(918, '111', NULL, NULL, NULL, 'n', 'Número de la reunión', 'FOT', 195, 1, 'Congresos, conferencias, etc.', 201),
(919, '111', NULL, NULL, NULL, 'd', 'Fecha de la reunión', 'FOT', 195, 1, 'Congresos, conferencias, etc.', 202),
(920, '111', NULL, NULL, NULL, 'c', 'Lugar de la reunión', 'FOT', 195, 1, 'Congresos, conferencias, etc.', 203),
(921, '505', 'v.&nbsp;', NULL, NULL, 'g', 'Volumen', 'LIB', 40, 2, 'Volumen/descripción', 205),
(922, '505', ':&nbsp;', NULL, NULL, 't', 'Descripción del volumen', 'LIB', 40, 2, 'Volumen/descripción', 206),
(923, '505', NULL, NULL, NULL, 'g', 'Volumen', 'FOT', 40, 2, 'Volumen/descripción', 207),
(924, '505', NULL, NULL, NULL, 't', 'Descripción del volumen', 'FOT', 40, 2, 'Volumen/descripción', 208),
(925, '260', NULL, NULL, NULL, 'b', 'Editor', 'REV', 54, 2, 'Lugar y editor', 2),
(926, '260', ',&nbsp;', NULL, NULL, 'c', 'Fecha', 'LIB', 54, 2, 'Lugar, editor y fecha', 3),
(927, '043', NULL, NULL, NULL, 'c', 'País', 'LIB', 43, 2, 'País', 216),
(928, '534', '&nbsp;', NULL, NULL, 'a', 'Nota/versión original', 'LIB', 217, 1, 'Nota/versión original', 217),
(929, '100', NULL, NULL, NULL, 'a', 'Autor', 'ANA', 1, 1, 'Autor', 218),
(930, '440', NULL, NULL, NULL, 'v', 'Número de la serie', 'FOT', 216, 2, 'Serie', 219),
(931, '440', NULL, NULL, NULL, 'p', 'Subserie', 'FOT', 216, 2, 'Serie', 220),
(932, '440', NULL, NULL, NULL, 'a', 'Serie', 'LIB', 216, 2, 'Serie', 1),
(933, '700', NULL, NULL, NULL, 'a', 'Autor secundario/Colaboradores', 'ANA', 77, 1, 'Autores secundarios/Colaboradores', 222),
(934, '700', NULL, NULL, NULL, 'e', 'Función', 'ANA', 77, 1, 'Autores secundarios/Colaboradores', 223),
(935, '110', NULL, NULL, NULL, 'a', 'Autor corporativo', 'ANA', 78, 1, 'Autor corporativo', 223),
(936, '110', NULL, NULL, NULL, 'b', 'Entidad subordinada', 'ANA', 78, 1, 'Autor corporativo', 224),
(937, '041', NULL, NULL, NULL, 'a', 'Idioma', 'ANA', 66, 2, 'Idioma', 225),
(938, '100', NULL, NULL, NULL, 'a', 'Autor', 'ELE', 1, 1, 'Autor', 226),
(939, '110', NULL, NULL, NULL, 'a', 'Autor corporativo', 'ELE', 78, 1, 'Autor corporativo', 228),
(940, '110', NULL, NULL, NULL, 'b', 'Entidad subordinada', 'ELE', 78, 1, 'ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)', 229),
(941, '111', '.', NULL, '.', 'a', 'Nombre de la reunión', 'ELE', 195, 1, 'Congresos, conferencias, etc.', 230),
(942, '111', NULL, NULL, NULL, 'n', 'Número de la reunión', 'ELE', 195, 1, 'Congresos, conferencias, etc.', 231),
(943, '111', NULL, NULL, NULL, 'd', 'Fecha de la reunión', 'ELE', 195, 1, 'Congresos, conferencias, etc.', 232),
(944, '111', NULL, NULL, NULL, 'c', 'Lugar de la reunión', 'ELE', 195, 1, 'Congresos, conferencias, etc.', 233),
(945, '260', NULL, NULL, NULL, 'a', 'Lugar', 'ELE', 54, 2, 'Lugar, editor y fecha', 231),
(946, '260', NULL, NULL, NULL, 'b', 'Editor', 'ELE', 54, 2, 'Lugar, editor y fecha', 232),
(947, '260', NULL, NULL, NULL, 'c', 'Fecha', 'ELE', 54, 2, 'Lugar, editor y fecha', 233),
(948, '043', NULL, NULL, NULL, 'c', 'País', 'ELE', 43, 2, 'País', 234),
(949, '500', NULL, NULL, NULL, 'a', 'Nota general', 'ELE', 244, 2, 'Nota general', 235),
(950, '863', NULL, NULL, NULL, 'a', 'Volumen', 'ELE', 65, 2, 'Año, vol. y nro.', 2),
(951, '863', ')', NULL, ')', 'b', 'Número', 'ELE', 65, 2, 'Año, vol. y nro.', 3),
(952, '863', NULL, NULL, NULL, 'i', 'Año', 'ELE', 65, 2, 'Año, vol. y nro.', 1),
(953, '700', ' -', NULL, ' -', 'a', 'Autor secundario/Colaboradores', 'ELE', 77, 1, 'Autores secundarios/Colaboradores', 239),
(954, '260', NULL, NULL, NULL, 'a', 'Lugar', 'LIB', 54, 2, 'Lugar, editor y fecha', 1),
(955, '440', NULL, NULL, NULL, 'a', 'Serie', 'ELE', 216, 2, 'Serie', 245),
(956, '440', NULL, NULL, NULL, 'p', 'Subserie', 'ELE', 216, 2, 'Serie', 246),
(957, '440', NULL, NULL, NULL, 'v', 'Número de la serie', 'ELE', 216, 2, 'Serie', 247),
(958, '022', NULL, NULL, NULL, 'a', 'ISSN', 'ELE', 255, 2, 'ISSN', 248),
(959, '080', NULL, NULL, NULL, 'a', 'CDU', 'LIB', 249, 1, 'CDU', 249),
(960, '910', NULL, NULL, NULL, 'a', 'Tipo de documento', 'LIB', 251, 2, 'Tipo de documento', 250),
(961, '900', NULL, NULL, NULL, 'b', 'nivel bibliografico', 'LIB', 250, 2, 'Nivel Bibliográfico', 251),
(962, '856', NULL, NULL, NULL, 'u', 'URL/URI', 'ELE', 349, 1, 'URL/URI', 252),
(963, '020', NULL, NULL, NULL, 'a', 'ISBN', 'ELE', 221, 2, 'ISBN', 253),
(964, '300', NULL, NULL, NULL, 'a', 'Extensión/Páginas', 'ELE', 346, 2, 'Páginas', 253),
(965, '260', NULL, NULL, ':&nbsp;', 'a', 'Lugar', 'REV', 54, 2, 'Lugar y editor', 1),
(966, '440', ')', NULL, ')', 'a', 'Serie', 'REV', 216, 2, 'Serie', 256),
(967, '900', NULL, NULL, NULL, 'b', 'nivel bibliografico', 'REV', 250, 2, 'Nivel Bibliográfico', 258),
(968, '502', NULL, NULL, NULL, 'a', 'Nota de tesis', 'ELE', 259, 2, 'Nota de tesis', 259),
(969, '502', NULL, NULL, NULL, 'b', 'Grado', 'ELE', 260, 2, 'Nota de tesis', 260),
(970, '502', NULL, NULL, NULL, 'c', 'Institución', 'ELE', 261, 2, 'Nota de tesis', 261),
(971, '502', NULL, NULL, NULL, 'd', 'Año', 'ELE', 262, 2, 'Nota de tesis', 262),
(972, '100', NULL, NULL, NULL, 'a', 'Autor', 'SEM', 1, 1, 'Autor', 264),
(973, '110', NULL, NULL, NULL, 'a', 'Autor corporativo', 'SEM', 78, 1, 'Autor corporativo', 268),
(974, '100', ')', NULL, ')', 'd', 'Fechas de nacimiento y muerte', 'SEM', 1, 1, 'ASIENTO PRINCIPAL - NOMBRE PERSONAL (NR)', 269),
(975, '110', NULL, NULL, NULL, 'b', 'Entidad subordinada', 'SEM', 78, 1, 'ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)', 270),
(976, '080', NULL, NULL, NULL, 'a', 'CDU', 'SEM', 249, 1, 'CDU', 269),
(977, '250', NULL, NULL, NULL, 'a', 'Edición', 'SEM', 38, 2, 'Edición', 270),
(978, '505', NULL, NULL, NULL, 'a', 'Nota normalizada', 'SEM', 40, 2, 'Nota normalizada', 271),
(979, '505', NULL, NULL, NULL, 'g', 'Volumen', 'SEM', 40, 2, 'NOTA DE CONTENIDOS FORMATEADA (R)', 272),
(980, '505', NULL, NULL, NULL, 't', 'Descripción del volumen', 'SEM', 40, 2, 'NOTA DE CONTENIDOS FORMATEADA (R)', 273),
(981, '260', NULL, NULL, NULL, 'a', 'Lugar', 'SEM', 54, 2, 'Lugar, editor y fecha', 274),
(982, '260', NULL, NULL, NULL, 'b', 'Editor', 'SEM', 54, 2, 'Lugar, editor y fecha', 275),
(983, '260', NULL, NULL, NULL, 'c', 'Fecha', 'SEM', 54, 2, 'Lugar, editor y fecha', 276),
(984, '440', NULL, NULL, NULL, 'a', 'Serie', 'SEM', 216, 2, 'Serie', 277),
(985, '440', NULL, NULL, NULL, 'p', 'Subserie', 'SEM', 216, 2, 'MENCIÓN DE SERIE/ASIENTO AGREGADA - TÍTULO (R) [OBSOLETE]', 278),
(986, '440', NULL, NULL, NULL, 'v', 'Número de la serie', 'SEM', 216, 2, 'MENCIÓN DE SERIE/ASIENTO AGREGADA - TÍTULO (R) [OBSOLETE]', 279),
(987, '043', NULL, NULL, NULL, 'c', 'País', 'SEM', 43, 2, 'País', 280),
(988, '300', NULL, NULL, NULL, 'a', 'Páginas', 'SEM', 346, 2, 'Páginas', 281),
(989, '900', NULL, NULL, NULL, 'b', 'nivel bibliografico', 'SEM', 250, 2, 'Nivel Bibliográfico', 282),
(990, '500', NULL, NULL, NULL, 'a', 'Nota general', 'SEM', 244, 2, 'NOTA GENERAL (R)', 283),
(991, '910', NULL, NULL, NULL, 'a', 'Tipo de documento', 'SEM', 251, 2, 'Tipo de documento', 284),
(992, '856', NULL, NULL, NULL, 'u', 'URL/URI', 'SEM', 349, 3, 'URI/URL', 285),
(993, '995', NULL, NULL, NULL, 'c', 'Unidad de Información', 'SEM', 309, 3, 'Datos del Ejemplar', 286),
(994, '995', NULL, NULL, NULL, 'd', 'Unidad de Información de Origen', 'SEM', 309, 3, 'Datos del Ejemplar', 287),
(995, '995', NULL, NULL, NULL, 'e', 'Estado', 'SEM', 309, 3, 'Datos del Ejemplar', 288),
(996, '995', NULL, NULL, NULL, 'f', 'Código de Barras', 'SEM', 309, 3, 'Datos del Ejemplar', 289),
(997, '995', NULL, NULL, NULL, 'm', 'Fecha de acceso', 'SEM', 309, 3, 'Datos del Ejemplar', 290),
(998, '995', NULL, NULL, NULL, 'o', 'Disponibilidad', 'SEM', 309, 3, 'Datos del Ejemplar', 291),
(999, '995', NULL, NULL, NULL, 't', 'Signatura Topográfica', 'SEM', 309, 3, 'Datos del Ejemplar', 292),
(1000, '995', NULL, NULL, NULL, 'u', 'Notas del item', 'SEM', 309, 3, 'Datos del Ejemplar', 293),
(1001, '520', NULL, NULL, NULL, 'a', 'Nota de resumen', 'LIB', 324, 1, 'Resumen', 294),
(1002, '520', NULL, NULL, NULL, 'a', 'Nota de resumen', 'ELE', 324, 1, 'Resumen', 295),
(1003, '520', NULL, NULL, NULL, 'a', 'Nota de resumen', 'DCD', 324, 1, 'Resumen', 296),
(1004, '520', NULL, NULL, NULL, 'a', 'Nota de resumen', 'REV', 324, 1, 'Resumen', 297),
(1005, '700', ')', NULL, ')', 'e', 'Función', 'TES', 77, 1, 'ASIENTO ADICIONAL DEL TÍTULO - NOMBRE PERSONAL (R)', 298),
(1006, '520', NULL, NULL, NULL, 'a', 'Nota de resumen', 'TES', 324, 1, 'Nota de resumen', 299),
(1007, '700', ')', NULL, ')', 'e', 'Función', 'ELE', 77, 1, 'ASIENTO ADICIONAL DEL TÍTULO - NOMBRE PERSONAL (R)', 300),
(1008, '995', NULL, NULL, NULL, 't', 'Signatura Topográfica', 'ANA', 309, 1, 'Signatura topográfica', 301),
(1009, '856', NULL, NULL, NULL, 'u', 'URL/URI', 'REV', 349, 2, 'URL/URI', 311),
(1010, '510', NULL, NULL, NULL, 'c', 'Ubicación dentro de la fuente (NR)', 'ANA', 333, 1, 'Ubicación dentro de la fuente', 312),
(1011, '856', NULL, NULL, NULL, 'u', 'URL/URI', 'LIB', 349, 1, 'URL/URI', 313),
(1012, '300', NULL, NULL, NULL, 'a', 'Páginas', 'ANA', 346, 1, 'Páginas', 318),
(1013, '859', NULL, NULL, NULL, 'e', 'Procedencia', 'REV', 344, 2, 'Procedencia', 334),
(1014, '856', NULL, NULL, NULL, 'u', 'URL/URI', 'ALL', 349, 1, 'URL/URI', 335),
(1015, '022', NULL, NULL, NULL, 'a', 'ISSN', 'REV', 255, 2, 'ISSN', 342),
(1016, '310', NULL, NULL, NULL, 'a', 'Frecuencia', 'REV', 107, 1, 'Frecuencia', 345),
(1017, '020', NULL, NULL, NULL, 'a', 'ISBN', 'LIB', 221, 2, 'ISBN', 346),
(1018, '100', NULL, NULL, NULL, 'a', 'Autor', 'LIB', 1, 1, 'Autor', 347);

--
-- Volcar la base de datos para la tabla `cat_visualizacion_opac`
--

INSERT  INTO `cat_visualizacion_opac` (`id`, `campo`, `tipo_ejemplar`, `pre`, `inter`, `post`, `subcampo`, `vista_opac`, `vista_campo`, `orden`, `orden_subcampo`, `nivel`) VALUES
(215, '245', 'ALL', NULL, NULL, NULL, 'a', 'Título', 'Título', 65, 1, 1),
(216, '245', 'ALL', NULL, NULL, NULL, 'b', 'Resto del título', 'Título', 65, 3, 1),
(217, '260', 'ALL', NULL, NULL, ' :', 'a', 'Lugar', 'Lugar, editor y fecha', 19, 1, 2),
(218, '995', 'ALL', NULL, NULL, NULL, 'd', 'Unidad de Información de Origen', ' ', 128, 0, 3),
(219, '910', 'ALL', NULL, NULL, NULL, 'a', 'Tipo de Documento', ' ', 130, 0, 2),
(220, '440', 'ALL', NULL, NULL, NULL, 'a', 'Serie', 'Serie', 46, 0, 2),
(221, '650', 'ALL', NULL, NULL, NULL, 'a', 'Tema', 'Temas', 132, 0, 1),
(222, '260', 'ALL', ':&nbsp;', NULL, ',', 'b', 'Editor', 'Lugar, editor y fecha', 19, 2, 2),
(223, '995', 'LIB', NULL, NULL, NULL, 't', 'Signatura Topográfica', ' ', 128, 0, 3),
(224, '110', 'LIB', NULL, NULL, NULL, '-', 'Autor corporativo', 'Autor corporativo', 34, 34, 1),
(225, '653', 'LIB', NULL, NULL, NULL, '-', 'Palabras claves', 'Palabras claves', 50, 36, 1),
(226, '080', 'LIB', NULL, NULL, NULL, 'a', 'CDU', 'CDU', 135, 37, 1),
(227, '250', 'LIB', NULL, NULL, NULL, 'a', 'Edición', 'Edición', 6, 39, 2),
(228, '300', 'LIB', NULL, NULL, NULL, 'a', 'Extensión/Páginas', 'Páginas', 43, 43, 2),
(229, '440', 'LIB', '.&nbsp;', NULL, ' ;', 'p', 'Subserie', 'Serie', 46, 44, 2),
(230, '440', 'LIB', '&nbsp;;&nbsp', NULL, ')', 'v', 'Número de la serie', 'Serie', 46, 45, 2),
(231, '500', 'LIB', NULL, NULL, NULL, 'a', 'Notas', 'Notas', 85, 44, 2),
(232, '111', 'LIB', NULL, NULL, NULL, 'a', 'Nombre de la reunión', 'Nombre de la reunión', 36, 48, 1),
(233, '111', 'LIB', NULL, NULL, NULL, 'n', 'Número de la reunión', 'ASIENTO PRINCIPAL - NOMBRE DE LA REUNIÓN (NR)', 36, 49, 1),
(234, '505', 'LIB', 'v.&nbsp;', NULL, NULL, 'g', 'Volumen', 'Volumen/Descripción', 13, 51, 2),
(235, '505', 'LIB', ':&nbsp;', NULL, NULL, 't', 'Descripción del volumen', 'Volumen/Descripción', 13, 52, 2),
(236, '110', 'CDR', NULL, NULL, NULL, 'a', 'Autor corporativo', 'Autor corporativo', 34, 53, 1),
(237, '110', 'CDR', NULL, NULL, NULL, 'b', 'Entidad subordinada', 'ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)', 34, 54, 1),
(238, '653', 'CDR', NULL, NULL, NULL, 'a', 'Palabras claves', 'Palabras claves', 50, 55, 1),
(239, '245', 'LIB', NULL, NULL, NULL, 'h', 'Medio', 'TÍTULO PROPIAMENTE DICHO (NR)', 65, 60, 1),
(240, '534', 'LIB', NULL, NULL, NULL, 'a', 'Nota/versión original', 'Nota/versión original', 37, 61, 1),
(241, '022', 'ELE', NULL, NULL, NULL, 'a', 'ISSN', 'ISSN', 108, 62, 2),
(242, '700', 'ELE', NULL, NULL, NULL, 'a', 'Autor secundario/Colaboradores', 'Autores secundarios/Colaboradores', 25, 1, 1),
(243, '110', 'LEG', NULL, NULL, NULL, 'a', 'Autor corporativo', 'ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)', 34, 79, 1),
(244, '110', 'LIB', NULL, NULL, NULL, 'a', 'Autor corporativo', 'ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)', 34, 66, 1),
(245, '110', 'LIB', NULL, NULL, NULL, 'b', 'Entidad subordinada', 'ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)', 34, 67, 1),
(246, '043', 'LIB', NULL, NULL, NULL, 'c', 'País', 'País', 42, 66, 2),
(247, '110', 'REV', NULL, NULL, NULL, 'a', 'Autor corporativo', 'Autor corporativo', 34, 86, 1),
(248, '110', 'REV', NULL, NULL, NULL, 'b', 'Entidad subordinada', 'ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)', 34, 87, 1),
(249, '210', 'REV', NULL, NULL, NULL, 'a', 'Título abreviado', 'Título abreviado', 90, 88, 1),
(250, '222', 'REV', NULL, NULL, NULL, 'b', 'Calificador (cualificador)', 'Título clave', 91, 90, 1),
(251, '240', 'REV', NULL, NULL, NULL, 'a', 'Título uniforme', 'Título uniforme', 92, 91, 1),
(252, '246', 'REV', NULL, NULL, NULL, 'a', 'Variante del título', 'Variantes del título', 113, 92, 1),
(253, '100', 'ELE', NULL, NULL, NULL, 'a', 'Autor', 'Autor', 1, 93, 1),
(254, '110', 'ELE', NULL, NULL, NULL, 'a', 'Autor corporativo', 'Autor corporativo', 34, 94, 1),
(255, '653', 'ELE', NULL, NULL, NULL, 'a', 'Palabras claves (no controlado)', 'Palabras claves', 50, 95, 1),
(256, '856', 'ELE', NULL, NULL, NULL, 'u', 'URL/URI', 'URL/URI', 136, 96, 1),
(257, '043', 'ELE', NULL, NULL, NULL, 'c', 'País', 'País', 42, 97, 2),
(258, '500', 'ELE', NULL, NULL, NULL, 'a', 'Nota general', 'Nota general', 85, 98, 2),
(259, '863', 'ELE', NULL, NULL, NULL, 'i', 'Año', 'Año, vol., nro.', 19, 99, 2),
(260, '863', 'ELE', NULL, NULL, NULL, 'a', 'Volumen', 'Año, vol., nro.', 19, 100, 2),
(261, '863', 'ELE', ')', NULL, ')', 'b', 'Número', 'Año, vol., nro.', 19, 101, 2),
(262, '300', 'ELE', NULL, NULL, NULL, 'a', 'Extensión/Páginas', 'Páginas', 43, 102, 2),
(263, '310', 'REV', NULL, NULL, NULL, 'a', 'Frecuencia-Periodicidad', 'Frecuencia actual de la publicación', 13, 103, 2),
(264, '310', 'REV', NULL, NULL, NULL, 'b', 'Fecha de frecuencia actual de la publicación', 'Frecuencia actual de la publicación', 13, 104, 2),
(265, '362', 'REV', NULL, NULL, NULL, 'a', 'Fecha de inicio - cese', 'Fecha de inicio - cese', 6, 104, 2),
(266, '041', 'REV', NULL, NULL, NULL, 'a', 'Idioma', 'Idioma', 103, 106, 2),
(267, '863', 'REV', NULL, NULL, NULL, 'i', 'Año', 'Vol., nro. y año', 19, 107, 2),
(268, '863', 'REV', NULL, NULL, NULL, 'a', 'Volumen', 'Vol., nro. y año', 19, 108, 2),
(269, '863', 'REV', ')', NULL, ')', 'b', 'Número', 'Vol., nro. y año', 19, 109, 2),
(270, '022', 'REV', NULL, NULL, NULL, 'a', 'ISSN', 'ISSN', 108, 109, 2),
(271, '500', 'REV', NULL, NULL, NULL, 'a', 'Nota general', 'Nota general', 85, 111, 2),
(272, '111', 'ELE', ',', NULL, ',', 'a', 'Congresos y conferencias', 'Congresos/Conferencias', 36, 1, 1),
(273, '111', 'ELE', ',', NULL, ',', 'c', 'Lugar', 'ASIENTO PRINCIPAL - NOMBRE DE LA REUNIÓN (NR)', 36, 3, 1),
(274, '111', 'ELE', NULL, NULL, NULL, 'd', 'Fecha', 'ASIENTO PRINCIPAL - NOMBRE DE LA REUNIÓN (NR)', 36, 4, 1),
(275, '111', 'ELE', NULL, NULL, NULL, 'n', 'Número', 'ASIENTO PRINCIPAL - NOMBRE DE LA REUNIÓN (NR)', 36, 2, 1),
(276, '520', 'ELE', NULL, NULL, NULL, 'a', 'Resumen', 'Resumen', 120, 120, 1),
(277, '260', 'LIB', ',&nbsp;', NULL, NULL, 'c', 'Fecha', 'PUBLICACIÓN, DISTRIBUCIÓN, ETC. (PIE DE IMPRENTA) (R)', 19, 122, 2),
(278, '653', 'TES', NULL, NULL, NULL, 'a', 'Palabras claves (no controlado)', 'Palabras claves', 50, 123, 1),
(279, '520', 'TES', NULL, NULL, NULL, 'a', 'Nota de resumen', 'Resumen', 124, 124, 1),
(280, '100', 'ANA', NULL, NULL, NULL, 'a', 'Autor', 'Autor', 1, 125, 1),
(281, '653', 'ANA', NULL, NULL, NULL, 'a', 'Palabras claves (no controlado)', 'Palabras claves', 50, 126, 1),
(282, '995', 'ANA', NULL, NULL, NULL, 't', 'Signatura Topográfica', 'Ubicación', 128, 127, 1),
(283, '110', 'ANA', NULL, NULL, NULL, 'a', 'Autor corporativo', 'Autor corporativo', 34, 128, 1),
(284, '856', 'REV', NULL, NULL, NULL, 'u', 'URL/URI', 'URL/URI', 136, 129, 1),
(285, '020', 'LIB', NULL, NULL, NULL, 'a', 'ISBN', 'ISBN', 52, 130, 2),
(286, '900', 'LIB', NULL, NULL, NULL, 'b', 'Nivel bibliografico', 'Nivel Bibliográfico', 131, 131, 2),
(287, '856', 'LIB', NULL, NULL, NULL, 'u', 'URL/URI', 'URL/URI', 136, 132, 1),
(288, '856', 'ALL', NULL, NULL, NULL, 'u', 'URL/URI', 'URL/URI', 136, 134, 1);

--
-- Volcar la base de datos para la tabla `pref_informacion_referencia`
--

INSERT  INTO `pref_informacion_referencia` (`idinforef`, `idestcat`, `referencia`, `orden`, `campos`, `separador`) VALUES
(1, 45, 'autores', 'nacionalidad', 'completo', '?'),
(2, 46, 'temas', 'nombre', 'nombre', ','),
(3, 47, 'bibliolevel', 'description', 'description', ','),
(5, 45, 'countries', 'printable_name', 'printable_name', '/'),
(6, 45, 'languages', 'description', 'description', '/'),
(18, 61, 'idioma', 'description', 'description', ','),
(22, 67, 'ciudad', 'NOMBRE', 'NOMBRE', ','),
(23, 68, 'soporte', 'description', 'description', ','),
(25, 71, 'autor', 'completo', 'completo', ','),
(26, 73, 'tema', '-1', 'id nombre', ''),
(27, 74, 'ui', 'id_ui', 'id_ui', NULL),
(29, 72, 'ui', 'nombre', 'nombre', NULL),
(30, 79, 'ui', 'nombre', 'nombre', NULL),
(32, 89, 'pais', 'iso', 'iso', NULL),
(42, 113, 'autor', 'completo', 'completo', NULL),
(48, 109, 'autor', 'completo', 'completo', NULL),
(50, 114, 'ciudad', 'NOMBRE', 'NOMBRE', NULL),
(53, 134, 'pais', 'iso', 'iso', NULL),
(61, 128, 'ui', 'id_ui', 'id_ui', NULL),
(64, 120, 'autor', 'nombre', 'nombre', NULL),
(67, 199, 'autor', 'completo', 'completo', NULL),
(71, 195, 'autor', 'completo', 'completo', NULL),
(74, 67, 'ciudad', 'LOCALIDAD', 'LOCALIDAD', NULL),
(76, 217, 'ciudad', 'LOCALIDAD', 'LOCALIDAD', NULL),
(77, 216, 'autor', 'completo', 'completo', NULL),
(78, 66, 'autor', 'nombre', 'nombre', NULL),
(85, 60, 'pais', 'iso', 'iso', NULL),
(88, 132, 'tema', 'nombre', 'nombre', NULL),
(89, 233, 'tema', 'nombre', 'nombre', NULL),
(91, 237, 'autor', 'nombre', 'nombre', NULL),
(93, 235, 'autor', 'completo', 'completo', NULL),
(94, 245, 'autor', 'nombre', 'nombre', NULL),
(97, 236, 'autor', 'completo', 'completo', NULL),
(98, 246, 'autor', 'nombre', 'nombre', NULL),
(99, 247, 'autor', 'nombre', 'nombre', NULL),
(101, 248, 'tema', 'nombre', 'nombre', NULL),
(106, 250, 'autor', 'nombre', 'nombre', NULL),
(107, 252, 'autor', 'nombre', 'nombre', NULL),
(108, 253, 'autor', 'nombre', 'nombre', NULL),
(109, 254, 'idioma', 'nombre', 'nombre', NULL),
(110, 232, 'idioma', 'nombre', 'nombre', NULL),
(114, 268, 'autor', 'nombre', 'nombre', NULL),
(117, 270, 'tema', 'nombre', 'nombre', NULL),
(118, 272, 'idioma', 'idLanguage', 'idLanguage', NULL),
(119, 266, 'autor', 'completo', 'completo', NULL),
(120, 273, 'ciudad', 'NOMBRE', 'NOMBRE', NULL),
(121, 280, 'ciudad', 'NOMBRE', 'NOMBRE', NULL),
(122, 241, 'tipo_ejemplar', 'nombre', 'nombre', NULL),
(124, 282, 'autor', 'nombre', 'nombre', NULL),
(126, 283, 'autor', 'nombre', 'nombre', NULL),
(128, 288, 'idioma', 'description', 'description', NULL),
(132, 317, 'ciudad', 'LOCALIDAD', 'LOCALIDAD', NULL),
(136, 62, 'nivel_bibliografico', 'id', 'id', NULL),
(137, 56, 'tipo_ejemplar', 'id_tipo_doc', 'id_tipo_doc', NULL),
(138, 321, 'tipo_ejemplar', 'id_tipo_doc', 'id_tipo_doc', NULL),
(143, 116, 'autor', 'completo', 'completo', NULL),
(147, 323, 'nivel_bibliografico', 'description', 'description', NULL),
(148, 138, 'idioma', 'description', 'description', NULL),
(149, 68, 'soporte', 'description', 'description', NULL),
(150, 215, 'ciudad', 'NOMBRE', 'NOMBRE', NULL),
(151, 324, 'ciudad', 'NOMBRE', 'NOMBRE', NULL),
(153, 333, 'idioma', 'code', 'code', NULL),
(158, 334, 'idioma', 'description', 'description', NULL),
(159, 292, 'autor', 'completo', 'completo', NULL),
(160, 296, 'autor', 'completo', 'completo', NULL),
(161, 297, 'autor', 'completo', 'completo', NULL),
(162, 299, 'tema', 'nombre', 'nombre', NULL),
(163, 305, 'autor', 'completo', 'completo', NULL),
(164, 310, 'nivel_bibliografico', 'description', 'description', NULL),
(165, 311, 'tipo_ejemplar', 'nombre', 'nombre', NULL),
(169, 335, 'pais', 'iso', 'iso', NULL),
(171, 337, 'autor', 'completo', 'completo', NULL),
(173, 341, 'autor', 'completo', 'completo', NULL),
(175, 342, 'autor', 'completo', 'completo', NULL),
(177, 346, 'ciudad', 'NOMBRE_ABREVIADO', 'NOMBRE_ABREVIADO', NULL),
(181, 350, 'autor', 'completo', 'completo', NULL),
(186, 369, 'nivel_bibliografico', 'description', 'description', NULL),
(187, 370, 'tipo_ejemplar', 'nombre', 'nombre', NULL),
(189, 371, 'tipo_ejemplar', 'nombre', 'nombre', NULL),
(193, 359, 'ciudad', 'NOMBRE_ABREVIADO', 'NOMBRE_ABREVIADO', NULL),
(194, 356, 'idioma', 'description', 'description', NULL),
(195, 357, 'soporte', 'description', 'description', NULL),
(196, 373, 'pais', 'nombre_largo', 'nombre_largo', NULL),
(197, 372, 'pais', 'nombre_largo', 'nombre_largo', NULL),
(199, 377, 'autor', 'completo', 'completo', NULL),
(202, 378, 'autor', 'completo', 'completo', NULL),
(204, 380, 'autor', 'completo', 'completo', NULL),
(205, 381, 'autor', 'completo', 'completo', NULL),
(207, 383, 'autor', 'completo', 'completo', NULL),
(208, 385, 'idioma', 'description', 'description', NULL),
(210, 389, 'autor', 'completo', 'completo', NULL),
(211, 348, 'tema', 'nombre', 'nombre', NULL),
(212, 391, 'tipo_ejemplar', 'nombre', 'nombre', NULL),
(213, 392, 'autor', 'completo', 'completo', NULL),
(214, 150, 'nivel2', 'id', 'id', NULL),
(215, 376, 'tema', 'nombre', 'nombre', NULL),
(220, 394, 'autor', 'completo', 'completo', NULL),
(221, 395, 'autor', 'completo', 'completo', NULL),
(223, 407, 'autor', 'completo', 'completo', NULL),
(224, 405, 'tema', 'nombre', 'nombre', NULL),
(225, 409, 'idioma', 'description', 'description', NULL),
(226, 410, 'pais', 'nombre_largo', 'nombre_largo', NULL),
(227, 411, 'soporte', 'description', 'description', NULL),
(228, 412, 'ciudad', 'NOMBRE', 'NOMBRE', NULL),
(229, 417, 'nivel_bibliografico', 'description', 'description', NULL),
(230, 418, 'tipo_ejemplar', 'nombre', 'nombre', NULL),
(234, 423, 'autor', 'completo', 'completo', NULL),
(235, 320, 'ciudad', 'NOMBRE', 'NOMBRE', NULL),
(238, 240, 'nivel_bibliografico', 'description', 'description', NULL),
(239, 444, 'autor', 'completo', 'completo', NULL),
(240, 448, 'autor', 'completo', 'completo', NULL),
(241, 449, 'autor', 'completo', 'completo', NULL),
(242, 452, 'tema', 'nombre', 'nombre', NULL),
(243, 454, 'autor', 'completo', 'completo', NULL),
(244, 460, 'idioma', 'description', 'description', NULL),
(245, 461, 'pais', 'nombre_largo', 'nombre_largo', NULL),
(246, 462, 'soporte', 'description', 'description', NULL),
(247, 464, 'ciudad', 'NOMBRE', 'NOMBRE', NULL),
(248, 477, 'nivel_bibliografico', 'description', 'description', NULL),
(249, 478, 'tipo_ejemplar', 'nombre', 'nombre', NULL),
(250, 322, 'tipo_ejemplar', 'nombre', 'nombre', NULL),
(252, 480, 'pais', 'nombre_largo', 'nombre_largo', NULL),
(254, 479, 'idioma', 'description', 'description', NULL),
(255, 481, 'soporte', 'description', 'description', NULL),
(256, 482, 'autor', 'completo', 'completo', NULL),
(257, 325, 'editorial', 'editorial', 'editorial', NULL),
(261, 167, 'autor', 'completo', 'completo', NULL),
(262, 52, 'ui', 'ALL', 'JSONcircRef:orden', NULL),
(263, 55, 'estado', 'ALL', 'JSONcircRef:orden', NULL),
(264, 54, 'disponibilidad', 'ALL', 'JSONcircRef:orden', NULL),
(275, 507, 'tipo_ejemplar', 'nombre', 'nombre', NULL),
(276, 508, 'ui', 'nombre', 'nombre', NULL),
(277, 509, 'ui', 'nombre', 'nombre', NULL),
(278, 513, 'disponibilidad', 'nombre', 'nombre', NULL),
(279, 510, 'estado', 'nombre', 'nombre', NULL),
(280, 502, 'ui', 'nombre', 'nombre', NULL),
(281, 501, 'ui', 'nombre', 'nombre', NULL),
(282, 422, 'autor', 'completo', 'completo', NULL);

--
-- Volcar la base de datos para la tabla `pref_tabla_referencia`
--

INSERT  INTO `pref_tabla_referencia` (`id`, `nombre_tabla`, `alias_tabla`, `campo_busqueda`, `client_title`) VALUES
(3, 'cat_autor', 'autor', 'completo', 'Autor'),
(5, 'pref_unidad_informacion', 'ui', 'nombre', 'Unidad de Informacion'),
(6, 'ref_idioma', 'idioma', 'description', 'Idioma'),
(7, 'ref_pais', 'pais', 'nombre_largo', 'Pais'),
(8, 'ref_disponibilidad', 'disponibilidad', 'nombre', 'Disponibilidad'),
(9, 'circ_ref_tipo_prestamo', 'tipo_prestamo', 'descripcion', 'Tipos de Prestamo'),
(10, 'ref_soporte', 'soporte', 'description', 'Soporte'),
(11, 'ref_nivel_bibliografico', 'nivel_bibliografico', 'description', 'Nivel bibliografico'),
(12, 'cat_tema', 'tema', 'nombre', 'Tema'),
(13, 'usr_ref_categoria_socio', 'tipo_socio', 'description', 'Categorias de Usuario'),
(14, 'usr_ref_tipo_documento', 'tipo_documento_usr', 'nombre', 'Tipo de documentos de Socio'),
(15, 'ref_estado', 'estado', 'nombre', 'Estado del ejemplar'),
(16, 'ref_localidad', 'ciudad', 'NOMBRE', 'Localidad'),
(27, 'usr_estado', 'usr_estado', 'nombre', 'Estado de Regularidad'),
(22, 'cat_editorial', 'editorial', 'editorial', 'Editorial'),
(24, 'ref_colaborador', 'colaborador', 'descripcion', 'Función de colaborador'),
(25, 'ref_signatura', 'signatura', 'signatura', 'Signatura Topográfica'),
(26, 'ref_acm', 'cdu', 'codigo', 'Códigos CDU');

--
-- Volcar la base de datos para la tabla `pref_tabla_referencia_conf`
--

INSERT  INTO `pref_tabla_referencia_conf` (`id`, `tabla`, `campo`, `campo_alias`, `visible`) VALUES
(1, 'cat_autor', 'id', 'id', 0),
(2, 'cat_autor', 'completo', 'Apellido y Nombre', 1),
(3, 'cat_autor', 'nombre', 'Nombre', 1),
(4, 'ref_estado', 'nombre', 'Nombre', 1),
(5, 'ref_idioma', 'description', 'Nombre', 1),
(6, 'ref_localidad', 'nombre', 'Nombre', 1),
(7, 'ref_localidad', 'NOMBRE_ABREVIADO', 'Nombre abreviado', 1),
(8, 'ref_nivel_bibliografico', 'description', 'Nombre', 1),
(9, 'ref_pais', 'nombre', 'Nombre abreviado', 1),
(10, 'ref_pais', 'nombre_largo', 'Nombre', 1),
(11, 'ref_provincia', 'nombre', 'Nombre', 1),
(12, 'ref_soporte', 'description', 'Nombre', 1),
(13, 'cat_ref_tipo_nivel3', 'nombre', 'Nombre', 1),
(14, 'pref_unidad_informacion', 'nombre', 'Nomrbe', 1),
(15, 'ref_disponibilidad', 'nombre', 'Nombre', 1),
(16, 'circ_ref_tipo_prestamo', 'description', 'Nombre', 1),
(17, 'cat_tema', 'nombre', 'Nombre', 1),
(18, 'usr_ref_categoria_socio', 'description', 'Nombre', 1),
(19, 'usr_ref_tipo_documento', 'nombre', 'Nombre', 0),
(20, 'cat_registro_marc_n2', 'id', 'Registro N2', 1),
(21, 'ref_colaborador', 'descripcion', 'descripcion', 1),
(22, 'ref_colaborador', 'codigo', 'codigo', 1),
(23, 'ref_colaborador', 'id', 'id', 1),
(24, 'cat_editorial', 'id', 'id', 1),
(25, 'cat_editorial', 'editorial', 'editorial', 1),
(26, 'ref_acm', 'codigo', 'Código CDU', 1),
(27, 'ref_signatura', 'signatura', 'Signatura topográfica', 1),
(28, 'ref_acm', 'id', 'id', 0),
(29, 'ref_signatura', 'id', 'id', 0);

--
-- Volcar la base de datos para la tabla `pref_tabla_referencia_info`
--

INSERT  INTO `pref_tabla_referencia_info` (`orden`, `referencia`, `similares`) VALUES
('apellido', 'autores', 'apellido'),
('nombre', 'temas', 'nombre');

--
-- Volcar la base de datos para la tabla `pref_tabla_referencia_rel_catalogo`
--

INSERT  INTO `pref_tabla_referencia_rel_catalogo` (`id`, `alias_tabla`, `tabla_referente`, `campo_referente`, `sub_campo_referente`) VALUES
(2, 'ui', 'usr_socio', 'id_ui', NULL),
(10, 'tipo_prestamo', 'circ_prestamo', 'tipo_prestamo', NULL),
(13, 'tipo_socio', 'usr_socio', 'id_categoria', NULL),
(14, 'tipo_documento_usr', 'usr_persona', 'tipo_documento', NULL),
(16, 'ciudad', 'usr_persona', 'ciudad', NULL),
(17, 'perfiles_opac', 'cat_visualizacion_opac', 'id_perfil', NULL),
(18, 'usr_estado', 'usr_regularidad', 'usr_estado_id', NULL),
(19, 'usr_estado', 'usr_regularidad', 'usr_estado_id', NULL);

DROP TABLE IF EXISTS `cat_control_seudonimo_autor`; 

CREATE TABLE IF NOT EXISTS `cat_control_seudonimo_autor` (
  `id_autor` int(11) NOT NULL,
  `id_autor_seudonimo` int(11) NOT NULL,
  PRIMARY KEY  (`id_autor`,`id_autor_seudonimo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `cat_control_seudonimo_editorial`;

CREATE TABLE IF NOT EXISTS `cat_control_seudonimo_editorial` (
  `id_editorial` int(11) NOT NULL,
  `id_editorial_seudonimo` int(11) NOT NULL,
  PRIMARY KEY  (`id_editorial`,`id_editorial_seudonimo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `cat_control_seudonimo_tema`;

CREATE TABLE IF NOT EXISTS `cat_control_seudonimo_tema` (
  `id_tema` int(11) NOT NULL,
  `id_tema_seudonimo` int(11) NOT NULL,
  PRIMARY KEY  (`id_tema`,`id_tema_seudonimo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `cat_control_sinonimo_autor`;

CREATE TABLE IF NOT EXISTS `cat_control_sinonimo_autor` (
  `id` int(11) NOT NULL,
  `autor` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`,`autor`),
  KEY `autor` (`autor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `cat_control_sinonimo_editorial`;

CREATE TABLE IF NOT EXISTS `cat_control_sinonimo_editorial` (
  `id` int(11) NOT NULL,
  `editorial` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`,`editorial`),
  KEY `editorial` (`editorial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `cat_control_sinonimo_tema`;

CREATE TABLE IF NOT EXISTS `cat_control_sinonimo_tema` (
  `id` int(11) NOT NULL auto_increment,
  `tema` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`,`tema`),
  KEY `tema` (`tema`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `cat_encabezado_campo_opac`;

CREATE TABLE IF NOT EXISTS `cat_encabezado_campo_opac` (
  `idencabezado` int(11) NOT NULL auto_increment,
  `nombre` varchar(255) NOT NULL,
  `orden` int(11) NOT NULL,
  `linea` tinyint(1) NOT NULL default '0',
  `nivel` tinyint(1) NOT NULL,
  `visible` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`idencabezado`),
  KEY `nombre` (`nombre`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT  INTO `cat_encabezado_campo_opac` (`idencabezado`, `nombre`, `orden`, `linea`, `nivel`, `visible`) VALUES
(1, 'Encabezado 1', -1, 0, 2, 1),
(2, 'Encabezado 3', 0, 0, 3, 1),
(3, 'Encabezado 2', 0, 0, 2, 1),
(4, 'Encabezado Nivel 1', 0, 0, 1, 1);

DROP TABLE IF EXISTS `cat_encabezado_item_opac`;

CREATE TABLE IF NOT EXISTS `cat_encabezado_item_opac` (
  `idencabezado` int(11) NOT NULL default '0',
  `itemtype` varchar(4) NOT NULL default '',
  PRIMARY KEY  (`idencabezado`,`itemtype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT  INTO `cat_encabezado_item_opac` (`idencabezado`, `itemtype`) VALUES
(1, 'ACT'),
(1, 'LIB'),
(2, 'ACT'),
(2, 'LIB'),
(3, 'LIB'),
(4, 'LIB');

DROP TABLE IF EXISTS `cat_estructura_catalogacion`;

CREATE TABLE IF NOT EXISTS `cat_estructura_catalogacion` (
  `id` int(11) NOT NULL auto_increment,
  `campo` char(3) NOT NULL,
  `subcampo` char(1) NOT NULL,
  `itemtype` varchar(4) NOT NULL default '',
  `liblibrarian` varchar(255) NOT NULL,
  `tipo` varchar(255) NOT NULL,
  `referencia` tinyint(1) NOT NULL default '0',
  `nivel` tinyint(1) NOT NULL,
  `obligatorio` tinyint(1) NOT NULL default '0',
  `intranet_habilitado` int(11) default '0',
  `visible` tinyint(1) NOT NULL default '1',
  `idinforef` int(11) default NULL,
  `idCompCliente` varchar(255) NOT NULL,
  `fijo` tinyint(1) NOT NULL default '0' COMMENT 'modificable = 0, No \r\nmodificable = 1',
  `repetible` tinyint(1) NOT NULL default '1' COMMENT 'repetible = 1 \r\n(es petible)',
  `rules` varchar(255) default NULL,
  `grupo` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `campo` (`campo`),
  KEY `subcampo` (`subcampo`),
  KEY `itemtype` (`itemtype`),
  KEY `indiceTodos` (`campo`,`subcampo`,`itemtype`),
  KEY `idinforef` (`idinforef`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

INSERT INTO `cat_estructura_catalogacion` (`id`, `campo`, `subcampo`, `itemtype`, `liblibrarian`, `tipo`, `referencia`, `nivel`, `obligatorio`, `intranet_habilitado`, `visible`, `idinforef`, `idCompCliente`, `fijo`, `repetible`, `rules`, `grupo`) VALUES
(51, '245', 'a', 'ALL', 'Título', 'text', 0, 1, 1, 3, 1, NULL, '1', 1, 0, 'alphanumeric_total:true', 0),
(52, '995', 'd', 'ALL', 'Unidad de Información de Origen', 'combo', 1, 3, 1, 4, 1, 7, '2', 1, 0, 'alphanumeric_total:true', 0),
(53, '995', 'c', 'ALL', 'Unidad de Información', 'combo', 1, 3, 1, 2, 1, 7, '3', 1, 0, 'alphanumeric_total:true', 0),
(54, '995', 'o', 'ALL', 'Disponibilidad', 'combo', 1, 3, 1, 3, 1, 20, '4', 1, 0, 'alphanumeric_total:true', 0),
(55, '995', 'e', 'ALL', 'Estado', 'combo', 1, 3, 1, 5, 1, 9, '5', 1, 0, 'alphanumeric_total:true', 0),
(56, '910', 'a', 'ALL', 'Tipo de Documento', 'combo', 1, 2, 1, 1, 1, 8, '6', 1, 0, 'alphanumeric_total:true', 0),
(59, '260', 'c', 'ALL', 'Fecha de publicación, distribución, etc.', 'calendar', 0, 2, 0, 2, 1, NULL, '3c650621a845f2ed6226269a137a8dd9', 1, 0, 'alphanumeric_total:true', 0),
(60, '043', 'c', 'ALL', 'Código ISO (R)', 'combo', 1, 2, 0, 3, 1, 17, 'cefaa8a5a8a3407c70df0e307dbd04bc', 1, 0, 'alphanumeric_total:true', 0),
(61, '041', 'h', 'ALL', 'Código de idioma de la versión original y/o \r\ntraducciones intermedias del texto', 'combo', 1, 2, 0, 5, 1, 18, 'd02d2fa5669407a74cc3937e20589794', 1, 0, 'alphanumeric_total:true', 0),
(62, '900', 'b', 'ALL', 'Nivel Bibliográfico', 'combo', 1, 2, 0, 6, 1, 19, 'd45294e8506d009a430a08fe9674ffcd', 1, 0, 'alphanumeric_total:true', 0),
(63, '995', 't', 'ALL', 'Signatura Topográfica', 'text', 0, 3, 0, 6, 1, NULL, '6bab6f3097531cc673b716beecb02291', 1, 0, 'alphanumeric_total:true', 0),
(65, '995', 'f', 'ALL', 'Código de Barras', 'text', 0, 3, 0, 1, 1, NULL, '62fe2d3dcb85e12ed75812bbac9f9e5a', 1, 0, 'alphanumeric_total:true', 0),
(66, '110', 'a', 'ALL', 'Autor', 'auto', 1, 1, 0, 1, 1, 21, 'bf8e17616267c51064becf693e64501e', 1, 0, 'alphanumeric_total:true', 0),
(67, '260', 'a', 'ALL', 'Ciudad de publicación', 'text', 1, 2, 0, 7, 1, NULL, 'cbbd9c107865b4586ceed391f8b5223b', 1, 0, 'alphanumeric_total:true', 0),
(68, '245', 'h', 'ALL', 'Medio', 'combo', 1, 2, 0, 4, 1, 4, 'dbd4ba15b96cf63914351cdb163467b2', 1, 0, 'alphanumeric_total:true', 0),
(107, '080', 'a', 'ALL', 'CDU', 'text', 0, 1, 0, 3, 1, NULL, 'ea0c6caa38d898989866335e1af0844e', 0, 1, ' alphanumeric_total:true ', 1),
(108, '084', 'a', 'ALL', 'Otro Número de Clasificación R', 'text', 0, 1, 0, 4, 1, NULL, 'a17d02aa9b8000545cbda6ecc9795cca', 0, 1, ' alphanumeric_total:true ', 2),
(109, '100', 'a', 'ALL', 'Nombre Personal', 'auto', 1, 1, 1, 5, 1, 21, 'ac650c162cb9a25439b3cf0121c04d4b', 0, 1, ' alphanumeric_total:true ', 3),
(110, '100', 'b', 'ALL', 'Número asociado al nombre', 'text', 0, 1, 0, 6, 1, NULL, 'b62a61396e3b2253834943f36b1c5c87', 0, 1, ' alphanumeric_total:true ', 4),
(111, '100', 'c', 'ALL', 'Títulos y otras palabras asociadas con el nombre', 'text', 0, 1, 0, 7, 1, NULL, 'db40bfc73a6b47a223d05354aad6fa01', 0, 1, ' alphanumeric_total:true ', 5),
(112, '100', 'd', 'ALL', 'Fechas de nacimiento y muerte del autor', 'calendar', 0, 1, 0, 8, 1, NULL, '3b14403d2b3bfa1b272ec8f1e40b0168', 0, 1, ' alphanumeric_total:true ', 6),
(113, '111', 'a', 'ALL', 'Congresos Conferencias etc.', 'text', 0, 1, 0, 9, 1, NULL, '2d5a88362087f3249641aa935cd8dc45', 0, 1, ' alphanumeric_total:true ', 7),
(114, '111', 'c', 'ALL', 'Lugar de la reunión', 'auto', 1, 1, 0, 10, 1, 16, '060b526698bf141dd9ed0a1af4bb7c2d', 0, 1, ' alphanumeric_total:true ', 8),
(115, '111', 'd', 'ALL', 'Fecha de la reunión', 'text', 0, 1, 0, 11, 1, NULL, '7567ea2a7165b64e35e07f9239bf0c71', 0, 1, ' alphanumeric_total:true ', 9),
(116, '700', 'a', 'ALL', 'Nombre Personal', 'auto', 1, 1, 0, 12, 1, 21, '496705e6cd65f25e4e41ef8f26d0027e', 0, 1, ' alphanumeric_total:true ', 10),
(117, '700', 'b', 'ALL', 'Número asociado al nombre', 'text', 0, 1, 0, 13, 1, NULL, '4fcabc8e2d75c645552d462df7109c85', 0, 1, ' alphanumeric_total:true ', 11),
(118, '700', 'c', 'ALL', 'Títulos y otras palabras asociadas con el nombre', 'text', 0, 1, 0, 14, 1, NULL, 'c1b59097f399bb24a7dedd6e3339badb', 0, 1, ' alphanumeric_total:true ', 12),
(119, '700', 'd', 'ALL', 'Fechas asociadas con el nombre', 'calendar', 0, 1, 0, 15, 1, NULL, 'a866a7222462053c4e750ddd3d663dea', 0, 1, ' alphanumeric_total:true ', 13),
(120, '710', 'a', 'ALL', 'Nombre de la entidad o jurisdicción', 'auto', 1, 1, 0, 16, 1, 31, '538f99c8e5537a6307385edc614e65cf', 0, 1, ' alphanumeric_total:true ', 14),
(121, '720', 'a', 'ALL', 'Entrada secundaria no controlada', 'text', 0, 1, 0, 17, 1, NULL, '33c7296b105f76296cdbacad6584cae9', 0, 1, ' alphanumeric_total:true ', 15),
(122, '210', 'a', 'ALL', 'Título abreviado para publicación seriada', 'text', 0, 1, 0, 18, 1, NULL, '7b2a5ab0c335b6bd5dd38b849badd8bc', 0, 1, ' alphanumeric_total:true ', 16),
(123, '222', 'a', 'ALL', 'Título clave', 'text', 0, 1, 0, 19, 1, NULL, '88ea02b00dbedb9dda51615c3c3c8707', 0, 1, ' alphanumeric_total:true ', 17),
(124, '245', 'b', 'ALL', 'Título informativo', 'text', 0, 1, 0, 20, 1, NULL, '21f6e655816f1ac4b941bc13908197e3', 0, 1, ' alphanumeric_total:true ', 18),
(125, '246', 'a', 'ALL', 'Variante del título', 'text', 0, 1, 0, 21, 1, NULL, 'c682c271dabbfb6a0f8878df928a3b1c', 0, 1, ' alphanumeric_total:true ', 19),
(126, '246', 'b', 'ALL', 'Variante del título informativo', 'text', 0, 1, 0, 22, 1, NULL, '7ef2d014b5db89d8d4980dbdc4822b5c', 0, 1, ' alphanumeric_total:true ', 20),
(127, '534', 'a', 'ALL', 'Título original', 'text', 0, 1, 0, 23, 1, NULL, 'c2d53e2fa84556af755bd8395a4a62cd', 0, 1, ' alphanumeric_total:true ', 21),
(128, '600', 'a', 'ALL', 'Nombre Personal', 'auto', 1, 1, 0, 24, 1, 28, 'f558fc057d212e144b86196d2a2c55c4', 0, 1, ' alphanumeric_total:true ', 22),
(129, '600', 'b', 'ALL', 'Número asociado al nombre', 'text', 0, 1, 0, 25, 1, NULL, 'ec8d0b007a5d9be29c4ab7fea291d6d1', 0, 1, ' alphanumeric_total:true ', 23),
(130, '600', 'c', 'ALL', 'Títulos y otras palabras asociadas con el nombre', 'text', 0, 1, 0, 26, 1, NULL, '8d72a2e4fcb2fea44f316ebbf26c23fa', 0, 1, ' alphanumeric_total:true ', 24),
(131, '600', 'd', 'ALL', 'Fechas asociadas con el nombre', 'calendar', 0, 1, 0, 27, 1, NULL, '00b61ffb2f9d4d4fee7fe7eb7af5ca2a', 0, 1, ' alphanumeric_total:true ', 25),
(132, '650', 'a', 'ALL', 'Término controlado', 'text', 0, 1, 0, 28, 1, NULL, '357a2f17fd0088cb1f0e8370b62d7452', 0, 1, ' alphanumeric_total:true ', 26),
(133, '650', '2', 'ALL', 'Fuente del encabezamiento o término', 'text', 0, 1, 0, 29, 1, NULL, '05828ac7a6143d90273a1f80be98095a', 0, 1, ' alphanumeric_total:true ', 27),
(134, '651', 'a', 'ALL', 'Nombre geográfico', 'auto', 1, 1, 0, 30, 1, 17, 'b62f6fea9e64c8db720eb447052d0bd6', 0, 1, ' alphanumeric_total:true ', 28),
(135, '653', 'a', 'ALL', 'Término no controlado', 'text', 0, 1, 0, 31, 1, NULL, 'eea199e92303ba203519cd460a662188', 0, 1, ' alphanumeric_total:true ', 29),
(136, '655', 'a', 'ALL', 'Genero/Forma del material', 'text', 0, 1, 0, 32, 1, NULL, 'e4a8ffaf0bad3ad286cf3057466a0e89', 0, 1, ' alphanumeric_total:true ', 30),
(137, '020', 'a', 'LIB', 'ISBN', 'text', 0, 2, 0, 8, 1, NULL, '18c969e664f25625d83183540b563ad0', 0, 1, ' alphanumeric_total:true ', 31),
(138, '041', 'a', 'LIB', 'Idioma', 'auto', 1, 2, 0, 9, 1, 24, 'c304616fe1434ba4235a146010b98aa3', 0, 1, ' alphanumeric_total:true ', 32),
(140, '250', 'a', 'LIB', 'Mención de edición', 'text', 0, 2, 0, 11, 1, NULL, '665d8ec1b8a444dcf4d8732f09022742', 0, 1, ' alphanumeric_total:true ', 34),
(141, '260', 'b', 'LIB', 'Editor', 'text', 0, 2, 0, 12, 1, NULL, 'c9cf3e8f4cdf5e96f913c4fc5d949591', 0, 1, ' alphanumeric_total:true ', 35),
(142, '300', 'a', 'LIB', 'Descripción física', 'text', 0, 2, 0, 13, 1, NULL, '6982e2c38b57af9484301752acba4d44', 0, 1, ' alphanumeric_total:true ', 36),
(143, '440', 'a', 'LIB', 'Título de la serie', 'text', 0, 2, 0, 14, 1, NULL, '484e5d9090c3ba6b66ebad0c0e1150d2', 0, 1, ' alphanumeric_total:true ', 37),
(144, '440', 'p', 'LIB', 'Nombre de la subserie', 'text', 0, 2, 0, 15, 1, NULL, '5c9badf652343301382222dee9d8cd81', 0, 1, ' alphanumeric_total:true ', 38),
(145, '440', 'v', 'LIB', 'Número de la serie', 'text', 0, 2, 0, 16, 1, NULL, '2c1cdfad0546433f47440881acc9dc1a', 0, 1, ' alphanumeric_total:true ', 39),
(146, '500', 'a', 'LIB', 'Notas', 'text', 0, 2, 0, 17, 1, NULL, 'd92774dab9a0b65d987d0d10fcc5ee96', 0, 1, ' alphanumeric_total:true ', 40),
(147, '773', 'd', 'LIB', 'Lugar editorial y fecha de publicación', 'text', 0, 2, 0, 18, 1, NULL, 'a418ddf28c319073c56d72d92182c086', 0, 1, ' alphanumeric_total:true ', 41),
(148, '773', 'g', 'LIB', 'Páginas', 'text', 0, 2, 0, 19, 1, NULL, 'c7cce151b4ab09c91a7a51d92b9300eb', 0, 1, ' alphanumeric_total:true ', 42),
(149, '773', 't', 'LIB', 'Título', 'text', 0, 2, 0, 20, 1, NULL, 'c448fa15d5d384ffe9058f12a48c4546', 0, 1, ' alphanumeric_total:true ', 43);

DROP TABLE IF EXISTS `cat_estructura_catalogacion_opac`;

CREATE TABLE IF NOT EXISTS `cat_estructura_catalogacion_opac` (
  `idestcatopac` int(11) NOT NULL auto_increment,
  `campo` char(3) NOT NULL,
  `subcampo` char(1) NOT NULL,
  `textpred` varchar(255) default NULL,
  `textsucc` varchar(255) default NULL,
  `separador` varchar(3) default NULL,
  `idencabezado` int(11) NOT NULL,
  `visible` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`idestcatopac`),
  KEY `campo` (`campo`,`subcampo`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

INSERT  INTO `cat_estructura_catalogacion_opac` (`idestcatopac`, `campo`, `subcampo`, `textpred`, `textsucc`, `separador`, `idencabezado`, `visible`) VALUES
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


DROP TABLE IF EXISTS `cat_portada_registro`;

CREATE TABLE IF NOT EXISTS `cat_portada_registro` (
  `id` int(11) NOT NULL auto_increment,
  `isbn` varchar(50) NOT NULL,
  `small` varchar(500) default NULL,
  `medium` varchar(500) default NULL,
  `large` varchar(500) default NULL,
  UNIQUE KEY `isbn` (`isbn`),
  UNIQUE KEY `id_2` (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;

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

INSERT  INTO `perm_catalogo` (`ui`, `tipo_documento`, `datos_nivel1`, `datos_nivel2`, `datos_nivel3`, `estantes_virtuales`, `estructura_catalogacion_n1`, `estructura_catalogacion_n2`, `estructura_catalogacion_n3`, `tablas_de_refencia`, `control_de_autoridades`, `usuarios`, `sistema`, `undefined`, `id`, `id_persona`, `nro_socio`) VALUES
('DEO', 'LIB', '00000001', '00000001', '00010000', '00001111', '00000001', '00000001', '00000001', '00000001', '00000001', '00001111', '00000001', '00001111', 1, 21, 'kohaadmin');

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

INSERT  INTO `perm_general` (`nro_socio`, `ui`, `tipo_documento`, `preferencias`, `reportes`, `permisos`) VALUES
('kohaadmin', 'DEO', 'ANY', '', '00001111', '00001111');

DROP TABLE IF EXISTS `pref_informacion_referencia`;

CREATE TABLE IF NOT EXISTS `pref_informacion_referencia` (
  `idinforef` int(11) NOT NULL auto_increment,
  `idestcat` int(11) NOT NULL,
  `referencia` varchar(255) NOT NULL,
  `orden` varchar(255) default NULL,
  `campos` varchar(255) default NULL,
  `separador` varchar(3) default NULL,
  PRIMARY KEY  (`idinforef`),
  KEY `idestcat` (`idestcat`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

INSERT INTO `pref_informacion_referencia` (`idinforef`, `idestcat`, `referencia`, `orden`, `campos`, `separador`) VALUES
(1, 45, 'autores', 'nacionalidad', 'completo', '?'),
(2, 46, 'temas', 'nombre', 'nombre', ','),
(3, 47, 'bibliolevel', 'description', 'description', ','),
(4, 47, 'soporte', 'description', 'description', ','),
(5, 45, 'countries', 'printable_name', 'printable_name', '/'),
(6, 45, 'languages', 'description', 'description', '/'),
(7, 44, 'ui', 'nombre', 'nombre', ','),
(8, 45, 'tipo_ejemplar', 'nombre', 'nombre', ','),
(9, 45, 'estado', 'nombre', 'nombre', ','),
(16, 0, 'ciudad', 'nombre', 'nombre', ','),
(17, 60, 'pais', 'nombre_largo', 'nombre', ','),
(18, 61, 'idioma', 'description', 'description', ','),
(19, 62, 'nivel_bibliografico', 'description', 'description', ','),
(20, 0, 'disponibilidad', 'nombre', 'nombre', ','),
(21, 66, 'autor', 'completo', 'completo', ','),
(22, 67, 'ciudad', 'NOMBRE', 'NOMBRE', ','),
(23, 68, 'soporte', 'description', 'description', ','),
(24, 70, 'idioma', 'description', 'description', ','),
(25, 71, 'autor', 'completo', 'completo', ','),
(26, 73, 'tema', '-1', 'id nombre', ''),
(27, 74, 'ui', 'id_ui', 'id_ui', NULL),
(28, 73, 'ui', 'nombre', 'nombre', NULL),
(29, 72, 'ui', 'nombre', 'nombre', NULL),
(30, 79, 'ui', 'nombre', 'nombre', NULL),
(31, 80, 'autor', 'completo', 'completo', NULL),
(32, 89, 'pais', 'iso', 'iso', NULL);

DROP TABLE IF EXISTS `pref_palabra_frecuente`;

CREATE TABLE IF NOT EXISTS `pref_palabra_frecuente` (
  `word` varchar(255) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `pref_palabra_frecuente` (`word`) VALUES
('an'),
('A'),
('THE'),
('EL'),
('LOS'),
('LA');

DROP TABLE IF EXISTS `pref_tabla_referencia_info`;

CREATE TABLE IF NOT EXISTS `pref_tabla_referencia_info` (
  `orden` varchar(20) NOT NULL,
  `referencia` varchar(30) NOT NULL,
  `similares` varchar(20) NOT NULL,
  PRIMARY KEY  (`referencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `pref_tabla_referencia_info` (`orden`, `referencia`, `similares`) VALUES
('apellido', 'autores', 'apellido'),
('nombre', 'temas', 'nombre');

DROP TABLE IF EXISTS `pref_tabla_referencia_rel_catalogo`;

CREATE TABLE IF NOT EXISTS `pref_tabla_referencia_rel_catalogo` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `alias_tabla` varchar(32) NOT NULL,
  `tabla_referente` varchar(32) NOT NULL,
  `campo_referente` varchar(32) NOT NULL,
  `sub_campo_referente` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

INSERT INTO `pref_tabla_referencia_rel_catalogo` (`id`, `alias_tabla`, `tabla_referente`, `campo_referente`, `sub_campo_referente`) VALUES
(2, 'ui', 'usr_socio', 'id_ui', NULL),
(10, 'tipo_prestamo', 'circ_prestamo', 'tipo_prestamo', NULL),
(13, 'tipo_socio', 'usr_socio', 'cod_categoria', NULL),
(14, 'tipo_documento_usr', 'usr_persona', 'tipo_documento', NULL),
(16, 'ciudad', 'usr_persona', 'ciudad', NULL),
(17, 'perfiles_opac', 'cat_visualizacion_opac', 'id_perfil', NULL);

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

DROP TABLE IF EXISTS `pref_tabla_referencia`;

CREATE TABLE IF NOT EXISTS `pref_tabla_referencia` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `nombre_tabla` varchar(40) NOT NULL,
  `alias_tabla` varchar(20) NOT NULL default '0',
  `campo_busqueda` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `campo_busqueda` (`campo_busqueda`)
) ENGINE=MyISAM ;

INSERT INTO `pref_tabla_referencia` (`id`, `nombre_tabla`, `alias_tabla`, `campo_busqueda`) VALUES
(3, 'cat_autor', 'autor', 'completo'),
(4, 'cat_ref_tipo_nivel3', 'tipo_ejemplar', 'nombre'),
(5, 'pref_unidad_informacion', 'ui', 'nombre'),
(6, 'ref_idioma', 'idioma', 'description'),
(7, 'ref_pais', 'pais', 'nombre_largo'),
(8, 'ref_disponibilidad', 'disponibilidad', 'nombre'),
(9, 'circ_ref_tipo_prestamo', 'tipo_prestamo', 'descripcion'),
(10, 'ref_soporte', 'soporte', 'description'),
(11, 'ref_nivel_bibliografico', 'nivel_bibliografico', 'description'),
(12, 'cat_tema', 'tema', 'nombre'),
(13, 'usr_ref_categoria_socio', 'tipo_socio', 'description'),
(14, 'usr_ref_tipo_documento', 'tipo_documento_usr', 'nombre'),
(15, 'ref_estado', 'estado', 'nombre'),
(16, 'ref_localidad', 'ciudad', 'NOMBRE'),
(17, 'cat_perfil_opac', 'perfiles_opac', 'nombre');

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


-- DA ERROR FIXME
ALTER TABLE `adq_proveedor`
  ADD CONSTRAINT `fk_adq_proveedor_ref_localidad1` FOREIGN KEY (`ref_localidad_id`) REFERENCES `ref_localidad` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_adq_proveedor_usr_ref_tipo_documento1` FOREIGN KEY (`usr_ref_tipo_documento_id`) REFERENCES `usr_ref_tipo_documento` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

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

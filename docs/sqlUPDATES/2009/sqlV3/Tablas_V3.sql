CREATE TABLE `analyticalauthors` (
  `analyticalnumber` int(11) NOT NULL,
  `author` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `analyticalkeyword` (
  `idkeyword` int(11) NOT NULL,
  `analyticalnumber` varchar(11) NOT NULL,
  PRIMARY KEY  (`idkeyword`,`analyticalnumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `analyticalsubject` (
  `analyticalnumber` int(11) NOT NULL,
  `subject` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `authorised_values` (
  `id` int(11) NOT NULL auto_increment,
  `category` char(10) NOT NULL default '',
  `authorised_value` char(80) NOT NULL default '',
  `lib` char(80) default NULL,
  PRIMARY KEY  (`id`),
  KEY `name` (`category`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=15 ;


CREATE TABLE `autores` (
  `id` int(11) NOT NULL auto_increment,
  `nombre` text NOT NULL,
  `apellido` text NOT NULL,
  `nacionalidad` char(3) default NULL,
  `completo` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8626 ;

CREATE TABLE `availability` (
  `id3` varchar(10) NOT NULL default '',
  `avail` varchar(30) NOT NULL default '',
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `date` date NOT NULL default '0000-00-00',
  `loan` varchar(15) NOT NULL default '',
  `branch` varchar(5) NOT NULL default ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `biblioanalysis` (
  `analyticaltitle` text,
  `id1` int(11) NOT NULL default '0',
  `analyticalunititle` text,
  `id2` int(11) NOT NULL default '0',
  `parts` text NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `analyticalnumber` int(11) NOT NULL,
  `classification` varchar(25) default NULL,
  `resumen` text,
  `url` varchar(100) default NULL,
  PRIMARY KEY  (`analyticalnumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `bibliolevel` (
  `code` varchar(4) NOT NULL default '',
  `description` varchar(20) NOT NULL default '',
  PRIMARY KEY  (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `bookshelf` (
  `shelfnumber` int(11) NOT NULL default '0',
  `shelfname` varchar(255) default NULL,
  `type` text NOT NULL,
  `parent` int(11) NOT NULL default '0',
  PRIMARY KEY  (`shelfnumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `borrowers` (
  `borrowernumber` int(11) NOT NULL auto_increment,
  `cardnumber` varchar(16) NOT NULL default '',
  `documentnumber` varchar(16) NOT NULL default '',
  `documenttype` char(3) NOT NULL default '',
  `surname` text NOT NULL,
  `firstname` text NOT NULL,
  `title` text,
  `othernames` text,
  `initials` text,
  `streetaddress` text,
  `suburb` text,
  `city` text,
  `phone` text,
  `emailaddress` text,
  `faxnumber` text,
  `textmessaging` text,
  `altstreetaddress` text,
  `altsuburb` text,
  `altcity` text,
  `altphone` text,
  `dateofbirth` date default NULL,
  `branchcode` varchar(4) NOT NULL default '',
  `categorycode` char(2) NOT NULL default '',
  `dateenrolled` date default NULL,
  `gonenoaddress` tinyint(1) default NULL,
  `lost` tinyint(1) default NULL,
  `debarred` tinyint(1) default NULL,
  `studentnumber` text,
  `school` text,
  `contactname` text,
  `borrowernotes` text,
  `guarantor` int(11) default NULL,
  `area` char(2) default NULL,
  `ethnicity` varchar(50) default NULL,
  `ethnotes` varchar(255) default NULL,
  `sex` char(1) default NULL,
  `expiry` date default NULL,
  `altnotes` varchar(255) default NULL,
  `altrelationship` varchar(100) default NULL,
  `streetcity` text,
  `phoneday` varchar(50) default NULL,
  `preferredcont` char(1) default NULL,
  `physstreet` varchar(100) default NULL,
  `homezipcode` varchar(25) default NULL,
  `zipcode` varchar(25) default NULL,
  `userid` varchar(30) default NULL,
  `flags` int(11) default NULL,
  `password` varchar(30) default NULL,
  `lastlogin` datetime default NULL,
  `lastchangepassword` date default NULL,
  `changepassword` tinyint(1) default '0',
  `usercourse` date default NULL,
  UNIQUE KEY `cardnumber` (`cardnumber`),
  UNIQUE KEY `documentnumber` (`documentnumber`,`documenttype`),
  KEY `borrowernumber` (`borrowernumber`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

CREATE TABLE `branchcategories` (
  `categorycode` varchar(4) NOT NULL default '',
  `categoryname` text,
  `codedescription` text,
  PRIMARY KEY  (`categorycode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `branches` (
  `branchcode` varchar(4) NOT NULL default '',
  `branchname` text NOT NULL,
  `branchaddress1` text,
  `branchaddress2` text,
  `branchaddress3` text,
  `branchphone` text,
  `branchfax` text,
  `branchemail` text,
  `issuing` tinyint(4) default NULL,
  PRIMARY KEY  (`branchcode`),
  UNIQUE KEY `branchcode` (`branchcode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `branchrelations` (
  `branchcode` varchar(4) default NULL,
  `categorycode` varchar(4) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `busquedas` (
  `idBusqueda` int(11) NOT NULL auto_increment,
  `borrower` int(11) default NULL,
  `fecha` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`idBusqueda`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=207 ;

CREATE TABLE `colaboradores` (
  `id1` int(11) NOT NULL,
  `idColaborador` int(11) NOT NULL,
  `tipo` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `control_autores_seudonimos` (
  `id` int(11) NOT NULL,
  `id2` int(11) NOT NULL,
  PRIMARY KEY  (`id`,`id2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `control_autores_sinonimos` (
  `id` int(11) NOT NULL,
  `autor` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`,`autor`),
  KEY `autor` (`autor`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `control_editoriales_seudonimos` (
  `id` int(11) NOT NULL,
  `id2` int(11) NOT NULL,
  PRIMARY KEY  (`id`,`id2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `control_temas_seudonimos` (
  `id` int(11) NOT NULL,
  `id2` int(11) NOT NULL,
  PRIMARY KEY  (`id`,`id2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `control_temas_sinonimos` (
  `id` int(11) NOT NULL auto_increment,
  `tema` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`,`tema`),
  KEY `tema` (`tema`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `countries` (
  `iso` char(2) NOT NULL default '',
  `iso3` char(3) NOT NULL default '',
  `name` varchar(80) NOT NULL default '',
  `printable_name` varchar(80) NOT NULL default '',
  `code` varchar(11) NOT NULL default '',
  PRIMARY KEY  (`iso`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `deletedborrowers` (
  `borrowernumber` int(11) NOT NULL default '0',
  `cardnumber` varchar(9) NOT NULL default '',
  `documentnumber` varchar(16) NOT NULL default '',
  `documenttype` char(3) NOT NULL default '',
  `surname` text NOT NULL,
  `firstname` text NOT NULL,
  `title` text,
  `othernames` text,
  `initials` text NOT NULL,
  `streetaddress` text NOT NULL,
  `suburb` text,
  `city` text NOT NULL,
  `phone` text NOT NULL,
  `emailaddress` text,
  `faxnumber` text,
  `textmessaging` text,
  `altstreetaddress` text,
  `altsuburb` text,
  `altcity` text,
  `altphone` text,
  `dateofbirth` date default NULL,
  `branchcode` varchar(4) NOT NULL default '',
  `categorycode` char(2) default NULL,
  `dateenrolled` date default NULL,
  `gonenoaddress` tinyint(1) default NULL,
  `lost` tinyint(1) default NULL,
  `debarred` tinyint(1) default NULL,
  `studentnumber` text,
  `school` text,
  `contactname` text,
  `borrowernotes` text,
  `guarantor` int(11) default NULL,
  `area` char(2) default NULL,
  `ethnicity` varchar(50) default NULL,
  `ethnotes` varchar(255) default NULL,
  `sex` char(1) default NULL,
  `expiry` date default NULL,
  `altnotes` varchar(255) default NULL,
  `altrelationship` varchar(100) default NULL,
  `streetcity` text,
  `phoneday` varchar(50) default NULL,
  `preferredcont` varchar(100) default NULL,
  `physstreet` varchar(100) default NULL,
  `homezipcode` varchar(25) default NULL,
  `zipcode` varchar(25) default NULL,
  `userid` varchar(30) default NULL,
  `flags` int(11) default NULL,
  `password` varchar(30) default NULL,
  `lastlogin` datetime default NULL,
  `lastchangepassword` date default NULL,
  `changepassword` tinyint(1) default '0',
  KEY `borrowernumber` (`borrowernumber`),
  KEY `cardnumber` (`cardnumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `dptos_partidos` (
  `DPTO_PARTIDO` varchar(11) NOT NULL default '',
  `NOMBRE` varchar(60) default NULL,
  `PROVINCIA` varchar(11) default NULL,
  `ESTADO` char(1) default NULL,
  PRIMARY KEY  (`DPTO_PARTIDO`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `encabezado_campo_opac` (
  `idencabezado` int(11) NOT NULL auto_increment,
  `nombre` varchar(255) NOT NULL,
  `orden` int(11) NOT NULL,
  `linea` tinyint(1) NOT NULL default '0',
  `nivel` tinyint(1) NOT NULL,
  PRIMARY KEY  (`idencabezado`),
  KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `encabezado_item_opac` (
  `idencabezado` int(11) NOT NULL default '0',
  `itemtype` varchar(4) NOT NULL default '',
  PRIMARY KEY  (`idencabezado`,`itemtype`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `estructura_catalogacion` (
  `id` int(11) NOT NULL auto_increment,
  `campo` char(3) NOT NULL,
  `subcampo` char(1) NOT NULL,
  `itemtype` varchar(4) NOT NULL default '',
  `liblibrarian` varchar(255) NOT NULL,
  `tipo` char(5) NOT NULL,
  `referencia` tinyint(1) NOT NULL default '0',
  `nivel` tinyint(1) NOT NULL,
  `obligatorio` tinyint(1) NOT NULL default '0',
  `intranet_habilitado` int(11) default '0',
  `visible` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `campo` (`campo`),
  KEY `subcampo` (`subcampo`),
  KEY `itemtype` (`itemtype`),
  KEY `indiceTodos` (`campo`,`subcampo`,`itemtype`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `estructura_catalogacion_opac` (
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `feriados` (
  `fecha` date NOT NULL default '0000-00-00',
  UNIQUE KEY `fecha` (`fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `generic_report_joins` (
  `table1` varchar(50) NOT NULL,
  `field1` varchar(50) NOT NULL,
  `table2` varchar(50) NOT NULL,
  `field2` varchar(50) NOT NULL,
  `unionjoin` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `generic_report_tables` (
  `tabla` varchar(50) NOT NULL,
  `campo` varchar(50) NOT NULL,
  `nombre` varchar(100) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `historialBusqueda` (
  `idHistorial` int(11) NOT NULL auto_increment,
  `idBusqueda` int(11) NOT NULL,
  `campo` varchar(100) NOT NULL,
  `valor` varchar(100) NOT NULL,
  `tipo` varchar(10) default NULL,
  PRIMARY KEY  (`idHistorial`),
  KEY `FK_idBusqueda` (`idBusqueda`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=121 ;

CREATE TABLE `historicCirculation` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(15) NOT NULL default '',
  `borrowernumber` int(11) NOT NULL,
  `responsable` varchar(20) NOT NULL,
  `id1` int(11) NOT NULL default '0',
  `id2` int(11) NOT NULL default '0',
  `branchcode` varchar(4) default NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `id3` int(11) default NULL,
  `date` date NOT NULL default '0000-00-00',
  `nota` varchar(50) default NULL,
  `end_date` date default NULL,
  `issuetype` char(2) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=5146 ;

CREATE TABLE `historicIssues` (
  `borrowernumber` int(11) NOT NULL default '0',
  `id3` int(11) NOT NULL default '0',
  `date_due` date default NULL,
  `branchcode` char(4) default NULL,
  `issuingbranch` char(18) default NULL,
  `returndate` date default NULL,
  `lastreneweddate` date default NULL,
  `return` char(4) default NULL,
  `renewals` tinyint(4) default NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `historicSanctions` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(15) NOT NULL default '',
  `borrowernumber` int(11) NOT NULL default '0',
  `responsable` varchar(20) NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `date` date NOT NULL default '0000-00-00',
  `end_date` date default NULL,
  `sanctiontypecode` int(11) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=107 ;


CREATE TABLE `informacion_referencias` (
  `idinforef` int(11) NOT NULL auto_increment,
  `idestcat` int(11) NOT NULL,
  `referencia` varchar(255) NOT NULL,
  `orden` varchar(255) NOT NULL,
  `campos` varchar(255) NOT NULL,
  `separador` varchar(3) default NULL,
  PRIMARY KEY  (`idinforef`),
  KEY `idestcat` (`idestcat`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;



CREATE TABLE `iso2709` (
  `id` int(11) NOT NULL auto_increment,
  `campoIso` smallint(6) NOT NULL default '0',
  `subCampoIso` char(1) default NULL,
  `descripcion` text,
  `kohaTabla` varchar(100) default NULL,
  `kohaCampo` varchar(100) default NULL,
  `ui` text NOT NULL,
  `marc_koha_field` text NOT NULL,
  `marc_table_field` text NOT NULL,
  `orden` int(1) default NULL,
  `separador` varchar(5) default NULL,
  `interfazWeb` varchar(5) default NULL,
  `tipo` varchar(10) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

CREATE TABLE `issues` (
  `borrowernumber` int(11) NOT NULL default '0',
  `id3` int(11) NOT NULL default '0',
  `issuecode` char(2) NOT NULL default 'DO',
  `date_due` date default NULL,
  `branchcode` char(4) default NULL,
  `issuingbranch` char(18) default NULL,
  `returndate` date default NULL,
  `lastreneweddate` date default NULL,
  `return` char(4) default NULL,
  `renewals` tinyint(4) default NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  KEY `issuesborridx` (`borrowernumber`),
  KEY `issuesitemidx` (`id3`),
  KEY `bordate` (`borrowernumber`,`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `issuetypes` (
  `issuecode` char(2) NOT NULL default '',
  `description` text,
  `notforloan` tinyint(1) NOT NULL default '0',
  `maxissues` int(11) NOT NULL,
  `daysissues` int(11) NOT NULL,
  `renew` int(11) NOT NULL default '0',
  `renewdays` tinyint(3) NOT NULL,
  `dayscanrenew` tinyint(10) NOT NULL,
  `enabled` tinyint(4) default '1',
  PRIMARY KEY  (`issuecode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `itemtypes` (
  `itemtype` varchar(4) NOT NULL default '',
  `description` text,
  `loanlength` smallint(6) default NULL,
  `renewalsallowed` smallint(6) default NULL,
  `rentalcharge` double(16,4) default NULL,
  `notforloan` smallint(6) default NULL,
  `search` varchar(30) NOT NULL default '',
  `detail` text NOT NULL,
  UNIQUE KEY `itemtype` (`itemtype`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `keyword` (
  `idkeyword` int(11) NOT NULL auto_increment,
  `keyword` varchar(150) NOT NULL,
  PRIMARY KEY  (`idkeyword`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `kohaToMARC` (
  `idmap` int(11) NOT NULL auto_increment,
  `tabla` varchar(100) NOT NULL,
  `campoTabla` varchar(100) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `campo` varchar(3) NOT NULL,
  `subcampo` varchar(1) NOT NULL,
  PRIMARY KEY  (`idmap`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=20 ;

CREATE TABLE `languages` (
  `idLanguage` char(2) NOT NULL default '',
  `description` varchar(30) NOT NULL default ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `localidades` (
  `LOCALIDAD` varchar(11) NOT NULL default '0',
  `NOMBRE` varchar(100) default NULL,
  `NOMBRE_ABREVIADO` varchar(40) default NULL,
  `DPTO_PARTIDO` varchar(11) default NULL,
  `DDN` varchar(11) default NULL,
  PRIMARY KEY  (`LOCALIDAD`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `marc_blob_subfield` (
  `blobidlink` bigint(20) NOT NULL auto_increment,
  `subfieldvalue` longtext NOT NULL,
  PRIMARY KEY  (`blobidlink`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=32 ;

CREATE TABLE `marc_breeding` (
  `id` bigint(20) NOT NULL auto_increment,
  `file` varchar(80) NOT NULL default '',
  `isbn` varchar(10) NOT NULL default '',
  `title` varchar(128) default NULL,
  `author` varchar(80) default NULL,
  `marc` text NOT NULL,
  `z3950random` varchar(40) default NULL,
  `encoding` varchar(40) NOT NULL default '''''',
  PRIMARY KEY  (`id`),
  KEY `title` (`title`),
  KEY `isbn` (`isbn`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `marc_subfield_structure` (
  `nivel` tinyint(1) NOT NULL default '0',
  `obligatorio` tinyint(1) NOT NULL default '0',
  `tagfield` char(3) NOT NULL default '',
  `tagsubfield` char(1) NOT NULL default '',
  `liblibrarian` char(255) NOT NULL default '',
  `libopac` char(255) NOT NULL default '',
  `repeatable` tinyint(4) NOT NULL default '0',
  `mandatory` tinyint(4) NOT NULL default '0',
  `kohafield` char(40) default NULL,
  `tab` tinyint(1) default NULL,
  `authorised_value` char(13) default NULL,
  `thesaurus_category` char(10) default NULL,
  `value_builder` char(80) default NULL,
  PRIMARY KEY  (`tagfield`,`tagsubfield`),
  KEY `kohafield` (`kohafield`),
  KEY `tab` (`tab`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


CREATE TABLE `marc_tag_structure` (
  `tagfield` char(3) NOT NULL default '',
  `liblibrarian` char(255) NOT NULL default '',
  `libopac` char(255) NOT NULL default '',
  `repeatable` tinyint(4) NOT NULL default '0',
  `mandatory` tinyint(4) NOT NULL default '0',
  `authorised_value` char(10) default NULL,
  PRIMARY KEY  (`tagfield`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `marcrecorddone` (
  `isbn` char(40) default NULL,
  `issn` char(40) default NULL,
  `lccn` char(40) default NULL,
  `controlnumber` char(40) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `modificaciones` (
  `idModificacion` int(4) NOT NULL auto_increment,
  `operacion` varchar(15) default NULL,
  `fecha` date default NULL,
  `responsable` varchar(20) default '0',
  `nota` varchar(50) default NULL,
  `numero` int(5) default '0',
  `tipo` varchar(15) default NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  KEY `id_modificacion` (`idModificacion`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1  ;

CREATE TABLE `nivel1` (
  `id1` int(11) NOT NULL auto_increment,
  `titulo` varchar(100) NOT NULL,
  `autor` int(11) NOT NULL,
  `timestamp` timestamp NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id1`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1  ;

CREATE TABLE `nivel1_repetibles` (
  `rep_n1_id` int(11) NOT NULL auto_increment,
  `id1` int(11) NOT NULL,
  `campo` varchar(3) default NULL,
  `subcampo` varchar(3) NOT NULL,
  `dato` varchar(250) NOT NULL,
  `timestamp` timestamp NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`rep_n1_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

CREATE TABLE `nivel2` (
  `id2` int(11) NOT NULL auto_increment,
  `id1` int(11) NOT NULL,
  `tipo_documento` varchar(4) NOT NULL,
  `nivel_bibliografico` varchar(2) NOT NULL,
  `soporte` varchar(3) NOT NULL,
  `pais_publicacion` char(2) NOT NULL,
  `lenguaje` char(2) NOT NULL,
  `ciudad_publicacion` varchar(20) NOT NULL,
  `anio_publicacion` varchar(15) default NULL,
  `timestamp` timestamp NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id2`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1  ;

CREATE TABLE `nivel2_repetibles` (
  `rep_n2_id` int(11) NOT NULL auto_increment,
  `id2` int(11) NOT NULL,
  `campo` varchar(3) default NULL,
  `subcampo` varchar(3) NOT NULL,
  `dato` varchar(250) default NULL,
  `timestamp` timestamp NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`rep_n2_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

CREATE TABLE `nivel3` (
  `id3` int(11) NOT NULL auto_increment,
  `id1` int(11) NOT NULL,
  `id2` int(11) NOT NULL,
  `barcode` varchar(20) default NULL,
  `signatura_topografica` varchar(30) default NULL,
  `holdingbranch` varchar(15) default NULL,
  `homebranch` varchar(15) default NULL,
  `wthdrawn` smallint(1) NOT NULL default '0',
  `notforloan` char(2) default '0',
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP, 
 PRIMARY KEY  (`id3`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ;

CREATE TABLE `nivel3_repetibles` (
  `rep_n3_id` int(11) NOT NULL auto_increment,
  `id3` int(11) NOT NULL,
  `campo` varchar(3) default NULL,
  `subcampo` varchar(3) NOT NULL,
  `dato` varchar(250) NOT NULL,
  `timestamp` timestamp NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`rep_n3_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `persons` (
  `personnumber` int(11) NOT NULL auto_increment,
  `borrowernumber` int(11) default NULL,
  `cardnumber` varchar(16) NOT NULL default '',
  `documentnumber` varchar(16) NOT NULL default '',
  `documenttype` char(3) NOT NULL default '',
  `surname` text NOT NULL,
  `firstname` text NOT NULL,
  `title` text,
  `othernames` text,
  `initials` text,
  `streetaddress` text,
  `suburb` text,
  `city` text,
  `phone` text,
  `emailaddress` text,
  `faxnumber` text,
  `textmessaging` text,
  `altstreetaddress` text,
  `altsuburb` text,
  `altcity` text,
  `altphone` text,
  `dateofbirth` date default NULL,
  `branchcode` varchar(4) NOT NULL default '',
  `categorycode` char(2) default NULL,
  `dateenrolled` date default NULL,
  `gonenoaddress` tinyint(1) default NULL,
  `lost` tinyint(1) default NULL,
  `debarred` tinyint(1) default NULL,
  `studentnumber` text,
  `school` text,
  `contactname` text,
  `borrowernotes` text,
  `guarantor` int(11) default NULL,
  `area` char(2) default NULL,
  `ethnicity` varchar(50) default NULL,
  `ethnotes` varchar(255) default NULL,
  `sex` char(1) default NULL,
  `expiry` date default NULL,
  `altnotes` varchar(255) default NULL,
  `altrelationship` varchar(100) default NULL,
  `streetcity` text,
  `phoneday` varchar(50) default NULL,
  `preferredcont` char(1) default NULL,
  `physstreet` varchar(100) default NULL,
  `homezipcode` varchar(25) default NULL,
  `zipcode` varchar(25) default NULL,
  `userid` varchar(30) default NULL,
  `flags` int(11) default NULL,
  `regular` tinyint(1) NOT NULL default '0',
  UNIQUE KEY `cardnumber` (`cardnumber`),
  KEY `personnumber` (`personnumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `provincias` (
  `PROVINCIA` varchar(11) NOT NULL default '0',
  `NOMBRE` varchar(60) default NULL,
  `PAIS` varchar(11) default '0',
  PRIMARY KEY  (`PROVINCIA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `reserves` (
  `id2` int(11) NOT NULL,
  `id3` int(11) default NULL,
  `reservenumber` int(11) NOT NULL auto_increment,
  `borrowernumber` int(11) NOT NULL default '0',
  `reservedate` date NOT NULL default '0000-00-00',
  `estado` char(1) default NULL,
  `branchcode` varchar(4) default NULL,
  `notificationdate` date default NULL,
  `reminderdate` date default NULL,
  `cancellationdate` date default NULL,
  `reservenotes` text,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`reservenumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

CREATE TABLE `sanctionissuetypes` (
  `sanctiontypecode` int(11) NOT NULL default '0',
  `issuecode` char(2) NOT NULL default '',
  PRIMARY KEY  (`sanctiontypecode`,`issuecode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sanctionrules` (
  `sanctionrulecode` int(11) NOT NULL auto_increment,
  `sanctiondays` int(11) NOT NULL default '0',
  `delaydays` int(11) NOT NULL default '0',
  PRIMARY KEY  (`sanctionrulecode`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=22 ;

CREATE TABLE `sanctions` (
  `sanctionnumber` int(11) NOT NULL auto_increment,
  `sanctiontypecode` int(11) default '0',
  `reservenumber` int(11) default NULL,
  `borrowernumber` int(11) NOT NULL default '0',
  `startdate` date default '0000-00-00',
  `enddate` date default '0000-00-00',
  `delaydays` int(11) default '0',
  `id3` int(11) default NULL,
  PRIMARY KEY  (`sanctionnumber`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

CREATE TABLE `sanctiontypes` (
  `sanctiontypecode` int(11) NOT NULL auto_increment,
  `categorycode` char(2) NOT NULL default '',
  `issuecode` char(2) NOT NULL default '',
  PRIMARY KEY  (`sanctiontypecode`),
  UNIQUE KEY `categoryissuecode` (`categorycode`,`issuecode`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=44 ;

CREATE TABLE `sanctiontypesrules` (
  `sanctiontypecode` int(11) NOT NULL default '0',
  `sanctionrulecode` int(11) NOT NULL default '0',
  `orden` int(11) NOT NULL default '1',
  `amount` int(11) NOT NULL default '1',
  PRIMARY KEY  (`sanctiontypecode`,`sanctionrulecode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `sessionqueries` (
  `sessionID` varchar(255) NOT NULL default '',
  `userid` varchar(100) NOT NULL default '',
  `ip` varchar(18) NOT NULL default '',
  `url` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sessions` (
  `sessionID` varchar(255) NOT NULL default '',
  `userid` varchar(255) default NULL,
  `ip` varchar(16) default NULL,
  `lasttime` int(11) default NULL,
  PRIMARY KEY  (`sessionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `shelfcontents` (
  `id2` int(11) NOT NULL default '0',
  `shelfnumber` int(11) NOT NULL default '0',
  `flags` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `stopwords` (
  `word` varchar(255) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `supports` (
  `idSupport` varchar(10) NOT NULL default '',
  `description` varchar(30) NOT NULL default ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `systempreferences` (
  `variable` varchar(50) NOT NULL default '',
  `value` text,
  `explanation` varchar(200) NOT NULL default '',
  `options` text,
  `type` varchar(20) default NULL,
  PRIMARY KEY  (`variable`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 PACK_KEYS=1;

CREATE TABLE `tablasDeReferencias` (
  `referencia` varchar(20) NOT NULL,
  `nomcamporeferencia` varchar(20) NOT NULL,
  `camporeferencia` tinyint(2) NOT NULL default '0',
  `referente` varchar(20) NOT NULL,
  `camporeferente` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tablasDeReferenciasInfo` (
  `orden` varchar(20) NOT NULL,
  `referencia` varchar(30) NOT NULL,
  `similares` varchar(20) NOT NULL,
  PRIMARY KEY  (`referencia`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `temas` (
  `id` int(11) NOT NULL auto_increment,
  `nombre` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1009 ;

CREATE TABLE `unavailable` (
  `code` tinyint(5) NOT NULL default '0',
  `description` varchar(30) NOT NULL default '',
  PRIMARY KEY  (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `uploadedmarc` (
  `id` int(11) NOT NULL auto_increment,
  `marc` longblob,
  `hidden` smallint(6) default NULL,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `userflags` (
  `bit` int(11) NOT NULL default '0',
  `flag` char(30) default NULL,
  `flagdesc` char(255) default NULL,
  `defaulton` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `usercode` varchar(10) default NULL,
  `username` text,
  `password` text,
  `level` smallint(6) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `z3950queue` (
  `id` int(11) NOT NULL auto_increment,
  `term` text,
  `type` varchar(10) default NULL,
  `startdate` int(11) default NULL,
  `enddate` int(11) default NULL,
  `done` smallint(6) default NULL,
  `results` longblob,
  `numrecords` int(11) default NULL,
  `servers` text,
  `identifier` varchar(30) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

CREATE TABLE `z3950results` (
  `id` int(11) NOT NULL auto_increment,
  `queryid` int(11) default NULL,
  `server` varchar(255) default NULL,
  `startdate` int(11) default NULL,
  `enddate` int(11) default NULL,
  `results` longblob,
  `numrecords` int(11) default NULL,
  `numdownloaded` int(11) default NULL,
  `highestseen` int(11) default NULL,
  `active` smallint(6) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `query_server` (`queryid`,`server`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

CREATE TABLE `z3950servers` (
  `id` int(11) NOT NULL auto_increment,
  `host` varchar(255) default NULL,
  `port` int(11) default NULL,
  `db` varchar(255) default NULL,
  `userid` varchar(255) default NULL,
  `password` varchar(255) default NULL,
  `name` text,
  `checked` smallint(6) default NULL,
  `rank` int(11) default NULL,
  `syntax` varchar(80) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

CREATE TABLE `categories` (
  `categorycode` char(2) NOT NULL default '',
  `description` text,
  `enrolmentperiod` smallint(6) default NULL,
  `upperagelimit` smallint(6) default NULL,
  `dateofbirthrequired` tinyint(1) default NULL,
  `finetype` varchar(30) default NULL,
  `bulk` tinyint(1) default NULL,
  `enrolmentfee` decimal(28,6) default NULL,
  `overduenoticerequired` tinyint(1) default NULL,
  `issuelimit` smallint(6) default NULL,
  `reservefee` decimal(28,6) default NULL,
  `borrowingdays` smallint(30) NOT NULL default '14',
  UNIQUE KEY `categorycode` (`categorycode`)
) ENGINE=innodb DEFAULT CHARSET=latin1;

CREATE TABLE `referenciaColaboradores` (
  `id` int(11) NOT NULL auto_increment,
  `descripcion` varchar(35) NOT NULL,
  `codigo` varchar(8) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=innodb  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

CREATE TABLE `amazon_covers` (
  `isbn` varchar(50) NOT NULL,
  `small` varchar(500) default NULL,
  `medium` varchar(500) default NULL,
  `large` varchar(50) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



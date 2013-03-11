


    ALTER TABLE rep_historial_busqueda CHANGE `HTTP_USER_AGENT` `agent` VARCHAR( 255 ) NOT NULL;
    
    ALTER TABLE rep_busqueda CHANGE `borrower` `nro_socio` INT( 11 ) NULL DEFAULT NULL;
    
    ALTER TABLE `rep_busqueda` CHANGE `nro_socio` `nro_socio` VARCHAR( 16 ) NULL DEFAULT NULL;
    
    ALTER TABLE circ_reserva CHANGE `reservenumber` `id_reserva` INT(11) NOT NULL AUTO_INCREMENT,
      CHANGE `reservedate` `fecha_reserva` VARCHAR(20) NOT NULL,
      CHANGE `constrainttype` `estado` CHAR(1) NULL DEFAULT NULL, 
      CHANGE `branchcode` `id_ui` VARCHAR(4) NULL DEFAULT NULL, 
      CHANGE `notificationdate` `fecha_notificacion` VARCHAR(20) NULL DEFAULT NULL, 
      CHANGE `reminderdate` `fecha_recordatorio` VARCHAR(20) NULL DEFAULT NULL;
    
     ALTER TABLE circ_reserva  ADD `nro_socio` VARCHAR( 16 ) NOT NULL DEFAULT '0' AFTER id_reserva ;

    ALTER TABLE circ_reserva  DROP `cancellationdate`,  DROP `reservenotes`,  DROP `priority`,  DROP `found`;
    
    ALTER TABLE circ_prestamo 
      CHANGE `issuecode` `tipo_prestamo` CHAR( 2 ) NOT NULL DEFAULT 'DO',
      CHANGE `date_due` `fecha_prestamo` VARCHAR( 20 ) NULL DEFAULT NULL ,
      CHANGE `branchcode` `id_ui_origen` CHAR( 4 ) NULL DEFAULT NULL ,
      CHANGE `issuingbranch` `id_ui_prestamo` CHAR( 18 ) NULL DEFAULT NULL ,
      CHANGE `returndate` `fecha_devolucion` VARCHAR( 20 ) NULL DEFAULT NULL ,
      CHANGE `lastreneweddate` `fecha_ultima_renovacion` VARCHAR( 20 ) NULL DEFAULT NULL ,
      CHANGE `renewals` `renovaciones` TINYINT( 4 ) NULL DEFAULT NULL;
      
     ALTER TABLE circ_prestamo  ADD `nro_socio` VARCHAR( 16 ) NOT NULL DEFAULT '0'  AFTER id3 ;

    ALTER TABLE circ_prestamo DROP `return`;
      
      ALTER TABLE `usr_persona` CHANGE `personnumber` `id_persona` INT(11) NOT NULL AUTO_INCREMENT;
      ALTER TABLE `usr_persona` CHANGE `borrowernumber` id_socio INT(11) NULL DEFAULT NULL;
      ALTER TABLE `usr_persona` CHANGE `cardnumber` nro_socio VARCHAR(16) NOT NULL;
      ALTER TABLE `usr_persona` CHANGE `documentnumber` `nro_documento` VARCHAR(16) NOT NULL;
       ALTER TABLE `usr_persona` CHANGE `documenttype` `tipo_documento` CHAR(3) NOT NULL;
       ALTER TABLE `usr_persona` CHANGE `surname` `apellido` TEXT NOT NULL; 
       ALTER TABLE `usr_persona` CHANGE `firstname` `nombre` TEXT  NOT NULL;
       ALTER TABLE `usr_persona` CHANGE `title` `titulo` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `othernames` `otros_nombres` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `initials` `iniciales` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `streetaddress` `calle` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `suburb` `barrio` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `city` `ciudad` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `phone` `telefono` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `emailaddress` `email` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `faxnumber` `fax` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `textmessaging` `msg_texto` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `altstreetaddress` `alt_calle` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `altsuburb` `alt_barrio` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `altcity` `alt_ciudad` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `altphone` `alt_telefono` TEXT NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `dateofbirth` `nacimiento` DATE NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `dateenrolled` `fecha_alta` DATE NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `studentnumber` legajo VARCHAR( 8 ) NOT NULL;
       ALTER TABLE `usr_persona` CHANGE `sex` `sexo` CHAR(1) NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `phoneday` `telefono_laboral` VARCHAR(50)  NULL DEFAULT NULL;
       ALTER TABLE `usr_persona` CHANGE `regular` `cumple_condicion` TINYINT(1) NOT NULL DEFAULT '0';
       
        ALTER TABLE `usr_persona` DROP `gonenoaddress`,  DROP `lost`,  DROP `debarred`,  DROP `school`,  DROP `contactname`,  DROP `borrowernotes`,  DROP `guarantor`,  DROP `area`,  DROP `ethnicity`,  DROP `ethnotes`,  DROP `expiry`,  DROP `altnotes`,  DROP `altrelationship`,  DROP `streetcity`,  DROP `preferredcont`,  DROP `physstreet`,  DROP `homezipcode`,  DROP `zipcode`,  DROP `userid`,  DROP `flags`;
       
       ALTER TABLE `usr_persona` ADD PRIMARY KEY ( `id_persona` ) ;
       ALTER TABLE `usr_persona` DROP INDEX `personnumber` ;

        ALTER TABLE `usr_socio` CHANGE `cardnumber` `nro_socio` VARCHAR( 16 ) NOT NULL ;
        ALTER TABLE `usr_socio` CHANGE `borrowernumber` `id_socio` INT( 11 ) NOT NULL AUTO_INCREMENT ;
        ALTER TABLE `usr_socio` CHANGE `branchcode` `id_ui` VARCHAR( 4 ) NOT NULL ;
        ALTER TABLE `usr_socio` CHANGE `categorycode` `cod_categoria` CHAR( 2 ) NOT NULL ;
        ALTER TABLE `usr_socio` CHANGE `dateenrolled` `fecha_alta` DATE NULL DEFAULT NULL ;
        ALTER TABLE `usr_socio` CHANGE `expiry` `expira` DATE NULL DEFAULT NULL ;
        ALTER TABLE `usr_socio` CHANGE `lastlogin` `last_login` DATETIME NULL DEFAULT NULL ;
        ALTER TABLE `usr_socio` CHANGE `lastchangepassword` `last_change_password` DATE NULL DEFAULT NULL ;
        ALTER TABLE `usr_socio` CHANGE `changepassword` `change_password` TINYINT( 1 ) NULL DEFAULT '0';
        ALTER TABLE `usr_socio` CHANGE `usercourse` `cumple_requisito` DATE NULL DEFAULT NULL;

      ALTER TABLE `usr_socio` ADD PRIMARY KEY ( `id_socio` );
        
      ALTER TABLE `usr_socio` DROP INDEX `cardnumber`;
      ALTER TABLE `usr_socio` DROP INDEX `borrowernumber`;

      ALTER TABLE `usr_socio` ADD `nombre_apellido_autorizado` VARCHAR( 255 )  NULL ;

      ALTER TABLE `usr_socio` ADD dni_autorizado VARCHAR( 16 )  NULL ;

      ALTER TABLE `usr_socio` ADD telefono_autorizado VARCHAR( 255 )  NULL ;

      ALTER TABLE `usr_socio` ADD is_super_user INT( 11 )NOT NULL ;

      ALTER TABLE `usr_socio` ADD credential_type VARCHAR( 255 ) NOT NULL ;

      ALTER TABLE `usr_socio` CHANGE `credential_type` `credential_type` VARCHAR( 255 ) NOT NULL DEFAULT 'estudiante';

      ALTER TABLE `usr_socio` ADD id_estado INT( 11 )NOT NULL ;

      ALTER TABLE `usr_socio` ADD activo VARCHAR( 255 ) NOT NULL ;

      ALTER TABLE `usr_socio` ADD agregacion_temp VARCHAR( 255 ) NULL ;
      
      ALTER TABLE `pref_unidad_informacion` CHANGE `branchcode` `id_ui` VARCHAR( 4 )  NOT NULL ,
      CHANGE `branchname` `nombre` TEXT  NOT NULL ,
      CHANGE `branchaddress1` `direccion` TEXT  NULL DEFAULT NULL ,
      CHANGE `branchaddress2` `alt_direccion` TEXT  NULL DEFAULT NULL ,
      CHANGE `branchphone` `telefono` TEXT  NULL DEFAULT NULL ,
      CHANGE `branchfax` `fax` TEXT  NULL DEFAULT NULL ,
      CHANGE `branchemail` `email` TEXT  NULL DEFAULT NULL ;
      
      ALTER TABLE `pref_unidad_informacion`
      DROP `branchaddress3`,
      DROP `issuing`;
      
      ALTER TABLE `pref_unidad_informacion` ADD `id` INT( 11 ) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;

      ALTER TABLE `pref_unidad_informacion` DROP INDEX `branchcode`;

      ALTER TABLE `sist_sesion` ADD `token` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL AFTER `nroRandom` ;

      ALTER TABLE `usr_persona` ADD `version_documento` CHAR( 1 ) NOT NULL DEFAULT 'P' AFTER `id_persona` ;

      ALTER TABLE `usr_persona`    DROP `id_socio`, DROP `nro_socio`;

      ALTER TABLE `usr_persona` DROP `branchcode` , DROP `categorycode` ;

      ALTER TABLE `usr_persona` ADD `es_socio` INT( 1 ) UNSIGNED NOT NULL DEFAULT '0' COMMENT '1= si; 0=no';

      ALTER TABLE `usr_socio` CHANGE `password` `password` VARCHAR( 255 ) NULL DEFAULT NULL;

      ALTER TABLE `usr_socio` ADD `id_persona` INT( 11 ) NOT NULL FIRST ;

      ALTER TABLE `ref_pais` DROP PRIMARY KEY;

      ALTER TABLE `ref_pais` ADD `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;
      
      ALTER TABLE `ref_pais` CHANGE `name` `nombre` VARCHAR( 80 )  NOT NULL ,
      CHANGE `printable_name` `nombre_largo` VARCHAR( 80 ) NOT NULL ,
      CHANGE `code` `codigo` VARCHAR( 11 ) NOT NULL;
      
      ALTER TABLE `cat_ref_tipo_nivel3` DROP INDEX `itemtype`;

      ALTER TABLE `cat_ref_tipo_nivel3` ADD `id` INT( 11 ) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;
     
      ALTER TABLE `cat_ref_tipo_nivel3` DROP `loanlength`;
      ALTER TABLE `cat_ref_tipo_nivel3` DROP `renewalsallowed`;
      ALTER TABLE `cat_ref_tipo_nivel3` DROP `rentalcharge`;
      ALTER TABLE `cat_ref_tipo_nivel3` DROP `search`;
      ALTER TABLE `cat_ref_tipo_nivel3` DROP `detail`;
      
      ALTER TABLE `cat_ref_tipo_nivel3` CHANGE `itemtype` `id_tipo_doc` VARCHAR( 4 ) NOT NULL ,
      CHANGE `description` `nombre` TEXT NULL DEFAULT NULL;
      
      ALTER TABLE ref_idioma ADD `id` INT( 11 ) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;
      
      ALTER TABLE `circ_prestamo` CHANGE id `id_prestamo` INT( 11 ) NOT NULL AUTO_INCREMENT FIRST ;
       
        ALTER TABLE `circ_reserva` DROP `cancellationdate`;
        ALTER TABLE `circ_reserva` DROP `reservenotes`;
        
        ALTER TABLE `circ_sancion` CHANGE `sanctionnumber` `id_sancion` INT( 11 ) NOT NULL AUTO_INCREMENT ,
        CHANGE `sanctiontypecode` `tipo_sancion` INT( 11 ) NULL DEFAULT '0',
        CHANGE `reservenumber` `id_reserva` INT( 11 ) NULL DEFAULT NULL ,
        CHANGE `startdate` `fecha_comienzo` DATE NOT NULL DEFAULT '0000-00-00',
        CHANGE `enddate` `fecha_final` DATE NOT NULL DEFAULT '0000-00-00',
        CHANGE `delaydays` `dias_sancion` INT( 11 ) NULL DEFAULT '0',
        CHANGE `itemnumber` `id3` INT( 11 ) NULL DEFAULT NULL ;
        
         ALTER TABLE `circ_sancion`  ADD `nro_socio` VARCHAR( 16 ) NOT NULL DEFAULT '0'  AFTER id_reserva ;
        
         ALTER TABLE `circ_tipo_prestamo_sancion` CHANGE `sanctiontypecode` `tipo_sancion` INT( 11 ) NOT NULL DEFAULT '0',
         CHANGE `issuecode` `tipo_prestamo` CHAR( 2 ) CHARACTER SET utf8 COLLATE utf8_swedish_ci NOT NULL ;
        
        ALTER TABLE `circ_tipo_sancion` CHANGE `sanctiontypecode` `tipo_sancion` INT( 11 ) NOT NULL AUTO_INCREMENT ,
        CHANGE `categorycode` `categoria_socio` CHAR( 2 ) CHARACTER SET utf8 COLLATE utf8_swedish_ci NOT NULL ,
        CHANGE `issuecode` `tipo_prestamo` CHAR( 2 ) CHARACTER SET utf8 COLLATE utf8_swedish_ci NOT NULL ;

        ALTER TABLE `circ_ref_tipo_prestamo` CHANGE `issuecode` `id_tipo_prestamo` CHAR( 2 ) CHARACTER SET utf8 COLLATE utf8_swedish_ci NOT NULL ;
        ALTER TABLE `circ_ref_tipo_prestamo`  CHANGE `description` `descripcion` TEXT CHARACTER SET utf8 COLLATE utf8_swedish_ci NULL DEFAULT NULL ;
        ALTER TABLE `circ_ref_tipo_prestamo`  CHANGE `notforloan` `id_disponibilidad` TINYINT( 1 ) NOT NULL DEFAULT '0';
        ALTER TABLE `circ_ref_tipo_prestamo`   CHANGE `maxissues` `prestamos` INT( 11 ) NOT NULL DEFAULT '0';
        ALTER TABLE `circ_ref_tipo_prestamo`   CHANGE `daysissues` `dias_prestamo` INT( 11 ) NOT NULL DEFAULT '0';
        ALTER TABLE `circ_ref_tipo_prestamo`    CHANGE `renew` `renovaciones` INT( 11 ) NOT NULL DEFAULT '0';
        ALTER TABLE `circ_ref_tipo_prestamo`   CHANGE `renewdays` `dias_renovacion` TINYINT( 3 ) NOT NULL DEFAULT '0';
        ALTER TABLE `circ_ref_tipo_prestamo`   CHANGE `dayscanrenew` `dias_antes_renovacion` TINYINT( 10 ) NOT NULL DEFAULT '0';
        ALTER TABLE `circ_ref_tipo_prestamo`   CHANGE `enabled` `habilitado` TINYINT( 4 ) NULL DEFAULT '1' ;
         
          ALTER TABLE `circ_ref_tipo_prestamo` DROP PRIMARY KEY ;
         
          ALTER TABLE `circ_ref_tipo_prestamo` ADD `id` INT( 11 ) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;
         
          ALTER TABLE `circ_regla_sancion` CHANGE `sanctionrulecode` `regla_sancion` INT( 11 ) NOT NULL AUTO_INCREMENT ,
          CHANGE `sanctiondays` `dias_sancion` INT( 11 ) NOT NULL DEFAULT '0',
          CHANGE `delaydays` `dias_demora` INT( 11 ) NOT NULL DEFAULT '0';

         ALTER TABLE `circ_regla_tipo_sancion` CHANGE `sanctiontypecode` `tipo_sancion` INT( 11 ) NOT NULL DEFAULT '0',
          CHANGE `sanctionrulecode` `regla_sancion` INT( 11 ) NOT NULL DEFAULT '0',
          CHANGE `orden` `orden` INT( 11 ) NOT NULL DEFAULT '1',
          CHANGE `amount` `cantidad` INT( 11 ) NOT NULL DEFAULT '1';

          ALTER TABLE `circ_prestamo` ADD `agregacion_temp` VARCHAR( 255 ) NULL ;
           
          DROP TABLE IF EXISTS `cat_visualizacion_intra`;

           CREATE TABLE IF NOT EXISTS `cat_visualizacion_intra` (
            `id` int(11) NOT NULL auto_increment,
            `campo` char(3) NOT NULL,
            `subcampo` char(1) NOT NULL,
            `vista_intra` varchar(255) default NULL,
            `tipo_ejemplar` CHAR( 3 ) NOT NULL,
            PRIMARY KEY  (`id`),
            KEY `campo` (`campo`,`subcampo`)
            ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;
            
  INSERT INTO cat_visualizacion_intra (campo, subcampo, tipo_ejemplar, vista_intra) VALUES
                ('245', 'a', 'ALL', 'Título'),
                ('995', 'd', 'ALL', 'Unidad de Información de Origen'),
                ('995', 'c', 'ALL', 'Unidad de Información'),
                ('995', 'o', 'ALL', 'Disponibilidad'),
                ('995', 'e', 'ALL', 'Estado'),
                ('910', 'a', 'ALL', 'Tipo de Documento'),
                ('260', 'c', 'ALL', 'Fecha de publicación'),
                ('043', 'c', 'LIB', 'Código ISO (R)'),
                ('041', 'h', 'LIB', 'Código de idioma de la versión original y/o traducciones intermedias del texto'),
                ('900', 'b', 'ALL', 'Nivel Bibliográfico'),
                ('995', 't', 'ALL', 'Signatura Topográfica'),
                ('995', 'f', 'ALL', 'Código de Barras'),
                ('100', 'a', 'ALL', 'Autor'),
                ('260', 'a', 'ALL', 'Ciudad de publicación'),
                ('245', 'h', 'ALL', 'Medio'),
                ('041', 'a', 'MAP', 'Código de Idioma para texto o pista de sonido o título separado'),
                ('995', 'a', 'LIB', 'Nombre del vendedor'),
                ('084', 'a', 'ALL', 'Otro Número de Clasificación R'),
                ('995', 'u', 'LIB', 'Notas del item'),
                ('022', 'a', 'LIB', 'ISSN'),
                ('082', '2', 'ALL', 'No. de la edición'),
                ('440', 'a', 'LIB', 'Serie - título de la serie'),
                ('020', 'a', 'LIB', 'ISBN'),
                ('245', 'b', 'ALL', 'Resto del título'),
                ('072', '2', 'LIB', 'Fuente del código');

            CREATE TABLE IF NOT EXISTS `cat_visualizacion_opac` (
            `id` int(11) NOT NULL auto_increment,
            `campo` char(3) NOT NULL,
            `subcampo` char(1) NOT NULL,
            `vista_opac` varchar(255) default NULL,
            `id_perfil` int(11) NOT NULL,
            PRIMARY KEY  (`id`),
            KEY `campo` (`campo`,`subcampo`)
            ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

            INSERT INTO `cat_visualizacion_opac` (`campo`, `subcampo`, `vista_opac`, `id_perfil`) VALUES
                ( '245', 'a', 'Título', '1'),
                ( '245', 'b', 'Resto del título', '1'),
                ( '082', '2', 'No. de la edición', '1'),
                ( '084', 'a', 'Otro Número de Clasificación R', '1'),
                ( '245', 'h', 'Medio', '1'),
                ( '260', 'a', 'Ciudad de publicación', '1'),
                ( '100', 'a', 'Autor', '1'),
                ( '995', 'f', 'Código de Barras', '1'),
                ( '995', 't', 'Signatura Topográfica', '1'),
                ( '900', 'b', 'Nivel Bibliográfico', '1'),
                ( '995', 'd', 'Unidad de Información de Origen', '1'),
                ( '260', 'c', 'Fecha de publicación', '1'),
                ( '910', 'a', 'Tipo de Documento', '1'),
                ( '995', 'e', 'Estado', '1'),
                ( '995', 'o', 'Disponibilidad', '1'),
                ( '995', 'c', 'Unidad de Información', '1'),
                ( '041', 'h', 'Código de idioma de la versión original y/o traducciones intermedias del texto', '1'),
                ( '020', 'a', 'ISBN', '1'),
                ( '440', 'a', 'Serie - título de la serie', '1'),
                ( '022', 'a', 'Año', '1'),
                ( '995', 'u', 'Notas del item', '1'),
                ( '995', 'a', 'Nombre del vendedor', '1'),
                ( '043', 'c', 'Código ISO (R)', '1'),
                ( '072', '2', 'Fuente del código', '1');

                CREATE TABLE IF NOT EXISTS `cat_perfil_opac` (
                `id` int(11) NOT NULL auto_increment,
                `nombre` varchar(255) character set utf8 NOT NULL,
                PRIMARY KEY  (`id`)
                ) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;
                
                INSERT INTO `cat_perfil_opac` (`id`, `nombre`) VALUES
                (1, 'Perfil 1');

            CREATE TABLE IF NOT EXISTS `ref_colaborador` (
            `id` int(11) NOT NULL auto_increment,
            `codigo` varchar(10) NOT NULL,
            `descripcion` text NOT NULL,
            PRIMARY KEY  (`id`)
            ) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

INSERT INTO `ref_colaborador` (`id`, `codigo`, `descripcion`) VALUES
(1, 'acp', 'Art copyist'),
(2, 'act', 'Actor'),
(3, 'adp', 'Adapter'),
(4, 'aft', 'Author of afterword, colophon, etc.'),
(5, 'anl', 'Analyst'),
(6, 'anm', 'Animator'),
(7, 'ann', 'Annotator'),
(8, 'ant', 'Bibliographic antecedent'),
(9, 'app', 'Applicant'),
(10, 'aqt', 'Author in quotations or text abstracts'),
(11, 'arc', 'Architect'),
(12, 'ard', 'Artistic director'),
(13, 'arr', 'Arranger'),
(14, 'art', 'Artist'),
(15, 'asg', 'Assignee'),
(16, 'asn', 'Associated name'),
(17, 'att', 'Attributed name'),
(18, 'auc', 'Auctioneer'),
(19, 'aud', 'Author of dialog'),
(20, 'aui', 'Author of introduction'),
(21, 'aus', 'Author of screenplay'),
(22, 'aut', 'Author'),
(23, 'bdd', 'Binding designer'),
(24, 'bjd', 'Bookjacket designer'),
(25, 'bkd', 'Book designer'),
(26, 'bkp', 'Book producer'),
(27, 'bnd', 'Binder'),
(28, 'bpd', 'Bookplate designer'),
(29, 'bsl', 'Bookseller'),
(30, 'ccp', 'Conceptor'),
(31, 'chr', 'Choreographer'),
(32, 'clb', 'Collaborator'),
(33, 'cli', 'Client'),
(34, 'cll', 'Calligrapher'),
(35, 'clt', 'Collotyper'),
(36, 'cmm', 'Commentator'),
(37, 'cmp', 'Composer'),
(38, 'cmt', 'Compositor'),
(39, 'cng', 'Cinematographer'),
(40, 'cnd', 'Conductor'),
(41, 'cns', 'Censor'),
(42, 'coe', 'Contestant -appellee'),
(43, 'col', 'Collector'),
(44, 'com', 'Compiler'),
(45, 'cos', 'Contestant'),
(46, 'cot', 'Contestant -appellant'),
(47, 'cov', 'Cover designer'),
(48, 'cpc', 'Copyright claimant'),
(49, 'cpe', 'Complainant-appellee'),
(50, 'cph', 'Copyright holder'),
(51, 'cpl', 'Complainant'),
(52, 'cpt', 'Complainant-appellant'),
(53, 'cre', 'Creator'),
(54, 'crp', 'Correspondent'),
(55, 'crr', 'Corrector'),
(56, 'csl', 'Consultant'),
(57, 'csp', 'Consultant to a project'),
(58, 'cst', 'Costume designer'),
(59, 'ctb', 'Contributor'),
(60, 'cte', 'Contestee-appellee'),
(61, 'ctg', 'Cartographer'),
(62, 'ctr', 'Contractor'),
(63, 'cts', 'Contestee'),
(64, 'ctt', 'Contestee-appellant'),
(65, 'cur', 'Curator'),
(66, 'cwt', 'Commentator for written text'),
(67, 'dfd', 'Defendant'),
(68, 'dfe', 'Defendant-appellee'),
(69, 'dft', 'Defendant-appellant'),
(70, 'dgg', 'Degree grantor'),
(71, 'dis', 'Dissertant'),
(72, 'dln', 'Delineator'),
(73, 'dnc', 'Dancer'),
(74, 'dnr', 'Donor'),
(75, 'dpc', 'Depicted'),
(76, 'dpt', 'Depositor'),
(77, 'drm', 'Draftsman'),
(78, 'drt', 'Director'),
(79, 'dsr', 'Designer'),
(80, 'dst', 'Distributor'),
(81, 'dtc', 'Data contributor'),
(82, 'dte', 'Dedicatee'),
(83, 'dtm', 'Data manager'),
(84, 'dto', 'Dedicator'),
(85, 'dub', 'Dubious author'),
(86, 'edt', 'Editor'),
(87, 'egr', 'Engraver'),
(88, 'elg', 'Electrician'),
(89, 'elt', 'Electrotyper'),
(90, 'eng', 'Engineer'),
(91, 'etr', 'Etcher'),
(92, 'exp', 'Expert'),
(93, 'fac', 'Facsimilist'),
(94, 'fld', 'Field director'),
(95, 'flm', 'Film editor'),
(96, 'fmo', 'Former owner'),
(97, 'fpy', 'First party'),
(98, 'fnd', 'Funder'),
(99, 'frg', 'Forger'),
(100, 'gis', 'Geographic information specialist'),
(101, '-grt', 'Graphic technician'),
(102, 'hnr', 'Honoree'),
(103, 'hst', 'Host'),
(104, 'ill', 'Illustrator'),
(105, 'ilu', 'Illuminator'),
(106, 'ins', 'Inscriber'),
(107, 'inv', 'Inventor'),
(108, 'itr', 'Instrumentalist'),
(109, 'ive', 'Interviewee'),
(110, 'ivr', 'Interviewer'),
(111, 'lbr', 'Laboratory '),
(112, 'lbt', 'Librettist'),
(113, 'ldr', 'Laboratory director'),
(114, 'led', 'Lead '),
(115, 'lee', 'Libelee-appellee'),
(116, 'lel', 'Libelee'),
(117, 'len', 'Lender'),
(118, 'let', 'Libelee-appellant'),
(119, 'lgd', 'Lighting designer'),
(120, 'lie', 'Libelant-appellee'),
(121, 'lil', 'Libelant'),
(122, 'lit', 'Libelant-appellant'),
(123, 'lsa', 'Landscape architect'),
(124, 'lse', 'Licensee'),
(125, 'lso', 'Licensor'),
(126, 'ltg', 'Lithographer'),
(127, 'lyr', 'Lyricist'),
(128, 'mcp', 'Music copyist'),
(129, 'mfr', 'Manufacturer'),
(130, 'mdc', 'Metadata contact'),
(131, 'mod', 'Moderator'),
(132, 'mon', 'Monitor'),
(133, 'mrk', 'Markup editor'),
(134, 'msd', 'Musical director'),
(135, 'mte', 'Metal-engraver'),
(136, 'mus', 'Musician'),
(137, 'nrt', 'Narrator'),
(138, 'opn', 'Opponent'),
(139, 'org', 'Originator'),
(140, 'orm', 'Organizer of meeting'),
(141, 'oth', 'Other'),
(142, 'own', 'Owner'),
(143, 'pat', 'Patron'),
(144, 'pbd', 'Publishing director'),
(145, 'pbl', 'Publisher'),
(146, 'pdr', 'Project director '),
(147, 'pfr', 'Proofreader'),
(148, 'pht', 'Photographer'),
(149, 'plt', 'Platemaker'),
(150, 'pma', 'Permitting agency'),
(151, 'pmn', 'Production manager'),
(152, 'pop', 'Printer of plates'),
(153, 'ppm', 'Papermaker'),
(154, 'ppt', 'Puppeteer'),
(155, 'prc', 'Process contact'),
(156, 'prd', 'Production personnel'),
(157, 'prf', 'Performer'),
(158, 'prg', 'Programmer'),
(159, 'prm', 'Printmaker'),
(160, 'pro', 'Producer'),
(161, 'prt', 'Printer'),
(162, 'pta', 'Patent applicant'),
(163, 'pte', 'Plaintiff -appellee'),
(164, 'ptf', 'Plaintiff'),
(165, 'pth', 'Patent holder'),
(166, 'ptt', 'Plaintiff-appellant'),
(167, 'rbr', 'Rubricator'),
(168, 'rce', 'Recording engineer'),
(169, 'rcp', 'Recipient'),
(170, 'red', 'Redactor'),
(171, 'ren', 'Renderer'),
(172, 'res', 'Researcher'),
(173, 'rev', 'Reviewer'),
(174, 'rps', 'Repository '),
(175, 'rpt', 'Reporter'),
(176, 'rpy', 'Responsible party'),
(177, 'rse', 'Respondent-appellee'),
(178, 'rsg', 'Restager'),
(179, 'rsp', 'Respondent'),
(180, 'rst', 'Respondent-appellant'),
(181, 'rth', 'Research team head'),
(182, 'rtm', 'Research team member'),
(183, 'sad', 'Scientific advisor'),
(184, 'sce', 'Scenarist'),
(185, 'scl', 'Sculptor'),
(186, 'scr', 'Scribe'),
(187, 'sds', 'Sound designer'),
(188, 'sec', 'Secretary'),
(189, 'sgn', 'Signer'),
(190, 'sht', 'Supporting host'),
(191, 'sng', 'Singer'),
(192, 'spk', 'Speaker'),
(193, 'spn', 'Sponsor'),
(194, 'spy', 'Second party'),
(195, 'srv', 'Surveyor'),
(196, 'std', 'Set designer'),
(197, 'stl', 'Storyteller'),
(198, 'stm', 'Stage manager '),
(199, 'stn', 'Standards body'),
(200, 'str', 'Stereotyper'),
(201, 'tcd', 'Technical director'),
(202, 'tch', 'Teacher'),
(203, 'ths', 'Thesis advisor'),
(204, 'trc', 'Transcriber'),
(205, 'trl', 'Translator'),
(206, 'tyd', 'Type designer'),
(207, 'tyg', 'Typographer'),
(208, 'vdg', 'Videographer'),
(209, 'voc', 'Vocalist'),
(210, 'wam', 'Writer of accompanying material'),
(211, 'wdc', 'Woodcutter'),
(212, 'wde', 'Wood -engraver'),
(213, 'wit', 'Witness');

 ALTER TABLE `rep_historial_circulacion` CHANGE `type` `tipo_operacion` VARCHAR( 15 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
CHANGE `branchcode` `id_ui` VARCHAR( 4 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
CHANGE `date` `fecha` DATE NOT NULL DEFAULT '0000-00-00',
CHANGE `end_date` `fecha_fin` DATE NULL DEFAULT NULL ,
CHANGE `issuetype` `tipo_prestamo` CHAR( 2 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;

ALTER TABLE `rep_historial_circulacion`  ADD `nro_socio` VARCHAR( 16 ) NOT NULL DEFAULT '0' AFTER `tipo_operacion` ;

ALTER TABLE `rep_historial_prestamo`
CHANGE `date_due` `fecha_prestamo` VARCHAR( 20 ) NULL DEFAULT NULL ,
CHANGE `branchcode` `id_ui_origen` CHAR( 4 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
CHANGE `issuingbranch` `id_ui_prestamo` CHAR( 4 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
CHANGE `returndate` `fecha_devolucion` VARCHAR( 20 ) NULL DEFAULT NULL ,
CHANGE `lastreneweddate` `fecha_ultima_renovacion` VARCHAR( 20 ) NULL DEFAULT NULL ,
CHANGE `renewals` `renovaciones` TINYINT( 4 ) NULL DEFAULT NULL ,
CHANGE `timestamp` `timestamp` TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE `rep_historial_prestamo`  ADD `nro_socio` VARCHAR( 16 ) NOT NULL DEFAULT '0' AFTER id3 ;

ALTER TABLE `rep_historial_prestamo` DROP `return`;

ALTER TABLE `rep_historial_prestamo` ADD `id_historial_prestamo` INT( 11 ) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;

ALTER TABLE `rep_historial_prestamo` ADD `tipo_prestamo` CHAR( 2 ) NOT NULL AFTER `nro_socio` ;

ALTER TABLE `rep_historial_prestamo` ADD `agregacion_temp` VARCHAR( 255 ) NULL ;

ALTER TABLE `rep_historial_sancion` CHANGE `type` `tipo_operacion` VARCHAR( 30 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
CHANGE `date` `fecha` DATE NOT NULL DEFAULT '0000-00-00',
CHANGE `end_date` `fecha_final` DATE NULL DEFAULT NULL ,
CHANGE `sanctiontypecode` `tipo_sancion` INT( 11 ) NULL DEFAULT '0';

ALTER TABLE `rep_historial_sancion`  ADD `nro_socio` VARCHAR( 16 ) NOT NULL DEFAULT '0' AFTER `tipo_operacion` ;

ALTER TABLE `ref_nivel_bibliografico` DROP PRIMARY KEY ;

ALTER TABLE `ref_nivel_bibliografico` ADD `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

ALTER TABLE `ref_soporte` ADD `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;

ALTER TABLE  `usr_socio` ADD  `theme` VARCHAR( 255 ) NULL DEFAULT  'default';

ALTER TABLE  `usr_socio` ADD  `theme_intra` VARCHAR( 255 ) NULL DEFAULT  'default';

ALTER TABLE  `pref_feriado` CHANGE  `fecha`  `fecha` VARCHAR( 10 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT  '0000-00-00';

ALTER TABLE  `pref_feriado` ADD  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;

ALTER TABLE `rep_historial_circulacion` CHANGE `id3` `id3` INT( 11 ) NULL ;

ALTER TABLE  `perm_circulacion` ADD  `circ_opac` VARBINARY( 8 ) NOT NULL DEFAULT  '00000000';

ALTER TABLE  `pref_feriado` ADD  `feriado` VARCHAR( 255 ) NULL ;

ALTER TABLE  `usr_socio` ADD  `locale` VARCHAR( 32 ) NULL ;

ALTER TABLE  `cat_ref_tipo_nivel3` ADD  `agregacion_temp` VARCHAR( 255 ) NULL ;

ALTER TABLE  `rep_busqueda` ADD  `categoria_socio` VARCHAR( 255 ) NULL ;

ALTER TABLE  `rep_busqueda` CHANGE  `categoria_socio`  `categoria_socio` CHAR( 2 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;

ALTER TABLE  `rep_busqueda` ADD  `agregacion_temp` VARCHAR( 255 ) NOT NULL ;

ALTER TABLE `cat_estante` CHANGE `shelfnumber` `id` INT( 11 ) NOT NULL AUTO_INCREMENT ,
CHANGE `shelfname` `estante` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
CHANGE `type` `tipo` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL ,
CHANGE `parent` `padre` INT( 11 ) NOT NULL DEFAULT '0';

ALTER TABLE `cat_contenido_estante` CHANGE `shelfnumber` `id_estante` INT( 11 ) NOT NULL DEFAULT '0';

ALTER TABLE `cat_contenido_estante` DROP PRIMARY KEY ,ADD PRIMARY KEY ( `id_estante` , `id2` );

ALTER TABLE `cat_contenido_estante` DROP `flags`;

ALTER TABLE  `cat_registro_marc_n3` ADD  `agregacion_temp` VARCHAR( 255 ) NULL ;

ALTER TABLE `rep_registro_modificacion` CHANGE `nota` `nota` TEXT CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;

ALTER TABLE  `rep_registro_modificacion` ADD  `agregacion_temp` VARCHAR( 255 ) NULL ;

ALTER TABLE  `rep_historial_busqueda` ADD  `agregacion_temp` VARCHAR( 255 ) NULL ;

ALTER TABLE  `rep_busqueda` ADD  `agregacion_temp` VARCHAR( 255 ) NULL;

ALTER TABLE `rep_busqueda` CHANGE `agregacion_temp` `agregacion_temp` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL  ;

ALTER TABLE `indice_busqueda` ADD `string_tabla_con_dato` TEXT NOT NULL AFTER `string` ;

ALTER TABLE `indice_busqueda` ADD `string_con_dato` TEXT NULL AFTER `string_tabla_con_dato` ;

ALTER TABLE `circ_tipo_prestamo_sancion` ADD `detalle` VARCHAR( 255 ) NOT NULL ;

ALTER TABLE  `cat_registro_marc_n3` ADD  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ;
ALTER TABLE `cat_historico_disponibilidad` CHANGE `id3` `id3` INT( 11 ) NOT NULL ;

ALTER TABLE `cat_portada_registro` CHANGE `id` `id` INT( 11 ) NOT NULL AUTO_INCREMENT;


ALTER TABLE `ref_dpto_partido` CHANGE COLUMN `PROVINCIA` `ref_provincia_id` VARCHAR(11) NOT NULL  ,  CHANGE COLUMN `DPTO_PARTIDO` `id` VARCHAR(11) NOT NULL DEFAULT ''  , 
  ADD CONSTRAINT `fk_ref_dpto_partido_ref_provincia1`
  FOREIGN KEY (`ref_provincia_id` )
  REFERENCES `ref_provincia` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
, DROP PRIMARY KEY 
, ADD PRIMARY KEY (`id`) 
, ADD INDEX `fk_ref_dpto_partido_ref_provincia1` (`ref_provincia_id` ASC) ;

ALTER TABLE `ref_localidad` CHANGE COLUMN `DPTO_PARTIDO` `ref_dpto_partido_id` VARCHAR(11) NOT NULL  , 
  ADD CONSTRAINT `fk_ref_localidad_ref_dpto_partido1`
  FOREIGN KEY (`ref_dpto_partido_id` )
  REFERENCES `ref_dpto_partido` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
, ADD INDEX `fk_ref_localidad_ref_dpto_partido1` (`ref_dpto_partido_id` ASC) ;

ALTER TABLE `ref_provincia` CHANGE COLUMN `PAIS` `ref_pais_id` INT(11) NOT NULL ,  CHANGE COLUMN `PROVINCIA` `id` VARCHAR(11) NOT NULL DEFAULT '0'  , 
  ADD CONSTRAINT `fk_ref_provincia_ref_pais1`
  FOREIGN KEY (`ref_pais_id` )
  REFERENCES `ref_pais` (`id` )
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
, DROP PRIMARY KEY 
, ADD PRIMARY KEY (`id`) 
, ADD INDEX `fk_ref_provincia_ref_pais1` (`ref_pais_id` ASC) ;

INSERT INTO `usr_ref_tipo_documento` (`id`, `nombre`, `descripcion`) VALUES (0, 'INDEFINIDO', 'para las personas jurídicas');

ALTER TABLE `cat_historico_disponibilidad` ADD `id_detalle` INT( 11 ) NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST ;
ALTER TABLE `cat_historico_disponibilidad` CHANGE `avail` `detalle` VARCHAR( 30 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '';
ALTER TABLE `cat_historico_disponibilidad` CHANGE `loan` `tipo_prestamo` VARCHAR( 15 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '';

ALTER TABLE `cat_historico_disponibilidad`  DROP `date`;
ALTER TABLE `cat_historico_disponibilidad`  DROP `branch`;

DROP TABLE IF EXISTS cat_editorial;

CREATE TABLE  `cat_editorial` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`editorial` VARCHAR( 255 ) NOT NULL
) ENGINE = MYISAM ;

INSERT INTO `pref_tabla_referencia` (`id`, `nombre_tabla`, `alias_tabla`, `campo_busqueda`) VALUES (NULL, 'cat_editorial', 'editorial', 'editorial');

ALTER TABLE `cat_registro_marc_n3` DROP `date`;
ALTER TABLE `cat_registro_marc_n3` ADD `updated_at` TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `id1`;
ALTER TABLE `cat_registro_marc_n3` ADD `created_at` DATETIME NOT NULL AFTER `updated_at`;

ALTER TABLE `cat_estructura_catalogacion` ADD `edicion_grupal` TINYINT NOT NULL DEFAULT '1' AFTER `visible` ;

ALTER TABLE `usr_socio` ADD  `lastValidation` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

UPDATE `usr_persona` SET `ciudad` =999999 WHERE ciudad IS NULL OR ciudad = '';

INSERT INTO cat_ref_tipo_nivel3( id_tipo_doc, nombre, notforloan ) VALUES ('ANA', 'Analítica', 1 );

DROP TABLE `usr_permiso` ;

CREATE TABLE IF NOT EXISTS `cat_colaborador` (
  `id1` int(11) NOT NULL,
  `idColaborador` int(11) NOT NULL,
  `tipo` varchar(10) DEFAULT NULL,
  KEY `idColaborador` (`idColaborador`),
  KEY `biblionumber` (`id1`,`idColaborador`,`tipo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS `cat_ref_colaborador` (
  `descripcion` varchar(35) DEFAULT NULL,
  `codigo` varchar(8) DEFAULT NULL,
  `index` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`index`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=19 ;


INSERT INTO `cat_ref_colaborador` (`descripcion`, `codigo`, `index`) VALUES
('Compilador, compiler', 'comp.', 1),
('Director', 'dir.', 2),
('Editor', 'ed.', 3),
('Ilustrador', 'il.', 4),
('Introducción', 'introd.', 5),
('Prefacio', 'pref.', 6),
('Prólogo', 'pról.', 7),
('Revisado, a.', 'rev.', 8),
('Traductor, translator, traducción', 'tr.', 9),
('Colaborador', 'colab.', 10),
('Coordinador', 'coord.', 11),
('Profesor', 'prof.', 12),
('Sonido', 'son.', 13),
('Montaje', 'mon.', 14),
('Curador', 'cur.', 15),
('Diseñador', 'dis.', 16),
('Grabados', 'grab.', 17),
('Diagramador', 'diag.', 18);


CREATE TABLE IF NOT EXISTS `oai_harvester_register` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `server_id` tinyint(4) NOT NULL,
  `oai_identifier` varchar(255) DEFAULT NULL,
  `record` mediumtext NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;



CREATE TABLE IF NOT EXISTS `oai_harvester_server` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `mail` varchar(255) DEFAULT NULL,
  `version` varchar(10) DEFAULT NULL,
  `firstdate` date NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `resumptionToken` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;


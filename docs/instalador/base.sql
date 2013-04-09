-- MySQL dump 10.13  Distrib 5.1.63, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: meran
-- ------------------------------------------------------
-- Server version	5.1.63-0+squeeze1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `adq_forma_envio`
--

DROP TABLE IF EXISTS `adq_forma_envio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_forma_envio` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_forma_envio`
--

LOCK TABLES `adq_forma_envio` WRITE;
/*!40000 ALTER TABLE `adq_forma_envio` DISABLE KEYS */;
/*!40000 ALTER TABLE `adq_forma_envio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adq_item`
--

DROP TABLE IF EXISTS `adq_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_item` (
  `id_item` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(255) DEFAULT NULL,
  `precio` float NOT NULL,
  PRIMARY KEY (`id_item`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_item`
--

LOCK TABLES `adq_item` WRITE;
/*!40000 ALTER TABLE `adq_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `adq_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adq_pedido_cotizacion`
--

DROP TABLE IF EXISTS `adq_pedido_cotizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_pedido_cotizacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_pedido_cotizacion`
--

LOCK TABLES `adq_pedido_cotizacion` WRITE;
/*!40000 ALTER TABLE `adq_pedido_cotizacion` DISABLE KEYS */;
INSERT INTO `adq_pedido_cotizacion` VALUES (1,'2011-09-13 12:12:53'),(2,'2012-02-07 14:07:50'),(3,'2012-02-07 15:48:18');
/*!40000 ALTER TABLE `adq_pedido_cotizacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adq_pedido_cotizacion_detalle`
--

DROP TABLE IF EXISTS `adq_pedido_cotizacion_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_pedido_cotizacion_detalle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `adq_pedido_cotizacion_id` int(11) NOT NULL,
  `cat_nivel2_id` int(11) DEFAULT NULL,
  `autor` varchar(255) DEFAULT NULL,
  `titulo` varchar(255) DEFAULT NULL,
  `lugar_publicacion` varchar(255) DEFAULT NULL,
  `editorial` varchar(255) DEFAULT NULL,
  `fecha_publicacion` date DEFAULT NULL,
  `coleccion` varchar(255) DEFAULT NULL,
  `isbn_issn` varchar(45) DEFAULT NULL,
  `cantidad_ejemplares` int(5) NOT NULL DEFAULT '1',
  `precio_unitario` float NOT NULL,
  `adq_recomendacion_detalle_id` int(11) DEFAULT NULL,
  `nro_renglon` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_pedido_cotizacion_detalle`
--

LOCK TABLES `adq_pedido_cotizacion_detalle` WRITE;
/*!40000 ALTER TABLE `adq_pedido_cotizacion_detalle` DISABLE KEYS */;
/*!40000 ALTER TABLE `adq_pedido_cotizacion_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adq_presupuesto`
--

DROP TABLE IF EXISTS `adq_presupuesto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_presupuesto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `proveedor_id` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ref_estado_presupuesto_id` int(11) NOT NULL,
  `ref_pedido_cotizacion_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_presupuesto`
--

LOCK TABLES `adq_presupuesto` WRITE;
/*!40000 ALTER TABLE `adq_presupuesto` DISABLE KEYS */;
/*!40000 ALTER TABLE `adq_presupuesto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adq_proveedor`
--

DROP TABLE IF EXISTS `adq_proveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_proveedor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  `apellido` varchar(255) DEFAULT NULL,
  `nro_doc` varchar(21) DEFAULT NULL,
  `razon_social` varchar(255) DEFAULT NULL,
  `cuit_cuil` int(11) NOT NULL,
  `domicilio` varchar(255) DEFAULT NULL,
  `telefono` varchar(32) DEFAULT NULL,
  `fax` varchar(32) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `activo` int(1) NOT NULL,
  `plazo_reclamo` int(11) DEFAULT NULL,
  `usr_ref_tipo_documento_id` int(11) DEFAULT NULL,
  `ref_localidad_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_adq_proveedor_usr_ref_tipo_documento1` (`usr_ref_tipo_documento_id`),
  KEY `fk_adq_proveedor_ref_localidad1` (`ref_localidad_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_proveedor`
--

LOCK TABLES `adq_proveedor` WRITE;
/*!40000 ALTER TABLE `adq_proveedor` DISABLE KEYS */;
/*!40000 ALTER TABLE `adq_proveedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adq_proveedor_forma_envio`
--

DROP TABLE IF EXISTS `adq_proveedor_forma_envio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_proveedor_forma_envio` (
  `adq_forma_envio_id` int(11) NOT NULL,
  `adq_proveedor_id` int(11) NOT NULL,
  PRIMARY KEY (`adq_forma_envio_id`,`adq_proveedor_id`),
  KEY `fk_adq_proveedor_forma_envio_adq_proveedor1` (`adq_proveedor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_proveedor_forma_envio`
--

LOCK TABLES `adq_proveedor_forma_envio` WRITE;
/*!40000 ALTER TABLE `adq_proveedor_forma_envio` DISABLE KEYS */;
/*!40000 ALTER TABLE `adq_proveedor_forma_envio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adq_proveedor_item`
--

DROP TABLE IF EXISTS `adq_proveedor_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_proveedor_item` (
  `id_proveedor` int(11) NOT NULL,
  `id_item` int(11) NOT NULL,
  PRIMARY KEY (`id_proveedor`,`id_item`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_proveedor_item`
--

LOCK TABLES `adq_proveedor_item` WRITE;
/*!40000 ALTER TABLE `adq_proveedor_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `adq_proveedor_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adq_proveedor_tipo_material`
--

DROP TABLE IF EXISTS `adq_proveedor_tipo_material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_proveedor_tipo_material` (
  `proveedor_id` int(11) NOT NULL,
  `tipo_material_id` int(11) NOT NULL,
  PRIMARY KEY (`proveedor_id`,`tipo_material_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_proveedor_tipo_material`
--

LOCK TABLES `adq_proveedor_tipo_material` WRITE;
/*!40000 ALTER TABLE `adq_proveedor_tipo_material` DISABLE KEYS */;
/*!40000 ALTER TABLE `adq_proveedor_tipo_material` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adq_recomendacion`
--

DROP TABLE IF EXISTS `adq_recomendacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_recomendacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `activa` tinyint(4) NOT NULL DEFAULT '1',
  `adq_ref_tipo_recomendacion_id` int(11) NOT NULL,
  `usr_socio_id` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_adq_recomendacion_adq_ref_tipo_recomendacion1` (`adq_ref_tipo_recomendacion_id`),
  KEY `fk_adq_recomendacion_usr_socio1` (`usr_socio_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_recomendacion`
--

LOCK TABLES `adq_recomendacion` WRITE;
/*!40000 ALTER TABLE `adq_recomendacion` DISABLE KEYS */;
INSERT INTO `adq_recomendacion` VALUES (17,'2011-09-05 13:24:18',0,1,'kohaadmin'),(19,'2011-09-07 11:32:23',1,1,'fernanda'),(21,'2011-09-07 12:33:51',1,1,'fernanda'),(22,'2011-09-07 13:51:18',1,1,'usuario10'),(23,'2011-09-07 13:51:53',1,1,'usuario7'),(24,'2011-09-07 13:54:21',1,1,'usuario7'),(25,'2011-09-09 11:58:24',1,1,'fernanda'),(27,'2011-09-13 11:52:48',1,1,'fernanda'),(28,'2011-09-28 00:45:57',1,1,'94301574'),(29,'2011-11-02 18:14:14',0,1,'21630416'),(31,'2012-02-07 13:02:55',0,1,'marialaura'),(32,'2012-02-07 13:34:35',0,1,'marialaura'),(34,'2012-02-07 15:35:39',0,1,'fernanda');
/*!40000 ALTER TABLE `adq_recomendacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adq_recomendacion_detalle`
--

DROP TABLE IF EXISTS `adq_recomendacion_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_recomendacion_detalle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_nivel2_id` int(11) DEFAULT NULL,
  `autor` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `titulo` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `lugar_publicacion` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `editorial` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `fecha_publicacion` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `coleccion` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `isbn_issn` varchar(45) CHARACTER SET latin1 DEFAULT NULL,
  `cantidad_ejemplares` int(5) NOT NULL DEFAULT '1',
  `motivo_propuesta` text CHARACTER SET latin1 NOT NULL,
  `comentario` text CHARACTER SET latin1,
  `reserva_material` tinyint(4) NOT NULL DEFAULT '0',
  `adq_recomendacion_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_adq_recomendacion_detalle_adq_recomendacion1` (`adq_recomendacion_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_recomendacion_detalle`
--

LOCK TABLES `adq_recomendacion_detalle` WRITE;
/*!40000 ALTER TABLE `adq_recomendacion_detalle` DISABLE KEYS */;
/*!40000 ALTER TABLE `adq_recomendacion_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adq_ref_proveedor_moneda`
--

DROP TABLE IF EXISTS `adq_ref_proveedor_moneda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_ref_proveedor_moneda` (
  `adq_ref_moneda_id` int(11) NOT NULL,
  `adq_proveedor_id` int(11) NOT NULL,
  PRIMARY KEY (`adq_ref_moneda_id`,`adq_proveedor_id`),
  KEY `fk_adq_ref_moneda_has_adq_proveedor_adq_proveedor1` (`adq_proveedor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_ref_proveedor_moneda`
--

LOCK TABLES `adq_ref_proveedor_moneda` WRITE;
/*!40000 ALTER TABLE `adq_ref_proveedor_moneda` DISABLE KEYS */;
/*!40000 ALTER TABLE `adq_ref_proveedor_moneda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `adq_tipo_material`
--

DROP TABLE IF EXISTS `adq_tipo_material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adq_tipo_material` (
  `id` int(11) NOT NULL,
  `nombre` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adq_tipo_material`
--

LOCK TABLES `adq_tipo_material` WRITE;
/*!40000 ALTER TABLE `adq_tipo_material` DISABLE KEYS */;
/*!40000 ALTER TABLE `adq_tipo_material` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `background_job`
--

DROP TABLE IF EXISTS `background_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `background_job` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jobID` varchar(255) CHARACTER SET latin1 NOT NULL,
  `size` int(11) NOT NULL,
  `progress` float NOT NULL,
  `status` varchar(255) CHARACTER SET latin1 NOT NULL,
  `name` varchar(255) CHARACTER SET latin1 NOT NULL,
  `invoker` varchar(255) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `jobID` (`jobID`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `background_job`
--

LOCK TABLES `background_job` WRITE;
/*!40000 ALTER TABLE `background_job` DISABLE KEYS */;
INSERT INTO `background_job` VALUES (6,'ed3dad72545ebc0afe989d3818019790',0,100,'running','DEMO','NULL'),(5,'f36057eb4dee5d636dc83e9deeb676ef',10,0,'running','IMPORTACION','kohaadmin'),(4,'fc14f5995f1016811c52056a7ee5fc53',10,0,'completed','IMPORTACION','kohaadmin');
/*!40000 ALTER TABLE `background_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `barcode_format`
--

DROP TABLE IF EXISTS `barcode_format`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `barcode_format` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo_doc` varchar(4) NOT NULL,
  `format` varchar(255) NOT NULL,
  `long` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_tipo_doc` (`id_tipo_doc`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `barcode_format`
--

LOCK TABLES `barcode_format` WRITE;
/*!40000 ALTER TABLE `barcode_format` DISABLE KEYS */;
INSERT INTO `barcode_format` VALUES (1,'LIB','',5);
/*!40000 ALTER TABLE `barcode_format` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_autor`
--

DROP TABLE IF EXISTS `cat_autor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_autor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(128) DEFAULT NULL,
  `apellido` varchar(128) DEFAULT NULL,
  `nacionalidad` char(3) DEFAULT NULL,
  `completo` varchar(260) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`,`apellido`,`nacionalidad`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_autor`
--

LOCK TABLES `cat_autor` WRITE;
/*!40000 ALTER TABLE `cat_autor` DISABLE KEYS */;
INSERT INTO `cat_autor` VALUES (1,'Test','Test','_SI','_SIN_VALOR_');
/*!40000 ALTER TABLE `cat_autor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_ayuda_marc`
--

DROP TABLE IF EXISTS `cat_ayuda_marc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_ayuda_marc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ui` int(11) NOT NULL,
  `campo` char(3) CHARACTER SET latin1 NOT NULL,
  `subcampo` char(1) CHARACTER SET latin1 NOT NULL,
  `ayuda` text CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ui` (`ui`),
  CONSTRAINT `cat_ayuda_marc_ibfk_1` FOREIGN KEY (`ui`) REFERENCES `pref_unidad_informacion` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_ayuda_marc`
--

LOCK TABLES `cat_ayuda_marc` WRITE;
/*!40000 ALTER TABLE `cat_ayuda_marc` DISABLE KEYS */;
INSERT INTO `cat_ayuda_marc` VALUES (3,25,'100','a','Ingresar el nombre del principal responsable de la creación del contenido intelectual o artístico de la obra. Puede ser un nombre de pila, un apellido simple, compuesto, iniciales, abreviaturas o frases que identifiquen al autor.'),(4,25,'100','b','Ingresar el número romano asociado al nombre del autor. En general se usa para papas, reyes, etc.'),(5,25,'100','c','Ingresar información de aquellos autores que tienen títulos nobiliarios, militares, eclesiásticos u otras palabras asociadas al nombre del autor.'),(6,25,'100','d','Ingresar las fechas de nacimiento y muerte del autor, en caso de considerarlo necesario.'),(7,25,'110','a','Ingresar el nombre de la entidad reconocida como principal responsable de la autoría de la obra.'),(8,25,'110','b','Ingresar el nombre de la entidad que está subordinada a la entidad mayor cargada en el subcampo a.'),(9,25,'245','a','Ingresar el título propiamente dicho de la obra, es la palabra o frase que da nombre al documento.'),(10,25,'245','b','Ingresar el resto del título. Incluye el título paralelo y la información complementaria sobre el título.'),(11,25,'520','a','Ingresar un sumario, un resumen o una anotación que describa el contenido temático de la obra.'),(12,25,'534','a','Ingresar la descripción de la obra original cuando los datos de reproducción de la obra son diferentes.'),(13,25,'111','a','Ingresar el nombre del Congreso, Jornada, Conferencia, Reunión, Taller, Charla, etc.'),(14,25,'111','c','Ingresar el nombre del lugar donde se desarrolló el evento.'),(15,25,'111','d','Ingresar el año en el que se realizó el evento.'),(16,25,'111','n','Ingresar la información numérica relacionada con el evento, en números ordinales. Reemplace los números romanos por arábigos.'),(17,25,'650','a','Ingresar el término controlado extraído de un lenguaje normalizado, que describa el contenido temático de la obra.'),(18,25,'653','a','Ingresar el término del lenguaje natural que describe el contenido temático de la obra.'),(19,25,'700','a','Ingresar el nombre del responsable secundario de la creación del contenido intelectual o artístico de la obra. Puede ser un nombre de pila, un apellido simple, compuesto, iniciales, abreviaturas o frases que identifiquen al autor.'),(20,25,'700','b','Ingresar el número romano asociado al nombre del autor. En general se usa para papas, reyes, etc.'),(21,25,'700','c','Ingresar información de aquellos autores que tienen títulos nobiliarios, militares, eclesiásticos u otras palabras asociadas al nombre del autor.'),(22,25,'700','d','Ingresar las fechas de nacimiento y muerte del autor, en caso de considerarlo necesario.'),(23,25,'700','e','Ingresar la función que describe la relación del autor secundario con la obra.'),(24,25,'856','u','Ingresar la dirección correspondiente a la localización del recurso electrónico.'),(25,25,'020','a','Ingresar al Número Internacional Normalizado para Libros, tal como aparezca en la obra.'),(26,25,'041','a','Ingresar el idioma en el que se encuentra la obra.'),(27,25,'043','c','Ingresar el país al que corresponda la obra.'),(28,25,'245','h','Ingresar el medio en el que el material se encuentra contenido.'),(29,25,'250','a','Ingrese número de edición y otra información relacionada, en forma normalizada.'),(30,25,'260','a','Ingresar el nombre del lugar donde se publicó la obra.'),(31,25,'260','b','Ingresar el nombre del editor o la editorial encargada de la publicación de la obra.'),(32,25,'260','c','Ingresar el año en que se editó la obra.'),(33,25,'300','a','Ingresar la extensión/cantidad de páginas de la obra.'),(34,25,'300','b','Ingresar características físicas como ilustraciones, diagramas, etc. que presente la obra.'),(35,25,'440','a','Ingresar el título de la serie o colección.'),(36,25,'440','p','Ingresar el nombre de la parte o sección de la serie o colección.'),(37,25,'440','v','Ingresar el número de volumen u otra designación de secuencia usada para diferenciar las partes de la serie o colección.'),(38,25,'500','a','Ingresar información sobre detalles particulares que contiene la obra.'),(39,25,'505','a','Ingresar información del contenido de la obra.'),(40,25,'900','b','Ingresar el nivel bibliográfico de descripción de la obra.'),(41,25,'910','a','Ingresar el tipo de documento.'),(42,25,'505','g','Ingresar el número de volumen.'),(43,25,'505','t','Ingresar el título del volumen.'),(44,25,'995','c','Ingresar la Unidad de Información a la que pertenece la obra.'),(45,25,'995','d','Ingresar la Unidad de Información de orígen/procedencia de la obra.'),(46,25,'995','e','Ingresar el estado de la obra.'),(47,25,'995','f','Ingresar el código de barras/inventario, cuando no desee autogenerarlo.'),(48,25,'995','m','Ingresar fecha de carga de la obra.'),(49,25,'995','o','Ingresar el tipo de disponibilidad de la obra.'),(50,25,'995','p','Ingresar el precio de compra según boleta, remito, etc.'),(51,25,'995','t','Ingresar la signatuta topográfica del ítem.'),(52,25,'995','u','Ingresar notas referidas al ítem en particular.'),(53,25,'080','a','Ingresar el número de clasificación temática asignado a la obra.'),(54,25,'502','b','Ingresar el tipo de grado: Licenciatura; Maestría; Doctorado; etc. al que accedió el autor de la tesis.'),(55,25,'502','c','Ingresar el nombre de la institución que otorga el grado.'),(56,25,'502','d','Ingresar el año de graduación.'),(57,25,'210','a','Ingresar el título abreviado que aparece en la publicación.'),(58,25,'222','a','Ingresar el título clave tal como aparece en la publicación.'),(59,25,'222','b','Ingresar información calificadora. Esta información va entre paréntesis y hace al título único.'),(60,25,'240','a','Ingresar el título uniforme de la publicación.'),(61,25,'246','a','Ingresar la variante del título o título paralelo.'),(62,25,'246','f','Ingresar la designación del volumen, número y fecha.'),(63,25,'247','a','Ingresar el título anterior con el que aparecía la publicación.'),(64,25,'247','f','Ingresar fecha o designación secuencial de la publicación.'),(65,25,'247','g','Ingresar información miscelánea (información que no pueda agregar a los subcampos anteriores).'),(66,25,'247','x','Ingresar ISSN de la publicación.'),(67,25,'310','a','Ingresar frecuencia de publicación.'),(68,25,'321','a','Ingresar frecuencia anterior de publicación.'),(69,25,'321','b','Ingresar fecha de frecuencia de publicación anterior.'),(70,25,'710','a','Ingresar el nombre de la entidad o jurisdicción.'),(71,25,'710','b','Ingresar el nombre de la entidad subordinada a la entidad o jurisdicción correspondiente al subcampo a.'),(72,25,'710','g','Ingresar la sigla de la entidad o jurisdicción.'),(73,25,'022','a','Ingresar ISSN.'),(74,25,'362','a','Ingresar la fecha del primer número editado  (y la fecha del último número editado, cuando se trate de una publicación cerrada).'),(75,25,'859','e','Ingresar la información de procedencia de la publicación: compra, donación o canje.'),(76,25,'863','a','Ingresar el número de volumen de la publicación.'),(77,25,'863','b','Ingresar el número de esta publicación.'),(78,25,'863','i','Ingresar año de publicación.');
/*!40000 ALTER TABLE `cat_ayuda_marc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_contenido_estante`
--

DROP TABLE IF EXISTS `cat_contenido_estante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_contenido_estante` (
  `id2` int(11) NOT NULL,
  `id_estante` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_estante`,`id2`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_contenido_estante`
--

LOCK TABLES `cat_contenido_estante` WRITE;
/*!40000 ALTER TABLE `cat_contenido_estante` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_contenido_estante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_control_seudonimo_autor`
--

DROP TABLE IF EXISTS `cat_control_seudonimo_autor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_control_seudonimo_autor` (
  `id_autor` int(11) NOT NULL,
  `id_autor_seudonimo` int(11) NOT NULL,
  PRIMARY KEY (`id_autor`,`id_autor_seudonimo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_control_seudonimo_autor`
--

LOCK TABLES `cat_control_seudonimo_autor` WRITE;
/*!40000 ALTER TABLE `cat_control_seudonimo_autor` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_control_seudonimo_autor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_control_seudonimo_editorial`
--

DROP TABLE IF EXISTS `cat_control_seudonimo_editorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_control_seudonimo_editorial` (
  `id_editorial` int(11) NOT NULL,
  `id_editorial_seudonimo` int(11) NOT NULL,
  PRIMARY KEY (`id_editorial`,`id_editorial_seudonimo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_control_seudonimo_editorial`
--

LOCK TABLES `cat_control_seudonimo_editorial` WRITE;
/*!40000 ALTER TABLE `cat_control_seudonimo_editorial` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_control_seudonimo_editorial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_control_seudonimo_tema`
--

DROP TABLE IF EXISTS `cat_control_seudonimo_tema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_control_seudonimo_tema` (
  `id_tema` int(11) NOT NULL,
  `id_tema_seudonimo` int(11) NOT NULL,
  PRIMARY KEY (`id_tema`,`id_tema_seudonimo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_control_seudonimo_tema`
--

LOCK TABLES `cat_control_seudonimo_tema` WRITE;
/*!40000 ALTER TABLE `cat_control_seudonimo_tema` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_control_seudonimo_tema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_control_sinonimo_autor`
--

DROP TABLE IF EXISTS `cat_control_sinonimo_autor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_control_sinonimo_autor` (
  `id` int(11) NOT NULL,
  `autor` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`autor`),
  KEY `autor` (`autor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_control_sinonimo_autor`
--

LOCK TABLES `cat_control_sinonimo_autor` WRITE;
/*!40000 ALTER TABLE `cat_control_sinonimo_autor` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_control_sinonimo_autor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_control_sinonimo_editorial`
--

DROP TABLE IF EXISTS `cat_control_sinonimo_editorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_control_sinonimo_editorial` (
  `id` int(11) NOT NULL,
  `editorial` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`editorial`),
  KEY `editorial` (`editorial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_control_sinonimo_editorial`
--

LOCK TABLES `cat_control_sinonimo_editorial` WRITE;
/*!40000 ALTER TABLE `cat_control_sinonimo_editorial` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_control_sinonimo_editorial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_control_sinonimo_tema`
--

DROP TABLE IF EXISTS `cat_control_sinonimo_tema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_control_sinonimo_tema` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tema` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`tema`),
  KEY `tema` (`tema`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_control_sinonimo_tema`
--

LOCK TABLES `cat_control_sinonimo_tema` WRITE;
/*!40000 ALTER TABLE `cat_control_sinonimo_tema` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_control_sinonimo_tema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_editorial`
--

DROP TABLE IF EXISTS `cat_editorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_editorial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `editorial` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_editorial`
--

LOCK TABLES `cat_editorial` WRITE;
/*!40000 ALTER TABLE `cat_editorial` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_editorial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_encabezado_campo_opac`
--

DROP TABLE IF EXISTS `cat_encabezado_campo_opac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_encabezado_campo_opac` (
  `idencabezado` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  `orden` int(11) NOT NULL,
  `linea` tinyint(1) NOT NULL DEFAULT '0',
  `nivel` tinyint(1) NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idencabezado`),
  KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_encabezado_campo_opac`
--

LOCK TABLES `cat_encabezado_campo_opac` WRITE;
/*!40000 ALTER TABLE `cat_encabezado_campo_opac` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_encabezado_campo_opac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_encabezado_item_opac`
--

DROP TABLE IF EXISTS `cat_encabezado_item_opac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_encabezado_item_opac` (
  `idencabezado` int(11) NOT NULL DEFAULT '0',
  `itemtype` varchar(4) NOT NULL DEFAULT '',
  PRIMARY KEY (`idencabezado`,`itemtype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_encabezado_item_opac`
--

LOCK TABLES `cat_encabezado_item_opac` WRITE;
/*!40000 ALTER TABLE `cat_encabezado_item_opac` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_encabezado_item_opac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_estante`
--

DROP TABLE IF EXISTS `cat_estante`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_estante` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `estante` varchar(255) DEFAULT NULL,
  `tipo` text NOT NULL,
  `padre` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_estante`
--

LOCK TABLES `cat_estante` WRITE;
/*!40000 ALTER TABLE `cat_estante` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_estante` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_estructura_catalogacion`
--

DROP TABLE IF EXISTS `cat_estructura_catalogacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_estructura_catalogacion` (
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
  KEY `indiceTodos` (`campo`,`subcampo`,`itemtype`),
  KEY `idinforef` (`idinforef`)
) ENGINE=InnoDB AUTO_INCREMENT=526 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_estructura_catalogacion`
--

LOCK TABLES `cat_estructura_catalogacion` WRITE;
/*!40000 ALTER TABLE `cat_estructura_catalogacion` DISABLE KEYS */;
INSERT INTO `cat_estructura_catalogacion` VALUES (51,'245','a','ALL','Título','text',0,1,1,2,1,1,NULL,'1',1,0,'alphanumeric_total:true',0),(66,'110','a','LIB','Autor corporativo','auto',1,1,0,1,1,1,78,'bf8e17616267c51064becf693e64501e',0,0,' alphanumeric_total:true ',0),(68,'245','h','LIB','Medio','combo',1,2,0,4,1,1,149,'dbd4ba15b96cf63914351cdb163467b2',0,0,' alphanumeric_total:true ',0),(107,'080','a','LIB','CDU','text',0,1,0,3,1,1,0,'ea0c6caa38d898989866335e1af0844e',0,1,' alphanumeric_total:true ',1),(116,'700','a','LIB','Autor secundario/Colaboradores','auto',1,1,0,12,1,1,143,'496705e6cd65f25e4e41ef8f26d0027e',0,1,' alphanumeric_total:true ',10),(120,'710','a','REV','Nombre de la entidad o jurisdicción','auto',1,1,0,16,1,1,64,'538f99c8e5537a6307385edc614e65cf',0,1,' alphanumeric_total:true ',14),(124,'245','b','LIB','Resto del título','text',0,1,0,20,1,1,NULL,'21f6e655816f1ac4b941bc13908197e3',0,1,' alphanumeric_total:true ',18),(132,'650','a','LIB','Temas (controlado)','auto',1,1,0,28,1,1,88,'357a2f17fd0088cb1f0e8370b62d7452',0,1,' alphanumeric_total:true ',26),(135,'653','a','LIB','Palabras claves (no controlado)','text',0,1,0,31,1,1,NULL,'eea199e92303ba203519cd460a662188',0,1,' alphanumeric_total:true ',29),(138,'041','a','LIB','Idioma','combo',1,2,0,9,1,1,148,'c304616fe1434ba4235a146010b98aa3',0,1,' alphanumeric_total:true ',32),(140,'250','a','LIB','Edición','text',0,2,0,11,1,1,NULL,'665d8ec1b8a444dcf4d8732f09022742',0,1,' alphanumeric_total:true ',34),(142,'300','a','LIB','Extensión/Páginas','text',0,2,0,13,1,1,NULL,'6982e2c38b57af9484301752acba4d44',0,1,' alphanumeric_total:true ',36),(143,'440','a','LIB','Serie','text',0,2,0,14,1,1,NULL,'484e5d9090c3ba6b66ebad0c0e1150d2',0,1,' alphanumeric_total:true ',37),(144,'440','p','LIB','Subserie','text',0,2,0,15,1,1,NULL,'5c9badf652343301382222dee9d8cd81',0,1,' alphanumeric_total:true ',38),(145,'440','v','LIB','Número de la serie ','text',0,2,0,16,1,1,NULL,'2c1cdfad0546433f47440881acc9dc1a',0,1,' alphanumeric_total:true ',39),(146,'500','a','LIB','Nota general','text',0,2,0,17,1,1,NULL,'d92774dab9a0b65d987d0d10fcc5ee96',0,1,' alphanumeric_total:true ',40),(152,'710','g','REV','Sigla','text',0,1,0,33,1,1,NULL,'ce7d0b9c0192b1668ec7854f96366d4f',0,1,' alphanumeric_total:true ',0),(157,'260','b','REV','Editor','text',0,2,0,10,1,1,NULL,'158837737c411171b07f555cf9911e09',0,1,' alphanumeric_total:true ',0),(159,'362','a','REV','Fecha de inicio - cese','text',0,2,0,12,1,1,NULL,'c1e31ba3b3372929907cdd9505868ad9',0,1,' alphanumeric_total:true ',0),(162,'710','b','REV','Entidad subordinada','texta',0,1,0,35,1,1,NULL,'11238f8ecd94de929e600086aad33c5e',0,1,' alphanumeric_total:true ',0),(166,'300','a','TES','Páginas','text',0,2,0,10,1,1,NULL,'52b02598a81d62f2639c1129422ed40e',0,1,' digits:true ',0),(167,'110','b','LIB','Entidad subordinada','auto',1,1,0,33,1,1,261,'e70d29c5813261bccda451db1e131bcc',0,1,' digits:true ',0),(170,'250','b','SEM','Editor','text',0,2,0,8,1,1,NULL,'c017c66d4f430c276dd18b91e70e0c87',0,1,' alphanumeric_total:true ',0),(173,'300','b','LIB','Otros detalles físicos (NR)','text',0,2,0,22,1,1,NULL,'8e7937b4a461334ac4069b343fd4be6f',0,1,' alphanumeric_total:true ',0),(174,'300','c','LIB','Dimensiones (R)','text',0,2,0,23,1,1,NULL,'a95bd9b45f6f4b63f13455acc09ea98b',0,1,' alphanumeric_total:true ',0),(179,'240','a','REV','Título uniforme (NR)','text',0,1,0,27,1,1,NULL,'c6a6287394c22748b31ccfff8f1c61d6',0,1,' alphanumeric_total:true ',0),(181,'246','f','REV','Designación del volumen, número, fecha','text',0,1,0,29,1,1,NULL,'3a5781978b3aa10341d0ac52c7848f9a',0,1,' alphanumeric_total:true ',0),(187,'310','b','REV','Fecha de frecuencia actual de la publicación (NR)','text',0,2,0,16,1,1,NULL,'13b3d3af3c0ed21bf82d8893b3ae2785',0,1,' alphanumeric_total:true ',0),(190,'500','a','REV','Nota general (NR)','text',0,2,0,17,1,1,NULL,'8b5faa32fa5cb921206b056cc2ab12b3',0,1,' alphanumeric_total:true ',0),(196,'100','b','LIB','Numeración (NR)','text',0,1,0,34,1,1,NULL,'fd5bf619a9599f761aeb2b06e2c78794',0,1,' alphanumeric_total:true ',0),(197,'100','c','LIB','Títulos y otras palabras asociadas con el nombre (R)','text',0,1,0,35,1,1,NULL,'1e93b93d6f843a21faefb43198be5a0f',0,1,' alphanumeric_total:true ',0),(198,'100','d','LIB','Fecha de nacimiento y muerte','calendar',0,1,0,36,1,1,NULL,'c2aef632843117206593b3da4b4eb2a4',0,1,' dateITA:true ',0),(203,'250','a','FOT','Edición','text',0,2,0,4,1,1,NULL,'1ca43551e6b3b7ae1867b5600286b28d',0,1,' alphanumeric_total:true ',0),(205,'260','b','FOT','Editor','text',0,2,0,6,1,1,NULL,'eee370a1798db8697e8d4ddc01645289',0,1,' alphanumeric_total:true ',0),(206,'260','c','FOT','Fecha','text',0,2,0,7,1,1,NULL,'3b20c6955b6abba2acdf75bd0e4eec0c',0,1,' alphanumeric_total:true ',0),(207,'440','a','FOT','Serie','text',0,2,0,8,1,1,NULL,'21bbc9fb703e5091daab09a783505185',0,1,' alphanumeric_total:true ',0),(208,'440','p','FOT','Subserie','text',0,2,0,9,1,1,NULL,'0926182ee4f15005e157065a66aecaea',0,1,' alphanumeric_total:true ',0),(209,'440','v','FOT','Número de la serie','text',0,2,0,10,1,1,NULL,'3e8dcc89ce341656d1c90360df6c0d76',0,1,' alphanumeric_total:true ',0),(210,'300','a','FOT','Descripción física','text',0,2,0,11,1,1,NULL,'ca37509585fba624c5a6824da36022cd',0,1,' alphanumeric_total:true ',0),(211,'500','a','FOT','Nota general ','text',0,2,0,12,1,1,NULL,'925becd7ae41c7e7b7300d01264f605b',0,1,' alphanumeric_total:true ',0),(212,'773','d','FOT','Lugar, editor y fecha de publicación de la parte mayor','text',0,2,0,13,1,1,NULL,'6e01cf17a1e90bccafb06983dfb1ecf6',0,1,' alphanumeric_total:true ',0),(213,'773','g','FOT','Ubicación de la parte','text',0,2,0,14,1,1,NULL,'9f74adedc3e487dd09fb1d40b156f896',0,1,' alphanumeric_total:true ',0),(214,'773','t','FOT','Título y mención de la parte mayor','text',0,2,0,15,1,1,NULL,'9f77f316a27cb3a8cec0ec3f3b11bfda',0,1,' alphanumeric_total:true ',0),(215,'260','a','FOT','Lugar','auto',1,2,0,15,1,1,150,'17780c5ea89df2b9ad8dbf66eda4015d',0,1,' alphanumeric_total:true ',0),(216,'100','a','DCA','Autor','auto',1,1,0,18,1,1,77,'8463a7ead2190cbca46501e1522d2010',0,1,' alphanumeric_total:true ',0),(217,'260','a','DCA','Lugar','auto',1,2,0,4,1,1,76,'0b3baf9f2c23e842482b50668a72af41',0,1,' alphanumeric_total:true ',0),(218,'260','b','DCA','Editor','text',0,2,0,5,1,1,NULL,'08caa243955d91b91498180d13e3fa41',0,1,' alphanumeric_total:true ',0),(219,'260','c','DCA','Fecha','calendar',0,2,0,6,1,1,NULL,'e0f9c80ff3e651fc0e786681f81dbffd',0,1,' alphanumeric_total:true ',0),(220,'300','a','DCA','Extensión/Páginas','text',0,2,0,7,1,1,NULL,'8db011e4e5f8cd1dda43b19724d64c36',0,1,' alphanumeric_total:true ',0),(221,'440','a','DCA','Serie','text',0,2,0,8,1,1,NULL,'8e03eaab572412f997af83cb4d993e63',0,1,' alphanumeric_total:true ',0),(222,'440','p','DCA','Subserie','text',0,2,0,9,1,1,NULL,'88bbd6dad17c4693455940239ab8e03c',0,1,' alphanumeric_total:true ',0),(223,'440','v','DCA','Número','text',0,2,0,10,1,1,NULL,'f7bd311eb4473e6df290689803ff1f1a',0,1,' alphanumeric_total:true ',0),(224,'500','a','DCA','Nota general','text',0,2,0,11,1,1,NULL,'b87ab2596026ff6efb3f4dedaa382cdd',0,1,' alphanumeric_total:true ',0),(225,'700','b','LIB','Número asociado al nombre','text',0,1,0,3,1,1,NULL,'d68a4311b8773c73495f6397f0dcabe8',0,1,' alphanumeric_total:true ',0),(226,'700','c','LIB','Títulos y otras palabras asociadas con el nombre','text',0,1,0,2,1,1,NULL,'9670663cf1362fa2de186daa80b65700',0,1,' alphanumeric_total:true ',0),(227,'700','d','LIB','Fecha de nacimento y muerte','text',0,1,0,3,1,1,NULL,'815574e5acfdbf4261651a3cf2c2ca16',0,1,' alphanumeric_total:true ',0),(228,'700','e','LIB','Función','text',0,1,0,2,1,1,0,'89a16936399743ab6537c00fd84de07a',0,1,' alphanumeric_total:true ',0),(229,'773','t','LIB','Título y mención de resp. del documento fuente','text',0,2,0,19,1,1,NULL,'a991d2c5d6905b32db1eaa70342a8962',0,1,' alphanumeric_total:true ',0),(230,'773','d','LIB','Lugar, editor y fecha (documento fuente)','text',0,2,0,20,1,1,NULL,'313e1387022292da1cf7b87cf67a293d',0,1,' alphanumeric_total:true ',0),(231,'773','g','LIB','Parte relacionada (ubicación de la parte)','text',0,2,0,21,1,1,NULL,'1aeadd22f8a43c45283e79c4d12b620a',0,1,' alphanumeric_total:true ',0),(232,'041','a','DCA','Idioma','combo',1,2,0,9,1,1,110,'ee3459db0a48b344488061909c0c96e5',0,1,' alphanumeric_total:true ',0),(233,'650','a','DCA','temas (controlado)','auto',1,1,0,2,1,1,89,'af1cfb16220f155838b1e3d8bbac14d5',0,1,' alphanumeric_total:true ',0),(234,'653','a','DCA','Palabras claves (no controlado)','text',0,1,0,3,1,1,NULL,'a048da02607307e067b5d1e4ca7c4bee',0,1,' alphanumeric_total:true ',0),(235,'110','a','DCA','Autor corporativo','auto',1,1,0,2,1,1,93,'a1a1350b2f0ffb80723e603b6105eeef',0,1,' alphanumeric_total:true ',0),(236,'110','b','DCA','Entidad subordinada','auto',1,1,0,2,1,1,97,'3f953984408ceec2965c058426cf6eef',0,1,' alphanumeric_total:true ',0),(237,'700','a','DCA','Autor secundario','auto',1,1,0,2,1,1,91,'d4a08dc643606dc1e6169762710cf116',0,1,' alphanumeric_total:true ',0),(238,'700','e','DCA','Función','text',0,1,0,2,1,1,NULL,'611244f681343b56cac4e9bc0341f63f',0,1,' alphanumeric_total:true ',0),(239,'080','a','DCA','CDU','text',0,1,0,2,1,1,NULL,'d80534925707ab93b53f9fdb83da509f',0,1,' alphanumeric_total:true ',0),(240,'900','b','REV','Nivel bibliografico','text',1,2,0,13,1,1,238,'ba9c2821f1553be4bb52e5cd2b24cb53',0,1,' alphanumeric_total:true ',0),(241,'910','a','REV','Tipo de documento','combo',1,2,1,7,1,1,122,'91fd6a6a083b0b1fba81f52b686d09f0',1,1,' alphanumeric_total:true ',0),(242,'900','b','DCA','Nivel bibliografico','text',0,2,0,10,1,1,NULL,'ae8bf4c011e2b889d43c2750ac1fe293',0,1,' alphanumeric_total:true ',0),(243,'910','a','DCA','Tipo de documento','text',0,2,1,6,1,1,NULL,'47a1ddefee6dbd1e1d48eea3e9866459',1,1,' alphanumeric_total:true ',0),(244,'080','a','DCD','CDU','text',0,1,0,2,1,1,NULL,'6da523b4dcff731ad8b6e04eeed6b658',0,1,' alphanumeric_total:true ',0),(245,'100','a','DCD','Autor','auto',1,1,0,2,1,1,94,'7eba44017ef8689f7d66bf860243f7d8',0,1,' alphanumeric_total:true ',0),(248,'650','a','DCD','Temas (controlado)','auto',1,1,0,2,1,1,101,'1bbf2189a2744958f7f4a5eab17b0f4a',0,1,' alphanumeric_total:true ',0),(249,'653','a','DCD','Palabras claves (no controlado)','text',0,1,0,2,1,1,NULL,'d827b366de9a62b46f35d98fd3cca4bc',0,1,' alphanumeric_total:true ',0),(250,'700','a','DCD','Autor secundario','auto',1,1,0,2,1,1,106,'480c2a2a8f5025d4847b6f5445d53a02',0,1,' alphanumeric_total:true ',0),(251,'700','e','DCD','Función','text',0,1,0,3,1,1,NULL,'2dbc9a57ba5d9b81e624585a90c0c423',0,1,' alphanumeric_total:true ',0),(252,'110','a','DCD','Autor corporativo','auto',1,1,0,2,1,1,107,'fb0ec3bfa41a301eca2b871eeaff3ede',0,1,' alphanumeric_total:true ',0),(253,'110','b','DCD','Entidad subordinada','auto',1,1,0,3,1,1,108,'fe5d1af48488acdf6ba5d6cfdb212b54',0,1,' alphanumeric_total:true ',0),(254,'041','a','DCD','Idioma','combo',1,2,0,1,1,1,109,'1bc8a25f686f436744d7b529c45f0dbe',0,1,' alphanumeric_total:true ',0),(255,'260','a','DCD','Lugar ','text',0,2,0,2,1,1,NULL,'1912d7b1406c1e6b4db9c4f449497fbc',0,1,' alphanumeric_total:true ',0),(256,'260','b','DCD','Editor','text',0,2,0,3,1,1,NULL,'0b5d0008268a956661c386eb9e028786',0,1,' alphanumeric_total:true ',0),(257,'260','c','DCD','Fecha ','text',0,2,0,4,1,1,NULL,'0c38b9e0add94b98d79311245b29e5b7',0,1,' alphanumeric_total:true ',0),(258,'300','a','DCD','Extensión/Páginas','text',0,2,0,5,1,1,NULL,'b511d53be952b277e5d563a846c32c77',0,1,' alphanumeric_total:true ',0),(259,'440','a','DCD','Serie','text',0,2,0,6,1,1,NULL,'36dfcca8f57a30dafc57e3247cdfd9f7',0,1,' alphanumeric_total:true ',0),(260,'440','p','DCD','Subserie','text',0,2,0,7,1,1,NULL,'4d9d520745e72cd9772478d30ad2ea78',0,1,' alphanumeric_total:true ',0),(261,'440','v','DCD','Número','text',0,2,0,8,1,1,NULL,'530657e9fbf30df062105db336525a91',0,1,' alphanumeric_total:true ',0),(262,'500','a','DCD','Nota general ','text',0,2,0,9,1,1,NULL,'72232966314ddd76b9e8415bcf4d78aa',0,1,' alphanumeric_total:true ',0),(263,'900','b','DCD','Nivel bibliografico','text',0,2,0,10,1,1,NULL,'ad014a05d2a21cc7aa07ecd655def9e4',0,1,' alphanumeric_total:true ',0),(264,'910','a','DCD','Tipo de documento','text',0,2,1,6,1,1,NULL,'c695d0ce05cf0c87867c119192cf83f1',1,1,' alphanumeric_total:true ',0),(265,'080','a','TES','CDU','text',0,1,0,2,1,1,NULL,'3bf5051f7db74faed5931613b905bc6e',0,1,' alphanumeric_total:true ',0),(266,'100','a','TES','Autor','auto',1,1,0,2,1,1,119,'4713353344e672c60b12476570671c33',0,1,' alphanumeric_total:true ',0),(267,'100','d','TES','Fecha de nacimiento y muerte','calendar',0,1,0,3,1,1,NULL,'92035ccdf9cde6432cf59470e9b1c401',0,1,' alphanumeric_total:true ',0),(268,'700','a','TES','Autor secundario/Colaboradores','auto',1,1,0,2,1,1,114,'8b182290b35d9f458c4fc58892fa3994',0,1,' alphanumeric_total:true ',0),(269,'700','e','TES','Función','text',0,1,0,2,1,1,NULL,'c9a8747e61ef069566a74ff08add9d89',0,1,' alphanumeric_total:true ',0),(270,'650','a','TES','Temas (controlado)','auto',1,1,0,2,1,1,117,'1fb052e60f604f631c3785a98df90f84',0,1,' alphanumeric_total:true ',0),(271,'653','a','TES','Palabras claves (no controlado)','text',0,1,0,2,1,1,NULL,'4b69608689208bbc715b7a8d85a2ecaf',0,1,' alphanumeric_total:true ',0),(272,'041','a','TES','Idioma','combo',1,2,0,2,1,1,118,'d11c085eebaa452a7b4986c5f84afb8c',0,1,' digits:true ',0),(273,'260','a','TES','Lugar','auto',1,2,0,3,1,1,120,'71a869e7f105ef5f97faf75b910c9380',0,1,' alphanumeric_total:true ',0),(274,'260','b','TES','Editor','text',0,2,0,4,1,1,NULL,'9048aed9af70bf2733c789850102c0cd',0,1,' alphanumeric_total:true ',0),(275,'260','c','TES','Fecha ','calendar',0,2,0,5,1,1,NULL,'de448182a028ddc62f881a64446b3acc',0,1,' dateITA:true ',0),(277,'502','b','TES','Tipo de grado','text',0,2,0,7,1,1,NULL,'1e3c38d59a684a80576b7f1c9577eaf3',0,1,' alphanumeric_total:true ',0),(278,'502','c','TES','Nombre de la institución otorgante','text',0,2,0,8,1,1,NULL,'4d486d99dbaba9179db32cd96df4c97c',0,1,' alphanumeric_total:true ',0),(279,'502','d','TES','Año de grado otorgado','text',0,2,0,9,1,1,NULL,'05f788ded9f65c5a139a39c70993738c',0,1,' alphanumeric_total:true ',0),(280,'260','a','REV','Lugar','auto',1,2,0,15,1,1,121,'372a9f2c8015cc3242c37ec660bc83c9',0,1,' alphanumeric_total:true ',0),(281,'246','a','REV','Variante del título','text',0,1,0,2,1,1,NULL,'668171c193e270880a06b6996431e774',0,1,' alphanumeric_total:true ',0),(282,'110','a','REV','Autor corporativo','auto',1,1,0,2,1,1,124,'25320613319b16f3bbeb342ee91b1303',0,1,' alphanumeric_total:true ',0),(283,'110','b','REV','Entidad subordinada','auto',1,1,0,2,1,1,126,'443efa19185b98fee8a41a86d16a6425',0,1,' alphanumeric_total:true ',0),(285,'863','a','REV','Volumen','text',0,2,0,16,1,1,NULL,'98a0b279468735013be9de9504e00bd1',0,1,' alphanumeric_total:true ',0),(286,'863','b','REV','Número','text',0,2,0,17,1,1,NULL,'2bbd5daf8f10feb41b49653515ba2887',0,1,' alphanumeric_total:true ',0),(287,'863','i','REV','Año','text',0,2,0,18,1,1,NULL,'b19ac05e7f553256a6a2c5e3458524fa',0,1,' alphanumeric_total:true ',0),(288,'041','a','REV','Código de idioma para texto o pista de sonido o título separado (R)','auto',1,2,0,19,1,1,128,'f27314e050fd60b21b56f5e445a00bd0',0,1,' alphanumeric_total:true ',0),(289,'245','b','FOT','Resto del título (NR)','text',0,1,0,2,1,1,NULL,'88a27b9d27a76b5cae15f7f364a2ccbd',0,1,' alphanumeric_total:true ',0),(290,'080','a','FOT','CDU','text',0,1,0,2,1,1,NULL,'4d45d15bfdb8ac5b43da43ca392e0c17',0,1,' alphanumeric_total:true ',0),(292,'100','a','FOT','Autor','auto',1,1,0,2,1,1,159,'1c776e09f1f10160e2ed4d0bb142238d',0,1,' alphanumeric_total:true ',0),(293,'100','b','FOT','Numeración (NR)','text',0,1,0,3,1,1,NULL,'ba95a5375d025f75e91a513b8ea24363',0,1,' alphanumeric_total:true ',0),(294,'100','c','FOT','Títulos y otras palabras asociadas con el nombre (R)','text',0,1,0,2,1,1,NULL,'cf6ba23a2c275073b7dc65dda42ff824',0,1,' alphanumeric_total:true ',0),(295,'100','d','FOT','Fechas asociadas con el nombre (NR)','text',0,1,0,2,1,1,NULL,'cb248ddf055e3ed7b3b890bfe4390516',0,1,' alphanumeric_total:true ',0),(296,'110','a','FOT','Autor corporativo','auto',1,1,0,2,1,1,160,'1ed441750cc808949c1934de696db4fd',0,1,' alphanumeric_total:true ',0),(297,'110','b','FOT','Entidad subordinada','auto',1,1,0,2,1,1,161,'c0ab88c817a47ab84787b8f8788b0c7d',0,1,' alphanumeric_total:true ',0),(299,'650','a','FOT','Temas (controlados)','auto',1,1,0,2,1,1,162,'99f7c5e12cddef20e32d2999e2f712d3',0,1,' alphanumeric_total:true ',0),(304,'653','a','FOT','Palabras claves (no controlado)','text',0,1,0,5,1,1,NULL,'d658571aa9daa2d9a9cde07f8749a3cd',0,1,' alphanumeric_total:true ',0),(305,'700','a','FOT','Autor secundario/Colaboradores','auto',1,1,0,6,1,1,163,'39f025806bbc598b0a88c4fa1ca8f96b',0,1,' alphanumeric_total:true ',0),(306,'700','b','FOT','Numeración','text',0,1,0,7,1,1,NULL,'d310f0895a17ec29759339c4122c1528',0,1,' alphanumeric_total:true ',0),(307,'700','c','FOT','Títulos y otras palabras asociadas con el nombre','text',0,1,0,8,1,1,NULL,'023cc3e4c877ed7b55960b447139e7f6',0,1,' alphanumeric_total:true ',0),(308,'700','d','FOT','Fechas de nacimiento y muerte','calendar',0,1,0,9,1,1,NULL,'5a24ccdf144188630ac81d2e7b37f2cf',0,1,' alphanumeric_total:true ',0),(309,'700','e','FOT','Función','text',0,1,0,10,1,1,NULL,'69e747d0fdb1d475236ce3fe25607671',0,1,' alphanumeric_total:true ',0),(310,'900','b','FOT','Nivel bibliografico','combo',1,2,0,13,1,1,164,'c3606946ef2b6695c127f57e0a74afc9',0,1,' alphanumeric_total:true ',0),(311,'910','a','FOT','Tipo de documento','combo',1,2,1,7,1,1,165,'2962c3f1a040d491b10c00f5000a61a7',1,1,' alphanumeric_total:true ',0),(312,'111','a','LIB','Nombre de la reunión','text',0,1,0,2,1,1,NULL,'58fef3280e991934f9639da16642bf47',0,1,' alphanumeric_total:true ',0),(315,'111','n','FOT','Número de la reunión','text',0,1,0,3,1,1,NULL,'b8a2e864b55385c8cd6633ca06c7f5cd',0,1,' alphanumeric_total:true ',0),(316,'111','d','FOT','Fecha de la reunión','calendar',0,1,0,4,1,1,NULL,'cf7426063068fc4a789320bf64e2615a',0,1,' alphanumeric_total:true ',0),(317,'111','c','FOT','Lugar de la reunión','auto',1,1,0,5,1,1,132,'a3467909c71023b93b18fe234fab1c14',0,1,' alphanumeric_total:true ',0),(318,'111','n','LIB','Número de la reunión','text',0,1,0,2,1,1,NULL,'8751c2ccd2ece8da7a19c2a20a839a4a',0,1,' alphanumeric_total:true ',0),(319,'111','d','LIB','Fecha de la reunión','calendar',0,1,0,2,1,1,NULL,'f9624e8e52ab15e934897f32122d6bcd',0,1,' alphanumeric_total:true ',0),(320,'111','c','LIB','Lugar de la reunión','auto',1,1,0,2,1,1,235,'1dbd53bb10384eeb711b7bc0d0072f29',0,1,' alphanumeric_total:true ',0),(322,'910','a','ANA','Tipo de documento','combo',1,2,1,10,1,1,250,'102655d2d2e23c7ab41878e4ad9c84b2',1,1,' alphanumeric_total:true ',0),(323,'900','b','LIB','Nivel bibliografico','combo',1,2,0,20,1,1,147,'6becd17a2634cb1d4f49d1266ee62c5b',0,1,' alphanumeric_total:true ',0),(324,'260','a','LIB','Lugar','auto',1,2,0,18,1,1,151,'a7dba4ca62f31b094ec67c065b8244c8',0,1,' alphanumeric_total:true ',0),(325,'260','b','LIB','Editor','auto',1,2,0,19,1,1,257,'632546631c044616b8b15c5eaef2c5cb',0,1,' digits:true ',0),(326,'260','c','LIB','Fecha ','text',0,2,0,20,1,1,NULL,'ede39fc9c490e561b88f7ee281dd05be',0,1,' alphanumeric_total:true ',0),(327,'505','a','LIB','Nota normalizada','text',0,2,0,20,1,1,NULL,'cfec8cf48f982f278df0bdbf9b59545d',0,1,' alphanumeric_total:true ',0),(328,'505','g','LIB','Volumen','text',0,2,0,21,1,1,NULL,'8567dd350b957fd789a94fbd8cb3920d',0,1,' alphanumeric_total:true ',0),(329,'505','t','LIB','Descripción del volumen','text',0,2,0,22,1,1,NULL,'62bf05615bba052b98d80a16db43c3df',0,1,' alphanumeric_total:true ',0),(330,'505','a','FOT','Nota normalizada','text',0,2,0,15,1,1,NULL,'8af7cd0fc50c245beb151f7430a93d5e',0,1,' alphanumeric_total:true ',0),(331,'505','g','FOT','Volumen','text',0,2,0,16,1,1,NULL,'26162739dd9f296f813a62dd5d38e17c',0,1,' alphanumeric_total:true ',0),(332,'505','t','FOT','Descripción del volumen','text',0,2,0,17,1,1,NULL,'6e3e5eeb564b4cf2aecf9af69b678ed5',0,1,' alphanumeric_total:true ',0),(336,'080','a','CDR','CDU','text',0,1,0,2,1,1,NULL,'fe4f17ce80b250817068c99894928289',0,1,' alphanumeric_total:true ',0),(337,'100','a','CDR','Autor','auto',1,1,0,2,1,1,171,'dae39828da8dbd62e18626ed2a2d6f48',0,1,' alphanumeric_total:true ',0),(338,'100','b','CDR','Numeración','text',0,1,0,2,1,1,NULL,'126ad0ebeea77d744ce0a12dae1a979b',0,1,' alphanumeric_total:true ',0),(339,'100','c','CDR','Títulos y otras palabras asociadas con el nombre','text',0,1,0,2,1,1,NULL,'0cc7aab522c7e6523d07c1d1b45657aa',0,1,' alphanumeric_total:true ',0),(340,'100','d','CDR','Fechas de nacimiento y muerte','text',0,1,0,2,1,1,NULL,'7110f52963568ed12ea0f9c029cf1447',0,1,' alphanumeric_total:true ',0),(341,'110','a','CDR','Autor corporativo','auto',1,1,0,2,1,1,173,'73351c532c5991d84434bc545c9bcc17',0,1,' alphanumeric_total:true ',0),(342,'110','b','CDR','Entidad subordinada','auto',1,1,0,2,1,1,175,'2ce80d26de7b9c31cfe19421c4a3ee1f',0,1,' alphanumeric_total:true ',0),(343,'111','a','CDR','Nombre de la reunión','text',0,1,0,2,1,1,NULL,'369b8fa4495d95305622b3027e5dc72f',0,1,' alphanumeric_total:true ',0),(344,'111','n','CDR','Número de la reunión','text',0,1,0,2,1,1,NULL,'766b036591dcccf6acc2e109403e61de',0,1,' alphanumeric_total:true ',0),(345,'111','d','CDR','Fecha de la reunión','text',0,1,0,3,1,1,NULL,'ad00dc0ad488023138b3e63226c35d50',0,1,' alphanumeric_total:true ',0),(346,'111','c','CDR','Lugar de la reunión','auto',1,1,0,2,1,1,177,'8ff959bb9cd5a88dfd78658af8b0e8bc',0,1,' alphanumeric_total:true ',0),(347,'245','b','CDR','Resto del título','text',0,1,0,2,1,1,NULL,'b4c85997493ddebd06280867f03b8cf2',0,1,' alphanumeric_total:true ',0),(348,'650','a','CDR','Temas (controlado)','auto',1,1,0,2,1,1,211,'af1a9cad897645f35a382aecc13a19c6',0,1,' alphanumeric_total:true ',0),(349,'653','a','CDR','Palabras claves (no controlado)','text',0,1,0,2,1,1,NULL,'f26c6fc8c6dc6f03804039f502c27d70',0,1,' alphanumeric_total:true ',0),(350,'700','a','CDR','Autor secundario/Colaboradores','auto',1,1,0,2,1,1,181,'f33c8e1cdb5fcf61c731de2229745a46',0,1,' alphanumeric_total:true ',0),(351,'700','b','CDR','Número asociado al nombre','text',0,1,0,2,1,1,NULL,'d5eafb260bf9e46108e79a28372035d5',0,1,' alphanumeric_total:true ',0),(352,'700','c','CDR','Títulos y otras palabras asociadas con el nombre','text',0,1,0,2,1,1,NULL,'5fdc7d5eb2ad23dd7391f89d7e600bb0',0,1,' alphanumeric_total:true ',0),(353,'700','d','CDR','Fechas de nacimiento y muerte','text',0,1,0,2,1,1,NULL,'619c8da4a2d0f7c3827ad983fa49da8c',0,1,' alphanumeric_total:true ',0),(354,'700','e','CDR','Función','text',0,1,0,2,1,1,NULL,'5e647d19341462a3064d17c3b1a39782',0,1,' alphanumeric_total:true ',0),(355,'020','a','CDR','ISBN','text',0,2,0,1,1,1,NULL,'fee55477650e11ec9f2fd8c33fbb6255',0,1,' alphanumeric_total:true ',0),(356,'041','a','CDR','Idioma','combo',1,2,0,2,1,1,194,'e380b75c8f6710835714437ee55f813f',0,1,' alphanumeric_total:true ',0),(357,'245','h','CDR','Medio','combo',1,2,0,3,1,1,195,'530f094bc48c793b573de0ee5fd44922',0,1,' alphanumeric_total:true ',0),(358,'250','a','CDR','Edición','text',0,2,0,4,1,1,NULL,'d9b0fefab015a978a03dd9498cf12582',0,1,' alphanumeric_total:true ',0),(359,'260','a','CDR','Lugar','auto',1,2,0,5,1,1,193,'0f7afc48fc856bef17040062562aca13',0,1,' alphanumeric_total:true ',0),(360,'260','b','CDR','Editor','text',0,2,0,6,1,1,NULL,'6998617a088c9d0e8db8b72d9a0c9068',0,1,' alphanumeric_total:true ',0),(361,'260','c','CDR','Fecha ','text',0,2,0,7,1,1,NULL,'900287ea7f144b1b27da72bc5ae56b34',0,1,' alphanumeric_total:true ',0),(362,'440','a','CDR','Serie','text',0,2,0,8,1,1,NULL,'12d6a978a77fb11fb08cfef18a7b1bcb',0,1,' alphanumeric_total:true ',0),(363,'440','p','CDR','Subserie','text',0,2,0,9,1,1,NULL,'320848a83845e32f13906866a8bdaad5',0,1,' alphanumeric_total:true ',0),(364,'440','v','CDR','Número de la serie','text',0,2,0,10,1,1,NULL,'5d1f51d6041efde46e3116712ae1ad77',0,1,' alphanumeric_total:true ',0),(365,'500','a','CDR','Nota general ','text',0,2,0,11,1,1,NULL,'c5521745452bfd70c8907ced5f644213',0,1,' alphanumeric_total:true ',0),(366,'505','a','CDR','Nota normalizada','text',0,2,0,12,1,1,NULL,'1c4a7675af85cab74bc58b105dafe3a6',0,1,' alphanumeric_total:true ',0),(367,'505','g','CDR','Volumen','text',0,2,0,13,1,1,NULL,'bbe3ddf7f9d885362518fb826601257e',0,1,' alphanumeric_total:true ',0),(368,'505','t','CDR','Descripción del volumen','text',0,2,0,14,1,1,NULL,'5b28e9f202592c69207905f1dc611cb4',0,1,' alphanumeric_total:true ',0),(369,'900','b','CDR','nivel bibliografico','combo',1,2,0,15,1,1,186,'ee4115f3f164b311d57315cc779631ea',0,1,' alphanumeric_total:true ',0),(371,'910','a','CDR','Tipo de documento','combo',1,2,1,7,1,1,189,'b018ddac638c1d6af58f3e84b34238af',1,1,' alphanumeric_total:true ',0),(372,'043','c','LIB','País','combo',1,2,0,23,1,1,197,'f719c4e32af057260f957c79460ee965',0,1,' alphanumeric_total:true ',0),(376,'650','a','ANA','Temas','auto',1,1,0,3,1,1,215,'9d3cf36046777fc75e35b60b672892af',0,1,' alphanumeric_total:true ',0),(379,'080','a','ANA','CDU','text',0,1,0,5,1,1,NULL,'b4be3602917b255fc71650c6b4502e67',0,1,' alphanumeric_total:true ',0),(382,'653','a','ANA','Palabras claves (no controlado)','text',0,1,0,4,1,1,NULL,'7c579257812de2ba5c5cf98db6986ea5',0,1,' alphanumeric_total:true ',0),(383,'700','a','ANA','Autor secundario/Colaboradores','auto',1,1,0,4,1,1,207,'22997abb9e23131b7fc77a7dc37beca8',0,1,' alphanumeric_total:true ',0),(384,'700','e','ANA','Función','text',0,1,0,4,1,1,NULL,'1cae00cebdc27054b19a081cfc8fbf57',0,1,' alphanumeric_total:true ',0),(385,'041','a','ANA','Idioma','combo',1,2,0,3,1,1,208,'ecbf4343e20f8d344f71ce2c184bd914',0,1,' alphanumeric_total:true ',0),(391,'910','a','LIB','Tipo de documento','combo',1,2,1,13,1,1,212,'2ac545d0ac9af315d139d38c904cb643',1,1,' alphanumeric_total:true ',0),(393,'245','b','ELE','Resto del título','text',0,1,0,2,1,1,NULL,'0e9d06e5be41c8e8dd27105d59fe9501',0,1,' alphanumeric_total:true ',0),(394,'110','a','ELE','Autor corporativo','auto',1,1,0,2,1,1,220,'f39871f82d76920d0c9385ab34948f86',0,1,' alphanumeric_total:true ',0),(395,'110','b','ELE','Entidad subordinada','auto',1,1,0,3,1,1,221,'ef79741a7b05365668c1c725c2d23366',0,1,' alphanumeric_total:true ',0),(401,'111','a','ELE','Nombre de la reunión','text',0,1,0,4,1,1,NULL,'2711d3fa3957d4866942a68337d6d576',0,1,' alphanumeric_total:true ',0),(402,'111','n','ELE','Número de la reunión','text',0,1,0,5,1,1,NULL,'07ca1e4c318bf51a536189725b440b5e',0,1,' alphanumeric_total:true ',0),(403,'111','d','ELE','Fecha de la reunión','text',0,1,0,6,1,1,NULL,'2ad33665f1f45296550a46f40a14a429',0,1,' alphanumeric_total:true ',0),(404,'111','c','ELE','Lugar de la reunión','text',0,1,0,7,1,1,NULL,'6776b988069fc4e96078554001654fba',0,1,' alphanumeric_total:true ',0),(405,'650','a','ELE','Temas (controlado)','auto',1,1,0,8,1,1,224,'fb3d84dd3846f30b32b0b38976a824dd',0,1,' alphanumeric_total:true ',0),(406,'653','a','ELE','Palabras claves (no controlado)','text',0,1,0,9,1,1,NULL,'b678e0ae292554094a72a2571c0d11c8',0,1,' alphanumeric_total:true ',0),(407,'700','a','ELE','Autor secundario/Colaboradores','auto',1,1,0,10,1,1,223,'1d72d56ab5f7e8f34ecb3c503caaa00f',0,1,' alphanumeric_total:true ',0),(408,'700','e','ELE','Función','text',0,1,0,11,1,1,NULL,'c19657299c72a0d1e60c1a16663e5f23',0,1,' alphanumeric_total:true ',0),(409,'041','a','ELE','Idioma','combo',1,2,0,1,1,1,225,'aff5f872f3bf3df88570d547a3e4f025',0,1,' alphanumeric_total:true ',0),(410,'043','c','ELE','País','combo',1,2,0,2,1,1,226,'a035134c45b7dc1dc6ec16dcf611eefa',0,1,' alphanumeric_total:true ',0),(411,'245','h','ELE','Medio','combo',1,2,0,3,1,1,227,'2e39bf987edb9f917e613bff3ca19490',0,1,' alphanumeric_total:true ',0),(412,'260','a','ELE','Lugar ','auto',1,2,0,4,1,1,228,'c09a3c4b035a6faecdbcab2f4267ee44',0,1,' alphanumeric_total:true ',0),(413,'260','b','ELE','Editor','text',0,2,0,5,1,1,NULL,'c4a21e6bdb9a89450b4c14acc4209b7a',0,1,' alphanumeric_total:true ',0),(414,'260','c','ELE','Fecha ','text',0,2,0,6,1,1,NULL,'4a34cdecc351107b3bee7004420ba7d6',0,1,' alphanumeric_total:true ',0),(415,'300','a','ELE','Páginas','text',0,2,0,7,1,1,NULL,'b633ef10c152201f8c5406b97cdc9019',0,1,' alphanumeric_total:true ',0),(416,'500','a','ELE','Nota general ','text',0,2,0,8,1,1,NULL,'da0c83346dc93562ac009c4b7109687a',0,1,' alphanumeric_total:true ',0),(417,'900','b','ELE','nivel bibliografico','combo',1,2,0,9,1,1,229,'04fd89e264131a605052d33b861f7dbe',0,1,' alphanumeric_total:true ',0),(418,'910','a','ELE','Tipo de documento','combo',1,2,1,6,1,1,230,'ea8d903dc272eab3544d572778529e55',1,1,' alphanumeric_total:true ',0),(419,'863','a','ELE','Volumen','text',0,2,0,11,1,1,NULL,'f86d9bddcd633c5c517fac1a77cb96d2',0,1,' alphanumeric_total:true ',0),(420,'863','b','ELE','Número','text',0,2,0,12,1,1,NULL,'89e33dc44c448e20b81d33e7722fef86',0,1,' alphanumeric_total:true ',0),(421,'863','i','ELE','Año','text',0,2,0,13,1,1,NULL,'cd1bfe2c4c741b21f14e42a71b919092',0,1,' alphanumeric_total:true ',0),(422,'100','a','LIB','Autor','auto',1,1,0,2,1,1,282,'e6e5f6ffdaf060db3d18148da10e18c2',0,1,' digits:true ',0),(423,'100','a','ELE','Autor','auto',1,1,0,2,1,1,234,'c80c9a9eb6ff3d2b538a0af1d25cddd6',0,1,' alphanumeric_total:true ',0),(424,'440','a','ELE','Serie','text',0,2,0,14,1,1,NULL,'73adf86aa3fee78abc386e1613c114c7',0,1,' alphanumeric_total:true ',0),(425,'440','p','ELE','Subserie','text',0,2,0,15,1,1,NULL,'df4b32147a3988867ee4a5be76c98e9e',0,1,' alphanumeric_total:true ',0),(426,'440','v','ELE','Número de la serie','text',0,2,0,16,1,1,NULL,'a0bf78317d22720bf5babf1d0569448a',0,1,' alphanumeric_total:true ',0),(427,'022','a','ELE','ISSN','text',0,2,0,17,1,1,NULL,'d2b395f0c58866b3e0de362972a8ecfc',0,1,' alphanumeric_total:true ',0),(428,'534','a','LIB','Nota/Versión original','text',0,1,0,22,1,1,NULL,'74381a3cd860eaec92d76a05b412dc86',0,1,' alphanumeric_total:true ',0),(429,'210','a','REV','Título abreviado','text',0,1,0,10,1,1,NULL,'8dbde1bbbb84e0604527cbd6aec35fe4',0,1,' alphanumeric_total:true ',0),(430,'222','a','REV','Título clave','text',0,1,0,11,1,1,NULL,'9c2d22c1f9c98ebd1e91d67ae5d7ec6c',0,1,' alphanumeric_total:true ',0),(431,'222','b','REV','Calificador (cualificador)','text',0,1,0,12,1,1,NULL,'cbd483aa663c42f17067d81fd11442d5',0,1,' alphanumeric_total:true ',0),(432,'856','u','ELE','URL/URI','text',0,1,0,14,1,1,NULL,'11e47f9dc7f2434b1d40ab6a120c555f',0,1,' alphanumeric_total:true ',0),(433,'247','a','REV','Título anterior','text',0,1,0,13,1,1,NULL,'f97ec3e9e67a0c13c667883670f39f2b',0,1,' alphanumeric_total:true ',0),(434,'247','f','REV','Fecha o designación secuencial ','text',0,1,0,14,1,1,NULL,'3712d44e244619fc5d02608a1b05dd2f',0,1,' alphanumeric_total:true ',0),(435,'247','g','REV','Información miscelánea ','text',0,1,0,15,1,1,NULL,'7747e124b039057ba81c5673b5bf3bd7',0,1,' alphanumeric_total:true ',0),(436,'247','x','REV','ISSN ','text',0,1,0,16,1,1,NULL,'47118f26e7ff622b348cfab31bc60332',0,1,' alphanumeric_total:true ',0),(437,'321','a','REV','Frecuencia anterior de publicación ','text',0,1,0,17,1,1,NULL,'727c84a7597ac06669ddf6905962ad4b',0,1,' alphanumeric_total:true ',0),(438,'321','b','REV','Fechas de frecuencia anterior de publicación ','text',0,1,0,18,1,1,NULL,'7f3eac03346ccdf75e320ca6b16c8359',0,1,' alphanumeric_total:true ',0),(442,'245','b','REV','Resto del título','text',0,1,0,19,1,1,NULL,'ff987e541f1901291471d8c232f7edd9',0,1,' alphanumeric_total:true ',0),(443,'080','a','SEM','CDU','text',0,1,0,2,1,1,NULL,'91d48d06df795565192d01069575f2de',0,1,' alphanumeric_total:true ',0),(444,'100','a','SEM','Autor','auto',1,1,0,3,1,1,239,'a99fa365b6d5983d71a3cb801819356e',0,1,' digits:true ',0),(445,'100','b','SEM','Numeración','text',0,1,0,4,1,1,NULL,'166914d05f9914a6378f214737a8cb52',0,1,' alphanumeric_total:true ',0),(446,'100','c','SEM','Títulos y otras palabras asociadas con el nombre','text',0,1,0,5,1,1,NULL,'73dc5edb10bb1e8cd60ccc6fa4368e4d',0,1,' alphanumeric_total:true ',0),(447,'100','d','SEM','Fechas asociadas con el nombre ','text',0,1,0,6,1,1,NULL,'8b70ecb65ab8ee927985f26675747477',0,1,' alphanumeric_total:true ',0),(448,'110','a','SEM','Autor corporativo','auto',1,1,0,7,1,1,240,'8df638839079ba4812ab6ae94f359d0d',0,1,' digits:true ',0),(449,'110','b','SEM','Entidad subordinada','auto',1,1,0,8,1,1,241,'39f2a5a7fcd16932854209b13a924ce8',0,1,' digits:true ',0),(450,'245','b','SEM','Resto del título','text',0,1,0,9,1,1,NULL,'d60a65446c0e668538130f80aaa4cc83',0,1,' alphanumeric_total:true ',0),(451,'534','a','SEM','Nota/Versión original ','text',0,1,0,10,1,1,NULL,'884d36c500cb795c826ca12812159ab1',0,1,' alphanumeric_total:true ',0),(452,'650','a','SEM','Temas (controlado)','auto',1,1,0,11,1,1,242,'2fb13946cc1f31e4e45f3084e9ed3280',0,1,' digits:true ',0),(453,'653','a','SEM','Palabras claves (no controlado)','text',0,1,0,12,1,1,NULL,'e2b06c23ac15e56bc2ec025b7526ae31',0,1,' alphanumeric_total:true ',0),(454,'700','a','SEM','Autor secundario/Colaboradores ','auto',1,1,0,13,1,1,243,'74c4b7004e1fa4d305cf11a99faf2922',0,1,' digits:true ',0),(455,'700','b','SEM','Número asociado al nombre','text',0,1,0,14,1,1,NULL,'d99091826b2e1d37877fe1e792bb9603',0,1,' alphanumeric_total:true ',0),(456,'700','c','SEM','Títulos y otras palabras asociadas con el nombre','text',0,1,0,15,1,1,NULL,'517da7c3805c69c75b9880c4b8e7e56c',0,1,' alphanumeric_total:true ',0),(457,'700','d','SEM','Fecha de nacimento y muerte ','text',0,1,0,16,1,1,NULL,'793097a29726c68c75c4a3e518e4431a',0,1,' alphanumeric_total:true ',0),(458,'700','e','SEM','Función','text',0,1,0,17,1,1,NULL,'858a0c16d6b7dc1f1edc09a448b417aa',0,1,' alphanumeric_total:true ',0),(459,'020','a','SEM','ISBN','text',0,2,0,2,1,1,NULL,'d4d9baacb5d9cc48430e3fbefe585eee',0,1,' alphanumeric_total:true ',0),(460,'041','a','SEM','Idioma','combo',1,2,0,3,1,1,244,'ea6948ee70908327ce917a87b34b8a63',0,1,' digits:true ',0),(461,'043','c','SEM','País','combo',1,2,0,4,1,1,245,'5f1b2ebfa02d2be622da1ec0ae608061',0,1,' digits:true ',0),(462,'245','h','SEM','Medio','combo',1,2,0,5,1,1,246,'11850d0845f83e1cff14c4b7c12ec7ab',0,1,' digits:true ',0),(463,'250','a','SEM','Edición','text',0,2,0,6,1,1,NULL,'eee83eccff01c1c07e040a750c8524f9',0,1,' alphanumeric_total:true ',0),(464,'260','a','SEM','Lugar','combo',1,2,0,7,1,1,247,'ea0b29b65a9fa65495e63f183a867e0d',0,1,' digits:true ',0),(465,'260','b','SEM','Editor','text',0,2,0,8,1,1,NULL,'ee87596f741ac2b186288ddb831a2f5c',0,1,' alphanumeric_total:true ',0),(466,'260','c','SEM','Fecha','text',0,2,0,9,1,1,NULL,'e39933c43829eaa22c2dccc7d72c5295',0,1,' alphanumeric_total:true ',0),(467,'300','a','SEM','Extensión/Páginas','text',0,2,0,10,1,1,NULL,'e2e1018136580c1430cdf68d63de1ab8',0,1,' alphanumeric_total:true ',0),(468,'300','b','SEM','Otros detalles físicos','text',0,2,0,11,1,1,NULL,'5877ad881a6252df97f45b0a0fcab03b',0,1,' alphanumeric_total:true ',0),(469,'300','c','SEM','Dimensiones','text',0,2,0,12,1,1,NULL,'07d02141d3c2ed5dca9b4115ecbe6a29',0,1,' alphanumeric_total:true ',0),(470,'440','a','SEM','Serie ','text',0,2,0,13,1,1,NULL,'0b7b5ca98dea318be167187592b30a41',0,1,' alphanumeric_total:true ',0),(471,'440','p','SEM','Subserie','text',0,2,0,14,1,1,NULL,'395a42af2332534bd9408b67fb4f1cc0',0,1,' alphanumeric_total:true ',0),(472,'440','v','SEM','Número de la serie','text',0,2,0,15,1,1,NULL,'da1855e0a34a6750d37d2454a8b52b80',0,1,' alphanumeric_total:true ',0),(473,'500','a','SEM','Nota general','text',0,2,0,16,1,1,NULL,'bc4b1a400cbdf1fdbb7719167571ad49',0,1,' alphanumeric_total:true ',0),(474,'505','a','SEM','Nota normalizada','text',0,2,0,17,1,1,NULL,'087c1f8614cab0b4087c02a672c5bdcd',0,1,' alphanumeric_total:true ',0),(475,'505','g','SEM','Volumen','text',0,2,0,18,1,1,NULL,'674c253be860d15b7dcb27ee97ccc0c9',0,1,' alphanumeric_total:true ',0),(476,'505','t','SEM','Descripción del volumen','text',0,2,0,19,1,1,NULL,'684232a770f9f50ccef7cd7729a7d74c',0,1,' alphanumeric_total:true ',0),(477,'900','b','SEM','nivel bibliografico','combo',1,2,0,20,1,1,248,'e41e64f6180b4e7da0ad8c94e0ae032b',0,1,' digits:true ',0),(478,'910','a','SEM','Tipo de documento','combo',1,2,1,11,1,1,249,'5aa574f5d26fd89864d2b7b8e66aab25',1,1,' digits:true ',0),(479,'041','a','FOT','Idioma','combo',1,2,0,18,1,1,254,'2ee1ac3fffd5d70afdc53eab8d1102be',0,1,' alphanumeric_total:true ',0),(480,'043','c','FOT','País','combo',1,2,0,19,1,1,252,'5236b2fa12e780d3fde8f8ff2f04dc7c',0,1,' digits:true ',0),(481,'245','h','FOT','Medio','combo',1,2,0,20,1,1,255,'fe0c12a9997c97284cc15056d43df3f8',0,1,' digits:true ',0),(482,'100','a','ANA','Autor','auto',1,1,0,7,1,1,256,'473d23493d6bfb2f8d85fa74355247b6',0,1,' digits:true ',0),(484,'856','u','REV','URL/URI','text',0,1,0,20,1,1,NULL,'05a718ae024fae5101977ab22da24f6d',0,1,' alphanumeric_total:true ',0),(485,'510','c','ANA','Ubicación dentro de la fuente (NR)','text',0,1,0,8,1,1,NULL,'e3ae786bdbbf4a936ce66ef3e40a0793',0,1,' alphanumeric_total:true ',0),(495,'900','g','ALL','Carga','text',0,3,0,9,1,1,NULL,'5f4501dba83f2874220cc9b19cd00ef8',0,1,' alphanumeric_total:true ',0),(496,'900','h','ALL','Modificación/Baja','text',0,3,0,10,1,1,NULL,'b98dec6e4f42ed7a2b3ee327aeb64a38',0,1,' alphanumeric_total:true ',0),(497,'900','i','ALL','Notas del catalogador','texta',0,3,0,11,1,1,NULL,'844feb9851dab2abf4a22217d1acd79a',0,1,' alphanumeric_total:true ',0),(498,'900','j','ALL','Control de registro','text',0,3,0,12,1,1,NULL,'c23b19ef18069b9f15a05e77e0ee2a1a',0,1,' alphanumeric_total:true ',0),(501,'995','c','LIB','Unidad de Información','combo',1,3,1,5,1,1,281,'2e9cf9c285fae2c00b1c42d5a97e8aaf',0,1,' alphanumeric_total:true ',0),(502,'995','d','LIB','Unidad de Información de Origen','combo',1,3,1,6,1,1,280,'d9630ffad0054eba402aa75bbf853ac8',0,1,' alphanumeric_total:true ',0),(503,'245','b','ANA','Resto del título (NR)','text',0,1,0,10,1,1,NULL,'422dd620757f9e370c9dc75d66663ab5',0,1,' alphanumeric_total:true ',0),(504,'859','e','REV','Procedencia','text',0,2,0,18,1,1,NULL,'5d8a8db60ef23b3070e2bc84151331e2',0,1,' alphanumeric_total:true ',0),(505,'300','a','LIB','Extensión (R)','text',0,1,0,22,1,1,NULL,'53a617b4db8b919682ce8b832ca5738a',0,1,' alphanumeric_total:true ',0),(506,'500','a','TES','Nota general (NR)','text',0,2,0,9,1,1,NULL,'0c0f49c942b12b425287196bc85ec9b2',0,1,' alphanumeric_total:true ',0),(507,'910','a','TES','Tipo de documento','combo',1,2,1,10,1,1,275,'638d3dc0e0faf0294476d80e3af02077',0,1,' digits:true ',0),(508,'995','c','ALL','Unidad de Información','combo',1,3,1,5,1,1,276,'143935d9a7a13fa47006651f0a30c811',0,1,' digits:true ',0),(509,'995','d','ALL','Unidad de Información de Origen','combo',1,3,1,6,1,1,277,'abae75e9d28b17a939d5987d3b32ea46',0,1,' digits:true ',0),(510,'995','e','ALL','Estado','combo',1,3,1,7,1,1,279,'faa66bd9eed267e6fdd1e1d3a8058934',0,1,' digits:true ',0),(511,'995','f','ALL','Código de Barras','text',0,3,0,8,1,1,NULL,'b5dfe1fda14b1063f531a1ac6ba27bcc',0,1,' alphanumeric_total:true ',0),(512,'995','m','ALL','Fecha de acceso','text',0,3,0,9,1,1,NULL,'be58c5a2149fcbf70bdf9f5cca4ff7e4',0,1,' alphanumeric_total:true ',0),(513,'995','o','ALL','Disponibilidad','combo',1,3,1,10,1,1,278,'df8af7bf6e82ca41d87359dfee68ce6b',0,1,' digits:true ',0),(514,'995','p','ALL','Precio de compra','text',0,3,0,11,1,1,NULL,'993015834fea443da73123010db786d9',0,1,' alphanumeric_total:true ',0),(515,'995','t','ALL','Signatura Topográfica','text',0,3,0,12,1,1,NULL,'c3cc7e32ba65d58db46d05cf769c8fcb',0,1,' alphanumeric_total:true ',0),(516,'995','u','ALL','Notas del item','texta',0,3,0,13,1,1,NULL,'ba3cc59c5b706d8d74dd997a03ff2c44',0,1,' alphanumeric_total:true ',0),(517,'856','u','ALL','URL/URI','text',0,1,0,2,1,1,NULL,'69cdc1146196bce382e8468b2b8da71e',0,1,' alphanumeric_total:true ',0),(518,'310','a','REV','Frecuencia','text',0,1,0,22,1,1,NULL,'52593085e471cbc2385db33b127bac3e',0,1,' alphanumeric_total:true ',0),(519,'020','a','LIB','ISBN','text',0,1,0,24,1,1,NULL,'01f5c03ff814761c1608c7f51671154c',0,1,' alphanumeric_total:true ',0),(521,'022','a','REV','ISSN','text',0,2,0,17,1,1,NULL,'8870936569bbcccfa2ea0bbb0184fa62',0,1,' alphanumeric_total:true ',0),(522,'300','a','ANA','Páginas','text',0,1,0,11,1,1,NULL,'0a12da437ffbb62e8d5d20660166cb85',0,1,' alphanumeric_total:true ',0),(523,'245','b','TES','Resto del título','text',0,1,0,10,1,1,NULL,'39ae4cb5746a5a7f774e46222108b99b',0,1,' alphanumeric_total:true ',0),(524,'856','u','REV','URL','text',0,2,0,14,1,1,NULL,'6cdd459cb7caaf4c55c5178b8c5c4d56',0,1,' alphanumeric_total:true ',0),(525,'520','a','LIB','Nota de resumen','texta',0,1,0,25,1,1,NULL,'2ea98806ce4e42d6659319ed75427267',0,1,' alphanumeric_total:true ',0);
/*!40000 ALTER TABLE `cat_estructura_catalogacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_favoritos_opac`
--

DROP TABLE IF EXISTS `cat_favoritos_opac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_favoritos_opac` (
  `nro_socio` varchar(16) NOT NULL DEFAULT '',
  `id1` int(11) NOT NULL,
  PRIMARY KEY (`nro_socio`,`id1`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_favoritos_opac`
--

LOCK TABLES `cat_favoritos_opac` WRITE;
/*!40000 ALTER TABLE `cat_favoritos_opac` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_favoritos_opac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_historico_disponibilidad`
--

DROP TABLE IF EXISTS `cat_historico_disponibilidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_historico_disponibilidad` (
  `id_detalle` int(11) NOT NULL AUTO_INCREMENT,
  `id3` int(11) NOT NULL,
  `detalle` varchar(30) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tipo_prestamo` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id_detalle`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_historico_disponibilidad`
--

LOCK TABLES `cat_historico_disponibilidad` WRITE;
/*!40000 ALTER TABLE `cat_historico_disponibilidad` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_historico_disponibilidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_portada_registro`
--

DROP TABLE IF EXISTS `cat_portada_registro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_portada_registro` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `isbn` varchar(50) DEFAULT NULL,
  `small` varchar(500) DEFAULT NULL,
  `medium` varchar(500) DEFAULT NULL,
  `large` varchar(500) DEFAULT NULL,
  UNIQUE KEY `id_2` (`id`),
  UNIQUE KEY `isbn` (`isbn`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_portada_registro`
--

LOCK TABLES `cat_portada_registro` WRITE;
/*!40000 ALTER TABLE `cat_portada_registro` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_portada_registro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_rating`
--

DROP TABLE IF EXISTS `cat_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_rating` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nro_socio` varchar(32) NOT NULL,
  `id2` int(11) NOT NULL,
  `rate` float DEFAULT NULL,
  `review` text,
  `date` varchar(20) NOT NULL,
  `review_aprobado` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nro_socio` (`nro_socio`,`id2`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_rating`
--

LOCK TABLES `cat_rating` WRITE;
/*!40000 ALTER TABLE `cat_rating` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_ref_tipo_nivel3`
--

DROP TABLE IF EXISTS `cat_ref_tipo_nivel3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_ref_tipo_nivel3` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo_doc` varchar(8) DEFAULT NULL,
  `nombre` mediumtext,
  `notforloan` smallint(6) DEFAULT NULL,
  `agregacion_temp` varchar(255) DEFAULT NULL,
  `disponible` tinyint(1) NOT NULL DEFAULT '1',
  `enable_nivel3` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_tipo_doc` (`id_tipo_doc`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_ref_tipo_nivel3`
--

LOCK TABLES `cat_ref_tipo_nivel3` WRITE;
/*!40000 ALTER TABLE `cat_ref_tipo_nivel3` DISABLE KEYS */;
INSERT INTO `cat_ref_tipo_nivel3` VALUES (1,'LIB','Libro',0,NULL,1,1),(2,'PAR','Partitura',NULL,NULL,1,0);
/*!40000 ALTER TABLE `cat_ref_tipo_nivel3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_registro_marc_n1`
--

DROP TABLE IF EXISTS `cat_registro_marc_n1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_registro_marc_n1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `marc_record` text NOT NULL,
  `template` char(3) NOT NULL,
  `clave_unicidad` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_registro_marc_n1`
--

LOCK TABLES `cat_registro_marc_n1` WRITE;
/*!40000 ALTER TABLE `cat_registro_marc_n1` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_registro_marc_n1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_registro_marc_n2`
--

DROP TABLE IF EXISTS `cat_registro_marc_n2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_registro_marc_n2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `marc_record` text NOT NULL,
  `id1` int(11) NOT NULL,
  `indice` text,
  `indice_file_path` varchar(255) DEFAULT NULL,
  `template` char(3) NOT NULL,
  `promoted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id1` (`id1`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_registro_marc_n2`
--

LOCK TABLES `cat_registro_marc_n2` WRITE;
/*!40000 ALTER TABLE `cat_registro_marc_n2` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_registro_marc_n2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_registro_marc_n2_analitica`
--

DROP TABLE IF EXISTS `cat_registro_marc_n2_analitica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_registro_marc_n2_analitica` (
  `cat_registro_marc_n2_id` int(11) NOT NULL,
  `cat_registro_marc_n1_id` int(11) NOT NULL,
  PRIMARY KEY (`cat_registro_marc_n2_id`,`cat_registro_marc_n1_id`),
  UNIQUE KEY `cat_registro_marc_n2_id` (`cat_registro_marc_n2_id`,`cat_registro_marc_n1_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_registro_marc_n2_analitica`
--

LOCK TABLES `cat_registro_marc_n2_analitica` WRITE;
/*!40000 ALTER TABLE `cat_registro_marc_n2_analitica` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_registro_marc_n2_analitica` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_registro_marc_n2_cover`
--

DROP TABLE IF EXISTS `cat_registro_marc_n2_cover`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_registro_marc_n2_cover` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id2` int(11) NOT NULL,
  `image_name` varchar(256) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id2` (`id2`),
  CONSTRAINT `cat_registro_marc_n2_cover_ibfk_1` FOREIGN KEY (`id2`) REFERENCES `cat_registro_marc_n2` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_registro_marc_n2_cover`
--

LOCK TABLES `cat_registro_marc_n2_cover` WRITE;
/*!40000 ALTER TABLE `cat_registro_marc_n2_cover` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_registro_marc_n2_cover` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_registro_marc_n3`
--

DROP TABLE IF EXISTS `cat_registro_marc_n3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_registro_marc_n3` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `marc_record` text NOT NULL,
  `id1` int(11) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `codigo_barra` varchar(255) NOT NULL,
  `signatura` varchar(255) DEFAULT NULL,
  `template` char(3) NOT NULL,
  `id2` int(11) NOT NULL,
  `agregacion_temp` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cat_registro_marc_n3_n1` (`id1`),
  KEY `cat_registro_marc_n3_n2` (`id2`),
  KEY `id1` (`id1`),
  KEY `id2` (`id2`),
  CONSTRAINT `cat_registro_marc_n3_ibfk_1` FOREIGN KEY (`id2`) REFERENCES `cat_registro_marc_n2` (`id`),
  CONSTRAINT `cat_registro_marc_n3_n1` FOREIGN KEY (`id1`) REFERENCES `cat_registro_marc_n1` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_registro_marc_n3`
--

LOCK TABLES `cat_registro_marc_n3` WRITE;
/*!40000 ALTER TABLE `cat_registro_marc_n3` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_registro_marc_n3` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_tema`
--

DROP TABLE IF EXISTS `cat_tema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_tema` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` mediumtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_tema`
--

LOCK TABLES `cat_tema` WRITE;
/*!40000 ALTER TABLE `cat_tema` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_tema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_visualizacion_intra`
--

DROP TABLE IF EXISTS `cat_visualizacion_intra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_visualizacion_intra` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campo` char(3) DEFAULT NULL,
  `pre` varchar(255) DEFAULT NULL,
  `inter` varchar(255) DEFAULT NULL,
  `post` varchar(255) DEFAULT NULL,
  `subcampo` char(1) DEFAULT NULL,
  `vista_intra` varchar(255) DEFAULT NULL,
  `tipo_ejemplar` char(3) DEFAULT NULL,
  `orden` int(11) NOT NULL,
  `nivel` int(1) DEFAULT NULL,
  `vista_campo` varchar(255) DEFAULT NULL,
  `orden_subcampo` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `campo_2` (`campo`,`subcampo`,`tipo_ejemplar`),
  UNIQUE KEY `campo_3` (`campo`,`subcampo`,`tipo_ejemplar`,`nivel`),
  UNIQUE KEY `campo_4` (`campo`,`subcampo`,`tipo_ejemplar`,`nivel`),
  KEY `campo` (`campo`,`subcampo`)
) ENGINE=InnoDB AUTO_INCREMENT=1019 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_visualizacion_intra`
--

LOCK TABLES `cat_visualizacion_intra` WRITE;
/*!40000 ALTER TABLE `cat_visualizacion_intra` DISABLE KEYS */;
INSERT INTO `cat_visualizacion_intra` VALUES (836,'245',NULL,NULL,NULL,'a','Título','ALL',188,1,'Titulo',1),(837,'245',NULL,NULL,NULL,'b','Resto del título','ALL',188,1,'Titulo',3),(838,'250',NULL,NULL,NULL,'a','Edición','LIB',38,2,'Edición',0),(839,'260',':&nbsp;',NULL,NULL,'b','Editor','LIB',54,2,'Lugar, editor y fecha',2),(840,'300',NULL,NULL,NULL,'a','Descripción física','LIB',346,2,'Páginas',0),(841,'440','.&nbsp;',NULL,NULL,'p','Subserie','LIB',216,2,'Serie',2),(842,'440','&nbsp;;&nbsp',NULL,NULL,'v','Número','LIB',216,2,'Serie',3),(843,'500',NULL,NULL,NULL,'a','Notas','LIB',244,2,'Nota general',0),(844,'505',NULL,NULL,NULL,'a','Nota normalizada','LIB',40,2,'Volumen/descripción',0),(845,'500',NULL,NULL,NULL,'a','Notas','REV',244,2,'Nota general',0),(846,'041',NULL,NULL,NULL,'a','Idioma','REV',66,2,'Idioma',2),(847,'362',NULL,NULL,NULL,'a','Situación de la publicación','REV',58,2,'Fecha de inicio - cese',0),(848,'910',NULL,NULL,NULL,'a','Tipo de Documento','REV',251,2,NULL,0),(849,'650',' -',NULL,' -','a','Término controlado','ALL',199,1,'Temas',0),(850,'653',' -',NULL,' -','a','Palabras claves (no controlado)','ALL',298,1,'Palabras claves',1),(851,'245',']',NULL,']','h','DGM','LIB',188,1,'TÍTULO PROPIAMENTE DICHO (NR)',2),(852,'110',NULL,NULL,NULL,'b','Entidad subordinada','LIB',78,1,'Autor corporativo',2),(853,'995',NULL,NULL,NULL,'c','Unidad de Información','LIB',309,3,'Datos del Ejemplar',88),(854,'995',NULL,NULL,NULL,'d','Unidad de Información de Origen','LIB',309,3,'Datos del Ejemplar',89),(855,'995',NULL,NULL,NULL,'e','Estado','LIB',309,3,'Datos del Ejemplar',90),(856,'995',NULL,NULL,NULL,'f','Código de Barras','LIB',309,3,'Datos del Ejemplar',91),(857,'995',NULL,NULL,NULL,'o','Disponibilidad','LIB',309,3,'Datos del Ejemplar',92),(858,'995',NULL,NULL,NULL,'t','Signatura Topográfica','LIB',309,3,'Datos del Ejemplar',93),(859,'210',NULL,NULL,NULL,'a','Título abreviado (NR)','REV',78,1,'Titulo abreviado',101),(860,'222',NULL,NULL,NULL,'a','Título clave (NR)','REV',101,1,'Título clave',102),(861,'222',NULL,NULL,NULL,'b','Calificador (o cualificador)','REV',101,1,'Título clave',103),(862,'240',NULL,NULL,NULL,'a','Título uniforme (NR)','REV',102,1,'Título uniforme',103),(863,'246',NULL,NULL,NULL,'a','Variantes del título','REV',104,1,'Variantes del título',105),(864,'246',NULL,NULL,NULL,'f','Designación del volumen, número, fecha','REV',104,1,'Variantes del título',106),(865,'247',NULL,NULL,NULL,'a','Título anterior','REV',105,1,'Título anterior',107),(866,'247',NULL,NULL,NULL,'f','Fecha o designación secuencial (NR)','REV',105,1,'Título anterior',108),(867,'247',NULL,NULL,NULL,'g','Información miscelánea (NR)','REV',105,1,'Título anterior',109),(868,'247',NULL,NULL,NULL,'x','ISSN (NR)','REV',105,1,'Título anterior',110),(869,'700',NULL,NULL,NULL,'e','Función','REV',77,1,'Autores secundarios/Colaboradores',3),(870,'321',NULL,NULL,NULL,'a','Frecuencia anterior de publicación (NR)','REV',116,1,'Frecuencia anterior',128),(871,'321',NULL,NULL,NULL,'b','Fechas de frecuencia anterior de publicación (NR)','REV',116,1,'Frecuencia anterior',129),(872,'700',NULL,NULL,NULL,'a','Autor secundario/Colaborador','FOT',77,1,'Autores secundarios/Colaboradores',1),(873,'250',NULL,NULL,NULL,'a','Edición','FOT',38,2,'Edición',149),(874,'300',NULL,NULL,NULL,'a','Descripción física','FOT',346,2,'Páginas',150),(875,'440',NULL,NULL,NULL,'a','Serie','FOT',216,2,'Serie',1),(876,'500',NULL,NULL,NULL,'a','Nota general','FOT',244,2,'Nota general',152),(877,'773',NULL,NULL,NULL,'a','Título (documento fuente)','FOT',66,2,'Analíticas',153),(878,'773',NULL,NULL,NULL,'d','Lugar, editor y fecha de la parte mayor','FOT',66,2,'Analíticas',154),(879,'773',NULL,NULL,NULL,'g','Ubicación de la parte','FOT',66,2,'Analíticas',155),(880,'773',NULL,NULL,NULL,'t','Título y mención de la parte mayor','FOT',66,2,'Analíticas',156),(881,'300',NULL,NULL,NULL,'a','Descripción física','DCA',346,2,'Páginas',160),(882,'440',NULL,NULL,NULL,'a','Serie','DCA',216,2,'Serie',161),(883,'700',NULL,NULL,NULL,'a','Autor secundario','TES',77,1,'Autores secundarios/Colaboradores',164),(884,'300',NULL,NULL,NULL,'a','Extensión/Páginas','TES',346,2,'Páginas',165),(885,'700',NULL,NULL,NULL,'a','Autor secundario/Colaboradores','DCA',77,1,'Autores secundarios/Colaboradores',167),(886,'041',NULL,NULL,NULL,'a','Idioma','DCA',66,2,'Idioma',168),(887,'500',NULL,NULL,NULL,'a','Nota general','DCA',244,2,'Nota general',169),(888,'910',NULL,NULL,NULL,'a','Tipo de documento','DCA',251,2,'Tipo de documento',171),(889,'900',NULL,NULL,NULL,'b','Nivel bibliografico','DCA',250,2,'Nivel bibliográfico',172),(890,'502',NULL,NULL,NULL,'a','Nota de tesis','TES',192,2,'Nota de tesis',173),(891,'502',NULL,NULL,NULL,'b','Tipo de grado','TES',192,2,'Nota de tesis',174),(892,'502',NULL,NULL,NULL,'c','Nombre de la institución otorgante','TES',192,2,'Nota de tesis',175),(893,'502',NULL,NULL,NULL,'d','Año de grado otorgado','TES',192,2,'Nota de tesis',176),(894,'100',NULL,NULL,NULL,'a','Autor','TES',1,1,'Autor',1),(895,'110',NULL,NULL,NULL,'a','Autor corporativo','REV',78,1,'Autor corporativo',1),(896,'863',NULL,NULL,NULL,'a','Volumen','REV',65,2,'Año, Vol., Número',2),(897,'863','(',NULL,')','b','Número','REV',65,2,'Año, Vol., Número',3),(898,'863',NULL,NULL,NULL,'i','Año','REV',65,2,'Año, Vol., Número',1),(899,'100',NULL,NULL,NULL,'a','Autor','FOT',1,1,'Autor',181),(900,'100',')',NULL,')','d','Fechas de nacimiento y muerte','FOT',1,1,'Autor',184),(901,'110',NULL,NULL,NULL,'a','Autor corporativo','FOT',78,1,'Autor corporativo',185),(902,'110',NULL,NULL,NULL,'b','Entidad subordinada','FOT',78,1,'Autor corporativo',186),(903,'700',')',NULL,')','e','Función','FOT',77,1,'Autores secundarios/Colaboradores',2),(904,'110',NULL,NULL,NULL,'a','Autor corporativo','LIB',78,1,'Autor corporativo',1),(905,'260',NULL,NULL,NULL,'b','Editor','FOT',54,2,'Lugar, editor y fecha',2),(906,'020',NULL,NULL,NULL,'a','ISBN','FOT',221,2,'ISBN',188),(907,'505',NULL,NULL,NULL,'a','Nota normalizada','FOT',40,2,'Volumen/descripción',191),(908,'250',NULL,NULL,NULL,'a','Edición','TES',38,2,'Edición',187),(909,'020',NULL,NULL,NULL,'a','ISBN','TES',221,2,'ISBN',193),(910,'500',NULL,NULL,NULL,'a','Nota general','TES',244,2,'Nota general',194),(911,'111',NULL,NULL,NULL,'a','Nombre de la reunión','LIB',195,1,'Congresos, conferencias, etc.',195),(912,'111',NULL,NULL,NULL,'n','Número de la reunión','LIB',195,1,'Congresos, conferencias, etc.',196),(913,'111',NULL,NULL,NULL,'d','Fecha de la reunión','LIB',195,1,'Congresos, conferencias, etc.',197),(914,'111',NULL,NULL,NULL,'c','Lugar de la reunión','LIB',195,1,'Congresos, conferencias, etc.',198),(915,'700','-',NULL,'-','a','Autor secundario/Colaborador','LIB',77,1,'Autores secundarios/Colaboradores',1),(916,'700',')',NULL,')','e','Función','LIB',77,1,'Autores secundarios/Colaboradores',5),(917,'111',NULL,NULL,NULL,'-','Autor secundario/Colaborador','FOT',195,1,'Congresos, conferencias, etc.',200),(918,'111',NULL,NULL,NULL,'n','Número de la reunión','FOT',195,1,'Congresos, conferencias, etc.',201),(919,'111',NULL,NULL,NULL,'d','Fecha de la reunión','FOT',195,1,'Congresos, conferencias, etc.',202),(920,'111',NULL,NULL,NULL,'c','Lugar de la reunión','FOT',195,1,'Congresos, conferencias, etc.',203),(921,'505','v.&nbsp;',NULL,NULL,'g','Volumen','LIB',40,2,'Volumen/descripción',205),(922,'505',':&nbsp;',NULL,NULL,'t','Descripción del volumen','LIB',40,2,'Volumen/descripción',206),(923,'505',NULL,NULL,NULL,'g','Volumen','FOT',40,2,'Volumen/descripción',207),(924,'505',NULL,NULL,NULL,'t','Descripción del volumen','FOT',40,2,'Volumen/descripción',208),(925,'260',NULL,NULL,NULL,'b','Editor','REV',54,2,'Lugar y editor',2),(926,'260',',&nbsp;',NULL,NULL,'c','Fecha','LIB',54,2,'Lugar, editor y fecha',3),(927,'043',NULL,NULL,NULL,'c','País','LIB',43,2,'País',216),(928,'534','&nbsp;',NULL,NULL,'a','Nota/versión original','LIB',217,1,'Nota/versión original',217),(929,'100',NULL,NULL,NULL,'a','Autor','ANA',1,1,'Autor',218),(930,'440',NULL,NULL,NULL,'v','Número de la serie','FOT',216,2,'Serie',219),(931,'440',NULL,NULL,NULL,'p','Subserie','FOT',216,2,'Serie',220),(932,'440',NULL,NULL,NULL,'a','Serie','LIB',216,2,'Serie',1),(933,'700',NULL,NULL,NULL,'a','Autor secundario/Colaboradores','ANA',77,1,'Autores secundarios/Colaboradores',222),(934,'700',NULL,NULL,NULL,'e','Función','ANA',77,1,'Autores secundarios/Colaboradores',223),(935,'110',NULL,NULL,NULL,'a','Autor corporativo','ANA',78,1,'Autor corporativo',223),(936,'110',NULL,NULL,NULL,'b','Entidad subordinada','ANA',78,1,'Autor corporativo',224),(937,'041',NULL,NULL,NULL,'a','Idioma','ANA',66,2,'Idioma',225),(938,'100',NULL,NULL,NULL,'a','Autor','ELE',1,1,'Autor',226),(939,'110',NULL,NULL,NULL,'a','Autor corporativo','ELE',78,1,'Autor corporativo',228),(940,'110',NULL,NULL,NULL,'b','Entidad subordinada','ELE',78,1,'ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)',229),(941,'111','.',NULL,'.','a','Nombre de la reunión','ELE',195,1,'Congresos, conferencias, etc.',230),(942,'111',NULL,NULL,NULL,'n','Número de la reunión','ELE',195,1,'Congresos, conferencias, etc.',231),(943,'111',NULL,NULL,NULL,'d','Fecha de la reunión','ELE',195,1,'Congresos, conferencias, etc.',232),(944,'111',NULL,NULL,NULL,'c','Lugar de la reunión','ELE',195,1,'Congresos, conferencias, etc.',233),(945,'260',NULL,NULL,NULL,'a','Lugar','ELE',54,2,'Lugar, editor y fecha',231),(946,'260',NULL,NULL,NULL,'b','Editor','ELE',54,2,'Lugar, editor y fecha',232),(947,'260',NULL,NULL,NULL,'c','Fecha','ELE',54,2,'Lugar, editor y fecha',233),(948,'043',NULL,NULL,NULL,'c','País','ELE',43,2,'País',234),(949,'500',NULL,NULL,NULL,'a','Nota general','ELE',244,2,'Nota general',235),(950,'863',NULL,NULL,NULL,'a','Volumen','ELE',65,2,'Año, vol. y nro.',2),(951,'863',')',NULL,')','b','Número','ELE',65,2,'Año, vol. y nro.',3),(952,'863',NULL,NULL,NULL,'i','Año','ELE',65,2,'Año, vol. y nro.',1),(953,'700',' -',NULL,' -','a','Autor secundario/Colaboradores','ELE',77,1,'Autores secundarios/Colaboradores',239),(954,'260',NULL,NULL,NULL,'a','Lugar','LIB',54,2,'Lugar, editor y fecha',1),(955,'440',NULL,NULL,NULL,'a','Serie','ELE',216,2,'Serie',245),(956,'440',NULL,NULL,NULL,'p','Subserie','ELE',216,2,'Serie',246),(957,'440',NULL,NULL,NULL,'v','Número de la serie','ELE',216,2,'Serie',247),(958,'022',NULL,NULL,NULL,'a','ISSN','ELE',255,2,'ISSN',248),(959,'080',NULL,NULL,NULL,'a','CDU','LIB',249,1,'CDU',249),(960,'910',NULL,NULL,NULL,'a','Tipo de documento','LIB',251,2,'Tipo de documento',250),(961,'900',NULL,NULL,NULL,'b','nivel bibliografico','LIB',250,2,'Nivel Bibliográfico',251),(962,'856',NULL,NULL,NULL,'u','URL/URI','ELE',349,1,'URL/URI',252),(963,'020',NULL,NULL,NULL,'a','ISBN','ELE',221,2,'ISBN',253),(964,'300',NULL,NULL,NULL,'a','Extensión/Páginas','ELE',346,2,'Páginas',253),(965,'260',NULL,NULL,':&nbsp;','a','Lugar','REV',54,2,'Lugar y editor',1),(966,'440',')',NULL,')','a','Serie','REV',216,2,'Serie',256),(967,'900',NULL,NULL,NULL,'b','nivel bibliografico','REV',250,2,'Nivel Bibliográfico',258),(968,'502',NULL,NULL,NULL,'a','Nota de tesis','ELE',259,2,'Nota de tesis',259),(969,'502',NULL,NULL,NULL,'b','Grado','ELE',260,2,'Nota de tesis',260),(970,'502',NULL,NULL,NULL,'c','Institución','ELE',261,2,'Nota de tesis',261),(971,'502',NULL,NULL,NULL,'d','Año','ELE',262,2,'Nota de tesis',262),(972,'100',NULL,NULL,NULL,'a','Autor','SEM',1,1,'Autor',264),(973,'110',NULL,NULL,NULL,'a','Autor corporativo','SEM',78,1,'Autor corporativo',268),(974,'100',')',NULL,')','d','Fechas de nacimiento y muerte','SEM',1,1,'ASIENTO PRINCIPAL - NOMBRE PERSONAL (NR)',269),(975,'110',NULL,NULL,NULL,'b','Entidad subordinada','SEM',78,1,'ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)',270),(976,'080',NULL,NULL,NULL,'a','CDU','SEM',249,1,'CDU',269),(977,'250',NULL,NULL,NULL,'a','Edición','SEM',38,2,'Edición',270),(978,'505',NULL,NULL,NULL,'a','Nota normalizada','SEM',40,2,'Nota normalizada',271),(979,'505',NULL,NULL,NULL,'g','Volumen','SEM',40,2,'NOTA DE CONTENIDOS FORMATEADA (R)',272),(980,'505',NULL,NULL,NULL,'t','Descripción del volumen','SEM',40,2,'NOTA DE CONTENIDOS FORMATEADA (R)',273),(981,'260',NULL,NULL,NULL,'a','Lugar','SEM',54,2,'Lugar, editor y fecha',274),(982,'260',NULL,NULL,NULL,'b','Editor','SEM',54,2,'Lugar, editor y fecha',275),(983,'260',NULL,NULL,NULL,'c','Fecha','SEM',54,2,'Lugar, editor y fecha',276),(984,'440',NULL,NULL,NULL,'a','Serie','SEM',216,2,'Serie',277),(985,'440',NULL,NULL,NULL,'p','Subserie','SEM',216,2,'MENCIÓN DE SERIE/ASIENTO AGREGADA - TÍTULO (R) [OBSOLETE]',278),(986,'440',NULL,NULL,NULL,'v','Número de la serie','SEM',216,2,'MENCIÓN DE SERIE/ASIENTO AGREGADA - TÍTULO (R) [OBSOLETE]',279),(987,'043',NULL,NULL,NULL,'c','País','SEM',43,2,'País',280),(988,'300',NULL,NULL,NULL,'a','Páginas','SEM',346,2,'Páginas',281),(989,'900',NULL,NULL,NULL,'b','nivel bibliografico','SEM',250,2,'Nivel Bibliográfico',282),(990,'500',NULL,NULL,NULL,'a','Nota general','SEM',244,2,'NOTA GENERAL (R)',283),(991,'910',NULL,NULL,NULL,'a','Tipo de documento','SEM',251,2,'Tipo de documento',284),(992,'856',NULL,NULL,NULL,'u','URL/URI','SEM',349,3,'URI/URL',285),(993,'995',NULL,NULL,NULL,'c','Unidad de Información','SEM',309,3,'Datos del Ejemplar',286),(994,'995',NULL,NULL,NULL,'d','Unidad de Información de Origen','SEM',309,3,'Datos del Ejemplar',287),(995,'995',NULL,NULL,NULL,'e','Estado','SEM',309,3,'Datos del Ejemplar',288),(996,'995',NULL,NULL,NULL,'f','Código de Barras','SEM',309,3,'Datos del Ejemplar',289),(997,'995',NULL,NULL,NULL,'m','Fecha de acceso','SEM',309,3,'Datos del Ejemplar',290),(998,'995',NULL,NULL,NULL,'o','Disponibilidad','SEM',309,3,'Datos del Ejemplar',291),(999,'995',NULL,NULL,NULL,'t','Signatura Topográfica','SEM',309,3,'Datos del Ejemplar',292),(1000,'995',NULL,NULL,NULL,'u','Notas del item','SEM',309,3,'Datos del Ejemplar',293),(1001,'520',NULL,NULL,NULL,'a','Nota de resumen','LIB',324,1,'Resumen',294),(1002,'520',NULL,NULL,NULL,'a','Nota de resumen','ELE',324,1,'Resumen',295),(1003,'520',NULL,NULL,NULL,'a','Nota de resumen','DCD',324,1,'Resumen',296),(1004,'520',NULL,NULL,NULL,'a','Nota de resumen','REV',324,1,'Resumen',297),(1005,'700',')',NULL,')','e','Función','TES',77,1,'ASIENTO ADICIONAL DEL TÍTULO - NOMBRE PERSONAL (R)',298),(1006,'520',NULL,NULL,NULL,'a','Nota de resumen','TES',324,1,'Nota de resumen',299),(1007,'700',')',NULL,')','e','Función','ELE',77,1,'ASIENTO ADICIONAL DEL TÍTULO - NOMBRE PERSONAL (R)',300),(1008,'995',NULL,NULL,NULL,'t','Signatura Topográfica','ANA',309,1,'Signatura topográfica',301),(1009,'856',NULL,NULL,NULL,'u','URL/URI','REV',349,2,'URL/URI',311),(1010,'510',NULL,NULL,NULL,'c','Ubicación dentro de la fuente (NR)','ANA',333,1,'Ubicación dentro de la fuente',312),(1011,'856',NULL,NULL,NULL,'u','URL/URI','LIB',349,1,'URL/URI',313),(1012,'300',NULL,NULL,NULL,'a','Páginas','ANA',346,1,'Páginas',318),(1013,'859',NULL,NULL,NULL,'e','Procedencia','REV',344,2,'Procedencia',334),(1014,'856',NULL,NULL,NULL,'u','URL/URI','ALL',349,1,'URL/URI',335),(1015,'022',NULL,NULL,NULL,'a','ISSN','REV',255,2,'ISSN',342),(1016,'310',NULL,NULL,NULL,'a','Frecuencia','REV',107,1,'Frecuencia',345),(1017,'020',NULL,NULL,NULL,'a','ISBN','LIB',221,2,'ISBN',346),(1018,'100',NULL,NULL,NULL,'a','Autor','LIB',1,1,'Autor',347);
/*!40000 ALTER TABLE `cat_visualizacion_intra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_visualizacion_opac`
--

DROP TABLE IF EXISTS `cat_visualizacion_opac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cat_visualizacion_opac` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campo` char(3) DEFAULT NULL,
  `tipo_ejemplar` char(3) DEFAULT NULL,
  `pre` varchar(255) DEFAULT NULL,
  `inter` varchar(255) DEFAULT NULL,
  `post` varchar(255) DEFAULT NULL,
  `subcampo` char(1) DEFAULT NULL,
  `vista_opac` varchar(255) DEFAULT NULL,
  `vista_campo` varchar(255) NOT NULL,
  `orden` int(11) NOT NULL,
  `orden_subcampo` int(11) NOT NULL,
  `nivel` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `campo_2` (`campo`,`tipo_ejemplar`,`subcampo`,`nivel`),
  UNIQUE KEY `campo_3` (`campo`,`subcampo`,`tipo_ejemplar`,`nivel`),
  KEY `campo` (`campo`,`subcampo`)
) ENGINE=InnoDB AUTO_INCREMENT=289 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_visualizacion_opac`
--

LOCK TABLES `cat_visualizacion_opac` WRITE;
/*!40000 ALTER TABLE `cat_visualizacion_opac` DISABLE KEYS */;
INSERT INTO `cat_visualizacion_opac` VALUES (215,'245','ALL',NULL,NULL,NULL,'a','Título','Título',65,1,1),(216,'245','ALL',NULL,NULL,NULL,'b','Resto del título','Título',65,3,1),(217,'260','ALL',NULL,NULL,' :','a','Lugar','Lugar, editor y fecha',19,1,2),(218,'995','ALL',NULL,NULL,NULL,'d','Unidad de Información de Origen',' ',128,0,3),(219,'910','ALL',NULL,NULL,NULL,'a','Tipo de Documento',' ',130,0,2),(220,'440','ALL',NULL,NULL,NULL,'a','Serie','Serie',46,0,2),(221,'650','ALL',NULL,NULL,NULL,'a','Tema','Temas',132,0,1),(222,'260','ALL',':&nbsp;',NULL,',','b','Editor','Lugar, editor y fecha',19,2,2),(223,'995','LIB',NULL,NULL,NULL,'t','Signatura Topográfica',' ',128,0,3),(224,'110','LIB',NULL,NULL,NULL,'-','Autor corporativo','Autor corporativo',34,34,1),(225,'653','LIB',NULL,NULL,NULL,'-','Palabras claves','Palabras claves',50,36,1),(226,'080','LIB',NULL,NULL,NULL,'a','CDU','CDU',135,37,1),(227,'250','LIB',NULL,NULL,NULL,'a','Edición','Edición',6,39,2),(228,'300','LIB',NULL,NULL,NULL,'a','Extensión/Páginas','Páginas',43,43,2),(229,'440','LIB','.&nbsp;',NULL,' ;','p','Subserie','Serie',46,44,2),(230,'440','LIB','&nbsp;;&nbsp',NULL,')','v','Número de la serie','Serie',46,45,2),(231,'500','LIB',NULL,NULL,NULL,'a','Notas','Notas',85,44,2),(232,'111','LIB',NULL,NULL,NULL,'a','Nombre de la reunión','Nombre de la reunión',36,48,1),(233,'111','LIB',NULL,NULL,NULL,'n','Número de la reunión','ASIENTO PRINCIPAL - NOMBRE DE LA REUNIÓN (NR)',36,49,1),(234,'505','LIB','v.&nbsp;',NULL,NULL,'g','Volumen','Volumen/Descripción',13,51,2),(235,'505','LIB',':&nbsp;',NULL,NULL,'t','Descripción del volumen','Volumen/Descripción',13,52,2),(236,'110','CDR',NULL,NULL,NULL,'a','Autor corporativo','Autor corporativo',34,53,1),(237,'110','CDR',NULL,NULL,NULL,'b','Entidad subordinada','ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)',34,54,1),(238,'653','CDR',NULL,NULL,NULL,'a','Palabras claves','Palabras claves',50,55,1),(239,'245','LIB',NULL,NULL,NULL,'h','Medio','TÍTULO PROPIAMENTE DICHO (NR)',65,60,1),(240,'534','LIB',NULL,NULL,NULL,'a','Nota/versión original','Nota/versión original',37,61,1),(241,'022','ELE',NULL,NULL,NULL,'a','ISSN','ISSN',108,62,2),(242,'700','ELE',NULL,NULL,NULL,'a','Autor secundario/Colaboradores','Autores secundarios/Colaboradores',25,1,1),(243,'110','LEG',NULL,NULL,NULL,'a','Autor corporativo','ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)',34,79,1),(244,'110','LIB',NULL,NULL,NULL,'a','Autor corporativo','ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)',34,66,1),(245,'110','LIB',NULL,NULL,NULL,'b','Entidad subordinada','ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)',34,67,1),(246,'043','LIB',NULL,NULL,NULL,'c','País','País',42,66,2),(247,'110','REV',NULL,NULL,NULL,'a','Autor corporativo','Autor corporativo',34,86,1),(248,'110','REV',NULL,NULL,NULL,'b','Entidad subordinada','ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)',34,87,1),(249,'210','REV',NULL,NULL,NULL,'a','Título abreviado','Título abreviado',90,88,1),(250,'222','REV',NULL,NULL,NULL,'b','Calificador (cualificador)','Título clave',91,90,1),(251,'240','REV',NULL,NULL,NULL,'a','Título uniforme','Título uniforme',92,91,1),(252,'246','REV',NULL,NULL,NULL,'a','Variante del título','Variantes del título',113,92,1),(253,'100','ELE',NULL,NULL,NULL,'a','Autor','Autor',1,93,1),(254,'110','ELE',NULL,NULL,NULL,'a','Autor corporativo','Autor corporativo',34,94,1),(255,'653','ELE',NULL,NULL,NULL,'a','Palabras claves (no controlado)','Palabras claves',50,95,1),(256,'856','ELE',NULL,NULL,NULL,'u','URL/URI','URL/URI',136,96,1),(257,'043','ELE',NULL,NULL,NULL,'c','País','País',42,97,2),(258,'500','ELE',NULL,NULL,NULL,'a','Nota general','Nota general',85,98,2),(259,'863','ELE',NULL,NULL,NULL,'i','Año','Año, vol., nro.',19,99,2),(260,'863','ELE',NULL,NULL,NULL,'a','Volumen','Año, vol., nro.',19,100,2),(261,'863','ELE',')',NULL,')','b','Número','Año, vol., nro.',19,101,2),(262,'300','ELE',NULL,NULL,NULL,'a','Extensión/Páginas','Páginas',43,102,2),(263,'310','REV',NULL,NULL,NULL,'a','Frecuencia-Periodicidad','Frecuencia actual de la publicación',13,103,2),(264,'310','REV',NULL,NULL,NULL,'b','Fecha de frecuencia actual de la publicación','Frecuencia actual de la publicación',13,104,2),(265,'362','REV',NULL,NULL,NULL,'a','Fecha de inicio - cese','Fecha de inicio - cese',6,104,2),(266,'041','REV',NULL,NULL,NULL,'a','Idioma','Idioma',103,106,2),(267,'863','REV',NULL,NULL,NULL,'i','Año','Vol., nro. y año',19,107,2),(268,'863','REV',NULL,NULL,NULL,'a','Volumen','Vol., nro. y año',19,108,2),(269,'863','REV',')',NULL,')','b','Número','Vol., nro. y año',19,109,2),(270,'022','REV',NULL,NULL,NULL,'a','ISSN','ISSN',108,109,2),(271,'500','REV',NULL,NULL,NULL,'a','Nota general','Nota general',85,111,2),(272,'111','ELE',',',NULL,',','a','Congresos y conferencias','Congresos/Conferencias',36,1,1),(273,'111','ELE',',',NULL,',','c','Lugar','ASIENTO PRINCIPAL - NOMBRE DE LA REUNIÓN (NR)',36,3,1),(274,'111','ELE',NULL,NULL,NULL,'d','Fecha','ASIENTO PRINCIPAL - NOMBRE DE LA REUNIÓN (NR)',36,4,1),(275,'111','ELE',NULL,NULL,NULL,'n','Número','ASIENTO PRINCIPAL - NOMBRE DE LA REUNIÓN (NR)',36,2,1),(276,'520','ELE',NULL,NULL,NULL,'a','Resumen','Resumen',120,120,1),(277,'260','LIB',',&nbsp;',NULL,NULL,'c','Fecha','PUBLICACIÓN, DISTRIBUCIÓN, ETC. (PIE DE IMPRENTA) (R)',19,122,2),(278,'653','TES',NULL,NULL,NULL,'a','Palabras claves (no controlado)','Palabras claves',50,123,1),(279,'520','TES',NULL,NULL,NULL,'a','Nota de resumen','Resumen',124,124,1),(280,'100','ANA',NULL,NULL,NULL,'a','Autor','Autor',1,125,1),(281,'653','ANA',NULL,NULL,NULL,'a','Palabras claves (no controlado)','Palabras claves',50,126,1),(282,'995','ANA',NULL,NULL,NULL,'t','Signatura Topográfica','Ubicación',128,127,1),(283,'110','ANA',NULL,NULL,NULL,'a','Autor corporativo','Autor corporativo',34,128,1),(284,'856','REV',NULL,NULL,NULL,'u','URL/URI','URL/URI',136,129,1),(285,'020','LIB',NULL,NULL,NULL,'a','ISBN','ISBN',52,130,2),(286,'900','LIB',NULL,NULL,NULL,'b','Nivel bibliografico','Nivel Bibliográfico',131,131,2),(287,'856','LIB',NULL,NULL,NULL,'u','URL/URI','URL/URI',136,132,1),(288,'856','ALL',NULL,NULL,NULL,'u','URL/URI','URL/URI',136,134,1);
/*!40000 ALTER TABLE `cat_visualizacion_opac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circ_prestamo`
--

DROP TABLE IF EXISTS `circ_prestamo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circ_prestamo` (
  `id_prestamo` int(11) NOT NULL AUTO_INCREMENT,
  `id3` int(11) NOT NULL,
  `nro_socio` varchar(16) DEFAULT NULL,
  `tipo_prestamo` char(2) DEFAULT NULL,
  `fecha_prestamo` varchar(20) NOT NULL,
  `id_ui_origen` char(4) NOT NULL,
  `id_ui_prestamo` char(4) NOT NULL,
  `fecha_devolucion` varchar(20) DEFAULT NULL,
  `fecha_ultima_renovacion` varchar(20) DEFAULT NULL,
  `renovaciones` tinyint(4) DEFAULT NULL,
  `cant_recordatorio_via_mail` int(11) NOT NULL DEFAULT '0',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `agregacion_temp` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_prestamo`),
  UNIQUE KEY `id3_2` (`id3`,`nro_socio`),
  KEY `issuesitemidx` (`id3`),
  KEY `bordate` (`timestamp`),
  KEY `id3` (`id3`),
  KEY `nro_socio` (`nro_socio`),
  KEY `tipo_prestamo` (`tipo_prestamo`),
  KEY `fecha_prestamo` (`fecha_prestamo`),
  KEY `fecha_devolucion` (`fecha_devolucion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circ_prestamo`
--

LOCK TABLES `circ_prestamo` WRITE;
/*!40000 ALTER TABLE `circ_prestamo` DISABLE KEYS */;
/*!40000 ALTER TABLE `circ_prestamo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circ_prestamo_vencido_temp`
--

DROP TABLE IF EXISTS `circ_prestamo_vencido_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circ_prestamo_vencido_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_prestamo` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circ_prestamo_vencido_temp`
--

LOCK TABLES `circ_prestamo_vencido_temp` WRITE;
/*!40000 ALTER TABLE `circ_prestamo_vencido_temp` DISABLE KEYS */;
/*!40000 ALTER TABLE `circ_prestamo_vencido_temp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circ_ref_tipo_prestamo`
--

DROP TABLE IF EXISTS `circ_ref_tipo_prestamo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circ_ref_tipo_prestamo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo_prestamo` char(4) DEFAULT NULL,
  `descripcion` text,
  `codigo_disponibilidad` varchar(255) NOT NULL DEFAULT 'CIRC0000',
  `prestamos` int(11) NOT NULL DEFAULT '0',
  `dias_prestamo` int(11) NOT NULL DEFAULT '0',
  `renovaciones` int(11) NOT NULL DEFAULT '0',
  `dias_renovacion` tinyint(3) NOT NULL DEFAULT '0',
  `dias_antes_renovacion` tinyint(10) NOT NULL DEFAULT '0',
  `habilitado` tinyint(4) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circ_ref_tipo_prestamo`
--

LOCK TABLES `circ_ref_tipo_prestamo` WRITE;
/*!40000 ALTER TABLE `circ_ref_tipo_prestamo` DISABLE KEYS */;
INSERT INTO `circ_ref_tipo_prestamo` VALUES (1,'DO','Domiciliario','CIRC0000',3,14,3,14,3,1);
/*!40000 ALTER TABLE `circ_ref_tipo_prestamo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circ_regla_sancion`
--

DROP TABLE IF EXISTS `circ_regla_sancion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circ_regla_sancion` (
  `regla_sancion` int(11) NOT NULL AUTO_INCREMENT,
  `dias_sancion` int(11) NOT NULL DEFAULT '0',
  `dias_demora` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`regla_sancion`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circ_regla_sancion`
--

LOCK TABLES `circ_regla_sancion` WRITE;
/*!40000 ALTER TABLE `circ_regla_sancion` DISABLE KEYS */;
/*!40000 ALTER TABLE `circ_regla_sancion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circ_regla_tipo_sancion`
--

DROP TABLE IF EXISTS `circ_regla_tipo_sancion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circ_regla_tipo_sancion` (
  `tipo_sancion` int(11) NOT NULL DEFAULT '0',
  `regla_sancion` int(11) NOT NULL DEFAULT '0',
  `orden` int(11) NOT NULL DEFAULT '1',
  `cantidad` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`tipo_sancion`,`regla_sancion`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circ_regla_tipo_sancion`
--

LOCK TABLES `circ_regla_tipo_sancion` WRITE;
/*!40000 ALTER TABLE `circ_regla_tipo_sancion` DISABLE KEYS */;
/*!40000 ALTER TABLE `circ_regla_tipo_sancion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circ_reserva`
--

DROP TABLE IF EXISTS `circ_reserva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circ_reserva` (
  `id2` int(11) NOT NULL,
  `id3` int(11) DEFAULT NULL,
  `id_reserva` int(11) NOT NULL AUTO_INCREMENT,
  `nro_socio` varchar(16) DEFAULT NULL,
  `fecha_reserva` varchar(20) DEFAULT NULL,
  `estado` char(1) DEFAULT NULL,
  `id_ui` varchar(4) NOT NULL,
  `fecha_notificacion` varchar(20) DEFAULT NULL,
  `fecha_recordatorio` varchar(20) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_reserva`),
  KEY `id2` (`id2`),
  KEY `id3` (`id3`),
  KEY `nro_socio` (`nro_socio`),
  KEY `estado` (`estado`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `circ_sancion`
--

DROP TABLE IF EXISTS `circ_sancion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circ_sancion` (
  `id_sancion` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_sancion` int(11) DEFAULT '0',
  `id_reserva` int(11) DEFAULT NULL,
  `nro_socio` varchar(16) DEFAULT NULL,
  `fecha_comienzo` date NOT NULL DEFAULT '0000-00-00',
  `fecha_final` date NOT NULL DEFAULT '0000-00-00',
  `dias_sancion` int(11) DEFAULT '0',
  `id3` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_sancion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circ_sancion`
--

LOCK TABLES `circ_sancion` WRITE;
/*!40000 ALTER TABLE `circ_sancion` DISABLE KEYS */;
/*!40000 ALTER TABLE `circ_sancion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circ_tipo_prestamo_sancion`
--

DROP TABLE IF EXISTS `circ_tipo_prestamo_sancion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circ_tipo_prestamo_sancion` (
  `tipo_sancion` int(11) NOT NULL DEFAULT '0',
  `tipo_prestamo` char(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`tipo_sancion`,`tipo_prestamo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circ_tipo_prestamo_sancion`
--

LOCK TABLES `circ_tipo_prestamo_sancion` WRITE;
/*!40000 ALTER TABLE `circ_tipo_prestamo_sancion` DISABLE KEYS */;
INSERT INTO `circ_tipo_prestamo_sancion` VALUES (1,'DO'),(1,'ES'),(1,'FO'),(1,'IN'),(1,'SA'),(1,'VE'),(2,'DO'),(2,'ES'),(2,'FO'),(2,'IN'),(2,'VE'),(3,'DO'),(3,'ES'),(3,'FO'),(3,'IN'),(3,'SA'),(3,'VE'),(4,'DO'),(4,'ES'),(4,'FO'),(4,'IN'),(4,'SA'),(4,'VE'),(5,'DO'),(5,'ES'),(5,'FO'),(5,'IN'),(5,'SA'),(5,'VE'),(6,'DO'),(6,'ES'),(6,'FO'),(6,'IN'),(6,'SA'),(6,'VE'),(7,'DO'),(7,'ES'),(7,'FO'),(7,'IN'),(7,'PI'),(7,'SE'),(7,'VE'),(8,'DO'),(8,'ES'),(8,'FO'),(8,'IN'),(8,'SA'),(8,'VE'),(9,'DO'),(9,'ES'),(9,'FO'),(9,'IN'),(9,'SA'),(9,'VE'),(10,'DO'),(10,'ES'),(10,'FO'),(10,'IN'),(10,'SA'),(10,'VE'),(11,'DO'),(11,'ES'),(11,'FO'),(11,'IN'),(11,'PI'),(11,'VE'),(12,'DO'),(12,'ES'),(12,'FO'),(12,'IN'),(12,'SA'),(12,'VE'),(13,'DO'),(13,'ES'),(13,'FO'),(13,'IN'),(13,'VE'),(14,'DO'),(14,'ES'),(14,'FO'),(14,'IN'),(14,'PI'),(14,'VE'),(15,'DO'),(15,'ES'),(15,'FO'),(15,'IN'),(15,'PI'),(15,'SA'),(15,'VE'),(16,'DO'),(16,'ES'),(16,'FO'),(16,'IN'),(16,'PI'),(16,'SA'),(16,'VE'),(17,'DO'),(17,'ES'),(17,'FO'),(17,'IN'),(17,'SA'),(17,'VE'),(18,'DO'),(18,'ES'),(18,'FO'),(18,'IN'),(18,'SA'),(18,'VE'),(19,'DO'),(19,'ES'),(19,'FO'),(19,'IN'),(19,'PI'),(19,'SA'),(19,'VE'),(20,'DO'),(20,'ES'),(20,'FO'),(20,'IN'),(20,'SA'),(20,'VE'),(21,'DO'),(21,'ES'),(21,'FO'),(21,'IN'),(21,'SA'),(21,'SE'),(21,'VE'),(22,'DO'),(22,'ES'),(22,'FO'),(22,'IN'),(22,'PI'),(22,'SA'),(22,'VE'),(23,'DO'),(23,'ES'),(23,'FO'),(23,'IN'),(23,'SA'),(23,'VE'),(24,'DO'),(24,'ES'),(24,'FO'),(24,'IN'),(24,'SA'),(24,'VE'),(25,'DO'),(25,'ES'),(25,'FO'),(25,'IN'),(25,'SA'),(25,'VE'),(26,'DO'),(26,'ES'),(26,'FO'),(26,'IN'),(26,'SA'),(26,'VE'),(27,'DO'),(27,'ES'),(27,'FO'),(27,'IN'),(27,'SA'),(27,'VE'),(28,'DO'),(28,'ES'),(28,'FO'),(28,'IN'),(28,'PI'),(28,'SA'),(28,'VE'),(29,'DO'),(29,'ES'),(29,'FO'),(29,'IN'),(29,'PI'),(29,'SA'),(29,'VE'),(30,'DO'),(30,'ES'),(30,'FO'),(30,'SA'),(30,'VE'),(31,'DO'),(31,'ES'),(31,'FO'),(31,'IN'),(31,'PI'),(31,'VE'),(32,'DO'),(32,'ES'),(32,'FO'),(32,'IN'),(32,'SA'),(32,'VE'),(33,'DO'),(33,'ES'),(33,'FO'),(33,'IN'),(33,'PI'),(33,'SA'),(33,'VE'),(34,'DO'),(34,'ES'),(34,'FO'),(34,'IN'),(34,'SA'),(34,'VE'),(35,'DO'),(35,'ES'),(35,'FO'),(35,'IN'),(35,'SA'),(35,'VE'),(36,'DO'),(36,'ES'),(36,'FO'),(36,'IN'),(36,'PI'),(36,'SA'),(36,'VE'),(37,'DO'),(37,'ES'),(37,'FO'),(37,'IN'),(37,'VE'),(38,'DO'),(38,'ES'),(38,'FO'),(38,'IN'),(38,'SA'),(38,'VE'),(39,'DO'),(39,'ES'),(39,'FO'),(39,'IN'),(39,'SA'),(39,'VE'),(40,'DO'),(40,'ES'),(40,'FO'),(40,'IN'),(40,'SA'),(40,'VE'),(41,'DO'),(41,'ES'),(41,'FO'),(41,'IN'),(41,'SA'),(41,'VE'),(42,'DO'),(42,'ES'),(42,'FO'),(42,'IN'),(42,'SA'),(42,'VE'),(43,'DO'),(43,'ES'),(43,'FO'),(43,'IN'),(43,'SE'),(43,'VE'),(47,'DO'),(47,'ES'),(47,'FO'),(47,'IN'),(47,'PI'),(47,'SE'),(47,'VE'),(48,'DO'),(49,'DO'),(49,'ES'),(49,'FO'),(49,'IN'),(49,'PI'),(49,'SE'),(49,'VE'),(51,'DO'),(51,'ES'),(51,'IN'),(51,'PI'),(51,'VE'),(52,'DO'),(52,'ES'),(52,'FO'),(52,'IN'),(52,'PI'),(52,'VE'),(54,'DO'),(54,'ES'),(54,'FO'),(54,'IN'),(54,'PI'),(54,'VE'),(56,'DO'),(56,'ES'),(56,'FO'),(56,'IN'),(56,'PI'),(56,'VE'),(57,'DO'),(58,'DO'),(58,'ES'),(58,'IN'),(58,'PI'),(58,'VE'),(62,'DO'),(62,'ES'),(62,'IN'),(62,'PI'),(62,'VE'),(63,'DO'),(63,'ES'),(63,'IN'),(63,'PI'),(63,'VE'),(64,'DO'),(64,'ES'),(64,'IN'),(64,'PI'),(64,'VE'),(69,'SE');
/*!40000 ALTER TABLE `circ_tipo_prestamo_sancion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circ_tipo_sancion`
--

DROP TABLE IF EXISTS `circ_tipo_sancion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circ_tipo_sancion` (
  `tipo_sancion` int(11) NOT NULL AUTO_INCREMENT,
  `categoria_socio` char(2) DEFAULT NULL,
  `tipo_prestamo` char(2) DEFAULT NULL,
  PRIMARY KEY (`tipo_sancion`),
  UNIQUE KEY `categoryissuecode` (`categoria_socio`,`tipo_prestamo`)
) ENGINE=MyISAM AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circ_tipo_sancion`
--

LOCK TABLES `circ_tipo_sancion` WRITE;
/*!40000 ALTER TABLE `circ_tipo_sancion` DISABLE KEYS */;
INSERT INTO `circ_tipo_sancion` VALUES (1,'ES','DO'),(2,'DO','DO'),(3,'DO','SA'),(4,'DO','FO'),(5,'ES','FO'),(6,'ND','FO'),(7,'ND','DO'),(8,'ND','SA'),(9,'ND','ES'),(10,'IN','ES'),(11,'EG','DO'),(12,'DO','ES'),(13,'IN','DO'),(14,'PG','DO'),(15,'ES','SA'),(16,'EG','SA'),(17,'IN','SA'),(18,'PG','SA'),(19,'ES','ES'),(20,'DO','VE'),(21,'ES','VE'),(22,'EG','VE'),(23,'EG','ES'),(24,'EG','FO'),(25,'IN','VE'),(26,'IN','FO'),(27,'ND','VE'),(28,'PG','VE'),(29,'PG','ES'),(30,'PG','FO'),(31,'ES','IN'),(32,'DO','IN'),(33,'EG','IN'),(34,'IN','IN'),(35,'ND','IN'),(36,'PG','IN'),(37,'EX','DO'),(38,'EX','VE'),(39,'EX','IN'),(40,'EX','ES'),(41,'EX','FO'),(42,'EX','SA'),(43,'IB','DO'),(44,'BI','SA'),(45,'BB','SA'),(46,'BB','IN'),(47,'BI','DO'),(48,'BI','PI'),(49,'BI','VE'),(50,'BB','DO'),(51,'ES','RE'),(52,'ND','RE'),(53,'IN','RE'),(54,'EG','RE'),(55,'EX','RE'),(56,'PG','RE'),(57,'ES','PI'),(58,'PG','PI'),(59,'PG','SE'),(60,'EX','SE'),(61,'EX','PI'),(62,'EG','PI'),(63,'BI','ES'),(64,'BI','IN'),(65,'','DO'),(66,'BB','FO'),(67,'BB','PI'),(68,'IN','PI'),(69,'ES','SE'),(70,'ES','BI'),(71,'IN','PG'),(72,'PI','ES'),(73,'PI','BI');
/*!40000 ALTER TABLE `circ_tipo_sancion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacto`
--

DROP TABLE IF EXISTS `contacto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trato` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `apellido` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `codigo_postal` varchar(255) DEFAULT NULL,
  `ciudad` varchar(255) DEFAULT NULL,
  `pais` varchar(255) DEFAULT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `asunto` varchar(255) DEFAULT NULL,
  `mensaje` text NOT NULL,
  `leido` int(11) NOT NULL DEFAULT '0',
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `respondido` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacto`
--

LOCK TABLES `contacto` WRITE;
/*!40000 ALTER TABLE `contacto` DISABLE KEYS */;
/*!40000 ALTER TABLE `contacto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `e_document`
--

DROP TABLE IF EXISTS `e_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `e_document` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `id2` int(11) NOT NULL,
  `file_type` varchar(64) NOT NULL DEFAULT 'pdf',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `e_document`
--

LOCK TABLES `e_document` WRITE;
/*!40000 ALTER TABLE `e_document` DISABLE KEYS */;
/*!40000 ALTER TABLE `e_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imagenes_novedades_opac`
--

DROP TABLE IF EXISTS `imagenes_novedades_opac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imagenes_novedades_opac` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `image_name` varchar(255) CHARACTER SET latin1 NOT NULL,
  `id_novedad` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `image_name` (`image_name`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imagenes_novedades_opac`
--

LOCK TABLES `imagenes_novedades_opac` WRITE;
/*!40000 ALTER TABLE `imagenes_novedades_opac` DISABLE KEYS */;
INSERT INTO `imagenes_novedades_opac` VALUES (4,'f9f6f4b62ec40fc1a0933ef94c8fb3c0.jpeg',5);
/*!40000 ALTER TABLE `imagenes_novedades_opac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `indice_busqueda`
--

DROP TABLE IF EXISTS `indice_busqueda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `indice_busqueda` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` text,
  `autor` text,
  `string` text NOT NULL,
  `marc_record` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `hits` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `string` (`string`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `indice_busqueda`
--

LOCK TABLES `indice_busqueda` WRITE;
/*!40000 ALTER TABLE `indice_busqueda` DISABLE KEYS */;
/*!40000 ALTER TABLE `indice_busqueda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `io_importacion_iso`
--

DROP TABLE IF EXISTS `io_importacion_iso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `io_importacion_iso` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_importacion_esquema` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `archivo` varchar(255) DEFAULT NULL,
  `formato` varchar(255) NOT NULL,
  `comentario` varchar(255) DEFAULT NULL,
  `estado` char(1) DEFAULT NULL,
  `fecha_upload` varchar(20) NOT NULL,
  `fecha_import` varchar(20) DEFAULT NULL,
  `campo_identificacion` varchar(255) DEFAULT NULL,
  `campo_relacion` varchar(255) DEFAULT NULL,
  `cant_registros_n1` int(11) DEFAULT NULL,
  `cant_registros_n2` int(11) DEFAULT NULL,
  `cant_registros_n3` int(11) DEFAULT NULL,
  `cant_desconocidos` int(11) NOT NULL,
  `accion_general` varchar(255) DEFAULT NULL,
  `accion_sinmatcheo` varchar(255) DEFAULT NULL,
  `accion_item` varchar(255) DEFAULT NULL,
  `accion_barcode` varchar(255) DEFAULT NULL,
  `reglas_matcheo` mediumtext,
  `jobID` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `io_importacion_iso`
--

LOCK TABLES `io_importacion_iso` WRITE;
/*!40000 ALTER TABLE `io_importacion_iso` DISABLE KEYS */;
/*!40000 ALTER TABLE `io_importacion_iso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `io_importacion_iso_esquema`
--

DROP TABLE IF EXISTS `io_importacion_iso_esquema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `io_importacion_iso_esquema` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `io_importacion_iso_esquema`
--

LOCK TABLES `io_importacion_iso_esquema` WRITE;
/*!40000 ALTER TABLE `io_importacion_iso_esquema` DISABLE KEYS */;
/*!40000 ALTER TABLE `io_importacion_iso_esquema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `io_importacion_iso_esquema_detalle`
--

DROP TABLE IF EXISTS `io_importacion_iso_esquema_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `io_importacion_iso_esquema_detalle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_importacion_esquema` int(11) NOT NULL,
  `campo_origen` char(3) NOT NULL,
  `subcampo_origen` char(1) NOT NULL,
  `campo_destino` char(3) CHARACTER SET latin1 DEFAULT NULL,
  `subcampo_destino` char(1) CHARACTER SET latin1 DEFAULT NULL,
  `nivel` int(11) DEFAULT NULL,
  `ignorar` int(11) NOT NULL DEFAULT '0',
  `orden` int(11) DEFAULT '0',
  `separador` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `campo_origen` (`campo_origen`,`id_importacion_esquema`,`subcampo_origen`,`campo_destino`,`subcampo_destino`,`orden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `io_importacion_iso_esquema_detalle`
--

LOCK TABLES `io_importacion_iso_esquema_detalle` WRITE;
/*!40000 ALTER TABLE `io_importacion_iso_esquema_detalle` DISABLE KEYS */;
/*!40000 ALTER TABLE `io_importacion_iso_esquema_detalle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `io_importacion_iso_registro`
--

DROP TABLE IF EXISTS `io_importacion_iso_registro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `io_importacion_iso_registro` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_importacion_iso` int(11) NOT NULL,
  `type` varchar(25) DEFAULT NULL,
  `estado` varchar(25) DEFAULT NULL,
  `detalle` text,
  `matching` varchar(255) DEFAULT '0',
  `id_matching` int(11) DEFAULT NULL,
  `identificacion` varchar(255) DEFAULT NULL,
  `relacion` varchar(255) DEFAULT NULL,
  `id1` int(11) DEFAULT NULL,
  `id2` int(11) DEFAULT NULL,
  `id3` int(11) DEFAULT NULL,
  `marc_record` mediumtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `io_importacion_iso_registro`
--

LOCK TABLES `io_importacion_iso_registro` WRITE;
/*!40000 ALTER TABLE `io_importacion_iso_registro` DISABLE KEYS */;
/*!40000 ALTER TABLE `io_importacion_iso_registro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logoEtiquetas`
--

DROP TABLE IF EXISTS `logoEtiquetas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logoEtiquetas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(256) CHARACTER SET latin1 NOT NULL,
  `imagenPath` varchar(255) CHARACTER SET latin1 NOT NULL,
  `ancho` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `alto` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logoEtiquetas`
--

LOCK TABLES `logoEtiquetas` WRITE;
/*!40000 ALTER TABLE `logoEtiquetas` DISABLE KEYS */;
/*!40000 ALTER TABLE `logoEtiquetas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logoUI`
--

DROP TABLE IF EXISTS `logoUI`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logoUI` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(256) CHARACTER SET latin1 NOT NULL,
  `imagenPath` varchar(255) CHARACTER SET latin1 NOT NULL,
  `ancho` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `alto` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logoUI`
--

LOCK TABLES `logoUI` WRITE;
/*!40000 ALTER TABLE `logoUI` DISABLE KEYS */;
INSERT INTO `logoUI` VALUES (2,'MERA-UI','MERA-UI.png',NULL,NULL);
/*!40000 ALTER TABLE `logoUI` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perm_catalogo`
--

DROP TABLE IF EXISTS `perm_catalogo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `perm_catalogo` (
  `ui` varchar(4) DEFAULT NULL,
  `tipo_documento` varchar(4) DEFAULT NULL,
  `datos_nivel1` varbinary(8) NOT NULL DEFAULT '00000',
  `datos_nivel2` varbinary(8) NOT NULL DEFAULT '00000',
  `datos_nivel3` varbinary(8) NOT NULL DEFAULT '00000',
  `estantes_virtuales` varbinary(8) NOT NULL DEFAULT '00000',
  `estructura_catalogacion_n1` varbinary(8) NOT NULL DEFAULT '00000',
  `estructura_catalogacion_n2` varbinary(8) NOT NULL DEFAULT '00000',
  `estructura_catalogacion_n3` varbinary(8) NOT NULL DEFAULT '00000',
  `tablas_de_refencia` varbinary(8) NOT NULL DEFAULT '00000',
  `control_de_autoridades` varbinary(8) NOT NULL DEFAULT '00000',
  `usuarios` varchar(8) DEFAULT NULL,
  `sistema` varchar(8) DEFAULT NULL,
  `undefined` varchar(8) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_persona` int(11) unsigned NOT NULL,
  `nro_socio` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_persona` (`ui`,`tipo_documento`,`nro_socio`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perm_catalogo`
--

LOCK TABLES `perm_catalogo` WRITE;
/*!40000 ALTER TABLE `perm_catalogo` DISABLE KEYS */;
INSERT INTO `perm_catalogo` VALUES ('MERA','ALL','00010000','00010000','00010000','00010000','00010000','00010000','00010000','00010000','00010000','00010000','00010000','00010000',1,167908,'meranadmin'),('MERA','ALL','00000001','00000001','00000001','00000001','00000001','00000001','00000001','00000001','00000001','00000001','00000001','00000001',2,0,'test'),('MERA','ALL','00000001','00000001','00000001','00000001','00000001','00000001','00000001','00000001','00000001','00000001','00000001','00000001',3,0,'888888');
/*!40000 ALTER TABLE `perm_catalogo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perm_circulacion`
--

DROP TABLE IF EXISTS `perm_circulacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `perm_circulacion` (
  `nro_socio` varchar(16) NOT NULL DEFAULT '',
  `ui` varchar(4) NOT NULL DEFAULT '',
  `tipo_documento` varchar(4) NOT NULL DEFAULT '',
  `catalogo` varbinary(8) NOT NULL,
  `prestamos` varbinary(8) NOT NULL,
  `circ_opac` varbinary(8) NOT NULL DEFAULT '00000000',
  `circ_prestar` varchar(8) NOT NULL,
  `circ_renovar` varchar(8) NOT NULL,
  `circ_sanciones` varchar(8) NOT NULL,
  `circ_devolver` varchar(8) NOT NULL,
  PRIMARY KEY (`nro_socio`,`ui`,`tipo_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perm_circulacion`
--

LOCK TABLES `perm_circulacion` WRITE;
/*!40000 ALTER TABLE `perm_circulacion` DISABLE KEYS */;
INSERT INTO `perm_circulacion` VALUES ('888888','MERA','ALL','','00000001','00000001','00000001','00000001','00000001','00000001'),('meranadmin','MERA','ALL','','00010000','00010000','00010000','00010000','00010000','00010000'),('test','MERA','ALL','','00000001','00000001','00000001','00000001','00000001','00000001');
/*!40000 ALTER TABLE `perm_circulacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perm_general`
--

DROP TABLE IF EXISTS `perm_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `perm_general` (
  `nro_socio` varchar(16) NOT NULL DEFAULT '',
  `ui` varchar(4) NOT NULL DEFAULT '',
  `tipo_documento` varchar(4) NOT NULL DEFAULT '',
  `preferencias` varbinary(8) NOT NULL,
  `reportes` varbinary(8) NOT NULL DEFAULT '00000000',
  `permisos` varbinary(8) NOT NULL DEFAULT '00000000',
  `adq_opac` varbinary(8) NOT NULL DEFAULT '00000000',
  `adq_intra` varbinary(8) NOT NULL DEFAULT '00000000',
  PRIMARY KEY (`nro_socio`,`ui`,`tipo_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perm_general`
--

LOCK TABLES `perm_general` WRITE;
/*!40000 ALTER TABLE `perm_general` DISABLE KEYS */;
INSERT INTO `perm_general` VALUES ('888888','MERA','ALL','00000001','00000001','00000001','00000001','00000001'),('meranadmin','MERA','ALL','00010000','00010000','00010000','00010000','00010000'),('test','MERA','ALL','00000001','00000001','00000001','00000001','00000001');
/*!40000 ALTER TABLE `perm_general` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `portada_opac`
--

DROP TABLE IF EXISTS `portada_opac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `portada_opac` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `image_path` varchar(255) NOT NULL,
  `footer` text,
  `footer_title` varchar(64) DEFAULT NULL,
  `orden` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portada_opac`
--

LOCK TABLES `portada_opac` WRITE;
/*!40000 ALTER TABLE `portada_opac` DISABLE KEYS */;
INSERT INTO `portada_opac` VALUES (11,'aa50034975b912ac5449f3f2a8de6e74.png','Esta imágen es una demostración. Es recomendable cambiarla al activar el sitio','Un nuevo enfoque en la gestión bibliotecaria',1),(12,'3df998026f8b0045e67bc3e1b30bcd63.png','ivida sus ejemplares por estantes virtuales, reflejando la Biblioteca física, u organizando por temas su colección','La eficiencia de la división',2),(13,'4d1cd120e9ff071e5ca4d03b91941d7f.png','Con Meran, organizar el catálogo es sólo una secuencia de pasos','Cuando la organización lo es todo',3);
/*!40000 ALTER TABLE `portada_opac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_about`
--

DROP TABLE IF EXISTS `pref_about`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_about` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_about`
--

LOCK TABLES `pref_about` WRITE;
/*!40000 ALTER TABLE `pref_about` DISABLE KEYS */;
INSERT INTO `pref_about` VALUES (1,'Biblioteca de Prueba - Meran - CeSPI - UNLP');
/*!40000 ALTER TABLE `pref_about` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_estructura_campo_marc`
--

DROP TABLE IF EXISTS `pref_estructura_campo_marc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_estructura_campo_marc` (
  `campo` char(3) NOT NULL DEFAULT '',
  `liblibrarian` char(255) DEFAULT NULL,
  `libopac` char(255) DEFAULT NULL,
  `repeatable` tinyint(4) NOT NULL DEFAULT '0',
  `mandatory` tinyint(4) NOT NULL DEFAULT '0',
  `descripcion` varchar(255) DEFAULT NULL,
  `indicador_primario` varchar(255) DEFAULT NULL,
  `indicador_secundario` varchar(255) DEFAULT NULL,
  `nivel` int(11) NOT NULL,
  PRIMARY KEY (`campo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_estructura_campo_marc`
--

LOCK TABLES `pref_estructura_campo_marc` WRITE;
/*!40000 ALTER TABLE `pref_estructura_campo_marc` DISABLE KEYS */;
INSERT INTO `pref_estructura_campo_marc` VALUES ('010','NÚMERO DE CONTROL DE LA BIBLIOTECA DEL CONGRESO (NR)','NÚMERO DE CONTROL DE LA BIBLIOTECA DEL CONGRESO (NR)',0,0,'Unique number assigned to a MARC record by the Library of Congress. Valid MARC prefixes for LC control numbers are published in <em>MARC 21 Format for Bibliographic Data</em>. \n The control number for MARC records distributed by LC is an LC control number','No definido','No definido',0),('011','NÚMERO DE CONTROL VINCULANTE DE LA BIBLIOTECA DEL CONGRESO (NR) [OBSOLETE]','NÚMERO DE CONTROL VINCULANTE DE LA BIBLIOTECA DEL CONGRESO (NR) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('013','INFORMACIÓN DE CONTROL DE PATENTES (R)','INFORMACIÓN DE CONTROL DE PATENTES (R)',1,0,'Information used to control patent documents. In addition to information about patents, this field may contain information relating to inventors\' certificates, utility certificates, utility models, patents or certificates of addition, inventors\' certifica','No definido','No definido',0),('015','NÚMERO DE LA BIBLIOGRAFÍA NACIONAL (R)','NÚMERO DE LA BIBLIOGRAFÍA NACIONAL (R)',1,0,'Bibliography entry number(s) for cataloging information that is derived from a national bibliography. \n When cataloging information is derived from an entry in a foreign national bibliography, the number of the entry is given in the record. A work may hav','No definido','No definido',0),('016','NÚMERO DE CONTROL DE LA AGENCIA NACIONAL BIBLIOGRÁFICA (R)','NÚMERO DE CONTROL DE LA AGENCIA NACIONAL BIBLIOGRÁFICA (R)',1,0,'Unique numbers that have been assigned to a record by a national bibliographic agency other than the Library of Congress. The control number may also appear in field 001 (Control Number) in records distributed by the same national agency. This number is a','Agencia nacional bibliográfica','No definido',0),('017','NÚMERO DE DEPÓSITO LEGAL O DERECHOS DE AUTOR (R)','NÚMERO DE DEPÓSITO LEGAL O DERECHOS DE AUTOR (R)',1,0,'Copyright registration or legal deposit number for an item that was acquired by copyright or legal deposit.\n Agency assigning the number is always given with the copyright or legal deposit number.\n Field is repeated when more than one agency has assigned ','No definido','Controlador de la constante de despliegue',0),('018','ARTÍCULO REGISTRADO-CÓDIGO DE PAGO (NR)','ARTÍCULO REGISTRADO-CÓDIGO DE PAGO (NR)',0,0,'Unique identification code for component parts appearing in monographs or continuing resources.\n Recorded in the record for the component part, not in the record for the host item.\n','No definido','No definido',0),('020','NÚMERO INTERNACIONAL NORMALIZADO PARA LIBROS (ISBN) (R)','NÚMERO INTERNACIONAL NORMALIZADO PARA LIBROS (ISBN) (R)',1,0,'International Standard Book Number (ISBN) assigned to a monographic publication by designated agencies in each country participating in the program. The field may include terms of availability and canceled or invalid ISBNs, such as ISBNs with invalid chec','No definido','No definido',0),('022','NÚMERO INTERNACIONAL NORMALIZADO PARA PUBLICACIONES SERIADAS (ISSN) (R)','NÚMERO INTERNACIONAL NORMALIZADO PARA PUBLICACIONES SERIADAS (ISSN) (R)',1,0,'International Standard Serial Number (ISSN), a unique identification number assigned to a continuing resource, and/or any incorrect or canceled ISSN. \n','Nivel de interés internacional','No definido',0),('023','STANDARD FILM NUMBER   [DELETED]','STANDARD FILM NUMBER   [DELETED]',1,0,'','','',0),('024','OTROS IDENTIFICADORES NORMALIZADOS (R)','OTROS IDENTIFICADORES NORMALIZADOS (R)',1,0,'','Tipo de número o código estandarizado','Designación de diferencia',0),('025','NÚMERO DE ADQUISICIÓN EN EL EXTRANJERO (R)','NÚMERO DE ADQUISICIÓN EN EL EXTRANJERO (R)',1,0,'Number assigned by the Library of Congress to works acquired through one of its overseas acquisition programs. \n Used to record the acquisition source of the item and also identifies certain programs under which materials are acquired at LC. The following','No definido','No definido',0),('027','NÚMERO NORMALIZADO DE INFORME TÉCNICO (R)','NÚMERO NORMALIZADO DE INFORME TÉCNICO (R)',1,0,'International Standard Technical Report number (ISRN) or a Standard Technical Report Number (STRN)assigned to a technical report. Assignment of STRNs is coordinated by the National Technical Information Service (NTIS), which also maintains an assignment r','No definido','No definido',0),('028','NÚMERO DE EDITOR (R)','NÚMERO DE EDITOR (R)',1,0,'','Tipo de número del editor','Nota/controlador de asiento adicional del título',0),('030','INDICADOR CODEN (R)','INDICADOR CODEN (R)',1,0,'CODEN designation for a bibliographic title. The CODEN is assigned by the International CODEN Section of Chemical Abstracts Service. \n CODEN is a unique identifier for scientific and technical periodical titles; it consists of six characters. \n','No definido','No definido',0),('032','NÚMERO DE REGISTRO POSTAL (R)','NÚMERO DE REGISTRO POSTAL (R)',1,0,'Number assigned to a publication for which the specified postal service permits the use of a special mailing class privilege. \n Postal service registration numbers are required in some countries for certain mailing class privileges. \n In the United States','No definido','No definido',0),('033','FECHA/HORA Y LUGAR DE UN EVENTO (R)','FECHA/HORA Y LUGAR DE UN EVENTO (R)',1,0,'Formatted date/time and/or coded place of creation, capture, recording, filming, execution, or broadcast associated with an event or the finding of a naturally occurring object. This information in textual form is contained in field 518 (Date/Time and Pla','Tipo de fecha en el subcampo $a','Tipo de eventos',0),('034','DATOS MATEMÁTICOS CARTOGRÁFICOS CODIFICADOS (R)','DATOS MATEMÁTICOS CARTOGRÁFICOS CODIFICADOS (R)',1,0,'','Tipos de escala','Tipo de anillo',0),('035','NÚMERO DE CONTROL DEL SISTEMA (R)','NÚMERO DE CONTROL DEL SISTEMA (R)',1,0,'Control number of a system other than the one whose control number is contained in field 001 (Control Number), field 010 (Library of Congress Control Number) or field 016 (National Bibliographic Agency Control Number). \n For interchange purposes, document','No definido','No definido',0),('036','NÚMERO DE ESTUDIO ORIGINAL PARA LOS ARCHIVOS DE DATOS (NR)','NÚMERO DE ESTUDIO ORIGINAL PARA LOS ARCHIVOS DE DATOS (NR)',0,0,'Original study number assigned by the producer of the computer file. Introductory phrase <em>Original study:</em> may be generated based on the field tag. \n This is an identification number for a data file, often assigned when the file was created and pos','No definido','No definido',0),('037','FUENTE DE ADQUISICIÓN (R)','FUENTE DE ADQUISICIÓN (R)',1,0,'Source of acquisition information for the item or its reproduction.\n If a stock number is present (subfield $a), source of stock number/acquisition information (subfield $b) is required. \n Government agency assigned numbers that can be used for classifica','No definido','No definido',0),('039','LEVEL OF biblioGRAPHIC CONTROL AND CODING DETAIL [OBSOLETE]','LEVEL OF biblioGRAPHIC CONTROL AND CODING DETAIL [OBSOLETE]',1,0,'','','',0),('040','FUENTE DE CATALOGACIÓN (NR)','FUENTE DE CATALOGACIÓN (NR)',0,0,'MARC code for or the name of the organization(s) that created the original bibliographic record, assigned MARC content designation and transcribed the record into machine-readable form, or modified (except for the addition of holdings symbols) an existing','No definido','No definido',0),('041','CÓDIGO DE IDIOMA (R)','CÓDIGO DE IDIOMA (R)',1,0,'','Indicador de traducción','Fuente del código',0),('042','CÓDIGO DE AUTENTICACIÓN (NR)','CÓDIGO DE AUTENTICACIÓN (NR)',0,0,'One or more authentication codes indicating that the record, existing in a national database, has been reviewed in a specific way. Used for codes associated with specifically designated authentication agencies. Code from: <em><a href=\"http://www.loc.gov/s','No definido','No definido',0),('043','CÓDIGO DE ÁREA GEOGRÁFICA (NR)','CÓDIGO DE ÁREA GEOGRÁFICA (NR)',0,0,'','No definido','No definido',0),('044','CÓDIGO DE ENTIDAD DEL PAÍS DE PUBLICACIÓN/PRODUCCIÓN (NR)','CÓDIGO DE ENTIDAD DEL PAÍS DE PUBLICACIÓN/PRODUCCIÓN (NR)',0,0,'Two- or three-character code for the country of the publishing or producing entity when field 008/15-17 (Place of publication, production, or execution) is insufficient to convey full information for an item published or produced in more than one country.','No definido','No definido',0),('045','PERÍODO CRONOLÓGICO DEL CONTENIDO (NR)','PERÍODO CRONOLÓGICO DEL CONTENIDO (NR)',0,0,'Time period code (subfield $a) and/or a formatted time period (subfield $b and/or $c) associated with an item. \n Time period code in subfield $a is derived from the B.C. (Before Common Era) and/or C.E. (Common Era) lists in the Time Period Code Table prov','Tipo de período cronológico en los subcampos $b o $c','No definido',0),('046','CÓDIGO ESPECIAL DE FECHAS (R)','CÓDIGO ESPECIAL DE FECHAS (R)',1,0,'Date of item information that cannot be recorded in 008/06-14 (Type of date/Publication status, Date 1, Date 2) because such information involves one or more Before Common Era (B.C.) dates, incorrect dates, dates when resources have been modified or creat','No definido','No definido',0),('047','CÓDIGO DE FORMA DE LA COMPOSICIÓN MUSICAL (R)','CÓDIGO DE FORMA DE LA COMPOSICIÓN MUSICAL (R)',1,0,'Codes that indicate the form of musical composition of printed and manuscript music and musical sound recordings when character positions 18 and 19 (Form of composition) of field 008 (Fixed-Length Data Elements) for music contains the code <em>mu</em> for','No definido','Fuente del código',0),('048','NÚMERO DE INSTRUMENTOS MUSICALES O CÓDIGO DE VOCES (R)','NÚMERO DE INSTRUMENTOS MUSICALES O CÓDIGO DE VOCES (R)',1,0,'Two-character code that indicates the medium of performance for a musical composition. Also contains the <em>number</em> of parts, indicated by a two-digit number immediately following the code for the musical instruments or voices (e.g., va02, a two-part','No definido','Fuente del código',0),('050','NÚMERO DE UBICACIÓN EN LA BIBLIOTECA DEL CONGRESO (R)','NÚMERO DE UBICACIÓN EN LA BIBLIOTECA DEL CONGRESO (R)',1,0,'Classification or call number that is taken from <em>Library of Congress Classification</em> or <em>LC Classification Additions and Changes</em>. The brackets that customarily surround alternate class/call numbers are not carried in the MARC record; they ','Existencia en la LC','Fuente del número de ubicación',0),('051','MENCIÓN DE LA BIBLIOTECA DEL CONGRESO SOBRE COPIAS, EDICIONES Y SEPARATAS (R)','MENCIÓN DE LA BIBLIOTECA DEL CONGRESO SOBRE COPIAS, EDICIONES Y SEPARATAS (R)',1,0,'Information added to a bibliographic record by the Library of Congress that relates to copies, issues, and/or offprints, etc. of the described material that are in its collections. \n Used only for such information assigned by the Library of Congress. The ','No definido','No definido',0),('052','CLASIFICACIÓN GEOGRÁFICA (R)','CLASIFICACIÓN GEOGRÁFICA (R)',1,0,'Geographic classification code that represents the geographic area and, if applicable, the geographic subarea and populated place name covered by an item. \n Code can provide more precise geographic access than the codes contained in field 043 (Geographic ','Fuente del código','No definido',0),('055','NÚMEROS DE CLASIFICACIÓN ASIGNADOS EN CANADÁ (R)','NÚMEROS DE CLASIFICACIÓN ASIGNADOS EN CANADÁ (R)',1,0,'Complete call number or a classification number assigned by Library and Archives Canada (LAC) or a library contributing to LAC. \n Excludes those numbers assigned from the National Library of Medicine classification system, the Universal Decimal Classifica','Existe en la colección de la LAC','Tipo, integridad, fuente del número de ubicación/clase',0),('060','NÚMERO DE UBICACIÓN EN LA BIBLIOTECA NACIONAL DE MEDICINA (R)','NÚMERO DE UBICACIÓN EN LA BIBLIOTECA NACIONAL DE MEDICINA (R)',1,0,'Either a complete National Library of Medicine (NLM) call number or classification number assigned by either the National Library of Medicine or by other agencies using the <em>National Library of Medicine Classification</em>. The second indicator values ','Existencia en la NML','Fuente del número de ubicación',0),('061','MENCIÓN SOBRE COPIAS DE LA BIBLIOTECA NACIONAL DE MEDICINA (R)','MENCIÓN SOBRE COPIAS DE LA BIBLIOTECA NACIONAL DE MEDICINA (R)',1,0,'Information added to a bibliographic record by the National Library of Medicine that relates to second copies or sets of the described item that are in its collections. \n Used only for class numbers and call numbers relating to second copies and sets assi','No definido','No definido',0),('066','CONJUNTO DE CARACTERES PRESENTES (NR)','CONJUNTO DE CARACTERES PRESENTES (NR)',0,0,'Information that indicates that the records were encoded with characters from sets other than ISO 10646 (or Unicode). A detailed description of the standard escape sequences used in MARC records is provided in <em><a href=\"http://www.loc.gov/marc/specific','No definido','No definido',0),('070','NÚMERO DE UBICACIÓN DE LA Biblioteca Nacional de Agricultura de los Estados Unidos (R)','NÚMERO DE UBICACIÓN DE LA Biblioteca Nacional de Agricultura de los Estados Unidos (R)',1,0,'Classification or call number that is assigned by the National Agricultural Library (NAL). \n May also contain NAL accession numbers for visual materials.\n Prior to 1965, NAL used a USDA library classification scheme. In 1965, NAL began using the <em>Libra','Existencia en la colección NAL','No definido',0),('071','MENCIÓN SOBRE COPIAS DE LA Biblioteca Nacional de Agricultura de los Estados Unidos (R)','MENCIÓN SOBRE COPIAS DE LA Biblioteca Nacional de Agricultura de los Estados Unidos (R)',1,0,'Call number and other information added to a bibliographic record by the National Agricultural Library (NAL) that relates to second copies or sets of the described item that are in its collections. \n','No definido','No definido',0),('072','CÓDIGO DE CATEGORIA TEMÁTICA (R)','CÓDIGO DE CATEGORIA TEMÁTICA (R)',1,0,'Code for the subject category that is associated with the described item.\n Repeated for multiple subject category codes.\n','No definido','Fuente especificada en el subcampo $2',0),('074','NÚMERO DE ÍTEM DE GPO (R)','NÚMERO DE ÍTEM DE GPO (R)',1,0,'Item number assigned to publications by the U.S. Government Printing Office (GPO) to manage their distribution to libraries within its Depository Library System. Numbers are assigned from the <em>List of Classes of United States Government Publications Av','No definido','No definido',0),('080','NÚMERO DE CLASIFICACIÓN DECIMAL UNIVERSAL (R)','NÚMERO DE CLASIFICACIÓN DECIMAL UNIVERSAL (R)',1,0,'Number taken from the Universal Decimal Classification scheme.\n','Tipo de edición','No definido',0),('082','NÚMERO DE CLASIFICACIÓN DECIMAL DEWEY (R)','NÚMERO DE CLASIFICACIÓN DECIMAL DEWEY (R)',1,0,'','Tipo de edición','Fuente del número',0),('084','OTRO NÚMERO DE CLASIFICACIÓN (R)','OTRO NÚMERO DE CLASIFICACIÓN (R)',1,0,'','No definido','No definido',0),('086','NÚMERO DE CLASIFICACION PARA DOCUMENTOS GUBERNAMENTALES (R)','NÚMERO DE CLASIFICACION PARA DOCUMENTOS GUBERNAMENTALES (R)',1,0,'Classification number assigned to documents by designated agencies in countries that have a government documents classification program. \n Government agency may be at any level (e.g., provincial, state, national, international). If a number can be charact','Fuente del número','No definido',0),('088','NÚMERO DE REPORTE (R)','NÚMERO DE REPORTE (R)',1,0,'Report number that is not a Standard Technical Report Number (STRN), recorded in field 027. \n Not used to record a number associated with a series statement. Field 088 is repeated for multiple report numbers, except when one number is the canceled or inva','No definido','No definido',0),('090','UBICACIÓN EN ESTANTE (AM)[OBSOLETE]','UBICACIÓN EN ESTANTE (AM)[OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('091','MICROFILM SHELF LOCATION (AM) [OBSOLETE]','MICROFILM SHELF LOCATION (AM) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('100','ASIENTO PRINCIPAL - NOMBRE PERSONAL (NR)','ASIENTO PRINCIPAL - NOMBRE PERSONAL (NR)',0,0,'Personal name used as a main entry in a bibliographic record.\n Main entry is assigned according to various cataloging rules, usually to the person chiefly responsible for the work. \n','Tipo de nombre personal como asiento principal','No definido',0),('110','ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)','ASIENTO PRINCIPAL - AUTOR CORPORATIVO (NR)',0,0,'Corporate name used as a main entry in a bibliographic record.\n According to various cataloging rules, main entry under corporate name is assigned to works that represent the collective thought of a body. \n Conference and meeting names that are entered su','Tipo del nombre del autor corporativo como asiento principal','No definido',0),('111','ASIENTO PRINCIPAL - NOMBRE DE LA REUNIÓN (NR)','ASIENTO PRINCIPAL - NOMBRE DE LA REUNIÓN (NR)',0,0,'Meeting or conference name used as a main entry in a bibliographic record.\n According to various cataloging rules, main entry under a meeting name is assigned to works that contain proceedings, reports, etc. \n Meetings entered subordinately to a corporate','Tipo del nombre de la reunión como asiento principal','No definido',0),('130','ASIENTO PRINCIPAL - TÍTULO UNIFORME (NR)','ASIENTO PRINCIPAL - TÍTULO UNIFORME (NR)',0,0,'Uniform title used as a main entry in a bibliographic record.\n Main entry under a uniform title is used when a work is entered directly under title and the work has appeared under varying titles, necessitating that a particular title be chosen to represen','Caracteres que no se alfabetizan','No definido',0),('210','TÍTULO ABREVIADO - PUBLICACIÓN SERIADA (R)','TÍTULO ABREVIADO - PUBLICACIÓN SERIADA (R)',1,0,'Title as abbreviated for indexing or identification. An abbreviated <em>key</em> title is supplied by ISSN centers, based on the Key Title (Field 222). Other abbreviated titles are supplied by cataloging agencies, including abstracting and indexing servic','Asiento adicional del título','Tipo',0),('211','TÍTULO ABREVIADO O ACRÓNIMO (R) [OBSOLETE]','TÍTULO ABREVIADO O ACRÓNIMO (R) [OBSOLETE]',0,0,'OBSOLETO','Asiento adicional del título','Caracteres que no se alfabetizan',0),('212','VARIANT ACCESS Título (R) [OBSOLETE]','VARIANT ACCESS Título (R) [OBSOLETE]',0,0,'OBSOLETO','Asiento adicional del título','No definido',0),('214','AUGMENTED Título (R) [OBSOLETE]','AUGMENTED Título (R) [OBSOLETE]',0,0,'OBSOLETO','Asiento adicional del título','Caracteres que no se alfabetizan',0),('222','TÍTULO CLAVE (R)','TÍTULO CLAVE (R)',1,0,'Unique title for a continuing resource that is assigned in conjunction with an ISSN recorded in field 022 by national centers under the auspices of the ISSN Network. \n A note formatted as <em>ISSN [number] = [Key Title]</em> may be generated from data in ','No definido','Caracteres que no se alfabetizan',0),('240','TÍTULO UNIFORME (NR)','TÍTULO UNIFORME (NR)',0,0,'Uniform title for an item when the bibliographic description is entered under a main entry field that contains a personal (field 100), corporate (110), or meeting (111) name. \n Used when a work has appeared under varying titles, necessitating that a parti','Título uniforme que se imprime o despliega','Caracteres que no se alfabetizan',0),('241','ROMANIZED Título (BK AM CF MP MU VM) (NR) [OBSOLETE]','ROMANIZED Título (BK AM CF MP MU VM) (NR) [OBSOLETE]',0,0,'OBSOLETO','Asiento adicional del título','Caracteres que no se alfabetizan',0),('242','TRADUCCIÓN DEL TÍTULO POR LA AGENCIA CATALOGADORA (R)','TRADUCCIÓN DEL TÍTULO POR LA AGENCIA CATALOGADORA (R)',1,0,'Translation of the title proper that is made by the cataloging agency when the translated title does not appear as a parallel title on the item. For a note, the introductory phrase <em>Title translated:</em> may be generated based on the field tag for dis','Asiento adicional del título','Caracteres que no se alfabetizan',0),('243','TÍTULO UNIFORME COLECTIVO (NR)','TÍTULO UNIFORME COLECTIVO (NR)',0,0,'Generic title that is constructed by the cataloger to collect works by a prolific author. Brackets that customarily enclose a collective uniform title are not carried in the MARC record. They may be generated based on the field tag. \n','Título uniforme que se imprime o despliega','Caracteres que no se alfabetizan',0),('245','TÍTULO PROPIAMENTE DICHO (NR)','TÍTULO PROPIAMENTE DICHO (NR)',0,0,'Title and statement of responsibility area of the bibliographic description of a work. \n Title Statement field consists of the title proper and may also contain the general material designation (medium), remainder of title, other title information, the re','Asiento adicional del título','Caracteres que no se alfabetizan',0),('246','VARIACIONES EN EL TÍTULO O TÍTULOS PARALELOS (R)','VARIACIONES EN EL TÍTULO O TÍTULOS PARALELOS (R)',1,0,'Varying forms of the title appearing on different parts of an item or a portion of the title proper, or an alternative form of the title when the form differs substantially from the title statement in field 245 and if they contribute to the further identi','Control de la nota y el asiento adicional del título','Tipo de título',0),('247','TÍTULO ANTERIOR (R)','TÍTULO ANTERIOR (R)',1,0,'Former title proper used when one cataloging record represents several titles associated with an entity. \n For instance, under some cataloging rules (e.g., ALA rules) a serial is cataloged under the latest title, with former titles noted in the <strong>sa','Asiento adicional del título','Controlador de nota',0),('250','MENCIÓN DE EDICIÓN (NR)','MENCIÓN DE EDICIÓN (NR)',0,0,'Information relating to the edition of a work as determined by applicable cataloging rules. \n For <strong>mixed materials</strong>, field 250 is used to record statements relating to collections that contain versions of works existing in two or more versi','No definido','No definido',0),('254','MENCIÓN DE PRESENTACIÓN MUSICAL (NR)','MENCIÓN DE PRESENTACIÓN MUSICAL (NR)',0,0,'Musical presentation statement for printed or manuscript music that describes the format of the edition, which may differ from that of another edition of the same work. \n For example, a string quartet published as a score, study score, score and parts, or','No definido','No definido',0),('255','DATOS MATEMÁTICOS CARTOGRÁFICOS (R)','DATOS MATEMÁTICOS CARTOGRÁFICOS (R)',1,0,'Mathematical data associated with cartographic material, including celestial charts. This data may also be coded in field 034 (Coded Mathematical Data). \n Date recorded includes a statement of scale, statement of projection and/or a statement of bounding ','No definido','No definido',0),('256','CARACTERÍSTICAS DE ARCHIVO INFORMÁTICO (NR)','CARACTERÍSTICAS DE ARCHIVO INFORMÁTICO (NR)',0,0,'Characteristics of a computer file, such as the type of file (e.g., Computer programs), the number of records, statements, etc. (e.g., 1250 records, 5076 bytes). \n','No definido','No definido',0),('257','PAÍS DE LA ENTIDAD QUE PRODUCE (R)','PAÍS DE LA ENTIDAD QUE PRODUCE (R)',1,0,'Name or abbreviation of the name of the country(s) where the principal offices of the producing entity(s) of a resource are located.\n Entity(s) in this instance is the production company(s) or individual that is named in the statement of responsibility (s','No definido','No definido',0),('260','PUBLICACIÓN, DISTRIBUCIÓN, ETC. (PIE DE IMPRENTA) (R)','PUBLICACIÓN, DISTRIBUCIÓN, ETC. (PIE DE IMPRENTA) (R)',1,0,'','Secuencia de declaraciones de publicación','No definido',0),('261','MENCIÓN DE PIE DE IMPRENTA PARA PELÍCULAS (Pre-AACR 1 Revised) (NR) [LOCAL]','MENCIÓN DE PIE DE IMPRENTA PARA PELÍCULAS (Pre-AACR 1 Revised) (NR) [LOCAL]',0,0,'Used in the United States to support retrospective conversion of Pre-AACR 1 (revised) cataloging records. It was made obsolete in CAN/MARC in 1988. This field contains imprint information, including the statement of production and release for projected me','No definido','No definido',0),('262','MENCIÓN DE PIE DE IMPRENTA PARA GRABACIONES DE SONIDO (Pre-AACR 2) (NR) [LOCAL]','MENCIÓN DE PIE DE IMPRENTA PARA GRABACIONES DE SONIDO (Pre-AACR 2) (NR) [LOCAL]',0,0,'Used in the United States to support retrospective conversion of Pre-AACR 2 cataloging records. It was never defined in CAN/MARC. This field contains imprint information for sound recordings. It is used only for cataloging of sound recordings created prio','No definido','No definido',0),('263','FECHA DE PUBLICACIÓN ESTIMADA (NR)','FECHA DE PUBLICACIÓN ESTIMADA (NR)',0,0,'Projected date of publication used in bibliographic records for works that have not yet been published. \n When field 263 is present, Leader/17 (Encoding level) contains value 8 (Prepublication level). Used for works that have not yet been published but wh','No definido','No definido',0),('265','SOURCE FOR ACQUISITION/SUBSCRIPTION ADDRESS (NR) [OBSOLETE]','SOURCE FOR ACQUISITION/SUBSCRIPTION ADDRESS (NR) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('270','DIRECCIÓN (R)','DIRECCIÓN (R)',1,0,'An address (as well as electronic access information such as email, telephone, fax, TTY, etc. numbers) for contacts related to the content of the bibliographic item. Multiple addresses, such as mailing addresses and addresses corresponding to the physical','Nivel','Tipo de dirección',0),('300','DESCRIPCIÓN FÍSICA (R)','DESCRIPCIÓN FÍSICA (R)',1,0,'Physical description of the described item, including its extent, dimensions, and such other physical details as a description of any accompanying materials and unit type and size. \n','No definido','No definido',0),('301','PHYSICAL DESCRIPTION FOR FILMS (PRE-AACR 2) (VM) [OBSOLETE]','PHYSICAL DESCRIPTION FOR FILMS (PRE-AACR 2) (VM) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('302','PAGE OR ITEM COUNT (BK AM) [OBSOLETE]','PAGE OR ITEM COUNT (BK AM) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('303','UNIT COUNT (AM) [OBSOLETE]','UNIT COUNT (AM) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('304','LINEAR FOOTAGE (AM) [OBSOLETE]','LINEAR FOOTAGE (AM) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('305','PHYSICAL DESCRIPTION FOR SOUND RECORDINGS (Pre-AACR 2) (MU) [OBSOLETE]','PHYSICAL DESCRIPTION FOR SOUND RECORDINGS (Pre-AACR 2) (MU) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('306','DURACIÓN (NR)','DURACIÓN (NR)',0,0,'Six numeric characters, in the pattern <em>hhmmss,</em> that represent the playing time for a sound recording, videorecording, etc. or the stated duration of performance of printed or manuscript music. If the playing time is less than 1 hour, the hour <em','No definido','No definido',0),('307','HORAS, ETC. (R)','HORAS, ETC. (R)',1,0,'Chronological information identifying the days and/or times an item is available or accessible. Used primarily in records for electronic resources. \n When displayed or printed as a note, hours, etc. information is in some instances preceded by an introduc','Controlador de la constante de despliegue','No definido',0),('308','PHYSICAL DESCRIPTION FOR FILMS (ARCHIVAL) (VM) [OBSOLETE]','PHYSICAL DESCRIPTION FOR FILMS (ARCHIVAL) (VM) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('310','FRECUENCIA ACTUAL DE LA PUBLICACIÓN (NR)','FRECUENCIA ACTUAL DE LA PUBLICACIÓN (NR)',0,0,'Current stated publication frequency of either an item or an update to an item. Dates are included when the beginning date of the current frequency is not the same as the beginning date of publication. \n In records having field 008 (Fixed-Length Data Elem','No definido','No definido',0),('315','FREQUENCY (NR) (CF MP) [OBSOLETE]','FREQUENCY (NR) (CF MP) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('321','FRECUENCIA ANTERIOR DE PUBLICACIÓN (R)','FRECUENCIA ANTERIOR DE PUBLICACIÓN (R)',1,0,'Former publication frequency of either an item or an update to an item when a current publication frequency is given in field 310 (Current Publication Frequency). \n','No definido','No definido',0),('340','MEDIO FÍSICO (R)','MEDIO FÍSICO (R)',1,0,'','No definido','No definido',0),('342','DATOS DE REFERENCIA GEOESPACIAL (R)','DATOS DE REFERENCIA GEOESPACIAL (R)',1,0,'Description of the frame of reference for the coordinates in a data set. To work with a data set a user must be able to identify how location accuracy has been affected through the application of a geospatial reference method, thus enabling the user to ma','Dimensión de referencia geoespacial','Método de referencia geoespacial',0),('343','DATOS DE COORDENADAS DEL PLANO (R)','DATOS DE COORDENADAS DEL PLANO (R)',1,0,'Information about the coordinate system developed on a planar surface. The information is provided to allow the user of a geospatial data set to identify the quantities of distances, or distances and angles. These define the position of a point on a refer','No definido','No definido',0),('350','PRICE (NR) (BK AM CF MU VM SE) [OBSOLETE]','PRICE (NR) (BK AM CF MU VM SE) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('351','ORGANIZACIÓN Y ARREGLO DE LOS MATERIALES (R)','ORGANIZACIÓN Y ARREGLO DE LOS MATERIALES (R)',1,0,'Information about the organization and arrangement of a collection of items.\n For instance, for computer files, organization and arrangement information may be the file structure and sort sequence of a file; for visual materials, this information may be h','No definido','No definido',0),('352','REPRESENTACIÓN GRÁFICA DIGITAL (R)','REPRESENTACIÓN GRÁFICA DIGITAL (R)',1,0,'Description of the method of referencing and the mechanism used to represent graphic information in a data set. This information consists of the type of storage technique used, the number of items in the data set, and the format in which the data is store','No definido','No definido',0),('355','CONTROL DE CLASIFICACIÓN DE SEGURIDAD (R)','CONTROL DE CLASIFICACIÓN DE SEGURIDAD (R)',1,0,'Specifics pertaining to the security classification associated with the document, title, abstract, contents note, and/or the author. In addition, it can contain handling instructions and external dissemination information pertaining to the dissemination o','Elemento controlado','No definido',0),('357','CONTROL DEL CREADOR SOBRE LA DISEMINACION (NR)','CONTROL DEL CREADOR SOBRE LA DISEMINACION (NR)',0,0,'Specifics pertaining to originator (i.e., author, producer) control of dissemination of the material in hand. Subfield $a contains a specific term denoting that the originator has control over the material. \n Other information may be present in the field,','No definido','No definido',0),('359','RENTAL PRICE (VM)  [OBSOLETE]','RENTAL PRICE (VM)  [OBSOLETE]',1,0,'','','',0),('362','FECHAS DE PUBLICACIÓN Y/O DESIGNACIÓN SECUENCIAL (R)','FECHAS DE PUBLICACIÓN Y/O DESIGNACIÓN SECUENCIAL (R)',1,0,'Beginning/ending date(s) of an item and/or the sequential designations used on each part. Dates to be used in this field are chronological designations that identify individual issues of the continuing resource. The sequential designations are usually num','Formato de fecha','No definido',0),('400','MENCIÓN DE SERIE/ASIENTO SECUNDARIO - NOMBRE PERSONAL (R) [US-LOCAL]','MENCIÓN DE SERIE/ASIENTO SECUNDARIO - NOMBRE PERSONAL (R) [US-LOCAL]',0,0,'Used in the United States to support retrospective conversion of Pre-AACR 2 cataloging records. It was made obsolete in CAN/MARC in 1988. This field contains an author/title series statement in which the author portion is a personal name or a pronoun repr','Tipo de elemento de asiento de nombre personal','Pronombre representa asiento principal',0),('410','MENCIÓN DE SERIE/ASIENTO SECUNDARIO - NOMBRE CORPORATIVO (R) [US-LOCAL]','MENCIÓN DE SERIE/ASIENTO SECUNDARIO - NOMBRE CORPORATIVO (R) [US-LOCAL]',0,0,'Used in the United States to support retrospective conversion of Pre-AACR 2 cataloging records. It was made obsolete in CAN/MARC in 1988. This field contains an author/title series statement in which the author portion is a corporate name or a pronoun rep','Tipo de elemento de asiento de nombre corporativo','Pronombre representa asiento principal',0),('411','MENCIÓN DE SERIE/ASIENTO SECUNDARIO - NOMBRE DE REUNIÓN (R) [US-LOCAL]','MENCIÓN DE SERIE/ASIENTO SECUNDARIO - NOMBRE DE REUNIÓN (R) [US-LOCAL]',0,0,'Used in the United States to support retrospective conversion of Pre-AACR 2 cataloging records. It was made obsolete in CAN/MARC in 1988. This local field contains an author/title series statement in which the author portion is a conference/meeting name o','Tipo de elemento de asiento del nombre de la reunión','Pronombre representa asiento principal',0),('440','MENCIÓN DE SERIE/ASIENTO AGREGADA - TÍTULO (R) [OBSOLETE]','MENCIÓN DE SERIE/ASIENTO AGREGADA - TÍTULO (R) [OBSOLETE]',0,0,'This field was made obsolete in 2008 to simplify the series area so that all title series <em>statements</em> would be entered in the 490 field and all title series added entries in the 830.\n Series statement consisting of a series title alone.\n Used when','No definido','Caracteres que no se alfabetizan',0),('490','MENCIÓN DE SERIE (R)','MENCIÓN DE SERIE (R)',1,0,'Series statement for a series title.\n Field 490 does not serve as a series added entry. When field 490 is used and a series added entry is desired, both the series statement (field 490) and a corresponding series added entry (fields 800-830) are recorded ','Especifica si la serie está asentada','No definido',0),('500','NOTA GENERAL (R)','NOTA GENERAL (R)',1,0,'General information for which a specialized 5XX note field has not been defined.\n','No definido','No definido',0),('501','NOTA DE CON (R)','NOTA DE CON (R)',1,0,'Note indicating that more than one bibliographical work is contained in the physical item at the time of publishing, release, issue, or execution. The works that are contained in the item usually have distinctive titles and lack a collective title. \n The ','No definido','No definido',0),('502','NOTA DE TESIS (R)','NOTA DE TESIS (R)',1,0,'Designation of an academic dissertation or thesis and the institution to which it was presented. Other notes indicating the relationship between the item being cataloged and the author\'s dissertation or thesis, such as statements indicating that the work ','No definido','No definido',0),('503','BIBLIOGRAPHIC Historia Nota (R) (BK CF MU) [OBSOLETE]','BIBLIOGRAPHIC Historia Nota (R) (BK CF MU) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('504','NOTA DE BIBLIOGRAFÍA, ETC. (R)','NOTA DE BIBLIOGRAFÍA, ETC. (R)',1,0,'Information on the presence of one or more bibliographies, discographies, filmographies, and/or other bibliographic references in a described item or in accompanying material. \n For multipart items, including <strong>serials</strong>, the note may pertain','No definido','No definido',0),('505','NOTA DE CONTENIDOS FORMATEADA (R)','NOTA DE CONTENIDOS FORMATEADA (R)',1,0,'Titles of separate works or parts of an item or the table of contents. The field may also contain statements of responsibility and volume numbers or other sequential designations. \n Chapter numbers are generally omitted. This field contains a formatted co','Controlador de la constante de despliegue','Nivel de la designación del contenido',0),('506','NOTA SOBRE RESTRICCIÓN DE ACCESO (R)','NOTA SOBRE RESTRICCIÓN DE ACCESO (R)',1,0,'Information about restrictions imposed on access to the described materials.\n For published works, this field contains information on limited distribution. For <strong>continuing resources</strong>, the restrictions must apply to all issues. \n If a note m','Restriction','No definido',0),('507','NOTA DE ESCALA PARA MATERIALES GRÁFICOS (NR)','NOTA DE ESCALA PARA MATERIALES GRÁFICOS (NR)',0,0,'Scale of a graphic material item given as a note. For <strong>visual materials</strong>, this field contains the scale of architectural drawings or three-dimensional artifacts. For <strong>maps</strong>, the scale of an item is contained in this field onl','No definido','No definido',0),('508','NOTA SOBRE LOS CRÉDITOS DE CREACIÓN/PRODUCCIÓN (R)','NOTA SOBRE LOS CRÉDITOS DE CREACIÓN/PRODUCCIÓN (R)',1,0,'Credits for persons or organizations, other than members of the cast, who have participated in the creation and/or production of the work. The introductory term <em>Credits:</em> is usually generated as a display constant. \n Field 508 is repeatable to rec','No definido','No definido',0),('510','NOTA DE CITACIÓN/REFERENCIA (R)','NOTA DE CITACIÓN/REFERENCIA (R)',1,0,'','Cobertura/localización dentro de la fuente','No definido',0),('511','NOTA DE PARTICIPANTE O INTÉRPRETE (R)','NOTA DE PARTICIPANTE O INTÉRPRETE (R)',1,0,'Information about the participants, players, narrators, presenters, or performers.\n The participant or performer note is sometimes displayed and/or printed with an introductory term or phrase that is generated as a display constant based on the first indi','Controlador de la constante de despliegue','No definido',0),('512','EARLIER OR LATER VOLUMES SEPARATELY CATALOGED Nota (SE) (R) [OBSOLETE]','EARLIER OR LATER VOLUMES SEPARATELY CATALOGED Nota (SE) (R) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('513','NOTA SOBRE EL TIPO DE REPORTE Y PERÍODO CUBIERTO (R)','NOTA SOBRE EL TIPO DE REPORTE Y PERÍODO CUBIERTO (R)',1,0,'Information on the type of report and the period covered by the report.\n','No definido','No definido',0),('514','NOTA SOBRE LA CALIDAD DE LOS DATOS (NR)','NOTA SOBRE LA CALIDAD DE LOS DATOS (NR)',0,0,'Provides a general assessment of the quality of the data set constituting the item.\n For <strong>cartographic material</strong>, recommendations on tests to be performed and information to be reported are found in the <em>Spatial Data Transfer Standard</e','No definido','No definido',0),('515','NOTA SOBRE LAS PARTICULARIDADES EN LA NUMERACIÓN (R)','NOTA SOBRE LAS PARTICULARIDADES EN LA NUMERACIÓN (R)',1,0,'Unformatted note giving irregularities and peculiarities in numbering or publishing patterns, report year coverage, revised editions, and/or issuance in parts. \n','No definido','No definido',0),('516','NOTA DE TIPO DE ARCHIVO O DATOS DE COMPUTADORA (R)','NOTA DE TIPO DE ARCHIVO O DATOS DE COMPUTADORA (R)',1,0,'General descriptor that characterizes the file (e.g., text, computer program, numeric). Specific information, such as the form or genre of textual material (e.g., biography, dictionaries, indexes) may be included. The general type of computer file informa','Controlador de la constante de despliegue','No definido',0),('517','CATEGORIES OF FILMS Nota (ARCHIVAL) (VM) (NR) [OBSOLETE]','CATEGORIES OF FILMS Nota (ARCHIVAL) (VM) (NR) [OBSOLETE]',0,0,'OBSOLETO','Fiction specification','No definido',0),('518','NOTA DE FECHA/HORA Y LUGAR DE UN ACONTECIMIENTO (R)','NOTA DE FECHA/HORA Y LUGAR DE UN ACONTECIMIENTO (R)',1,0,'Note on the date/time and/or place of creation, capture, recording, filming, execution, or broadcast associated with an event or the finding of a naturally occurring object. Field 033 (Date/Time and Place of an Event) contains the same information in code','No definido','No definido',0),('520','RESUMEN, ETC. (R)','RESUMEN, ETC. (R)',1,0,'Unformatted information that describes the scope and general contents of the materials. \n This could be a summary, abstract, annotation, review, or only a phrase describing the material. \n The level of detail appropriate in a summary may vary depending on','Controlador de la constante de despliegue','No definido',0),('521','NOTA DE AUDIENCIA (R)','NOTA DE AUDIENCIA (R)',1,0,'Information that identifies the specific audience or intellectual level for which the content of the described item is considered appropriate. \n Used to record interest and motivation levels and special learner characteristics. Information about the targe','Controlador de la constante de despliegue','No definido',0),('522','NOTA DE COBERTURA GEOGRÁFICA (R)','NOTA DE COBERTURA GEOGRÁFICA (R)',1,0,'Information about the geographic coverage of the described material (usually survey material). This information in coded form may be contained in field 052 (Geographic Classification Code). \n Sometimes displayed and/or printed with an introductory phrase ','Controlador de la constante de despliegue','No definido',0),('523','TIME PERIOD OF CONTENT Nota (NR) (CF) [OBSOLETE]','TIME PERIOD OF CONTENT Nota (NR) (CF) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('524','NOTA SOBRE CITACIÓN PREFERIDA DE LOS MATERIALES DESCRITOS (R)','NOTA SOBRE CITACIÓN PREFERIDA DE LOS MATERIALES DESCRITOS (R)',1,0,'Format for the citation of the described materials that is preferred by the custodian. \n When multiple citation formats exist for the same item, each is recorded in a separate occurrence of field 524. \n The note is sometimes displayed and/or printed with ','Controlador de la constante de despliegue','No definido',0),('525','NOTA DE SUPLEMENTO (R)','NOTA DE SUPLEMENTO (R)',1,0,'Information on the existence of supplements or special issues that are neither cataloged in separate records nor recorded in a linking entry field 770 (Supplement/Special Issue Entry). \n Generally, this note field is used <em>only</em> for unnamed supplem','No definido','No definido',0),('526','NOTA DE INFORMACIÓN SOBRE PROGRAMA DE ESTUDIOS (R)','NOTA DE INFORMACIÓN SOBRE PROGRAMA DE ESTUDIOS (R)',1,0,'Note giving the name of a study program which uses the title described in the record. Details about the study program data elements are also contained in the field. Field 526 is generally used for formal curriculum-based study or reading programs. \n','Controlador de la constante de despliegue','No definido',0),('527','CENSORSHIP Nota (VM) (R) [OBSOLETE]','CENSORSHIP Nota (VM) (R) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('530','NOTA SOBRE DISPONIBILIDAD DEL MATERIAL EN OTRO FORMATO (R)','NOTA SOBRE DISPONIBILIDAD DEL MATERIAL EN OTRO FORMATO (R)',1,0,'Information concerning a different physical format in which the described item is available. \n If the publisher of the additional physical form is different from the publisher of the item being cataloged, this field also contains source and order number i','No definido','No definido',0),('533','NOTA SOBRE REPRODUCCIÓN (R)','NOTA SOBRE REPRODUCCIÓN (R)',1,0,'Descriptive data for a reproduction of an original item when the main portion of the bibliographic record describes the original item and the data differ. \n The original item is described in the main portion of the bibliographic record and data relevant t','No definido','No definido',0),('534','NOTA SOBRE VERSIÓN ORIGINAL (R)','NOTA SOBRE VERSIÓN ORIGINAL (R)',1,0,'Descriptive data for an original item when the main portion ofthe bibliographic record describes a reproduction of that itemand the data differ. Details relevant to the original are givenin field 534.\nThe resource being cataloged may either be a reproduct','No definido','No definido',0),('535','NOTA SOBRE LA UBICACIÓN DE ORIGINALES O DUPLICADOS (R)','NOTA SOBRE LA UBICACIÓN DE ORIGINALES O DUPLICADOS (R)',1,0,'Name and address of the repository with custody over originals or duplicates of the described materials. This field is used only when the originals or duplicates are housed in a repository different from that of the materials being described. \n','Información adicional sobre el custodio','No definido',0),('536','NOTA DE INFORMACION SOBRE FINANCIAMIENTO (R)','NOTA DE INFORMACION SOBRE FINANCIAMIENTO (R)',1,0,'Contract, grant, and project numbers when the material results from a funded project. Information concerning the sponsor or funding agency also may be included. \n','No definido','No definido',0),('537','SOURCE OF DATA Nota (NR) (CF) [OBSOLETE]','SOURCE OF DATA Nota (NR) (CF) [OBSOLETE]',0,0,'OBSOLETO','Controlador de la constante de despliegue','No definido',0),('538','NOTA SOBRE DETALLES DEL SISTEMA (R)','NOTA SOBRE DETALLES DEL SISTEMA (R)',1,0,'Technical information about an item, such as the presence or absence of certain kinds of codes; or the physical characteristics of a computer file, such as recording densities, parity, blocking factors, mode of access, software programming language, compu','No definido','No definido',0),('540','NOTA SOBRE LOS TÉRMINOS QUE GOBIERNAN EL USO Y LA REPRODUCCIÓN DE UN ÍTEM (R)','NOTA SOBRE LOS TÉRMINOS QUE GOBIERNAN EL USO Y LA REPRODUCCIÓN DE UN ÍTEM (R)',1,0,'Terms governing the use of the materials after access has been provided. The field includes, but is not limited to, copyrights, film rights, trade restrictions, etc. that restrict the right to reproduce, exhibit, fictionalize, quote, etc. \n Information ab','No definido','No definido',0),('541','NOTA SOBRE LA FUENTE INMEDIATA DE ADQUISICIÓN (R)','NOTA SOBRE LA FUENTE INMEDIATA DE ADQUISICIÓN (R)',1,0,'Information about the immediate source of acquisition of the described materials and is used primarily with original or historical items, or other archival collections. \n  The original source of acquisition is recorded in field 561 (Ownership and Custodia','Privacidad','No definido',0),('543','SOLICITATION INFORMATION NOTE (AM)  [OBSOLETE]','SOLICITATION INFORMATION NOTE (AM)  [OBSOLETE]',1,0,'','','',0),('544','NOTA SOBRE LA UBICACIÓN DE OTROS MATERIALES ARCHIVARIOS (R)','NOTA SOBRE LA UBICACIÓN DE OTROS MATERIALES ARCHIVARIOS (R)',1,0,'Name and address of custodians of archival materials related to the described materials by provenance, specifically by having been, at a previous time, a part of the same collection or record group. \n','Relación','No definido',0),('545','NOTA SOBRE DATOS BIOGRÁFICOS O HISTÓRICOS (R)','NOTA SOBRE DATOS BIOGRÁFICOS O HISTÓRICOS (R)',1,0,'Biographical information about an individual or historical information about an institution or event used as the main entry for the item being cataloged. When a distinction between levels of detail is required, a brief summary is given in subfield $a and ','Tipo de datos','No definido',0),('546','NOTA DE IDIOMA (R)','NOTA DE IDIOMA (R)',1,0,'','No definido','No definido',0),('547','NOTA COMPLEJA SOBRE TÍTULO ANTERIOR (R)','NOTA COMPLEJA SOBRE TÍTULO ANTERIOR (R)',1,0,'Description of the complex relationship between titles proper whenever an intelligible note cannot be system generated from the data in field 247 (Former Title). \n Field 547 is used on latest entry and integrated entry catalog records (Continuing resource','No definido','No definido',0),('550','NOTA SOBRE ENTIDAD EMISORA DE LA PUBLICACIÓN (R)','NOTA SOBRE ENTIDAD EMISORA DE LA PUBLICACIÓN (R)',1,0,'Information about the current and former issuing bodies of a continuing resource.\n Includes notes containing editing, compiling, or translating information that involves an issuing body and notes denoting the item as an official organ of a society, etc. \n','No definido','No definido',0),('552','NOTA INFORMATIVA SOBRE LA ENTIDAD Y ATRIBUTO (R)','NOTA INFORMATIVA SOBRE LA ENTIDAD Y ATRIBUTO (R)',1,0,'Description of the information content of the data set, including the entity types, their attributes, and the domains from which attribute values may be assigned. \n','No definido','No definido',0),('555','NOTA SOBRE ÍNDICE ACUMULATIVO/AYUDAS DE BÚSQUEDA (R)','NOTA SOBRE ÍNDICE ACUMULATIVO/AYUDAS DE BÚSQUEDA (R)',1,0,'Information on the availability of cumulative indexes for continuing resources or finding aids and similar control materials for archival and manuscripts control and visual materials whose only or major focus is the described material. \n Field 510 (Citati','Controlador de la constante de despliegue','No definido',0),('556','NOTA INFORMATIVA SOBRE DOCUMENTACIÓN (R)','NOTA INFORMATIVA SOBRE DOCUMENTACIÓN (R)',1,0,'Information about the documentation of the described materials, such as codebooks which explain the contents and use of the file or a users&#8217; manual to a serial. \n Material which is based on the use, study, or analysis of the materials is cited in fi','Controlador de la constante de despliegue','No definido',0),('561','NOTA HISTÓRICA SOBRE DUEÑOS Y CUSTODIOS (R)','NOTA HISTÓRICA SOBRE DUEÑOS Y CUSTODIOS (R)',1,0,'','Privacidad','No definido',0),('562','NOTA SOBRE IDENTIFICACIÓN DE COPIA Y VERSIÓN (R)','NOTA SOBRE IDENTIFICACIÓN DE COPIA Y VERSIÓN (R)',1,0,'Information that distinguishes the copy(s) or version(s) of materials held by an archive or manuscript repository when more than one copy or version exists or could exist. \n NOTE: Statements relating to versions of manuscript works existing in two or more','No definido','No definido',0),('565','NOTA DE LAS CARACTERÍSTICAS DE ARCHIVOS DE CASOS (R)','NOTA DE LAS CARACTERÍSTICAS DE ARCHIVOS DE CASOS (R)',1,0,'Information about the content and characteristics of case files and/or the number of cases or variables making up a case file or a database. \n Case files are interpreted broadly as records that contain standard categories of information about a defined po','Controlador de la constante de despliegue','No definido',0),('567','NOTA SOBRE METODOLOGÍA (R)','NOTA SOBRE METODOLOGÍA (R)',1,0,'Information concerning significant methodological characteristics of the material, such as the algorithm, universe description, sampling procedures, classification, or validation characteristics. \n The note is sometimes displayed and/or printed with an in','Controlador de la constante de despliegue','No definido',0),('570','EDITOR Nota (SE) (R) [OBSOLETE]','EDITOR Nota (SE) (R) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('580','NOTA COMPLEJA DE ENLACES DE ASIENTOS (R)','NOTA COMPLEJA DE ENLACES DE ASIENTOS (R)',1,0,'Description of the complex relationship between the item described in the record and other items that cannot be adequately generated from the linking entry fields 760-787. \n In some cases the field is used to state a relationship when no corresponding lin','No definido','No definido',0),('581','NOTA SOBRE PUBLICACIONES SOBRE EL MATERIAL DESCRITO (R)','NOTA SOBRE PUBLICACIONES SOBRE EL MATERIAL DESCRITO (R)',1,0,'Citation or information about a publication that is based on the use, study, or analysis of the materials described in the record. \n Documentation about a file, etc., is recorded in field 556 (Information about Documentation Note). \n This field can also b','Controlador de la constante de despliegue','No definido',0),('582','RELATED COMPUTER FILES Nota (R) (CF) [OBSOLETE]','RELATED COMPUTER FILES Nota (R) (CF) [OBSOLETE]',0,0,'OBSOLETO','Controlador de la constante de despliegue','No definido',0),('583','NOTA DE ACCIÓN TOMADA (R)','NOTA DE ACCIÓN TOMADA (R)',1,0,'Information about processing, reference, and preservation actions.\n Reference actions may include a brief statement about solicitation to acquire material, whether the solicitation is active or inactive, and the date of the last item of correspondence. \n ','Privacidad','No definido',0),('584','NOTA SOBRE ACUMULACIONES Y FRECUENCIA DE USO (R)','NOTA SOBRE ACUMULACIONES Y FRECUENCIA DE USO (R)',1,0,'Measurements of and information about the rates of accumulation (for continuing, open-ended accessions) and/or the rate of reference use of the described materials. \n','No definido','No definido',0),('585','NOTA SOBRE EXPOSICIONES (R)','NOTA SOBRE EXPOSICIONES (R)',1,0,'Copy-specific field that contains a note which cites exhibitions where the material described has been shown. \n','No definido','No definido',0),('586','NOTA SOBRE PREMIOS (R)','NOTA SOBRE PREMIOS (R)',1,0,'Information on awards associated with the described item.\n Field is repeated for each occurrence of an award.\n','Controlador de la constante de despliegue','No definido',0),('590','RECEIPT DATE Nota (VM) [OBSOLETE]','RECEIPT DATE Nota (VM) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('600','ASIENTO SECUNDARIO DE MATERIA - NOMBRE PERSONAL (R)','ASIENTO SECUNDARIO DE MATERIA - NOMBRE PERSONAL (R)',1,0,'Subject added entry in which the entry element is a personal name.\n Subject added entries are assigned to a bibliographic record to provide access according to established subject cataloging principles and guidelines. Field 600 may be used by any institut','Tipo de nombre personal','Tesauro',0),('610','ASIENTO SECUNDARIO DE MATERIA - NOMBRE CORPORATIVOS (R)','ASIENTO SECUNDARIO DE MATERIA - NOMBRE CORPORATIVOS (R)',1,0,'Subject added entry in which the entry element is a corporate name.\n Subject added entries are assigned to a bibliographic record to provide access according to established subject cataloging principles and guidelines. Field 610 may be used by any institu','Tipo de nombre corporativo','Tesauro',0),('611','ASIENTO SECUNDARIO DE MATERIA - NOMBRE DE REUNIÓN (R)','ASIENTO SECUNDARIO DE MATERIA - NOMBRE DE REUNIÓN (R)',1,0,'Subject added entry in which the entry element is a meeting or conference name.\n Subject added entries are assigned to a bibliographic record to provide access according to established subject cataloging principles and guidelines. Field 611 may be used by','Tipo de nombre de reunión','Tesauro',0),('630','ASIENTO SECUNDARIO DE MATERIA - TÍTULO UNIFORME (R)','ASIENTO SECUNDARIO DE MATERIA - TÍTULO UNIFORME (R)',1,0,'Subject added entry in which the entry element is a uniform title.\n Subject added entries are assigned to a bibliographic record to provide access according to established subject cataloging principles and guidelines. Field 630 may be used by any institut','Caracteres que no se alfabetizan','Tesauro',0),('650','ASIENTO SECUNDARIO DE MATERIA - TÉRMINOS TEMÁTICOS (R)','ASIENTO SECUNDARIO DE MATERIA - TÉRMINOS TEMÁTICOS (R)',1,0,'Subject added entry in which the entry element is a topical term.\n Topical subject added entries may consist of general subject terms including names of events or objects. Subject added entries are assigned to a bibliographic record to provide access acco','Nivel del tema o materia','Tesauro',0),('651','ASIENTO SECUNDARIO DE MATERIA - NOMBRES GEOGRÁFICOS (R)','ASIENTO SECUNDARIO DE MATERIA - NOMBRES GEOGRÁFICOS (R)',1,0,'Subject added entry in which the entry element is a geographic name.\n Subject added entries are assigned to a bibliographic record to provide access according to generally accepted cataloging and thesaurus-building rules (e.g., <em>Library of Congress Sub','No definido','Tesauro',0),('652','SUBJECT ADDED ENTRY--REVERSED GEOGRAPHIC (BK MP SE) [OBSOLETE]','SUBJECT ADDED ENTRY--REVERSED GEOGRAPHIC (BK MP SE) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('653','TÉRMINO INDIZADO -NO CONTROLADO (R)','TÉRMINO INDIZADO -NO CONTROLADO (R)',1,0,'Index term added entry that is not constructed by standard subject heading/thesaurus-building conventions. \n','Nivel del término índice','Tipo de término o nombre',0),('654','ASIENTO SECUNDARIO DE MATERIA - TÉRMINOS TEMÁTICOS FACETADOS (R)','ASIENTO SECUNDARIO DE MATERIA - TÉRMINOS TEMÁTICOS FACETADOS (R)',1,0,'Topical subject constructed from a faceted vocabulary.\n For each term found in the field, an identification is given as to the facet/hierarchy in the thesaurus from which the term came. In addition, identification is given as to which term is the focus te','Nivel del tema o materia','No definido',0),('655','TÉRMINO INDIZADO - GÉNERO/FORMA (R)','TÉRMINO INDIZADO - GÉNERO/FORMA (R)',1,0,'Terms indicating the genre, form, and/or physical characteristics of the materials being described. A <em>genre term</em> designates the style or technique of the intellectual content of textual materials or, for graphic materials, aspects such as vantage','Tipo de encabezado','Tesauro',0),('656','TÉRMINO INDIZADO - OCUPACIÓN (R)','TÉRMINO INDIZADO - OCUPACIÓN (R)',1,0,'Index term that is descriptive of the occupation (including avocation) reflected in the contents of the described materials. \n <strong>Not</strong> used to list the occupations of the creators of the described materials, unless those occupations are signi','No definido','Fuente del término',0),('657','TÉRMINO INDIZADO - FUNCIÓN (R)','TÉRMINO INDIZADO - FUNCIÓN (R)',1,0,'Index term that describes the activity or function that generated the described materials. \n Standard published lists are used for the function terms and the list is identified in subfield $2 (Source of term). \n','No definido','Fuente del término',0),('658','TÉRMINO INDIZADO - OBJETIVO DEL currículo (R)','TÉRMINO INDIZADO - OBJETIVO DEL currículo (R)',1,0,'Index terms denoting curriculum or course-of-study objectives applicable to the content of the described materials. The field may also contain correlation factors indicating the degree to which the described materials meet an objective. Codes assigned to ','No definido','No definido',0),('700','ASIENTO ADICIONAL DEL TÍTULO - NOMBRE PERSONAL (R)','ASIENTO ADICIONAL DEL TÍTULO - NOMBRE PERSONAL (R)',1,0,'Added entry in which the entry element is a personal name.\n Added entries are assigned according to various cataloging rules to give access to the bibliographic record from personal name headings which may not be more appropriately assigned as 600 (Subjec','Tipo de nombre personal como asiento','Tipo de asiento adicional del título',0),('705','ADDED ENTRY--PERSONAL NAME (PERFORMER) (MU) [OBSOLETE]','ADDED ENTRY--PERSONAL NAME (PERFORMER) (MU) [OBSOLETE]',0,0,'OBSOLETO','Type of personal name entry element','Tipo de asiento adicional del título',0),('710','ASIENTO ADICIONAL - NOMBRE CORPORATIVO (R)','ASIENTO ADICIONAL - NOMBRE CORPORATIVO (R)',1,0,'Added entry in which the entry element is a corporate name.\n Added entries are assigned according to various cataloging rules to give access to the bibliographic record from corporate name headings which may not be more appropriately assigned as 610 (Subj','Tipo del nombre del autor corporativo como asiento','Tipo de asiento agregado',0),('711','ASIENTO SECUNDARIO DE MATERIA - NOMBRE DE LA REUNIÓN (R)','ASIENTO SECUNDARIO DE MATERIA - NOMBRE DE LA REUNIÓN (R)',1,0,'Added entry in which the entry element is a meeting name.\n Added entries are assigned according to various cataloging rules to give access to the bibliographic record from meeting or conference name headings which may not be more appropriately assigned as','Tipo del nombre de la reunión como asiento','Tipo de asiento adicional del título',0),('715','ADDED ENTRY--CORPORATE NAME (PERFORMING GROUP) (MU) [OBSOLETE]','ADDED ENTRY--CORPORATE NAME (PERFORMING GROUP) (MU) [OBSOLETE]',0,0,'OBSOLETO','Type of corporate name entry element','Tipo de asiento adicional del título',0),('720','ASIENTO SECUNDARIO DE MATERIA - NOMBRES NO CONTROLADOS (R)','ASIENTO SECUNDARIO DE MATERIA - NOMBRES NO CONTROLADOS (R)',1,0,'Added entry in which the name is not controlled in an authority file or list. It is also used for names that have not been formulated according to cataloging rules. Names may be of any type (e.g., personal, corporate, meeting). \n Used when one of the othe','Tipo de nombre','No definido',0),('730','ASIENTO ADICIONAL DEL TÍTULO - TÍTULO UNIFORME (R)','ASIENTO ADICIONAL DEL TÍTULO - TÍTULO UNIFORME (R)',1,0,'Uniform title, a related or an analytical title that is controlled by an authority file or list, used as an added entry.\n Added entries are assigned according to various cataloging rules to give access to the bibliographic record from headings which may n','Caracteres que no se alfabetizan','Tipo de asiento adicional del título',0),('740','ASIENTO ADICIONAL DEL TÍTULO - TÍTULO ANALÍTICO/RELACIONADO NO CONTROLADO (R)','ASIENTO ADICIONAL DEL TÍTULO - TÍTULO ANALÍTICO/RELACIONADO NO CONTROLADO (R)',1,0,'Added entries for related or analytical titles that are not controlled through an authority file or list. (If related or analytical titles are controlled by an authority file, use field 730 (Added entry - uniform title)). \n May contain the title portion o','Caracteres que no se alfabetizan','Tipo de asiento adicional del título',0),('752','ASIENTO SECUNDARIO DE MATERIA - JERARQUÍA DEL NOMBRE DE LUGAR (R)','ASIENTO SECUNDARIO DE MATERIA - JERARQUÍA DEL NOMBRE DE LUGAR (R)',1,0,'Added entry in which the entry element is a hierarchical form of place name that is related to a particular attribute of the described item, e.g., the place of publication for a rare book. For display, a dash (--) may be generated to separate the subeleme','No definido','No definido',0),('753','DETALLES DE ACCESO AL SISTEMA PARA ARCHIVOS DE COMPUTADORA (R)','DETALLES DE ACCESO AL SISTEMA PARA ARCHIVOS DE COMPUTADORA (R)',1,0,'Information on the technical aspects of a computer file and any accompanying material that may be used to select and arrange the record with other records in a printed index. \n Used for the type of machine, operating system, and/or programming language. T','No definido','No definido',0),('754','ASIENTO ADICIONAL DEL TÍTULO - IDENTIFICACIÓN TAXONÓMICA (R)','ASIENTO ADICIONAL DEL TÍTULO - IDENTIFICACIÓN TAXONÓMICA (R)',1,0,'Added entry in which the entry element is the taxonomic name or category associated with the described item. \n Subfields $a and $2 are always used.\n','No definido','No definido',0),('755','ADDED ENTRY--PHYSICAL CHARACTERISTICS (R) [OBSOLETE]','ADDED ENTRY--PHYSICAL CHARACTERISTICS (R) [OBSOLETE]',0,0,'OBSOLETO','No definido','No definido',0),('760','ASIENTO PRINCIPAL DE SERIE (R)','ASIENTO PRINCIPAL DE SERIE (R)',1,0,'Information concerning the related main series when the target item is a subseries (vertical relationship). When a note is generated from this field, the introductory phrase <em>Main series:</em> or <em>Subseries of:</em> may be generated based on the fie','Controlador de nota','Controlador de la constante de despliegue',0),('762','ASIENTO DE SUBSERIE (R)','ASIENTO DE SUBSERIE (R)',1,0,'Information concerning a related subseries when the target item is a main series or a parent subseries (vertical relationship). When a note is generated from this field, the introductory phrase <em>Has subseries:</em> may be generated based on the field t','Controlador de nota','Controlador de la constante de despliegue',0),('765','ASIENTO DE IDIOMA ORIGINAL (R)','ASIENTO DE IDIOMA ORIGINAL (R)',1,0,'Information concerning the publication in its original language when the target item is a translation (horizontal relationship). When a note is generated from this field, the introductory phrase <em>Translation of:</em> may be generated based on the field','Controlador de nota','Controlador de la constante de despliegue',0),('767','ASIENTO DE TRADUCCIÓN (R)','ASIENTO DE TRADUCCIÓN (R)',1,0,'Information concerning the publication in some other language other than the original when the target item is in the original language or is another translation (horizontal relationship). When a note is generated from this field, the introductory phrase <','Controlador de nota','Controlador de la constante de despliegue',0),('770','ASIENTO DE SUPLEMENTOS/NÚMEROS ESPECIALES (R)','ASIENTO DE SUPLEMENTOS/NÚMEROS ESPECIALES (R)',1,0,'Information concerning the supplement or special issue associated with the target item but cataloged and/or input as a separate record (vertical relationship). When a note is generated from this field, the introductory phrase <em>Has supplement:</em> may ','Controlador de nota','Controlador de la constante de despliegue',0),('772','ASIENTO DE REGISTRO PRINCIPAL DE SUPLEMENTO (R)','ASIENTO DE REGISTRO PRINCIPAL DE SUPLEMENTO (R)',1,0,'Information concerning the related parent record when the target item is a single issue, supplement or special issue (vertical relationship) of the parent item. When a note is generated from this field, the introductory phrase <em>Supplement to:</em> may ','Controlador de nota','Controlador de la constante de despliegue',0),('773','ASIENTO DE REGISTRO ANFITRIÓN (R)','ASIENTO DE REGISTRO ANFITRIÓN (R)',1,0,'Information concerning the host item for the constituent unit described in the record (vertical relationship). In the case of host items that are serial or multi-volume in nature, information in subfields $g and $q is necessary to point to the exact locat','Controlador de nota','Controlador de la constante de despliegue',0),('774','ASIENTO DE UNIDAD CONSTITUYENTE (R)','ASIENTO DE UNIDAD CONSTITUYENTE (R)',1,0,'Information concerning a constituent unit associated with a larger bibliographic unit (vertical relationship). When a note is generated from this field, the introductory term <em>Constituent unit:</em> may be generated based on the field tag for display.\n','Controlador de nota','Controlador de la constante de despliegue',0),('775','ASIENTO DE OTRA EDICIÓN (R)','ASIENTO DE OTRA EDICIÓN (R)',1,0,'Entry for another available edition of the target item (horizontal relationship). When a note is generated from this field, the introductory phrase <em>Other editions available:</em> may be generated based on the field tag for display.\n The following type','Controlador de nota','Controlador de la constante de despliegue',0),('776','ASIENTO DE FORMA FÍSICA ADICIONAL (R)','ASIENTO DE FORMA FÍSICA ADICIONAL (R)',1,0,'Information concerning another available physical form of the target item (horizontal relationship). When a note is generated from this field, the introductory phrase <em>Available in other form:</em> may be generated based on the field tag for display.\n ','Controlador de nota','Controlador de la constante de despliegue',0),('777','ASIENTO DE EMITIDO CON (R)','ASIENTO DE EMITIDO CON (R)',1,0,'Information concerning the publication that is separately cataloged but that is issued with or included in the target item (horizontal relationship). When a note is generated from this field, the introductory phrase <em>Issued with:</em> may be generated ','Controlador de nota','Controlador de la constante de despliegue',0),('780','ASIENTO DE TÍTULO ANTERIOR (R)','ASIENTO DE TÍTULO ANTERIOR (R)',1,0,'Information concerning the immediate predecessor of the target item (chronological relationship). When a note is generated from this field, the introductory term or phrase may be generated based on the value in the second indicator position for display.\n ','Controlador de nota','Tipo de relación',0),('785','ASIENTO DE TÍTULO POSTERIOR (R)','ASIENTO DE TÍTULO POSTERIOR (R)',1,0,'Information concerning the immediate successor to the target item (chronological relationship). When a note is generated from this field, the introductory phrase may be generated based on the value in the second indicator position for display.\n Repeated f','Controlador de nota','Tipo de relación',0),('786','ASIENTO DE ORIGEN DE DATOS (R)','ASIENTO DE ORIGEN DE DATOS (R)',1,0,'Information pertaining to a data source to which the described item is related. It may contain information about other files, printed sources, or collection procedures.\n','Controlador de nota','Controlador de la constante de despliegue',0),('787','ASIENTO DE RELACIONES NO ESPECÍFICAS (R)','ASIENTO DE RELACIONES NO ESPECÍFICAS (R)',1,0,'','Controlador de nota','Controlador de la constante de despliegue',0),('800','ASIENTO ADICIONAL DE LA SERIE - NOMBRE PERSONAL (R)','ASIENTO ADICIONAL DE LA SERIE - NOMBRE PERSONAL (R)',1,0,'Author/title series added entry in which the author portion is a personal name. \n An 800 field is usually justified by a series statement (field 490) or a general note (field 500) relating to the series. For reproductions, it may be justified by a series ','Tipo de elemento de asiento de nombre personal','No definido',0),('810','ASIENTO ADICIONAL DE LA SERIE - NOMBRE CORPORATIVO (R)','ASIENTO ADICIONAL DE LA SERIE - NOMBRE CORPORATIVO (R)',1,0,'Author/title series added entry in which the author portion is a corporate name. \n An 810 field is usually justified by a series statement (field 490) or a general note (field 500) relating to the series. For reproductions, it may be justified by a series','Tipo de elemento de asiento de nombre corporativo','No definido',0),('811','ASIENTO ADICIONAL DE LA SERIE - NOMBRE DE LA REUNIÓN (R)','ASIENTO ADICIONAL DE LA SERIE - NOMBRE DE LA REUNIÓN (R)',1,0,'Author/title series added entry in which the author portion is a meeting name or conference name. \n An 811 field is usually justified by a series statement (field 490) or a general note (field 500) relating to the series. For reproductions, it may be just','Tipo del nombre de la reunión como asiento','No definido',0),('830','ASIENTO ADICIONAL DE SERIE - TÍTULO UNIFORME (R)','ASIENTO ADICIONAL DE SERIE - TÍTULO UNIFORME (R)',1,0,'Series added entry consisting of a series title alone. \n An 830 field is usually justified by a series statement (field 490) or a general note (field 500) relating to the series. For reproductions, it may be justified by a series statement in subfield $f ','No definido','Caracteres que no se alfabetizan',0),('840','SERIES ADDED ENTRY--TÍTULO (R) [OBSOLETE]','SERIES ADDED ENTRY--TÍTULO (R) [OBSOLETE]',0,0,'OBSOLETO','No definido','Caracteres que no se alfabetizan',0),('841','VALORES CODIFICADOS DE INFORMACION DE EXISTENCIAS (NR)','VALORES CODIFICADOS DE INFORMACION DE EXISTENCIAS (NR)',0,0,'','','',0),('842','DESIGNADOR DE FORMA FÍSICA TEXTUAL (NR)','DESIGNADOR DE FORMA FÍSICA TEXTUAL (NR)',0,0,'','','',0),('843','NOTA DE REPRODUCCIÓN (R)','NOTA DE REPRODUCCIÓN (R)',1,0,'','','',0),('844','NOMBRE DE LA UNIDAD (NR)','NOMBRE DE LA UNIDAD (NR)',0,0,'','','',0),('845','TÉRMINOS QUE REGULAN EL USO Y LA REPRODUCCIÓN (R)','TÉRMINOS QUE REGULAN EL USO Y LA REPRODUCCIÓN (R)',1,0,'','','',0),('850','INSTITUCIÓN EN POSESIÓN DE LA EXISTENCIA (R)','INSTITUCIÓN EN POSESIÓN DE LA EXISTENCIA (R)',1,0,'Information concerning holdings of the described item by the specified institution.\n May be repeated when the size of a single field exceeds system limitations due to the number of $a subfields present. \n','No definido','No definido',0),('851','LOCATION   [OBSOLETE]','LOCATION   [OBSOLETE]',1,0,'','','',0),('852','UBICACIÓN (R)','UBICACIÓN (R)',1,0,'Identifies the organization holding the item or from which it is available. May also contain detailed information about how to locate the item in a collection. \n Repeated when holdings are reported for multiple copies of an item and the location data elem','Esquema de almacenamiento en los estantes','Orden de almacenamiento en los estantes',0),('853','ENCABEZADOS Y PATRÓN - UNIDAD BIBLIOGRÁFICA BÁSICA  (R)','ENCABEZADOS Y PATRÓN - UNIDAD BIBLIOGRÁFICA BÁSICA  (R)',1,0,'','','',0),('854','ENCABEZADOS Y PATRÓN - MATERIAL ADICIONAL (R)','ENCABEZADOS Y PATRÓN - MATERIAL ADICIONAL (R)',1,0,'','','',0),('855','ENCABEZADOS Y PATRÓN - ÍNDICES (R)','ENCABEZADOS Y PATRÓN - ÍNDICES (R)',1,0,'','','',0),('856','UBICACIÓN Y ACCESO ELECTRÓNICOS (R)','UBICACIÓN Y ACCESO ELECTRÓNICOS (R)',1,0,'Information needed to locate and access an electronic resource. The field may be used in a bibliographic record for a resource when that resource or a subset of it is available electronically. In addition, it may be used to locate and access an electronic','Método de acceso','Relación',0),('863','ENUMERACIÓN Y CRONOLOGÍA - UNIDAD BIBLIOGRÁFICA BÁSICA (R)','ENUMERACIÓN Y CRONOLOGÍA - UNIDAD BIBLIOGRÁFICA BÁSICA (R)',1,0,'','','',0),('864','ENUMERACIÓN Y CRONOLOGÍA - MATERIAL ADICIONAL (R)','ENUMERACIÓN Y CRONOLOGÍA - MATERIAL ADICIONAL (R)',1,0,'','','',0),('865','ENUMERACIÓN Y CRONOLOGÍA - ÍNDICES (R)','ENUMERACIÓN Y CRONOLOGÍA - ÍNDICES (R)',1,0,'','','',0),('866','INVENTARIO TEXTUAL - UNIDAD BIBLIOGRÁFICA BÁSICA (R)','INVENTARIO TEXTUAL - UNIDAD BIBLIOGRÁFICA BÁSICA (R)',1,0,'','','',0),('867','INVENTARIO TEXTUAL - MATERIAL ADICIONAL (R)','INVENTARIO TEXTUAL - MATERIAL ADICIONAL (R)',1,0,'','','',0),('868','INVENTARIO TEXTUAL - ÍNDICES (R)','INVENTARIO TEXTUAL - ÍNDICES (R)',1,0,'','','',0),('870','VARIANT PERSONAL NAME (SE) [OBSOLETE]','VARIANT PERSONAL NAME (SE) [OBSOLETE]',0,0,'OBSOLETO','','',0),('871','VARIANT CORPORATE NAME (SE)[OBSOLETE]','VARIANT CORPORATE NAME (SE)[OBSOLETE]',0,0,'OBSOLETO','','',0),('872','VARIANT CONFERENCE OR MEETING NAME (SE) [OBSOLETE]','VARIANT CONFERENCE OR MEETING NAME (SE) [OBSOLETE]',0,0,'OBSOLETO','','',0),('873','VARIANT UNIFORM TITLE HEADING (SE) [OBSOLETE]','VARIANT UNIFORM TITLE HEADING (SE) [OBSOLETE]',0,0,'OBSOLETO','','',0),('876','INFORMACIÓN DEL ÍTEM - UNIDAD BIBLIOGRÁFICA BÁSICA (R)','INFORMACIÓN DEL ÍTEM - UNIDAD BIBLIOGRÁFICA BÁSICA (R)',1,0,'','','',0),('877','INFORMACIÓN DEL ÍTEM - MATERIAL ADICIONAL (R)','INFORMACIÓN DEL ÍTEM - MATERIAL ADICIONAL (R)',1,0,'','','',0),('878','INFORMACIÓN DEL ÍTEM - ÍNDICES (R)','INFORMACIÓN DEL ÍTEM - ÍNDICES (R)',1,0,'','','',0),('880','REPRESENTACIÓN GRÁFICA ALTERNATIVA (R)','REPRESENTACIÓN GRÁFICA ALTERNATIVA (R)',1,0,'Fully content-designated representation, in a different script, of another field in the same record. Field 880 is linked to the associated regular field by subfield $6 (Linkage). A subfield $6 in the associated field also links that field to the 880 field','Igual que el campo asociado','Igual que el campo asociado',0),('886','CAMPO DE INFORMACIÓN DE FORMATO MARC EXTRANJERO (R)','CAMPO DE INFORMACIÓN DE FORMATO MARC EXTRANJERO (R)',1,0,'Used when converting foreign MARC records into the MARC format. Contains data from a foreign MARC record for which there is no corresponding MARC field. \n','Tipo de campo','No definido',0),('995','Datos del Ejemplar','Datos del Ejemplar',1,0,'','','',0),('000','LEADER','LEADER',0,0,'','','',0),('910','Tipo de documento','Tipo de documento',0,1,'','','',0),('882','INFORMACIÓN DE REGISTRO DE REEMPLAZO (NR)','INFORMACIÓN DE REGISTRO DE REEMPLAZO (NR)',0,0,'Information about the replacement bibliographic record in a deleted record. The replacement title(s) may be contained in subfield(s) $a. \n','No definido','No definido',0),('366','INFORMACION SOBRE DISPONIBILIDAD COMERCIAL (R)','INFORMACION SOBRE DISPONIBILIDAD COMERCIAL (R)',1,0,'Detailed information relating to the availability of items from publishers.\n Used primarily by book trade users of the MARC format.\n','No definido','No definido',0),('751','ASIENTO ADICIONAL DEL TÍTULO - NOMBRE GEOGRÁFICO (R)','ASIENTO ADICIONAL DEL TÍTULO - NOMBRE GEOGRÁFICO (R)',1,0,'Added entry in which the entry element is a geographic name that is related to a particular attribute of the described item, e.g., the place of publication for a rare book, place of distribution, place of a university to which a dissertation is submitted,','No definido','No definido',0),('337','TIPO DE MEDIO (R)','TIPO DE MEDIO (R)',1,0,'Media type reflects the general type of intermediation device required to view, play, run, etc., the content of a resource. Used as an alternative to or in addition to the coded expression of Media type in field 007/00 (Category of material). Field 337 in','No definido','No definido',0),('648','ASIENTO SECUNDARIO DE MATERIA - TÉRMINO CRONOLÓGICO (R)','ASIENTO SECUNDARIO DE MATERIA - TÉRMINO CRONOLÓGICO (R)',1,0,'Subject added entry in which the entry element is a chronological term.\n Subject added entries are assigned to a bibliographic record to provide access according to generally accepted thesaurus-building rules (e.g., <em>Library of Congress Subject Heading','No definido','Tesauro',0),('026','IDENTIFICADOR DE IDENTIDAD TIPOGRÁFICA (R)','IDENTIFICADOR DE IDENTIDAD TIPOGRÁFICA (R)',1,0,'Used to assist in the identification of antiquarian books by recording information comprising groups of characters taken from specified positions on specified pages of the book, in accordance with the principles laid down in various published guidelines. ','No definido','No definido',0),('662','ASIENTO ADICIONAL DEL TÍTULO - NOMBRE DE LUGAR JERÁRQUICO (R)','ASIENTO ADICIONAL DEL TÍTULO - NOMBRE DE LUGAR JERÁRQUICO (R)',1,0,'Hierarchical form of a geographic name used as a subject added entry.\n Subject added entries are assigned to a bibliographic record to provide access according to generally accepted cataloging and thesaurus-building rules. \n','No definido','No definido',0),('588','NOTA DE ORIGEN DE DESCRIPCIÓN (R)','NOTA DE ORIGEN DE DESCRIPCIÓN (R)',1,0,'Information used for tracking and controlling the metadata contained in the record. It includes general and specific source of description notes that are especially of interest to other catalogers.\n','No definido','No definido',0),('542','INFORMACIÓN RELATIVA AL ESTADO DE DERECHO DE AUTOR (R)','INFORMACIÓN RELATIVA AL ESTADO DE DERECHO DE AUTOR (R)',1,0,'Information known about the item that may be used to determine copyright status.\n The entire field may be repeated if a non-repeatable subfield needs to be repeated (e.g., Personal creator, Research date) or if additional information is added at a later d','Privacidad','No definido',0),('083','NÚMERO DE CLASIFICACIÓN DECIMAL DEWEY ADICIONAL','NÚMERO DE CLASIFICACIÓN DECIMAL DEWEY ADICIONAL',0,0,'','Tipo de edición','No definido',0),('887','CAMPO DE INFORMACIÓN QUE NO PERTENECE A MARC (R)','CAMPO DE INFORMACIÓN QUE NO PERTENECE A MARC (R)',1,0,'Data from non-MARC records for which there are no corresponding MARC 21 fields. Used when converting non-MARC records into the MARC 21 format. \n','No definido','No definido',0),('336','TIPO DE CONTENIDO (R)','TIPO DE CONTENIDO (R)',1,0,'The form of communication through which a work is expressed. Used in conjunction with Leader /06 (Type of record), which indicates the general type of content of the resource. Field 336 information enables expression of more specific content types and con','No definido','No definido',0),('085','SÍNTESIS DE COMPONENTES DEL NÚMERO DE CLASIFICACIÓN (R)','SÍNTESIS DE COMPONENTES DEL NÚMERO DE CLASIFICACIÓN (R)',1,0,'Information about how a synthesized classification number or a portion of a synthesized classification number was built. It traces the different components of a synthesized number, showing the different portions of the number and where the add instruction','No definido','No definido',0),('563','INFORMACIÓN SOBRE ENCUADERNACIÓN (R)','INFORMACIÓN SOBRE ENCUADERNACIÓN (R)',1,0,'Binding information intended primarily for use with antiquarian materials, rare books and other special collections. \n It is not intended for serials bound together after publication for shelving and storage purposes. \n \n','No definido','No definido',0),('258','FECHA DE SUPLEMENTO FILATÉLICO (R)','FECHA DE SUPLEMENTO FILATÉLICO (R)',1,0,'Issuing jurisdiction and denomination information about philatelic material, such as postage stamps, postal stationery (postal cards, etc., made available by a postal administration bearing a stamped impression (indicium) of denomination), revenue stamps ','No definido','No definido',0),('038','REGISTRO DEL CONCEDENTE DE LA LICENCIA DEL CONTENIDO (NR)','REGISTRO DEL CONCEDENTE DE LA LICENCIA DEL CONTENIDO (NR)',0,0,'MARC code of the organization that licenses the intellectual property rights to the data contained in the record, such as with contractual arrangements. See Appendix I: <em><a href=\"http://www.loc.gov/marc/bibliographic/ecbdorg.html\">Organization Code Sou','No definido','No definido',0),('365','PRECIO COMERCIAL (R)','PRECIO COMERCIAL (R)',1,0,'Current price of an item or the special export price of an item in any currency.\n Intended primarily for use by the book trade to record the current price of an item.\n','No definido','No definido',0),('338','TIPO DE PORTADOR (R)','TIPO DE PORTADOR (R)',1,0,'Carrier type reflects the format of the storage medium and housing of a carrier in combination with the media type (which indicates the intermediation device required to view, play, run, etc., the content of a resource). Used as an alternative to or in ad','No definido','No definido',0),('031','INFORMACIÓN DE ÍNCIPITS MUSICALES (R)','INFORMACIÓN DE ÍNCIPITS MUSICALES (R)',1,0,'Coded data representing the musical incipit for music using established notation schemes that employ ordinary ASCII symbols. Primarily used to identify music manuscripts, but can be applied to any material containing music. \n','No definido','No definido',0),('363','DESIGNACIÓN CRONOLÓGICA Y SECUENCIAL NORMALIZADA (R)','DESIGNACIÓN CRONOLÓGICA Y SECUENCIAL NORMALIZADA (R)',1,0,'The numeric, alphabetic and/or normalized date designation used on the bibliographic item that identifies its parts and shows the relationship of the parts to the whole.\n','Designación de inicio/fin','Estado de la emisión',0),('900','Nivel Bibliográfico','Nivel Bibliográfico',0,0,NULL,NULL,NULL,0),('859','No se que es','No se que es',0,0,NULL,NULL,NULL,2);
/*!40000 ALTER TABLE `pref_estructura_campo_marc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_estructura_subcampo_marc`
--

DROP TABLE IF EXISTS `pref_estructura_subcampo_marc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_estructura_subcampo_marc` (
  `nivel` tinyint(1) NOT NULL DEFAULT '0',
  `obligatorio` tinyint(1) NOT NULL DEFAULT '0',
  `campo` char(3) NOT NULL DEFAULT '',
  `subcampo` char(3) NOT NULL DEFAULT '',
  `liblibrarian` char(255) DEFAULT NULL,
  `libopac` char(255) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `repetible` tinyint(4) NOT NULL DEFAULT '0',
  `mandatory` tinyint(4) NOT NULL DEFAULT '0',
  `kohafield` char(40) DEFAULT NULL,
  PRIMARY KEY (`campo`,`subcampo`),
  KEY `kohafield` (`kohafield`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_estructura_subcampo_marc`
--

LOCK TABLES `pref_estructura_subcampo_marc` WRITE;
/*!40000 ALTER TABLE `pref_estructura_subcampo_marc` DISABLE KEYS */;
INSERT INTO `pref_estructura_subcampo_marc` VALUES (0,0,'010','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,1,NULL),(0,0,'010','a','Número de control de LC (NR)','Número de control de LC (NR)','',0,1,'biblioitems.lccn'),(0,0,'010','b','Número de control NUCMC (R)','Número de control NUCMC (R)','',1,1,NULL),(0,0,'010','z','Número de control LC no válido/cancelado (R)','Número de control LC no válido/cancelado (R)','',1,0,NULL),(0,0,'011','a','Número de control vinculante de LC (R)','Número de control vinculante de LC (R)','',1,0,NULL),(0,0,'013','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'013','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'013','a','Número (NR)','Número (NR)','',0,0,NULL),(0,0,'013','b','País (NR)','País (NR)','',0,0,NULL),(0,0,'013','c','Tipo de número (NR)','Tipo de número (NR)','',0,0,NULL),(0,0,'013','d','Fecha (R)','Fecha (R)','',1,0,NULL),(0,0,'013','e','Estado (R)','Estado (R)','',1,0,NULL),(0,0,'013','f','Parte del documento (R)','Parte del documento (R)','',1,0,NULL),(0,0,'015','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'015','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'015','a','Número de la bibliografía nacional (R)','Número de la bibliografía nacional (R)','',1,0,NULL),(0,0,'016','2','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'016','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'016','a','Número de control de registro (NR)','Número de control de registro (NR)','',0,0,NULL),(0,0,'016','z','Número de control de registro no válido/cancelado (R)','Número de control de registro no válido/cancelado (R)','',1,0,NULL),(0,0,'017','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'017','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'017','a','Número de depósito legal (R)','Número de depósito legal (R)','',1,0,NULL),(0,0,'017','b','Agencia que asigna el número (NR)','Agencia que asigna el número (NR)','',0,0,NULL),(0,0,'017','c','Terms of availability','Terms of availability','',0,0,NULL),(0,0,'017','z','Número de depósito legal o derecho de autor no válido/cancelado (R)','Número de depósito legal o derecho de autor no válido/cancelado (R)','',1,0,NULL),(0,0,'018','a','Artículo registrado-código de pago (NR)','Artículo registrado-código de pago (NR)','',0,0,NULL),(0,0,'020','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'020','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'020','a','Número Internacional Normalizado para Libros (NR)','Número Internacional Normalizado para Libros (NR)','',0,1,'isbns.isbn'),(0,0,'020','b','Binding information (NR) [OBSOLETE]','Binding information (NR) [OBSOLETE]','',0,0,NULL),(0,0,'020','c','Términos de disponibilidad (NR)','Términos de disponibilidad (NR)','',0,0,NULL),(0,0,'020','z','ISBN no válido/cancelado (R)','ISBN no válido/cancelado (R)','',1,0,NULL),(0,0,'022','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'022','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'022','a','Número Internacional Normalizado para Publicaciones Seriadas (NR)','Número Internacional Normalizado para Publicaciones Seriadas (NR)','',0,0,'biblioitems.issn'),(0,0,'022','y','ISSN incorrecto (R)','ISSN incorrecto (R)','',1,0,NULL),(0,0,'022','z','ISSN cancelado (R)','ISSN cancelado (R)','',1,0,NULL),(0,0,'024','2','Fuente del código o número (NR)','Fuente del código o número (NR)','',0,0,NULL),(0,0,'024','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'024','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'024','a','Código o número estandarizado de grabación (NR)','Código o número estandarizado de grabación (NR)','',0,0,NULL),(0,0,'024','c','Términos de disponibilidad (NR)','Términos de disponibilidad (NR)','',0,0,NULL),(0,0,'024','d','Códigos adicionales a continuación del número o código estandarizado (NR)','Códigos adicionales a continuación del número o código estandarizado (NR)','',0,0,NULL),(0,0,'024','z','Código cancelado/no válido (R)','Código cancelado/no válido (R)','',1,0,NULL),(0,0,'025','6','Linkage See','Linkage See','',0,0,NULL),(0,0,'025','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'025','a','Número de adquisición en el extranjero (R)','Número de adquisición en el extranjero (R)','',1,0,NULL),(0,0,'025','z','Canceled/invalid number','Canceled/invalid number','',1,0,NULL),(0,0,'027','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'027','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'027','a','Número normalizado de informe técnico (NR)','Número normalizado de informe técnico (NR)','',0,0,NULL),(0,0,'027','z','Número cancelado/no válido (R)','Número cancelado/no válido (R)','',1,0,NULL),(0,0,'028','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'028','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'028','a','Número del editor (NR)','Número del editor (NR)','',0,0,NULL),(0,0,'028','b','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'030','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'030','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'030','a','CODEN (NR)','CODEN (NR)','',0,0,NULL),(0,0,'030','z','CODEN cancelado/no válido (R)','CODEN cancelado/no válido (R)','',1,0,NULL),(0,0,'032','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'032','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'032','a','Número de registro postal (NR)','Número de registro postal (NR)','',0,0,NULL),(0,0,'032','b','Fuente (agencia que asigna el número) (NR)','Fuente (agencia que asigna el número) (NR)','',0,0,NULL),(0,0,'033','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,''),(0,0,'033','6','Enlace (NR)','Enlace (NR)','',0,0,''),(0,0,'033','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,''),(0,0,'033','a','Fecha/hora formateados (R)','Fecha/hora formateados (R)','',1,0,''),(0,0,'033','b','Código de área de clasificación geográfica (R)','Código de área de clasificación geográfica (R)','',1,0,''),(0,0,'033','c','Código de sub-área de clasificación geográfica (R)','Código de sub-área de clasificación geográfica (R)','',1,0,''),(0,0,'034','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'034','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'034','a','Categoría de la escala (NR)','Categoría de la escala (NR)','',0,0,NULL),(0,0,'034','b','Escala horizontal lineal de radio constante (R)','Escala horizontal lineal de radio constante (R)','',1,0,NULL),(0,0,'034','c','Escala vertical lineal de radio constante (R)','Escala vertical lineal de radio constante (R)','',1,0,NULL),(0,0,'034','d','Coordenadas--Longitud Oeste (NR)','Coordenadas--Longitud Oeste (NR)','',0,0,NULL),(0,0,'034','e','Coordenadas--Longitud Este (NR)','Coordenadas--Longitud Este (NR)','',0,0,NULL),(0,0,'034','f','Coordenadas--Longitud Norte (NR)','Coordenadas--Longitud Norte (NR)','',0,0,NULL),(0,0,'034','g','Coordenadas--Longitud Sur (NR)','Coordenadas--Longitud Sur (NR)','',0,0,NULL),(0,0,'034','h','Escala angular (R)','Escala angular (R)','',1,0,NULL),(0,0,'034','j','Declinación--Límite Norte (NR)','Declinación--Límite Norte (NR)','',0,0,NULL),(0,0,'034','k','Declinación--Límite Sur (NR)','Declinación--Límite Sur (NR)','',0,0,NULL),(0,0,'034','m','Ascensión derecha--Límite Este (NR)','Ascensión derecha--Límite Este (NR)','',0,0,NULL),(0,0,'034','n','Ascensión derecha--Límite Oeste (NR)','Ascensión derecha--Límite Oeste (NR)','',0,0,NULL),(0,0,'034','p','Equinoccio (NR)','Equinoccio (NR)','',0,0,NULL),(0,0,'034','s','Latitud G-ring (R)','Latitud G-ring (R)','',1,0,NULL),(0,0,'034','t','Longitud G-ring (R)','Longitud G-ring (R)','',1,0,NULL),(0,0,'035','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'035','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'035','a','Número de control del sistema (NR)','Número de control del sistema (NR)','',0,0,NULL),(0,0,'035','z','Número de control cancelado/no válido (R)','Número de control cancelado/no válido (R)','',1,0,NULL),(0,0,'036','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'036','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'036','a','Número de estudio original (NR)','Número de estudio original (NR)','',0,0,NULL),(0,0,'036','b','Fuente (agencia que asigna el número) (NR)','Fuente (agencia que asigna el número) (NR)','',0,0,NULL),(0,0,'037','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'037','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'037','a','Número de inventario (NR)','Número de inventario (NR)','',0,0,NULL),(0,0,'037','b','Fuente del número de inventario/compra (NR)','Fuente del número de inventario/compra (NR)','',0,0,NULL),(0,0,'037','c','Términos de disponibilidad (R)','Términos de disponibilidad (R)','',0,0,NULL),(0,0,'037','f','Forma del ejemplar (R)','Forma del ejemplar (R)','',0,0,NULL),(0,0,'037','g','Características adicionales del formato (R)','Características adicionales del formato (R)','',0,0,NULL),(0,0,'037','n','Nota (R)','Nota (R)','',0,0,NULL),(0,0,'039','a','Level of rules in bibliographic description (NR)    0 - No level defined by rules    1 - Minimal    2 - Less than full    3 - Full','Level of rules in bibliographic description (NR)    0 - No level defined by rules    1 - Minimal    2 - Less than full    3 - Full','',0,0,NULL),(0,0,'039','b','Level of effort used to assign nonsubject heading access points (NR)    2 - Less than full    3 - Full','Level of effort used to assign nonsubject heading access points (NR)    2 - Less than full    3 - Full','',0,0,NULL),(0,0,'039','c','Level of effort (030, CODEN DESIGNATION, CODEN DESIGNATION, 1, 0, \', \', \'),\nused to assign subject headings  (NR)    0 - None    2 - Less than full    3 - Full','Level of effort used to assign subject headings  (NR)    0 - None    2 - Less than full    3 - Full','',0,0,NULL),(0,0,'039','d','Level of effort used to assign classification  (NR)    0 - None    2 - Less than full    3 - Full','Level of effort used to assign classification  (NR)    0 - None    2 - Less than full    3 - Full','',0,0,NULL),(0,0,'039','e','Number of fixed field character positions coded  (NR)    0 - None    1 - Minimal    2 - Most necessary    3 - Full','Number of fixed field character positions coded  (NR)    0 - None    1 - Minimal    2 - Most necessary    3 - Full','',0,0,NULL),(0,0,'040','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'040','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'040','a','Agencia/entidad que catalogó originalmente la obra (NR)','Agencia/entidad que catalogó originalmente la obra (NR)','',0,0,NULL),(0,0,'040','b','Idioma en que se cataloga (NR)','Idioma en que se cataloga (NR)','',0,0,NULL),(0,0,'040','c','Entidad que transcribió la catalogación (NR)','Entidad que transcribió la catalogación (NR)','',0,0,NULL),(0,0,'040','d','Entidad que modificó el registro (R)','Entidad que modificó el registro (R)','',1,0,NULL),(0,0,'040','e','Convenciones de la descripción (NR)','Convenciones de la descripción (NR)','',0,0,NULL),(0,0,'041','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'041','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'041','a','Código de idioma para texto o pista de sonido o título separado (R)','Código de idioma para texto o pista de sonido o título separado (R)','',1,0,'biblioitems.idLanguage'),(0,0,'041','b','Código de idioma del resumen (R)','Código de idioma del resumen (R)','',1,0,NULL),(0,0,'041','c','Idiomas de traducción disponible (SE) [OBSOLETE]','Idiomas de traducción disponible (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'041','d','Código de idioma de texto cantado o hablado (R)','Código de idioma de texto cantado o hablado (R)','',1,0,NULL),(0,0,'041','e','Código de idioma de libretos (R)','Código de idioma de libretos (R)','',1,0,NULL),(0,0,'041','f','Código de idioma de la tabla de contenidos (R)','Código de idioma de la tabla de contenidos (R)','',1,0,NULL),(0,0,'041','g','Código de idioma del material anexado diferente de libretos (R)','Código de idioma del material anexado diferente de libretos (R)','',1,0,NULL),(0,0,'041','h','Código de idioma de la versión original y/o traducciones intermedias del texto (R)','Código de idioma de la versión original y/o traducciones intermedias del texto (R)','',1,0,NULL),(0,0,'042','6','Linkage See','Linkage See','',0,0,NULL),(0,0,'042','8','Field link and sequence number See','Field link and sequence number See','',1,0,NULL),(0,0,'042','a','Código de autenticación (R)','Código de autenticación (R)','',1,0,NULL),(0,0,'042','b','Formatted 9999 B','Formatted 9999 B','',1,0,NULL),(0,0,'042','c','Formatted pre-9999 B','Formatted pre-9999 B','',1,0,NULL),(0,0,'043','2','Fuente de código local (R)','Fuente de código local (R)','',1,0,NULL),(0,0,'043','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'043','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'043','a','Código de área geográfica (R)','Código de área geográfica (R)','',1,0,NULL),(0,0,'043','c','Código ISO (R)','Código ISO (R)','',1,0,'biblioitems.idCountry'),(0,0,'044','2','Fuente del código de sub-entidad local (R)','Fuente del código de sub-entidad local (R)','',1,0,NULL),(0,0,'044','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'044','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'044','a','Código MARC del país (R)','Código MARC del país (R)','',1,0,NULL),(2,0,'490','3','Materiales específicos a los cuales se aplica el campo','Materiales específicos a los cuales se aplica el campo','',0,0,NULL),(0,0,'044','b','Código de sub-entidad local (R)','Código de sub-entidad local (R)','',1,0,NULL),(0,0,'044','c','Código ISO del país (R)','Código ISO del país (R)','',1,0,NULL),(0,0,'045','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'045','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'045','a','Código de período cronológico (R)','Código de período cronológico (R)','',1,0,NULL),(0,0,'045','b','Período cronológico de formato 9999 A.C. a D.C. (R)','Período cronológico de formato 9999 A.C. a D.C. (R)','',1,0,NULL),(0,0,'045','c','Período cronológico de formato anterior a 9999 A.C. (R)','Período cronológico de formato anterior a 9999 A.C. (R)','',1,0,NULL),(0,0,'046','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'046','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'046','a','Código de tipo de fecha (NR)','Código de tipo de fecha (NR)','',0,0,NULL),(0,0,'046','b','Fecha 1 (fecha A.C.) (NR)','Fecha 1 (fecha A.C.) (NR)','',0,0,NULL),(0,0,'046','c','Fecha 1 (fecha D.C.) (NR)','Fecha 1 (fecha D.C.) (NR)','',0,0,NULL),(0,0,'046','d','Fecha 2 (fecha A.C.) (NR)','Fecha 2 (fecha A.C.) (NR)','',0,0,NULL),(0,0,'046','e','Fecha 2 (fecha D.C.) (NR)','Fecha 2 (fecha D.C.) (NR)','',0,0,NULL),(0,0,'047','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'047','a','Código de forma de la composición musical (R)','Código de forma de la composición musical (R)','',1,0,NULL),(0,0,'047','b','Soloist','Soloist','',1,0,NULL),(0,0,'048','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'048','a','Intérprete o conjunto (R)','Intérprete o conjunto (R)','',1,0,NULL),(0,0,'048','b','Solista (R)','Solista (R)','',1,0,NULL),(0,0,'050','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'050','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'050','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'050','a','Número de clasificación (R)','Número de clasificación (R)','',1,0,NULL),(0,0,'050','b','Número de item (NR)','Número de item (NR)','',0,0,NULL),(0,0,'050','d','Número de clase suplementario (MU) [OBSOLETE]','Número de clase suplementario (MU) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'051','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'051','a','Número de clasificación (NR)','Número de clasificación (NR)','',0,0,NULL),(0,0,'051','b','Número de ítem (NR)','Número de ítem (NR)','',0,0,NULL),(0,0,'051','c','Información de copia (NR)','Información de copia (NR)','',0,0,NULL),(0,0,'052','2','Fuente del código (NR)','Fuente del código (NR)','',0,0,NULL),(0,0,'052','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'052','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'052','a','Código de área de clasificación geográfica (NR)','Código de área de clasificación geográfica (NR)','',0,0,NULL),(0,0,'052','b','Código de subárea de clasificación geográfica (R)','Código de subárea de clasificación geográfica (R)','',1,0,NULL),(0,0,'052','c','Subject (MP) [OBSOLETE]','Subject (MP) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'052','d','Nombre de poblado (R)','Nombre de poblado (R)','',1,0,NULL),(0,0,'055','2','Fuente del número de ubicación/clase (NR)','Fuente del número de ubicación/clase (NR)','',0,0,NULL),(0,0,'055','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'055','a','Número de clasificación (NR)','Número de clasificación (NR)','',0,0,NULL),(0,0,'055','b','Número de ítem (NR)','Número de ítem (NR)','',0,0,NULL),(0,0,'060','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'060','a','Número de clasificación (R)','Número de clasificación (R)','',1,0,NULL),(0,0,'060','b','Numero del ítem (NR)','Numero del ítem (NR)','',0,0,NULL),(0,0,'061','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'061','a','Número de clasificación (R)','Número de clasificación (R)','',1,0,NULL),(0,0,'061','b','Número de ítem (NR)','Número de ítem (NR)','',0,0,NULL),(0,0,'061','c','Información de copia (NR)','Información de copia (NR)','',0,0,NULL),(0,0,'066','a','Conjunto de caracteres primario G0 (NR)','Conjunto de caracteres primario G0 (NR)','',0,0,NULL),(0,0,'066','b','Conjunto de caracteres G1 (NR)','Conjunto de caracteres G1 (NR)','',0,0,NULL),(0,0,'066','c','Conjunto de caracteres alternos G0 o G1 (R)','Conjunto de caracteres alternos G0 o G1 (R)','',1,0,NULL),(0,0,'070','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'070','a','Número de clasificación (R)','Número de clasificación (R)','',1,0,NULL),(0,0,'070','b','Número de ítem (NR)','Número de ítem (NR)','',0,0,NULL),(0,0,'071','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'071','a','Número de clasificación (R)','Número de clasificación (R)','',1,0,NULL),(0,0,'071','b','Número de ítem (NR)','Número de ítem (NR)','',0,0,NULL),(0,0,'071','c','Información de copia (NR)','Información de copia (NR)','',0,0,NULL),(0,0,'072','2','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'072','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'072','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'072','a','Código de categoría temática (NR)','Código de categoría temática (NR)','',0,0,NULL),(0,0,'072','x','Subdivisión de código de categoría temática (R)','Subdivisión de código de categoría temática (R)','',1,0,NULL),(0,0,'074','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'074','a','Número de ítem GPO (NR)','Número de ítem GPO (NR)','',0,0,NULL),(0,0,'074','z','Número de ítem GPO cancelado/no válido (R)','Número de ítem GPO cancelado/no válido (R)','',1,0,NULL),(0,0,'080','2','Identificador de la edición (NR)','Identificador de la edición (NR)','',0,0,NULL),(0,0,'080','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'080','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'080','a','Número de Clasificación Decimal Universal (NR)','Número de Clasificación Decimal Universal (NR)','',0,0,'biblio.seriestitle'),(0,0,'080','b','Número del ítem (NR)','Número del ítem (NR)','',0,0,NULL),(0,0,'080','x','Subdivisión auxiliar común (R)','Subdivisión auxiliar común (R)','',1,0,NULL),(0,0,'082','2','Número de la edición (NR)','Número de la edición (NR)','',0,0,NULL),(0,0,'082','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'082','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'082','a','Número de clasificación (R)','Número de clasificación (R)','',1,0,NULL),(0,0,'082','b','Número DDC -- versión NST abreviada (SE) [OBSOLETE]','Número DDC -- versión NST abreviada (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'084','2','Fuente del número (NR)','Fuente del número (NR)','',0,0,NULL),(0,0,'084','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'084','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'084','a','Número de clasificación (R)','Número de clasificación (R)','',1,0,NULL),(0,0,'084','b','Número de ítem (NR)','Número de ítem (NR)','',0,0,NULL),(0,0,'086','2','Fuente del número (NR)','Fuente del número (NR)','',0,0,NULL),(0,0,'086','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'086','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'086','a','Número de clasificación (NR)','Número de clasificación (NR)','',0,0,NULL),(0,0,'086','z','Número de clasificación no válido/cancelado (R)','Número de clasificación no válido/cancelado (R)','',1,0,NULL),(0,0,'088','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'088','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'088','a','Número de reporte (NR)','Número de reporte (NR)','',0,0,NULL),(0,0,'088','z','Número de reporte cancelado/no válido (R)','Número de reporte cancelado/no válido (R)','',1,0,NULL),(0,0,'090','a','Ubicación en estante (NR)','Ubicación en estante (NR)','',0,0,NULL),(0,0,'090','b','Local Cutter number','Local Cutter number','',0,0,NULL),(0,0,'090','c','Koha biblionumber (NR)','Koha biblionumber (NR)','',0,0,'biblio.biblionumber'),(0,0,'090','d','Koha biblioitemnumber (NR)','Koha biblioitemnumber (NR)','',0,0,'biblioitems.biblioitemnumber'),(0,0,'091','a','Microfilm shelf location (NR)','Microfilm shelf location (NR)','',0,0,NULL),(0,0,'100','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'100','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'100','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'100','a','Nombre personal (NR)','Nombre personal (NR)','',0,0,'biblio.author'),(0,0,'100','b','Numeración (NR)','Numeración (NR)','',0,0,NULL),(0,0,'100','c','Títulos y otras palabras asociadas con el nombre (R)','Títulos y otras palabras asociadas con el nombre (R)','',1,0,NULL),(0,0,'100','d','Fechas asociadas con el nombre (NR)','Fechas asociadas con el nombre (NR)','',0,0,NULL),(0,0,'100','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'100','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'100','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'100','j','Calificador de atributos (R)','Calificador de atributos (R)','',1,0,NULL),(0,0,'100','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'100','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'100','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'100','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'100','q','Forma completa del nombre (NR)','Forma completa del nombre (NR)','',0,0,NULL),(0,0,'100','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'100','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'110','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'110','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'110','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'110','a','Nombre de la institución, jurisdicción como asiento principal (NR)','Nombre de la institución, jurisdicción como asiento principal (NR)','',0,0,NULL),(0,0,'110','b','Unidad subordinada (R)','Unidad subordinada (R)','',1,0,NULL),(0,0,'110','c','Ubicación de la reunión (NR)','Ubicación de la reunión (NR)','',0,0,NULL),(0,0,'110','d','Fecha de la reunión o firma de tratado (R)','Fecha de la reunión o firma de tratado (R)','',1,0,NULL),(0,0,'110','e','Relación (R)','Relación (R)','',1,0,NULL),(0,0,'110','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'110','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'110','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'110','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'110','n','Número de la parte/sección/reunión (R)','Número de la parte/sección/reunión (R)','',1,0,NULL),(0,0,'110','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'110','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'110','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'111','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'111','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'111','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'111','a','Nombre de la reunión como asiento principal (NR)','Nombre de la reunión como asiento principal (NR)','',0,0,NULL),(0,0,'111','b','Number (BK CF MP MU SE VM MX) [OBSOLETE]','Number (BK CF MP MU SE VM MX) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'111','c','Localización de la reunión (NR)','Localización de la reunión (NR)','',0,0,NULL),(0,0,'111','d','Fecha de la reunión (NR)','Fecha de la reunión (NR)','',0,0,NULL),(0,0,'111','e','Unidad subordinada (R)','Unidad subordinada (R)','',1,0,NULL),(0,0,'111','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'111','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'111','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'111','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'111','n','Número de la parte/sección/reunión (R)','Número de la parte/sección/reunión (R)','',1,0,NULL),(0,0,'111','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'111','q','Tipo del nombre de la reunión siguiente al nombre de jurisdicción como asiento (NR)','Tipo del nombre de la reunión siguiente al nombre de jurisdicción como asiento (NR)','',0,0,NULL),(0,0,'111','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'111','u','Afiliación  (NR)','Afiliación  (NR)','',0,0,NULL),(0,0,'130','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'130','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'130','a','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'130','d','Fecha de firma de tratado (R)','Fecha de firma de tratado (R)','',1,0,NULL),(0,0,'130','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'130','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'130','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'130','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'130','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'130','m','Medio de interpretación de la música (R)','Medio de interpretación de la música (R)','',1,0,NULL),(0,0,'130','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'130','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'130','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'130','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'130','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'130','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'210','2','Fuente (R)','Fuente (R)','',1,0,NULL),(0,0,'210','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'210','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'210','a','Título abreviado (NR)','Título abreviado (NR)','',0,0,NULL),(0,0,'210','b','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'211','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'211','a','Acronym or shortened Título (NR)','Acronym or shortened Título (NR)','',0,0,NULL),(0,0,'212','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'212','a','Variant access Título (NR)','Variant access Título (NR)','',0,0,NULL),(0,0,'214','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'214','a','Augmented Título (NR)','Augmented Título (NR)','',0,0,NULL),(0,0,'222','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'222','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'222','a','Título clave (NR)','Título clave (NR)','',0,0,NULL),(0,0,'222','b','Informacion calificadora (NR)','Informacion calificadora (NR)','',0,0,NULL),(0,0,'240','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'240','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'240','a','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'240','d','Fecha de la firma del tratado (R)','Fecha de la firma del tratado (R)','',1,0,NULL),(0,0,'240','f','Fecha del trabajo (NR)','Fecha del trabajo (NR)','',0,0,NULL),(0,0,'240','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'240','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'240','k','Formas de subencabezados (R)','Formas de subencabezados (R)','',1,0,NULL),(0,0,'240','l','Idioma del trabajo (NR)','Idioma del trabajo (NR)','',0,0,NULL),(0,0,'240','m','Medio para la ejecución de música (R)','Medio para la ejecución de música (R)','',1,0,NULL),(0,0,'240','n','Número de la parte/sección/reunión (R)','Número de la parte/sección/reunión (R)','',1,0,NULL),(0,0,'240','o','Mención de arreglo música (NR)','Mención de arreglo música (NR)','',0,0,NULL),(0,0,'240','p','Nombre de la parte/sección (R)','Nombre de la parte/sección (R)','',1,0,NULL),(0,0,'240','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'240','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'241','a','Romanized Título (NR)','Romanized Título (NR)','',0,0,NULL),(0,0,'241','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'242','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'242','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'242','a','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'242','b','Resto del título (NR)','Resto del título (NR)','',0,0,NULL),(0,0,'242','c','Declaración de responsabilidad , etc. (NR)','Declaración de responsabilidad , etc. (NR)','',0,0,NULL),(0,0,'242','d','Designación de la sección (BK AM MP MU VM SE) [OBSOLETE]','Designación de la sección (BK AM MP MU VM SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'242','e','Nombre de la parte/sección (BK AM MP MU VM SE) [OBSOLETE]','Nombre de la parte/sección (BK AM MP MU VM SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'242','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'242','n','Número de la parte/sección del trabajo (R)','Número de la parte/sección del trabajo (R)','',1,0,NULL),(0,0,'242','p','Nombre de la parte/sección del trabajo (R)','Nombre de la parte/sección del trabajo (R)','',1,0,NULL),(0,0,'242','y','Código de idioma del título traducido (NR)','Código de idioma del título traducido (NR)','',0,0,NULL),(0,0,'243','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'243','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'243','a','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'243','d','Fecha de firma de tratado (R)','Fecha de firma de tratado (R)','',1,0,NULL),(0,0,'243','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'243','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'243','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'243','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'243','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'243','m','Medio de interpretación de la música (R)','Medio de interpretación de la música (R)','',1,0,NULL),(0,0,'243','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'243','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'243','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'243','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'243','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'245','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'245','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,1,'245','a','Título (NR)','Título (NR)','',0,0,'biblio.title'),(0,0,'245','b','Resto del título (NR)','Resto del título (NR)','',0,0,'biblio.unititle'),(0,0,'245','c','Declaración de responsabilidad, etc. (NR)','Declaración de responsabilidad, etc. (NR)','',0,0,NULL),(0,0,'245','d','Designation of section (SE) [OBSOLETE]','Designation of section (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'245','e','Name of part/section (SE) [OBSOLETE]','Name of part/section (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'245','f','Fechas inclusivas (NR)','Fechas inclusivas (NR)','',0,0,NULL),(0,0,'245','g','Bulk dates (NR)','Bulk dates (NR)','',0,0,NULL),(0,0,'245','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'245','k','Forma (R)','Forma (R)','',1,0,NULL),(0,0,'245','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'245','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'245','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'246','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'246','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'246','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'246','a','Título propiamente dicho/título corto (NR)','Título propiamente dicho/título corto (NR)','',0,0,'bibliosubtitle.subtitle'),(0,0,'246','b','Resto del título (NR)','Resto del título (NR)','',0,0,NULL),(0,0,'246','d','Designation of section (SE) [OBSOLETE]','Designation of section (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'246','e','Name of part/section (SE) [OBSOLETE]','Name of part/section (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'246','f','Fecha o designación secuencial (NR)','Fecha o designación secuencial (NR)','',0,0,NULL),(0,0,'533','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'246','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'246','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'246','i','Texto a desplegar (NR)','Texto a desplegar (NR)','',0,0,NULL),(0,0,'246','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'246','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'247','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'247','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'247','a','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'247','b','Resto del título (NR)','Resto del título (NR)','',0,0,NULL),(0,0,'247','d','Designation of section (SE) [OBSOLETE]','Designation of section (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'247','e','Name of part/section (SE) [OBSOLETE]','Name of part/section (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'247','f','Fecha o designación secuencial (NR)','Fecha o designación secuencial (NR)','',0,0,NULL),(0,0,'247','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'247','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'247','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'247','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'247','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'250','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'250','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'250','a','Mención de edición (NR)','Mención de edición (NR)','',0,0,'biblioitems.number'),(0,0,'250','b','Resto de la mención de edición (NR)','Resto de la mención de edición (NR)','',0,0,NULL),(0,0,'254','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'254','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'254','a','Mención de presentación musical (NR)','Mención de presentación musical (NR)','',0,0,NULL),(0,0,'255','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'255','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'255','a','Mención de escala (NR)','Mención de escala (NR)','',0,0,NULL),(0,0,'255','b','Mención de proyección (NR)','Mención de proyección (NR)','',0,0,NULL),(0,0,'255','c','Mención de coordenadas (NR)','Mención de coordenadas (NR)','',0,0,NULL),(0,0,'255','d','Mención de zona (NR)','Mención de zona (NR)','',0,0,NULL),(0,0,'255','e','Mención de equinoccio (NR)','Mención de equinoccio (NR)','',0,0,NULL),(0,0,'255','f','Pares de coordenadas del G-ring externo (NR)','Pares de coordenadas del G-ring externo (NR)','',0,0,NULL),(0,0,'255','g','Pares de coordenadas del G-ring de exclusión (NR)','Pares de coordenadas del G-ring de exclusión (NR)','',0,0,NULL),(0,0,'256','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'256','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'256','a','Características de archivo informático (NR)','Características de archivo informático (NR)','',0,0,NULL),(0,0,'257','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'257','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'257','a','País de la entidad que produce (R)','País de la entidad que produce (R)','',1,0,NULL),(0,0,'260','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'260','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'260','a','Lugar de publicación, distribución, etc. (R)','Lugar de publicación, distribución, etc. (R)','',1,0,'biblioitems.place'),(0,0,'260','b','Nombre de la editorial, distribuidor, etc. (R)','Nombre de la editorial, distribuidor, etc. (R)','',1,0,'publisher.publisher'),(0,0,'260','c','Fecha de publicación, distribución, etc. (R)','Fecha de publicación, distribución, etc. (R)','',1,0,'biblioitems.publicationyear'),(0,0,'260','d','Placa o número de editor para música (Pre-AACR 2) (NR) [LOCAL]','Placa o número de editor para música (Pre-AACR 2) (NR) [LOCAL]','',0,0,NULL),(0,0,'260','e','Lugar de fabricación (R)','Lugar de fabricación (R)','',1,0,NULL),(0,0,'260','f','Fabricante (R)','Fabricante (R)','',1,0,NULL),(0,0,'260','g','Fecha de fabricación (R)','Fecha de fabricación (R)','',1,0,NULL),(0,0,'261','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'261','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'261','a','Compañía productora (R)','Compañía productora (R)','',1,0,NULL),(0,0,'261','b','Compañía que comercializa (distribuidor primario) (R)','Compañía que comercializa (distribuidor primario) (R)','',1,0,NULL),(0,0,'261','d','Fecha de producción, publicación, etc. (R)','Fecha de producción, publicación, etc. (R)','',1,0,NULL),(0,0,'261','e','Productor contractual (R)','Productor contractual (R)','',1,0,NULL),(0,0,'261','f','Lugar de producción, publicación, etc. (R)','Lugar de producción, publicación, etc. (R)','',1,0,NULL),(0,0,'262','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'262','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'262','a','Lugar de producción, publicación, etc. (NR)','Lugar de producción, publicación, etc. (NR)','',0,0,NULL),(0,0,'262','b','Nombre comercial o editor (NR)','Nombre comercial o editor (NR)','',0,0,NULL),(0,0,'262','c','Fecha de producción, publicación, etc. (NR)','Fecha de producción, publicación, etc. (NR)','',0,0,NULL),(0,0,'262','k','Identificación serial (NR)','Identificación serial (NR)','',0,0,NULL),(0,0,'262','l','Número matriz o de pista (NR)','Número matriz o de pista (NR)','',0,0,NULL),(0,0,'263','4','Relator code','Relator code','',1,0,NULL),(0,0,'263','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'263','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'263','a','Fecha de publicación estimada (NR)','Fecha de publicación estimada (NR)','',0,0,NULL),(0,0,'263','b','City','City','',0,0,NULL),(0,0,'263','c','State or province','State or province','',0,0,NULL),(0,0,'263','d','Country','Country','',0,0,NULL),(0,0,'263','e','Postal code','Postal code','',0,0,NULL),(0,0,'263','f','Terms preceding attention name','Terms preceding attention name','',0,0,NULL),(0,0,'263','g','Attention name','Attention name','',0,0,NULL),(0,0,'263','h','Attention position','Attention position','',0,0,NULL),(0,0,'263','i','Type of address','Type of address','',0,0,NULL),(0,0,'263','j','Specialized telephone number','Specialized telephone number','',1,0,NULL),(0,0,'263','k','Telephone number','Telephone number','',1,0,NULL),(0,0,'263','l','Fax number','Fax number','',1,0,NULL),(0,0,'263','m','Electronic mail address','Electronic mail address','',1,0,NULL),(0,0,'263','n','TDD or TTY number','TDD or TTY number','',1,0,NULL),(0,0,'263','p','Contact person','Contact person','',1,0,NULL),(0,0,'263','q','Title of contact person','Title of contact person','',1,0,NULL),(0,0,'263','r','Hours','Hours','',1,0,NULL),(0,0,'263','z','Public note','Public note','',1,0,NULL),(0,0,'265','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'265','a','Source for acquisition/subscription address (R)','Source for acquisition/subscription address (R)','',1,0,NULL),(0,0,'270','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'270','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'270','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'270','a','Dirección (R)','Dirección (R)','',1,0,NULL),(0,0,'270','b','Ciudad (NR)','Ciudad (NR)','',0,0,NULL),(0,0,'270','c','Provincia o estado (NR)','Provincia o estado (NR)','',0,0,NULL),(0,0,'270','d','País (NR)','País (NR)','',0,0,NULL),(0,0,'270','e','Código postal (NR)','Código postal (NR)','',0,0,NULL),(0,0,'270','f','Términos que preceden el nombre de atención (NR)','Términos que preceden el nombre de atención (NR)','',0,0,NULL),(0,0,'270','g','Nombre de atención (NR)','Nombre de atención (NR)','',0,0,NULL),(0,0,'270','h','Posición de atención (NR)','Posición de atención (NR)','',0,0,NULL),(0,0,'270','i','Tipo de dirección (NR)','Tipo de dirección (NR)','',0,0,NULL),(0,0,'270','j','Número de teléfono especializado (R)','Número de teléfono especializado (R)','',1,0,NULL),(0,0,'270','k','Número de teléfono (R)','Número de teléfono (R)','',1,0,NULL),(0,0,'270','l','Número de fax (R)','Número de fax (R)','',1,0,NULL),(0,0,'270','m','Dirección de correo electrónico (R)','Dirección de correo electrónico (R)','',1,0,NULL),(0,0,'270','n','Número TDD o TTY (R)','Número TDD o TTY (R)','',1,0,NULL),(0,0,'270','p','Persona de contacto (R)','Persona de contacto (R)','',1,0,NULL),(0,0,'270','q','Título de persona de contacto (R)','Título de persona de contacto (R)','',1,0,NULL),(0,0,'270','r','Horas (R)','Horas (R)','',1,0,NULL),(0,0,'270','z','Nota pública (R)','Nota pública (R)','',1,0,NULL),(0,0,'300','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'300','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'300','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'300','a','Extensión (R)','Extensión (R)','',1,0,'biblioitems.pages'),(0,0,'300','b','Otros detalles físicos (NR)','Otros detalles físicos (NR)','',0,0,'biblioitems.illus'),(0,0,'300','c','Dimensiones (R)','Dimensiones (R)','',1,0,'biblioitems.size'),(0,0,'300','e','Material acompañante (NR)','Material acompañante (NR)','',0,0,NULL),(0,0,'300','f','Tipo de unidad (R)','Tipo de unidad (R)','',1,0,NULL),(0,0,'300','g','Tamaño de unidad (R)','Tamaño de unidad (R)','',1,0,NULL),(0,0,'301','a','Extensión of item (NR)','Extensión of item (NR)','',0,0,NULL),(0,0,'301','b','Sound characteristics (NR)','Sound characteristics (NR)','',0,0,NULL),(0,0,'301','c','Color characteristics (NR)','Color characteristics (NR)','',0,0,NULL),(0,0,'301','d','Dimensions (NR)','Dimensions (NR)','',0,0,NULL),(0,0,'301','e','Accompanying material (NR)','Accompanying material (NR)','',0,0,NULL),(0,0,'301','f','Speed (NR)','Speed (NR)','',0,0,NULL),(0,0,'302','a','Page count (NR)','Page count (NR)','',0,0,NULL),(0,0,'303','a','Unit count (NR)','Unit count (NR)','',0,0,NULL),(0,0,'304','a','Linear footage (NR)','Linear footage (NR)','',0,0,NULL),(0,0,'305','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'305','a','Extensión (NR)','Extensión (NR)','',0,0,NULL),(0,0,'305','b','Other physical details (NR)','Other physical details (NR)','',0,0,NULL),(0,0,'305','c','Dimensions (NR)','Dimensions (NR)','',0,0,NULL),(0,0,'305','d','Microgroove or standard (NR)','Microgroove or standard (NR)','',0,0,NULL),(0,0,'305','e','Stereophonic, monaural (NR)','Stereophonic, monaural (NR)','',0,0,NULL),(0,0,'305','f','Number of tracks (NR)','Number of tracks (NR)','',0,0,NULL),(0,0,'305','m','Serial identification (NR)','Serial identification (NR)','',0,0,NULL),(0,0,'305','n','Matrix and/or take number (NR)','Matrix and/or take number (NR)','',0,0,NULL),(0,0,'306','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'306','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'306','a','Duración (R)','Duración (R)','',1,0,NULL),(0,0,'306','b','Additional information','Additional information','',0,0,NULL),(0,0,'307','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'307','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'307','a','Horas (NR)','Horas (NR)','',0,0,NULL),(0,0,'307','b','Información adicional (NR)','Información adicional (NR)','',0,0,NULL),(0,0,'308','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'308','a','Number of reels (NR)','Number of reels (NR)','',0,0,NULL),(0,0,'308','b','Footage (NR)','Footage (NR)','',0,0,NULL),(0,0,'308','c','Sound characteristics (NR)','Sound characteristics (NR)','',0,0,NULL),(0,0,'308','d','Color characteristics (NR)','Color characteristics (NR)','',0,0,NULL),(0,0,'308','e','Width (NR)','Width (NR)','',0,0,NULL),(0,0,'308','f','Formato de presentación (NR)','Formato de presentación (NR)','',0,0,NULL),(0,0,'310','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'310','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'310','a','Frecuencia actual de la publicación (NR)','Frecuencia actual de la publicación (NR)','',0,0,NULL),(0,0,'310','b','Fecha de frecuencia actual de la publicación (NR)','Fecha de frecuencia actual de la publicación (NR)','',0,0,NULL),(0,0,'315','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'315','a','Frequency (R)','Frequency (R)','',1,0,NULL),(0,0,'315','b','Dates of frequency (R)','Dates of frequency (R)','',1,0,NULL),(0,0,'321','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'321','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'321','a','Frecuencia anterior de publicación (NR)','Frecuencia anterior de publicación (NR)','',0,0,NULL),(0,0,'321','b','Fechas de frecuencia anterior de publicación (NR)','Fechas de frecuencia anterior de publicación (NR)','',0,0,NULL),(0,0,'340','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'340','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'340','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'340','a','Configuración y base material (R)','Configuración y base material (R)','',1,0,NULL),(0,0,'340','b','Dimensiones (R)','Dimensiones (R)','',1,0,NULL),(0,0,'340','c','Materiales aplicados a la superficie (R)','Materiales aplicados a la superficie (R)','',1,0,NULL),(0,0,'340','d','Técnica de grabado de la información (R)','Técnica de grabado de la información (R)','',1,0,NULL),(0,0,'340','e','Soporte (R)','Soporte (R)','',1,0,NULL),(0,0,'340','f','Tasa o proporción de producción (R)','Tasa o proporción de producción (R)','',1,0,NULL),(0,0,'340','h','Ubicación en el medio (R)','Ubicación en el medio (R)','',1,0,NULL),(0,0,'340','i','Especificaciones técnicas del medio (R)','Especificaciones técnicas del medio (R)','',1,0,NULL),(0,0,'342','2','Método de referencia utilizado (NR)','Método de referencia utilizado (NR)','',0,0,NULL),(0,0,'342','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'342','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'342','a','Nombre (NR)','Nombre (NR)','',0,0,NULL),(0,0,'342','b','Coordenada o unidades de distancia (NR)','Coordenada o unidades de distancia (NR)','',0,0,NULL),(0,0,'342','c','Resolución de latitud (NR)','Resolución de latitud (NR)','',0,0,NULL),(0,0,'342','d','Resolución de longitud (NR)','Resolución de longitud (NR)','',0,0,NULL),(0,0,'342','e','Latitud estándar de línea oblicua o paralela (R)','Latitud estándar de línea oblicua o paralela (R)','',1,0,NULL),(0,0,'342','f','Longitud de línea oblicua (R)','Longitud de línea oblicua (R)','',1,0,NULL),(0,0,'342','g','Longitud del meridiano central o centro de proyección  (NR)','Longitud del meridiano central o centro de proyección  (NR)','',0,0,NULL),(0,0,'342','h','Latitud del origen de proyección o centro de proyección (NR)','Latitud del origen de proyección o centro de proyección (NR)','',0,0,NULL),(0,0,'342','i','Falso este (NR)','Falso este (NR)','',0,0,NULL),(0,0,'342','j','Falso norte (NR)','Falso norte (NR)','',0,0,NULL),(0,0,'342','k','Factor de escala (NR)','Factor de escala (NR)','',0,0,NULL),(0,0,'342','l','Altura del punto de perspectiva por sobre la superficie (NR)','Altura del punto de perspectiva por sobre la superficie (NR)','',0,0,NULL),(0,0,'342','m','Ángulo acimutal (NR)','Ángulo acimutal (NR)','',0,0,NULL),(0,0,'342','n','Longitud del punto de medición del acimut o longitud vertical recta desde el polo (NR)','Longitud del punto de medición del acimut o longitud vertical recta desde el polo (NR)','',0,0,NULL),(0,0,'342','o','Número de LandSat y número de trayectoria (NR)','Número de LandSat y número de trayectoria (NR)','',0,0,NULL),(0,0,'342','p','Identificador de zona (NR)','Identificador de zona (NR)','',0,0,NULL),(0,0,'342','q','Nombre del elipsoide (NR)','Nombre del elipsoide (NR)','',0,0,NULL),(0,0,'342','r','Eje semi-principal (NR)','Eje semi-principal (NR)','',0,0,NULL),(0,0,'342','s','Denominador de la proporción de aplanamiento (NR)','Denominador de la proporción de aplanamiento (NR)','',0,0,NULL),(0,0,'342','t','Resolución vertical (NR)','Resolución vertical (NR)','',0,0,NULL),(0,0,'342','u','Método de codificación vertical (NR)','Método de codificación vertical (NR)','',0,0,NULL),(0,0,'342','v','Plano local, local, u otra projección o descripción en malla (NR)','Plano local, local, u otra projección o descripción en malla (NR)','',0,0,NULL),(0,0,'342','w','Información de georeferencia de plano local o local (NR)','Información de georeferencia de plano local o local (NR)','',0,0,NULL),(0,0,'343','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'343','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'343','a','Método de codificación de las coordenadas del plano (NR)','Método de codificación de las coordenadas del plano (NR)','',0,0,NULL),(0,0,'343','b','Unidades de distancia del plano (NR)','Unidades de distancia del plano (NR)','',0,0,NULL),(0,0,'343','c','Resolución de abscisa (NR)','Resolución de abscisa (NR)','',0,0,NULL),(0,0,'343','d','Resolución de ordenada(NR)','Resolución de ordenada(NR)','',0,0,NULL),(0,0,'343','e','Resolución de distancia (NR)','Resolución de distancia (NR)','',0,0,NULL),(0,0,'343','f','Resolución de orientación (NR)','Resolución de orientación (NR)','',0,0,NULL),(0,0,'343','g','Unidades de orientación (NR)','Unidades de orientación (NR)','',0,0,NULL),(0,0,'343','h','Dirección de referencia de orientación (NR)','Dirección de referencia de orientación (NR)','',0,0,NULL),(0,0,'343','i','Meridiano de referencia de orientación (NR)','Meridiano de referencia de orientación (NR)','',0,0,NULL),(0,0,'350','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'350','a','Price (R)','Price (R)','',1,0,NULL),(0,0,'350','b','Form of issue (R)','Form of issue (R)','',1,0,NULL),(0,0,'351','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'351','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'351','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'351','a','Organización (R)','Organización (R)','',1,0,NULL),(0,0,'351','b','Arreglo (R)','Arreglo (R)','',1,0,NULL),(0,0,'351','c','Nivel jerárquico (NR)','Nivel jerárquico (NR)','',0,0,NULL),(0,0,'352','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'352','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'352','a','Método de referencia directa (NR)','Método de referencia directa (NR)','',0,0,NULL),(0,0,'352','b','Tipo de objeto (R)','Tipo de objeto (R)','',1,0,NULL),(0,0,'352','c','Conteo de objetos (R)','Conteo de objetos (R)','',1,0,NULL),(0,0,'352','d','Conteo de filas (NR)','Conteo de filas (NR)','',0,0,NULL),(0,0,'352','e','Conteo de columnas (NR)','Conteo de columnas (NR)','',0,0,NULL),(0,0,'352','f','Conteo vertical (NR)','Conteo vertical (NR)','',0,0,NULL),(0,0,'352','g','Nivel topológico VPF (NR)','Nivel topológico VPF (NR)','',0,0,NULL),(0,0,'352','i','Descripción de referencia indirecta (NR)','Descripción de referencia indirecta (NR)','',0,0,NULL),(0,0,'355','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'355','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'355','a','Clasificación de seguridad (NR)','Clasificación de seguridad (NR)','',0,0,NULL),(0,0,'355','b','Instrucciones de manejo (R)','Instrucciones de manejo (R)','',1,0,NULL),(0,0,'355','c','Información sobre diseminación externa (R)','Información sobre diseminación externa (R)','',1,0,NULL),(0,0,'355','d','Evento de reclasificación a menor nivel o desclasificación (NR)','Evento de reclasificación a menor nivel o desclasificación (NR)','',0,0,NULL),(0,0,'355','e','Sistema de clasificación (NR)','Sistema de clasificación (NR)','',0,0,NULL),(0,0,'355','f','Código del país de origen (NR)','Código del país de origen (NR)','',0,0,NULL),(0,0,'355','g','Fecha de reclasificación a menor nivel (NR)','Fecha de reclasificación a menor nivel (NR)','',0,0,NULL),(0,0,'355','h','Fecha de desclasificación (NR)','Fecha de desclasificación (NR)','',0,0,NULL),(0,0,'355','j','Autorización (R)','Autorización (R)','',1,0,NULL),(0,0,'357','6','Linkage See','Linkage See','',0,0,NULL),(0,0,'357','8','Field link and sequence number See','Field link and sequence number See','',1,0,NULL),(0,0,'357','a','Rental price (NR)','Rental price (NR)','',0,0,NULL),(0,0,'810','w','Bibliographic Número de control de registro (R)','Bibliographic Número de control de registro (R)','',1,0,NULL),(0,0,'357','b','Originating agency (R)','Originating agency (R)','',1,0,NULL),(0,0,'357','c','Authorized recipients of material (R)','Authorized recipients of material (R)','',1,0,NULL),(0,0,'357','g','Other restrictions (R)','Other restrictions (R)','',1,0,NULL),(0,0,'357','z','Source of information','Source of information','',0,0,NULL),(0,0,'359','a','Rental price (NR)','Rental price (NR)','',0,0,NULL),(0,0,'362','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'362','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'362','a','Fecha de publicación y/o designación secuencial (NR)','Fecha de publicación y/o designación secuencial (NR)','',0,0,NULL),(0,0,'362','z','Fuente de la información (NR)','Fuente de la información (NR)','',0,0,NULL),(0,0,'400','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'400','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'400','8','Vínculo de campo y número de secuencia  (R)','Vínculo de campo y número de secuencia  (R)','',1,0,NULL),(0,0,'400','a','Nombre personal (NR)','Nombre personal (NR)','',0,0,NULL),(0,0,'400','b','Numeración (NR)','Numeración (NR)','',0,0,NULL),(0,0,'400','c','Títulos y otras palabras asociadas con el nombre (R)','Títulos y otras palabras asociadas con el nombre (R)','',1,0,NULL),(0,0,'400','d','Fechas asociadas con el nombre (NR)','Fechas asociadas con el nombre (NR)','',0,0,NULL),(0,0,'400','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'400','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'400','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'400','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'400','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'400','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'400','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'400','q','Forma completa del nombre (NR) [OBSOLETE]','Forma completa del nombre (NR) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'400','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'400','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'400','v','Número de volumen/designación secuencial (NR)','Número de volumen/designación secuencial (NR)','',0,0,NULL),(0,0,'400','x','ISSN  (NR)','ISSN  (NR)','',0,0,NULL),(0,0,'410','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'410','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'410','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'410','a','Nombre corporativo o de jurisdicción como asiento (NR)','Nombre corporativo o de jurisdicción como asiento (NR)','',0,0,NULL),(0,0,'410','b','Unidad subordinada(R)','Unidad subordinada(R)','',1,0,NULL),(0,0,'410','c','Ubicación de la reunión (NR)','Ubicación de la reunión (NR)','',0,0,NULL),(0,0,'410','d','Fecha de la reunión o firma de tratado (R)','Fecha de la reunión o firma de tratado (R)','',1,0,NULL),(0,0,'410','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'410','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'410','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'410','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'410','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'410','n','Número de la parte/sección/reunión (R)','Número de la parte/sección/reunión (R)','',1,0,NULL),(0,0,'410','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'410','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'410','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'410','v','Número de volumen/designación secuencial (NR)','Número de volumen/designación secuencial (NR)','',0,0,NULL),(0,0,'410','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'411','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'411','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'411','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'411','a','Nombre de reunión o nombre de jurisdicción como elemento de asiento (NR)','Nombre de reunión o nombre de jurisdicción como elemento de asiento (NR)','',0,0,NULL),(0,0,'411','b','Number  [OBSOLETE]','Number  [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'411','c','Ubicación de la reunión (NR)','Ubicación de la reunión (NR)','',0,0,NULL),(0,0,'411','d','Fecha de reunión (NR)','Fecha de reunión (NR)','',0,0,NULL),(0,0,'411','e','Unidad subordinada(R)','Unidad subordinada(R)','',1,0,NULL),(0,0,'411','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'411','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'411','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'411','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'411','n','Número de la parte/sección/reunión (R)','Número de la parte/sección/reunión (R)','',1,0,NULL),(0,0,'411','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'411','q','Tipo del nombre de la reunión siguiente al nombre de jurisdicción como asiento (NR)','Tipo del nombre de la reunión siguiente al nombre de jurisdicción como asiento (NR)','',0,0,NULL),(0,0,'411','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'411','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'411','v','Número de volumen/designación secuencial (NR)','Número de volumen/designación secuencial (NR)','',0,0,NULL),(0,0,'411','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'440','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'440','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'440','a','Título (NR)','Título (NR)','',0,0,'biblioitems.seriestitle'),(0,0,'440','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'440','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'440','v','Número del volumen/designación secuencial (NR)','Número del volumen/designación secuencial (NR)','',0,0,NULL),(0,0,'440','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(2,0,'490','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(2,0,'490','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(2,0,'490','a','Mención de serie (R)','Mención de serie (R)','',1,0,NULL),(2,0,'490','l','Número de ubicación en la Biblioteca del Congreso (NR)','Número de ubicación en la Biblioteca del Congreso (NR)','',0,0,NULL),(2,0,'490','v','Número de volumen/designación secuencial (R)','Número de volumen/designación secuencial (R)','',1,0,NULL),(2,0,'490','x','ISSN (R)','ISSN (R)','',1,0,NULL),(0,0,'500','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'500','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'500','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'500','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'500','a','Nota general (NR)','Nota general (NR)','',0,0,'biblioitems.notes'),(0,0,'500','l','Library of Congress call number (SE) [OBSOLETE]','Library of Congress call number (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'500','x','ISSN (SE) [OBSOLETE]','ISSN (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'500','z','Source of note information (AM SE) [OBSOLETE]','Source of note information (AM SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'501','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'501','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'501','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'501','a','Nota de con (NR)','Nota de con (NR)','',0,0,NULL),(0,0,'502','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'502','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'502','a','Nota de tesis (NR)','Nota de tesis (NR)','',0,0,NULL),(0,0,'503','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'503','a','Bibliographic Historia Nota (NR)','Bibliographic Historia Nota (NR)','',0,0,NULL),(0,0,'504','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'504','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'504','a','Nota de bibliografía, etc. (NR)','Nota de bibliografía, etc. (NR)','',0,0,NULL),(0,0,'504','b','Número de referencias (NR)','Número de referencias (NR)','',0,0,NULL),(0,0,'505','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'505','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'505','a','Nota de contenido formateada (NR)','Nota de contenido formateada (NR)','',0,0,NULL),(0,0,'505','g','Información miscelánea (R)','Información miscelánea (R)','',1,0,NULL),(0,0,'505','r','Declaración de responsabilidad (R)','Declaración de responsabilidad (R)','',1,0,NULL),(0,0,'505','t','Título (R)','Título (R)','',1,0,NULL),(0,0,'505','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'506','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'506','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'506','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'506','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'506','a','Términos que gobiernan el acceso (NR)','Términos que gobiernan el acceso (NR)','',0,0,NULL),(0,0,'506','b','Jurisdicción (R)','Jurisdicción (R)','',1,0,NULL),(0,0,'506','c','Provisiones de acceso físico (R)','Provisiones de acceso físico (R)','',1,0,NULL),(0,0,'506','d','Usuarios autorizados (R)','Usuarios autorizados (R)','',1,0,NULL),(0,0,'506','e','Autorización (R)','Autorización (R)','',1,0,NULL),(0,0,'507','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'507','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'507','a','Nota de fracción representativa de escala (NR)','Nota de fracción representativa de escala (NR)','',0,0,NULL),(0,0,'507','b','Nota del resto de la escala (NR)','Nota del resto de la escala (NR)','',0,0,NULL),(0,0,'508','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'508','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'508','a','Nota de créditos de creación/producción (NR)','Nota de créditos de creación/producción (NR)','',0,0,NULL),(0,0,'510','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'510','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'510','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'510','a','Nombre de la fuente (NR)','Nombre de la fuente (NR)','',0,0,NULL),(0,0,'510','b','Cobertura de la fuente (NR)','Cobertura de la fuente (NR)','',0,0,NULL),(0,0,'510','c','Ubicación dentro de la fuente (NR)','Ubicación dentro de la fuente (NR)','',0,0,NULL),(0,0,'510','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'511','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'511','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'511','a','Nota de participante o intérprete (NR)','Nota de participante o intérprete (NR)','',0,0,NULL),(0,0,'512','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'512','a','Earlier or later volumes separately cataloged Nota (NR)','Earlier or later volumes separately cataloged Nota (NR)','',0,0,NULL),(0,0,'513','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'513','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'513','a','Tipo de reporte (NR)','Tipo de reporte (NR)','',0,0,NULL),(0,0,'513','b','Período cubierto (NR)','Período cubierto (NR)','',0,0,NULL),(0,0,'514','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'514','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'514','a','Informe de exactitud del atributo (NR)','Informe de exactitud del atributo (NR)','',0,0,NULL),(0,0,'514','b','Valor de exactitud del atributo (R)','Valor de exactitud del atributo (R)','',1,0,NULL),(0,0,'514','c','Explicación de exactitud del atributo (R)','Explicación de exactitud del atributo (R)','',1,0,NULL),(0,0,'514','d','Informe de consistencia lógica (NR)','Informe de consistencia lógica (NR)','',0,0,NULL),(0,0,'514','e','Informe de exhaustividad (NR)','Informe de exhaustividad (NR)','',0,0,NULL),(0,0,'514','f','Informe de exactitud de la posición horizontal (NR)','Informe de exactitud de la posición horizontal (NR)','',0,0,NULL),(0,0,'514','g','Valor de exactitud de la posición horizontal (R)','Valor de exactitud de la posición horizontal (R)','',1,0,NULL),(0,0,'514','h','Explicación de exactitud de la posición horizontal (R)','Explicación de exactitud de la posición horizontal (R)','',1,0,NULL),(0,0,'514','i','Informe de exactitud de la posición vertical (NR)','Informe de exactitud de la posición vertical (NR)','',0,0,NULL),(0,0,'514','j','Valor de exactitud de la posición vertical (R)','Valor de exactitud de la posición vertical (R)','',1,0,NULL),(0,0,'514','k','Explicación de exactitud de la posición vertical (R)','Explicación de exactitud de la posición vertical (R)','',1,0,NULL),(0,0,'514','m','Cobertura nubosa (NR)','Cobertura nubosa (NR)','',0,0,NULL),(0,0,'514','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'514','z','Mostrar nota (R)','Mostrar nota (R)','',1,0,NULL),(0,0,'515','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'515','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'515','a','Nota sobre las peculiaridades en la numeración (NR)','Nota sobre las peculiaridades en la numeración (NR)','',0,0,NULL),(0,0,'515','z','Source of note information (NR) (SE) [OBSOLETE]','Source of note information (NR) (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'516','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'516','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'516','a','Nota de tipo de archivo o datos de computadora (NR)','Nota de tipo de archivo o datos de computadora (NR)','',0,0,NULL),(0,0,'517','a','Different formats (NR)','Different formats (NR)','',0,0,NULL),(0,0,'517','b','Content descriptors (R)','Content descriptors (R)','',1,0,NULL),(0,0,'517','c','Additional animation techniques (R)','Additional animation techniques (R)','',1,0,NULL),(0,0,'518','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'518','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'518','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'518','a','Nota de fecha/hora y lugar de un acontecimiento (NR)','Nota de fecha/hora y lugar de un acontecimiento (NR)','',0,0,NULL),(0,0,'520','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'520','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'520','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'520','a','Nota de resumen, etc. (NR)','Nota de resumen, etc. (NR)','',0,0,'biblio.abstract'),(0,0,'520','b','Expansión de la nota de resumen (NR)','Expansión de la nota de resumen (NR)','',0,0,NULL),(0,0,'520','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'520','z','Source of note information (NR) [OBSOLETE]','Source of note information (NR) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'521','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'521','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'521','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'521','a','Nota de audiencia (R)','Nota de audiencia (R)','',1,0,NULL),(0,0,'521','b','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'522','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'522','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'522','a','Nota de cobertura geográfica (NR)','Nota de cobertura geográfica (NR)','',0,0,NULL),(0,0,'523','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'523','a','Time period of content Nota (NR)','Time period of content Nota (NR)','',0,0,NULL),(0,0,'523','b','Dates of data collection Nota (NR)','Dates of data collection Nota (NR)','',0,0,NULL),(0,0,'524','2','Fuente del esquema usado (NR)','Fuente del esquema usado (NR)','',0,0,NULL),(0,0,'524','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'524','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'524','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'524','a','Nota de forma preferida de citación de los materiales descritos (NR)','Nota de forma preferida de citación de los materiales descritos (NR)','',0,0,NULL),(0,0,'525','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'525','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'525','a','Nota del suplemento (NR)','Nota del suplemento (NR)','',0,0,NULL),(0,0,'525','z','Source of note information (NR) (SE) [OBSOLETE]','Source of note information (NR) (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'526','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'526','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'526','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'526','a','Nombre del programa (NR)','Nombre del programa (NR)','',0,0,NULL),(0,0,'526','b','Nivel de interés (NR)','Nivel de interés (NR)','',0,0,NULL),(0,0,'526','c','Nivel de lectura (NR)','Nivel de lectura (NR)','',0,0,NULL),(0,0,'526','d','Puntuación del título (NR)','Puntuación del título (NR)','',0,0,NULL),(0,0,'526','i','Texto a desplegar (NR)','Texto a desplegar (NR)','',0,0,NULL),(0,0,'526','x','Nota sin despliegue público (R)','Nota sin despliegue público (R)','',1,0,NULL),(0,0,'526','z','Nota con despliegue público (R)','Nota con despliegue público (R)','',1,0,NULL),(0,0,'527','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'527','a','Censorship Nota (NR)','Censorship Nota (NR)','',0,0,NULL),(0,0,'530','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'530','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'530','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'530','a','Nota de formato físico adicional disponible (NR)','Nota de formato físico adicional disponible (NR)','',0,0,NULL),(0,0,'530','b','Fuente de disponibilidad (NR)','Fuente de disponibilidad (NR)','',0,0,NULL),(0,0,'530','c','Condiciones de disponibilidad (NR)','Condiciones de disponibilidad (NR)','',0,0,NULL),(0,0,'530','d','Número de pedido (NR)','Número de pedido (NR)','',0,0,NULL),(0,0,'530','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'530','z','Source of note information (NR) (AM CF VM SE) [OBSOLETE]','Source of note information (NR) (AM CF VM SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'533','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'533','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'533','7','Elementos de la reproducción de longitud fija (NR)','Elementos de la reproducción de longitud fija (NR)','',0,0,NULL),(0,0,'533','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'533','a','Tipo de reproducción (NR)','Tipo de reproducción (NR)','',0,0,NULL),(0,0,'533','b','Lugar de reproducción (R)','Lugar de reproducción (R)','',1,0,NULL),(0,0,'533','c','Agencia responsable de la reproducción (R)','Agencia responsable de la reproducción (R)','',1,0,NULL),(0,0,'533','d','Fecha de la reproducción (NR)','Fecha de la reproducción (NR)','',0,0,NULL),(0,0,'533','e','Descripción física de la reproducción (NR)','Descripción física de la reproducción (NR)','',0,0,NULL),(0,0,'533','f','Mención de serie de la reproducción (R)','Mención de serie de la reproducción (R)','',1,0,NULL),(0,0,'533','m','Fechas de publicación y/o designación secuencial de los números reproducidos (R)','Fechas de publicación y/o designación secuencial de los números reproducidos (R)','',1,0,NULL),(0,0,'533','n','Nota sobre reproducción (R)','Nota sobre reproducción (R)','',1,0,NULL),(0,0,'534','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'534','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'534','a','Asiento principal del original (NR)','Asiento principal del original (NR)','',0,0,'biblio.notes'),(0,0,'534','b','Mención de edición del original (NR)','Mención de edición del original (NR)','',0,0,NULL),(0,0,'534','c','Publicación, distribución, etc. del original (NR)','Publicación, distribución, etc. del original (NR)','',0,0,NULL),(0,0,'534','e','Descripción física, etc. del original (NR)','Descripción física, etc. del original (NR)','',0,0,NULL),(0,0,'534','f','Mención de serie del original (R)','Mención de serie del original (R)','',1,0,NULL),(0,0,'534','k','Título clave del original (R)','Título clave del original (R)','',1,0,NULL),(0,0,'534','l','Ubicación del original (NR)','Ubicación del original (NR)','',0,0,NULL),(0,0,'534','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'534','n','Nota sobre el original (R)','Nota sobre el original (R)','',1,0,NULL),(0,0,'534','p','Frase introductoria (NR)','Frase introductoria (NR)','',0,0,NULL),(0,0,'534','t','Mención de título del original (NR)','Mención de título del original (NR)','',0,0,NULL),(0,0,'534','x','ISSN (R)','ISSN (R)','',1,0,NULL),(0,0,'534','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'535','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'535','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'535','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'535','a','Custodio (NR)','Custodio (NR)','',0,0,NULL),(0,0,'535','b','Dirección postal (R)','Dirección postal (R)','',1,0,NULL),(0,0,'535','c','País (R)','País (R)','',1,0,NULL),(0,0,'535','d','Dirección de telecomunicación (R)','Dirección de telecomunicación (R)','',1,0,NULL),(0,0,'535','g','Código de localización del repositorio (NR)','Código de localización del repositorio (NR)','',0,0,NULL),(0,0,'536','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'536','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'536','a','Texto de la nota (NR)','Texto de la nota (NR)','',0,0,NULL),(0,0,'536','b','Número de contrato (R)','Número de contrato (R)','',1,0,NULL),(0,0,'536','c','Número de subvención (R)','Número de subvención (R)','',1,0,NULL),(0,0,'536','d','Número no diferenciado (R)','Número no diferenciado (R)','',1,0,NULL),(0,0,'536','e','Número de elemento de programa (R)','Número de elemento de programa (R)','',1,0,NULL),(0,0,'536','f','Número de proyecto (R)','Número de proyecto (R)','',1,0,NULL),(0,0,'536','g','Número de tarea (R)','Número de tarea (R)','',1,0,NULL),(0,0,'536','h','Número de unidad de trabajo (R)','Número de unidad de trabajo (R)','',1,0,NULL),(0,0,'537','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'537','a','Source of data Nota (NR)','Source of data Nota (NR)','',0,0,NULL),(0,0,'538','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'538','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'538','a','Nota sobre detalles del sistema (NR)','Nota sobre detalles del sistema (NR)','',0,0,NULL),(0,0,'540','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'540','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'540','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'540','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'540','a','Términos que regulan el uso y reproducción (NR)','Términos que regulan el uso y reproducción (NR)','',0,0,NULL),(0,0,'540','b','Jurisdicción (NR)','Jurisdicción (NR)','',0,0,NULL),(0,0,'540','c','Autorización (NR)','Autorización (NR)','',0,0,NULL),(0,0,'540','d','Usuarios autorizados (NR)','Usuarios autorizados (NR)','',0,0,NULL),(0,0,'541','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'541','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'541','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'541','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'541','a','Fuente de adquisición (NR)','Fuente de adquisición (NR)','',0,0,NULL),(0,0,'541','b','Dirección (NR)','Dirección (NR)','',0,0,NULL),(0,0,'541','c','Método de adquisición (NR)','Método de adquisición (NR)','',0,0,NULL),(0,0,'541','d','Fecha de adquisición (NR)','Fecha de adquisición (NR)','',0,0,NULL),(0,0,'541','e','Número de acceso (NR)','Número de acceso (NR)','',0,0,NULL),(0,0,'541','f','Propietario (NR)','Propietario (NR)','',0,0,NULL),(0,0,'541','h','Precio de compra (NR)','Precio de compra (NR)','',0,0,NULL),(0,0,'541','n','Extensión (R)','Extensión (R)','',1,0,NULL),(0,0,'541','o','Tipo de unidad (R)','Tipo de unidad (R)','',1,0,NULL),(0,0,'543','6','Linkage (NR)','Linkage (NR)','',0,0,NULL),(0,0,'543','a','Solicitation information note (NR)','Solicitation information note (NR)','',0,0,NULL),(0,0,'544','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'544','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'544','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'544','a','Custodio (R)','Custodio (R)','',1,0,NULL),(0,0,'544','b','Dirección (R)','Dirección (R)','',1,0,NULL),(0,0,'544','c','País (R)','País (R)','',1,0,NULL),(0,0,'544','d','Título (R)','Título (R)','',1,0,NULL),(0,0,'544','e','Provenance (R)','Provenance (R)','',1,0,NULL),(0,0,'544','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'545','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'545','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'545','a','Nota biográfica o histórica (NR)','Nota biográfica o histórica (NR)','',0,0,NULL),(0,0,'545','b','Expansión (NR)','Expansión (NR)','',0,0,NULL),(0,0,'545','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'546','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'546','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'546','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'546','a','Nota de idioma (NR)','Nota de idioma (NR)','',0,0,NULL),(0,0,'546','b','Información sobre códigos o alfabetos (R)','Información sobre códigos o alfabetos (R)','',1,0,NULL),(0,0,'546','z','Source of note information (NR) (SE) [OBSOLETE]','Source of note information (NR) (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'547','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'547','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'547','a','Nota compleja sobre título anterior (NR)','Nota compleja sobre título anterior (NR)','',0,0,NULL),(0,0,'547','z','Source of note information (NR) (SE) [OBSOLETE]','Source of note information (NR) (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'550','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'550','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'550','a','Nota sobre entidad emisora (NR)','Nota sobre entidad emisora (NR)','',0,0,NULL),(0,0,'550','z','Source of note information (NR) (SE) [OBSOLETE]','Source of note information (NR) (SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'552','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'552','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'552','a','Etiqueta de tipo de entidad (NR)','Etiqueta de tipo de entidad (NR)','',0,0,NULL),(0,0,'552','b','Definición y fuente de tipo de entidad (NR)','Definición y fuente de tipo de entidad (NR)','',0,0,NULL),(0,0,'552','c','Etiqueta de atributo (NR)','Etiqueta de atributo (NR)','',0,0,NULL),(0,0,'552','d','Definición y fuente de atributo (NR)','Definición y fuente de atributo (NR)','',0,0,NULL),(0,0,'552','e','Valor de dominio enumerado (R)','Valor de dominio enumerado (R)','',1,0,NULL),(0,0,'552','f','Definición y fuente de valor de dominio enumerado (R)','Definición y fuente de valor de dominio enumerado (R)','',1,0,NULL),(0,0,'552','g','Mínimo y máximo de dominio de rango (NR)','Mínimo y máximo de dominio de rango (NR)','',0,0,NULL),(0,0,'552','h','Nombre y fuente del grupo de caracteres (NR)','Nombre y fuente del grupo de caracteres (NR)','',0,0,NULL),(0,0,'552','i','Dominio no representable (NR)','Dominio no representable (NR)','',0,0,NULL),(0,0,'552','j','Unidades de medida y resolución del atributo (NR)','Unidades de medida y resolución del atributo (NR)','',0,0,NULL),(0,0,'552','k','Fecha de inicio y de fin de los valores de atributo (NR)','Fecha de inicio y de fin de los valores de atributo (NR)','',0,0,NULL),(0,0,'552','l','Precisión del valor del atributo (NR)','Precisión del valor del atributo (NR)','',0,0,NULL),(0,0,'552','m','Explicación de la precisión del valor del atributo (NR)','Explicación de la precisión del valor del atributo (NR)','',0,0,NULL),(0,0,'552','n','Frecuencia de la medición del atributo (NR)','Frecuencia de la medición del atributo (NR)','',0,0,NULL),(0,0,'552','o','Visión general de entidad y atributo (R)','Visión general de entidad y atributo (R)','',1,0,NULL),(0,0,'552','p','Cita detallada de entidad y atributo (R)','Cita detallada de entidad y atributo (R)','',1,0,NULL),(0,0,'552','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'552','z','Mostrar nota (R)','Mostrar nota (R)','',1,0,NULL),(0,0,'555','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'555','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'555','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'555','a','Nota de ayuda acumulativa de índice/búsqueda (NR)','Nota de ayuda acumulativa de índice/búsqueda (NR)','',0,0,NULL),(0,0,'555','b','Fuente de disponibilidad (R)','Fuente de disponibilidad (R)','',1,0,NULL),(0,0,'555','c','Grado de control (NR)','Grado de control (NR)','',0,0,NULL),(0,0,'555','d','Referencia bibliográfica (NR)','Referencia bibliográfica (NR)','',0,0,NULL),(0,0,'555','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'556','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'556','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'556','a','Nota informativa sobre documentación (NR)','Nota informativa sobre documentación (NR)','',0,0,NULL),(0,0,'556','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'561','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'561','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'561','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'561','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'561','a','Historia (NR)','Historia (NR)','',0,0,NULL),(0,0,'561','b','Time of collation (NR) [OBSOLETE]','Time of collation (NR) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'562','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'562','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'562','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'562','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'562','a','Marcas identificativas (R)','Marcas identificativas (R)','',1,0,NULL),(0,0,'562','b','Identificación de copia (R)','Identificación de copia (R)','',1,0,NULL),(0,0,'562','c','Identificación de versión (R)','Identificación de versión (R)','',1,0,NULL),(0,0,'562','d','Formato de presentación (R)','Formato de presentación (R)','',1,0,NULL),(0,0,'562','e','Número de copias (R)','Número de copias (R)','',1,0,NULL),(0,0,'565','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'565','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'565','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'565','a','Número de casos/variables (NR)','Número de casos/variables (NR)','',0,0,NULL),(0,0,'565','b','Nombre de la variable (R)','Nombre de la variable (R)','',1,0,NULL),(0,0,'565','c','Unidad de análisis (R)','Unidad de análisis (R)','',1,0,NULL),(0,0,'565','d','Universo de los datos (R)','Universo de los datos (R)','',1,0,NULL),(0,0,'565','e','Esquema o código con que se archiva (R)','Esquema o código con que se archiva (R)','',1,0,NULL),(0,0,'567','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'567','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'567','a','Nota sobre metodología (NR)','Nota sobre metodología (NR)','',0,0,NULL),(0,0,'570','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'570','a','Editor Nota (NR)','Editor Nota (NR)','',0,0,NULL),(0,0,'570','z','Source of note information (NR)','Source of note information (NR)','',0,0,NULL),(0,0,'580','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'580','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'580','a','Nota compleja de enlaces de asientos (NR)','Nota compleja de enlaces de asientos (NR)','',0,0,NULL),(0,0,'580','z','Source of note information (NR) [OBSOLETE]','Source of note information (NR) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'581','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'581','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'581','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'581','a','Nota sobre publicaciones sobre el material descrito (NR)','Nota sobre publicaciones sobre el material descrito (NR)','',0,0,NULL),(0,0,'581','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'582','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'582','a','Related computer files Nota (NR)','Related computer files Nota (NR)','',0,0,NULL),(0,0,'583','2','Fuente del término (NR)','Fuente del término (NR)','',0,0,NULL),(0,0,'583','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'583','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'583','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'583','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'583','a','Acción (NR)','Acción (NR)','',0,0,NULL),(0,0,'583','b','Identificación de acción (R)','Identificación de acción (R)','',1,0,NULL),(0,0,'583','c','Fecha/hora de acción (R)','Fecha/hora de acción (R)','',1,0,NULL),(0,0,'583','d','Intervalo de acción (R)','Intervalo de acción (R)','',1,0,NULL),(0,0,'583','e','Contingencia de acción (R)','Contingencia de acción (R)','',1,0,NULL),(0,0,'583','f','Autorización (R)','Autorización (R)','',1,0,NULL),(0,0,'583','h','Jurisdicción (R)','Jurisdicción (R)','',1,0,NULL),(0,0,'583','i','Método de acción (R)','Método de acción (R)','',1,0,NULL),(0,0,'583','j','Sitio de acción (R)','Sitio de acción (R)','',1,0,NULL),(0,0,'583','k','Agente de acción (R)','Agente de acción (R)','',1,0,NULL),(0,0,'583','l','Estado (R)','Estado (R)','',1,0,NULL),(0,0,'583','n','Extensión (R)','Extensión (R)','',1,0,NULL),(0,0,'583','o','Tipo de unidad (R)','Tipo de unidad (R)','',1,0,NULL),(0,0,'583','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'583','x','Nota no pública (R)','Nota no pública (R)','',1,0,NULL),(0,0,'583','z','Nota pública (R)','Nota pública (R)','',1,0,NULL),(0,0,'584','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'584','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'584','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'584','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'584','a','Acumulación (R)','Acumulación (R)','',1,0,NULL),(0,0,'584','b','Frecuencia de uso (R)','Frecuencia de uso (R)','',1,0,NULL),(0,0,'585','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'585','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'585','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'585','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'585','a','Nota sobre exposiciones (NR)','Nota sobre exposiciones (NR)','',0,0,NULL),(0,0,'586','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'586','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'586','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'586','a','Nota de premios (NR)','Nota de premios (NR)','',0,0,NULL),(0,0,'590','a','Receipt Fecha (NR)','Receipt Fecha (NR)','',0,0,NULL),(0,0,'590','b','Provenance (NR)','Provenance (NR)','',0,0,NULL),(0,0,'590','d','Origin of safety copy (NR)','Origin of safety copy (NR)','',0,0,NULL),(0,0,'600','2','Fuente del encabezado o término (NR)','Fuente del encabezado o término (NR)','',0,0,NULL),(0,0,'600','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'600','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'600','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'600','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'600','a','Nombre personal (NR)','Nombre personal (NR)','',0,0,NULL),(0,0,'600','b','Numeración (NR)','Numeración (NR)','',0,0,NULL),(0,0,'600','c','Títulos y otras palabras asociadas con el nombre (R)','Títulos y otras palabras asociadas con el nombre (R)','',1,0,NULL),(0,0,'600','d','Fechas asociadas con el nombre (NR)','Fechas asociadas con el nombre (NR)','',0,0,NULL),(0,0,'600','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'600','f','Fecha de una obra (NR)','Fecha de una obra (NR)','',0,0,NULL),(0,0,'600','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'600','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'600','j','Calificador de atribución (R)','Calificador de atribución (R)','',1,0,NULL),(0,0,'600','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'600','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'600','m','Medio de interpretación para música (R)','Medio de interpretación para música (R)','',1,0,NULL),(0,0,'600','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'600','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'600','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'600','q','Forma completa del nombre (NR)','Forma completa del nombre (NR)','',0,0,NULL),(0,0,'600','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'600','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'600','t','Título del trabajo (NR)','Título del trabajo (NR)','',0,0,NULL),(0,0,'600','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'600','v','Subdivisión de forma (R)','Subdivisión de forma (R)','',1,0,NULL),(0,0,'600','x','Subdivisión general (R)','Subdivisión general (R)','',1,0,NULL),(0,0,'600','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'600','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'610','2','Fuente del encabezado o término (NR)','Fuente del encabezado o término (NR)','',0,0,NULL),(0,0,'610','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'610','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'610','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'610','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'610','a','Nombre corporativo o de jurisdicción como asiento (NR)','Nombre corporativo o de jurisdicción como asiento (NR)','',0,0,NULL),(0,0,'610','b','Unidad subordinada (R)','Unidad subordinada (R)','',1,0,NULL),(0,0,'610','c','Ubicación de reunión (NR)','Ubicación de reunión (NR)','',0,0,NULL),(0,0,'610','d','Fecha de reunión o firma de tratado (R)','Fecha de reunión o firma de tratado (R)','',1,0,NULL),(0,0,'610','e','Relación (R)','Relación (R)','',1,0,NULL),(0,0,'610','f','Fecha de una obra (NR)','Fecha de una obra (NR)','',0,0,NULL),(0,0,'610','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'610','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'610','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'610','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'610','m','Medio de interpretación de música (R)','Medio de interpretación de música (R)','',1,0,NULL),(0,0,'610','n','Número de parte/sección/reunión (R)','Número de parte/sección/reunión (R)','',1,0,NULL),(0,0,'610','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'610','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'610','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'610','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'610','t','Título del trabajo (NR)','Título del trabajo (NR)','',0,0,NULL),(0,0,'610','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'610','v','Subdivisión de forma (R)','Subdivisión de forma (R)','',1,0,NULL),(0,0,'610','x','Subdivisión general (R)','Subdivisión general (R)','',1,0,NULL),(0,0,'610','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'610','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'611','2','Fuente del encabezado o término (NR)','Fuente del encabezado o término (NR)','',0,0,NULL),(0,0,'611','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'611','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'611','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'611','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'611','a','Nombre de la reunión o jurisdicción como elemento ingresado (NR)','Nombre de la reunión o jurisdicción como elemento ingresado (NR)','',0,0,NULL),(0,0,'611','b','Número (BK CF MP MU SE VM MX) [OBSOLETE]','Número (BK CF MP MU SE VM MX) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'611','c','Lugar de la reunión (NR)','Lugar de la reunión (NR)','',0,0,NULL),(0,0,'611','d','Fecha de la reunión (NR)','Fecha de la reunión (NR)','',0,0,NULL),(0,0,'611','e','Unidad subordinada (R)','Unidad subordinada (R)','',1,0,NULL),(0,0,'611','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'611','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'611','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'611','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'611','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'611','n','Número de la parte/sección/reunión (R)','Número de la parte/sección/reunión (R)','',1,0,NULL),(0,0,'611','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'611','q','Nombre de la reunión luego del elemento de asiento del nombre de la jurisdicción (NR)','Nombre de la reunión luego del elemento de asiento del nombre de la jurisdicción (NR)','',0,0,NULL),(0,0,'611','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'611','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'611','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'611','v','Subdivisión de forma (R)','Subdivisión de forma (R)','',1,0,NULL),(0,0,'611','x','Subdivisión general (R)','Subdivisión general (R)','',1,0,NULL),(0,0,'611','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'611','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'630','2','Fuente del encabezado o término (NR)','Fuente del encabezado o término (NR)','',0,0,NULL),(0,0,'630','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'630','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'630','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'630','a','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'630','d','Fecha de firma del tratado (R)','Fecha de firma del tratado (R)','',1,0,NULL),(0,0,'630','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'630','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'630','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'630','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'630','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'630','m','Medio de interpretación de la música (R)','Medio de interpretación de la música (R)','',1,0,NULL),(0,0,'630','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'630','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'630','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'630','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'630','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'630','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'630','v','Subdivisión de forma (R)','Subdivisión de forma (R)','',1,0,NULL),(0,0,'630','x','Subdivisión general (R)','Subdivisión general (R)','',1,0,NULL),(0,0,'630','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'630','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'650','2','Fuente del encabezado o término (NR)','Fuente del encabezado o término (NR)','',0,0,NULL),(0,0,'650','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'650','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'650','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'650','a','Término temático o nombre geográfico como elemento ingresado (NR)','Término temático o nombre geográfico como elemento ingresado (NR)','',0,0,'bibliosubject.subject'),(0,0,'650','b','Término temático subsiguiente a nombre geográfico como elemento ingresado (NR)','Término temático subsiguiente a nombre geográfico como elemento ingresado (NR)','',0,0,NULL),(0,0,'650','c','Lugar del evento (NR)','Lugar del evento (NR)','',0,0,NULL),(0,0,'650','d','Fechas activas (NR)','Fechas activas (NR)','',0,0,NULL),(0,0,'650','e','Término de relación (NR)','Término de relación (NR)','',0,0,NULL),(0,0,'650','v','Subdivisión de forma (R)','Subdivisión de forma (R)','',1,0,NULL),(0,0,'650','x','Subdivisión general (R)','Subdivisión general (R)','',1,0,NULL),(0,0,'650','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'650','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'651','2','Fuente del encabezado o término (NR)','Fuente del encabezado o término (NR)','',0,0,NULL),(0,0,'651','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'651','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'651','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'651','a','Nombre geográfico (NR)','Nombre geográfico (NR)','',0,0,NULL),(0,0,'651','b','Nombre geográfico siguiente al elemento de asiento de lugar (R) [OBSOLETE]','Nombre geográfico siguiente al elemento de asiento de lugar (R) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'651','v','Subdivisión de forma (R)','Subdivisión de forma (R)','',1,0,NULL),(0,0,'651','x','Subdivisión general (R)','Subdivisión general (R)','',1,0,NULL),(0,0,'651','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'651','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'652','a','Geographic name of place element (NR)','Geographic name of place element (NR)','',0,0,NULL),(0,0,'652','x','Subdivisión general (R)','Subdivisión general (R)','',1,0,NULL),(0,0,'652','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'652','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'653','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'653','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'653','a','Término no controlado (R)','Término no controlado (R)','',1,0,NULL),(0,0,'654','2','Fuente del encabezado o término (NR)','Fuente del encabezado o término (NR)','',0,0,NULL),(0,0,'654','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'654','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'654','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'654','a','Término temático principal (R)','Término temático principal (R)','',1,0,NULL),(0,0,'654','b','Término temático no principal  (R)','Término temático no principal  (R)','',1,0,NULL),(0,0,'654','c','Designación de faceta/jerarquía (R)','Designación de faceta/jerarquía (R)','',1,0,NULL),(0,0,'654','v','Subdivisión de forma (R)','Subdivisión de forma (R)','',1,0,NULL),(0,0,'654','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'654','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'655','2','Fuente del término (NR)','Fuente del término (NR)','',0,0,NULL),(0,0,'655','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'655','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'655','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'655','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'655','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'655','a','Datos de género/forma o término temático principal (NR)','Datos de género/forma o término temático principal (NR)','',0,0,NULL),(0,0,'655','b','Término temático no principal (R)','Término temático no principal (R)','',1,0,NULL),(0,0,'655','c','Designación de faceta/jerarquía (R)','Designación de faceta/jerarquía (R)','',1,0,NULL),(0,0,'655','v','Subdivisión de forma (R)','Subdivisión de forma (R)','',1,0,NULL),(0,0,'655','x','Subdivisión general (R)','Subdivisión general (R)','',1,0,NULL),(0,0,'655','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'655','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'656','2','Fuente del término (NR)','Fuente del término (NR)','',0,0,NULL),(0,0,'656','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'656','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'656','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'656','a','Ocupación (NR)','Ocupación (NR)','',0,0,NULL),(0,0,'656','k','Forma (NR)','Forma (NR)','',0,0,NULL),(0,0,'656','v','Subdivisión de forma (R)','Subdivisión de forma (R)','',1,0,NULL),(0,0,'656','x','Subdivisión general (R)','Subdivisión general (R)','',1,0,NULL),(0,0,'656','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'656','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'657','2','Fuente del término (NR)','Fuente del término (NR)','',0,0,NULL),(0,0,'657','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'657','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'657','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'657','a','Función (NR)','Función (NR)','',0,0,NULL),(0,0,'657','v','Subdivisión de forma (R)','Subdivisión de forma (R)','',1,0,NULL),(0,0,'657','x','Subdivisión general (R)','Subdivisión general (R)','',1,0,NULL),(0,0,'657','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'657','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'658','2','Fuente del término o código (NR)','Fuente del término o código (NR)','',0,0,NULL),(0,0,'658','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'658','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'658','a','Objetivo principal del currículo (NR)','Objetivo principal del currículo (NR)','',0,0,NULL),(0,0,'658','b','Objetivo subordinado del currículo (R)','Objetivo subordinado del currículo (R)','',1,0,NULL),(0,0,'658','c','Código del currículo (NR)','Código del currículo (NR)','',0,0,NULL),(0,0,'658','d','Factor de correlación (NR)','Factor de correlación (NR)','',0,0,NULL),(0,0,'700','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'700','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'700','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'700','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'700','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'700','a','Nombre personal (NR)','Nombre personal (NR)','',0,0,'additionalauthors.author'),(0,0,'700','b','Numeración (NR)','Numeración (NR)','',0,0,NULL),(0,0,'700','c','Títulos y otras palabras asociadas con el nombre (R)','Títulos y otras palabras asociadas con el nombre (R)','',1,0,NULL),(0,0,'700','d','Fechas asociadas con el nombre (NR)','Fechas asociadas con el nombre (NR)','',0,0,NULL),(0,0,'700','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'700','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'700','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'700','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'700','j','Calificador de atributo (R)','Calificador de atributo (R)','',1,0,NULL),(0,0,'700','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'700','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'700','m','Medio de interpretación de la música (R)','Medio de interpretación de la música (R)','',1,0,NULL),(0,0,'700','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'700','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'700','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'700','q','Forma completa del nombre (NR)','Forma completa del nombre (NR)','',0,0,NULL),(0,0,'700','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'700','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'700','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'700','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'700','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'705','a','Personal name (NR)','Personal name (NR)','',0,0,NULL),(0,0,'705','b','Numeración (NR)','Numeración (NR)','',0,0,NULL),(0,0,'705','c','Titles and other words associated with a name (R)','Titles and other words associated with a name (R)','',1,0,NULL),(0,0,'705','d','Dates associated with a name (NR)','Dates associated with a name (NR)','',0,0,NULL),(0,0,'705','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'705','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'705','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'705','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'705','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'705','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'705','m','Medio de interpretación de la música (R)','Medio de interpretación de la música (R)','',1,0,NULL),(0,0,'705','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'705','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'705','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'705','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'705','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'705','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'710','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'710','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'710','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'710','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'710','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'710','a','Nombre corporativo o de jurisdicción como asiento (NR)','Nombre corporativo o de jurisdicción como asiento (NR)','',0,0,NULL),(0,0,'710','b','Unidad subordinada (R)','Unidad subordinada (R)','',1,0,NULL),(0,0,'710','c','Ubicación de la reunión (NR)','Ubicación de la reunión (NR)','',0,0,NULL),(0,0,'710','d','Fecha de la reunión o firma de tratado (R)','Fecha de la reunión o firma de tratado (R)','',1,0,NULL),(0,0,'710','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'710','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'710','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'710','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'710','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'710','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'710','m','Medio de interpretación de la música (R)','Medio de interpretación de la música (R)','',1,0,NULL),(0,0,'710','n','Número de la parte/sección/reunión (R)','Número de la parte/sección/reunión (R)','',1,0,NULL),(0,0,'710','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'710','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'710','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'710','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'710','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'710','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'710','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'711','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'711','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'711','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'711','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'711','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'711','a','Tipo del nombre de la reunión o nombre de jurisdicción como asiento (NR)','Tipo del nombre de la reunión o nombre de jurisdicción como asiento (NR)','',0,0,NULL),(0,0,'711','b','Número (BK CF MP MU SE VM MX) [OBSOLETE]','Número (BK CF MP MU SE VM MX) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'711','c','Ubicación de la reunión (NR)','Ubicación de la reunión (NR)','',0,0,NULL),(0,0,'711','d','Fecha de la reunión (NR)','Fecha de la reunión (NR)','',0,0,NULL),(0,0,'711','j','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'711','e','Unidad subordinada (R)','Unidad subordinada (R)','',1,0,NULL),(0,0,'711','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'711','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'711','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'711','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'711','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'711','n','Número de la parte/sección/reunión (R)','Número de la parte/sección/reunión (R)','',1,0,NULL),(0,0,'711','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'711','q','Tipo del nombre de la reunión siguiente al nombre de jurisdicción como asiento (NR)','Tipo del nombre de la reunión siguiente al nombre de jurisdicción como asiento (NR)','',0,0,NULL),(0,0,'711','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'711','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'711','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'711','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'715','a','Corporate name or Nombre de jurisdicción (NR)','Corporate name or Nombre de jurisdicción (NR)','',0,0,NULL),(0,0,'715','b','Unidad subordinada(R)','Unidad subordinada(R)','',1,0,NULL),(0,0,'715','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'715','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'715','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'715','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'715','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'715','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'715','m','Medio de interpretación de la música (R)','Medio de interpretación de la música (R)','',1,0,NULL),(0,0,'715','n','Número de la parte/sección/reunión (R)','Número de la parte/sección/reunión (R)','',1,0,NULL),(0,0,'715','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'715','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'715','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'715','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'715','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'715','u','Nonprinting information (NR)','Nonprinting information (NR)','',0,0,NULL),(0,0,'720','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'720','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'720','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'720','a','Nombre (NR)','Nombre (NR)','',0,0,NULL),(0,0,'720','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'730','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'730','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'730','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'730','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'730','a','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'730','d','Fecha de firma de tratado (R)','Fecha de firma de tratado (R)','',1,0,NULL),(0,0,'730','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'730','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'730','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'730','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'730','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'730','m','Medio de interpretación de la música (R)','Medio de interpretación de la música (R)','',1,0,NULL),(0,0,'730','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'730','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'730','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'730','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'730','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'730','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'730','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'740','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'740','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'740','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'740','a','Título analítico/relacionado no controlado (NR)','Título analítico/relacionado no controlado (NR)','',0,0,'biblioitems.volumeddesc'),(0,0,'740','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'740','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,'biblioitems.volume'),(0,0,'740','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'752','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'752','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'752','a','País o entidad mayor (R)','País o entidad mayor (R)','',1,0,NULL),(0,0,'752','b','Jurisdicción política de primer orden (NR)','Jurisdicción política de primer orden (NR)','',0,0,NULL),(0,0,'752','c','Jurisdicción política intermedia (R)','Jurisdicción política intermedia (R)','',1,0,NULL),(0,0,'752','d','Ciudad (NR)','Ciudad (NR)','',0,0,NULL),(0,0,'753','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'753','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'753','a','Marca y modelo de la máquina (NR)','Marca y modelo de la máquina (NR)','',0,0,NULL),(0,0,'753','b','Lenguaje de programación (NR)','Lenguaje de programación (NR)','',0,0,NULL),(0,0,'753','c','Sistema operativo (NR)','Sistema operativo (NR)','',0,0,NULL),(0,0,'754','2','Fuente de identificación taxonómica (NR)','Fuente de identificación taxonómica (NR)','',0,0,NULL),(0,0,'754','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'754','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'754','a','Nombre taxonómico (R)','Nombre taxonómico (R)','',1,0,NULL),(0,0,'754','x','Nota no pública (R)','Nota no pública (R)','',1,0,NULL),(0,0,'755','2','Fuente del término (NR)','Fuente del término (NR)','',0,0,NULL),(0,0,'755','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'755','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'755','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'755','a','Access term (NR)','Access term (NR)','',0,0,NULL),(0,0,'755','x','Subdivisión general (R)','Subdivisión general (R)','',1,0,NULL),(0,0,'755','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'755','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'760','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'760','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'760','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'760','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'760','a','Asiento principal de serie (NR)','Asiento principal de serie (NR)','',0,0,NULL),(0,0,'760','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'760','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'760','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'760','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'760','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'760','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'760','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'760','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'760','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'760','q','Título paralelo (NR) (BK SE) [OBSOLETE]','Título paralelo (NR) (BK SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'760','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'760','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'760','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'760','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'760','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'762','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'762','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'762','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'762','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'762','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'762','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'762','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'762','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'762','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'762','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'762','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'762','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'762','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'762','q','Título paralelo (NR) (BK SE) [OBSOLETE]','Título paralelo (NR) (BK SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'762','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'762','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'762','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'762','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'762','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'765','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'765','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'765','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'765','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'765','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'765','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'765','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'765','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'765','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'765','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'765','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'765','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'765','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'765','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'765','q','Título paralelo (NR) (BK SE) [OBSOLETE]','Título paralelo (NR) (BK SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'765','r','Número de reporte (R)','Número de reporte (R)','',1,0,NULL),(0,0,'765','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'765','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'765','u','Número de reporte técnico estándar (NR)','Número de reporte técnico estándar (NR)','',0,0,NULL),(0,0,'765','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'765','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'765','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'765','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'767','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'767','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'767','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'767','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'767','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'767','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'767','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'767','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'767','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'767','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'767','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'767','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'767','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'767','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'767','q','Título paralelo (NR) (BK SE) [OBSOLETE]','Título paralelo (NR) (BK SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'767','r','Número de reporte (R)','Número de reporte (R)','',1,0,NULL),(0,0,'767','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'767','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'767','u','Número de reporte técnico estándar (NR)','Número de reporte técnico estándar (NR)','',0,0,NULL),(0,0,'767','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'767','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'767','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'767','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'770','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'770','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'770','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'770','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'770','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'770','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'770','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'770','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'770','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'770','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'770','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'770','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'770','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'770','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'770','q','Título paralelo (NR) (BK SE) [OBSOLETE]','Título paralelo (NR) (BK SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'770','r','Número de reporte (R)','Número de reporte (R)','',1,0,NULL),(0,0,'770','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'770','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'770','u','Número de reporte técnico estándar (NR)','Número de reporte técnico estándar (NR)','',0,0,NULL),(0,0,'770','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'770','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'770','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'770','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'772','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'772','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'772','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'772','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'772','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'772','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'772','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'772','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'772','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'772','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'772','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'772','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'772','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'772','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'772','q','Título paralelo (NR) (BK SE) [OBSOLETE]','Título paralelo (NR) (BK SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'772','r','Número de reporte (R)','Número de reporte (R)','',1,0,NULL),(0,0,'772','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'772','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'772','u','Número de reporte técnico estándar (NR)','Número de reporte técnico estándar (NR)','',0,0,NULL),(0,0,'772','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'772','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'772','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'772','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'773','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'773','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'773','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'773','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'773','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'773','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'773','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'773','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'773','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'773','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'773','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'773','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'773','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'773','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'773','p','Título abreviado (NR)','Título abreviado (NR)','',0,0,NULL),(0,0,'773','r','Número de reporte (R)','Número de reporte (R)','',1,0,NULL),(0,0,'773','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'773','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'773','u','Número de reporte técnico estándar (NR)','Número de reporte técnico estándar (NR)','',0,0,NULL),(0,0,'773','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'773','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'773','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'773','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'774','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'774','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'774','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'774','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'774','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'774','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'774','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'774','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'774','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'774','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'774','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'774','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'774','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'774','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'774','r','Número de reporte (R)','Número de reporte (R)','',1,0,NULL),(0,0,'774','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'774','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'774','u','Número de reporte técnico estándar (NR)','Número de reporte técnico estándar (NR)','',0,0,NULL),(0,0,'774','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'774','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'774','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'774','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'775','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'775','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'775','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'775','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'775','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'775','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'775','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'775','e','Código de idioma (NR)','Código de idioma (NR)','',0,0,NULL),(0,0,'775','f','Código de país (NR)','Código de país (NR)','',0,0,NULL),(0,0,'775','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'775','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'775','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'775','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'775','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'775','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'775','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'775','q','Título paralelo (NR) (BK SE) [OBSOLETE]','Título paralelo (NR) (BK SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'775','r','Número de reporte (R)','Número de reporte (R)','',1,0,NULL),(0,0,'775','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'775','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'775','u','Número de reporte técnico estándar (NR)','Número de reporte técnico estándar (NR)','',0,0,NULL),(0,0,'775','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'775','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'775','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'775','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'776','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'776','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'776','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'776','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'776','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'776','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'776','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'776','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'776','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'776','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'776','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'776','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'776','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'776','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'776','q','Título paralelo (NR) (BK SE) [OBSOLETE]','Título paralelo (NR) (BK SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'776','r','Número de reporte (R)','Número de reporte (R)','',1,0,NULL),(0,0,'776','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'776','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'776','u','Número de reporte técnico estándar (NR)','Número de reporte técnico estándar (NR)','',0,0,NULL),(0,0,'776','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'776','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'776','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'776','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'777','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'777','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'777','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'777','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'777','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'777','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'777','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'777','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'777','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'777','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'777','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'777','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'777','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'777','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'777','q','Título paralelo (NR) (BK SE) [OBSOLETE]','Título paralelo (NR) (BK SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'777','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'777','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'777','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'777','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'777','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'780','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'780','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'780','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'780','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'780','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'780','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'780','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'780','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'780','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'780','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'780','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'780','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'780','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'780','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'780','q','Título paralelo (NR) (BK SE) [OBSOLETE]','Título paralelo (NR) (BK SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'780','r','Número de reporte (R)','Número de reporte (R)','',1,0,NULL),(0,0,'780','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'780','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'780','u','Número de reporte técnico estándar (NR)','Número de reporte técnico estándar (NR)','',0,0,NULL),(0,0,'780','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'780','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'780','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'780','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'785','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'785','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'785','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'785','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'785','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'785','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'785','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'785','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'785','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'785','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'785','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'785','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'785','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'785','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'785','q','Título paralelo (NR) (BK SE) [OBSOLETE]','Título paralelo (NR) (BK SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'785','r','Número de reporte (R)','Número de reporte (R)','',1,0,NULL),(0,0,'785','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'785','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'785','u','Número de reporte técnico estándar (NR)','Número de reporte técnico estándar (NR)','',0,0,NULL),(0,0,'785','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'785','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'785','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'785','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'786','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'786','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'786','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'786','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'786','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'786','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'786','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'786','g','Partes relacionadas (R)','Partes relacionadas (R)','',1,0,NULL),(0,0,'786','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'786','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'786','j','Período de contenido (NR)','Período de contenido (NR)','',0,0,NULL),(0,0,'786','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'786','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'786','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'786','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'786','p','Título abreviado (NR)','Título abreviado (NR)','',0,0,NULL),(0,0,'786','r','Número de reporte (R)','Número de reporte (R)','',1,0,NULL),(0,0,'786','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'786','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'786','u','Número de reporte técnico estándar (NR)','Número de reporte técnico estándar (NR)','',0,0,NULL),(0,0,'786','v','Contribución a la fuente (NR)','Contribución a la fuente (NR)','',0,0,NULL),(0,0,'786','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'786','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'786','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'786','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'787','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'787','7','Subcampo de control (NR)','Subcampo de control (NR)','',0,0,NULL),(0,0,'787','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'787','a','Encabezado del asiento principal (NR)','Encabezado del asiento principal (NR)','',0,0,NULL),(0,0,'787','b','Edición (NR)','Edición (NR)','',0,0,NULL),(0,0,'787','c','Información calificadora (NR)','Información calificadora (NR)','',0,0,NULL),(0,0,'787','d','Lugar, editor y fecha de edición (NR)','Lugar, editor y fecha de edición (NR)','',0,0,NULL),(0,0,'787','g','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'787','h','Descripción física (NR)','Descripción física (NR)','',0,0,NULL),(0,0,'787','i','Texto a desplegar (NR)','Texto a desplegar (NR)','',0,0,NULL),(0,0,'787','k','Datos de serie de ítem relacionado (R)','Datos de serie de ítem relacionado (R)','',1,0,NULL),(0,0,'787','m','Detalles específicos del material (NR)','Detalles específicos del material (NR)','',0,0,NULL),(0,0,'787','n','Nota (R)','Nota (R)','',1,0,NULL),(0,0,'787','o','Otro identificador de ítem (R)','Otro identificador de ítem (R)','',1,0,NULL),(0,0,'787','r','Número de reporte (R)','Número de reporte (R)','',1,0,NULL),(0,0,'787','s','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'787','t','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'787','u','Número de reporte técnico estándar (NR)','Número de reporte técnico estándar (NR)','',0,0,NULL),(0,0,'787','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'787','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'787','y','Indicador CODEN (NR)','Indicador CODEN (NR)','',0,0,NULL),(0,0,'787','z','ISBN (R)','ISBN (R)','',1,0,NULL),(0,0,'800','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'800','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'800','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'800','a','Nombre personal (NR)','Nombre personal (NR)','',0,0,NULL),(0,0,'800','b','Numeración (NR)','Numeración (NR)','',0,0,NULL),(0,0,'800','c','Títulos y otras palabras asociadas con un nombre (R)','Títulos y otras palabras asociadas con un nombre (R)','',1,0,NULL),(0,0,'800','d','Fechas asociadas con un nombre (NR)','Fechas asociadas con un nombre (NR)','',0,0,NULL),(0,0,'800','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'800','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'800','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'800','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'800','j','Calificador de atributo (R)','Calificador de atributo (R)','',1,0,NULL),(0,0,'800','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'800','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'800','m','Medio de interpretación de la música (R)','Medio de interpretación de la música (R)','',1,0,NULL),(0,0,'800','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'800','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'800','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'800','q','Forma completa del nombre (NR)','Forma completa del nombre (NR)','',0,0,NULL),(0,0,'800','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'800','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'800','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'800','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'800','v','Volumen/designación secuencial (NR)','Volumen/designación secuencial (NR)','',0,0,NULL),(0,0,'810','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'810','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'810','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'810','a','Nombre corporativo o de jurisdicción como asiento (NR)','Nombre corporativo o de jurisdicción como asiento (NR)','',0,0,NULL),(0,0,'810','b','Unidad subordinada (R)','Unidad subordinada (R)','',1,0,NULL),(0,0,'810','c','Ubicación de la reunión (NR)','Ubicación de la reunión (NR)','',0,0,NULL),(0,0,'810','d','Fecha de la reunión o firma de tratado (R)','Fecha de la reunión o firma de tratado (R)','',1,0,NULL),(0,0,'810','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'810','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'810','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'810','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'810','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'810','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'810','m','Medio de interpretación de la música (R)','Medio de interpretación de la música (R)','',1,0,NULL),(0,0,'810','n','Número de la parte/sección/reunión (R)','Número de la parte/sección/reunión (R)','',1,0,NULL),(0,0,'810','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'810','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'810','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'810','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'810','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'810','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'810','v','Volumen/designación secuencial (NR)','Volumen/designación secuencial (NR)','',0,0,NULL),(0,0,'811','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'811','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'811','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'811','a','Nombre de la reunión o nombre de jurisdicción como elemento de entrada (NR)','Nombre de la reunión o nombre de jurisdicción como elemento de entrada (NR)','',0,0,NULL),(0,0,'811','b','Number (BK CF MP MU SE VM MX)  [OBSOLETE]','Number (BK CF MP MU SE VM MX)  [OBSOLETE]','',1,0,NULL),(0,0,'811','c','Ubicación de la reunión (NR)','Ubicación de la reunión (NR)','',0,0,NULL),(0,0,'811','d','Fecha de reunión (NR)','Fecha de reunión (NR)','',0,0,NULL),(0,0,'811','e','Unidad subordinada (R)','Unidad subordinada (R)','',1,0,NULL),(0,0,'811','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'811','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'811','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'811','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'811','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'811','n','Número de la parte/sección/reunión (R)','Número de la parte/sección/reunión (R)','',1,0,NULL),(0,0,'811','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'811','q','Tipo del nombre de la reunión siguiente al nombre de jurisdicción como asiento (NR)','Tipo del nombre de la reunión siguiente al nombre de jurisdicción como asiento (NR)','',0,0,NULL),(0,0,'811','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'811','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'811','u','Afiliación (NR)','Afiliación (NR)','',0,0,NULL),(0,0,'811','v','Volumen/designación secuencial (NR)','Volumen/designación secuencial (NR)','',0,0,NULL),(0,0,'830','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'830','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'830','a','Título uniforme (NR)','Título uniforme (NR)','',0,0,NULL),(0,0,'830','d','Fecha de firma de tratado (R)','Fecha de firma de tratado (R)','',1,0,NULL),(0,0,'830','f','Fecha de la obra (NR)','Fecha de la obra (NR)','',0,0,NULL),(0,0,'830','g','Información miscelánea (NR)','Información miscelánea (NR)','',0,0,NULL),(0,0,'830','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'830','k','Subtítulo de formulario (R)','Subtítulo de formulario (R)','',1,0,NULL),(0,0,'830','l','Idioma de la obra (NR)','Idioma de la obra (NR)','',0,0,NULL),(0,0,'830','m','Medio de interpretación de la música (R)','Medio de interpretación de la música (R)','',1,0,NULL),(0,0,'830','n','Número de la parte/sección de la obra (R)','Número de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'830','o','Mención del arreglo musical (NR)','Mención del arreglo musical (NR)','',0,0,NULL),(0,0,'830','p','Nombre de la parte/sección de la obra (R)','Nombre de la parte/sección de la obra (R)','',1,0,NULL),(0,0,'830','r','Clave para música (NR)','Clave para música (NR)','',0,0,NULL),(0,0,'830','s','Versión (NR)','Versión (NR)','',0,0,NULL),(0,0,'830','t','Título de la obra (NR)','Título de la obra (NR)','',0,0,NULL),(0,0,'830','v','Volumen/designación secuencial (NR)','Volumen/designación secuencial (NR)','',0,0,NULL),(0,0,'840','a','Título (NR)','Título (NR)','',0,0,NULL),(0,0,'840','h','Medio (NR)','Medio (NR)','',0,0,NULL),(0,0,'840','v','Volumen/designación secuencial (NR)','Volumen/designación secuencial (NR)','',0,0,NULL),(0,0,'841','8','Field link and sequence number See','Field link and sequence number See','',1,0,NULL),(0,0,'841','a','Holding institution','Holding institution','',1,0,NULL),(0,0,'850','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'850','a','Institución en posesión de la existencia (R)','Institución en posesión de la existencia (R)','',0,0,NULL),(0,0,'850','b','Existencias (NR) (MU VM SE) [OBSOLETE]','Existencias (NR) (MU VM SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'850','d','Fechas inclusivas (NR) (MU VM SE) [OBSOLETE]','Fechas inclusivas (NR) (MU VM SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'850','e','Declaración de retención (NR) (CF MU VM SE) [OBSOLETE]','Declaración de retención (NR) (CF MU VM SE) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'851','3','Materials specified (NR)','Materials specified (NR)','',0,0,NULL),(0,0,'851','6','Linkage (NR)','Linkage (NR)','',0,0,NULL),(0,0,'851','a','Name (custodian or owner) (NR)','Name (custodian or owner) (NR)','',0,0,NULL),(0,0,'851','b','Institutional division (NR)','Institutional division (NR)','',0,0,NULL),(0,0,'851','c','Street address (NR)','Street address (NR)','',0,0,NULL),(0,0,'851','d','Country (NR)','Country (NR)','',0,0,NULL),(0,0,'851','e','Location of units (NR)','Location of units (NR)','',0,0,NULL),(0,0,'851','f','Item number (NR)','Item number (NR)','',0,0,NULL),(0,0,'851','g','Repository location code (NR)','Repository location code (NR)','',0,0,NULL),(0,0,'852','2','Fuente del esquema de clasificación o almacenamiento en los estantes (NR)','Fuente del esquema de clasificación o almacenamiento en los estantes (NR)','',0,0,''),(0,0,'852','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,''),(0,0,'852','6','Enlace (NR)','Enlace (NR)','',0,0,''),(0,0,'852','8','Número de secuencia (NR)','Número de secuencia (NR)','',0,0,NULL),(0,0,'852','a','Ubicación (NR)','Ubicación (NR)','',0,0,''),(0,0,'852','b','Sub-ubicación o colección (R)','Sub-ubicación o colección (R)','',0,0,''),(0,0,'995','t','Signatura Topogr&aacute;fica','Signatura Topogr&aacute;fica','',0,0,'items.bulk'),(0,0,'852','e','Dirección (R)','Dirección (R)','',1,0,''),(0,0,'852','f','Calificador de ubicación codificado (R)','Calificador de ubicación codificado (R)','',1,0,''),(0,0,'852','g','Calificador de ubicación no-codificado (R)','Calificador de ubicación no-codificado (R)','',1,0,''),(0,0,'852','h','Parte de clasificación (NR)','Parte de clasificación (NR)','',0,0,'biblioitems.classification'),(0,0,'852','i','Parte del ítem (R)','Parte del ítem (R)','',0,0,''),(0,0,'852','j','Número de control de almacenamiento en los estantes (NR)','Número de control de almacenamiento en los estantes (NR)','',0,0,''),(0,0,'852','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'852','k','Prefijo del número de identificación (R)','Prefijo del número de identificación (R)','',1,0,'biblioitems.dewey'),(0,0,'852','l','Forma de almacenamiento en los estantes del título (NR)','Forma de almacenamiento en los estantes del título (NR)','',0,0,''),(0,0,'852','m','Sufijo del número de identificación (R)','Sufijo del número de identificación (R)','',1,0,'biblioitems.subclass'),(0,0,'852','n','Código de país (NR)','Código de país (NR)','',0,0,''),(0,0,'852','p','Designación de la pieza (NR)','Designación de la pieza (NR)','',0,0,''),(0,0,'852','q','Condición física de la pieza (NR)','Condición física de la pieza (NR)','',0,0,''),(0,0,'852','s','Código de cuota de derechos de autor del artículo (R)','Código de cuota de derechos de autor del artículo (R)','',1,0,''),(0,0,'852','t','Número de copia (NR)','Número de copia (NR)','',0,0,''),(0,0,'852','x','Nota no-pública (R)','Nota no-pública (R)','',0,0,''),(0,0,'852','z','Nota pública (R)','Nota pública (R)','',0,0,''),(0,0,'853','2','Access method','Access method','',0,0,NULL),(0,0,'853','3','Materials specified','Materials specified','',0,0,NULL),(0,0,'853','6','Linkage See','Linkage See','',0,0,NULL),(0,0,'853','8','Field link and sequence number See','Field link and sequence number See','',1,0,NULL),(0,0,'853','a','Host name','Host name','',1,0,NULL),(0,0,'853','b','Access number','Access number','',1,0,NULL),(0,0,'853','c','Compression information','Compression information','',1,0,NULL),(0,0,'853','d','Path','Path','',1,0,NULL),(0,0,'853','f','Electronic name','Electronic name','',1,0,NULL),(0,0,'853','h','Processor of request','Processor of request','',0,0,NULL),(0,0,'853','i','Instruction','Instruction','',1,0,NULL),(0,0,'853','j','Bits per second','Bits per second','',0,0,NULL),(0,0,'853','k','Password','Password','',0,0,NULL),(0,0,'853','l','Logon','Logon','',0,0,NULL),(0,0,'853','m','Contact for access assistance','Contact for access assistance','',1,0,NULL),(0,0,'853','n','Name of location of host','Name of location of host','',0,0,NULL),(0,0,'853','o','Operating system','Operating system','',0,0,NULL),(0,0,'853','p','Port','Port','',0,0,NULL),(0,0,'853','q','Electronic format type','Electronic format type','',0,0,NULL),(0,0,'853','r','Settings','Settings','',0,0,NULL),(0,0,'853','s','File size','File size','',1,0,NULL),(0,0,'853','t','Terminal emulation','Terminal emulation','',1,0,NULL),(0,0,'853','u','Uniform Resource Identifier','Uniform Resource Identifier','',1,0,NULL),(0,0,'853','v','Hours access method available','Hours access method available','',1,0,NULL),(0,0,'853','w','Record control number','Record control number','',1,0,NULL),(0,0,'853','x','Nonpublic note','Nonpublic note','',1,0,NULL),(0,0,'853','y','Link text','Link text','',1,0,NULL),(0,0,'853','z','Public note','Public note','',1,0,NULL),(0,0,'856','2','Método de acceso (NR)','Método de acceso (NR)','',0,0,NULL),(0,0,'856','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'856','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'856','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'856','a','Nombre de host (R)','Nombre de host (R)','',1,0,NULL),(0,0,'856','b','Número de acceso (R)','Número de acceso (R)','',1,0,NULL),(0,0,'856','c','Información de compresión (R)','Información de compresión (R)','',1,0,NULL),(0,0,'856','d','Ruta (R)','Ruta (R)','',1,0,NULL),(0,0,'856','f','Nombre electrónico (R)','Nombre electrónico (R)','',1,0,NULL),(0,0,'856','g','Uniform Resource Name (R) [OBSOLETE]','Uniform Resource Name (R) [OBSOLETE]','OBSOLETO',0,0,NULL),(0,0,'856','h','Procesador de la solicitud (NR)','Procesador de la solicitud (NR)','',0,0,NULL),(0,0,'856','i','Instrucción (R)','Instrucción (R)','',1,0,NULL),(0,0,'856','j','Bits por segundo (NR)','Bits por segundo (NR)','',0,0,NULL),(0,0,'856','k','Contraseña (NR)','Contraseña (NR)','',0,0,NULL),(0,0,'856','l','Cadena de acceso (Logon) (NR)','Cadena de acceso (Logon) (NR)','',0,0,NULL),(0,0,'856','m','Contacto para asistencia de acceso (R)','Contacto para asistencia de acceso (R)','',1,0,NULL),(0,0,'856','n','Nombre de la ubicación del host (NR)','Nombre de la ubicación del host (NR)','',0,0,NULL),(0,0,'856','o','Sistema operativo (NR)','Sistema operativo (NR)','',0,0,NULL),(0,0,'856','p','Puerto (NR)','Puerto (NR)','',0,0,NULL),(0,0,'856','q','Tipo de formato electrónico (NR)','Tipo de formato electrónico (NR)','',0,0,NULL),(0,0,'856','r','Configuración (NR)','Configuración (NR)','',0,0,NULL),(0,0,'856','s','Tamaño del archivo (R)','Tamaño del archivo (R)','',1,0,NULL),(0,0,'856','t','Emulación de terminal (R)','Emulación de terminal (R)','',1,0,NULL),(0,0,'856','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,'biblioitems.url'),(0,0,'856','v','Método de acceso por horas disponible (R)','Método de acceso por horas disponible (R)','',1,0,NULL),(0,0,'856','w','Número de control de registro (R)','Número de control de registro (R)','',1,0,NULL),(0,0,'856','x','Nota no-pública (R)','Nota no-pública (R)','',0,0,NULL),(0,0,'856','y','Texto del enlace (R)','Texto del enlace (R)','',1,0,NULL),(0,0,'856','z','Nota pública (R)','Nota pública (R)','',0,0,NULL),(0,0,'863','8','Field link and sequence number (NR)','Field link and sequence number (NR)','',1,0,NULL),(0,0,'876','8','Field link and sequence number  (R)','Field link and sequence number  (R)','',1,0,NULL),(0,0,'876','b','Home branch (NR)','Home branch (NR)','',0,0,NULL),(0,0,'876','c','Cost (R)','Cost (R)','',1,0,NULL),(0,0,'876','d','Date acquired (R)','Date acquired (R)','',1,0,NULL),(0,0,'876','e','Source of acquisition (R)','Source of acquisition (R)','',1,0,NULL),(0,0,'876','j','Item status (R)','Item status (R)','',1,0,NULL),(0,0,'876','l','Temporary location (R)','Temporary location (R)','',1,0,NULL),(0,0,'876','p','Piece designation (R)','Piece designation (R)','',1,0,NULL),(0,0,'876','z','Note  (R)','Note  (R)','',1,0,NULL),(0,0,'880','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'880','7-9','ual que el campo asociado','ual que el campo asociado','',0,0,NULL),(0,0,'886','2','Fuente de los datos (NR)','Fuente de los datos (NR)','',0,0,NULL),(0,0,'648','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'886','a','Etiqueta del campo MARC extranjero (NR)','Etiqueta del campo MARC extranjero (NR)','',0,0,NULL),(0,0,'886','b','Contenido del campo MARC extranjero (NR)','Contenido del campo MARC extranjero (NR)','',0,0,NULL),(0,1,'995','d','Unidad de Informaci&oacute;n de Origen','Unidad de Informaci&oacute;n de Origen','',0,0,'items.homebranch'),(0,0,'995','f','C&oacute;digo de Barras','C&oacute;digo de Barras','',0,0,'items.barcode'),(0,0,'995','m','Fecha de acceso','Fecha de acceso','',0,0,'items.dateaccessioned'),(0,1,'995','o','Disponibilidad','Disponibilidad','',0,0,'items.notforloan'),(0,0,'995','s','Koha item number','Koha item number','',0,0,'items.itemnumber'),(0,0,'995','u','Notas del item','Notas del item','',0,0,'items.itemnotes'),(0,1,'995','c','Unidad de Informaci&oacute;n','Unidad de Informaci&oacute;n','',0,0,'items.holdingbranch'),(0,0,'043','b','Código local GAC (R)','Código local GAC (R)','',1,0,NULL),(0,0,'995','a','Nombre del vendedor','Nombre del vendedor','',0,0,'items.booksellerid'),(0,0,'995','p','Precio de compra','Precio de compra','',0,0,'items.price'),(0,0,'995','r','Precio de reemplazo','Precio de reemplazo','',0,0,'items.replacementprice'),(0,1,'910','a','Tipo de documento','Tipo de documento','',0,1,'biblioitems.itemtype'),(0,1,'995','e','Estado','Estado','',0,0,'items.wthdrawn'),(0,0,'000','@','LEADER','LEADER','',0,0,''),(0,0,'900','b','nivel bibliografico','nivel bibliografico','',0,0,NULL),(0,0,'022','m','ISSN-L cancelado (R)','ISSN-L cancelado (R)','',1,0,NULL),(0,0,'022','2','Fuente del número (NR)','Fuente del número (NR)','',0,0,NULL),(0,0,'022','l','ISSN-L (NR)','ISSN-L (NR)','',0,0,NULL),(0,0,'882','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'882','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'882','w','Número de control de registro bibliográfico de reemplazo (R)','Número de control de registro bibliográfico de reemplazo (R)','',1,0,NULL),(0,0,'882','a','Título de reemplazo (R)','Título de reemplazo (R)','',1,0,NULL),(0,0,'882','i','Texto de explicación (R)','Texto de explicación (R)','',1,0,NULL),(0,0,'520','2','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'520','c','Agencia que asigna (NR)','Agencia que asigna (NR)','',0,0,NULL),(0,0,'041','2','Fuente del código (NR)','Fuente del código (NR)','',0,0,NULL),(0,0,'041','j','Código de idioma de subtítulos (R)','Código de idioma de subtítulos (R)','',1,0,NULL),(0,0,'366','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'366','e','Nota (NR)','Nota (NR)','',0,0,NULL),(0,0,'366','a','Identificación del título comprimido de la casa editora (NR)','Identificación del título comprimido de la casa editora (NR)','',0,0,NULL),(0,0,'366','m','Identificación de la agencia (NR)','Identificación de la agencia (NR)','',0,0,NULL),(0,0,'366','d','Próxima fecha probable de disponibilidad (NR)','Próxima fecha probable de disponibilidad (NR)','',0,0,NULL),(0,0,'366','2','Fuente del código de estado de la disponibilidad (NR)','Fuente del código de estado de la disponibilidad (NR)','',0,0,NULL),(0,0,'366','j','Código ISO del país (NR)','Código ISO del país (NR)','',0,0,NULL),(0,0,'366','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'366','c','Código del estado de la disponibilidad (NR)','Código del estado de la disponibilidad (NR)','',0,0,NULL),(0,0,'366','k','Código MARC del país (NR)','Código MARC del país (NR)','',0,0,NULL),(0,0,'366','b','Fecha detallada de publicación (NR)','Fecha detallada de publicación (NR)','',0,0,NULL),(0,0,'366','g','Fecha en que se agotó (NR)','Fecha en que se agotó (NR)','',0,0,NULL),(0,0,'366','f','Categoría de descuento de la casa editora (NR)','Categoría de descuento de la casa editora (NR)','',0,0,NULL),(0,0,'785','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'767','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'730','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'730','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'787','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'775','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'534','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'534','o','Otro identificador de recurso (R)','Otro identificador de recurso (R)','',1,0,NULL),(0,0,'611','j','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'611','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'015','2','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'015','z','Número de la bibliografía nacional no válido/cancelado (R)','Número de la bibliografía nacional no válido/cancelado (R)','',1,0,NULL),(0,0,'700','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'700','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'540','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'751','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'751','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'751','a','Nombre geográfico (NR)','Nombre geográfico (NR)','',0,0,NULL),(0,0,'751','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'751','2','Fuente del encabezado o término (NR)','Fuente del encabezado o término (NR)','',0,0,NULL),(0,0,'751','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'751','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'751','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'337','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'337','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'337','a','Término de tipo de medio (R)','Término de tipo de medio (R)','',1,0,NULL),(0,0,'337','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'337','b','Código de tipo de medio (R)','Código de tipo de medio (R)','',1,0,NULL),(0,0,'337','2','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'886','0-9','Subcampo MARC extranjero (R)','Subcampo MARC extranjero (R)','',1,0,NULL),(0,0,'886','a-z','Subcampo MARC extranjero (R)','Subcampo MARC extranjero (R)','',1,0,NULL),(0,0,'648','a','Término cronológico (NR)','Término cronológico (NR)','',0,0,NULL),(0,0,'648','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'648','x','Subdivisión general (R)','Subdivisión general (R)','',1,0,NULL),(0,0,'648','v','Subdivisión de forma (R)','Subdivisión de forma (R)','',1,0,NULL),(0,0,'648','2','Fuente del encabezado o término (NR)','Fuente del encabezado o término (NR)','',0,0,NULL),(0,0,'648','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'648','y','Subdivisión cronológica (R)','Subdivisión cronológica (R)','',1,0,NULL),(0,0,'648','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'648','z','Subdivisión geográfica (R)','Subdivisión geográfica (R)','',1,0,NULL),(0,0,'026','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'026','e','Huella digital sin analizar (NR)','Huella digital sin analizar (NR)','',0,0,NULL),(0,0,'026','a','Primer y segundo grupo de caracteres (R)','Primer y segundo grupo de caracteres (R)','',1,0,NULL),(0,0,'026','d','Número de volumen o parte (R)','Número de volumen o parte (R)','',1,0,NULL),(0,0,'026','2','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'026','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'026','c','Fecha (NR)','Fecha (NR)','',0,0,NULL),(0,0,'026','b','Tercer y cuarto grupo de caracteres (R)','Tercer y cuarto grupo de caracteres (R)','',1,0,NULL),(0,0,'026','5','Institución a la que se aplica el campo (R)','Institución a la que se aplica el campo (R)','',1,0,NULL),(0,0,'656','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'110','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'811','w','Número de control de registro bibliográfico (R)','Número de control de registro bibliográfico (R)','',1,0,NULL),(0,0,'811','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'811','j','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'811','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'811','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'650','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'650','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'662','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'662','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'662','a','País o entidad mayor (R)','País o entidad mayor (R)','',1,0,NULL),(0,0,'662','d','Ciudad (NR)','Ciudad (NR)','',0,0,NULL),(0,0,'662','2','Fuente del encabezado o término (NR)','Fuente del encabezado o término (NR)','',0,0,NULL),(0,0,'662','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'662','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'662','c','Jurisdicción política intermedia (R)','Jurisdicción política intermedia (R)','',1,0,NULL),(0,0,'662','h','Área extraterrestre (R)','Área extraterrestre (R)','',1,0,NULL),(0,0,'662','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'662','b','Jurisdicción política de primer orden (NR)','Jurisdicción política de primer orden (NR)','',0,0,NULL),(0,0,'662','g','Otra región geográfica no-jurisdiccional (R)','Otra región geográfica no-jurisdiccional (R)','',1,0,NULL),(0,0,'662','f','Subsección de ciudad (R)','Subsección de ciudad (R)','',1,0,NULL),(0,0,'710','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'710','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'776','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'772','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'588','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'588','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'588','a','Nota de origen de descripción (NR)','Nota de origen de descripción (NR)','',0,0,NULL),(0,0,'588','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'502','d','Año de grado otorgado (NR)','Año de grado otorgado (NR)','',0,0,NULL),(0,0,'502','c','Nombre de la institución otorgante (NR)','Nombre de la institución otorgante (NR)','',0,0,NULL),(0,0,'502','b','Tipo de grado (NR)','Tipo de grado (NR)','',0,0,NULL),(0,0,'502','g','Información miscelánea (R)','Información miscelánea (R)','',1,0,NULL),(0,0,'502','o','Identificador de tesis (R)','Identificador de tesis (R)','',1,0,NULL),(0,0,'830','w','Número de control de registro bibliográfico (R)','Número de control de registro bibliográfico (R)','',1,0,NULL),(0,0,'830','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'830','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'830','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'754','d','Nombre común o alternativo (R)','Nombre común o alternativo (R)','',1,0,NULL),(0,0,'754','c','Categoría taxonómica (R)','Categoría taxonómica (R)','',1,0,NULL),(0,0,'754','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'754','z','Nota pública (R)','Nota pública (R)','',1,0,NULL),(0,0,'352','q','Formato de la imagen digital (R)','Formato de la imagen digital (R)','',1,0,NULL),(0,0,'018','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'018','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'034','r','Distancia de la Tierra (NR)','Distancia de la Tierra (NR)','',0,0,NULL),(0,0,'034','x','Fecha de inicio (NR)','Fecha de inicio (NR)','',0,0,NULL),(0,0,'034','2','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'034','y','Fecha de fin (NR)','Fecha de fin (NR)','',0,0,NULL),(0,0,'034','z','Nombre del cuerpo extraterrestre (NR)','Nombre del cuerpo extraterrestre (NR)','',0,0,NULL),(0,0,'542','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'542','a','Solicitation information Nota (NR)','Solicitation information Nota (NR)','',0,0,NULL),(0,0,'651','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'651','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'651','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'083','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'083','a','Número de clasificación (R)','Número de clasificación (R)','',1,0,NULL),(0,0,'083','m','Designación estándar u opcional (NR)','Designación estándar u opcional (NR)','',0,0,NULL),(0,0,'083','2','Número de edición (NR)','Número de edición (NR)','',0,0,NULL),(0,0,'083','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'083','y','Número de secuencia de tabla para uso interno o agregar tabla (R)','Número de secuencia de tabla para uso interno o agregar tabla (R)','',1,0,NULL),(0,0,'083','c','Número de clasificación - número final del código (R)','Número de clasificación - número final del código (R)','',1,0,NULL),(0,0,'083','q','Agencia que lo asigna (NR)','Agencia que lo asigna (NR)','',0,0,NULL),(0,0,'083','z','Identificación de tablas (R)','Identificación de tablas (R)','',1,0,NULL),(0,0,'810','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'810','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'810','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'852','d','Ubicación anterior en los estantes (R)','Ubicación anterior en los estantes (R)','',1,0,NULL),(0,0,'852','c','Ubicación en los estantes (R)','Ubicación en los estantes (R)','',1,0,NULL),(0,0,'047','2','Fuente del código (NR)','Fuente del código (NR)','',0,0,NULL),(0,0,'538','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'538','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'538','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'538','i','Texto que se muestra (NR)','Texto que se muestra (NR)','',0,0,NULL),(0,0,'046','n','Término de la fecha válida (NR)','Término de la fecha válida (NR)','',0,0,NULL),(0,0,'046','m','Inicio de la fecha válida (NR)','Inicio de la fecha válida (NR)','',0,0,NULL),(0,0,'046','2','Fuente de la fecha (NR)','Fuente de la fecha (NR)','',0,0,NULL),(0,0,'046','j','Fecha del recurso modificado (NR)','Fecha del recurso modificado (NR)','',0,0,NULL),(0,0,'046','l','Finalización de la fecha creada (NR)','Finalización de la fecha creada (NR)','',0,0,NULL),(0,0,'046','k','Inicio o individualización de la fecha creada (NR)','Inicio o individualización de la fecha creada (NR)','',0,0,NULL),(0,0,'887','a','Contenido del campo que no pertenece a MARC (NR)','Contenido del campo que no pertenece a MARC (NR)','',0,0,NULL),(0,0,'887','2','Fuente de los datos (NR)','Fuente de los datos (NR)','',0,0,NULL),(0,0,'600','0','Número de control del registro de autoridad (R)','Número de control del registro de autoridad (R)','',1,0,NULL),(0,0,'336','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'336','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'336','a','Término de tipo de contenido (R)','Término de tipo de contenido (R)','',1,0,NULL),(0,0,'336','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'336','b','Código de tipo de contenido (R)','Código de tipo de contenido (R)','',1,0,NULL),(0,0,'336','2','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'880','a-z','ual que el campo asociado','ual que el campo asociado','',0,0,NULL),(0,0,'880','0-5','ual que el campo asociado','ual que el campo asociado','',0,0,NULL),(0,0,'780','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'240','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'786','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'440','w','Número de control del registro bibliográfico (R)','Número de control del registro bibliográfico (R)','',1,0,NULL),(0,0,'440','0','Número de control del registro de autoridad (R)','Número de control del registro de autoridad (R)','',1,0,NULL),(0,0,'752','2','Fuente del encabezado o término (NR)','Fuente del encabezado o término (NR)','',0,0,NULL),(0,0,'752','h','Área extraterrestre (R)','Área extraterrestre (R)','',1,0,NULL),(0,0,'752','g','Otra región geográfica no jurisdiccional (R)','Otra región geográfica no jurisdiccional (R)','',1,0,NULL),(0,0,'752','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'752','f','Subsección de ciudad (R)','Subsección de ciudad (R)','',1,0,NULL),(0,0,'085','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'085','w','Identificación de tabla - Subclasificación interna o tabla agregada (add table) (R)','Identificación de tabla - Subclasificación interna o tabla agregada (add table) (R)','',1,0,NULL),(0,0,'085','r','Número raíz (R)','Número raíz (R)','',1,0,NULL),(0,0,'085','a','Número en que se encuentran las instrucciones - número simple o principio del código (R)','Número en que se encuentran las instrucciones - número simple o principio del código (R)','',1,0,NULL),(0,0,'085','v','Número en subclasificación interna o tabla agregada donde se encuentran las instrucciones (R)','Número en subclasificación interna o tabla agregada donde se encuentran las instrucciones (R)','',1,0,NULL),(0,0,'085','s','Dígitos agregados del número de clasificación en lista o tabla externa (R)','Dígitos agregados del número de clasificación en lista o tabla externa (R)','',1,0,NULL),(0,0,'085','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'085','y','Número de secuencia de tabla para subclasificación interna o tabla agregada (add table) (R)','Número de secuencia de tabla para subclasificación interna o tabla agregada (add table) (R)','',1,0,NULL),(0,0,'085','c','Múmero de clasificación - número final del código (R)','Múmero de clasificación - número final del código (R)','',1,0,NULL),(0,0,'085','u','Número analizado (R)','Número analizado (R)','',1,0,NULL),(0,0,'085','b','Número base (R)','Número base (R)','',1,0,NULL),(0,0,'085','z','Identificación de tabla (R)','Identificación de tabla (R)','',1,0,NULL),(0,0,'085','f','Designación de faceta (R)','Designación de faceta (R)','',1,0,NULL),(0,0,'085','t','Dígitos agregados de la subclasificación interna o tabla agregada (add table) (R)','Dígitos agregados de la subclasificación interna o tabla agregada (add table) (R)','',1,0,NULL),(0,0,'610','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'563','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'563','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'563','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'563','a','Nota sobre encuadernación(NR)','Nota sobre encuadernación(NR)','',0,0,NULL),(0,0,'563','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'563','5','Institución a la que se aplica el campo (NR)','Institución a la que se aplica el campo (NR)','',0,0,NULL),(0,0,'258','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'258','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'258','a','Jurisdicción de emisión (NR)','Jurisdicción de emisión (NR)','',0,0,NULL),(0,0,'258','b','Denominación (NR)','Denominación (NR)','',0,0,NULL),(0,0,'765','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'038','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'038','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'038','a','Registro del concedente de la licencia del contenido (NR)','Registro del concedente de la licencia del contenido (NR)','',0,0,NULL),(0,0,'657','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'510','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'774','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'260','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'365','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'365','e','Nota sobre el precio (NR)','Nota sobre el precio (NR)','',0,0,NULL),(0,0,'365','a','Código de tipo de precio (NR)','Código de tipo de precio (NR)','',0,0,NULL),(0,0,'365','m','Identificación de la entidad que asigna el precio (NR)','Identificación de la entidad que asigna el precio (NR)','',0,0,NULL),(0,0,'365','d','Unidad de precio (NR)','Unidad de precio (NR)','',0,0,NULL),(0,0,'365','2','Fuente del código para el tipo de precio (NR)','Fuente del código para el tipo de precio (NR)','',0,0,NULL),(0,0,'365','j','Código ISO del país (NR)','Código ISO del país (NR)','',0,0,NULL),(0,0,'365','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'365','c','Código de moneda (NR)','Código de moneda (NR)','',0,0,NULL),(0,0,'365','k','Código MARC de país (NR)','Código MARC de país (NR)','',0,0,NULL),(0,0,'365','h','Tarifa de impuesto 1 (NR)','Tarifa de impuesto 1 (NR)','',0,0,NULL),(0,0,'365','b','Monto del precio (NR)','Monto del precio (NR)','',0,0,NULL),(0,0,'365','g','Precio efectivo hasta (NR)','Precio efectivo hasta (NR)','',0,0,NULL),(0,0,'365','f','Precio efectivo a partir de (NR)','Precio efectivo a partir de (NR)','',0,0,NULL),(0,0,'365','i','Tarifa de impuesto 2 (NR)','Tarifa de impuesto 2 (NR)','',0,0,NULL),(0,0,'770','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'762','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'506','2','Fuente del término (NR)','Fuente del término (NR)','',0,0,NULL),(0,0,'506','u','Identificador Uniforme de Recursos (R)','Identificador Uniforme de Recursos (R)','',1,0,NULL),(0,0,'506','f','Terminología estandarizada para restricción de acceso (R)','Terminología estandarizada para restricción de acceso (R)','',1,0,NULL),(0,0,'082','q','Agencia que lo asigna (NR)','Agencia que lo asigna (NR)','',0,0,NULL),(0,0,'082','m','Designación estándar u opcional (NR)','Designación estándar u opcional (NR)','',0,0,NULL),(0,0,'338','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'338','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'338','a','Término de tipo de portador (R)','Término de tipo de portador (R)','',1,0,NULL),(0,0,'338','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'338','b','Código de tipo de portador (R)','Código de tipo de portador (R)','',1,0,NULL),(0,0,'338','2','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'654','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'654','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'654','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'100','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'800','w','Número de control de registro bibliográfico (R)','Número de control de registro bibliográfico (R)','',1,0,NULL),(0,0,'800','x','ISSN (NR)','ISSN (NR)','',0,0,NULL),(0,0,'800','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'800','3','Materiales específicos a los cuales se aplica el campo (NR)','Materiales específicos a los cuales se aplica el campo (NR)','',0,0,NULL),(0,0,'031','r','Tono o modo (NR)','Tono o modo (NR)','',0,0,NULL),(0,0,'031','a','Número de la obra (NR)','Número de la obra (NR)','',0,0,NULL),(0,0,'031','d','Título (R)','Título (R)','',1,0,NULL),(0,0,'031','2','Código de sistema (NR)','Código de sistema (NR)','',0,0,NULL),(0,0,'031','y','Texto de enlace (R)','Texto de enlace (R)','',1,0,NULL),(0,0,'031','u','Identificador Uniforme de Recursos (URI) (R)','Identificador Uniforme de Recursos (URI) (R)','',1,0,NULL),(0,0,'031','g','Tono (NR)','Tono (NR)','',0,0,NULL),(0,0,'031','t','Texto del íncipit (R)','Texto del íncipit (R)','',1,0,NULL),(0,0,'031','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'031','e','Rol (NR)','Rol (NR)','',0,0,NULL),(0,0,'031','n','Armadura (NR)','Armadura (NR)','',0,0,NULL),(0,0,'031','m','Voz/instrumento (NR)','Voz/instrumento (NR)','',0,0,NULL),(0,0,'031','s','Nota de validez cifrada (R)','Nota de validez cifrada (R)','',1,0,NULL),(0,0,'031','8','Vínculo de campo y número de secuencia (R)','Vínculo de campo y número de secuencia (R)','',1,0,NULL),(0,0,'031','c','Número del extracto (NR)','Número del extracto (NR)','',0,0,NULL),(0,0,'031','p','Notación musical (NR)','Notación musical (NR)','',0,0,NULL),(0,0,'031','b','Número del movimiento (NR)','Número del movimiento (NR)','',0,0,NULL),(0,0,'031','q','Nota general (R)','Nota general (R)','',1,0,NULL),(0,0,'031','z','Nota pública (R)','Nota pública (R)','',1,0,NULL),(0,0,'031','o','Compás (NR)','Compás (NR)','',0,0,NULL),(0,0,'130','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'777','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'773','4','Código de relación (R)','Código de relación (R)','',1,0,NULL),(0,0,'773','q','Enumeración y primera página (NR)','Enumeración y primera página (NR)','',0,0,NULL),(0,0,'363','a','Primer nivel de enumeración (NR)','Primer nivel de enumeración (NR)','',0,0,NULL),(0,0,'363','x','Nota no-pública (R)','Nota no-pública (R)','',1,0,NULL),(0,0,'363','d','Cuarto nivel de enumeración (NR)','Cuarto nivel de enumeración (NR)','',0,0,NULL),(0,0,'363','j','Segundo nivel de cronología (NR)','Segundo nivel de cronología (NR)','',0,0,NULL),(0,0,'363','u','Designación textual de primer nivel (NR)','Designación textual de primer nivel (NR)','',0,0,NULL),(0,0,'363','k','Tercer nivel de cronología (NR)','Tercer nivel de cronología (NR)','',0,0,NULL),(0,0,'363','h','Esquema de numeración alternativo, segundo nivel de enumeración (NR)','Esquema de numeración alternativo, segundo nivel de enumeración (NR)','',0,0,NULL),(0,0,'363','g','Esquema de numeración alternativo, primer nivel de enumeración (NR)','Esquema de numeración alternativo, primer nivel de enumeración (NR)','',0,0,NULL),(0,0,'363','f','Sexto nivel de enumeración (NR)','Sexto nivel de enumeración (NR)','',0,0,NULL),(0,0,'363','i','Primer nivel de cronología (NR)','Primer nivel de cronología (NR)','',0,0,NULL),(0,0,'363','6','Enlace (NR)','Enlace (NR)','',0,0,NULL),(0,0,'363','e','Quinto nivel de enumeración (NR)','Quinto nivel de enumeración (NR)','',0,0,NULL),(0,0,'363','m','Esquema de numeración alternativo, cronología (NR)','Esquema de numeración alternativo, cronología (NR)','',0,0,NULL),(0,0,'363','v','Primer nivel de cronología, emisión (NR)','Primer nivel de cronología, emisión (NR)','',0,0,NULL),(0,0,'363','8','Vínculo de campo y número de secuencia (NR)','Vínculo de campo y número de secuencia (NR)','',0,0,NULL),(0,0,'363','l','Cuarto nivel de cronología (NR)','Cuarto nivel de cronología (NR)','',0,0,NULL),(0,0,'363','c','Tercer nivel de enumeración (NR)','Tercer nivel de enumeración (NR)','',0,0,NULL),(0,0,'363','b','Segundo nivel de enumeración (NR)','Segundo nivel de enumeración (NR)','',0,0,NULL),(0,0,'363','z','Nota pública (R)','Nota pública (R)','',1,0,NULL),(0,0,'257','2','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'048','2','Fuente del código (NR)','Fuente del código (NR)','',0,0,NULL),(0,0,'630','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'630','e','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'630','4','Código relator (R)','Código relator (R)','',1,0,NULL),(0,0,'111','j','Término de relación (R)','Término de relación (R)','',1,0,NULL),(0,0,'111','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'017','d','Fecha (NR)','Fecha (NR)','',0,0,NULL),(0,0,'017','2','Fuente (NR)','Fuente (NR)','',0,0,NULL),(0,0,'017','i','Texto visualizado (NR)','Texto visualizado (NR)','',0,0,NULL),(0,0,'711','0','Número de control de registro de autoridad (R)','Número de control de registro de autoridad (R)','',1,0,NULL),(0,0,'711','i','Información sobre relaciones (R)','Información sobre relaciones (R)','',1,0,NULL),(0,0,'863','a','Volumen','Volumen',NULL,0,0,NULL),(0,0,'863','b','Número','Número',NULL,0,0,NULL),(0,0,'863','i','Año','Año',NULL,0,0,NULL),(0,0,'859','d','No se que es','No se que es','No se que es',0,0,NULL),(0,0,'859','e','No se que es','No se que es','No se que es',0,0,NULL),(0,0,'859','o','No se que es','No se que es','No se que es',0,0,NULL),(0,0,'859','s','No se que es','No se que es','No se que es',0,0,NULL),(0,0,'865','a','índice','índice','índice',0,0,NULL),(0,0,'900','g','para uso interno 1','para uso interno 1',NULL,0,0,NULL),(0,0,'900','h','para uso interno 2','para uso interno 2',NULL,0,0,NULL),(0,0,'900','i','para uso interno 3','para uso interno 3',NULL,0,0,NULL),(0,0,'900','j','para uso interno 4','para uso interno 4',NULL,0,0,NULL);
/*!40000 ALTER TABLE `pref_estructura_subcampo_marc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_feriado`
--

DROP TABLE IF EXISTS `pref_feriado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_feriado` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` varchar(10) DEFAULT NULL,
  `feriado` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fecha` (`fecha`)
) ENGINE=MyISAM AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_feriado`
--

LOCK TABLES `pref_feriado` WRITE;
/*!40000 ALTER TABLE `pref_feriado` DISABLE KEYS */;
INSERT INTO `pref_feriado` VALUES (1,'2012-09-12','Biblioteca sin actividad'),(2,'2012-09-13','Biblioteca sin actividad'),(3,'2012-09-14','Biblioteca sin actividad'),(4,'2012-09-17','Biblioteca sin actividad'),(5,'2012-09-18','Biblioteca sin actividad'),(6,'2012-09-19','Biblioteca sin actividad'),(7,'2012-09-20','Biblioteca sin actividad'),(8,'2012-09-21','Biblioteca sin actividad'),(9,'2012-09-24','Biblioteca sin actividad'),(10,'2012-09-25','Biblioteca sin actividad'),(11,'2012-09-26','Biblioteca sin actividad'),(12,'2012-09-27','Biblioteca sin actividad'),(13,'2012-09-28','Biblioteca sin actividad'),(14,'2012-10-02','Biblioteca sin actividad'),(15,'2012-10-03','Biblioteca sin actividad'),(16,'2012-10-05','Biblioteca sin actividad'),(17,'2012-10-08','Biblioteca sin actividad'),(18,'2012-10-09','Biblioteca sin actividad'),(19,'2012-10-10','Biblioteca sin actividad'),(20,'2012-10-11','Biblioteca sin actividad'),(21,'2012-10-12','Biblioteca sin actividad'),(22,'2012-10-15','Biblioteca sin actividad'),(23,'2012-10-16','Biblioteca sin actividad'),(24,'2012-10-17','Biblioteca sin actividad'),(25,'2012-10-18','Biblioteca sin actividad'),(26,'2012-10-19','Biblioteca sin actividad'),(27,'2012-10-23','Biblioteca sin actividad'),(28,'2012-10-25','Biblioteca sin actividad');
/*!40000 ALTER TABLE `pref_feriado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_indicador_primario`
--

DROP TABLE IF EXISTS `pref_indicador_primario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_indicador_primario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `indicador` varchar(255) DEFAULT NULL,
  `dato` varchar(255) DEFAULT NULL,
  `campo_marc` char(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=453 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_indicador_primario`
--

LOCK TABLES `pref_indicador_primario` WRITE;
/*!40000 ALTER TABLE `pref_indicador_primario` DISABLE KEYS */;
INSERT INTO `pref_indicador_primario` VALUES (1,'1','Clave transpuesta','384'),(2,'0','Clave original','384'),(3,'#','Relación con el original desconocida','384'),(4,'#','No definido','011'),(5,'#','No definido','030'),(6,'1','Publicación seriada sin interés internacional','022'),(7,'0','Publicación seriada de interés internacional','022'),(8,'#','No se especifica nivel','022'),(9,'8','No se genera una constante de despliegue','565'),(10,'0','Características de archivos de casos','565'),(11,'#','Tamaño de archivo','565'),(12,'#','No definido','546'),(13,'#','No definido','882'),(14,'8','No se genera una constante de despliegue','537'),(15,'#','No se suministra información','537'),(16,'8','No se genera una constante de despliegue','520'),(17,'4','Advertencia sobre el contenido','520'),(18,'1','Revisión','520'),(19,'3','Resumen','520'),(20,'0','Tema','520'),(21,'#','Resumen','520'),(22,'2','Alcance y contenido','520'),(23,'1','El ítem no está en la LC','050'),(24,'0','El ítem está en la LC','050'),(25,'#','No se suministra información','050'),(26,'1','El ítem es o incluye una traducción','041'),(27,'0','El ítem no es traducción/no incluye traducción','041'),(28,'#','No se suministra información','041'),(29,'#','No definido','037'),(30,'#','No definido','850'),(31,'1','Abreviada','080'),(32,'0','Completa','080'),(33,'#','No se suministra información','080'),(34,'1','Clasificación del U.S. Dept. of Defense','052'),(35,'0','Clasificación del U.S. Dept. of Defense [OBSOLETE]','052'),(36,'7','Fuente especificada en el campo $2','052'),(37,'#','Clasificación de la Biblioteca del Congreso','052'),(38,'#','No definido','366'),(39,'1','No mostrar nota','785'),(40,'0','Mostrar nota','785'),(41,'1','No mostrar nota','767'),(42,'0','Mostrar nota','767'),(43,'#','No definido','580'),(44,'8','No se genera una constante de despliegue','522'),(45,'#','Cobertura geográfica','522'),(46,'0-9','Número de caracteres que no se alfabetizan','730'),(47,'#','Caracteres que no se alfabetizan no especificados [OBSOLETE]','730'),(48,'#','No definido','525'),(49,'1','No mostrar nota','787'),(50,'0','Mostrar nota','787'),(51,'#','No definido','512'),(52,'4','Número de videograbación','028'),(53,'1','Número de la matriz','028'),(54,'3','Otro número de música','028'),(55,'0','Número de secuencia','028'),(56,'2','Número de placa','028'),(57,'5','Otro número de editor','028'),(58,'1','No mostrar nota','775'),(59,'0','Mostrar nota','775'),(60,'8','No se genera una constante de despliegue','582'),(61,'#','No se suministra información','582'),(62,'F','t - No definido','517'),(63,'1','Fiction','517'),(64,'0','Nonfiction','517'),(65,'#','No definido','517'),(66,'#','No definido','534'),(67,'1','Apellido','400'),(68,'3','Nombre de familia','400'),(69,'0','Nombre','400'),(70,'2','Multiple surname [OBSOLETE]','400'),(71,'1','El ítem se encuentra en la NAL','070'),(72,'0','El ítem se encuentra en la NAL','070'),(73,'1','Se imprime o despliega','243'),(74,'3','Printed on card, asiento adicional del título (MU) [OBSOLETE]','243'),(75,'0','No se imprime o despliega','243'),(76,'2','Not printed on card, asiento adicional del título (MU) [OBSOLETE]','243'),(77,'1','Nombre de jurisdicción','611'),(78,'0','Nombre en orden inverso','611'),(79,'2','Nombre en orden directo','611'),(80,'#','No definido','015'),(81,'#','No definido','584'),(82,'#','No definido','753'),(83,'#','No definido','504'),(84,'#','No definido','343'),(85,'1','Apellido','700'),(86,'3','Nombre de familia','700'),(87,'0','Sólo nombre','700'),(88,'2','Multiple surname [OBSOLETE]','700'),(89,'1','Elenco','511'),(90,'3','Narrator (VM MU) [OBSOLETE]','511'),(91,'0','No se genera una constante de despliegue','511'),(92,'#','No se suministra información (VM MU) [OBSOLETE]','511'),(93,'2','Presenter (VM MU) [OBSOLETE]','511'),(94,'#','No definido','032'),(95,'#','No definido','071'),(96,'#','No definido','515'),(97,'#','No definido','350'),(98,'#','No definido','261'),(99,'#','No definido','540'),(100,'#','No definido','751'),(101,'1','Hay asiento adicional para el título','211'),(102,'0','No hay asiento adicional para el título','211'),(103,'#','No definido','527'),(104,'#','No definido','382'),(105,'#','No definido','337'),(106,'1','Campos variables de control (002-009)','886'),(107,'0','Cabecera','886'),(108,'2','Campos de información variable (010-999)','886'),(109,'#','No definido','648'),(110,'#','No definido','321'),(111,'#','No definido','026'),(112,'#','No definido','340'),(113,'1','Hay asiento agregada','247'),(114,'0','No hay asiento adicional para el título','247'),(115,'#','No definido','656'),(116,'1','Hay asiento adicional para el título','241'),(117,'0','No hay asiento adicional para el título','241'),(118,'#','No definido','585'),(119,'#','No definido','088'),(120,'1','Nombre de jurisdicción','110'),(121,'0','Nombre invertido','110'),(122,'2','Nombre en orden directo','110'),(123,'1','Nombre de jurisdicción','811'),(124,'0','Nombre en orden inverso','811'),(125,'2','Nombre en orden directo','811'),(126,'1','Primario','650'),(127,'0','No hay nivel especificado','650'),(128,'#','No se suministra información','650'),(129,'2','Secundario','650'),(130,'#','No definido','662'),(131,'#','No definido','036'),(132,'1','No mostrar nota','760'),(133,'0','Mostrar nota','760'),(134,'1','Nombre de jurisdicción','710'),(135,'0','Nombre en orden inverso','710'),(136,'2','Nombre en orden directo','710'),(137,'#','No definido','590'),(138,'F','t - Jurisdicción gubernamental (BK MP MU VM SE) [OBSOLETE]','086'),(139,'1','Publicaciones del Gobierno de Canadá: Clasificación general','086'),(140,'0','Encargado del sistema de clasificación de documentos','086'),(141,'#','No definido (BK MP MU VM SE) [OBSOLETE]','086'),(142,'4','HTTP','856'),(143,'1','FTP','856'),(144,'3','Línea telefónica (Dial-up)','856'),(145,'0','Email','856'),(146,'7','Método especificado en el subcampo $2','856'),(147,'#','No se suministra información','856'),(148,'2','Sesión remota (Telnet)','856'),(149,'#','No definido','025'),(150,'1','Historial administrativo','545'),(151,'0','Esbozo biográfico','545'),(152,'#','No se suministra información','545'),(153,'1','No mostrar nota','776'),(154,'0','Mostrar nota','776'),(155,'1','No mostrar nota','772'),(156,'0','Mostrar nota','772'),(157,'#','No definido','588'),(158,'8','No se genera una constante de despliegue','516'),(159,'#','Type of file','516'),(160,'7','Agencia identificada en el subcampo $2','016'),(161,'#','Biblioteca y archivos de Canadá','016'),(162,'#','No definido','502'),(163,'8','No se genera una constante de despliegue','307'),(164,'#','Horas','307'),(165,'#','No definido','262'),(166,'1','Nombre de jurisdicción','715'),(167,'0','Nombre en orden inverso','715'),(168,'2','Nombre en orden directo','715'),(169,'1','Hay asiento adicional para el título','212'),(170,'0','No hay asiento adicional para el título','212'),(171,'#','No definido','830'),(172,'#','No definido','754'),(173,'#','No definido','352'),(174,'#','No definido','018'),(175,'1','Escalas simples','034'),(176,'3','Rango de escalas','034'),(177,'0','Escala indeterminable/no hay escala registrada','034'),(178,'1','Primario','653'),(179,'0','No hay nivel especificado','653'),(180,'#','No se suministra información','653'),(181,'2','Secundario','653'),(182,'8','Otro elemento','355'),(183,'4','Autor','355'),(184,'1','Título','355'),(185,'3','Notas de contenido','355'),(186,'0','Documento','355'),(187,'2','Resumen','355'),(188,'5','Registro','355'),(189,'1','No privado','542'),(190,'0','Privado','542'),(191,'#','No se suministra información','542'),(192,'#','No definido','010'),(193,'1','No privado','561'),(194,'0','Privado','561'),(195,'#','No se suministra información','561'),(196,'#','No definido','651'),(197,'8','No se genera una constante de despliegue','555'),(198,'0','Ayuda de búsqueda','555'),(199,'#','Índices','555'),(200,'1','Abreviada','083'),(201,'0','Completa','083'),(202,'8','Tipo de número estándar sin especificar','024'),(203,'4','Ítem seriado e identificador de contribución (SICI)','024'),(204,'1','Código de producto universal (UPC)','024'),(205,'3','Número internacional para artículos (EAN)','024'),(206,'0','Código Estándar Internacional de Grabación (ISRC)','024'),(207,'7','Fuente especificada en el subcampo $2','024'),(208,'2','Número internacional estandarizado para música (ISMN)','024'),(209,'#','No definido','357'),(210,'#','No definido','256'),(211,'1','Nombre de jurisdicción','810'),(212,'0','Nombre en orden inverso','810'),(213,'2','Nombre en orden directo','810'),(214,'1','Primario','270'),(215,'#','No hay nivel especificado','270'),(216,'2','Secundario','270'),(217,'#','No definido','043'),(218,'6','Almacenado en estantes separados','852'),(219,'3','Clasificación del Superintendente de Documentos','852'),(220,'7','Fuente especificada en el campo $2','852'),(221,'#','No se suministra información','852'),(222,'2','Clasificación de la Biblioteca Nacional de Medicina','852'),(223,'8','Otro esquema','852'),(224,'1','Clasificación Decimal Dewey','852'),(225,'4','Número de control de almacenamiento en los estantes','852'),(226,'0','Clasificación de la Biblioteca del Congreso','852'),(227,'5','Título','852'),(228,'#','No definido','047'),(229,'#','No definido','538'),(230,'8','No se genera una constante de despliegue','524'),(231,'#','Citar como','524'),(232,'#','No definido','523'),(233,'#','No definido','046'),(234,'#','No definido','887'),(235,'1','Personal','720'),(236,'#','No definido','720'),(237,'2','Otro','720'),(238,'1','Apellido','600'),(239,'3','Nombre de familia','600'),(240,'0','Nombre','600'),(241,'2','Multiple surname [OBSOLETE]','600'),(242,'#','No definido','552'),(243,'#','No definido','336'),(244,'8','No se genera una constante de despliegue','586'),(245,'#','Premios','586'),(246,'8','No se genera una constante de despliegue','521'),(247,'4','Nivel de motivación e interés','521'),(248,'1','Nivel de interés por edad','521'),(249,'3','Características especiales de la audiencia','521'),(250,'0','Nivel de lectura','521'),(251,'#','Audiencia','521'),(252,'2','Nivel de interés por curso','521'),(253,'#','No definido','072'),(254,'8','No se genera una constante de despliegue','526'),(255,'0','Programa de lectura','526'),(256,'1','No mostrar nota','780'),(257,'0','Mostrar nota','780'),(258,'#','No definido','383'),(259,'#','No definido','255'),(260,'#','No definido','351'),(261,'#','No definido','500'),(262,'1','Nombre de jurisdicción','410'),(263,'0','Nombre en orden inverso','410'),(264,'2','Nombre en orden directo','410'),(265,'1','Se imprime o despliega','240'),(266,'3','Printed on card, asiento adicional del título (MU) [OBSOLETE]','240'),(267,'0','No se imprime o despliega','240'),(268,'2','Not printed on card, asiento adicional del título (MU) [OBSOLETE]','240'),(269,'1','Hay nota y asiento adicional del título','246'),(270,'3','No hay nota, hay asiento adicional para el título','246'),(271,'0','Hay nota, no hay asiento adicional para el título','246'),(272,'2','No hay nota y no hay asiento adicional para el título','246'),(273,'#','No definido','533'),(274,'1','No mostrar nota','786'),(275,'0','Mostrar nota','786'),(276,'1','Múltiples fechas simples','033'),(277,'0','Fecha simple','033'),(278,'#','No hay información de fecha','033'),(279,'2','Rango de fechas','033'),(280,'#','No definido','440'),(281,'1','El ítem no se encuentra en la NLM','060'),(282,'0','El ítem se encuentra en la NLM','060'),(283,'#','No se suministra información','060'),(284,'#','No definido','752'),(285,'0-9','Número de caracteres que no se alfabetizan','740'),(286,'#','Caracteres que no se alfabetizan no especificado [OBSOLETE]','740'),(287,'8','No se genera una constante de despliegue','556'),(288,'#','Documentación','556'),(289,'#','No definido','536'),(290,'#','No definido','550'),(291,'#','No definido','051'),(292,'#','No definido','085'),(293,'#','No definido','027'),(294,'1','Sistema de coordinadas verticales','342'),(295,'0','Sistema de coordinadas horizontales','342'),(296,'#','No definido','263'),(297,'8','No se genera una constante de despliegue','505'),(298,'1','Contenido incompleto','505'),(299,'0','Contenido','505'),(300,'2','Contenido parcial','505'),(301,'1','Depositario de originales','535'),(302,'3','Holder of oral tapes (AM) [OBSOLETE]','535'),(303,'0','Repository (AM) [OBSOLETE]','535'),(304,'2','Depositario de duplicados','535'),(305,'1','La obra no se encuentra en la LAC','055'),(306,'0','La obra se encuentra en la LAC','055'),(307,'#','Información no disponible','055'),(308,'1','Nombre jurisdiccional','610'),(309,'0','Nombre en orden inverso','610'),(310,'2','Nombre en orden directo','610'),(311,'#','No definido','514'),(312,'1','Hay asiento adicional para el título','214'),(313,'0','No hay asiento adicional para el título','214'),(314,'1','No privado','541'),(315,'0','Privado','541'),(316,'#','No se suministra información','541'),(317,'#','No definido','508'),(318,'#','No definido','513'),(319,'#','No definido','090'),(320,'#','No definido','304'),(321,'#','No definido','563'),(322,'#','No definido','547'),(323,'1','Hay asiento adicional para el título','210'),(324,'0','No hay asiento adicional para el título','210'),(325,'#','No definido','258'),(326,'1','No mostrar nota','765'),(327,'0','Mostrar nota','765'),(328,'#','No definido','038'),(329,'#','No definido','657'),(330,'#','No definido','042'),(331,'#','No definido','302'),(332,'4','Se indica la ubicación dentro de la fuente','510'),(333,'1','Cobertura completa','510'),(334,'3','No se indica la ubicación dentro de la fuente','510'),(335,'0','Cobertura desconocida','510'),(336,'2','Cobertura selectiva','510'),(337,'1','No mostrar nota','774'),(338,'0','Mostrar nota','774'),(339,'#','No definido','530'),(340,'#','No definido','061'),(341,'#','No definido','020'),(342,'3','Editor actual/último','260'),(343,'#','No corresponde/No se suministra información/Primer editor disponible','260'),(344,'2','Editor que interviene','260'),(345,'#','No definido','507'),(346,'#','No definido','658'),(347,'#','No definido','365'),(348,'#','No definido','074'),(349,'#','No definido','306'),(350,'#','No definido','503'),(351,'1','No mostrar nota','770'),(352,'0','Mostrar nota','770'),(353,'1','No mostrar nota','762'),(354,'0','Mostrar nota','762'),(355,'#','No definido','013'),(356,'#','No definido','035'),(357,'#','No definido','315'),(358,'8','No se genera una constante de despliegue','567'),(359,'#','Metodología','567'),(360,'1','Se aplican restricciones','506'),(361,'0','No hay restricciones','506'),(362,'#','No se suministra información','506'),(363,'1','Edición abreviada','082'),(364,'0','Edición completa','082'),(365,'#','No se suministra información de edición (BK CF MU VM SE) [OBSOLETE]','082'),(366,'2','Versión NST abreviada (BK MU VM SE) [OBSOLETE]','082'),(367,'#','No definido','338'),(368,'1','Primario','654'),(369,'0','No hay nivel especificado','654'),(370,'#','No se suministra información','654'),(371,'2','Secundario','654'),(372,'#','No definido','570'),(373,'1','Apellido','100'),(374,'3','Nombre de familia','100'),(375,'0','Nombre propio','100'),(376,'2','Multiple surname [OBSOLETE]','100'),(377,'#','No definido','380'),(378,'#','No definido','222'),(379,'#','No definido','300'),(380,'#','No definido','310'),(381,'#','No definido','250'),(382,'#','No definido','303'),(383,'1','Apellido','800'),(384,'3','Nombre de familia','800'),(385,'0','Nombre','800'),(386,'0','Facetado','655'),(387,'#','Básico','655'),(388,'#','No definido','031'),(389,'#','No definido','305'),(390,'#','No definido','381'),(391,'8','No se genera una constante de despliegue','581'),(392,'#','Publicaciones','581'),(393,'#','No definido','308'),(394,'#','No definido','254'),(395,'#','No definido','501'),(396,'1','Materiales relacionados','544'),(397,'0','Materiales asociados','544'),(398,'#','No se suministra información','544'),(399,'#','No definido','091'),(400,'#','No definido','044'),(401,'1','Asiento de serie diferente al descriptivo','490'),(402,'0','No se asigna un asiento a la serie','490'),(403,'0-9','Número de caracteres que no se alfabetizan presentes','130'),(404,'#','Caracteres que no se alfabetizan no especificados [OBSOLETE]','130'),(405,'#','No definido','755'),(406,'1','Hay asiento adicional para el título','245'),(407,'0','No hay asiento adicional para el título','245'),(408,'1','No mostrar nota','777'),(409,'0','Mostrar nota','777'),(410,'1','No mostrar nota','773'),(411,'0','Mostrar nota','773'),(412,'1','Información final','363'),(413,'0','Información inicial','363'),(414,'#','No se suministra información','363'),(415,'#','No definido','084'),(416,'1','No privado','583'),(417,'0','Privado','583'),(418,'#','No se suministra información','583'),(419,'#','No definido','066'),(420,'#','No definido','040'),(421,'#','No definido','257'),(422,'#','No definido','301'),(423,'#','No definido','562'),(424,'#','No definido','840'),(425,'#','No definido','048'),(426,'0-9','Número de caracteres que no se alfabetizan','630'),(427,'#','Caracteres que no se alfabetizan no especificados [OBSOLETE]','630'),(428,'#','No definido','518'),(429,'1','Nombre de jurisdicción','111'),(430,'0','Nombre en orden inverso','111'),(431,'2','Nombre en orden directo','111'),(432,'#','No definido','017'),(433,'1','Múltiples fechas/horas simples','045'),(434,'0','Fecha/hora simple','045'),(435,'#','Subcampo $b o $c no presente','045'),(436,'2','Rango de fechas/horas','045'),(437,'1','Estilo sin formato','362'),(438,'0','Estilo con formato','362'),(439,'#','No definido','652'),(440,'#','No definido','265'),(441,'1','Nombre de jurisdicción','711'),(442,'0','Nombre en orden inverso','711'),(443,'2','Nombre en orden directo','711'),(444,'1','Nombre de jurisdicción','411'),(445,'0','Nombre en orden inverso','411'),(446,'2','Nombre en orden directo','411'),(447,'1','Single surname','705'),(448,'3','Family name','705'),(449,'0','Forename','705'),(450,'2','Multiple surname','705'),(451,'1','Hay asiento adicional para el título','242'),(452,'0','No hay asiento adicional para el título','242');
/*!40000 ALTER TABLE `pref_indicador_primario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_indicador_secundario`
--

DROP TABLE IF EXISTS `pref_indicador_secundario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_indicador_secundario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `indicador` varchar(255) DEFAULT NULL,
  `dato` varchar(255) DEFAULT NULL,
  `campo_marc` char(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=428 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_indicador_secundario`
--

LOCK TABLES `pref_indicador_secundario` WRITE;
/*!40000 ALTER TABLE `pref_indicador_secundario` DISABLE KEYS */;
INSERT INTO `pref_indicador_secundario` VALUES (1,'#','No definido','384'),(2,'#','No definido','011'),(3,'#','No definido','030'),(4,'#','No definido','022'),(5,'#','No definido','565'),(6,'#','No definido','546'),(7,'#','No definido','882'),(8,'#','No definido','537'),(9,'#','No definido','520'),(10,'4','Número asignado por una agencia diferente a la LC','050'),(11,'0','Asignado por la LC','050'),(12,'#','No se suministra información [OBSOLETE]','050'),(13,'7','Fuente identificada en subcampo $2','041'),(14,'#','Lista de códigos MARC','041'),(15,'#','No definido','037'),(16,'#','No definido','850'),(17,'#','No definido','080'),(18,'#','No definido','052'),(19,'#','No definido','366'),(20,'6','Separado en ... y ...','785'),(21,'3','Sustituido por la parte','785'),(22,'7','Unido con ... para formar ...','785'),(23,'2','Sustituido por','785'),(24,'8','Cambiado de vuelta como','785'),(25,'1','Continuado por la parte','785'),(26,'4','Absorbido','785'),(27,'0','Continuado por','785'),(28,'5','Absorbido en parte por','785'),(29,'8','No se genera una constante de despliegue','767'),(30,'#','Traducido como','767'),(31,'#','No definido','580'),(32,'#','No definido','522'),(33,'1','Printed on card (VM) [OBSOLETE]','730'),(34,'3','Not printed on card (VM) [OBSOLETE]','730'),(35,'0','Entrada alternativa (BK CF MP MU SE MX) [OBSOLETE]','730'),(36,'#','No se suministra información','730'),(37,'2','Asiento analítico','730'),(38,'#','No definido','525'),(39,'8','No se genera una constante de despliegue','787'),(40,'#','Ítem relacionado','787'),(41,'#','No definido','512'),(42,'1','Requiere nota, requiere asiento adicional del título','028'),(43,'3','No requiere nota, requiere asiento adicional del título','028'),(44,'0','No requiere nota, no requiere asiento adicional para el título','028'),(45,'2','Requiere nota, no requiere asiento adicional para el título','028'),(46,'8','No se genera una constante de despliegue','775'),(47,'#','Otra edición disponible','775'),(48,'#','No definido','582'),(49,'#','No definido','517'),(50,'#','No definido','534'),(51,'1','Asiento principal representado por pronombre','400'),(52,'0','Asiento principal no representado por pronombre','400'),(53,'#','No definido','070'),(54,'0-9','Número de caracteres que no se alfabetizan','243'),(55,'6','Répertoire de vedettes-matière','611'),(56,'4','Fuente no especificada','611'),(57,'1','Encabezamientos de la Biblioteca del Congreso para literatura infantil','611'),(58,'3','Archivo de autoridades de materia de la Biblioteca Nacional de Agricultura de los Estados Unidos','611'),(59,'0','Lista de encabezamientos de la Biblioteca del Congreso','611'),(60,'7','Fuente especificada en el campo $2','611'),(61,'2','Encabezamientos médicos','611'),(62,'5','Lista de Encabezamientos de la Biblioteca Nacional de Canadá','611'),(63,'#','No definido','015'),(64,'#','No definido','584'),(65,'#','No definido','753'),(66,'#','No definido','504'),(67,'#','No definido','343'),(68,'1','Printed on card (VM) [OBSOLETE]','700'),(69,'3','Not printed on card (VM) [OBSOLETE]','700'),(70,'0','Asiento alternativo (BK CF MP MU SE MX) [OBSOLETE]','700'),(71,'#','No se suministra información','700'),(72,'2','Asiento analítico','700'),(73,'#','No definido','511'),(74,'#','No definido','032'),(75,'#','No definido','071'),(76,'#','No definido','515'),(77,'#','No definido','350'),(78,'#','No definido','261'),(79,'#','No definido','540'),(80,'#','No definido','751'),(81,'0-9','Número de caracteres que no se alfabetizan presentes','211'),(82,'#','No definido','527'),(83,'#','No definido','382'),(84,'#','No definido','337'),(85,'#','No definido','886'),(86,'6','Répertoire de vedettes-matière','648'),(87,'4','Fuente no especificada','648'),(88,'1','Encabezamientos de la Biblioteca del Congreso para literatura infantil','648'),(89,'3','Archivo de autoridades de materia de la Biblioteca Nacional de Agricultura de los Estados Unidos','648'),(90,'0','Lista de encabezamientos de la Biblioteca del Congreso','648'),(91,'7','Fuente especificada en el campo $2','648'),(92,'2','Encabezamientos médicos','648'),(93,'5','Lista de Encabezamientos de la Biblioteca Nacional de Canadá','648'),(94,'#','No definido','321'),(95,'#','No definido','026'),(96,'#','No definido','340'),(97,'1','No mostrar nota','247'),(98,'0','Mostrar nota','247'),(99,'7','Fuente especificada en el campo $2','656'),(100,'0-9','Número de caracteres que no se alfabetizan','241'),(101,'#','No definido','585'),(102,'#','No definido','088'),(103,'#','No definido','110'),(104,'#','No definido','811'),(105,'6','Répertoire de vedettes-matière','650'),(106,'4','Fuente no especificada','650'),(107,'1','Encabezamientos de la Biblioteca del Congreso para literatura infantil','650'),(108,'3','Archivo de autoridades de materia de la Biblioteca Nacional de Agricultura de los Estados Unidos','650'),(109,'0','Lista de encabezamientos de la Biblioteca del Congreso','650'),(110,'7','Fuente especificada en el campo $2','650'),(111,'2','Encabezamientos médicos','650'),(112,'5','Lista de Encabezamientos de la Biblioteca Nacional de Canadá','650'),(113,'#','No definido','662'),(114,'#','No definido','036'),(115,'8','No se genera una constante de despliegue','760'),(116,'#','Serie principal','760'),(117,'1','Printed on card (VM) [OBSOLETE]','710'),(118,'3','Not printed on card (VM) [OBSOLETE]','710'),(119,'0','Entrada alternativa (BK CF MP MU SE MX) [OBSOLETE]','710'),(120,'#','No se suministra información','710'),(121,'2','Asiento analítico','710'),(122,'#','No definido','590'),(123,'#','No definido','086'),(124,'8','No se genera una constante de despliegue','856'),(125,'1','Versión del recurso','856'),(126,'0','Recurso','856'),(127,'#','No se suministra información','856'),(128,'2','Recurso relacionado','856'),(129,'#','No definido','025'),(130,'#','No definido','545'),(131,'8','No se genera una constante de despliegue','776'),(132,'#','Disponible en otra forma','776'),(133,'8','No se genera una constante de despliegue','772'),(134,'0','Principal','772'),(135,'#','Suplemento de','772'),(136,'#','No definido','588'),(137,'#','No definido','516'),(138,'#','No definido','016'),(139,'#','No definido','502'),(140,'#','No definido','307'),(141,'#','No definido','262'),(142,'1','Hay asiento adicional para el título','715'),(143,'0','Asiento alternativo','715'),(144,'2','Asiento analítico','715'),(145,'#','No definido','212'),(146,'0-9','Número de caracteres que no se alfabetizan','830'),(147,'#','No definido','754'),(148,'#','No definido','352'),(149,'#','No definido','018'),(150,'1','Anillo de exclusión','034'),(151,'0','Anillo exterior','034'),(152,'#','No corresponde','034'),(153,'6','Término de género/forma','653'),(154,'4','Término cronológico','653'),(155,'1','Nombre personal','653'),(156,'3','Nombre de reunión','653'),(157,'0','Término de tema','653'),(158,'#','No se suministra información','653'),(159,'2','Nombre corporativo','653'),(160,'5','Nombre geográfico','653'),(161,'#','No definido','355'),(162,'S','nd - No definido','542'),(163,'F','t - No definido','542'),(164,'','','542'),(165,'$',' Vínculo de campo y número de secuencia (R)','542'),(166,'I','cators','542'),(167,'#','No definido','542'),(168,'5','- SOLICITATION INFORMATION Nota (AM) (R) [OBSOLETE]','542'),(169,'#','No definido','010'),(170,'#','No definido','561'),(171,'6','Répertoire de vedettes-matière','651'),(172,'4','Fuente no especificada','651'),(173,'1','Encabezamientos de la Biblioteca del Congreso para literatura infantil','651'),(174,'3','Archivo de autoridades de materia de la Biblioteca Nacional de Agricultura de los Estados Unidos','651'),(175,'0','Lista de encabezamientos de la Biblioteca del Congreso','651'),(176,'7','Fuente especificada en el campo $2','651'),(177,'2','Encabezamientos médicos','651'),(178,'5','Lista de Encabezamientos de la Biblioteca Nacional de Canadá','651'),(179,'#','No definido','555'),(180,'#','No definido','083'),(181,'1','Hay diferencia','024'),(182,'0','No hay diferencia','024'),(183,'#','No se suministra información','024'),(184,'F','t - No definido','357'),(185,'','','357'),(186,'$',' Vínculo de campo y número de secuencia (R)','357'),(187,'S','nd - No definido','357'),(188,'3','- RENTAL PRICE (VM) [OBSOLETE]','357'),(189,'I','cators','357'),(190,'#','No definido','357'),(191,'#','No definido','256'),(192,'#','No definido','810'),(193,'0','Postal','270'),(194,'7','Tipo especificado en subcampo $i','270'),(195,'#','No hay tipo especificado','270'),(196,'#','No definido','043'),(197,'1','Enumeración principal','852'),(198,'0','No enumerado','852'),(199,'#','No se suministra información','852'),(200,'2','Enumeración alternativa','852'),(201,'7','Fuente especificada en el subcampo $2','047'),(202,'#','Código MARC de la composición musical','047'),(203,'#','No definido','538'),(204,'#','No definido','524'),(205,'#','No definido','523'),(206,'#','No definido','046'),(207,'#','No definido','887'),(208,'#','No definido','720'),(209,'6','Répertoire de vedettes-matière','600'),(210,'4','Fuente no especificada','600'),(211,'1','Encabezamientos de la Biblioteca del Congreso para literatura infantil','600'),(212,'3','Archivo de autoridades de materia de la Biblioteca Nacional de Agricultura de los Estados Unidos','600'),(213,'0','Lista de encabezamientos de la Biblioteca del Congreso','600'),(214,'7','Fuente especificada en el campo $2','600'),(215,'2','Encabezamientos médicos','600'),(216,'5','Lista de Encabezamientos de la Biblioteca Nacional de Canadá','600'),(217,'#','No definido','552'),(218,'#','No definido','336'),(219,'#','No definido','586'),(220,'#','No definido','521'),(221,'0','Lista de códigos de categoría temática de NAL','072'),(222,'7','Código fuente especificado en el subcampo $2','072'),(223,'#','No definido','526'),(224,'6','Absorbido en parte','780'),(225,'4','Formado por la unión de ... y ...','780'),(226,'1','Continúa en la parte','780'),(227,'3','Sustituye en parte','780'),(228,'0','Continúa','780'),(229,'7','Separado de','780'),(230,'2','Sustituye','780'),(231,'5','Absorbido','780'),(232,'#','No definido','383'),(233,'#','No definido','255'),(234,'#','No definido','351'),(235,'#','No definido','500'),(236,'1','Asiento principal representada por pronombre','410'),(237,'0','Asiento principal no representada por pronombre','410'),(238,'0-9','Número de caracteres que no se alfabetizan','240'),(239,'6','Titulillo','246'),(240,'3','Otro título','246'),(241,'7','Título corrido','246'),(242,'#','No se especifica tipo','246'),(243,'2','Título distintivo','246'),(244,'8','Título del lomo','246'),(245,'1','Título paralelo','246'),(246,'4','Título de cubierta','246'),(247,'0','Porción del título','246'),(248,'5','Título agregado, título de página','246'),(249,'#','No definido','533'),(250,'8','No se genera una constante de despliegue','786'),(251,'#','Origen de datos','786'),(252,'1','Transmisión','033'),(253,'0','Captura','033'),(254,'#','No se suministra información','033'),(255,'2','Hallazgo','033'),(256,'0-9','Número de caracteres que no se alfabetizan','440'),(257,'4','Número asignado por una agencia diferente a la NLM','060'),(258,'0','Asignado por la NLM','060'),(259,'#','No se suministra información [OBSOLETE]','060'),(260,'#','No definido','752'),(261,'1','Printed on card (VM) [OBSOLETE]','740'),(262,'3','Not printed on card (VM) [OBSOLETE]','740'),(263,'0','Entrada alternativa (BK AM CF MP MU) [OBSOLETE]','740'),(264,'#','No se suministra información','740'),(265,'2','Asiento analítico','740'),(266,'#','No definido','556'),(267,'#','No definido','536'),(268,'#','No definido','550'),(269,'S','nd - Series call number (SE) [OBSOLETE]','051'),(270,'1','Serie principal','051'),(271,'3','Sub-subserie','051'),(272,'0','No hay serie','051'),(273,'#','No definido','051'),(274,'2','Subserie','051'),(275,'#','No definido','085'),(276,'#','No definido','027'),(277,'6','Altitud','342'),(278,'3','Plano local','342'),(279,'7','Método especificado en $2','342'),(280,'2','Sistema de coordenadas en malla','342'),(281,'8','Profundidad','342'),(282,'1','Proyección de mapa','342'),(283,'4','Local','342'),(284,'0','Geográfico','342'),(285,'5','Modelo geodésico','342'),(286,'#','No definido','263'),(287,'0','Aumentado','505'),(288,'#','Básico','505'),(289,'#','No definido','535'),(290,'6','Otro número de ubicación asignado por la LAC','055'),(291,'3','Número de ubicación basado en la LC asignado por la biblioteca que contribuye','055'),(292,'7','Otro número de clase asignado por la LAC','055'),(293,'9','Otro número de clase asignado por la biblioteca que contribuye','055'),(294,'2','Número de clase LC incompleto asignado por la LAC','055'),(295,'8','Otro número de ubicación asignado por la biblioteca que contribuye','055'),(296,'1','Número de clase LC completo asignado por la LAC','055'),(297,'4','Número de clase LC completo asignado por la biblioteca que contribuye','055'),(298,'0','Número de ubicación basado en la LC asignado por la LAC','055'),(299,'5','Número de clase LC incompleto asignado por la biblioteca que contribuye','055'),(300,'6','Répertoire de vedettes-matière','610'),(301,'4','Fuente no especificada','610'),(302,'1','Encabezamientos de la Biblioteca del Congreso para literatura infantil','610'),(303,'3','Archivo de autoridades de materia de la Biblioteca Nacional de Agricultura de los Estados Unidos','610'),(304,'0','Lista de encabezamientos de la Biblioteca del Congreso','610'),(305,'7','Fuente especificada en el campo $2','610'),(306,'2','Encabezamientos médicos','610'),(307,'5','Lista de Encabezamientos de la Biblioteca Nacional de Canadá','610'),(308,'#','No definido','514'),(309,'0-9','Número de caracteres que no se alfabetizan present','214'),(310,'#','No definido','541'),(311,'#','No definido','508'),(312,'#','No definido','513'),(313,'#','No definido','090'),(314,'#','No definido','304'),(315,'#','No definido','563'),(316,'#','No definido','547'),(317,'0','Otro título abreviado','210'),(318,'#','Título clave abreviado','210'),(319,'#','No definido','258'),(320,'8','No se genera una constante de despliegue','765'),(321,'#','Traducción de','765'),(322,'#','No definido','038'),(323,'7','Fuente especificada en el campo $2','657'),(324,'#','No definido','042'),(325,'#','No definido','302'),(326,'#','No definido','510'),(327,'8','No se genera una constante de despliegue','774'),(328,'#','Unidad constituyente','774'),(329,'#','No definido','530'),(330,'#','No definido','061'),(331,'#','No definido','020'),(332,'#','No definido','260'),(333,'#','No definido','507'),(334,'#','No definido','658'),(335,'#','No definido','365'),(336,'#','No definido','074'),(337,'#','No definido','306'),(338,'#','No definido','503'),(339,'8','No se genera una constante de despliegue','770'),(340,'#','Tiene suplemento','770'),(341,'8','No se genera una constante de despliegue','762'),(342,'#','Tiene subserie','762'),(343,'#','No definido','013'),(344,'#','No definido','035'),(345,'#','No definido','315'),(346,'#','No definido','567'),(347,'#','No definido','506'),(348,'4','Asignado por otra agencia diferente de la LC','082'),(349,'0','Asignado por la LC','082'),(350,'#','No se suministra información','082'),(351,'#','No definido','338'),(352,'#','No definido','654'),(353,'#','No definido','570'),(354,'#','No definido','100'),(355,'#','No definido','380'),(356,'0-9','Número de caracteres que no se alfabetizan','222'),(357,'#','No definido','300'),(358,'#','No definido','310'),(359,'#','No definido','250'),(360,'#','No definido','303'),(361,'#','No definido','800'),(362,'6','Répertoire de vedettes-matière','655'),(363,'4','Fuente no especificada','655'),(364,'1','Encabezamientos de la Biblioteca del Congreso para literatura infantil','655'),(365,'3','Archivo de autoridades de materia de la Biblioteca Nacional de Agricultura de los Estados Unidos','655'),(366,'0','Lista de encabezamientos de la Biblioteca del Congreso','655'),(367,'7','Fuente especificada en el campo $2','655'),(368,'2','Encabezamientos médicos','655'),(369,'5','Lista de Encabezamientos de la Biblioteca Nacional de Canadá','655'),(370,'#','No definido','031'),(371,'#','No definido','305'),(372,'#','No definido','381'),(373,'#','No definido','581'),(374,'#','No definido','308'),(375,'#','No definido','254'),(376,'#','No definido','501'),(377,'#','No definido','544'),(378,'#','No definido','091'),(379,'#','No definido','044'),(380,'#','No definido','490'),(381,'#','No definido','130'),(382,'#','No definido','755'),(383,'0-9','Número de caracteres que no se alfabetizan','245'),(384,'8','No se genera una constante de despliegue','777'),(385,'#','Emitido con','777'),(386,'8','No se genera una constante de despliegue','773'),(387,'#','En','773'),(388,'1','Abierta','363'),(389,'0','Cerrada','363'),(390,'#','No especificado','363'),(391,'#','No definido','084'),(392,'#','No definido','583'),(393,'#','No definido','066'),(394,'#','No definido','040'),(395,'#','No definido','257'),(396,'#','No definido','301'),(397,'#','No definido','562'),(398,'0-9','Número de caracteres que no se alfabetizan','840'),(399,'7','Fuente especificada en subcampo $2','048'),(400,'#','Código MARC','048'),(401,'6','Répertoire de vedettes-matière','630'),(402,'4','Fuente no especificada','630'),(403,'1','Encabezamientos de la Biblioteca del Congreso para literatura infantil','630'),(404,'3','Archivo de autoridades de materia de la Biblioteca Nacional de Agricultura de los Estados Unidos','630'),(405,'0','Lista de encabezamientos de la Biblioteca del Congreso','630'),(406,'7','Fuente especificada en el campo $2','630'),(407,'2','Encabezamientos médicos','630'),(408,'5','Lista de Encabezamientos de la Biblioteca Nacional de Canadá','630'),(409,'#','No definido','518'),(410,'#','No definido','111'),(411,'8','No se generó controlador de constante de muestra','017'),(412,'#','Número de registro de depósito legal o derecho de autor','017'),(413,'#','No definido','045'),(414,'#','No definido','362'),(415,'#','No definido','652'),(416,'#','No definido','265'),(417,'1','Printed on card (VM) [OBSOLETE]','711'),(418,'3','Not printed on card (VM) [OBSOLETE]','711'),(419,'0','asiento alternativa (BK CF MP MU SE MX) [OBSOLETE]','711'),(420,'#','No se suministra información','711'),(421,'2','Asiento analítico','711'),(422,'1','Asiento principal representada por pronombre','411'),(423,'0','Asiento principal no representada por pronombre','411'),(424,'1','Asiento adicional del título','705'),(425,'0','Asiento alternativo','705'),(426,'2','Asiento analítico','705'),(427,'0-9','Número de caracteres que no se alfabetizan','242');
/*!40000 ALTER TABLE `pref_indicador_secundario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_informacion_referencia`
--

DROP TABLE IF EXISTS `pref_informacion_referencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_informacion_referencia` (
  `idinforef` int(11) NOT NULL AUTO_INCREMENT,
  `idestcat` int(11) NOT NULL,
  `referencia` varchar(255) DEFAULT NULL,
  `orden` varchar(255) DEFAULT NULL,
  `campos` varchar(255) DEFAULT NULL,
  `separador` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`idinforef`),
  KEY `idestcat` (`idestcat`)
) ENGINE=InnoDB AUTO_INCREMENT=283 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_informacion_referencia`
--

LOCK TABLES `pref_informacion_referencia` WRITE;
/*!40000 ALTER TABLE `pref_informacion_referencia` DISABLE KEYS */;
INSERT INTO `pref_informacion_referencia` VALUES (1,45,'autores','nacionalidad','completo','?'),(2,46,'temas','nombre','nombre',','),(3,47,'bibliolevel','description','description',','),(5,45,'countries','printable_name','printable_name','/'),(6,45,'languages','description','description','/'),(18,61,'idioma','description','description',','),(22,67,'ciudad','NOMBRE','NOMBRE',','),(23,68,'soporte','description','description',','),(25,71,'autor','completo','completo',','),(26,73,'tema','-1','id nombre',''),(27,74,'ui','id_ui','id_ui',NULL),(29,72,'ui','nombre','nombre',NULL),(30,79,'ui','nombre','nombre',NULL),(32,89,'pais','iso','iso',NULL),(42,113,'autor','completo','completo',NULL),(48,109,'autor','completo','completo',NULL),(50,114,'ciudad','NOMBRE','NOMBRE',NULL),(53,134,'pais','iso','iso',NULL),(61,128,'ui','id_ui','id_ui',NULL),(64,120,'autor','nombre','nombre',NULL),(67,199,'autor','completo','completo',NULL),(71,195,'autor','completo','completo',NULL),(74,67,'ciudad','LOCALIDAD','LOCALIDAD',NULL),(76,217,'ciudad','LOCALIDAD','LOCALIDAD',NULL),(77,216,'autor','completo','completo',NULL),(78,66,'autor','nombre','nombre',NULL),(85,60,'pais','iso','iso',NULL),(88,132,'tema','nombre','nombre',NULL),(89,233,'tema','nombre','nombre',NULL),(91,237,'autor','nombre','nombre',NULL),(93,235,'autor','completo','completo',NULL),(94,245,'autor','nombre','nombre',NULL),(97,236,'autor','completo','completo',NULL),(98,246,'autor','nombre','nombre',NULL),(99,247,'autor','nombre','nombre',NULL),(101,248,'tema','nombre','nombre',NULL),(106,250,'autor','nombre','nombre',NULL),(107,252,'autor','nombre','nombre',NULL),(108,253,'autor','nombre','nombre',NULL),(109,254,'idioma','nombre','nombre',NULL),(110,232,'idioma','nombre','nombre',NULL),(114,268,'autor','nombre','nombre',NULL),(117,270,'tema','nombre','nombre',NULL),(118,272,'idioma','idLanguage','idLanguage',NULL),(119,266,'autor','completo','completo',NULL),(120,273,'ciudad','NOMBRE','NOMBRE',NULL),(121,280,'ciudad','NOMBRE','NOMBRE',NULL),(122,241,'tipo_ejemplar','nombre','nombre',NULL),(124,282,'autor','nombre','nombre',NULL),(126,283,'autor','nombre','nombre',NULL),(128,288,'idioma','description','description',NULL),(132,317,'ciudad','LOCALIDAD','LOCALIDAD',NULL),(136,62,'nivel_bibliografico','id','id',NULL),(137,56,'tipo_ejemplar','id_tipo_doc','id_tipo_doc',NULL),(138,321,'tipo_ejemplar','id_tipo_doc','id_tipo_doc',NULL),(143,116,'autor','completo','completo',NULL),(147,323,'nivel_bibliografico','description','description',NULL),(148,138,'idioma','description','description',NULL),(149,68,'soporte','description','description',NULL),(150,215,'ciudad','NOMBRE','NOMBRE',NULL),(151,324,'ciudad','NOMBRE','NOMBRE',NULL),(153,333,'idioma','code','code',NULL),(158,334,'idioma','description','description',NULL),(159,292,'autor','completo','completo',NULL),(160,296,'autor','completo','completo',NULL),(161,297,'autor','completo','completo',NULL),(162,299,'tema','nombre','nombre',NULL),(163,305,'autor','completo','completo',NULL),(164,310,'nivel_bibliografico','description','description',NULL),(165,311,'tipo_ejemplar','nombre','nombre',NULL),(169,335,'pais','iso','iso',NULL),(171,337,'autor','completo','completo',NULL),(173,341,'autor','completo','completo',NULL),(175,342,'autor','completo','completo',NULL),(177,346,'ciudad','NOMBRE_ABREVIADO','NOMBRE_ABREVIADO',NULL),(181,350,'autor','completo','completo',NULL),(186,369,'nivel_bibliografico','description','description',NULL),(187,370,'tipo_ejemplar','nombre','nombre',NULL),(189,371,'tipo_ejemplar','nombre','nombre',NULL),(193,359,'ciudad','NOMBRE_ABREVIADO','NOMBRE_ABREVIADO',NULL),(194,356,'idioma','description','description',NULL),(195,357,'soporte','description','description',NULL),(196,373,'pais','nombre_largo','nombre_largo',NULL),(197,372,'pais','nombre_largo','nombre_largo',NULL),(199,377,'autor','completo','completo',NULL),(202,378,'autor','completo','completo',NULL),(204,380,'autor','completo','completo',NULL),(205,381,'autor','completo','completo',NULL),(207,383,'autor','completo','completo',NULL),(208,385,'idioma','description','description',NULL),(210,389,'autor','completo','completo',NULL),(211,348,'tema','nombre','nombre',NULL),(212,391,'tipo_ejemplar','nombre','nombre',NULL),(213,392,'autor','completo','completo',NULL),(214,150,'nivel2','id','id',NULL),(215,376,'tema','nombre','nombre',NULL),(220,394,'autor','completo','completo',NULL),(221,395,'autor','completo','completo',NULL),(223,407,'autor','completo','completo',NULL),(224,405,'tema','nombre','nombre',NULL),(225,409,'idioma','description','description',NULL),(226,410,'pais','nombre_largo','nombre_largo',NULL),(227,411,'soporte','description','description',NULL),(228,412,'ciudad','NOMBRE','NOMBRE',NULL),(229,417,'nivel_bibliografico','description','description',NULL),(230,418,'tipo_ejemplar','nombre','nombre',NULL),(234,423,'autor','completo','completo',NULL),(235,320,'ciudad','NOMBRE','NOMBRE',NULL),(238,240,'nivel_bibliografico','description','description',NULL),(239,444,'autor','completo','completo',NULL),(240,448,'autor','completo','completo',NULL),(241,449,'autor','completo','completo',NULL),(242,452,'tema','nombre','nombre',NULL),(243,454,'autor','completo','completo',NULL),(244,460,'idioma','description','description',NULL),(245,461,'pais','nombre_largo','nombre_largo',NULL),(246,462,'soporte','description','description',NULL),(247,464,'ciudad','NOMBRE','NOMBRE',NULL),(248,477,'nivel_bibliografico','description','description',NULL),(249,478,'tipo_ejemplar','nombre','nombre',NULL),(250,322,'tipo_ejemplar','nombre','nombre',NULL),(252,480,'pais','nombre_largo','nombre_largo',NULL),(254,479,'idioma','description','description',NULL),(255,481,'soporte','description','description',NULL),(256,482,'autor','completo','completo',NULL),(257,325,'editorial','editorial','editorial',NULL),(261,167,'autor','completo','completo',NULL),(262,52,'ui','ALL','JSONcircRef:orden',NULL),(263,55,'estado','ALL','JSONcircRef:orden',NULL),(264,54,'disponibilidad','ALL','JSONcircRef:orden',NULL),(275,507,'tipo_ejemplar','nombre','nombre',NULL),(276,508,'ui','nombre','nombre',NULL),(277,509,'ui','nombre','nombre',NULL),(278,513,'disponibilidad','nombre','nombre',NULL),(279,510,'estado','nombre','nombre',NULL),(280,502,'ui','nombre','nombre',NULL),(281,501,'ui','nombre','nombre',NULL),(282,422,'autor','completo','completo',NULL);
/*!40000 ALTER TABLE `pref_informacion_referencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_preferencia_sistema`
--

DROP TABLE IF EXISTS `pref_preferencia_sistema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_preferencia_sistema` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `variable` varchar(50) DEFAULT NULL,
  `value` mediumtext,
  `explanation` text,
  `options` mediumtext,
  `type` varchar(20) DEFAULT NULL,
  `categoria` varchar(255) DEFAULT NULL,
  `label` varchar(128) DEFAULT NULL,
  `explicacion_interna` text,
  `revisado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2968 DEFAULT CHARSET=utf8 PACK_KEYS=1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_preferencia_sistema`
--

LOCK TABLES `pref_preferencia_sistema` WRITE;
/*!40000 ALTER TABLE `pref_preferencia_sistema` DISABLE KEYS */;
INSERT INTO `pref_preferencia_sistema` VALUES (2,'dateformat','metric','date format (us mm/dd/yyyy, metric dd/mm/yyy, ISO yyyy/mm/dd)','metric|us|iso','text','sistema','Formato de fecha','date format (us mm/dd/yyyy, metric dd/mm/yyy, ISO yyyy/mm/dd)',0),(4,'insecure','0','If YES,  careful if you set this to yes!no auth at all is needed. Be',NULL,'bool','internal','Permite la operación sin estar autenticado','If YES,  careful if you set this to yes!no auth at all is needed. Be',1),(7,'timeout','1200','Inactivity timeout for cookies authentication (in seconds)',NULL,'text','internal','Tiempo para que se venza la sesión de usuario ','Inactivity timeout for cookies authentication (in seconds)',1),(8,'maxreserves','2','Número máximo de reservas que un usuario puede hacer',NULL,'text','circulacion','Máximo de reservas','Número máximo de reservas que un usuario puede hacer',0),(13,'libreDeuda','10101','Variable que limita la impresión del documento de libre deuda. RESERVAS ADJUDICADAS flag 1º,  RESERVAS EN ESPERA  flag 2º, PRESTAMOS VENCIDOS  flag 3º, PRESTAMOS EN CURSO flag 4º , SANSIONADO flag 5º',NULL,'text','circulacion','Libre deuda','Variable que limita la impresión del documento de libre deuda. RESERVAS ADJUDICADAS flag 1º,  RESERVAS EN ESPERA  flag 2º, PRESTAMOS VENCIDOS  flag 3º, PRESTAMOS EN CURSO flag 4º , SANSIONADO flag 5º',0),(142,'enviar_mail_cambio_disponibilidad_espera','0','Habilita o deshabilita el envio de mail cuando una reserva en espera sufre un cambio de disponibilidad y avisa al usuario que tiene dicha reserva',NULL,'bool','sistema','Mail de cambio de disponibilidad','Habilita o deshabilita el envio de mail cuando una reserva en espera sufre un cambio de disponibilidad y avisa al usuario que tiene dicha reserva',0),(141,'enviar_mail_cambio_disponibilidad_cancelacion','0','Habilita o deshabilita el mail  de cancelación por cambio en la disponibilidad',NULL,'bool','sistema','Mail de cambio de disponibilidad por cancelacion','Habilita o deshabilita el mail  de cancelación por cambio en la disponibilidad',0),(140,'ldapenabled','0','Indica si se usa ldap para hacer autenticacion de usuarios',NULL,'bool','sistema','LDAP habilitado','Indica si se usa ldap para hacer autenticacion de usuarios',0),(30,'UploadPictureFromOPAC','1','Permite o no que se pueda subir la foto de un usuario desde el OPAC',NULL,'bool','sistema','Imagen de usuario OPAC','Permite o no que se pueda subir la foto de un usuario desde el OPAC',1),(31,'mailFrom','','Remitente que llega cuando MERAN manda un Mail',NULL,'text','mail','Remitente mail','Remitente que llega cuando MERAN manda un Mail',0),(34,'intranetGroupReserve','1','Indica que  si al realizar un préstamo desde la intranet y no se encuentra ningun ejemplar libre, se realiza o no una reserva sobre el grupo desde la intranet.',NULL,'bool','circulacion','Reservas del grupo intranet','Indica que  si al realizar un préstamo desde la intranet y no se encuentra ningun ejemplar libre, se realiza o no una reserva sobre el grupo desde la intranet.',0),(35,'keeppasswordalive','0','Indica la cantidad de días de vigencia que tiene una contraseña para aquellas cuentas cuya contraseña vence. Si el valor es 0 (cero) entonces la contraseña solo debe ser cambiada la primera vez',NULL,'bool','sistema','Vigencia de contraseña','Indica la cantidad de días de vigencia que tiene una contraseña para aquellas cuentas cuya contraseña vence. Si el valor es 0 (cero) entonces la contraseña solo debe ser cambiada la primera vez',0),(37,'defaultNivelBibliografico','m','Nivel bibliográfico que siempre queda seleccionado por defecto en todos los lados donde se lo use','nivel_bibliografico|description','referencia','catalogo','Nivel bibliográfico','Nivel bibliográfico que siempre queda seleccionado por defecto en todos los lados donde se lo use',0),(41,'EnabledMailSystem','0','Indica si MERAN debe o no enviar mails',NULL,'bool','sistema','Envío de mail','Indica si el sistema debe o no enviar mails',0),(42,'reserveFrom','','Dirección desde la que llegan los mails que se refieren a las reservas',NULL,'text','mail','Dirección mail reservas','Dirección desde la que llegan los mails que se refieren a las reservas',0),(43,'reserveSubject','Importante: Reservas en BRANCH','Asunto del mail de reservas. BRANCH se reemplazará por el nombre de la biblioteca.',NULL,'text','circulacion','Asunto mail reservas','Asunto del mail de reservas. BRANCH se reemplazará por el nombre de la biblioteca.',0),(44,'reserveMessage','Estimado/a SURNAME FIRSTNAME, Tiene un ejemplar disponible para retirar.Título: TITLEAutor: AUTHORLo puede retirar desde el a1 a las a2 hasta el a4 a las a3.','El mensaje que se envía a un usuario que tiene una reserva para retirar. Las variables que se reemplazan por ahora son: BRANCH,FIRSTNAME,SURNAME,UNITITLE,TITLE,AUTHOR,a1,a2,a3,a4 fechas y horas, EDICI',NULL,'texta','circulacion','Mensaje mail reservas','El mensaje que se envía a un usuario que tiene una reserva para retirar. Las variables que se reemplazan por ahora son: BRANCH,FIRSTNAME,SURNAME,UNITITLE,TITLE,AUTHOR,a1,a2,a3,a4 fechas y horas, EDICI',0),(45,'reserveItem','2','Número de días que tiene el usuario para retirar el libro si la reserva se efectúa sobre un ítem',NULL,'text','circulacion','Días para retirar','Número de días que tiene el usuario para retirar el libro si la reserva se efectúa sobre un ítem',0),(46,'reserveGroup','3','Número de días que tiene el usuario para retirar el libro si la reserva se efectúa sobre un grupo. Dicho lapso comienza a contarse a partir de que la reserva se asocia a un ítem.',NULL,'text','circulacion','Días para retirar grupo','Número de días que tiene el usuario para retirar el libro si la reserva se efectúa sobre un grupo. Dicho lapso comienza a contarse a partir de que la reserva se asocia a un ítem.',0),(47,'open','08:00','Horario de Apertura de la Biblioteca  (DEBE SER HH:MM !!!!)',NULL,'text','sistema','Horario apertura','Horario de Apertura de la Biblioteca  (DEBE SER HH:MM !!!!)',0),(48,'close','19:00','Horario de Cierre de la Biblioteca. (DEBE SER HH:MM !!!!)',NULL,'text','sistema','Horario cierre','Horario de Cierre de la Biblioteca. (DEBE SER HH:MM !!!!)',0),(276,'external_search','1','Habilita/Deshabilita la búsqueda en servidores externos Meran. También permite que sistemas externos busquen sobre este MERAN',NULL,'bool','catalogo','Búsqueda externa','Habilita/Deshabilita la búsqueda en servidores externos Meran. También permite que sistemas externos busquen sobre este MERAN',0),(277,'open_sabado','09:00','Horario de Apertura de la Biblioteca los dias sabado (DEBE SER HH:MM !!!!)',NULL,'text',NULL,'','Horario de Apertura de la Biblioteca los dias sabado (DEBE SER HH:MM !!!!)',0),(55,'barcodeFormat','UI,-,tipo_ejemplar,-','Formato del número de inventario para la generación automática. Es el formato antes del numero, y se pueden usar los siguientes comodines. UI se reemplazará por el nombre de la biblioteca, tipo_ejemplar por el tipo de ejemplar',NULL,'text','catalogo','Números de inventario','Formato del número de inventario para la generación automática. Es el formato antes del numero, y se pueden usar los siguientes comodines. UI se reemplazará por el nombre de la biblioteca, tipo_ejemplar por el tipo de ejemplar',0),(56,'defaultUI','MERA','Nombre de la unidad de información/biblioteca local','ui|nombre','referencia','catalogo','Nombre biblioteca','Nombre de la unidad de información/biblioteca local',0),(60,'logSearchOPAC','1','Indican si se loguean las búsquedas en el OPAC',NULL,'bool','sistema','Búsquedas OPAC','Indican si se loguean las búsquedas en el OPAC',0),(61,'logSearchINTRA','0','Indican si se loguean las búsquedas en el INTRA',NULL,'bool','sistema','Búsquedas INTRA','Indican si se loguean las búsquedas en el INTRA',0),(63,'reminderMessage','Sr./Sra. FIRSTNAME SURNAME : Se le recuerda que el día VENCIMIENTO debe regresar el ejemplar que posee del libro \"TITLE:UNITITLE\" - De: \"AUTHOR\" (EDICION) a la BRANCH para no ser sancionado. Muchas gracias. Para desactivar estas notificaciones por favor ingrese a LINK.','Mensaje del mail de recordatorio de préstamo a vencer. NO modificar las palabras en mayuscula',NULL,'texta','circulacion','Mensaje mail recordatorio','Mensaje del mail de recordatorio de préstamo a vencer. NO modificar las palabras en mayuscula',0),(64,'reminderSubject','Recordatorio de vencimiento de préstamos','Subject del mail de recodatorio de préstamo a vencer',NULL,'text','circulacion','Asunto mail recordatorio','Subject del mail de recodatorio de préstamo a vencer',0),(65,'beginESissue','60','Cantidad de minutos antes del cierre de la biblioteca que se puede realizar un préstamo ESPECIAL.',NULL,'text','circulacion','Comienzo del prestamo especial','Cantidad de minutos antes del cierre de la biblioteca que se puede realizar un préstamo ESPECIAL.',0),(66,'endESissue','35','Cantidad de minutos luego de la apertura de la biblioteca  en que se puede devolver un préstamo ESPECIAL.',NULL,'text','circulacion','Fin del prestamo especial','Cantidad de minutos luego de la apertura de la biblioteca  en que se puede devolver un préstamo ESPECIAL.',0),(67,'usercourse','0','habilita o no que el curso de usuario sea necesario para utilizar el opac.',NULL,'bool','sistema','Curso OPAC','habilita o no que el curso de usuario sea necesario para utilizar el opac. ',0),(242,'twitter_consumer_secret','','Consumer secret',NULL,'text','sistema','Twitter consumer secret','Consumer secret',0),(86,'404_error_message','404 NOT FOUND','Mensaje a mostrar cuando se intenta acceder a una página inexistente',NULL,'text','sistema','Mensaje de no encontrado','Mensaje a mostrar cuando se intenta acceder a una página inexistente',0),(87,'500_error_message','500 Error Interno','Mensaje que se muestra si se produce un fallo interno de sistema',NULL,'text','sistema','Mensaje de error','Mensaje que se muestra si se produce un fallo interno de sistema',0),(94,'CirculationEnabled','1','Habilita o dehabilita la circulación en la biblioteca desde el opac',NULL,'bool','circulacion','Circulación OPAC','Habilita o dehabilita la circulación en la biblioteca desde el opac',0),(97,'auto-nro_socio_from_dni','1','Preferencia que configura el auto-generar de nro de socio. Si es NO, es el autogenerar *serial*, sino sera el documento.',NULL,'bool','sistema','Auto número de socio','Preferencia que configura el auto-generar de nro de socio. Si es 0, es el autogenerar *serial*, sino sera el documento.',0),(98,'autoActivarPersona','0','Activa por defecto un alta de una persona',NULL,'bool','sistema','Auto activar persona','Activa por defecto un alta de una persona',0),(99,'circularDesdeDetalleDelRegistro','1','se permite (=1) circular desde el detalle del registro',NULL,'bool','circulacion','Circular desde detalle registro','se permite (=1) circular desde el detalle del registro',0),(100,'circularDesdeDetalleUsuario','1','se permite (=1) circular desde el detalle del usuario',NULL,'bool','circulacion','Circular desde detalle usuario','se permite (=1) circular desde el detalle del usuario',0),(101,'defaultCategoriaSocio','Estudiante','Categoria de Socio utilizada con mas frecuencia','tipo_socio|description','referencia','sistema','Categoría socio','Categoria de Socio utilizada con mas frecuencia',0),(103,'defaultissuetype','DO  ','Es el tipo de préstamo utilizado con mas frecuencia en la biblioteca','tipo_prestamo|descripcion','referencia','circulacion','Tipo de préstamo','Es el tipo de préstamo utilizado con mas frecuencia en la biblioteca',0),(104,'defaultTipoDoc','DNI','Tipo de Documento de Usuario utilizado con mas frecuencia','tipo_documento_usr|descripcion','referencia','catalogo','Tipo de documento socio','Tipo de Documento de Usuario utilizado con mas frecuencia',0),(105,'defaultTipoNivel3','LIB','Tipo de Documento utilizado con mas frecuencia','tipo_ejemplar|nombre','referencia','catalogo','Tipo de documento','Tipo de Documento utilizado con mas frecuencia',0),(106,'habilitar_https','0','OPAC sobre HTTPS',NULL,'bool','sistema','Opac sobre https','OPAC sobre HTTPS',0),(108,'paginas','10','Tamaño paginador','','text','sistema','Tamaño paginador','Tamaño paginador',0),(109,'permite_cambio_password_desde_opac','0','Indica si de permite o no el cambio de password desde el OPAC',NULL,'bool','sistema','Cambio de contraseña OPAC','Indica si de permite o no el cambio de password desde el OPAC',0),(111,'showMenuItem_circ_devolucion_renovacion','0','Preferencia que configura si el menu item dado se muestra o no en el menu (1 sí  0 no).',NULL,'bool','circulacion','Menu item','Preferencia que configura si el menu item dado se muestra o no en el menu (1 sí  0 no).',0),(112,'showMenuItem_circ_prestamos','0','Preferencia que configura si el menu item dado se muestra o no en el menu (1 sí  0 no).',NULL,'bool','interna','Menú loco','Preferencia que configura si el menu item dado se muestra o no en el menu (1 sí  0 no).',0),(114,'titulo_nombre_ui','Meran - LINTI - Facultad de Informática - UNLP','Entorno de trabajo de la Biblioteca',NULL,'text','sistema','Titulo biblioteca','Entorno de trabajo de la Biblioteca',0),(115,'z3950_ cant_resultados','25','Cantidad de resultados por servidor en una busqueda z3950 MAX para devoler todos',NULL,'text','sistema','Resultados z3950','Cantidad de resultados por servidor en una busqueda z3950 MAX para devoler todos',0),(116,'longitud_barcode','5','Cantidad de numeros de digitos que conforman la parte numerica del numero de inventario',NULL,'text','catalogo','Longitud de Nro de inventario','Cantidad de numeros de digitos que conforman la parte numerica del numero de inventario',0),(117,'limite_resultados_autocompletables','101','limite de resultados a mostrar en los campos autocompletables',NULL,'text','sistema','Cantidad items autocomplete','limite de resultados a mostrar en los campos autocompletables',0),(119,'detalle_resumido','0','Muestra el detalle desde el OPAC en forma resumida',NULL,'bool','catalogo','Detalle resumido','Muestra el detalle desde el OPAC en forma resumida',0),(120,'google_map','','Google Map',NULL,'texta','sistema','Google Map','Google Map',0),(259,'tema_opac_default','default','El tema por defecto para OPAC','','text','temas_opac','Tema OPAC','El tema por defecto para OPAC',0),(244,'twitter_token_secret','','Token secret',NULL,'text','sistema','Twitter token secret','Token secret',0),(243,'twitter_token','','Token',NULL,'text','sistema','Twitter token','Token',0),(241,'twitter_consumer_key','','Consumer key',NULL,'text','sistema','Twitter consumer key','Consumer key',0),(132,'indexado','1','=1 indica que el indice se encuentra actualizado, 0 caso contrario (NO TOCAR)',NULL,'bool','internal','null','=1 indica que el indice se encuentra actualizado, 0 caso contrario (NO TOCAR)',1),(133,'operacion_fuera_horario','1','Se permiten las operaciones de la INTRANET fuera de horario?',NULL,'bool','circulacion','Operación fuera de horario','Se permiten las operaciones de la INTRANET fuera de horario?',0),(134,'prestar_mismo_grupo_distintos_tipos_prestamo','0','Se permite (1) o no (0) prestar mas de un ejemplar del mismo grupo con distinto tipo de préstamo',NULL,'bool','circulacion','Multiples préstamos por grupo','Se permite (1) o no (0) prestar mas de un ejemplar del mismo grupo con distinto tipo de préstamo',0),(136,'e_documents','1','Variable que indica si está habilitado el manejo de documentos electróos',NULL,'bool','catalogo','Documentos electrónicos','Variable que indica si está habilitado el manejo de documentos electróos',0),(143,'subject_mail_cambio_disponibilidad_cancelacion','Aviso de cambio de disponibilidad','Subject del mail de cancelación por cambio en la disponibilidad',NULL,'text','circulacion','Asunto mail cancelación disponibilidad','Subject del mail de cancelación por cambio en la disponibilidad',0),(144,'mensaje_mail_cambio_disponibilidad_cancelacion','Estimado/a  FIRSTNAME SURNAME :Lo sentimos, debido a cambios en la disponibilidad de los ejemplares de la biblioteca, su reserva del ejemplar de:Título: TITLE: UNITITLEAutor: AUTHOREdición: EDICIONdebió ser cancelada por no contar con ejemplares disponibles.Disculpe las molestias.BRANCH','Mensaje del mail de cancelación por cambio en la disponibilidad',NULL,'texta','circulacion','Mensaje mail cancelación disponibilidad','Mensaje del mail de cancelación por cambio en la disponibilidad',0),(145,'subject_mail_cambio_disponibilidad_espera','Aviso de cambio de disponibilidad','Subject del mail de paso de una reserva a espera por cambio en la disponibilidad',NULL,'text','circulacion','Asunto mail espera disponibilidad','Subject del mail de paso de una reserva a espera por cambio en la disponibilidad',0),(146,'mensaje_mail_cambio_disponibilidad_espera','Estimado/a  FIRSTNAME SURNAME :Lo sentimos, debido a cambios en la disponibilidad de los ejemplares de la biblioteca, su reserva del ejemplar de:Título: TITLE: UNITITLEAutor: AUTHOREdición: EDICIONpaso a espera hasta que haya algún ejemplar disponible.Disculpe las molestias.BRANCH','Mensaje del mail de paso de una reserva a espera por cambio en la disponibilidad',NULL,'texta','circulacion','Mensaje mail espera disponibilidad','Mensaje del mail de paso de una reserva a espera por cambio en la disponibilidad',0),(248,'renglones','10','Cantidad de resultados a mostrar en los resultados de búsquedas',NULL,NULL,NULL,'Cantidad de resultados','Cantidad de resultados a mostrar en los resultados de búsquedas',0),(249,'requisito_necesario','0','Indica si el socio debe cumplir requisito para operar',NULL,'bool','sistema','Cumple requisito','Indica si el socio debe cumplir requisito para operar',0),(148,'ldap_server','','Indica el servidor LDAP','','','auth','','Indica el servidor LDAP',1),(264,'BookLabelPage','1','Impresión en A4',NULL,'bool','catalogo','Impresión A4','Impresión en A4',0),(267,'offset_operacion_fuera_horario','10','Cantidad de minutos para poder operar internamente, luego del cierre',NULL,'text','circulacion','Minutos de operación extra','Cantidad de minutos para poder operar internamente, luego del cierre',0),(265,'detalle_INTRA_extendido','0','Muestra el detalle de la INTRA extendido','','bool','catalogo','Detalle INTRA','Muestra el detalle de la INTRA extendido ',0),(266,'detalle_OPAC_extendido','0','Muestra el detalle del OPAC extendido','','bool','catalogo','Detalle OPAC','Muestra el detalle del OPAC extendido ',0),(268,'renglones_autocomplete','20','Cantidad de items a mostrar en los autocomplete',NULL,'text','sistema','Items autocomplete','Cantidad de items a mostrar en los autocomplete',0),(269,'incluir_fax_etiquetas','1','Indica si el Fax de la Biblioteca se incluye como dato en la etiqueta',NULL,'bool','catalogo','Incluir fax biblioteca','Indica si el Fax de la Biblioteca se incluye como dato en la etiqueta',0),(270,'primer_dia_semana','1','El primer día hábil de la semana para la biblioteca',NULL,'text','circulacion','Primer día hábil','El primer día hábil de la semana para la biblioteca',0),(239,'re_captcha_private_key','','Private Key',NULL,'text','sistema','Recaptcha private key','Private Key',0),(240,'limite_novedades','3','La cantidad de novedades a mostrar en el OPAC',NULL,'text','sistema','Limite novedades OPAC','La cantidad de novedades a mostrar en el OPAC',0),(245,'prefijo_twitter','[INFO]','prefijo para post de twitter',NULL,'text','sistema','Prefijo twitter','prefijo para post de twitter',0),(246,'twitter_enabled','0','Habilita la publicacion en twitter',NULL,'bool','sistema','Twitter habilitado','Habilita la publicacion en twitter',0),(247,'google_shortener_api_key','AIzaSyDJCr_F49vYtCXI_Ypa4mf8T_iV66mRybA','Google shortener api key',NULL,'text','sistema','Google shortener api key','Google shortener api key',0),(250,'twitter_follow_button','','',NULL,'texta','sistema','Twitter follow button','',0),(271,'ultimo_dia_semana','5','El último día hábil de la semana para la biblioteca',NULL,'text','circulacion','Ultimo día semana','El último día hábil de la semana para la biblioteca',0),(272,'reminderDays','3','Cantidad de dias en que comienza el envio de recordatorio de vencimiento al socio. Ejemplo: Si es 3, se le enviara un mail cuando falten 3 dias, 2 dias y 1 dia.',NULL,'text','circulacion','Dias recordatorio','Cantidad de dias en que comienza el envio de recordatorio de vencimiento al socio. Ejemplo: Si es 3, se le enviara un mail cuando falten 3 dias, 2 dias y 1 dia.',0),(273,'remindUser','1','Indica si se habilita GLOBALMENTE recordarle al usuario el vencimiento del prestamo por el medio que tenga registrado',NULL,'bool','circulacion','Recordatorio vencimiento préstamo','Indica si se habilita GLOBALMENTE recordarle al usuario el vencimiento del prestamo por el medio que tenga registrado',0),(274,'mostrar_ui_opac','0','Habilita/Deshabilita que se muestre la UI poseedora y la UI origen en el detalle de ejemplares del OPAC',NULL,'bool','catalogo','Mostrar UI OPAC','Habilita/Deshabilita que se muestre la UI poseedora y la UI origen en el detalle de ejemplares del OPAC',0),(275,'se_permite_repetir_signatura','0','Permite especificar si la signatura puede repetirse solamente en le registro comprendido (Nivel1) o en todo el catalogo',NULL,'bool','catalogo','Repetir signatura','Permite especificar si la signatura puede repetirse solamente en le registro comprendido (Nivel1) o en todo el catalogo',0),(280,'cancelar_reservas_intranet','0','Habilita/Deshabilita la posibilidad de cancelar reservas de usuario desde intranet',NULL,'bool','circulacion','Cancelar reservas desde intranet','Habilita/Deshabilita la posibilidad de cancelar reservas de usuario desde intranet',0),(281,'libreDeudaMensaje','Certificamos que SOCIO, de la UI_NAME, con número de documento DOC, no adeuda material bibliográfico en esta Biblioteca. Se extiende el presente certificado para ser presentado ante quién corresponda, con una validez de 10 días corridos a partir de su fecha de emisión.','Cuerpo del certificado de libre deuda. No cambiar las palabras en mayusculas. SOCIO es nombre del socio, UI_NAME nombre de la biblioteca',NULL,'texta','circulacion','Mensaje libre deuda','Cuerpo del certificado de libre deuda. No cambiar las palabras en mayusculas. SOCIO es nombre del socio, UI_NAME nombre de la biblioteca',0),(282,'defaultEstado','STATE002','Estado del ejemplar utilizado con mas frecuencia','estado|nombre','referencia','catalogo','Estado por defecto','Estado del ejemplar utilizado con mas frecuencia',0),(283,'defaultDisponibilidad','CIRC0000','Disponibilidad utilizada con mas frecuencia','disponibilidad|nombre','referencia','catalogo','Disponibilidad','Disponibilidad utilizada con mas frecuencia',0),(284,'defaultSoporte','1','Soporte utilizado con mas frecuencia','soporte|description','referencia','catalogo','Soporte','Soporte utilizado con mas frecuencia',0),(285,'defaultCiudad','1','Ciudad utilizada con mas frecuencia','ciudad|NOMBRE','referencia','catalogo','Cuidad','Ciudad utilizada con mas frecuencia',0),(286,'defaultPais','AR','Pais utilizado con mas frecuencia','pais|nombre_largo','referencia','catalogo','País','Pais utilizado con mas frecuencia',0),(287,'defaultIdioma','es','Idioma utilizado con mas frecuencia','idioma|description','referencia','catalogo','Idioma','Idioma utilizado con mas frecuencia',0),(288,'serverName','','URL del servidor',NULL,'text','sistema','URL servidor','URL del servidor',0),(289,'mailMessageForgotPass','Estimado/a <b>SOCIO</b>, socio de NOMBRE_UI, recientemente Ud. ha solicitado reestablecer su clave.<br> Para hacerlo, haga click en el siguiente enlace y siga los pasos que el sistema le va a indicar.<br> <p style=\"\"><br class=\"aloha-end-br\" style=\"\"></p><p>Si Ud. NO ha solicitado un reseteo de su clave, simplemente ignore este mail. <br style=\"\">Atte. NOMBRE_UI.</p><p><br class=\"aloha-end-br\"></p><p>Si no puede abrir el enlace, copie y pegue la siguente URL en su navegador:&nbsp;<br>LINK&nbsp;<br class=\"aloha-end-br\"></p>','Cuerpo del mail de reseteo de password. No cambiar las paralbar en mayusculas',NULL,'texta','sistema','Mensaje olvido contraseña','Cuerpo del mail de reseteo de password. No cambiar las paralbar en mayusculas',0),(290,'mailMessageForgotPassUnactive','Estimado/a <b>SOCIO</b>, socio de NOMBRE_UI, recientemente Ud. ha solicitado reestablecer su clave.<br> <br>Para hacerlo, debe dirigirse a la biblioteca, ya que UD. no cumple las condiciones necesarias de regularidad. <br><br>Puede dirigirse a NOMBRE_UI. <br> Si UD no ha solicitado un reseteo de su clave, simplemente ignore este mail.  <br>Atte. NOMBRE_UI.','Cuerpo del mail de reseteo de password. No cambiar las paralbar en mayusculas',NULL,'texta','sistema','Mensaje olvico contraseña inactiva','Cuerpo del mail de reseteo de password. No cambiar las paralbar en mayusculas',0),(291,'auto_generar_comprobante_prestamo','1','Si esta en true imprime directamente el comprobante al efectuarse el prestamo, sino no',NULL,'bool','circulacion','Imprimir certificado','Si esta en true imprime directamente el comprobante al efectuarse el prestamo, sino no',0),(294,'twitter_username_to_search','','Username para refrescar el timeline',NULL,'text','sistema','Twitter username','Username para refrescar el timeline',0),(295,'vencidoMessage','Sr./Sra. FIRSTNAME SURNAME : El dia VENCIMIENTO se le ha vencido e ejemplar que posee del libro \"TITLE:UNITITLE\" - De: \"AUTHOR\" (EDICION).','Mensaje del mail de préstamos vencidos. NO modificar las palabras en mayuscula',NULL,'texta','circulacion','Mensaje préstamo vencido','Mensaje del mail de préstamos vencidos. NO modificar las palabras en mayuscula',0),(296,'vencidoSubject','URGENTE','Subject del mail de préstamos vencidos',NULL,'text','circulacion','Asunto mail préstamo vencido','Subject del mail de préstamos vencidos',0),(297,'enableMailPrestVencidos','0','Flag para habilitar el CRON de mails de prestamos vencidos',NULL,NULL,'CRON','Prestamo vencido','Flag para habilitar el CRON de mails de prestamos vencidos',1),(298,'library_thing_key','0429c5b67a8c0eb1c2e3d6f6dd64cea6','Key de http://www.librarything.com/ para obtener portadas de los registros.',NULL,'text','sistema','Library thing key','Key de http://www.librarything.com/ para obtener portadas de los registros.',0),(299,'libre_deuda_fill_a4','0','Formato de impresion de libre de deuda. Si su valor es SI imprime en formato A4.',NULL,'bool','circulacion','Libre deuda A4','Formato de impresion de libre de deuda. Si su valor es 1 imprime en formato A4.',0),(300,'title_search_bar','Buscar','El titulo de la barra de busqueda de OPAC',NULL,'text','catalogo','Titulo barra búsquedas','El titulo de la barra de busqueda de OPAC',0),(301,'re_captcha_public_key','','',NULL,'text','sistema','Recaptcha public key',NULL,0),(327,'mostrarDetalleDisponibilidad','0','Muestra la cantidad de disponibles, reservados, etc., en el detalle del grupo en OPAC','','bool','catalogo','Mostrar disponibilidad','Muestra la cantidad de disponibles, reservados, etc., en el detalle del grupo en OPAC',0),(326,'mostrarSignaturaEnDetalleOPAC','0','Muestra \'Puede solicitar más fácilmente...\' en el detalle del grupo en OPAC',NULL,'bool','catalogo','Mostrar signatura','Muestra \'Puede solicitar más fácilmente...\' en el detalle del grupo en OPAC',0),(323,'nombre_indice_sphinx','test1','Indice de Sphinx a utilizar',NULL,'text','sistema','Nombre indice sphinx','Indice de Sphinx a utilizar',0),(317,'minPassSymbol','0','Cantidad de caracteres simbolicos que debe tener la password',NULL,'text','sistema','Símbolos minimos','Cantidad de caracteres simbolicos que debe tener la password',0),(318,'minPassAlphaNumeric','4','Cantidad de caracteres alfanumericos que debe tener la password',NULL,'text','sistema','Alfanumericos minimos','Cantidad de caracteres alfanumericos que debe tener la password',0),(319,'minPassAlpha','4','Cantidad de caracteres alpha minimo que debe tener la password',NULL,'text','sistema','Alfabeticos minimos','Cantidad de caracteres alpha minimo que debe tener la password',0),(320,'minPassNumeric','0','Cantidad de caracteres numericos minimo que debe tener la password',NULL,'text','sistema','Numéricos minimos','Cantidad de caracteres numericos minimo que debe tener la password',0),(321,'minPassLower','0','Cantidad de caracteres con minuscula minimo que debe tener la password',NULL,'text','sistema','Minusculas minimas','Cantidad de caracteres con minuscula minimo que debe tener la password',0),(322,'minPassUpper','0','Cantidad de caracteres con mayuscula minimo que debe tener la password',NULL,'text','sistema','Mayusculas minimas','Cantidad de caracteres con mayuscula minimo que debe tener la password',0),(316,'minPassLength','4','Cantidad de caracteres minimo que debe tener la password',NULL,'text','sistema','Caracteres mínimos','Cantidad de caracteres minimo que debe tener la password',0),(328,'problem_catalog_opac','1','Habilita que un socio avise a la Biblioteca de un problema con el detalle de un registro',NULL,'bool','catalogo','Informe de errores de registro en OPAC',NULL,0),(2967,'registradoMeran','0','Indica si se registro la instalacion de MERAN',NULL,'bool','interna',NULL,'Indica si se registro la instalacion de MERAN',0);
/*!40000 ALTER TABLE `pref_preferencia_sistema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_tabla_referencia`
--

DROP TABLE IF EXISTS `pref_tabla_referencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_tabla_referencia` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nombre_tabla` varchar(40) NOT NULL,
  `alias_tabla` varchar(20) NOT NULL DEFAULT '0',
  `campo_busqueda` varchar(255) NOT NULL DEFAULT 'jmmj',
  `client_title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `campo_busqueda` (`campo_busqueda`)
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_tabla_referencia`
--

LOCK TABLES `pref_tabla_referencia` WRITE;
/*!40000 ALTER TABLE `pref_tabla_referencia` DISABLE KEYS */;
INSERT INTO `pref_tabla_referencia` VALUES (3,'cat_autor','autor','completo','Autor'),(5,'pref_unidad_informacion','ui','nombre','Unidad de Informacion'),(6,'ref_idioma','idioma','description','Idioma'),(7,'ref_pais','pais','nombre_largo','Pais'),(8,'ref_disponibilidad','disponibilidad','nombre','Disponibilidad'),(9,'circ_ref_tipo_prestamo','tipo_prestamo','descripcion','Tipos de Prestamo'),(10,'ref_soporte','soporte','description','Soporte'),(11,'ref_nivel_bibliografico','nivel_bibliografico','description','Nivel bibliografico'),(12,'cat_tema','tema','nombre','Tema'),(13,'usr_ref_categoria_socio','tipo_socio','description','Categorias de Usuario'),(14,'usr_ref_tipo_documento','tipo_documento_usr','nombre','Tipo de documentos de Socio'),(15,'ref_estado','estado','nombre','Estado del ejemplar'),(16,'ref_localidad','ciudad','NOMBRE','Localidad'),(27,'usr_estado','usr_estado','nombre','Estado de Regularidad'),(22,'cat_editorial','editorial','editorial','Editorial'),(24,'ref_colaborador','colaborador','descripcion','Función de colaborador'),(25,'ref_signatura','signatura','signatura','Signatura Topográfica'),(26,'ref_acm','cdu','codigo','Códigos CDU');
/*!40000 ALTER TABLE `pref_tabla_referencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_tabla_referencia_conf`
--

DROP TABLE IF EXISTS `pref_tabla_referencia_conf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_tabla_referencia_conf` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tabla` varchar(255) NOT NULL,
  `campo` varchar(255) NOT NULL,
  `campo_alias` varchar(255) NOT NULL,
  `visible` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_tabla_referencia_conf`
--

LOCK TABLES `pref_tabla_referencia_conf` WRITE;
/*!40000 ALTER TABLE `pref_tabla_referencia_conf` DISABLE KEYS */;
INSERT INTO `pref_tabla_referencia_conf` VALUES (1,'cat_autor','id','id',0),(2,'cat_autor','completo','Apellido y Nombre',1),(3,'cat_autor','nombre','Nombre',1),(4,'ref_estado','nombre','Nombre',1),(5,'ref_idioma','description','Nombre',1),(6,'ref_localidad','nombre','Nombre',1),(7,'ref_localidad','NOMBRE_ABREVIADO','Nombre abreviado',1),(8,'ref_nivel_bibliografico','description','Nombre',1),(9,'ref_pais','nombre','Nombre abreviado',1),(10,'ref_pais','nombre_largo','Nombre',1),(11,'ref_provincia','nombre','Nombre',1),(12,'ref_soporte','description','Nombre',1),(13,'cat_ref_tipo_nivel3','nombre','Nombre',1),(14,'pref_unidad_informacion','nombre','Nomrbe',1),(15,'ref_disponibilidad','nombre','Nombre',1),(16,'circ_ref_tipo_prestamo','description','Nombre',1),(17,'cat_tema','nombre','Nombre',1),(18,'usr_ref_categoria_socio','description','Nombre',1),(19,'usr_ref_tipo_documento','nombre','Nombre',0),(20,'cat_registro_marc_n2','id','Registro N2',1),(21,'ref_colaborador','descripcion','descripcion',1),(22,'ref_colaborador','codigo','codigo',1),(23,'ref_colaborador','id','id',1),(24,'cat_editorial','id','id',1),(25,'cat_editorial','editorial','editorial',1),(26,'ref_acm','codigo','Código CDU',1),(27,'ref_signatura','signatura','Signatura topográfica',1),(28,'ref_acm','id','id',0),(29,'ref_signatura','id','id',0);
/*!40000 ALTER TABLE `pref_tabla_referencia_conf` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_tabla_referencia_info`
--

DROP TABLE IF EXISTS `pref_tabla_referencia_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_tabla_referencia_info` (
  `orden` varchar(20) DEFAULT NULL,
  `referencia` varchar(30) NOT NULL DEFAULT '',
  `similares` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`referencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_tabla_referencia_info`
--

LOCK TABLES `pref_tabla_referencia_info` WRITE;
/*!40000 ALTER TABLE `pref_tabla_referencia_info` DISABLE KEYS */;
INSERT INTO `pref_tabla_referencia_info` VALUES ('apellido','autores','apellido'),('nombre','temas','nombre');
/*!40000 ALTER TABLE `pref_tabla_referencia_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_tabla_referencia_rel_catalogo`
--

DROP TABLE IF EXISTS `pref_tabla_referencia_rel_catalogo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_tabla_referencia_rel_catalogo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alias_tabla` varchar(32) DEFAULT NULL,
  `tabla_referente` varchar(32) DEFAULT NULL,
  `campo_referente` varchar(32) DEFAULT NULL,
  `sub_campo_referente` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_tabla_referencia_rel_catalogo`
--

LOCK TABLES `pref_tabla_referencia_rel_catalogo` WRITE;
/*!40000 ALTER TABLE `pref_tabla_referencia_rel_catalogo` DISABLE KEYS */;
INSERT INTO `pref_tabla_referencia_rel_catalogo` VALUES (2,'ui','usr_socio','id_ui',NULL),(10,'tipo_prestamo','circ_prestamo','tipo_prestamo',NULL),(13,'tipo_socio','usr_socio','id_categoria',NULL),(14,'tipo_documento_usr','usr_persona','tipo_documento',NULL),(16,'ciudad','usr_persona','ciudad',NULL),(17,'perfiles_opac','cat_visualizacion_opac','id_perfil',NULL),(18,'usr_estado','usr_regularidad','usr_estado_id',NULL),(19,'usr_estado','usr_regularidad','usr_estado_id',NULL);
/*!40000 ALTER TABLE `pref_tabla_referencia_rel_catalogo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pref_unidad_informacion`
--

DROP TABLE IF EXISTS `pref_unidad_informacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pref_unidad_informacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_ui` varchar(4) DEFAULT NULL,
  `nombre` mediumtext NOT NULL,
  `direccion` mediumtext,
  `alt_direccion` mediumtext,
  `telefono` mediumtext,
  `fax` mediumtext,
  `url_servidor` varchar(255) DEFAULT NULL,
  `email` mediumtext,
  `titulo_formal` varchar(255) NOT NULL DEFAULT 'Universidad Nacional de La Plata',
  `ciudad` varchar(255) NOT NULL DEFAULT 'La Plata',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pref_unidad_informacion`
--

LOCK TABLES `pref_unidad_informacion` WRITE;
/*!40000 ALTER TABLE `pref_unidad_informacion` DISABLE KEYS */;
INSERT INTO `pref_unidad_informacion` VALUES (25,'MERA','Meran','Calle 50 y 120',NULL,'+54 221 422 3528',NULL,'http://meran.unlp.edu.ar','soportemeran@cespi.unlp.edu.ar','CeSPI - Universidad Nacional de La Plata','La Plata');
/*!40000 ALTER TABLE `pref_unidad_informacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_acm`
--

DROP TABLE IF EXISTS `ref_acm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_acm` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(45) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo_UNIQUE` (`codigo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_acm`
--

LOCK TABLES `ref_acm` WRITE;
/*!40000 ALTER TABLE `ref_acm` DISABLE KEYS */;
/*!40000 ALTER TABLE `ref_acm` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_adq_moneda`
--

DROP TABLE IF EXISTS `ref_adq_moneda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_adq_moneda` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_adq_moneda`
--

LOCK TABLES `ref_adq_moneda` WRITE;
/*!40000 ALTER TABLE `ref_adq_moneda` DISABLE KEYS */;
/*!40000 ALTER TABLE `ref_adq_moneda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_colaborador`
--

DROP TABLE IF EXISTS `ref_colaborador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_colaborador` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(10) DEFAULT NULL,
  `descripcion` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=216 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_colaborador`
--

LOCK TABLES `ref_colaborador` WRITE;
/*!40000 ALTER TABLE `ref_colaborador` DISABLE KEYS */;
INSERT INTO `ref_colaborador` VALUES (1,'acp','Art copyist'),(2,'act','Actor'),(3,'adp','Adapter'),(4,'aft','Author of afterword, colophon, etc.'),(5,'anl','Analyst'),(6,'anm','Animator'),(7,'ann','Annotator'),(8,'ant','Bibliographic antecedent'),(9,'app','Applicant'),(10,'aqt','Author in quotations or text abstracts'),(11,'arc','Architect'),(12,'ard','Artistic director'),(13,'arr','Arranger'),(14,'art','Artist'),(15,'asg','Assignee'),(16,'asn','Associated name'),(17,'att','Attributed name'),(18,'auc','Auctioneer'),(19,'aud','Author of dialog'),(20,'aui','Author of introduction'),(21,'aus','Author of screenplay'),(22,'aut','Author'),(23,'bdd','Binding designer'),(24,'bjd','Bookjacket designer'),(25,'bkd','Book designer'),(26,'bkp','Book producer'),(27,'bnd','Binder'),(28,'bpd','Bookplate designer'),(29,'bsl','Bookseller'),(30,'ccp','Conceptor'),(31,'chr','Choreographer'),(32,'clb','Collaborator'),(33,'cli','Client'),(34,'cll','Calligrapher'),(35,'clt','Collotyper'),(36,'cmm','Commentator'),(37,'cmp','Composer'),(38,'cmt','Compositor'),(39,'cng','Cinematographer'),(40,'cnd','Conductor'),(41,'cns','Censor'),(42,'coe','Contestant -appellee'),(43,'col','Collector'),(44,'com','Compiler'),(45,'cos','Contestant'),(46,'cot','Contestant -appellant'),(47,'cov','Cover designer'),(48,'cpc','Copyright claimant'),(49,'cpe','Complainant-appellee'),(50,'cph','Copyright holder'),(51,'cpl','Complainant'),(52,'cpt','Complainant-appellant'),(53,'cre','Creator'),(54,'crp','Correspondent'),(55,'crr','Corrector'),(56,'csl','Consultant'),(57,'csp','Consultant to a project'),(58,'cst','Costume designer'),(59,'ctb','Contributor'),(60,'cte','Contestee-appellee'),(61,'ctg','Cartographer'),(62,'ctr','Contractor'),(63,'cts','Contestee'),(64,'ctt','Contestee-appellant'),(65,'cur','Curator'),(66,'cwt','Commentator for written text'),(67,'dfd','Defendant'),(68,'dfe','Defendant-appellee'),(69,'dft','Defendant-appellant'),(70,'dgg','Degree grantor'),(71,'dis','Dissertant'),(72,'dln','Delineator'),(73,'dnc','Dancer'),(74,'dnr','Donor'),(75,'dpc','Depicted'),(76,'dpt','Depositor'),(77,'drm','Draftsman'),(78,'drt','Director'),(79,'dsr','Designer'),(80,'dst','Distributor'),(81,'dtc','Data contributor'),(82,'dte','Dedicatee'),(83,'dtm','Data manager'),(84,'dto','Dedicator'),(85,'dub','Dubious author'),(86,'edt','Editor'),(87,'egr','Engraver'),(88,'elg','Electrician'),(89,'elt','Electrotyper'),(90,'eng','Engineer'),(91,'etr','Etcher'),(92,'exp','Expert'),(93,'fac','Facsimilist'),(94,'fld','Field director'),(95,'flm','Film editor'),(96,'fmo','Former owner'),(97,'fpy','First party'),(98,'fnd','Funder'),(99,'frg','Forger'),(100,'gis','Geographic information specialist'),(101,'-grt','Graphic technician'),(102,'hnr','Honoree'),(103,'hst','Host'),(104,'ill','Illustrator'),(105,'ilu','Illuminator'),(106,'ins','Inscriber'),(107,'inv','Inventor'),(108,'itr','Instrumentalist'),(109,'ive','Interviewee'),(110,'ivr','Interviewer'),(111,'lbr','Laboratory '),(112,'lbt','Librettist'),(113,'ldr','Laboratory director'),(114,'led','Lead '),(115,'lee','Libelee-appellee'),(116,'lel','Libelee'),(117,'len','Lender'),(118,'let','Libelee-appellant'),(119,'lgd','Lighting designer'),(120,'lie','Libelant-appellee'),(121,'lil','Libelant'),(122,'lit','Libelant-appellant'),(123,'lsa','Landscape architect'),(124,'lse','Licensee'),(125,'lso','Licensor'),(126,'ltg','Lithographer'),(127,'lyr','Lyricist'),(128,'mcp','Music copyist'),(129,'mfr','Manufacturer'),(130,'mdc','Metadata contact'),(131,'mod','Moderator'),(132,'mon','Monitor'),(133,'mrk','Markup editor'),(134,'msd','Musical director'),(135,'mte','Metal-engraver'),(136,'mus','Musician'),(137,'nrt','Narrator'),(138,'opn','Opponent'),(139,'org','Originator'),(140,'orm','Organizer of meeting'),(141,'oth','Other'),(142,'own','Owner'),(143,'pat','Patron'),(144,'pbd','Publishing director'),(145,'pbl','Publisher'),(146,'pdr','Project director '),(147,'pfr','Proofreader'),(148,'pht','Photographer'),(149,'plt','Platemaker'),(150,'pma','Permitting agency'),(151,'pmn','Production manager'),(152,'pop','Printer of plates'),(153,'ppm','Papermaker'),(154,'ppt','Puppeteer'),(155,'prc','Process contact'),(156,'prd','Production personnel'),(157,'prf','Performer'),(158,'prg','Programmer'),(159,'prm','Printmaker'),(160,'pro','Producer'),(161,'prt','Printer'),(162,'pta','Patent applicant'),(163,'pte','Plaintiff -appellee'),(164,'ptf','Plaintiff'),(165,'pth','Patent holder'),(166,'ptt','Plaintiff-appellant'),(167,'rbr','Rubricator'),(168,'rce','Recording engineer'),(169,'rcp','Recipient'),(170,'red','Redactor'),(171,'ren','Renderer'),(172,'res','Researcher'),(173,'rev','Reviewer'),(174,'rps','Repository '),(175,'rpt','Reporter'),(176,'rpy','Responsible party'),(177,'rse','Respondent-appellee'),(178,'rsg','Restager'),(179,'rsp','Respondent'),(180,'rst','Respondent-appellant'),(181,'rth','Research team head'),(182,'rtm','Research team member'),(183,'sad','Scientific advisor'),(184,'sce','Scenarist'),(185,'scl','Sculptor'),(186,'scr','Scribe'),(187,'sds','Sound designer'),(188,'sec','Secretary'),(189,'sgn','Signer'),(190,'sht','Supporting host'),(191,'sng','Singer'),(192,'spk','Speaker'),(193,'spn','Sponsor'),(194,'spy','Second party'),(195,'srv','Surveyor'),(196,'std','Set designer'),(197,'stl','Storyteller'),(198,'stm','Stage manager '),(199,'stn','Standards body'),(200,'str','Stereotyper'),(201,'tcd','Technical director'),(202,'tch','Teacher'),(203,'ths','Thesis advisor'),(204,'trc','Transcriber'),(205,'trl','Translator'),(206,'tyd','Type designer'),(207,'tyg','Typographer'),(208,'vdg','Videographer'),(209,'voc','Vocalist'),(210,'wam','Writer of accompanying material'),(211,'wdc','Woodcutter'),(212,'wde','Wood -engraver'),(213,'wit','Witness'),(214,'_SIN_VALOR','_SIN_VALOR_'),(215,'_SIN_VALOR','_SIN_VALOR_');
/*!40000 ALTER TABLE `ref_colaborador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_disponibilidad`
--

DROP TABLE IF EXISTS `ref_disponibilidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_disponibilidad` (
  `nombre` varchar(255) DEFAULT NULL,
  `codigo` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_disponibilidad`
--

LOCK TABLES `ref_disponibilidad` WRITE;
/*!40000 ALTER TABLE `ref_disponibilidad` DISABLE KEYS */;
INSERT INTO `ref_disponibilidad` VALUES ('Domiciliario','CIRC0000'),('Sala de Lectura','CIRC0001');
/*!40000 ALTER TABLE `ref_disponibilidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_dpto_partido`
--

DROP TABLE IF EXISTS `ref_dpto_partido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_dpto_partido` (
  `id` varchar(11) NOT NULL DEFAULT '',
  `NOMBRE` varchar(60) DEFAULT NULL,
  `ref_provincia_id` varchar(11) DEFAULT NULL,
  `ESTADO` char(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ref_dpto_partido_ref_provincia1` (`ref_provincia_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_dpto_partido`
--

LOCK TABLES `ref_dpto_partido` WRITE;
/*!40000 ALTER TABLE `ref_dpto_partido` DISABLE KEYS */;
INSERT INTO `ref_dpto_partido` VALUES ('1','LA PLATA','1','1');
/*!40000 ALTER TABLE `ref_dpto_partido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_estado`
--

DROP TABLE IF EXISTS `ref_estado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_estado` (
  `nombre` varchar(255) NOT NULL DEFAULT '',
  `codigo` varchar(8) NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE KEY `nombre_3` (`nombre`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_estado`
--

LOCK TABLES `ref_estado` WRITE;
/*!40000 ALTER TABLE `ref_estado` DISABLE KEYS */;
INSERT INTO `ref_estado` VALUES ('Baja','STATE000'),('Compartido','STATE001'),('Disponible','STATE002'),('Ejemplar deteriorado','STATE003'),('En Encuadernacion','STATE004'),('En Etiquetado','STATE006'),('En Impresiones','STATE007'),('En procesos tecnicos','STATE008'),('No disponible','STATE009'),('Perdido','STATE005');
/*!40000 ALTER TABLE `ref_estado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_estado_presupuesto`
--

DROP TABLE IF EXISTS `ref_estado_presupuesto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_estado_presupuesto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_estado_presupuesto`
--

LOCK TABLES `ref_estado_presupuesto` WRITE;
/*!40000 ALTER TABLE `ref_estado_presupuesto` DISABLE KEYS */;
/*!40000 ALTER TABLE `ref_estado_presupuesto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_idioma`
--

DROP TABLE IF EXISTS `ref_idioma`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_idioma` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idLanguage` char(2) DEFAULT NULL,
  `description` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=141 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_idioma`
--

LOCK TABLES `ref_idioma` WRITE;
/*!40000 ALTER TABLE `ref_idioma` DISABLE KEYS */;
INSERT INTO `ref_idioma` VALUES (1,'ab','Abkhaziano'),(2,'aa','Afar'),(3,'af','Afrikaans'),(4,'sq','Albano'),(5,'de','Alemán'),(6,'am','Amárico'),(7,'en','Inglés'),(8,'ar','Árabe'),(9,'hy','Armenio'),(10,'as','Asamés'),(11,'ay','Aymara'),(12,'az','Azerí'),(13,'ba','Bashkir'),(14,'eu','Vasco'),(15,'be','Bielorruso'),(16,'bn','Bengalí'),(17,'dz','Bhutaní'),(18,'bi','Bislama'),(19,'bh','Bihari'),(20,'my','Birmano'),(21,'br','Bretón'),(22,'bg','Búlgaro'),(23,'ks','Cachemir'),(24,'ca','Catalán'),(25,'zh','Chino'),(26,'sn','Shona'),(27,'si','Singalés'),(28,'ko','Coreano'),(29,'co','Corso'),(30,'hr','Croata'),(31,'da','Danés'),(32,'es','Español'),(33,'eo','Esperanto'),(34,'et','Estonio'),(35,'fo','Feroés'),(36,'fj','Fidji'),(37,'fi','Finlandés'),(38,'fr','Francés'),(39,'fy','Frisón'),(40,'gd','Gaélico'),(41,'gl','Gallego'),(42,'cy','Galés'),(43,'ka','Georgiano'),(44,'gu','Gujarati'),(45,'el','Griego'),(46,'kl','Groenlandés'),(47,'gn','Guaraní'),(48,'ha','Hausa'),(49,'he','Hebreo'),(50,'hi','Hindi'),(51,'hu','Húngaro'),(52,'id','Indonesio'),(53,'ia','Interlingua'),(54,'ie','Interlingue'),(55,'iu','Inuktitut'),(56,'ik','Inupiak'),(57,'ga','Irlandés'),(58,'is','Islandés'),(59,'it','Italiano'),(60,'ja','Japonés'),(61,'jw','Javanés'),(62,'kn','Kannada'),(63,'kk','Kazaj'),(64,'km','Camboyano'),(65,'rw','Kinyarwanda'),(66,'ky','Kirghiz'),(67,'rn','Kirundi'),(68,'ku','Kurdo'),(69,'lo','Laosiano'),(70,'la','Latín'),(71,'lv','Letón'),(72,'ln','Lingala'),(73,'lt','Lituano'),(74,'mk','Macedonio'),(75,'ms','Malayo'),(76,'ml','Malayalam'),(77,'mg','Malgache'),(78,'mt','Maltés'),(79,'mi','Maori'),(80,'mr','Marathi'),(81,'mo','Moldavo'),(82,'mn','Mongol'),(83,'na','Nauri'),(84,'nl','Holandés'),(85,'ne','Nepalí'),(86,'no','Noruego'),(87,'oc','Occitán'),(88,'or','Oriya'),(89,'om','Oromo'),(90,'ug','Uigur'),(91,'wo','Uolof'),(92,'ur','Urdu'),(93,'uz','Uzbeko'),(94,'ps','Pastún'),(95,'pa','Panjabi'),(96,'fa','Farsi'),(97,'pl','Polaco'),(98,'pt','Portugués'),(99,'qu','Quechua'),(100,'rm','Reto-romance'),(101,'ro','Rumano'),(102,'ru','Ruso'),(103,'sm','Samoano'),(104,'sg','Sango'),(105,'sa','Sánscrito'),(106,'sc','Sardo'),(107,'sr','Serbio'),(108,'sh','Serbocroata'),(109,'tn','Setchwana'),(110,'sd','Sindhi'),(111,'ss','Siswati'),(112,'sk','Eslovaco'),(113,'sl','Esloveno'),(114,'so','Somalí'),(115,'sw','Swahili'),(116,'st','Sesotho'),(117,'sv','Sueco'),(118,'su','Sundanés'),(119,'tg','Tayic'),(120,'tl','Tagalo'),(121,'ta','Tamil'),(122,'tt','Tatar'),(123,'cs','Checo'),(124,'tw','Twi'),(125,'te','Telugu'),(126,'th','Thai'),(127,'bo','Tibetano'),(128,'ti','Tigrinya'),(129,'to','Tonga'),(130,'ts','Tsonga'),(131,'tr','Turco'),(132,'tk','Turcmeno'),(133,'uk','Ucraniano'),(134,'vi','Vietnamita'),(135,'vo','Volapuk'),(136,'xh','Xhosa'),(137,'yi','Yidish'),(138,'yo','Yoruba'),(139,'za','Zhuang'),(140,'zu','Zulú');
/*!40000 ALTER TABLE `ref_idioma` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_localidad`
--

DROP TABLE IF EXISTS `ref_localidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_localidad` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `LOCALIDAD` varchar(11) DEFAULT NULL,
  `NOMBRE` varchar(100) DEFAULT NULL,
  `NOMBRE_ABREVIADO` varchar(40) DEFAULT NULL,
  `ref_dpto_partido_id` varchar(11) DEFAULT NULL,
  `DDN` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ref_localidad_ref_dpto_partido1` (`ref_dpto_partido_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_localidad`
--

LOCK TABLES `ref_localidad` WRITE;
/*!40000 ALTER TABLE `ref_localidad` DISABLE KEYS */;
INSERT INTO `ref_localidad` VALUES (1,'LA PLATA','LA PLATA','LA PLATA','1','1');
/*!40000 ALTER TABLE `ref_localidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_nivel_bibliografico`
--

DROP TABLE IF EXISTS `ref_nivel_bibliografico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_nivel_bibliografico` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(4) DEFAULT NULL,
  `description` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_nivel_bibliografico`
--

LOCK TABLES `ref_nivel_bibliografico` WRITE;
/*!40000 ALTER TABLE `ref_nivel_bibliografico` DISABLE KEYS */;
INSERT INTO `ref_nivel_bibliografico` VALUES (1,'a','Analítico'),(2,'m','Monográfico'),(3,'c','Colección'),(4,'i','Integrantes'),(5,'s','Serie');
/*!40000 ALTER TABLE `ref_nivel_bibliografico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_pais`
--

DROP TABLE IF EXISTS `ref_pais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_pais` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iso` char(2) DEFAULT NULL,
  `iso3` char(3) DEFAULT NULL,
  `nombre` varchar(80) DEFAULT NULL,
  `nombre_largo` varchar(80) DEFAULT NULL,
  `codigo` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=239 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_pais`
--

LOCK TABLES `ref_pais` WRITE;
/*!40000 ALTER TABLE `ref_pais` DISABLE KEYS */;
INSERT INTO `ref_pais` VALUES (1,'AF','AFG','Afganistán','Afganistán',''),(2,'AL','ALB','Albania','Albania','355'),(3,'DE','DEU','Alemania','Alemania',''),(4,'AD','AND','Andorra','Andorra','376'),(5,'AO','AGO','Angola','Angola','244'),(6,'AI','AIA','Anguilla','Anguilla',''),(7,'AQ','ATA','Antártida','Antártida',''),(8,'AG','ATG','Antigua y Barbuda','Antigua y Barbuda',''),(9,'AN','ANT','Antillas Holandesas','Antillas Holandesas',''),(10,'SA','SAU','Arabia Saudí','Arabia Saudí',''),(11,'DZ','DZA','Argelia','Argelia',''),(12,'AR','ARG','Argentina','Argentina','25'),(13,'AM','ARM','Armenia','Armenia','374'),(14,'AW','ABW','Aruba','Aruba',''),(15,'AU','AUS','Australia','Australia','96'),(16,'AT','AUT','Austria','Austria','57'),(17,'AZ','AZE','Azerbaiján','Azerbaiján',''),(18,'BS','BHS','Bahamas','Bahamas',''),(19,'BH','BHR','Bahrein','Bahrein',''),(20,'BD','BGD','Bangladesh','Bangladesh','880'),(21,'BB','BRB','Barbados','Barbados',''),(22,'BE','BEL','Belgica','Belgica',''),(23,'BZ','BLZ','Belice','Belice',''),(24,'BJ','BEN','Benin','Benin','229'),(25,'BM','BMU','Bermuda','Bermuda',''),(26,'BT','BTN','Bhután','Bhután',''),(27,'BY','BLR','Bielorrusia','Bielorrusia',''),(28,'BO','BOL','Bolivia','Bolivia','591'),(29,'BA','BIH','Bosnia & Herzegovina','Bosnia & Herzegovina',''),(30,'BW','BWA','Botswana','Botswana','267'),(31,'BR','BRA','Brasil','Brasil',''),(32,'BN','BRN','Brunei','Brunei',''),(33,'BG','BGR','Bulgaria','Bulgaria','359'),(34,'BF','BFA','Burkina Faso','Burkina Faso','226'),(35,'BI','BDI','Burundi','Burundi','257'),(36,'CV','CPV','Cabo Verde','Cabo Verde',''),(37,'KH','KHM','Camboya','Camboya',''),(38,'CM','CMR','Camerún','Camerún',''),(39,'CA','CAN','Canada','Canada','51'),(40,'TD','TCD','Chad','Chad','235'),(41,'CL','CHL','Chile','Chile','29'),(42,'CN','CHN','China','China','83'),(43,'CY','CYP','Chipre','Chipre',''),(44,'CO','COL','Colombia','Colombia','28'),(45,'KM','COM','Comoros','Comoros',''),(46,'CG','COG','Congo (Rep.)','Congo (Rep.)','242'),(47,'KP','PRK','Corea (Norte)','Corea (Norte)',''),(48,'KR','KOR','Corea (Sur)','Corea (Sur)',''),(49,'CI','CIV','Costa de Marfil','Costa de Marfil',''),(50,'CR','CRI','Costa Rica','Costa Rica','506'),(51,'HR','HRV','Croacia','Croacia',''),(52,'CU','CUB','Cuba','Cuba','39'),(53,'ZZ','','Desconocido','Desconocido',''),(54,'DK','DNK','Dinamarca','Dinamarca',''),(55,'DM','DMA','Dominica','Dominica',''),(56,'EC','ECU','Ecuador','Ecuador','593'),(57,'EG','EGY','Egipto','Egipto',''),(58,'SV','SLV','El Salvador','El Salvador','503'),(59,'AE','ARE','Emiratos Árabes Unidos','Emiratos Árabes Unidos',''),(60,'ER','ERI','Eritrea','Eritrea','291'),(61,'SK','SVK','Eslovaquia','Eslovaquia',''),(62,'SI','SVN','Eslovenia','Eslovenia',''),(63,'ES','ESP','España','España',''),(64,'US','USA','Estados Unidos','Estados Unidos',''),(65,'EE','EST','Estonia','Estonia','372'),(66,'ET','ETH','Etiopia','Etiopia',''),(67,'FJ','FJI','Fiji','Fiji',''),(68,'PH','PHL','Filipinas','Filipinas',''),(69,'FI','FIN','Finlandia','Finlandia',''),(70,'FR','FRA','Francia','Francia',''),(71,'GA','GAB','Gabón','Gabón',''),(72,'GM','GMB','Gambia','Gambia','220'),(73,'GE','GEO','Georgia','Georgia','995'),(74,'GS','SGS','Georgia Sur & Islas Sandwich del Sur','Georgia Sur & Islas Sandwich del Sur',''),(75,'GH','GHA','Ghana','Ghana','233'),(76,'GI','GIB','Gibraltar','Gibraltar',''),(77,'GD','GRD','Granada','Granada',''),(78,'GR','GRC','Grecia','Grecia',''),(79,'GL','GRL','Groenlandia','Groenlandia',''),(80,'GP','GLP','Guadalupe','Guadalupe',''),(81,'GU','GUM','Guam','Guam',''),(82,'GT','GTM','Guatemala','Guatemala','502'),(83,'GN','GIN','Guinea','Guinea',''),(84,'GQ','GNQ','Guinea Ecuatorial','Guinea Ecuatorial',''),(85,'GW','GNB','Guinea-Bissau','Guinea-Bissau',''),(86,'GY','GUY','Guyana','Guyana','592'),(87,'GF','GUF','Guyana Francesa','Guyana Francesa',''),(88,'HT','HTI','Haiti','Haiti','509'),(89,'NL','NLD','Holanda','Holanda',''),(90,'HN','HND','Honduras','Honduras','504'),(91,'HK','HKG','Hong Kong','Hong Kong',''),(92,'HU','HUN','Hungria','Hungria',''),(93,'IN','IND','India','India','84'),(94,'ID','IDN','Indonesia','Indonesia',''),(95,'IR','IRN','Iran','Iran',''),(96,'IQ','IRQ','Iraq','Iraq',''),(97,'IE','IRL','Irlanda','Irlanda',''),(98,'BV','BVT','Isla Bouvet','Isla Bouvet',''),(99,'CX','CXR','Isla Christmas','Isla Christmas',''),(100,'HM','HMD','Isla Heard & Islas McDonald','Isla Heard & Islas McDonald',''),(101,'NF','NFK','Isla Norfolk','Isla Norfolk',''),(102,'IS','ISL','Islandia','Islandia',''),(103,'KY','CYM','Islas Cayman','Islas Cayman',''),(104,'CC','CCK','Islas Cocos','Islas Cocos',''),(105,'CK','COK','Islas Cook','Islas Cook',''),(106,'FK','FLK','Islas Falkland (Malvinas)','Islas Falkland (Malvinas)',''),(107,'FO','FRO','Islas Feroe','Islas Feroe',''),(108,'MP','MNP','Islas Marianas','Islas Marianas',''),(109,'MH','MHL','Islas Marshall','Islas Marshall',''),(110,'UM','UMI','Islas menores y remotas de Estados Unidos','Islas menores y remotas de Estados Unidos',''),(111,'SB','SLB','Islas Salomón','Islas Salomón',''),(112,'VI','VIR','Islas Vírgenes (Estados Unidos )','Islas Vírgenes (Estados Unidos )',''),(113,'VG','VGB','Islas Vírgenes (Reino Unido)','Islas Vírgenes (Reino Unido)',''),(114,'IL','ISR','Israel','Israel','972'),(115,'IT','ITA','Italia','Italia',''),(116,'JM','JAM','Jamaica','Jamaica','44'),(117,'JP','JPN','Japón','Japón',''),(118,'JO','JOR','Jordania','Jordania',''),(119,'KZ','KAZ','Kazajstán','Kazajstán',''),(120,'KE','KEN','Kenya','Kenya','254'),(121,'KG','KGZ','Kirguizstan','Kirguizstan',''),(122,'KI','KIR','Kiribati','Kiribati','686'),(123,'KW','KWT','Kuwait','Kuwait','965'),(124,'LA','LAO','Laos','Laos',''),(125,'LS','LSO','Lesotho','Lesotho','266'),(126,'LV','LVA','Letonia','Letonia',''),(127,'LB','LBN','Líbano','Líbano',''),(128,'LR','LBR','Liberia','Liberia','231'),(129,'LY','LBY','Libia','Libia',''),(130,'LI','LIE','Liechtenstein','Liechtenstein','423'),(131,'LT','LTU','Lituania','Lituania',''),(132,'LU','LUX','Luxemburgo','Luxemburgo',''),(133,'MO','MAC','Macao','Macao',''),(134,'MG','MDG','Madagascar','Madagascar','261'),(135,'MY','MYS','Malasia','Malasia',''),(136,'MW','MWI','Malawi','Malawi','265'),(137,'MV','MDV','Maldivas','Maldivas',''),(138,'ML','MLI','Malí','Malí',''),(139,'MT','MLT','Malta','Malta','356'),(140,'MA','MAR','Marruecos','Marruecos',''),(141,'MQ','MTQ','Martinica','Martinica',''),(142,'MU','MUS','Mauricio','Mauricio',''),(143,'MR','MRT','Mauritania','Mauritania','222'),(144,'YT','MYT','Mayotte','Mayotte',''),(145,'MX','MEX','México','México','53'),(146,'FM','FSM','Micronesia','Micronesia',''),(147,'MD','MDA','Moldavia','Moldavia',''),(148,'MC','MCO','Mónaco','Mónaco','377'),(149,'MN','MNG','Mongolia','Mongolia','976'),(150,'MS','MSR','Montserrat','Montserrat',''),(151,'MZ','MOZ','Mozambique','Mozambique','258'),(152,'MM','MMR','Myanmar (Birmania)','Myanmar (Birmania)',''),(153,'NA','NAM','Namibia','Namibia',''),(154,'NR','NRU','Nauru','Nauru','674'),(155,'NP','NPL','Nepal','Nepal','977'),(156,'NI','NIC','Nicaragua','Nicaragua','505'),(157,'NE','NER','Níger','Níger',''),(158,'NG','NGA','Nigeria','Nigeria','234'),(159,'NU','NIU','Niue','Niue',''),(160,'NO','NOR','Noruega','Noruega',''),(161,'NC','NCL','Nueva Caledonia','Nueva Caledonia',''),(162,'NZ','NZL','Nueva Zelanda','Nueva Zelanda',''),(163,'OM','OMN','Omán','Omán',''),(164,'PK','PAK','Pakistán','Pakistán',''),(165,'PW','PLW','Palau','Palau','680'),(166,'PA','PAN','Panamá','Panamá','507'),(167,'PG','PNG','Papua Nueva Guinea','Papua Nueva Guinea',''),(168,'PY','PRY','Paraguay','Paraguay','595'),(169,'PE','PER','Perú','Perú','34'),(170,'PN','PCN','Pitcairn','Pitcairn',''),(171,'PF','PYF','Polinesia Francesa','Polinesia Francesa',''),(172,'PL','POL','Polonia','Polonia',''),(173,'PT','PRT','Portugal','Portugal','351'),(174,'PR','PRI','Puerto Rico','Puerto Rico','47'),(175,'QA','QAT','Qatar','Qatar','974'),(176,'GB','GBR','Reino Unido','Reino Unido',''),(177,'CF','CAF','Rep. Centro Africana','Rep. Centro Africana',''),(178,'CZ','CZE','Republica Checa','Republica Checa',''),(179,'DO','DOM','República Dominicana','República Dominicana',''),(180,'RE','REU','Reunión','Reunión',''),(181,'RW','RWA','Ruanda','Ruanda',''),(182,'RO','ROM','Rumania','Rumania',''),(183,'RU','RUS','Rusia','Rusia',''),(184,'EH','ESH','Sahara Occidental','Sahara Occidental',''),(185,'AS','ASM','Samoa (Americana)','Samoa (Americana)',''),(186,'WS','WSM','Samoa (Oeste)','Samoa (Oeste)',''),(187,'SM','SMR','San Marino','San Marino','378'),(188,'ST','STP','Santo Tomé & Principe','Santo Tomé & Principe',''),(189,'SN','SEN','Senegal','Senegal','221'),(190,'SC','SYC','Seychelles','Seychelles',''),(191,'SL','SLE','Sierra Leona','Sierra Leona',''),(192,'SG','SGP','Singapur','Singapur',''),(193,'SY','SYR','Siria','Siria',''),(194,'SO','SOM','Somalia','Somalia','252'),(195,'LK','LKA','Sri Lanka','Sri Lanka',''),(196,'SH','SHN','St Helena','St Helena',''),(197,'KN','KNA','St Kitts & Nevis','St Kitts & Nevis',''),(198,'LC','LCA','St Lucia','St Lucia',''),(199,'PM','SPM','St Pierre & Miquelon','St Pierre & Miquelon',''),(200,'VC','VCT','St Vincent','St Vincent',''),(201,'ZA','ZAF','Sudáfrica','Sudáfrica',''),(202,'SD','SDN','Sudan','Sudan','249'),(203,'SE','SWE','Suecia','Suecia',''),(204,'CH','CHE','Suiza','Suiza',''),(205,'SR','SUR','Surinam','Surinam',''),(206,'SJ','SJM','Svalbard & Jan Mayen','Svalbard & Jan Mayen',''),(207,'SZ','SWZ','Swazilandia','Swazilandia',''),(208,'TH','THA','Tailandia','Tailandia',''),(209,'TW','TWN','Taiwan','Taiwan',''),(210,'TJ','TJK','Tajikistan','Tajikistan',''),(211,'TZ','TZA','Tanzania','Tanzania',''),(212,'IO','IOT','Territorio Britanico del Oceano Indico','Territorio Britanico del Oceano Indico',''),(213,'TF','ATF','Territorios Franceses del Sur y Antárticos','Territorios Franceses del Sur y Antárticos',''),(214,'TP','TMP','Timor Oriental','Timor Oriental',''),(215,'TG','TGO','Togo','Togo',''),(216,'TK','TKL','Tokelau','Tokelau','690'),(217,'TO','TON','Tonga','Tonga','676'),(218,'TT','TTO','Trinidad & Tobago','Trinidad & Tobago',''),(219,'TN','TUN','Tunez','Tunez',''),(220,'TM','TKM','Turkmenistan','Turkmenistan',''),(221,'TC','TCA','Turks & Islas Caicos','Turks & Islas Caicos',''),(222,'TR','TUR','Turquia','Turquia',''),(223,'TV','TUV','Tuvalu','Tuvalu','688'),(224,'UA','UKR','Ucrania','Ucrania',''),(225,'UG','UGA','Uganda','Uganda','256'),(226,'UY','URY','Uruguay','Uruguay','598'),(227,'UZ','UZB','Uzbekistán','Uzbekistán',''),(228,'VU','VUT','Vanuatu','Vanuatu','678'),(229,'VA','VAT','Vaticano','Vaticano',''),(230,'VE','VEN','Venezuela','Venezuela','37'),(231,'VN','VNM','Vietnam','Vietnam',''),(232,'WF','WLF','Wallis & Futuna','Wallis & Futuna',''),(233,'YE','YEM','Yemen','Yemen',''),(234,'DJ','DJI','Yibuti','Yibuti',''),(235,'YU','YUG','Yugoslavia','Yugoslavia','381'),(236,'ZR','ZAR','Zaire','Zaire','243'),(237,'ZM','ZMB','Zambia','Zambia','260'),(238,'ZW','ZWE','Zimbabwe','Zimbabwe','263');
/*!40000 ALTER TABLE `ref_pais` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_provincia`
--

DROP TABLE IF EXISTS `ref_provincia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_provincia` (
  `id` varchar(11) NOT NULL DEFAULT '',
  `NOMBRE` varchar(60) DEFAULT NULL,
  `ref_pais_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ref_provincia_ref_pais1` (`ref_pais_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_provincia`
--

LOCK TABLES `ref_provincia` WRITE;
/*!40000 ALTER TABLE `ref_provincia` DISABLE KEYS */;
INSERT INTO `ref_provincia` VALUES ('1','BUENOS AIRES',12);
/*!40000 ALTER TABLE `ref_provincia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_signatura`
--

DROP TABLE IF EXISTS `ref_signatura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_signatura` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `signatura` varchar(255) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `signatura_UNIQUE` (`signatura`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_signatura`
--

LOCK TABLES `ref_signatura` WRITE;
/*!40000 ALTER TABLE `ref_signatura` DISABLE KEYS */;
/*!40000 ALTER TABLE `ref_signatura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_soporte`
--

DROP TABLE IF EXISTS `ref_soporte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_soporte` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idSupport` varchar(10) DEFAULT NULL,
  `description` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_soporte`
--

LOCK TABLES `ref_soporte` WRITE;
/*!40000 ALTER TABLE `ref_soporte` DISABLE KEYS */;
INSERT INTO `ref_soporte` VALUES (1,'1','Impreso en papel'),(2,'2','Microfilm'),(3,'3','Soporte Magnético');
/*!40000 ALTER TABLE `ref_soporte` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ref_tipo_operacion`
--

DROP TABLE IF EXISTS `ref_tipo_operacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_tipo_operacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ref_tipo_operacion`
--

LOCK TABLES `ref_tipo_operacion` WRITE;
/*!40000 ALTER TABLE `ref_tipo_operacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `ref_tipo_operacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rep_busqueda`
--

DROP TABLE IF EXISTS `rep_busqueda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rep_busqueda` (
  `idBusqueda` int(11) NOT NULL AUTO_INCREMENT,
  `nro_socio` varchar(16) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `categoria_socio` char(2) DEFAULT NULL,
  `agregacion_temp` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idBusqueda`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rep_busqueda`
--

-- Table structure for table `rep_historial_busqueda`
--

DROP TABLE IF EXISTS `rep_historial_busqueda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rep_historial_busqueda` (
  `idHistorial` int(11) NOT NULL AUTO_INCREMENT,
  `idBusqueda` int(11) NOT NULL,
  `campo` varchar(100) DEFAULT NULL,
  `valor` varchar(100) DEFAULT NULL,
  `tipo` varchar(10) DEFAULT NULL,
  `agent` varchar(255) DEFAULT NULL,
  `agregacion_temp` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idHistorial`),
  KEY `FK_idBusqueda` (`idBusqueda`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rep_historial_busqueda`
--

LOCK TABLES `rep_historial_busqueda` WRITE;
/*!40000 ALTER TABLE `rep_historial_busqueda` DISABLE KEYS */;
/*!40000 ALTER TABLE `rep_historial_busqueda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rep_historial_circulacion`
--

DROP TABLE IF EXISTS `rep_historial_circulacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rep_historial_circulacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id1` int(11) NOT NULL,
  `id2` int(11) NOT NULL,
  `id3` int(11) DEFAULT NULL,
  `tipo_operacion` varchar(255) DEFAULT NULL,
  `nro_socio` varchar(16) DEFAULT NULL,
  `responsable` varchar(20) DEFAULT NULL,
  `id_ui` varchar(4) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `fecha` date NOT NULL DEFAULT '0000-00-00',
  `nota` varchar(50) DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `tipo_prestamo` char(2) DEFAULT NULL,
  `agregacion_temp` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rep_historial_circulacion`
--

LOCK TABLES `rep_historial_circulacion` WRITE;
/*!40000 ALTER TABLE `rep_historial_circulacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `rep_historial_circulacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rep_historial_prestamo`
--

DROP TABLE IF EXISTS `rep_historial_prestamo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rep_historial_prestamo` (
  `id_historial_prestamo` int(11) NOT NULL AUTO_INCREMENT,
  `id3` int(11) NOT NULL,
  `nro_socio` varchar(16) DEFAULT NULL,
  `tipo_prestamo` char(2) DEFAULT NULL,
  `fecha_prestamo` varchar(20) DEFAULT NULL,
  `id_ui_origen` char(4) DEFAULT NULL,
  `id_ui_prestamo` char(4) DEFAULT NULL,
  `fecha_devolucion` varchar(20) DEFAULT NULL,
  `fecha_ultima_renovacion` varchar(20) DEFAULT NULL,
  `fecha_vencimiento` varchar(20) NOT NULL,
  `renovaciones` tinyint(4) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `agregacion_temp` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_historial_prestamo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rep_historial_prestamo`
--

LOCK TABLES `rep_historial_prestamo` WRITE;
/*!40000 ALTER TABLE `rep_historial_prestamo` DISABLE KEYS */;
/*!40000 ALTER TABLE `rep_historial_prestamo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rep_historial_sancion`
--

DROP TABLE IF EXISTS `rep_historial_sancion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rep_historial_sancion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_operacion` varchar(30) DEFAULT NULL,
  `nro_socio` varchar(16) DEFAULT NULL,
  `responsable` varchar(20) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `fecha` date NOT NULL DEFAULT '0000-00-00',
  `fecha_comienzo` date DEFAULT NULL,
  `fecha_final` date DEFAULT NULL,
  `tipo_sancion` int(11) DEFAULT '0',
  `dias_sancion` int(11) DEFAULT NULL,
  `id3` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rep_historial_sancion`
--

LOCK TABLES `rep_historial_sancion` WRITE;
/*!40000 ALTER TABLE `rep_historial_sancion` DISABLE KEYS */;
/*!40000 ALTER TABLE `rep_historial_sancion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rep_registro_modificacion`
--

DROP TABLE IF EXISTS `rep_registro_modificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rep_registro_modificacion` (
  `idModificacion` int(4) NOT NULL AUTO_INCREMENT,
  `id` int(11) NOT NULL,
  `operacion` varchar(15) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `responsable` varchar(20) DEFAULT NULL,
  `nota` text,
  `tipo` varchar(255) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `agregacion_temp` varchar(255) DEFAULT NULL,
  KEY `id_modificacion` (`idModificacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rep_registro_modificacion`
--

LOCK TABLES `rep_registro_modificacion` WRITE;
/*!40000 ALTER TABLE `rep_registro_modificacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `rep_registro_modificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sist_sesion`
--

DROP TABLE IF EXISTS `sist_sesion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sist_sesion` (
  `sessionID` varchar(255) NOT NULL DEFAULT '',
  `userid` varchar(255) DEFAULT NULL,
  `ip` varchar(16) DEFAULT NULL,
  `lasttime` int(11) DEFAULT NULL,
  `nroRandom` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `flag` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`sessionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sist_sesion`
--

LOCK TABLES `sist_sesion` WRITE;
/*!40000 ALTER TABLE `sist_sesion` DISABLE KEYS */;
/*!40000 ALTER TABLE `sist_sesion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_externos_meran`
--

DROP TABLE IF EXISTS `sys_externos_meran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_externos_meran` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_ui` varchar(4) NOT NULL,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_ui` (`id_ui`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_externos_meran`
--

LOCK TABLES `sys_externos_meran` WRITE;
/*!40000 ALTER TABLE `sys_externos_meran` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_externos_meran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_metodo_auth`
--

DROP TABLE IF EXISTS `sys_metodo_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_metodo_auth` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `metodo` varchar(255) NOT NULL,
  `orden` int(12) NOT NULL,
  `enabled` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `metodo` (`metodo`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_metodo_auth`
--

LOCK TABLES `sys_metodo_auth` WRITE;
/*!40000 ALTER TABLE `sys_metodo_auth` DISABLE KEYS */;
INSERT INTO `sys_metodo_auth` VALUES (1,'mysql',1,1);
/*!40000 ALTER TABLE `sys_metodo_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_novedad`
--

DROP TABLE IF EXISTS `sys_novedad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_novedad` (
  `id` int(16) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(16) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `titulo` varchar(255) DEFAULT NULL,
  `categoria` varchar(255) DEFAULT NULL,
  `contenido` text NOT NULL,
  `links` varchar(1024) DEFAULT NULL,
  `adjunto` varchar(255) DEFAULT NULL,
  `nombreAdjunto` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_novedad`
--

LOCK TABLES `sys_novedad` WRITE;
/*!40000 ALTER TABLE `sys_novedad` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_novedad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_novedad_intra`
--

DROP TABLE IF EXISTS `sys_novedad_intra`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_novedad_intra` (
  `id` int(16) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(16) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `titulo` varchar(255) NOT NULL,
  `categoria` varchar(255) NOT NULL,
  `contenido` text NOT NULL,
  `links` varchar(1024) CHARACTER SET latin1 DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_novedad_intra`
--

LOCK TABLES `sys_novedad_intra` WRITE;
/*!40000 ALTER TABLE `sys_novedad_intra` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_novedad_intra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_novedad_intra_no_mostrar`
--

DROP TABLE IF EXISTS `sys_novedad_intra_no_mostrar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_novedad_intra_no_mostrar` (
  `id_novedad` int(16) NOT NULL,
  `usuario_novedad` varchar(16) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id_novedad`,`usuario_novedad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_novedad_intra_no_mostrar`
--

LOCK TABLES `sys_novedad_intra_no_mostrar` WRITE;
/*!40000 ALTER TABLE `sys_novedad_intra_no_mostrar` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_novedad_intra_no_mostrar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usr_estado`
--

DROP TABLE IF EXISTS `usr_estado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usr_estado` (
  `id_estado` int(11) NOT NULL AUTO_INCREMENT,
  `fuente` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) NOT NULL,
  PRIMARY KEY (`id_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usr_estado`
--

LOCK TABLES `usr_estado` WRITE;
/*!40000 ALTER TABLE `usr_estado` DISABLE KEYS */;
INSERT INTO `usr_estado` VALUES (1,'MERAN','ACTIVO');
/*!40000 ALTER TABLE `usr_estado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usr_login_attempts`
--

DROP TABLE IF EXISTS `usr_login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usr_login_attempts` (
  `nro_socio` varchar(16) NOT NULL,
  `attempts` int(32) NOT NULL DEFAULT '0',
  PRIMARY KEY (`nro_socio`),
  UNIQUE KEY `nro_socio` (`nro_socio`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usr_login_attempts`
--

--
-- Table structure for table `usr_persona`
--

DROP TABLE IF EXISTS `usr_persona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usr_persona` (
  `id_persona` int(11) NOT NULL AUTO_INCREMENT,
  `version_documento` char(1) DEFAULT NULL,
  `nro_documento` varchar(16) DEFAULT NULL,
  `tipo_documento` int(11) NOT NULL DEFAULT '1',
  `apellido` varchar(255) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `titulo` varchar(255) DEFAULT NULL,
  `otros_nombres` varchar(255) DEFAULT NULL,
  `iniciales` varchar(255) DEFAULT NULL,
  `calle` varchar(255) DEFAULT NULL,
  `barrio` varchar(255) DEFAULT NULL,
  `ciudad` varchar(255) DEFAULT NULL,
  `telefono` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `fax` varchar(255) DEFAULT NULL,
  `msg_texto` varchar(255) DEFAULT NULL,
  `alt_calle` varchar(255) DEFAULT NULL,
  `alt_barrio` varchar(255) DEFAULT NULL,
  `alt_ciudad` varchar(255) DEFAULT NULL,
  `alt_telefono` varchar(255) DEFAULT NULL,
  `codigo_postal` varchar(32) DEFAULT NULL,
  `nacimiento` date DEFAULT NULL,
  `fecha_alta` date DEFAULT NULL,
  `legajo` varchar(8) DEFAULT NULL,
  `sexo` char(1) DEFAULT NULL,
  `telefono_laboral` varchar(50) DEFAULT NULL,
  `es_socio` int(1) unsigned NOT NULL DEFAULT '0' COMMENT '1= si; 0=no',
  `institucion` varchar(255) DEFAULT NULL,
  `carrera` varchar(255) DEFAULT NULL,
  `anio` varchar(255) DEFAULT NULL,
  `division` varchar(255) DEFAULT NULL,
  `id_categoria` int(2) NOT NULL DEFAULT '8',
  `foto` varchar(255) NOT NULL,
  PRIMARY KEY (`id_persona`),
  KEY `id_persona` (`id_persona`,`nro_documento`,`tipo_documento`),
  KEY `apellido` (`apellido`),
  KEY `nombre` (`nombre`),
  KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=167923 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usr_persona`
--

LOCK TABLES `usr_persona` WRITE;
/*!40000 ALTER TABLE `usr_persona` DISABLE KEYS */;
INSERT INTO `usr_persona` VALUES (1,'P','1000000',1,'Meran','Meran Unlp',NULL,NULL,NULL,'Calle 50 y 120',NULL,' 1 ','1287423648','soportemeran@cespi.unlp.edu.ar',NULL,NULL,'',NULL,'','','1900','2009-12-23',NULL,'007','M',NULL,1,'','','','',6,'');
/*!40000 ALTER TABLE `usr_persona` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usr_ref_categoria_socio`
--

DROP TABLE IF EXISTS `usr_ref_categoria_socio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usr_ref_categoria_socio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `categorycode` char(2) DEFAULT NULL,
  `description` mediumtext,
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
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usr_ref_categoria_socio`
--

LOCK TABLES `usr_ref_categoria_socio` WRITE;
/*!40000 ALTER TABLE `usr_ref_categoria_socio` DISABLE KEYS */;
INSERT INTO `usr_ref_categoria_socio` VALUES (1,'ES','Estudiante',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14),(2,'IN','Investigador',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14),(3,'DO','Docente',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14),(4,'ND','No Docente',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14),(5,'EG','Egresado',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14),(6,'PG','Postgrado',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14),(7,'EX','Usuario externo',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14),(8,'BI','Bibliotecas',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14),(9,'BB','Bibliotecario',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14);
/*!40000 ALTER TABLE `usr_ref_categoria_socio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usr_ref_tipo_documento`
--

DROP TABLE IF EXISTS `usr_ref_tipo_documento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usr_ref_tipo_documento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usr_ref_tipo_documento`
--

LOCK TABLES `usr_ref_tipo_documento` WRITE;
/*!40000 ALTER TABLE `usr_ref_tipo_documento` DISABLE KEYS */;
INSERT INTO `usr_ref_tipo_documento` VALUES (1,'DNI','DNI');
/*!40000 ALTER TABLE `usr_ref_tipo_documento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usr_regularidad`
--

DROP TABLE IF EXISTS `usr_regularidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usr_regularidad` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usr_estado_id` int(11) NOT NULL,
  `usr_ref_categoria_id` int(11) NOT NULL,
  `condicion` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usr_regularidad`
--

LOCK TABLES `usr_regularidad` WRITE;
/*!40000 ALTER TABLE `usr_regularidad` DISABLE KEYS */;
INSERT INTO `usr_regularidad` VALUES (1,1,1,1),(7,1,3,1),(13,1,5,1),(25,1,2,0),(26,1,4,0),(27,1,6,1),(28,1,7,1),(29,1,8,1),(30,1,9,1);
/*!40000 ALTER TABLE `usr_regularidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usr_socio`
--

DROP TABLE IF EXISTS `usr_socio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usr_socio` (
  `id_persona` int(11) NOT NULL,
  `id_socio` int(11) NOT NULL AUTO_INCREMENT,
  `nro_socio` varchar(16) DEFAULT NULL,
  `id_ui` varchar(4) DEFAULT NULL,
  `fecha_alta` date DEFAULT NULL,
  `expira` date DEFAULT NULL,
  `flags` int(11) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `last_change_password` date DEFAULT NULL,
  `change_password` tinyint(1) DEFAULT '0',
  `cumple_requisito` varchar(255) DEFAULT NULL,
  `nombre_apellido_autorizado` varchar(255) DEFAULT NULL,
  `dni_autorizado` varchar(16) DEFAULT NULL,
  `telefono_autorizado` varchar(255) DEFAULT NULL,
  `is_super_user` int(11) NOT NULL DEFAULT '0',
  `credential_type` varchar(255) DEFAULT NULL,
  `activo` varchar(255) DEFAULT NULL,
  `note` text,
  `agregacion_temp` varchar(255) DEFAULT NULL,
  `theme` varchar(255) DEFAULT NULL,
  `theme_intra` varchar(255) DEFAULT NULL,
  `locale` varchar(32) DEFAULT NULL,
  `lastValidation` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_categoria` int(2) NOT NULL DEFAULT '1',
  `recover_password_hash` varchar(255) DEFAULT NULL,
  `client_ip_recover_pwd` varchar(255) DEFAULT NULL,
  `recover_date_of` timestamp NULL DEFAULT NULL,
  `last_auth_method` varchar(255) NOT NULL DEFAULT 'mysql',
  `remindFlag` int(1) NOT NULL DEFAULT '1',
  `id_estado` int(11) NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `es_admin` int(1) DEFAULT NULL,
  PRIMARY KEY (`id_socio`),
  KEY `id_persona` (`id_persona`),
  KEY `nro_socio` (`nro_socio`),
  KEY `id_ui` (`id_ui`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usr_socio`
--

LOCK TABLES `usr_socio` WRITE;
/*!40000 ALTER TABLE `usr_socio` DISABLE KEYS */;
INSERT INTO `usr_socio` VALUES (1,1,'meranadmin','MERA','2010-02-15',NULL,1,'0385tAqkMI66N2lmUq080FtjO8Qwt0Old/tWIZczOOo','2012-10-30 21:49:58','0000-00-00',0,'2013030600:00:00','','','',1,'superLibrarian','1','','','default','default','es_ES','2012-10-30 21:49:58',9,'PMlYOV9TjfdlsygDVRkQEcy2utxj80sMIzAQKmD4hls','163.10.10.78 <>','2012-10-30 21:49:58','mysql',1,1,'a473a594c51a00aad2af931e85edc9e6999c7725.jpg',1);
/*!40000 ALTER TABLE `usr_socio` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-10-31 14:42:40

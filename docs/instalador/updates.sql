USE reemplazarDATABASE;
#UPDATES PARA ACTUALIZACIONES DE SANDBOX

#agregar al actualizar el numero de version actual (0.9.3) y los updates.sql con un postFix que sea el numero de version

ALTER TABLE  `circ_prestamo` ADD  `fecha_vencimiento_reporte` VARCHAR( 20 ) NOT NULL;

# APARTIR DE ACA ES LA v0.9.3

INSERT INTO  `pref_tabla_referencia` (
`id` ,
`nombre_tabla` ,
`alias_tabla` ,
`campo_busqueda` ,
`client_title`
)
VALUES (
NULL ,  'cat_ref_tipo_nivel3',  'tipo_ejemplar',  'nombre',  'Tipo de Documento'
);

ALTER TABLE  `cat_estructura_catalogacion` CHANGE  `itemtype`  `itemtype` VARCHAR( 8 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL;

ALTER TABLE  `usr_persona` CHANGE  `foto`  `foto` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL;


## 13/02/2013

UPDATE pref_preferencia_sistema 
SET value = '200'
WHERE (variable = 'limite_resultados_autocompletables');


## 22/02/2013

INSERT INTO  `pref_preferencia_sistema` (`id`, `variable`, `value`, `explanation`, `options`, `type`, `categoria`, `label`, `explicacion_interna`, `revisado`) VALUES (NULL, 'origen_catalogacion', 'AgLpU', 'Origen de Catalogacion (Campo 40 a en exportación Isis MARC)', NULL, 'text', 'sistema', 'Origen de Catalogación', 'Origen de Catalogacion (Campo 40 a en exportación Isis MARC)', '0');

## 25/02/2013

UPDATE pref_preferencia_sistema SET explanation = 'Habilita/Deshabilita la búsqueda en servidores externos Meran. También permite que sistemas externos busquen sobre este MERAN.' WHERE variable = "external_search";

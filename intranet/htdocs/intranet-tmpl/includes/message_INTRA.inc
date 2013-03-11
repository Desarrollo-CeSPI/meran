<!-- Aca se definen todos los mensajes de catalogacion -->
[% INCLUDE 'localized_messages.inc' %]


<script type="text/javascript">

    /*================================================Reportes=================================================*/
    DEBE_INGRESAR_LA_SIGNATURA = "[% 'Debe ingresar una signatura topogr&aacute;fica' | i18n %]";
    DEBE_INGRESAR_EL_BARCODE = "[% 'Debe ingresar un barcode' | i18n %]";
    GUARDANDO = "[% 'Guardando cambios' | i18n %]";
    /*================================================Circulacion=================================================*/
    FALLO_NOTA = "[% 'La nota no se ha podido guardar' | i18n %]";
    NOTA_GUARDADA = "[% 'La nota se actualizo correctamente' | i18n %]";
    CIRCULACION = "[% 'Circulaci&oacute;n' | i18n %]";
    /*================================================Catalogacion===================================================*/
    CAMPO_NO_PUEDE_ESTAR_EN_BLANCO= "[% 'El campo no puede estar en blanco' | i18n %]";
    ESTE_CAMPO_NO_PUEDE_ESTAR_EN_BLANCO= "[% 'Este campo es requerido, no lo deje en blanco' | i18n %]";
    ESTA_SEGURO_QUE_DESEA_BORRARLO= "&iquest;[% 'Est&aacute; seguro que desea borrarlo' | i18n %]?";
    HAY_BARCODES_REPETIDOS= "[% 'Hay barcodes repetidos' | i18n %]";
    ELIJA_AL_MENOS_UN_EJEMPLAR= "[% 'Elija al menos un ejemplar para realizar la acci&oacute;n' | i18n %]";
    FALTA_PARAMETRO_PARA_REFERENCIA= "[% 'Falta par&aacute;metro para referencia' | i18n %]";
    CATALOGO_TITLE= "[% 'Advertencia de cat&aacute;logo' | i18n %]";
    LLENE_EL_CAMPO= "[% 'Llene el campo' | i18n %]";
    CATALOGO_ALERT_TITLE= "[% 'Advertencia de cat&aacute;logo' | i18n %]";
    BORRAR_CANTIDAD_DE_EJEMPLARES = "[% 'Borrar Cantidad de ejemplares?' %]";
    BORRAR_LISTA_DE_CODIGOS = "[% 'Borrar lista de codigos de barras?' %]";
    SELECCIONE_EL_ESQUEMA = "[% 'Seleccione el esquema' %]";
    DEBE_SELECCIONAR_TODOS_LOS_CAMPOS_REQUERIDOS = "[% 'Debe seleccionar todos los campos requeridos.' %]";
    DEBE_SELECCIONAR_UNA_TABLA_DE_REFERENCIA = "[% 'Debe seleccionar una tabla de referencia.' %]";
    DEBE_SELECCIONAR_AL_MENOS_UN_CAMPO = "[% 'Debe seleccionar al menos un campo.' %]";
    DEBE_SELECCIONAR_MAS_DE_UN_EJEMPLAR = "[% 'Debe seleccionar m&aacute;s de un ejemplar.' %]";
    ADD_EJEMPLARES						= "[% 'Agregar ejemplares' %]";
    ADD_EDICION                      = "[% 'Agregar edición' %]";
    CANCELAR_IMPORTACION             = "[% 'Esto lleva a cancelar el proceso de importar' %]";
    /*=============================================Fin===Catalogacion=================================================*/

    ELIMINAR_NOVEDAD = "[% 'Elminar la novedad?' %]";
    NOVEDAD_TITLE = "[% 'Administracion de Novedades' %]";


    /*================================================Usuarios========================================================*/
    INGRESE_UN_DATO= "[% 'Ingrese un dato' | i18n %]";
    NO_SE_SELECCIONO_NINGUN_USUARIO= "[% 'No seleccion&oacute; ning&uacute;n usuario' | i18n %]";
    // mensaje compuesto
    ESTA_SEGURO= "[% 'Esta seguro' | i18n %]";
    TARJETA_NRO= "[% ' -  Tarjeta nro ' | i18n %]";
    DATOS_ENVIADOS_INCORRECTOS= "[% 'No se recibieron datos del servidor, posiblemente debido a que se ha enviado informacion incorrecta.' | i18n %]";
    // fin mensaje compuesto
	SUBIR_IMAGEN = "[% 'Seleccionar imagen' | i18n %]";
	ARRASTRAR_IMAGEN = "[% 'Arrastre para subir la imagen' | i18n %]";
    SUPER_USER_GRANTED = "[% 'Ha concedido algunos permisos de super usuario, esta seguro que quiere continuar' | i18n %]?";
    PERMISSION_GRANTED = "[% 'Ha concedido permisos, esta seguro que quiere continuar' | i18n %]?";

    NEW_GRANT = "[% 'ATENCION: DANDO DE ALTA UN NUEVO PERMISO YA QUE EL USUARIO NO CUENTA CON PRIVILEGIOS PARA TAL COMBINACION ' | i18n %]";
    // mensaje compuesto
    UD_ESTA_A_PUNTO= "[% 'Usted est&aacute; a punto de habilitar' | i18n %]";
    A_LOS_PROPIETARIOS= "[% 'a los propietarios de' | i18n %]:";
    HABILITAR_POTENCIALES_CONFIRM = "[% 'Habilitar a los usuarios seleccionados?' | i18n %]"; 
    // fin mensaje compuesto

    PERMISOS_DE_ACCESO= "[% 'Permisos de Acceso' | i18n %]";
    ELIJA_AL_MENOS_UN_PERMISO= "[% 'Elija al menos un permiso' | i18n %]";
    POR_FAVOR_SELECCIONE_LA_CATEGORIA= "[% 'Por favor, seleccione la categor&iacute;a' | i18n %]";
    POR_FAVOR_INGRESE_SU_APELLIDO= "[% 'Por favor, ingrese su apellido' | i18n %]";
    POR_FAVOR_INGRESE_SU_NOMBRE= "[% 'Por favor, ingrese su/s nombre/s' | i18n %]";
    POR_FAVOR_INGRESE_LA_TARJETA_DE_IDENTIFICACION= "[% 'Por favor, ingrese la tarjeta de id.' | i18n %]";
    POR_FAVOR_INGRESE_EL_SEXO= "[% 'Por favor, ingrese el sexo.' | i18n %]";
    POR_FAVOR_INGRESE_LA_CALLE_DONDE_VIVE= "[% 'Por favor, ingrese la calle en donde vive.' | i18n %]";
    POR_FAVOR_INGRESE_LA_CIUDAD_EN_DONDE_VIVE= "[% 'Por favor, ingrese La ciudad en donde vive.' | i18n %]";
    POR_FAVOR_INGRESE_LA_FECHA_DE_NACIMIENTO= "[% 'Por favor, ingrese la fecha de nacimiento.' | i18n %]";
    POR_FAVOR_INGRESE_EL_TELEFONO= "[% 'Por favor, ingrese el tel&eacute;fono.' | i18n %]";
    POR_FAVOR_INGRESE_SU_NRO_DE_DNI= "[% 'Por favor, ingrese su nro. de documento' | i18n %]";
    POR_FAVOR_INGRESE_SOLO_DIGITOS= "[% 'Por favor, ingrese s&oacute;lo d&iacute;gitos' | i18n %]";
    POR_FAVOR_INGRESE_UNA_UI= "[% 'Por favor, seleccione una unidad de informacion' | i18n %]";
    CONFIRMAR_ELIMINAR_FOTO = "[% 'Seguro desea eliminar la foto de usuario?' | i18n %]";
    LA_LONG_DEL_DNI_DEBE_SER_DE_8_DIGITOS_INGRESO_MAS= "[% 'La longitud del documento debe ser de 8 d&iacute;gitos (ha ingresado menos)' | i18n %]";
    LA_LONG_DEL_DNI_DEBE_SER_DE_8_DIGITOS_INGRESO_MENOS= "[% 'La longitud del documento debe ser de 8 d&iacute;gitos (ha ingresado m&aacute;s)' | i18n %]";
    POR_FAVOR_INGRESE_UNA_DIR_DE_EMAIL_VALIDA= "[% 'Por favor, ingrese una direcci&oacute;n de email v&aacute;lida' | i18n %]";
    POR_FAVOR_INGRESE_UNA_CONTRASENIA= "[% 'Por favor, ingrese ingrese una contraseña.' | i18n %]";
    LAS_CLAVES_SON_DISTINTAS= "[% 'Las claves son distintas.\nIngreselas nuevamente.' | i18n %]";
    CAMBIO_DE_CONTRASENIA= "[% 'Cambio de Contrase&ntilde;a' | i18n %]";
    PRESTAMO_INTER_BIBLIO= "[% 'Pr&eacute;stamo Interbibliotecario' | i18n %]";
    PRESTAMO_STRING =  "[% 'Pr&eacute;stamo' | i18n %]";
    CONFIRMA_LA_BAJA= "[% 'Confirma la baja ?' | i18n %]";
    FILTRO_POR= "[% 'filtro: ' | i18n %]";
    SOLO_SERA_NUMERICO= "[% 'S&oacute;lo ser&aacute; num&eacute;rico' | i18n %]";
    CONFIRMAR_ELIMINAR_AFILIADO= "[% 'Desea eliminar el autorizado para este usuario?' | i18n %]";
    GRANT_PERMISSION_TITLE= "[% 'Advertencia de cesion de Permisos' | i18n %]";
    USUARIOS_ALERT_TITLE= "[% 'Advertencia de Usuarios' | i18n %]";
    FALTA_INGRESAR_EL_NOMBRE_DEL_AUTORIZADO= "[% 'Falta ingresar el nombre del autorizado' | i18n %]";
    FALTA_INGRESAR_EL_DNI_DEL_AUTORIZADO= "[% 'Falta ingresar el DNI del autorizado' | i18n %]";
    FALTA_INGRESAR_EL_TELEFONO_DEL_AUTORIZADO= "[% 'Falta ingresar el Tel&eacute;fono del autorizado' | i18n %]";
    RESET_PASSWORD= "[% 'Desea reestablecer el password del usuario?' | i18n %]";
    CONFIRMA_LA_ELIMINACION = "[% 'Esta operaci&oacute;n no se puede reparar. Desea eliminar el usuario por completo?' | i18n %]";
    /*================================================Fin==Usuarios==================================================*/

    /*================================================Catalogo=======================================================*/
    INGRESE_EL_USUARIO= "[% 'Ingrese el Usuario' | i18n %]";
    ERROR_ITSELF= "[% 'Error' | i18n %]";
    var CAMPO_NO_PUEDE_ESTAR_EN_BLANCO= "[% 'El campo no puede estar en blanco.' | i18n %]";
    
    /*================================================Fin==Catalogo==================================================*/
    /*================================================Circulacion===================================================*/
    ESTA_SEGURO_QUE_DESEA_CANCELAR_LA_RESERVA= "&iquest;[% 'Esta seguro que desea cancelar la reserva' | i18n %]?";
    /*=============================================Fin===Circulacion=================================================*/
    /*================================================Control Autoridades==============================================*/
    YA_EXISTE_EL_ELEMENTO= "[% 'Ya existe el elemento' | i18n %]";
    CONFIRMA_LA_BAJA_DEL_SEUDONIMO= "&iquest;[% 'Confirma la baja del seudonimo' | i18n %]?";
    CONFIRMA_LA_BAJA_DEL_SINONIMO= "&iquest;[% 'Confirma la baja del sinonimo' | i18n %]?";
    CONTROL_AUTORIDADES_TITLE= "[% 'Advertencia de Control de Autoridades' | i18n %]";
    /*=============================================Fin===Control Autoridades===========================================*/

    /*================================================Visualizacion Opac==============================================*/
    AGREGAR_ENCABEZADO= "[% 'Agregar Encabezado' | i18n %]";
    CONFIRMA_LA_BAJA_DEL_ENCABEZADO = "[% 'Confirma la baja del Encabezado?' | i18n %]";
    INGRESE_EL_ENCABEZADO = "[% 'Ingrese el encabezado' | i18n %]";
    VISUALIZACION_OPAC_TITLE= "[% 'Advertencia de Visualizaci&oacute;n del Opac' | i18n %]";
    NO_SE_PUEDE_SUBIR_MAS= "[% 'No se puede subir m&aacute;s' | i18n %]";
    SELECCIONE_EL_FILTRO_PARA_CAMPOS= "[% 'Seleccione el filtro para campos' | i18n %]";
    SELECCIONE_EL_CAMPO= "[% 'Seleccione el campo' | i18n %]";
    SELECCIONE_EL_SUBCAMPO= "[% 'Seleccione el subcampo' | i18n %]";
    INGRESE_EL_TEXTO_PREDECESOR= "[% 'Ingrese el texto predecesor' | i18n %]";
    INGRESE_EL_TEXTO_SUCESOR= "[% 'Ingrese el texto sucesor' | i18n %]";
    INGRESE_EL_SEPERADOR= "[% 'Ingrese el separador' | i18n %]";
    SELECCIONE_VISTA_OPAC= "[% 'Seleccione una opcion en todos los campos' | i18n %]";
    /*=============================================Fin===Visualizacion Opac===========================================*/

    /*================================================Visualizacion INTRA==============================================*/
    AGREGAR_ENCABEZADO= "[% 'Agregar Encabezado' | i18n %]";
    CONFIRMA_LA_BAJA_DEL_ENCABEZADO = "[% 'Confirma la baja del Encabezado?' | i18n %]";
    INGRESE_EL_ENCABEZADO = "[% 'Ingrese el encabezado' | i18n %]";
    VISUALIZACION_OPAC_TITLE= "[% 'Advertencia de Visualizaci&oacute;n del Opac' | i18n %]";
    NO_SE_PUEDE_SUBIR_MAS= "[% 'No se puede subir m&aacute;s' | i18n %]";
    SELECCIONE_EL_FILTRO_PARA_CAMPOS= "[% 'Seleccione el filtro para campos' | i18n %]";
    SELECCIONE_EL_CAMPO= "[% 'Seleccione el campo' | i18n %]";
    SELECCIONE_EL_SUBCAMPO= "[% 'Seleccione el subcampo' | i18n %]";
    INGRESE_EL_TEXTO_PREDECESOR= "[% 'Ingrese el texto predecesor' | i18n %]";
    INGRESE_EL_TEXTO_SUCESOR= "[% 'Ingrese el texto sucesor' | i18n %]";
    INGRESE_EL_SEPERADOR= "[% 'Ingrese el separador' | i18n %]";
    SELECCIONE_VISTA_INTRA= "[% 'Seleccione una opcion en todos los campos' | i18n %]";
    SEGURO_QUE_DESEA_ELIMINAR_TODO_EL_CAMPO= "&iquest;[% 'Est&aacute; seguro que desea eliminar el campo y todas sus visualizaciones' | i18n %]?";
    /*=============================================Fin===Visualizacion Opac===========================================*/
    /*================================================Busquedas==============================================*/
    INGRESE_DATOS_PARA_LA_BUSQUEDA = "[% 'Ingrese datos para la b&uacute;squeda' | i18n %]";
    INGRESE_AL_MENOS_TRES_CARACTERES_PARA_REALIZAR_LA_BUSQUEDA = "[% 'Ingrese al menos 3 caracteres para realizar la b&uacute;squeda' | i18n %]";
    /*=============================================Fin===Busquedas===========================================*/

    /*================================================Reglas Sanciones==============================================*/
    POR_FAVOR_SELECCIONE_TIPO_PRESTAMO= "[% 'Por favor, seleccione un tipo de pr&eacute;stamo' | i18n %]";
    POR_FAVOR_SELECCIONE_CATEGORIA_SOCIO= "[% 'Por favor, seleccione una categor&iacute;a de socio' | i18n %]"
    /*=============================================Fin===Reglas Sanciones===========================================*/

    /*================================================Sanciones==============================================*/
    ESTA_SEGURO_QUE_DESEA_CANCELAR_LA_SANCION= "&iquest;[% 'Est&aacute; seguro que desea cancelar la sanci&oacute;n' | i18n %]?";
    SANCIONES_TITLE= "[% 'Advertencia de Sanciones' | i18n %]";
    /*===============================================Fin=Sanciones===========================================*/

    /*====================================================Admin==========================================================*/
    DEBE_SELECCIONAR_UNA_OPCION= "[% 'Debe seleccionar al menos una opci&oacute;n' | i18n %]";
    DEBE_SELECCIONAR_UNA_TABLA_DE_REFERENCIA= "[% 'Debe seleccionar una tabla de referencia' | i18n %]";
    DEBE_SELECCIONAR_UN_VALOR_AUTORIZADO= "[% 'Debe seleccionar un valor autorizado' | i18n %]";

    ADMIN_TITLE= "[% 'Advertencia de Administraci&oacute;n' | i18n %]";

    TITLE_FIRST_ASSIGN_REFERENCIES = "[% 'Desea asignar el elemento con clave ' | i18n %]";

    TITLE_FIRST_ASSIGN_DELETE_REFERENCIES = "[% 'Desea asignar y eliminar el elemento con clave ' | i18n %]";

    TITLE_TO_ASSIGN_REFERENCIES = "[% ' a este otro? ' | i18n %]";

    TITLE_DELETE_REFERENCE = "[% ' Desea eliminar ' | i18n %]";

    /*=================================================Fin===Admin=======================================================*/

    /*====================================================Estante==========================================================*/
    ELIMINAR_ESTANTE_TITLE =  "[% 'Advertencia' | i18n %]";
    ELIMINAR_LOS_ESTANTES = "[% 'Usted est&aacute; a punto de eliminar los estantes' | i18n %]";
    ELIMINAR_E_DOC= "[% 'Desea eliminar el documento digital seleccionado?' | i18n %]";
    NO_SE_SELECCIONO_NINGUN_ESTANTE= "[% 'No seleccion&oacute; ning&uacute;n estante' | i18n %]";

    ELIMINAR_CONTENIDO_TITLE =  "[% 'Advertencia' | i18n %]";
    ELIMINAR_EL_CONTENIDO = "[% 'Usted est&aacute; a punto de eliminar el contenido' | i18n %]";
    NO_SE_SELECCIONO_NINGUN_CONTENIDO= "[% 'No seleccion&oacute; ning&uacute;n contenido' | i18n %]";
    /*=================================================Fin===Estante=======================================================*/

    /*=================================================Proveedores=========================================================*/
    POR_FAVOR_INGRESE_UN_NOMBRE                     = "[% 'Por favor ingrese un nombre' | i18n %]";
    POR_FAVOR_INGRESE_UN_DOMICILIO                  = "[% 'Por favor ingrese un domicilio' | i18n %]";
    POR_FAVOR_INGRESE_UN_TELEFONO                   = "[% 'Por favor ingrese un telefono' | i18n %]";
    PROVEEDOR_ALERT_TITLE                           = "[% 'Advertencia de cat&aacute;logo' | i18n %]";
    POR_FAVOR_INGRESE_UNA_DIR_DE_EMAIL_VALIDA       = "[% 'Por favor ingrese una direcci&oacute;n de email v&aacute;lida' | i18n %]";
    POR_FAVOR_INGRESE_UN_APELLIDO                   = "[% 'Por favor ingrese un apellido' | i18n %]";
    POR_FAVOR_INGRESE_UN_TIPO_DE_DOC                = "[% 'Por favor seleccione un tipo de documento' | i18n %]";
    POR_FAVOR_INGRESE_UN_NRO_DE_DOC                 = "[% 'Por favor ingrese un n&uacute;mero de documento' | i18n %]";
    POR_FAVOR_INGRESE_UNA_RAZON_SOCIAL              = "[% 'Por favor ingrese una raz&oacute;n social' | i18n %]";
    POR_FAVOR_INGRESE_UN_CUIT_CUIL                  = "[% 'Por favor ingrese un n&uacute;mero de CUIT o CUIL' | i18n %]";
    POR_FAVOR_INGRESE_UN_PAIS                       = "[% 'Por favor seleccione un pais' | i18n %]";
    POR_FAVOR_INGRESE_UNA_PROV                      = "[% 'Por favor seleccione una provincia' | i18n %]";
    POR_FAVOR_INGRESE_UNA_CIUDAD                    = "[% 'Por favor seleccione una ciudad' | i18n %]";
    POR_FAVOR_INGRESE_UNA_MONEDA                    = "[% 'Por favor ingrese una moneda' | i18n %]";
    POR_FAVOR_SELECCIONE_LAS_MONEDAS_A_BORRAR       = "[% 'Por favor seleccione la/s monedas que desea borrar' | i18n %]";
    POR_FAVOR_INGRESE_UN_TIPO_DE_MATERIAL           = "[% 'Por favor seleccione alg&uacute;n tipo de material' | i18n %]";
    POR_FAVOR_SELECCIONE_LAS_FORMAS_DE_ENVIO_QUITAR = "[% 'Por favor seleccione las formas de envio que desea quitar' | i18n %]";
    POR_FAVOR_SELECCIONE_LAS_FORMAS_DE_ENVIO_AGREGAR= "[% 'Por favor seleccione las formas de envio que desea agregar' | i18n %]";
    POR_FAVOR_SELECCIONE_LOS_MATERIALES_QUITAR      = "[% 'Por favor seleccione los materiales que desea quitar' | i18n %]";
    POR_FAVOR_SELECCIONE_LOS_MATERIALES_AGREGAR     = "[% 'Por favor seleccione los materiales que desea agregar' | i18n %]";
    POR_FAVOR_INGRESE_UNA_FORMA_DE_ENVIO            = "[% 'Por favor seleccione alg&uacute;na forma de envio' | i18n %]";
    POR_FAVOR_SELECCIONE_LAS_RECOMENDACIONES        = "[% 'Por favor seleccione las recomendaciones que desea incluir' | i18n %]";
    POR_FAVOR_SELECCIONE_PROVEEDORES_A_PRESUPUESTAR = "[% 'Por favor seleccione los proveedores que desea presupuestar' | i18n %]";

    /*=================================================Fin===Proveedor=======================================================*/

    /*=================================================File Uploader=========================================================*/
    TYPE_ERROR  = " Error en {file}: Solamente se permiten extensiones {extensions}";
    SIZE_ERROR  = "{file} es muy grande, el maximo tama&ntilde;o es {sizeLimit}.";
    EMPTY_ERROR = "{file} esta vacio. Elija un archivo con contenido, por favor.";
    ON_LEAVE    = "[% 'The files are being uploaded, if you leave now the upload will be cancelled.' | i18n %]";
    /*=================================================Fin File Uploader======================================================*/

    /*=================================================Servidores z3950=========================================================*/
    POR_FAVOR_INGRESE_SERVER_SERVIDOR   = "[% 'Por favor ingrese el servidor z3950' | i18n %]";
    POR_FAVOR_INGRESE_PUERTO_SERVIDOR   = "[% 'Por favor ingrese el puerto del servidor z3950' | i18n %]";
    POR_FAVOR_INGRESE_BASE_SERVIDOR     = "[% 'Por favor ingrese la base del servidor z3950' | i18n %]";
    POR_FAVOR_INGRESE_USUARIO_SERVIDOR  = "[% 'Por favor ingrese el usuario del servidor z3950' | i18n %]";
    POR_FAVOR_INGRESE_PASSWORD_SERVIDOR = "[% 'Por favor ingrese la password del servidor z3950' | i18n %]";
    POR_FAVOR_INGRESE_NOMBRE_SERVIDOR   = "[% 'Por favor ingrese el nombre del servidor z3950' | i18n %]";
    POR_FAVOR_INGRESE_SINTAXIS_SERVIDOR = "[% 'Por favor ingrese la sintaxis del servidor z3950' | i18n %]";
    /*================================================Fin Servidores z3950====================================================*/

    /*=================================================Mails prestamos vencidos===============================================*/
    PRESTAMO_TITLE =  "[% 'Advertencia' | i18n %]";
    POR_FAVOR_SELECCIONE_ALGUN_PRESTAMO  = "[% 'Por favor seleccione al menos un pr&eacute;stamo' | i18n %]";
    /*==========================================Fin Mails prestamos vencidos==================================================*/

    /*====================================================Importacion/Exportacion==========================================================*/
    IMPORTACION_ALERT_TITLE =  "[% 'Advertencia' | i18n %]";

    /*=================================================Fin===Estante=======================================================*/

    /*=================================Exportacion Visualizaciones======================================*/
    EXPORTACION_VISUALIZACION = "[% 'Esta a punto de realizar la exportaci&oacute;n. ¿Desea continuar?' | i18n %]";
    /*===============================FIN - Exportacion Visualizaciones====================================*/
</script>

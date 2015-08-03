package C4::AR::Mensajes;

use strict;
require Exporter;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

# set the version for version checking
$VERSION = 0.01;

@ISA = qw(Exporter);

@EXPORT = qw(
    getMensaje
    getAccion
    encodeUtf8Msj
);

#000 - Todo normal
#R000 - R099 para Reservas
#P100 - P199 para Prestamos
#S200 - S299 para Sanciones
#U300 - U399 para Usuarios
#SP000 - SP999 para errores de sistema
#B400 - B499 para Errores e Informacion de Base de Datos
#C500 - C599 para Catalogacion
#CA600 - CA699 para Control de Autoridades
#F700 - F799 para Favoritos
#VO800 - VO899 para Visualizacion Opac
#E900 - E999 para Estantes
#RC00 - #RC99 para Recomendaciones
#IO00 - #IO99 para Importaciones/Exportaciones
#UP00 - #UP99 para Upload Files

# %mensajes mapea codigo de mensaje con la descripcion del mismo
my %mensajesOPAC = (
    '000' => '',
    'R001' => 'Disculpe, usted no puede realizar m&aacute;s de *?* reservas',
    'R002' => 'Disculpe, no puede efectuar reservas porque ya tiene una reserva para el mismo grupo y tipo de prestamo ',
    'R003' => 'Disculpe, usted no puede tener m&aacute;s de *?* reservas en espera.',
    'R004' => '',
    'R005' => '',
    'R006' => '',
    'R007' => 'Disculpe, pero no hay ejemplares disponibles para reservar.',
    'R008' => 'Disculpe, llego al m&aacute;ximo de reservas en espera.',
    'R009' => 'Disculpe, no se pudo realizar la reserva, intente nuevamente.',
    'R010' => 'Disculpe, no se pudo cancelar la reserva, intente nuevamente.',
    'R011' => 'Disculpe, no se pudo cancelar y reservar, intente nuevamente.',
    'R012' => 'Disculpe, no se pudo renovar, ha alcanzado el m&aacute;ximo posible.',
    'R900' => 'Disculpe, no se circular desde OPAC, la biblioteca ha deshabilitado esto.',
    'P100' => 'Disculpe, no puede efectuar reservas porque ya tiene un ejemplar prestado del mismo grupo y del mismo tipo de prestamo',
    'P101' => 'Disculpe, usted ha alcanzado la cantidad m&aacute;xima de pr&eacute;stamos *?*. No puede efectuar reservas sobre ejemplares.',
    'P102' => '',
    'P103' => '',
    'P104' => '',
    'P105' => '',
    'P106' => '',
    'P107' => '',
    'P108' => '',
    'P109' => 'El prestamo del ejemplar con c&oacute;digo de barras *?* ha sido devuelto.',
    'P110' => 'El prestamo n&uacute;mero *?* ha sido devuelto',
    'P111' => 'El ejemplar con c&oacute;digo de barras *?* fue renovado',
    'P112' => 'El ejemplar con c&oacute;digo de barras *?* no pudo ser renovado',
    'P113' => 'Disculpe, no se pudo renovar el pr&eacute;stamo, intente nuevamente.',
    'P114' => 'Disculpe, no puede efectuar renovaciones porque usted no cumple condici&oacute;n.',
    'P118' => 'El ejemplar que intenta renovar esta vencido',
    'P119' => 'Renovaci&oacute;n fuera de fecha',
    'P120' => 'Disculpe, no se pudo renovar el pr&eacute;stamo, el grupo posee reservas.',
    'P131' => 'Disculpe, no puede efectuar la renovación porque el usuario tiene ejemplar/es vencido/s.',
    'S200' => 'Disculpe, no puede efectuar reservas porque usted esta sancionado hasta el *?*',
    'S201' => 'Disculpe, no puede efectuar reservas porque usted tiene una posible sanci&oacute;n pendiente.',
    'S204' => 'Disculpe, no puede efectuar el pr&eacute;stamo porque tiene ejemplar/es vencido/s.',
    'S205' => 'Disculpe, usted tiene una sanci&oacute;n para este tipo de pr&eacute;stamo hasta el *?*.',
    'S206' => 'Disculpe, no se puede efectuar la reserva porque tiene ejemplar/es vencido/s.',
    'U300' => 'Disculpe, no puede efectuar reservas porque no cumple la condici&oacute;n debido a las normas de la Biblioteca.',
    'U301' => 'Disculpe, no puede efectuar reservas porque usted no ha realizado a&uacute;n el curso para usuarios.',
    'U302' => 'El ejemplar que acaba de reservar puede ser retirado hasta el d&iacute;a: *?* a las *?*',
    'U303' => 'En este momento no hay ejemplares disponibles para pr&eacute;stamo inmediato. 
                Cuando haya alg&uacute;n ejemplar a su disposici&oacute;n se le informar&aacute; a 
                <br><i> *?* </i><br>Verifique que sus datos sean correctos ya que el mensaje se enviar&aacute; a esta direcci&oacute;n. <br>Para mayo seguridad, también puede verificar en su cuenta de MERAN.',
    'U304' => 'Disculpe, no puede reservar porque no hizo el curso para usuarios.',
    'U305' => 'El ejemplar que acaba de reservar puede ser retirado hasta el d&iacute;a: *?*',
    'U308' => 'Se cancel&oacute; la reserva con &eacute;xito.',
    'U315' => 'Las passwords no coinciden, ingrese la password nuevamente.',
    'U338' => 'Se modificaron los datos del usuario correctamente.',
    'U339' => 'No se pudieron modificar los datos del usuario, intente nuevamente.',
    'U354' => 'Disculpe, usted no tiene permisos suficientes para acceder a esta p&aacute;gina.',
    'U357' => 'Ha ingresado un nombre de usuario o password incorrecto. Por favor intente nuevamente.',
    'U358' => 'Ud. ha cerrado su sesion. Gracias por usar MERAN.',
    'U361' => 'El password actual NO coincide con el suyo.',
    'U400' => 'UD. acaba de cambiar la password, debe ingresar nuevamente.',
    'U425' => 'El valor ingresado en el Captcha es invalido, por favor intente nuevamente',
    'U499' => 'El password actual no puede ser igual al nuevo.',
    'U505' => 'Sus datos censales est&aacute;n desactualizados, debe actualizarlos.',
    'U507' => 'No se permite actualizar los datos censales, dir&iacute;jase a la biblioteca. ',
    'U600' => 'Se ha enviado un e-mail con las instrucciones para que pueda reestablecer su acceso a MERAN.',
    'U601' => 'Los datos ingresados no han sido encontrados en nuestros registros. Int&eacute;ntelo nuevamente.',
    'U602' => 'Imposible reestablecer la clave. El enlace ha vencido.',
    'U603' => 'La clave ha sido cambiada satisfactoriamente.',
    'U604' => 'Las claves no concuerdan.',
    'U605' => 'Compruebe el texto de verificaci&oacute;n.',
    'U606' => 'Hubo un problema en el proceso de restablecer su clave. Int&eacute;ntelo de nuevo. Si el problema persiste, dir&iacute;jase a la biblioteca.',
    'U607' => 'Para operar en el cat&aacute;logo p&uacute;blico, debe iniciar sesi&oacute; nuevamente. Disculpe las molestias.',
    'U608' => 'El mensaje de contacto ha sido enviado. En breve sera respondido por el personal de la biblioteca.',
    'U609' => 'Muchas gracias, en breve el personal de la biblioteca revisar&aacute; el registro.',
    'F700' => 'Disculpe, no se pudo agregar el favorito, intente nuevamente.',
    'F701' => 'Se agrego el favorito con &eacute;xito',
    'F702' => 'Se elimin&oacute; el favorito con &eacute;xito',
    'F703' => 'Disculpe, no se pudo eliminar el favorito, intente nuevamente.',
    'RC00' => 'El detalle de la recomendacion fue eliminado con &eacute;xito',
    'RC01' => 'Disculpe, no se pudo eliminar el detalle, intente nuevamente.',
    'RC02' => 'La recomendacion fue eliminada con &eacute;xito',
    'RC03' => 'Disculpe, no se pudo eliminar la recomendacion, intente nuevamente.',
    'RC04' => 'La recomendacion ha sido enviada',
    'VA001' => 'Error de parametros, inconsistentes o faltantes, don\'t HACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
    'VA002' => 'Por favor, complete todos los datos requeridos e intente nuevamente. Gracias.',
    
    #Mensajes Upload Files
    'UP00' => 'Solo se permiten archivos del tipo ("*?*") [Fallo de extension]',
    'UP01' => 'Hay un error y el archivo no puede escribirse en el servidor',
    'UP02' => 'El archivo "*?*" ("*?*") se ha cargado correctamente',
    'UP03' => 'Ocurrio un error mientras se intentaba subir el archivo de la importaci&oacute;n',
    'UP04' => 'El nombre del archivo no tiene un formato correcto',
    'UP05' => 'Hay un error y el archivo no puede eliminarse del servidor',
    'UP06' => 'El archivo "*?*" se ha eliminado correctamente',
    'UP07' => 'El archivo excede el tama&ntilde;o m&aacute;ximo permitido (*?*)',
    'UP08' => 'El archivo se ha cargado correctamente',
    'UP09' => 'La portada se ha eliminado correctamente',
    'UP10' => 'La portada se ha modificado correctamente',
    'UP11' => 'La portada no se ha podido modificar',
    'UP12' => 'Ocurrio un error subiendo las imagenes',
    'UP13' => 'El tipo de archivo subido no esta permitido',
    'UP14' => 'El manejo de archivos no esta habilitado',
 
   #ERRORES DE BASE DE DATOS
    'B400' => 'Error al intentar reservar desde OPAC, funcion C4::AR::Reservas::reservarOPAC.',
    'B401' => '',
    'B402' => '',
    'B403' => '',
    'B404' => 'Error al cancelar una reserva desde OPAC, funcion C4::AR::Reservas::t_cancelar_reserva',
    'B405' => 'Error al intentar renovar desde OPAC, funcion C4::AR::Prestamos::t_renovarOPAC',
    'B406' => '',
    'B407' => 'Error al intentar carncelar y reservar desde OPAC, funcion C4::AR::Reservas::t_cancelar_y_reserva',
    'B408' => 'Error al intentar agregar un favorito desde OPAC, funcion C4::AR::BookShelves::t_addPrivateShelfs',
    'B409' => 'Error al intentar eliminar un favorito desde OPAC, funcion C4::AR::BookShelves::t_delPrivateShelfs',
    'B410' => 'Error al intentar agregar una recomendaci&oacute;n desde OPAC en funcion C4::AR::Recomendaciones::agregarRecomendacion',
    'B411' => 'Error en funcion C4::AR::Auth::t_operacionesDeOPAC',
    'B412' => 'Error en la funcion C4::AR::RecomendacionDetalle::eliminarDetalleRecomendacion',
    'B413' => 'Error en la funcion C4::AR::Recomendaciones::eliminarRecomendacion',

);

my %mensajesINTRA = (
    '000' => '',
    'CB001' => 'El formato de inventario para el tipo de documento (*?*) se ha acualizado.',
    'CB002' => '[ERROR] El formato de inventario para el tipo de documento (*?*) no se ha podido acualizar.',
    'CB003' => 'El formato de inventario para el tipo de documento (*?*) ha vuelto a su valor por defecto.',
    'R001' => 'El usuario lleg&oacute; al m&acute;ximo de reservas permitidas (*?*).',
    'R002' => 'El usuario ya tiene una reserva para el mismo tipo de prestamo ',
    'R003' => 'El usuario lleg&oacute; al m&acute;ximo de reservas en espera (*?*).',
    'R004' => 'No hay ejemplares libres para el prestamo, y no se pueden realizar reservas sobre un grupo desde intranet.',
    'R005' => 'No hay ejemplares libres para el prestamo, y se realizo una reserva sobre el grupo.',
    'R006' => 'No hay m&aacute;s ejemplares disponibles y no puede hacer m&aacute;s reservas porque lleg&oacute; el l&iacute;mite',
    'R007' => '',
    'R008' => '',
    'R009' => '',
    'R010' => 'Se produjo un error al intentar cancelar la reserva, repita la operaci&oacute;n',
    'R011' => 'Disculpe, no se pudo cancelar y reservar, intente nuevamente.',
    'R012' => 'Disculpe, no se pudo renovar, ha alcanzado el m&aacute;ximo posible.',
    'P100' => 'El usuario ya tiene un ejemplar prestado del mismo grupo y del mismo tipo de prestamo',
    'P101' => 'El usuario alcanzo la cantidad m&aacute;xima  de pr&eacute;stamos *?*, no se pudo prestar *?*',
    'P102' => 'Estamos fuera del horario de realizaci&oacute;n del pr&eacute;stamo especial.',
    'P103' => 'Se realizo el pr&eacute;stamo con exito del ejemplar *?*.',
    'P104' => 'No hay m&aacute;s ejemplares disponibles',
    'P105' => 'El usuario supera el n&uacute;mero m&aacute;ximo de ejemplares para ese tipo de pr&eacute;stamo.',
    'P106' => 'No se pudo realizar el pr&eacute;stamo, intentelo nuevamente.',
    'P107' => 'El documento esta prestado, seleccione otro c&oacute;digo de barra',
    'P108' => 'Pr&eacute;stamo realizado con &eacute;xito *?*, el usuario lleg&oacute; al m&aacute;ximo de pr&eacute;stamos, se le cancelaron todas las reservas',
    'P109' => 'El ejemplar con c&oacute;digo de barras *?* fue devuelto',
    'P110' => 'El ejemplar con c&oacute;digo de barras *?* no pudo ser devuelto',
    'P111' => 'El ejemplar con c&oacute;digo de barras *?* fue renovado',
    'P112' => 'El ejemplar con c&oacute;digo de barras *?* no pudo ser renovado',
    'P113' => 'Disculpe, no se pudo renovar el pr&eacute;stamo, intente nuevamente.',
    'P114' => 'Disculpe, no puede efectuar renovaciones porque usted no ha realizado a&uacute;n el curso para usuarios.',
    'P115' => 'El ejemplar con c&oacute;digo de barras *?* no existe o no se encuentra prestado',
    'P116' => 'El usuario ingresado no existe',
    'P117' => 'El ejemplar que intenta devolver no existe o fue devuelto anteriormente',
    'P118' => 'El ejemplar que intenta renovar esta vencido',
    'P119' => 'Renovaci&oacute;n fuera de fecha',
    'P120' => 'Disculpe, no se pudo renovar el pr&eacute;stamo, el grupo posee reservas.',
    'P121' => 'Disculpe, no se pudo eliminar el ejemplar *?*, se encuentra prestado.',
    'P122' => 'Disculpe, no se pudo eliminar el ejemplar *?*, se encuentra reservado.',
    'P123' => 'Disculpe, no se pudo eliminar el grupo (*?*), tiene al menos 1 ejemplar con reserva.',
    'P124' => 'Disculpe, no se pudo eliminar el grupo (*?*), tiene al menos 1 ejemplar con prestamo.',
    'P125' => 'Disculpe, no se pudo modificar el ejemplar *?*, se encuentra prestado.',
    'P126' => 'Disculpe, el ejemplar con c&oacute;digo de barras *?* se encuentra prestado.',
    'P127' => 'Disculpe, no se permiten realizar operaciones fuera del horario de apertura de la biblioteca.',
    'P128' => 'El ejemplar que se intenta prestar no est&aacute; disponible para pr&eacute;stamo.',
    'P129' => 'El usuario ya tiene un ejemplar prestado del mismo grupo',
    'P130' => 'El ejemplar que intenta prestar se encuentra asignado a otro usuario y no hay ning&uacute;n otro libre.',
    'P131' => 'Disculpe, no puede efectuar la renovación porque el usuario tiene ejemplar/es vencido/s.',
    'P132' => 'Disculpe, no se pudo eliminar el registro (*?*), tiene al menos 1 ejemplar con reserva.',
    'P133' => 'Disculpe, no se pudo eliminar el registro (*?*), tiene al menos 1 ejemplar con prestamo.',
    'S200' => 'El usuario no puede reservar porque esta sancionado hasta el *?*',
    'S201' => 'No es posible realizar el pr&eacute;stamo porque el usuario tiene una posible sanci&oacute;n pendiente.',
    'S202' => 'Se elimin&oacute; la sanci&oacute;n a *?*, *?* (*?*) con &eacute;xito.',
    'S203' => 'No se pudo eliminar la sanci&oacute;n a *?*, *?*, *?*.',
    'S204' => 'Disculpe, no puede efectuar el pr&eacute;stamo porque el usuario tiene un ejemplar vencido.',
    'S205' => 'No es posible realizar el pr&eacute;stamo porque el usuario tiene una sanci&oacute;n para ese tipo de pr&eacute;stamo hasta el *?*.',
    'S206' => 'El usuario est&aacute; sancionado.',
    'S207' => 'Fue aplicada correctamente la sanci&oacute;n manual.',
    'S208' => 'No pudo aplicarse la sanci&oacute;n manual.',
    'U300' => 'El usuario no puede reservar porque no es un alumno regular.',
    'U301' => 'El usuario no puede reservar porque no ha realizado a&uacute;n el curso para usuarios.',
    'U302' => 'El libro que acaba de reservar puede ser retirado hasta del d&iacute;a: *?* a las *?*',
    'U303' => 'En este momento no hay ejemplares disponibles para pr&eacute;stamo inmediato. 
                Cuando haya alg&uacute;n ejemplar a su disposici&oacute;n se le informar&aacute; a 
                <br><i> *?* </i><br>Verifique que sus datos sean correctos ya que el mensaje se enviar&aacute; a esta direcci&oacute;n.',
    'U304' => 'El usuario no hizo el curso de MERAN.',
    'U305' => 'Disculpe, no se pudo eliminar el item con c&oacute;digo de barras *?*, intente nuevamente.',
    'U306' => 'Disculpe, no se pudo eliminar el grupo *?*, intente nuevamente.',
    'U307' => 'Disculpe, no se pudo eliminar el registro *?*, intente nuevamente.',
    'U308' => 'Se cancel&oacute; la reserva con &eacute;xito.',
    'U308b' => 'La reserva no se puede cancelar debido a preferencias del sistema.',
    'U309' => 'Se elimin&oacute; el seud&oacute;nimo con &eacute;xito.',
    'U310' => 'Se elimin&oacute; el sin&oacute;nimo (*?*) con &eacute;xito.',
    'U311' => 'Usted ha ingresado un ID de usuario que ya existe. Por favor elija otro. userid: *?* Apellido: *?* Nombre: *?*',
    'U312' => 'Se realiz&oacute; el cambio de la password con &eacute;xito.',
    'U313' => 'Disculpe, no se pudo realizar el cambio de la password, intente nuevamente.',
    'U314' => 'Password en blanco, debe ingresar la password.',
    'U315' => 'Las passwords no coinciden, ingrese la password nuevamente.',
    'U316' => 'La password no respeta la longitud m&iacute;nima.',
    'U317' => 'Se cambiaron los permisos con &eacute;xito.',
    'U318' => 'La password no respeta la longitud m&iacute;nima de s&iacute;mbolos.',
    'U319' => 'Disculpe, no se pudo eliminar el usuario *?*, intente nuevamente.',
    'U320' => 'Se elimin&oacute; el usuario *?* con &eacute;xito.',
    'U321' => 'No existe el usuario *?*, intente nuevamente.',
    'U322' => 'Disculpe, no se pudo eliminar el usuario *?*, intente nuevamente.',
    'U323' => 'Se agreg&oacute; el usuario *?* con &eacute;xito.',
    'U324' => 'La password no respeta la longitud m&iacute;nima de car&aacute;cteres alfanum&eacute;ricos.',
    'U325' => 'La password no respeta la longitud m&iacute;nima de car&aacute;cteres alfab&eacute;ticos.',
    'U326' => 'La password no respeta la longitud m&iacute;nima de car&aacute;cteres num&eacute;ricos.',
    'U327' => 'La password no respeta la longitud m&iacute;nima de min&uacute;sculas.',
    'U328' => 'La password no respeta la longitud m&iacute;nima de may&uacute;sculas.',
    'U329' => 'Se agregr&oacute; el usuario con &eacute;xito.',
    'U330' => 'Disculpe, no se pudo agregar el usuario, intente nuevamente.',
    'U331' => 'Disculpe, no se pudo cambiar el permiso, intente nuevamente.',
    'U332' => 'Disculpe, la direcci&oacute;n de mail es inv&aacute;lida.',
    'U333' => 'El n&uacute;mero de tarjeta de indentificaci&oacute;n no puede estar en blanco.',
    'U334' => 'El apellido no puede estar en blanco.',
    'U335' => 'El nombre no puede estar en blanco.',
    'U336' => 'El n&uacute;mero de documento no puede estar en blanco, o no respeta el formato adecuado.',
    'U800' => 'El tipo de documento no puede estar en blanco.',
    'U337' => 'El nombre de la ciudad no puede estar en blanco.',
    'U338' => 'Se modificaron los datos del usuario correctamente.',
    'U339' => 'No se pudieron modificar los datos del usuario, intente nuevamente.',
    'U340' => 'Se subi&oacute; la foto con &eacute;xito.',
    'U341' => 'S&oacute;lo se permiten im&aacute;genes de tipo JPG,BMP,GIF o PNG.',
    'U342' => 'Hay un error y el archivo no puede escribirse en el servidor.',
    'U343' => 'El nombre del archivo no tiene un formato correcto',
    'U344' => 'La foto ha sido eliminada.',
    'U345' => 'No se pudo eliminar la foto.',
    'U346' => 'El usuario con tarjeta id: *?* ya se encuentra habilitado!!!',
    'U347' => 'El usuario con tarjeta id: *?* se ha habilit&oacute; con &eacute;xito',
    'U348' => 'Disculple, no se pudo hablitar el usurio, intente nuevamente',
    'U349' => 'El usuario con tarjeta id: *?* es IRREGULAR y no puede ser habilitado!!!',
    'U350' => 'El usuario con tarjeta id: *?* NO se encuentra habilitado!!!',
    'U351' => 'El usuario no se puede borrar ya que cuenta con prestamos activos y/o vencidos!!!',
    'U352' => 'El usuario no se puede borrar ya que es el mismo que est&aacute; activo en la sesi&oacute;n.',
    'U353' => 'El usuario solicitado no existe.',
    'U354' => 'Disculpe, usted no tiene permisos suficientes para acceder a esta p&aacute;gina.',
    'U355' => 'Disculpe, su sesi&oacute;n ha caducado. Por favor ingrese nuevamente.',
    'U356' => 'Esta accediendo a MERAN desde una direcci&oacute;n IP diferente! Por favor ingrese nuevamente.',
    'U357' => 'Ha ingresado un nombre de usuario o password incorrecto. Por favor intente nuevamente.',
    'U358' => 'Ud. ha cerrado su sesion. Gracias por usar MERAN.',
    'U359' => 'El password ha sido reseteado.',
    'U360' => 'El password NO ha sido reseteado, intentelo m&aacute;s tarde.',
    'U361' => 'El password actual NO coincide con el suyo.',
    'U362' => 'UD. no puede personalizar el password de otro usuario.',
    'U363' => 'El usuario con tarjeta id: *?* se ha deshabilit&oacute; con &eacute;xito',
    'U364' => 'Se agreg&oacute; la estructura de catalogaci&oacute;n con &eacute;xito',
    'U365' => 'Disculpe, no se pudo agregar la estructura de catalogaci&oacute;n, intente nuevamente',
    'U366' => 'Se modific&oacute; la estructura de catalogaci&oacute;n con &eacute;xito',
    'U367' => 'Disculpe, no se pudo modificar la estructura de catalogaci&oacute;n, intente nuevamente',
    'U368' => 'Se agreg&oacute; con &Eacute;xito el registro ( *?* )',
    'U369' => 'Se agreg&oacute; con &Eacute;xito el grupo ( *?* )',
    'U370' => 'Se agreg&oacute; con &Eacute;xito el ejemplar ( *?* )',
    'U371' => 'Disculpe, no se pudo agregar el registro, intente nuevamente',
    'U372' => 'Disculpe, no se pudo agregar el grupo, intente nuevamente',
    'U373' => 'Disculpe, no se pudo agregar el ejemplar, intente nuevamente',
    'U374' => 'Se elimin&oacute; con &Eacute;xito el registro ( *?* )',
    'U375' => 'Se elimin&oacute; con &Eacute;xito el grupo ( *?* )',
    'U376' => 'Se elimin&oacute; con &Eacute;xito el ejemplar ( *?* )',
    'U377' => 'Disculpe, no se pudo eliminar el registro ( *?* ), intente nuevamente',
    'U378' => 'Disculpe, no se pudo eliminar el grupo ( *?* ), intente nuevamente',
    'U379' => 'Disculpe, no se pudo eliminar el ejemplar ( *?* ), intente nuevamente',
    'U380' => 'Se modific&oacute; con &Eacute;xito el registro ( *?* )',
    'U381' => 'Se modific&oacute; con &Eacute;xito el grupo ( *?* )',
    'U382' => 'Se modific&oacute; con &Eacute;xito el ejemplar ( *?* )',
    'U383' => 'Disculpe, no se pudo modificar el registro ( *?* ), intente nuevamente',
    'U384' => 'Disculpe, no se pudo modificar el grupo ( *?* ), intente nuevamente',
    'U385' => 'Disculpe, no se pudo modificar el ejemplar ( *?* ), intente nuevamente',
    'U386' => 'Ya existe el barcode en el ejemplar ( *?* )',
    'U387' => 'El C&oacute;digo de Barras es obligatorio y no puede ser blanco',
    'U388' => 'El n&uacute;mero de documento pertenece a otro socio.',
    'U389' => 'Faltan par&aacute;metros necesarios para el funcionamiento de este m&oacute;dulo.',
    'U390' => 'Disculpe, no se pudo agregar el seud&oacute;nimo, intente nuevamente',
    'U391' => 'Disculpe, no se pudo agregar el sin&oacute;nimo, intente nuevamente',
    'U392' => 'Se agreg&oacute; con &Eacute;xito el seud&oacute;nimo',
    'U393' => 'Se agreg&oacute; con &Eacute;xito el sin&oacute;nimo',
    'U394' => 'Se actualiz&oacute; con &Eacute;xito el seud&oacute;nimo (*?*)',
    'U395' => 'Se actualiz&oacute; con &Eacute;xito el sin&oacute;nimo (*?*)',
    'U396' => 'Se elimin&oacute; correctamente el autorizado.',
    'U397' => 'Se carg&oacute; correctamente el autorizado.',
    'U398' => 'No se pudo realizar la modificaci&oacute;n del autorizado.',
    'U399' => 'UD. no puede dar de alta administradores de sistema.',
    'U400' => 'UD. acaba de cambiar la password, debe ingresar nuevamente.',
    'U401' => 'Disculpe, intent&oacute; loguearse de forma inadecuada.',
    'U402' => 'El barcode no cumple con el formato requerido.',
    'U403' => 'No existe el Grupo que se intenta modificar.',
    'U404' => 'No existe el registro que se intenta modificar.',
    'U405' => 'No está permitido agregar mas de *?* ejempales.',
    'U406' => 'La sesi&oacute;n ha sido eliminada, por favor, inicie sesi&oacute;n nuevamente. Disculpe las molestias.',
    'U407' => 'Se elimin&oacute; el nivel repetible (*?*) con &Eacute;xito.',
    'U408' => 'Disculpe, No se pudo eliminar el nivel repetible (*?*).',
    'U409' => 'No existe el Nivel Repetible que se intenta eliminar.',
    'U410' => 'Se agruparon los campos con &eacute;xito.',
    'U411' => 'Disculpe, No se pudieron agrupar los campos.',
    'U412' => 'Error en la estructura *?*.',
    'U413' => 'Se envi&oacute; el mail de prueba exitosamente a la cuenta (*?*).',
    'U414' => 'Error al intentar enviar el mail de prueba a la cuenta (*?*) <br/> (*?*).',
    'U415' => 'Se han verificado los datos censales del socio.',
    'U416' => 'No se han verificado los datos censales del socio, intentelo nuevamente.',
    'U417' => 'No se puede repetir la signatura topogr&aacute;fica, existe en otro registro.',
    'U418' => 'No se puede extender el libre deuda porque el usuario tiene reservas asignadas.',
    'U419' => 'No se puede extender el libre deuda porque el usuario tiene reservas en espera.',
    'U420' => 'No se puede extender el libre deuda porque el usuario tiene pr&eacute;stamos vencidos.',
    'U421' => 'No se puede extender el libre deuda porque el usuario tiene pr&eacute;stamos vigentes.',
    'U422' => 'No se puede extender el libre deuda porque el usuario se encuentra sancionado.',
    'U423' => 'Se puede imprimir el certificado de libre deuda para *?*. <br/> *?*',
    'U424' => 'No se puede deshabilitar el usuario porque tiene pr&eacute;stamos vigentes y/o vencidos.',
    'U425' => 'El valor ingresado en el Captcha es invalido, por favor intente nuevamente',

    'U426' => 'El mail ha sido enviado',
    'U427' => 'Ha ocurrido un error, el mail no ha sido enviado',
    'U428' => 'Disculpe, no se pudo modificar el ejemplar ( *?* ), ya que es el &uacute;nico ejemplar disponible para pr&eacute;stamo domiciliario y el mismo posee reservas ( *?* ).<br/>Cancele las reservas antes e intente nuevamente.',

    'U499' => 'El password actual no puede ser igual al nuevo.',

    'U500' => 'La tarjeda de identificaci&oacute;n ingresada (Nro. de socio) ya pertenece a otro usuario.',
    'U501' => 'El libro cuyo t&iacute;tulo y autor es:  *?* ya existe.  Desea agregar nuevos ejemplares al registro *?* ? ',
#     'U405' => 'No existe la estructura de catalogaci&oacute;n que se intentando recuperar.',
    'U502' => 'Los permisos del usuario (*?*) no se pudieron cambiar.',
    'U503' => 'Los permisos del usuario (*?*) se agregaron con &eacute;xito.',
    'U504' => 'Los permisos del usuario (*?*) no se pudieron agregar.',
    'U505' => 'Sus datos censales est&aacute;n desactualizados, debe actualizarlos.',
    'U506' => 'No se pudo realizar el pr&eacute;stamo. Los datos censales del usuario (*?*) deben ser actualizados.',
    'U507' => 'No se permite actualizar los datos censales desde la Intranet. Debe realizarce desde la sesión del Opac.',
    'U601' => 'Para operar en INTRANET, debe iniciar sesi&oacute;n nuevamente. Disculpe las molestias.',
    'U602' => 'La configuraci&oacute;n (campo, subcampo, tipo de ejemplar, nivel) (*?*, *?*, *?*, *?*) ya existe.',
    'U603' => 'Disculpe, error al intentar agregar la configuraci&oacute;n (campo, subcampo, tipo de ejemplar) (*?*, *?*, *?*).',
    'U604' => 'La configuraci&oacute;n (campo, subcampo, tipo de ejemplar) (*?*, *?*, *?*) se agreg&oacute; con &eacute;xito.',
    'U605' => 'La configuraci&oacute;n (campo, subcampo, tipo de ejemplar, nivel) (*?*, *?*, *?*, *?*) ya existe.',
    'U606' => 'Disculpe, error al intentar agregar la configuraci&oacute;n (campo, subcampo, perfil) (*?*, *?*, *?*).',
    'U607' => 'La configuraci&oacute;n (campo, subcampo, prefil) (*?*, *?*, *?*) se agreg&oacute; con &eacute;xito.',
    'U608' => 'Se elimin&oacute; con &eacute;xito la configuraci&oacute;n.',
    'U609' => 'Disculpe, no se pudo eliminar la configuraci&oacute;n.',
    'U610' => 'Se agreg&oacute; con &eacute;xito el &iacute;ndice',
    'U611' => 'Disculpe, no se pudo agregar el &iacute;ndice',
    'U612' => 'Se modifico el esquema correctamente',
    'U613' => 'Disculpe, error al intentar agregar la configuraci&oacute;n (campo, subcampo, perfil) (*?*, *?*, *?*). Esta configuraci&oacute;n ya existe',
    'U614' => 'No existe el registro que se intenta acceder.',
    'U615' => 'No existe configuraci&oacute;n para el cat&aacute;logo, para el nivel *?*, equema *?*',
    'U616' => 'No existe la anal&iacute;tica para el registro (*?*)',
    'U617' => 'Registro asociado con &eacute;xito!',
    'U618' => 'Disculpe, no se pudo asociar el registro',
    'U619' => 'Se elimin&oacute; la relaci&oacute;n de la anal&iacute;tica correctamente',
    'U620' => 'Se copi&oacute; la configuraci&oacute;n (campo, subcampo, tipo de ejemplar) (*?*, *?*, *?*) con &eacute;xito.',
    'U900' => 'El usuario ha sido eliminado del sistema.',
    'U982' => 'El mensaje ha sido eliminado.',
    'C500' => 'Los items fueron guardados correctamente.',
    'C501' => 'Se produjo un error al intentar guardar los datos del item, repita la operacion.',
    'C502' => 'Se produjo un error, el codigo de barra ingresado esta repetido. Vuelva a intentarlo',
    'CA601' => 'Se produjo un error al intentar agregar un sin&oacute;nimo, repita la operaci&oacute;n',
    'CA602' => 'Se produjo un error al intentar agregar un seud&oacute;nimo, repita la operaci&oacute;n',
    'CA603' => 'Se produjo un error al intentar eliminar un seud&oacute;nimo, repita la operaci&oacute;n',
    'CA604' => 'Se produjo un error al intentar eliminar un sin&oacute;nimo, repita la operaci&oacute;n',
    'CA605' => 'Se produjo un error al intentar actualizar un sin&oacute;nimo, repita la operaci&oacute;n',
    'CA900' => 'Los registros se han agregado al &iacute;ndice',
    'VO800' => 'Se agreg&oacute; con &eacute;xito el encabezado',
    'VO801' => 'Disculpe, no se pudo ingresar el Encabezado, intente nuevamente',
    'VO802' => 'Disculpe, no se pudo eliminar el Encabezado, intente nuevamente',
    'VO803' => 'Se elimin&oacute; el encabezado con &eacute;xito',
    'VO804' => 'Se elimin&oacute; la configuraci&oacute;n de visulizaci&oacute;n con &eacute;xito',
    'VO805' => 'Disculpe, no se pudo eliminar la configuraci&oacute;n de visualizaci&oacute;n, intente nuevamente',
    'VO806' => 'Se agreg&oacute; la configuraci&oacute;n de visulizaci&oacute;n con &eacute;xito',
    'VO807' => 'Disculpe, no se pudo agregar la configuraci&oacute;n de visualizaci&oacute;n, intente nuevamente',
    'VO808' => 'Se modific&oacute;ß la configuraci&oacute;n de visualizaci&oacute;n con &eacute;xito',
    'VO809' => 'Disculpe, no se pudo modificar la configuraci&oacute;n de visualizaci&oacute; intente nuevamente',
    'M901' => 'Se elimin&oacute; con &eacute;xito el item con c&oacute;digo de barras *?* .',
    'M902' => 'Se elimin&oacute; con &eacute;xito el grupo *?* .',
    'M903' => 'Se elimin&oacute; con &eacute;xito el Registro *?* .',
    'SP000' => 'Las preferencias han sido modificadas con &eacute;xito.',
    'SP001' => 'Se produjo un error al actualizar la preferencia.',
    'SP002' => 'Se produjo un error al guardar la preferencia.',
    'SP003' => 'La preferencia ha sido modificada con &eacute;xito.',
    'SP004' => 'La preferencia ha sido agregada al sistema con &eacute;xito.',
    'SP005' => 'La preferencia ya existe, no puede ser agregada.',
    'SP006' => 'El tipo de pr&eacute;stamo se elimin&oacute; con &eacute;xito.',
    'SP007' => 'El tipo de pr&eacute;stamo no pudo ser eliminado.',
    'SP008' => 'Se produjo un error al actualizar el tipo de pr&eacute;stamo.',
    'SP009' => 'Se produjo un error al guardar el tipo de pr&eacute;stamo.',
    'SP010' => 'El tipo de pr&eacute;stamo ha sido modificado con &eacute;xito.',
    'SP011' => 'El tipo de pr&eacute;stamo ha sido agregado al sistema con &eacute;xito.',
    'SP012' => 'El tipo de pr&eacute;stamo no pudo ser eliminado ya que se encuentra en uso por *?* pr&eacute;stamos.',
    'SP013' => 'Los tipos de prestamo sobre el cual se aplican las sanciones se actualizaron con &eacute;xito.',
    'SP014' => 'No se pudieron actualizar los tipos de prestamo sobre el cual se aplican las sanciones.',
    'SP015' => 'Se agrego una nueva regla de sanci&oacute;n.',
    'SP016' => 'No se pudo agregar la regla de sanci&oacute;n.',
    'SP017' => 'Se elimin&oacute; la regla de sanci&oacute;n.',
    'SP018' => 'No se pudo eliminar la regla de sanci&oacute;n.',
    'SP019' => 'La regla ya existe!!',
    'SP020' => 'Se creo la regla con &eacute;xito.',
    'SP021' => 'No se pudo agregar la regla.',
    'SP022' => 'La regla esta siendo utilizada *?* veces. No se puede eliminar.',
    'SP023' => 'Se elimin&oacute; la regla con &eacute;xito.',
    'SP024' => 'No se pudo eliminar la regla.',
    'UT001' => 'Se rompio Utilidades::from_json_ISO',
    'VA001' => 'Error de parametros, inconsistentes o faltantes, don\'t HACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
    'VA002' => 'Por favor, complete todos los datos requeridos e intente nuevamente. Gracias.',
    'E001' => 'No se pudo borrar el estante "*?*", ya que el mismo posee contenido.',
    'E002' => 'No se pudo borrar el estante "*?*", ya que el mismo posee subestantes.',
    'E003' => 'Se produjo un error al tratar de eliminar el estante "*?*" .',
    'E004' => 'El estante "*?*" se elimin&oacute; con &eacute;xito.',
    'E005' => 'Se produjo un error al tratar de eliminar el contenido del estante "*?*" .',
    'E006' => 'El contenido del estante se elimin&oacute; con &eacute;xito.',
    'E007' => 'El estante fue modificado con &eacute;xito a "*?*".',
    'E008' => 'Se produjo un error al tratar de modificar el estante "*?*" .',
    'E009' => 'No se pudo modificar el estante  ya que existe otro con el nombre "*?*".',
    'E010' => 'No se pudo agregar el estante  ya que existe otro con el nombre "*?*".',
    'E011' => 'El estante "*?*" fue agregado con &eacute;xito.',
    'E012' => 'Se produjo un error al tratar de agregar el estante "*?*" .',
    'E013' => 'Se produjo un error al tratar de agregar contenido al estante "*?*" .',
    'E014' => 'El contenido fue agregado con &eacute;xito al estante "*?*".',
    'E015' => 'Ya existe el contenido en el estante "*?*".',
    'E016' => 'El estante fue clonado con &eacute;xito a "*?*".',
    'E017' => 'Se produjo un error al tratar de clonar el estante "*?*" .',
    'E018' => 'Disculpe, no se pudo eliminar el grupo (*?*), se encuentra contenido en al menos 1 estante. Debe quitarlo del estante antes. En caso de no visualizarse el estante, es porque se trata de un estante virtual privado).',
    'REF0' => 'La referencia no se ha podido eliminar, verifique que no se est&eacute; usando.',
    'REF1' => 'La referencia ha sido eliminada correctamente.',
#   Mensajes de Adquisicion Proveedores y Presupuestos
    'A001' => 'El proveedor ha sido agregado exitosamente.',
    'A002' => 'El nombre del proveedor no puede estar en blanco.',
    'A003' => 'El mail debe ser v&aacute;lido.',
    'A004' => 'El domicilio del proveedor no puede estar en blanco.',
    'A005' => 'El telefono no puede contener car&aacute;cteres raros o estar en blanco.',
    'A006' => 'La informacion del proveedor fue guardada con &eacute;xito.',
    'A007' => 'El nombre del proveedor es inv&aacute;lido.',
    'A008' => 'El domicilio del proveedor es inv&aacute;lido.',
    'A009' => 'El apellido del proveedor es inv&aacute;lido.',
    'A010' => 'El apellido del proveedor no puede estar en blanco.',
    'A011' => 'La razon social del proveedor es inv&aacute;lida.',
    'A012' => 'La razon social del proveedor no puede estar en blanco.',
    'A013' => 'El CUIT/CUIL del proveedor es inv&aacute;lido.',
    'A014' => 'El CIUT/CUIL del proveedor no puede estar en blanco.',
    'A015' => 'El nro de documento del proveedor es inv&aacute;lido.',
    'A016' => 'El nro de documento del proveedor no puede estar en blanco.',
    'A017' => 'El pais es inv&aacute;lido.',
    'A018' => 'El pais no puede estar en blanco.',
    'A019' => 'La provincia es inv&aacute;lida.',
    'A020' => 'La provincia no puede estar en blanco.',
    'A021' => 'La ciudad es inv&aacute;lida.',
    'A022' => 'La ciudad no puede estar en blanco.',
    'A023' => 'La moneda fue agregada con &eacute;xtio.',
    'A024' => 'El proveedor fue eliminado con &eacute;xtio.',
    'A025' => 'El proveedor no pudo ser eliminado. Intente nuevamente.',
    'A026' => 'El n&uacute;mero de documento ingresado ya existe. Por favor ingrese otro.',
    'A027' => 'La informaci&oacute;n del presupuesto fue guardada con &eacute;xtio.',
    'A028' => 'Error en la funcion C4::AR::Presupuestos::actualizarPresupuesto.',
    'A029' => 'La cantidad de ejemplares ingresada es inv&aacute;lida.',
    'A030' => 'La cantidad de ejemplares no puede estar en blanco.',
    'A031' => 'El precio unitario ingresado es inv&aacute;lido.',
    'A032' => 'El precio unitario no puede estar en blanco.',
    'A033' => 'Pedido cotizaci&oacute;n generado con &eacute;xito.',
    'A034' => 'Recomendaci&oacute;n actualizada con &eacute;xito.',
    'A035' => 'Presupuesto generado con &eacute;xito.',
    'A036' => 'La exportaci&oacute;n se realiz&oacute correctamente.',
    'A037' => 'La exportaci&oacute;n no ha podido realizarse.',
    'A038' => 'Las monedas seleccionadas son inv&aacute;lidas.',
    'A039' => 'Las formas de envio seleccionadas son inv&aacute;lidas.',
    'A040' => 'Los materiales seleccionados son inv&aacute;lidos.',
    'A041' => 'El pedido de cotizaci&oacute;n fue agregado exitosamente.',
    'A042' => 'Alguno de los ejemplares seleccionados ya se encuentran dentro del Pedido de Cotizaci&oacute;n.',
    #mensajes de servidores z3950
    'S000' => 'Se agrego el servidor z3950 con &eacute;xito.',
    'S001' => 'Hubo un error cuando se intentaba agregar el servidor z3950.',
    'S002' => 'Se elimino el servidor z3950 con &eacute;xito.',
    'S003' => 'Hubo un error cuando se intentaba eliminar el servidor z3950.',
    'S004' => 'Se modifico el servidor z3950 con &eacute;xito.',
    'S005' => 'Hubo un error cuando se intentaba modificar el servidor z3950.',
    'S006' => 'Se deshabilit&oacute; el servidor z3950 con &eacute;xito.',
    'S007' => 'Hubo un error cuando se intentaba deshabilitar el servidor z3950.',
    'S008' => 'Por favor verifique que los datos ingresados sean correctos.',
    #mensajes visualizacion INTRA y OPAC
    'M000' => 'Se modifico el orden con &eacute;xito.',
    'M001' => 'Se eliminaron todas las visualizaciones del campo "*?*", nivel "*?*" y ejemplar "*?*" con &eacute;xito.',
    'M002' => 'Error al intentar eliminar las visualizaciones con campo "*?*" y nivel "*?*".',
    'M003' => 'Error en la funcion eliminarTodoElCampo.',
    'M004' => 'Se copi&oacute; toda la visualizaci&oacute;n del campo "*?*", nivel "*?*" y ejemplar "*?*" con &eacute;xito.',

    #Mensajes Social
    'SC000' => 'El mensaje ha sido publicado en Twitter',
    'SC001' => 'El mensaje no pudo ser publicado a causa del siguiente error: ',
    'SC002' => 'Se ha excedido en la cantidad de caracteres ingresados. El mensaje no ha sido publicado en Twitter ',
    'SC003' => 'No esta habilitada la preferencia para publicar en Twitter',
    'SC004' => 'Error de Twitter: *?*',

     #Metodos Auth
    'MA000' => 'El Metodo fue agregado exitosamente',
    'MA001' => 'El Metodo no pudo ser agregado',

    #Mensajes Recomendaciones
    'RC00' => 'El detalle de la recomendacion fue eliminado con &eacute;xito',
    'RC01' => 'Disculpe, no se pudo eliminar el detalle, intente nuevamente.',
    'RC02' => 'La recomendacion fue eliminada con &eacute;xito',

    #prestamos vencidos
    'PV00' => 'Se enviar&aacute;n los mails de pr&eacute;stamos vencidos a la brevedad',
    'PV01' => 'Ocurrio un error mientras se mandaban los mails de pr&eacute;stamos vencidos',

    #Mensajes Importaciones/Exportaciones
    'IO00' => 'La importaci&oacute;n fue eliminada con &eacute;xito',
    'IO01' => 'Ocurrio un error mientras se intentaba eliminar la importaci&oacute;n',
    'IO02' => 'El esquema "*?*" ya existe (o se agreg&oacute; un nuevo esquema y no se modific&oacute;)',
    'IO03' => 'El esquema se elimin&oacute; correctamente',
    'IO04' => 'Ocurrio un error mientras se intentaban leer los registros de la importaci&oacute;n',
    'IO05' => 'El esquema ha sido eliminado correctamente',
    'IO06' => 'El esquema no se ha podido eliminar.',
    'IO07' => 'El esquema solicitado no existe',
    'IO08' => 'Ocurrio un error mientras se intentaban guardar la  nueva importaci&oacute;n',
    'IO09' => 'Relaci&oacute;n Registro/Ejemplares aplicada con &eacute;xito',
    'IO10' => 'Ocurrio un error mientras se intentaban aplicar la relaci&oacute;n Registro/Ejemplares',
    'IO11' => 'Reglas de matcheo aplicadas con &eacute;xito, se encontraron "*?*" registros',
    'IO12' => 'Ocurrio un error mientras se intentaban aplicar las reglas de matcheo',
    'IO015' => 'El campo/subcampo ya existe en el esquema',
    'IO016' => 'El Campo "*?*" y Subcampo "*?*" se han agregado correctamente al esquema "*?*"',
    'IO017' => 'El Campo "*?*" fue movido a "*?*" por tener subcampos y no ser de control.',
    'IO018' => 'Se ha terminado de importar correctamente.',
    'IO019' => 'No se ha podido cancelar la importaci&oacute;n',
    'IO020' => 'La importaci&oacute;n ha sido cancelada',

    #importaciones XML
    'IXML00' => 'La importaci&oacute;n ha sido realizada correctamente',
    'IXML01' => 'El archivo importado no es v&aacute;lido',
    'IXML02' => 'Ocurri&oacute; un error mientras se insertaba en la base de datos la importaci&oacute;n',
    'IXML03' => 'Ocurri&oacute; un error mientras se realizaba la importaci&oacute;n',

    #Mensajes Upload Files
    'UP00' => 'Solo se permiten archivos del tipo ("*?*") [Fallo de extension]',
    'UP01' => 'Hay un error y el archivo no puede escribirse en el servidor',
    'UP02' => 'El archivo "*?*" ("*?*") se ha cargado correctamente',
    'UP03' => 'Ocurrio un error mientras se intentaba subir el archivo de la importaci&oacute;n',
    'UP04' => 'El nombre del archivo no tiene un formato correcto',
    'UP05' => 'Hay un error y el archivo no puede eliminarse del servidor',
    'UP06' => 'El archivo "*?*" se ha eliminado correctamente',
    'UP07' => 'El archivo excede el tama&ntilde;o m&aacute;ximo permitido ( "*?*" )',
    'UP08' => 'El archivo se ha cargado correctamente',
    'UP09' => 'La portada se ha eliminado correctamente',
    'UP10' => 'La portada se ha modificado correctamente',
    'UP11' => 'La portada no se ha podido modificar',
    'UP12' => 'Ocurrio un error subiendo las imagenes',
    'UP13' => 'El tipo de archivo subido no esta permitido',
    'UP14' => 'Ocurrio un error mientras se eliminaban las imagenes',
    'UP15' => 'El logo se ha eliminado correctamente',
    'UP16' => 'Ocurrio un error mientras se cargaban las imagenes',

    #servidores externos meran
    'SEM01' => 'El servidor fue agregado exitosamente',
    'SEM02' => 'El servidor no pudo ser guardado',
    'SEM03' => 'El servidor fue editado exitosamente',
    'SEM04' => 'El servidor fue eliminado exitosamente',
    'SEM05' => 'El servidor no pudo ser eliminado',

#ERRORES DE BASE DE DATOS
    'B400' => '',
    'B401' => 'Error al intentar prestar desde INTRA, funcion C4::AR::Reservas::t_realizarPrestamo.',
    'B402' => 'Error al intentar guardar un item desde INTRA, funcion C4::AR::Catalogacion::transaccion.',
    'B403' => 'Error al intentar guardar un item desde INTRA, funcion C4::AR::Catalogacion::transaccionNivel3.',
    'B404' => 'Error al cancelar una reserva desde INTRA, funcion C4::AR::Reservas::t_cancelar_reserva',
    'B405' => 'Error al intentar renovar desde la INTRA, funcion C4::AR::Prestamos::t_renovar',
    'B406' => 'Error al intentar devolver desde la INTRA, funcion C4::AR::Prestamos::t_devolver',
    'B407' => '',
    'B408' => 'Error en funcion C4::AR::Auth::t_operacionesDeOPAC',
    'B409' => 'Error en funcion C4::AR::Auth::t_operacionesDeINTRA',
    'B410' => 'Error en funcion C4::AR::VisualizacionOpac::t_insertarEncabezado',
    'B411' => 'Error en funcion C4::AR::VisualizacionOpac::t_deleteEncabezado',
    'B412' => 'Error en funcion C4::AR::Nivel3::t_deleteItem',
    'B413' => 'Error en funcion C4::AR::Nivel2::t_deleteGrupo',
    'B414' => 'Error en funcion C4::AR::Nivel1::t_deleteNivel1',
    'B415' => 'Error en funcion C4::AR::VisualizacionOpac::t_deleteEncabezado',
    'B416' => 'Error en funcion C4::AR::VisualizacionOpac::t_insertConfVisualizacion',
    'B417' => 'Error en funcion C4::AR::ControlAutoridades::t_eliminarSeudonimosAutor',
    'B418' => 'Error en funcion C4::AR::ControlAutoridades::t_eliminarSeudonimosTema',
    'B419' => 'Error en funcion C4::AR::ControlAutoridades::t_eliminarSeudonimosEditorial',
    'B420' => 'Error en funcion C4::AR::Usuarios::t_cambiarPassword',
    'B421' => 'Error en funcion C4::AR::Usuarios::t_cambiarPermisos',
    'B422' => 'Error en funcion C4::AR::Usuarios::t_eliminarUsuario',
    'B423' => 'Error en funcion C4::AR::Usuarios::habilitarPersona',
    'B424' => 'Error en funcion C4::AR::Usuarios::t_updateBorrower',
    'B425' => 'Error en funcion C4::AR::Usuarios::t_addPersons',
    'B426' => 'Error en funcion C4::AR::Catalogacion::t_guardarEnEstructuraCatalogacion',
    'B427' => 'Error en funcion C4::AR::Nivel1::t_guardarNivel1',
    'B428' => 'Error en funcion C4::AR::Nivel2::t_guardarNivel2',
    'B429' => 'Error en funcion C4::AR::Nivel3::t_guardarNivel3',
    'B430' => 'Error en funcion C4::AR::Nivel1::t_modificarNivel1',
    'B431' => 'Error en funcion C4::AR::Nivel2::t_modificarNivel2',
    'B432' => 'Error en funcion C4::AR::Nivel3::t_modificarNivel3',
    'B433' => 'Error en funcion C4::AR::Nivel1::t_eliminarNivel1',
    'B434' => 'Error en funcion C4::AR::Nivel2::t_eliminarNivel2',
    'B435' => 'Error en funcion C4::AR::Nivel3::t_eliminarNivel3',
    'B436' => 'Error en funcion C4::AR::VisualizacionOpac::t_insertConfVisualizacion',
    'B437' => 'Error en funcion C4::AR::ControlAutoridades::t_insertarSeudonimosAutor',
    'B438' => 'Error en funcion C4::AR::ControlAutoridades::t_insertarSeudonimosTema',
    'B439' => 'Error en funcion C4::AR::ControlAutoridades::t_insertarSeudonimosEditorial',
    'B440' => 'Error en funcion C4::AR::ControlAutoridades::t_eliminarSinonimosAutor',
    'B441' => 'Error en funcion C4::AR::ControlAutoridades::t_eliminarSinonimosTemas',
    'B442' => 'Error en funcion C4::AR::ControlAutoridades::t_eliminarSinonimosEditoriales',
    'B443' => 'Error en funcion C4::AR::ControlAutoridades::t_updateSinonimosAutores',
    'B444' => 'Error en funcion C4::AR::ControlAutoridades::t_updateSinonimosTemas',
    'B445' => 'Error en funcion C4::AR::ContR099rolAutoridades::t_updateSinonimosEditoriales',
    'B446' => 'Error en funcion C4::AR::VisualizacionOpac::t_updateConfVisualizacion',
    'B447' => 'Error en funcion C4::AR::Nivel1::t_eliminarNivel1Repetible',
    'B448' => 'Error en funcion C4::AR::Catalogacion::t_agruparCampos',
    'B449' => 'Error en la funcion C4::AR::Provedoores::agregarProveedor',
    'B450' => 'Error en funcion C4::AR::Catalogacion::_procesar_referencia',
    'B451' => 'Error en funcion C4::AR::Catalogacion::getDatoFromReferencia',
    'B452' => 'Error en funcion C4::AR::Permisos::actualizarPermisosGeneral',
    'B453' => 'Error en funcion C4::AR::ImportacionIsoMARC::eliminarImportacion',
    'B454' => 'Error en funcion C4::AR::UploadFile::uploadImport',
    'B455' => 'Error en funcion C4::AR::UploadFile::guardarRegistrosNuevaImportacion',
    'B456' => 'Error en funcion C4::AR::UploadFile::guardarRegistrosNuevaImportacion',
    'B457' => 'Error en funcion C4::AR::ImportacionIsoMARC::procesarRelacionRegistroEjemplares',
    'PERCENTAGE_VALUE' => "*?*",
    'B458' => 'Error en funcion C4::AR::ImportacionIsoMARC::procesarReglasMatcheo',
    'B459' => 'Error en funcion C4::Modelo::ImagenesNovedadesOpac SAVE',
    'B460' => 'Error en funcion C4::Preferencias::addSysExternoMeran SAVE',
    #caracter blanco en una busqueda AJA
    'B460' => 'Error en la palabra ingresada',
    'B461' => 'Error subiendo logos. Funcion C4::AR::Logos::uploadLogo',
    'B462' => 'Error subiendo logos. Funcion C4::AR::Logos::eliminarLogo',
    'B463' => 'Error aliminando la ayuda MARC. Funcion C4::AR::AyudaMarc::eliminarAyudaMarc',
    'B464' => 'Error en funcion C4::AR::Sanciones::aplicarSancionManualSocio',


    #mensajes ayuda marc
    'AM00' => 'La ayuda MARC ha sido guardada exitosamente',
    'AM01' => 'Error guardando la ayuda MARC',
    'AM02' => 'La ayuda MARC (campo, subcampo) (*?*, *?*) ya existe',
    'AM03' => 'La ayuda MARC fue eliminada con &eacute;xito',
    'AM04' => 'Error eliminando la ayuda MARC',

    'REV000' => 'La revisiones han sido eliminadas',
    'REV001' => 'La revisiones no han sido eliminadas, int&eacute;ntelo nuevamente.',
    'REV002' => 'La revisiones han sido aprobadas para su publicaci&oacute;n.',
    'REV003' => 'La revisiones no han sido aprobadas, int&eacute;ntelo nuevamente.',

    #tipo de documentos
    'TD000' => 'Error guardando la imagen del tipo de documento, int&eacute;ntelo nuevamente.',
    'TD001' => 'El tipo de documento ha sido guardado exitosamente',
    'TD002' => 'Error guardando el tipo de documento',
    'TD003' => 'No se puede eliminar el tipo de documento, ya que se encuentra referenciado',
    'TD004' => 'El tipo de documento fue eliminado con &eacute;xito',
    'TD005' => 'Ocurri&oacute; un error mientras se eliminaba el tipo de documento',
    'TD006' => 'Error guardando la imagen del tipo de documento. S&oacute;lo se permiten imagenes con extenci&oacute;n .png',

    #portadas nivel 2
    'POR00' => 'Error guardando la imagen de la portada, intentelo nuevamente.',
    'POR01' => 'Las imagenes fueron modificadas con exito',

    #novedades
    'NOV00' => 'La novedad fue guardada con &eacute;xito',

);

sub getMensaje {
    my($codigo,$tipo,$param)    = @_;
    my $msj                     = "";
    $tipo                       = lc($tipo);
    
    if($tipo eq 'opac'){
    
        $msj = $mensajesOPAC{$codigo};
        C4::AR::Debug::debug("mensaje de OPAC");
        
    }else{
    
        C4::AR::Debug::debug("mensaje de INTRA");
        $msj = $mensajesINTRA{$codigo};
    }

    my $p;

    foreach $p (@$param){
        $msj=~ s/\*\?\*/$p/o;
    }

    C4::AR::Debug::debug("C4::AR::Mensajes => getMensaje => tipo => ".$tipo);
    C4::AR::Debug::debug("C4::AR::Mensajes => getMensaje => codigo => ".$codigo);
    C4::AR::Debug::debug("C4::AR::Mensajes => getMensaje => mensaje => ".$msj);

    return $msj;
}

=item
Esta funcion se encarga de setear variables para los distintos pl que la invocan segun un codigo de error,
estas variables se setean para mostrar u ocultar cosas en los tmpls
=cut
sub getAccion {
    my($codigo,$tipo)=@_;
    my %acciones;

    if($codigo eq 'R001'){
        $acciones{'maximoReservas'}= 1;
#       $acciones{'materialEnEspera'}= 0;
    }

    if($codigo eq 'U302'){
        $acciones{'materialParaRetirar'}= 1;
    }

    if($codigo eq 'U303'){
        $acciones{'reservaGrupo'}= 1;
    }

    return \%acciones;
}

=item
printErrorDB
Esta funcion logea los bugs que ocurren cuando una transaccion no es ejecutada con exito.
Guarda los errores en el siguiente archivo: /var/log/koha/debugErrorDBA.txt
=cut


sub printErrorDB {
    my ($errorsDB_array,$codigo,$tipo)=@_;

    C4::AR::Debug::printErrorDB($errorsDB_array,$codigo,$tipo);
}



sub create {

    #se crea el objetos contenedor de mensajes
    my %msg_object;
    $msg_object{'error'}    = 0;
    $msg_object{'messages'} = [];
    my $session = CGI::Session->load();
 
    $session->{'msg_object'} = \%msg_object;
    
    $msg_object{'tipo'}     = $session->param('type')||'INTRA';

    return \%msg_object;
}

sub hayError {
    my($msg_object)=@_;

    if($msg_object->{'error'}){
        return 1;
    }else{
        return 0;
    }
}

sub getFirstCodeError {
    my($msg_object)=@_;

    return $msg_object->{'messages'}->[0]->{'codMsg'} || 0;
}


=item
    Esta funcion encodea el mensaje en utf8 para mostrar correctamente los acentos en el cliente
=cut
sub encodeUtf8Msj{

    my($hash) = @_;

    use Encode;

    foreach my $value (@$hash) {
        $value = encode("utf8",$value);
    }
}

#Esta funcion agrega un mensaje al arreglo de objetos mensajes
sub add {
    my($Message_hashref, $msg_hashref)=@_;
    #@param $Message_hashref es el objeto mensaje contenedor de los mensajes
    #@param $msg_hashref es un mensaje
    #se obtiene el texto del mensaje
#       my $messageString= &C4::AR::Mensajes::getMensaje($msg_hashref->{'codMsg'},$Message_hashref->{'tipo'},$msg_hashref->{'params'});
    my $session         = CGI::Session->load();
    my $tipo            = $msg_hashref->{'tipo'}||$session->param('type')||'INTRA';
    
    #encodeamos en utf8 para mostrar bien los acentros
    encodeUtf8Msj($msg_hashref->{'params'});

    my $messageString   = C4::AR::Mensajes::getMensaje($msg_hashref->{'codMsg'}, $tipo, $msg_hashref->{'params'});
    $msg_hashref->{'message'}= $messageString;
    $msg_hashref->{'codMsg'}= $msg_hashref->{'codMsg'};
# C4::AR::Debug::debug("Mensajes::add => message: ".$messageString."\n");
# C4::AR::Debug::debug("Mensajes::add => params: ".$msg_hashref->{'params'}->[0]."\n");

    push (@{$session->{'msg_object'}->{'messages'}}, $msg_hashref);
    
    push (@{$Message_hashref->{'messages'}}, $msg_hashref);
}

END { }       # module clean-up code here (global destructor)

1;
__END__

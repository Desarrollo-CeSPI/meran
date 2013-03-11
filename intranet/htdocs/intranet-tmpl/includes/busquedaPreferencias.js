/* Buscador de Preferencias de MERAN v0.1
 *
 * Funciones js para filtrar las preferencias.
 *
 * FIXME: por mas que cant sea 0, no siempre muestra el mensaje de 'preferencias no encontradas'
 */

(function ($) {

    //expresion css :Contains que lo hace case insensitive
    jQuery.expr[':'].Contains = function(a,i,m){
        return (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase())>=0;
    };

    function listFilter(){

        //foqueamos en el input
        $('#buscadorPreferencias').focus();

        //con escape limpiamos el input
        $('#buscadorPreferencias').keydown(function(evt) {
                if (evt.keyCode == 27) {
                        $('#buscadorPreferencias').val('');
                        $('#buscadorPreferencias').keyup();
                }
        });

        //var que cuenta la cantidad de preferencias mostradas
        var cant = 0;

        //aca se hace el filtrado
        $('#buscadorPreferencias').keyup(function(){

            var buscar = $(this).val();

            if (jQuery.trim(buscar) != '') {

                //ocultamos las que no machean y dejamos las que si
                $(".control-group:Contains('" + buscar + "')").fadeIn('slow');
                $(".control-group").not(":Contains('" + buscar + "')").fadeOut('normal', function() {
                    /* Lo hacemos como callback del fadeOut para que cuente bien los elementos ocultos */

                    //cuento la cantidad de elementos que se estan mostrando
                    cant = $('.control-group').filter(function() {
                        return $(this).css('display') !== 'none';
                    }).size();

                    //si es 0 ocultamos el .form-actions y mostramos el div de mensaje
                    if (cant == 0) {
                        $('.form-actions').hide();
                        $('#mensajePreferenciasNoEncontradas').show();
                    } 
                    else {
                        $('.form-actions').show();
                        $('#mensajePreferenciasNoEncontradas').hide();
                    }
                });

            } else {

                // mostramos todas las preferencias, esto es cuando buscar == 0
                $(".control-group").each(function(i, e){ 
                    $(this).fadeIn('slow');
                });

                //muestro el form de acciones y oculto el mensaje
                $('.form-actions').show();
                $('#mensajePreferenciasNoEncontradas').hide();
            }
        });
    }

    //ondomready
    $(function () {
        listFilter();
        $('#mensajePreferenciasNoEncontradas').hide();
    });

}(jQuery));
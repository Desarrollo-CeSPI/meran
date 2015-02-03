<script type="text/javascript" src="/intranet-tmpl/includes/adquisiciones/tabletojson.js"> </script>
<script type="text/javascript" src="/includes/jquery/jquery.nanoscroller.js"></script>
    
<script>


function exportarPDF(){
      $('#formSeleccionados').submit();
}

function seleccionarTr(trSelected){

         if (trSelected.is(':checked')){

                  id_tr = trSelected.val();
                  id_tr = id_tr + "_tr";
                  id1= trSelected.attr('id').substring(15);
                  id3= trSelected.val();
                  // trSelected.attr('checked', false);
                  // $('#' + id_tr).hide();
                  barcode= $('#barcode'+ trSelected.val()).html();
                  // $('#seleccionados').show();
                  $('#button-seleccionados').show();
                  $('#seleccionados').append("<div class='label label-info barcode-box' style='width:auto;' name='"+ id1  + "' id='label"+barcode+"'><input type='hidden' name='"+id3+"' value='"+id_tr+"'>" + barcode + "<span class='click' id='"+barcode+"'> X </span></div>");
              
                  

                  id_tabla= '#tablaResult'+ id1;

                  cant_visibles_tabla= $(id_tabla + ' tr:visible').length;
                 
                  // if (cant_visibles_tabla <= 1){
                  //         $('#grupo' + id1).hide();
                  // } else {
                  //         $('#grupo' + id1).show();
                  // }

                  $('.click').click( function (){  
                              labelClosed=$('#label'+ $(this).attr('id')).attr('name');
                              $('#grupo' + labelClosed).show();          
                              $('#' + $(this).parent().children(":input").val()).show();                    
                              $('#label'+ $(this).attr('id')).remove(); 
                              // if ($('#seleccionados').children().size() == 0){
                              //       $('#seleccionados').hide();
                              //       $('#button-seleccionados').hide();
                              // };
                                     
                  });
              } else {

                barcode = $('#barcode'+trSelected.val()).html();
                $('#label'+barcode).remove();
              }


}


function onSelectTr(){
      $('[type=checkbox]').change( function (){ 
                seleccionarTr($(this));
            }
        );
}
  
function checkedAllTrs(id,nombreCheckbox){

            $("#"+id).toggle(
                    function(){
                          $("input[name="+nombreCheckbox+"]").each(
                                  function(index){
                                      this.checked=true;
                                      if ($(this).is(':visible'))
                                        seleccionarTr($(this));
                                  }
                          )
                    },

                    function(){
                          $("input[name="+nombreCheckbox+"]").each(
                                  function(){
                                      this.checked=false;
                                      $(this).parent().parent().removeClass("marked");
                                      $(this).parent().parent().children().each(
                                                function(){
                                                    $(this).removeClass("marked");
                                                }
                                      );
                                  }
                            )

                          if($("input[name=checkEjemplares]").size() > 0){
                            $("#seleccionados").html("");
                          }
                    }
            );
}



$(document).ready(function(){
      // $('#button-seleccionados').hide();
});


</script>



[% IF cantidad %]
      <div class="well">
                    <!--<div class="resultados_consulta">[% "Ha buscado por" | i18n %]: <strong>[% HTML.escape(socio_busqueda) %]</strong></div> -->
              <div class="resultados_consulta">[% "La cantidad de resultados es" | i18n %]: <strong>[% cantidad %]</strong></div>
                      
      </div>
[% END %]
[% IF cantidad %]
<div class="contenedor_paginador">[% paginador %]</div> 
<div>        
              [% PERL %]
                print C4::AR::Filtros::tableHeader(   
                                  id              => "tablaResult",
                                  class           => "",
                                  selectAll_id    => "selectAll[% nivel3.nivel1.id1 %]",
                                  columns         => ['[% "Título" | i18n %]', '[% "Autor" | i18n %]', '[% "Codigo de Barra" | i18n %]','[% 'Signatura' | i18n %]', '[% "Estado" | i18n %]'               
                                                      ],
                            
                                  ) ;
              [% END %]

              <tbody>
    [% FOREACH SEARCH_RESULTS %]

                <tr id="[% nivel3.id %]_tr">
                        <td><label class="checkbox">
                                <input type="checkbox" value="[% nivel3.id %]" id="checkEjemplares[% nivel3.nivel2.nivel1.id1 %]" name="checkEjemplares[% nivel3.nivel2.nivel1.id1 %]">
                            </label>
                        </td> 
                        <td>
                        [% PERL %]
                            print C4::AR::Filtros::link_to( text    =>  "[% nivel3.nivel1.getTituloStringEscaped %]",
                                                            url     =>  "[% url_prefix %]/catalogacion/estructura/detalle.pl", 
                                                            params  =>  ["id1=[% nivel3.nivel1.getId1 %]"],
                                                            title   =>  "[% 'Mostrar Detalle del Registro' | i18n %]",
                                                            class   =>  "link_to_detail",
                                                            on_click=> "startOverlay();"

                                                        ) ;
                        [% END %]
                         <small> [% nivel3.nivel2.toString %] </small></td>
                        <td>[% nivel3.nivel1.getAutor %]</td>
                        <td id="barcode[% nivel3.id %]">[% nivel3.getBarcode %]</td>
                        <td id="signatura[% nivel3.id %]">[% nivel3.signatura %]</td>
                        <td id="estado[% nivel3.id %]">[% nivel3.getEstadoObject.getNombre %]</td> 
                </tr>

          [% END %]
              </tbody>
        </table>
        <script type="text/javascript">
        // NO SE VA A USAR
                    onSelectTr(); 
                    checkedAllTrs("selectAll"+ "[% nivel2.nivel1.id1 %]", "checkEjemplares"+"[% nivel2.nivel1.id1 %]");
                   
        </script>
    
</div>
<div class="form-actions"  id="button-seleccionados"> 
    [% PERL %]
                print C4::AR::Filtros::action_button( 
                                                button      => "btn btn-success",
                                                action      => "exportarPDF()",
                                                icon        => "icon-white icon-bookmark",
                                                title       => " [% 'Generar Etiquetas' | i18n %]"
                                            ) ;
            [% END %]
</div>
[% ELSE %]
      <div class="alert alert-info">No se han encontrado resultados.</div>
[% END %]
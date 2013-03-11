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
                  trSelected.attr('checked', false);
                  $('#' + id_tr).hide();
                  barcode= $('#barcode'+ trSelected.val()).html();
                  $('#seleccionados').show();
                  $('#button-seleccionados').show();
                  $('#seleccionados').append("<div class='label label-info barcode-box' style='width:auto;' name='"+ id1  + "' id='label"+barcode+"'><input type='hidden' name='"+id3+"' value='"+id_tr+"'>" + barcode + "<span class='click' id='"+barcode+"'> X </span></div>");
              
                  

                  id_tabla= '#tablaResult'+ id1;

                  cant_visibles_tabla= $(id_tabla + ' tr:visible').length;
                 
                  if (cant_visibles_tabla <= 1){
                          $('#grupo' + id1).hide();
                  } else {
                          $('#grupo' + id1).show();
                  }

                  $('.click').click( function (){  
                              labelClosed=$('#label'+ $(this).attr('id')).attr('name');
                              $('#grupo' + labelClosed).show();          
                              $('#' + $(this).parent().children(":input").val()).show();                    
                              $('#label'+ $(this).attr('id')).remove(); 
                              if ($('#seleccionados').children().size() == 0){
                                    $('#seleccionados').hide();
                                    $('#button-seleccionados').hide();
                              };
                                     
                  });
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
                    }
            );
}



$(document).ready(function(){
      $('#button-seleccionados').hide();
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
          [% FOREACH SEARCH_RESULTS %]
          <div id="grupo[% nivel1.id1 %]">  
                    <div class="page-header">
                          <h3>[% nivel1.titulo %] <small> ([% nivel1.nomCompleto %]) </small> </h3>
                    </div>    
                    [% IF nivel3.size > 0 %]                         
                        [% PERL %]
                          print C4::AR::Filtros::tableHeader(   
                                            id              => "tablaResult[% nivel1.id1 %]",
                                            class           => "",
                                            selectAll_id    => "selectAll[% nivel1.id1 %]",
                                            columns         => ['[% "Codigo de Barra" | i18n %]','[% 'Signatura' | i18n %]',
                                                                '[% "Estado" | i18n %]'               
                                                                ],
                                      
                                            ) ;
                        [% END %]
                        <tbody>
                 
                                 [% FOREACH n3 IN nivel3 %]
                                      <tr id="[% n3.id %]_tr">
                                              <td><label class="checkbox">
                                                      <input type="checkbox" value="[% n3.id %]" id="checkEjemplares[% nivel1.id1 %]" name="checkEjemplares[% nivel1.id1 %]">
                                                  </label>
                                              </td> 
                                              <td id="barcode[% n3.id %]">[% n3.getBarcode %]</td>
                                              <td id="signatura[% n3.id %]">[% n3.signatura %]</td>
                                              <td id="estado[% n3.id %]">[% n3.getEstadoObject.getNombre %]</td> 
                                      </tr>
                                      
                               [% END %]

                          </tbody>
                    [% ELSE %]
                          <div class="alert alert-info">Esta edicion no tiene ejemplares</div>
                    [% END %]
                    </table>
                  </div>  
                <script type="text/javascript">
                            onSelectTr(); 
                            checkedAllTrs("selectAll"+ "[% nivel1.id1 %]", "checkEjemplares"+"[% nivel1.id1 %]");
                           
                </script>
               
          [% END %]
    
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
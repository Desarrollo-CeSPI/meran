
<fieldset id="datos_material" > <legend class="titulo_legend trigger click">[% "Datos del material" %]</legend>
      [%  IF cant_ejemplares_disp > 0 %]
                      <div id="cant_ejemplares_disp" style="border: 1px solid #A0D651; background-color: #E3F6CE; color:#505050; padding:10px 0 0 0; margin: 0 0 10px 0">
                                    <p>[% 'La biblioteca cuenta con ' | i18n %]<strong>[% cant_ejemplares_disp %]</strong>[% ' ejemplar/es de este tipo, si aun considera necesaria esta recomendacion, complete el formulario, de lo contrario realice otra busqueda' | i18n %] </p>
                      </div> 
      [% END  %] 
      <form id="recom_form" name="recom_form" method="post" onsubmit="return false;">     
        <div class="datos_edicion" id="datos_edicion"> 
                  
                  <p><label for="autor" class="left">[% 'Autor*' | i18n %]:</label>
                            <input type="text" class="required" name="autor" id="autor" class="field" value="[% datos_nivel1.getAutor %]" tabindex="10" /></p>
                  <p><label for="titulo" class="left">[% 'T&iacute;tulo*' | i18n %]:</label>
                            <input type="text" class="required" name="titulo" id="titulo" class="field" value="[% datos_nivel1.getTitulo %]" tabindex="10" /></p>
                   <p><label for="edicion" class="left">[% 'Edici&oacute;n*' | i18n %]:</label>
                            <input type="text" class="required" name="edicion" id="edicion" class="field" value="[% edicion %]" tabindex="10" /></p>
                  <p><label for="lugar_publicacion" class="left">[% 'Lugar de Publicaci&oacute;n*' | i18n %]:</label>
                            <input type="text"  name="lugar_publicacion" id="lugar_publicacion" class="field" value="[% datos_edicion.getCiudadObject.getNombre %]" tabindex="10"/></p>     
                  <p><label for="editorial" class="left">[% 'Editorial*' | i18n %]:</label>
                            <input type="text" class="required" name="editorial" id="editorial" class="field" value="[% datos_edicion.getEditor %]" tabindex="10" /></p>
                  <p><label for="fecha" class="left">[% 'Fecha*' | i18n %]:</label>
                            <input type="text"  name="fecha" id="fecha" class="field" value="[% datos_edicion.getAnio_publicacion %]" tabindex="10" /></p>
                 <!-- <p><label for="coleccion" class="left">[% 'Colecci&oacute;n*' | i18n %]:</label>
                      <input type="text" name="coleccion" id="coleccion" class="field" value="" tabindex="10" READONL/></p>-->
                  <p><label for="isbn_issn" class="left">[% 'ISBN/ISSN' | i18n %]:</label>
                    [% IF datos_edicion.getISBN %]
                            <input type="text" name="isbn_issn" id="isbn_issn" class="field" value="[% datos_edicion.getISBN %]" tabindex="10" /></p>
                    [% ELSE %]
                            <input type="text" name="isbn_issn" id="isbn_issn" class="field" value="[% datos_edicion.getISSN %]" tabindex="10" /></p>
                    [% END %]
                  <p><label for="cant_ejemplares" class="left">[% 'Cantidad de Ejemplares*' | i18n %]:</label>
                            <input type="number" class="required" name="cant_ejemplares" id="cant_ejemplares" class="field" value="" tabindex="10" /></p>
                 
                  <p><label for="motivo_propuesta" class="left">[% 'Motivo de la Propuesta*' | i18n %]:</label>
                     <textarea name="motivo_propuesta" id="motivo_propuesta" cols="45" class="required" rows="10" tabindex="17"></textarea></p>
                  <p><label for="comment" class="left">[% 'Comentarios' | i18n %]:</label>
                     <textarea name="comment" id="comment"  cols="45" rows="10" tabindex="17"></textarea></p>
<!--                      <p><input type="submit" name="submit" id="submit" class="button" value="[% 'Enviar Mensaje' | i18n %]" tabindex="18" /></p> -->
                       <!-- <input type="hidden" name="post_message" id="post_message" value="1"/>-->
                 
                  


<!--        VER COMO MANDAR EL ID DE LA RECOMENDACION CREADA PARA PASARSELO A LOS RENGLONES SIGUIENTES            -->
               
                 

                  <p><input type="button" onClick="guardarDetalle()" value="[% 'Agregar ejemplar' | i18n %]" tabindex="6" /> </p>  
                  [% PERL %]
                          print C4::AR::Filtros::setHelp(text => "[% 'Los campos marcados con * son obligatorios' | i18n %]",
                                        );
                  [% END %]
                  
                  
        </div>  
   </form>
</fieldset>
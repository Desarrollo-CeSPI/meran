
             [% IF recomendacion.getLugarPublicacion %]
                  <p>[% "Lugar Publicacion: "| i18n %]<span>[%  recomendacion.getLugarPublicacion %]</span></p>    
             [% ELSE %] 
                  <p>[% "Lugar Publicacion: "| i18n %] <span>No especificado </span></p>  
             [% END %]
             [% IF recomendacion.getFechaPublicacion %]
                  <p>[% "Fecha Publicacion: "| i18n %]<span>[%  recomendacion.getFechaPublicacion %]</span></p>    
             [% ELSE %] 
                  <p>[% "Fecha Publicacion: "| i18n %]<span> No especificado</span> </p>  
             [% END %]

             [% IF recomendacion.getColeccion %]
                  <p>[% "Coleccion: "| i18n %]<span>[%  recomendacion.getColeccion %]</span></p>    
             [% ELSE %] 
                  <p>[% "Coleccion: "| i18n %]<span> No especificado </span></p>  
             [% END %]

             [% IF  recomendacion.getIsbnIssn %]
                  <p>[% "ISBN/ISSN: "| i18n %]<span>[%  recomendacion.getIsbnIssn  %]</span></p>    
             [% ELSE %] 
                  <p>[% "ISBN/ISSN: "| i18n %]<span> No especificado</span> </p>  
             [% END %]
             [% IF recomendacion.getCantidadEjemplares %]
                  <p>[% "Cantidad Ejemplares: "| i18n %]<span>[%  recomendacion.getCantidadEjemplares %]</span></p>    
             [% ELSE %] 
                  <p>[% "Cantidad Ejemplares: "| i18n %]<span> No especificado </span></p>  
             [% END %]
             [% IF recomendacion.getMotivoPropuesta  %]
                  <p>[% "Motivo Propuesta: "| i18n %]<span>[%  recomendacion.getMotivoPropuesta  %]</span></p>    
             [% ELSE %] 
                  <p>[% "Motivo Propuesta:  "| i18n %]<span> No especificado</span> </p>  
             [% END %]
             [% IF recomendacion.getComentario   %]
                        <p>[% "Comentario: " | i18n %]<span>[% recomendacion.getComentario %]</span></p>   
             [% ELSE %] 
                        <p>[% "Comentario:  "| i18n %]<span>No especificado </span></p>  
             [% END %]
             [% IF recomendacion.getReservaMaterial == 0%]
                  <p>[% "Reserva Material: " | i18n %]<span> No </span></p> 
             [% ELSE %] 
                  <p>[% "Reserva Material: " | i18n %]<span>Si </span></p> 
             [% END %]
   

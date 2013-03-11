<script type="text/javascript" src="/intranet-tmpl/includes/reports.js"></script>
<script>
	$(document).ready( function(){ 
	    $(".cb-enable").click(function(){
	        var parent = $(this).parents('.switch');
	        $('.cb-disable',parent).removeClass('selected');
	        $(this).addClass('selected');
	        $('.checkbox',parent).attr('checked', true);
	    });
	    $(".cb-disable").click(function(){
	        var parent = $(this).parents('.switch');
	        $('.cb-enable',parent).removeClass('selected');
	        $(this).addClass('selected');
	        $('.checkbox',parent).attr('checked', false);
	    });
	});
		
</script>

<div class="center_fieldset report_form_container">
      <form class="form-horizontal" onsubmit="generarEtiquetas('report_result_cards'); return false;">
          <div class="control-group">
            <label class="control-label"  for="name">Partel del nombre/apellido</label>
            <div class="controls">
              <input class="xlarge" id="name" name="name" size="30" type="text">
              <p class="help-block">Perez juan, etc.</p>
            </div>
          </div><!-- /control-group -->
          <div class="control-group">
            <label class="control-label"  for="user_category">Categoría del usuario</label>
            <div class="controls">
              <select name="user_category" id="user_category">
                <option>Docente</option>
                <option>No docente</option>
                <option>Alumno</option>
                <option>Bibliotecario</option>
                <option>Cocinero</option>
              </select>
            </div>
          </div><!-- /control-group -->

          <div class="control-group">
            <label class="control-label" for="sorty_by">Ordenar por</label>
            <div class="controls">
              <select name="sorty_by" id="sorty_by">
                <option>Apellido</option>
                <option>Fecha de alta</option>
                <option>Legajo</option>
                <option>DNI</option>
              </select>
            </div>
          </div><!-- /control-group -->

		  <div class="control-group">
				<label class="control-label"  for="statistics_check">Generar estadisticas</label>
				<div class="controls">
					<input type="checkbox" name="statistics_check" id=""statistics_check"" />
				</div>
		  </div>

          <div class="form-actions">
            <input type="submit" class="btn btn-primary" value="Consultar">
          </div>
      </form>
 </div>
 
<div id="report_result_cards" style="display:none;"></div>
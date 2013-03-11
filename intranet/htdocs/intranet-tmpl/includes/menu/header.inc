<script type="text/javascript">
   var placeholder='[% "Buscar en el cat&aacute;logo" | i18n %]'
</script>

<script type="text/javascript" src="/intranet-tmpl/includes/busquedasCatalogo-min.js"> </script>
<script type="text/javascript" src="/intranet-tmpl/includes/busquedasUsuarios-min.js"></script>

<script type="text/javascript"> 

function socioSearchEvent(event){
    if(event.keyCode==13)
        consultarBar();
}

    $(document).ready(function() {
    
      onEnter('keyword-bar',buscarBar,true);

      //onEnter('socio-bar',consultarBar);

      
      $('[placeholder]').focus(function() {
    	  var input = $(this);
    	  if (input.val() == input.attr('placeholder')) {
    	    input.val('');
    	    input.removeClass('placeholder');
    	  }
    	}).blur(function() {
    	  var input = $(this);
    	  if (input.val() == '' || input.val() == input.attr('placeholder')) {
    	    input.addClass('placeholder');
    	    input.val(input.attr('placeholder'));
    	  }
    	}).blur().parents('form').submit(function() {
    	  $(this).find('[placeholder]').each(function() {
    	    var input = $(this);
    	    if (input.val() == input.attr('placeholder')) {
    	      input.val('');
    	    }
    	  })
    	});      
      
    });

</script>



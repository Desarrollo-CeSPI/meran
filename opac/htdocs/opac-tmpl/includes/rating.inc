<script type="text/javascript">
$(document).ready(function() {

	$('#rating_[% id2 %]').raty({
		  cancel    : true,
		  cancelOff : 'cancel-off-big.png',
		  cancelOn  : 'cancel-on-big.png',
		  half      : true,
		  size      : 24,
		  starHalf  : 'star-half-big.png',
		  starOff   : 'star-off-big.png',
		  starOn    : 'star-on-big.png',
		  score		: [% rating %],


		[% IF !socio_data.usr_nro_socio %]
		  readOnly: true,
		[% END %]		  


		click       : function(score, evt) {

		    $.ajax({
		        url: '[% url_prefix %]/rating.pl',
		        data: {rate: score, id2: [% id2 %]}, 
		        type: 'POST',
		        success: function (data) {
	                $("#ajax_response[% id2 %]").html(data);
	                $("#ajax_response[% id2 %]").show();
		
		        },
		        error: function (jxhr, msg, err) {
		            $('#response').append('<li style="color:red">' + msg + '</li>');
		        }
		    });


  		}
	});

		


});
</script>

<div id="rating_form_[% id2 %]" class="well">
    <h4>[% "Valoraci&oacute;n" | i18n %]</h4>

	<div id="rating_[% id2 %]"></div>

    <br style="clear:both" />

    <span class="label label-success" id="ajax_response[% id2 %]" style="display:none;"></span>

	[% PERL %]
	    print C4::AR::Filtros::action_link_button(
	                                    url     => "reviews.pl", 
	                                    button	=> "btn btn-info",
	                                    params  => ["id2=[% id2 %]"],
	                                    title   => " [% 'Comentarios' | i18n %] ([% cant_reviews %])",
	                                    icon	=> "icon-white icon-comment",
	                                ) ;
	[% END %]

</div>

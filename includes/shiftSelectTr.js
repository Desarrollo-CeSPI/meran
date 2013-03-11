(function($) {
	$.fn.shiftClick = function() {
		var lastSelected;
		var tr = $(this);
		this.each(function() {
			$(this).click(function(ev) {
				if (ev.shiftKey) {
					var last    = tr.index(lastSelected);
					var first   = tr.index(this);
					var start   = Math.min(first, last);
					var end     = Math.max(first, last);
					var chk     = lastSelected.childNodes[1].childNodes[1].checked;
                    var clase;
                    var claseOriginal;
					for (var i = start; i < end; i++) {
						tr[i].childNodes[1].childNodes[1].checked = chk;
                        if(chk == false){         
                            tr[i].setAttribute('class', '');
                        }else{ 
                            tr[i].setAttribute('class', ' marked');
                        }
					}
				} else {
					lastSelected = this;
				}
			})
		});
	};
})(jQuery);

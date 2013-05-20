/*
 * Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
 * Circulation and User's Management. It's written in Perl, and uses Apache2
 * Web-Server, MySQL database and Sphinx 2 indexing.
 * Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
 *
 * This file is part of Meran.
 *
 * Meran is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Meran is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Meran.  If not, see <http://www.gnu.org/licenses/>.
 */

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

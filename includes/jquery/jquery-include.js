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

/*
 * by Petko D. Petkov; pdp (architect)
 * http://www.gnucitizen.org
 * http://www.gnucitizen.org/projects/jquery-include/
 */
jQuery.extend({
	/*
	 * included scripts
	 */
	includedScripts: {},

	/*
	 * include timer
	 */
	includeTimer: null,

	/*
	 * include
	 */
	include: function (url, onload) {
		if (jQuery.includedScripts[url] != undefined) {
			return;
		}

		jQuery.isReady = false;

		if (jQuery.readyList == null) {
			jQuery.readyList = [];
		}

		var script = document.createElement('script');

		script.type = 'text/javascript';
		script.onload = function () {
			jQuery.includedScripts[url] = true;

			if (typeof onload == 'function') {
				onload.apply(jQuery(script), arguments);
			}
		};
		script.onreadystatechange = function () {
			if (script.readyState == 'complete') {
				jQuery.includedScripts[url] = true;

				if (typeof onload == 'function') {
					onload.apply(jQuery(script), arguments);
				}
			}
		};
		script.src = url;

		jQuery.includedScripts[url] = false;
		document.getElementsByTagName('head')[0].appendChild(script);

		if (!jQuery.includeTimer) {
			jQuery.includeTimer = window.setInterval(function () {
				jQuery.ready();
			}, 10);
		}
	}
});

/*
 * replacement of jQuery.ready
 */
jQuery.extend({
	/*
	 * hijack jQuery.ready
	 */
	_ready: jQuery.ready,

	/*
	 * jQuery.ready replacement
	 */
	ready: function () {
		isReady = true;

		for (var script in jQuery.includedScripts) {
			if (jQuery.includedScripts[script] == false) {
				isReady = false;
				break;
			}
		}

		if (isReady) {
			window.clearInterval(jQuery.includeTimer);
			jQuery._ready.apply(jQuery, arguments);
		}
	}
});

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

define(['jquery', 'jqueryui'], function($) {
	'use strict';
	var Utils = {
		makeButton: function(button, props, hasMenu) {
			button.button({
				label: Utils.makeButtonLabel(props),
				text: !!(props.text || props.html),
				icons: {
					primary: props.icon || (props.iconUrl && 'aloha-ui-inline-icon-container') || null,
					secondary: (hasMenu && 'aloha-jqueryui-icon ui-icon-triangle-1-s') || null
				}
			});
			if (props.iconUrl) {
				button.button('widget')
					  .children('.ui-button-icon-primary')
					  .append(Utils.makeButtonIconFromUrl(props.iconUrl));
			}
			return button;
		},
		makeButtonLabel: function(props) {
			// TODO text should be escaped
			return props.html || props.text || props.tooltip;
		},
		makeButtonLabelWithIcon: function(props) {
			var label = Utils.makeButtonLabel(props);
			if (props.iconUrl) {
				label = Utils.makeButtonIconFromUrl(props.iconUrl) + label;
			}
			return label;
		},
		makeButtonIconFromUrl: function(iconUrl) {
			return '<img class="aloha-ui-inline-icon" src="' + iconUrl + '">';
		},
		makeButtonElement: function(attr){
			// Set type to button to avoid problems with IE which
			// considers buttons to be of type submit by default. One
			// problem that occurd was that hitting enter inside a
			// text-input caused a click event in the button right next
			// to it.
			return $('<button>', attr).attr('type', 'button');
		}
	};
	return Utils;
});

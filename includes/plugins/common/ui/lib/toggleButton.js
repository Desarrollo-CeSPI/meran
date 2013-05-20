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

define([
	'jquery',
	'ui/button',
	'jqueryui'
],
function( jQuery, Button ) {
	'use strict';

	var idCounter = 0;

	/**
	 * ToggleButton control. Extends the Button component type to provide an
	 * easy way to create buttons that can transition between "checked" and
	 * "unchecked" states.
	 *
	 * @class
	 * @name ToggleButton
	 * @extends {Button}
	 */
	var ToggleButton = Button.extend({

		_checked: false,

		/**
		 * Sets the state of the toggleButton and updates its visual display
		 * accordingly.
		 *
		 * @param {boolean} toggled Whether the button is to be set to the
		 *                          "toggled/checked" state.
		 */
		setState: function( toggled ) {
			// It is very common to set the button state on every
			// selection change even if the state hasn't changed.
			// Profiling showed that this is very inefficient.
			if (this._checked === toggled) {
				return;
			}
			this._checked = toggled;
			if (toggled) {
				this.element.addClass("aloha-button-active");
			} else {
				this.element.removeClass("aloha-button-active");
			}
		},

		getState: function() {
			return this._checked;
		},

		_onClick: function() {
			this.setState( ! this._checked );
			this.click();
		}
	});

	return ToggleButton;
});

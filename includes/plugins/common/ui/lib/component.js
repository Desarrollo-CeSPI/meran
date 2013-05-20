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
	'aloha/core',
	'jquery',
	'util/class'
], function (
	Aloha,
	$,
	Class
) {
	'use strict';

	var idCounter = 0;

	/**
	 * Component class and manager.
	 *
	 * This implementation constitues the base of all UI components (buttons,
	 * and labels).  The `Component' constructor object, with its static
	 * properties and functions, manages all components instances.
	 *
	 * @class
	 * @base
	 */
	var Component = Class.extend({

		id: 0,

		/**
		 * Flag to indicate that this is an instance of a component and  not the class object.
		 */
		isInstance: true,

		/**
		 * The Container instance or null if this component was not
		 * adopted by a counter by calling Component.adopt().
		 */
		container: null,

		/**
		 * Will be set in Component.define()
		 */
		type: null,

		/**
		 * @type {boolean} Whether or not this component is visible.
		 */
		visible: true,

		/**
		 * The type property is set in Component.define(), so components should only ever be instantiated through define.
		 * @constructor
		 */
		_constructor: function () {
			this.id = idCounter++;
			this.init();
		},

		adoptParent: function (container) {
			this.container = container;
		},

		/**
		 * Initializes this component.  To be implemented in subclasses.
		 */
		init: function () {},

		isVisible: function () {
			return this.visible;
		},

		/**
		 * Shows this component.
		 */
		show: function (show_opt) {
			if (false === show_opt) {
				this.hide();
				return;
			}
			// Only call container.childVisible if we switch from hidden to visible
			if (!this.visible) {
				this.visible = true;
				this.element.show();
				if (this.container) {
					this.container.childVisible(this, true);
				}
			}
		},

		/**
		 * Hides this component.
		 */
		hide: function () {
			// Only call container.childVisible if we switch from visible to hidden
			if (this.visible) {
				this.visible = false;
				this.element.hide();
				if (this.container) {
					this.container.childVisible(this, false);
				}
			}
		},

		focus: function () {
			this.element.focus();
			if (this.container) {
				this.container.childFocus(this);
			}
		},

		foreground: function () {
			if (this.container) {
				this.container.childForeground(this);
			}
		},

		enable: function (enable_opt) {},
		disable: function () {}
	});

	return Component;
});

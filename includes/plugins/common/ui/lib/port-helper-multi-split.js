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

/*global define: true */
/**
 * This is a helper module for porting plugins from the old
 * ui-attributefield.js in the aloha core to the new ui-plugin.
 * This interface is obsolete and must not be used for new implementations.
 */
define([
	'aloha/core',
	'jquery',
	'ui/ui',
	'ui/multiSplit'
], function (
	Aloha,
	jQuery,
	Ui,
	MultiSplit
) {
	'use strict';

	function MultiSplitButton(props) {
		var component;

		component = Ui.adopt(props.name, MultiSplit, {
			scope: props.scope,
			getButtons: function () {
				var buttons = [];
				jQuery.each(props.items, function (i, item) {
					buttons.push({
						tooltip: item.tooltip,
						text: item.text,
						name: item.name,
						icon: item.iconClass,
						click: item.click,
						init: function () {
							if (item.cls) {
								this.element.addClass(item.cls);
							}
							if (item.init) {
								item.init.call(this);
							}
						},
						wide: item.wide
					});
				});
				return buttons;
			}
		});

		return {
			// Expose this function so the cite-plugin can push its own
			// button to the format plugin's multi-split-button (which
			// is a disastrous hack I know).
			// TODO make it possible to combine the items of multiple
			// plugins into a single multi split button.
			pushItem: function (item) {
				props.items.push(item);
			},
			showItem: function (name) {
				component.show(name);
			},
			hideItem: function (name) {
				component.hide(name);
			},
			setActiveItem: function (name) {
				component.setActiveButton(name);
			}
		};
	}

	return MultiSplitButton;
});

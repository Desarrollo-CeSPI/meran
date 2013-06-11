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

/**
 * The context module provides functions to get at the context element
 * for widgets.
 *
 * Many widgets are created dynamically and append themselves to the
 * body so that they can be shown to the user. The context element is
 * just a div appended to the body, that provides a common parent for
 * these widget elements.
 * 
 * Appending widget elements to the context element provides two benefits:
 * 1 - it would be cleaner for all aloha-specific elements to be
 *     appended to one common parent.
 * 2 - all css rules should have a .aloha context class, and the common
 *     parent provides this class.
 */
define([
	'aloha',
	'jquery',
	'util/class'
], function(
	Aloha,
	$,
	Class
) {
	'use strict';

	var id = 'aloha-ui-context',
	    selector = '#' + id,
	    element;

	// There is just a single context element in the page
	element = $(selector);
	if (!element.length) {
		element = $('<div>', {'class': 'aloha', 'id': id});
		// In the built aloha.js, init will happend before the body has
		// finished loading, so we have to defer appending the element.
		$(function(){ element.appendTo('body'); });
	}

	var Context =  Class.extend({
		surfaces: [],
		containers: []
	});

	// static fields

	$.extend(Context, {
		selector: selector,
		element: element
	});

	return Context;
});

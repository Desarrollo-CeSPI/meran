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

define(['jquery'],function($){
	'use strict';

	/**
	 * Splits a string into individual words.
	 *
	 * Words are any sequences of non-space characaters.
	 */
	function words(str) {
		// "  x  ".split(/\s/) -> ["", "x", ""] (Chrome)
		var list = $.trim(str).split(/[\r\n\t\s]+/);
		// "".split(/\s/) -> [""] (Chrome)
		return (list.length && list[0] === "") ? [] : list;
	}

	/**
	 * Converst a dashes form into camel cased form.
	 *
	 * For example 'data-my-attr' becomes 'dataMyAttr'.
	 *
	 * @param {string} s
	 *        Should be all lowercase and should not begin with a dash
	 */
	function dashesToCamelCase(s) {
		return s.replace(/[-]([a-z])/gi, function (all, upper) {
			return upper.toUpperCase();
		});
	}

	/**
	 * Converts a camel cased form into dashes form.
	 *
	 * For example
	 * 'dataMyAttr' becomes 'data-my-attr',
	 * 'dataAB'     becomes 'data-a-b'.
	 *
	 * @param {string} s
	 *        Should begin with a lowercase letter and should not contain dashes.
	 */
	function camelCaseToDashes(s) {
		return s.replace(/[A-Z]/g, function (match) {
			return '-' + match.toLowerCase();
		});
	}

	return {
		'words': words,
		'dashesToCamelCase': dashesToCamelCase,
		'camelCaseToDashes': camelCaseToDashes
	};
});

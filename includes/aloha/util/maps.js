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

define([], function () {
	'use strict';

	/**
	 * Checks whether the given object has no own or inherited properties.
	 *
	 * @param {!Object} obj The object to check.
	 * @return {boolean} True if the object is empty. eg: isEmpty({}) == true
	 */
	function isEmpty(obj) {
		for (var name in obj) if (obj.hasOwnProperty(name)) {
			return false;	
		}
		return true;
	}
 
	/**
	 * Fill the given map with the given keys mapped to the given value.
	 *
	 * @param map
	 *        The given map will have one entry added for each given key.
	 * @param keys
	 *        An array of string keys. Javascript maps can only
	 *        contain string keys, so these must be strings or
	 *        or they will be cast to string.
	 * @param value
	 *        A single value that each given key will map to.
	 * @return
	 *        The given map.
	 */
	function fillKeys(map, keys, value) {
		var i = keys.length;
		while (i--) {
			map[keys[i]] = value;
		}
		return map;
	}

	/**
	 * Fill the given map with entries from the given tuples.
	 *
	 * @param map
	 *        The given map will have one entry added for each item in
	 *        the given array.
	 * @param tuples
	 *        An array of [key, value] tuples. Javascript maps can only
	 *        contain string keys, so the keys must be strings or
	 *        or they will be cast to string.
	 * @return
	 *        The given map.
	 */
	function fillTuples(map, tuples) {
		var i = tuples.length,
		    tuple;
		while (i--) {
			tuple = tuples[i];
			map[tuple[0]] = tuple[1];
		}
		return map;
	}

	return {
		isEmpty: isEmpty,
		fillTuples: fillTuples,
		fillKeys: fillKeys
	};
});

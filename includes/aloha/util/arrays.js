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

define([],function(){
	'use strict'

    /**
     * Implements unique() using the browser's sort().
     *
     * @param a
     *        The array to sort and strip of duplicate values.
	 *        Warning: this array will be modified in-place.
     * @param compFn
     *        A custom comparison function that accepts two values a and
     *        b from the given array and returns -1, 0, 1 depending on
     *        whether a < b, a == b, a > b respectively.
	 *
	 *        If no compFn is provided, the algorithm will use the
     *        browsers default sort behaviour and loose comparison to
     *        detect duplicates.
     * @return
     *        The given array.
     */
    function sortUnique(a, compFn){
		var i;
		if (compFn) {
			a.sort(compFn);
			for (i = 1; i < a.length; i++) {
				if (0 === compFn(a[i], a[i - 1])) {
					a.splice(i--, 1);
				}
			}
		} else {
			a.sort();
			for (i = 1; i < a.length; i++) {
				// Use loosely typed comparsion if no compFn is given
				// to avoid sortUnique( [6, "6", 6] ) => [6, "6", 6]
				if (a[i] == a[i - 1]) {
					a.splice(i--, 1);
				}
			}
		}
		return a;
	}

	/**
	 * Shallow comparison of two arrays.
	 *
	 * @param a, b
	 *        The arrays to compare.
	 * @param equalFn
	 *        A custom comparison function that accepts two values a and
	 *        b from the given arrays and returns true or false for
	 *        equal and not equal respectively.
	 *
	 *        If no equalFn is provided, the algorithm will use the strict
	 *        equals operator.
	 * @return
	 *        True if all items in a and b are equal, false if not.
	 */
	function equal(a, b, equalFn) {
		var i = 0, len = a.length;
		if (len !== b.length) {
			return false;
		}
		if (equalFn) {
			for (; i < len; i++) {
				if (!equalFn(a[i], b[i])) {
					return false;
				}
			}
		} else {
			for (; i < len; i++) {
				if (a[i] !== b[i]) {
					return false;
				}
			}
		}
		return true;
	}

	/**
	 * ECMAScript map replacement
	 * See https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array/map
	 * And http://es5.github.com/#x15.4.4.19
	 * It's not exactly according to standard, but it does exactly what one expects.
	 */
	function map(a, fn) {
		var i, len, result = [];
		for (i = 0, len = a.length; i < len; i++) {
			result.push(fn(a[i]));
		}
		return result;
	}

	function mapNative(a, fn) {
		// Call map directly on the object instead of going through
		// Array.prototype.map. This avoids the problem that we may get
		// passed an array-like object (NodeList) which may cause an
		// error if the implementation of Array.prototype.map can only
		// deal with arrays (Array.prototype.map may be native or
		// provided by a javscript framework).
		return a.map(fn);
	}

	return {
		sortUnique: sortUnique,
		equal: equal,
		map: Array.prototype.map ? mapNative : map
	};
});

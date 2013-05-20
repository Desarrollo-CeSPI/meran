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
 * Defines a `Container` Class.
 *
 * Containers are activated based on the `showOn` setting for the container.
 * The values are normalized to functions which accept an element and return a
 * boolean; true means the container should be shown.
 *
 * For efficiency, we group all containers that have the same normalized
 * `showOn()' function together, so we can evaluate it once, regardless of how
 * many containers are using the same logic. In order for this to work, the
 * exact same function must be returned from `Container.normalizeShowOn()' when
 * the logic is the same.
 *
 * The list of containers is then stored on the context instance as
 * `context.containers', which is a hash of `showOn()' ids to an array of
 * containers. The `showOn()' ids are unique identifiers that are stored as
 * properties of the `showOn()' function (see `getShowOnId()'). This gives us
 * constant lookup times when grouping containers.
 */

define([
	'jquery',
	'util/class',
	'ui/scopes'
], function(
	$,
	Class,
	Scopes
) {
	'use strict';

	var uid = 0;

	/**
	 * Gets the id of a normalized showOn option.  If the given function has
	 * not had its showOnId set it will receive one, the first time this
	 * function it is passed to this function.
	 *
	 * @param {function} showOn The function whose id we wish to get.
	 * @return {number} The id of the given function.
	 */
	function getShowOnId(showOn) {
		// Store a unique id on the showOn function.
		// See full explanation at top of file.
		if (!showOn.showOnId) {
			showOn.showOnId = ++uid;
		}
		return showOn.showOnId;
	}

	/**
	 * Show or hide a set of containers.
	 *
	 * @param {Array.<Container>} containers The set of containers to operate
	 *                                       on.
	 * @param {boolean} show Whether to show or hide the given containers.
	 */
	function toggleContainers(containers, show) {
		var action = show ? 'show' : 'hide',
		    i;
		for (i = 0; i < containers.length; i++) {
			containers[i][action]();
		}
	}

	var scopeFns = {};

	var returnTrue = function() {
		return true;
	};

	/**
	 * Normalizes a showOn option into a function.
	 *
	 * @param {(string|boolean|function)} showOn
	 * @return function
	 */
	function normalizeShowOn(container, showOn) {
		switch ($.type(showOn)) {
		case 'function':
			return showOn;
		case 'object':
			if (showOn.scope) {
				if (scopeFns[showOn.scope]) {
					return scopeFns[showOn.scope];
				}
				return scopeFns[showOn.scope] = function() {
					return Scopes.isActiveScope(showOn.scope);
				};
			} else {
				throw "Invalid showOn configuration";
			}
		default:
			return returnTrue;
		}
	}

	/**
	 * Container class.
	 *
	 * @class
	 * @base
	 */
	var Container = Class.extend({

		/**
		 * The containing (wrapper) element for this container.
		 *
		 * @type {jQuery<HTMLElement>}
		 */
		element: null,

		/**
		 * Initialize a new container with the specified properties.
		 *
		 * @param {object=} settings Optional properties, and override methods.
		 * @constructor
		 */
		_constructor: function(context, settings) {
			var showOn = normalizeShowOn(this, settings.showOn),
			    key = getShowOnId(showOn),
			    group = context.containers[key];
			this.context = context;
			if (!group) {
				group = context.containers[key] = {
					shouldShow: showOn,
					containers: []
				};
			}
			group.containers.push(this);
		},

		// must be implemented by extending classes
		show: function() {},
		hide: function() {},
		focus: function() {},
		foreground: function() {},

		childVisible: function(childComponent, visible) {},
		childFocus: function(childComponent) {},
		childForeground: function(childComponent) {}
	});

	// static fields

	$.extend( Container, {
		/**
		 * Given an array of elements, show appropriate containers.
		 *
		 * @param {object} context
		 * @param {string} eventType Type of the event triggered (optional)
		 * @static
		 */
		showContainersForContext: function(context, eventType) {
			var group,
			    groupKey,
			    containerGroups;
			if (!context.containers) {
				// No containers were constructed for the given context, so
				// there is nothing for us to do.
				return;
			}
			containerGroups = context.containers;
			for (groupKey in containerGroups) {
				if (containerGroups.hasOwnProperty(groupKey)) {
					group = containerGroups[groupKey];
					toggleContainers(group.containers, group.shouldShow(eventType));
				}
			}
		}
	});

	return Container;
});

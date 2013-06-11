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
	'PubSub'
], function (
	$,
	PubSub
) {
	'use strict';

	var scopes = {
		    'Aloha.empty': [],
		    'Aloha.global': ['Aloha.empty'],
		    'Aloha.continuoustext': ['Aloha.global']
	    },
	    activeScopes = [],
	    addedScopes = {},
	    scopeSetDuringSelectionChanged = false;

	function pushScopeAncestors(ancestorScopes, scope) {
		if (!scopes.hasOwnProperty(scope)) {
			return;
		}
		var parentScopes = scopes[scope];
		for (var i = 0; i < parentScopes.length; i++) {
			var parentScope = parentScopes[i];
			ancestorScopes.push(parentScope);
			pushScopeAncestors(ancestorScopes, parentScope);
		}
	}

	Aloha.bind('aloha-selection-changed-before', function () {
		scopeSetDuringSelectionChanged = false;
	});

	Aloha.bind('aloha-selection-changed-after', function (event, range, originalEvent) {
		// I don't know why we check for originalEvent != 'undefined', here is
		// the original comment:
		// "Only set the specific scope if an event was provided, which means
		// that somehow an editable was selected"
		if (typeof originalEvent !== 'undefined' && ! scopeSetDuringSelectionChanged) {
			Scopes.setScope('Aloha.continuoustext');
		}
	});

	/**
	 * @deprecated
	 *     Scopes don't provide any additional functionality since
	 *     the visibility of containers and components can be
	 *     controlled individually.
	 */
	var Scopes = {

		/**
		 * @deprecated
		 *     Scopes don't provide any additional functionality since
		 *     the visibility of containers and components can be
		 *     controlled individually.
		 */
		enterScope: function(scope) {
			var counter = addedScopes[scope] || 0;
			addedScopes[scope] = counter + 1;
			if (!counter) {
				PubSub.pub('aloha.ui.scope.change');
			}
		},

		/**
		 * @deprecated
		 *     Scopes don't provide any additional functionality since
		 *     the visibility of containers and components can be
		 *     controlled individually.
		 */
		leaveScope: function(scope) {
			var counter = addedScopes[scope] - 1;
			if (counter) {
				addedScopes[scope] = counter;
			} else {
				delete addedScopes[scope];
				PubSub.pub('aloha.ui.scope.change');
			}
		},

		/**
		 * @deprecated
		 *     Scopes don't provide any additional functionality since
		 *     the visibility of containers and components can be
		 *     controlled individually.
		 */
		isActiveScope: function(scope){
			if (addedScopes[scope]) {
				return true;
			}
			var isActive = (-1 !== $.inArray(scope, activeScopes));
			if (isActive) {
				return true;
			}
			return false;
		},

		/**
		 * @deprecated
		 *     See setScope()
		 */
		getPrimaryScope: function() {
			return activeScopes[0];
		},

		/**
		 * @deprecated
		 *     Problem with setScope is that scopes defined by multiple plugins are exclusive to one another.
		 *     Example: table plugin and link plugin - you want to be able to set both table and link scopes.
		 *     Use enterScope and leaveScope instead.
		 */
		setScope: function(scope) {
			scopeSetDuringSelectionChanged = true;
			if (activeScopes[0] != scope) {
				activeScopes = [scope];
				pushScopeAncestors(activeScopes, scope);
				PubSub.pub('aloha.ui.scope.change');
			}
		},

		/**
		 * @deprecated
		 *     This method was used to define an ancestry for scopes.
		 *     It is unknonwn what problem scope ancestry solved, and
		 *     the method is therefore deprecated.
		 */
		createScope: function(scope, parentScopes){
			if ( ! parentScopes ) {
				parentScopes = ['Aloha.empty'];
			} else if (typeof parentScopes === 'string') {
				parentScopes = [parentScopes];
			}
			scopes[scope] = parentScopes;
		}
	};
	return Scopes;
});

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
	'aloha/repositorymanager',
	'ui/component',
	'ui/context',
	'./vendor/jquery-ui-autocomplete-html',
], function(
	jQuery,
	RepositoryManager,
	Context,
	Component
) {
	'use strict';

	/**
	 * Generates the HTML for an item
	 * @param {string} template
	 * @param {object} item
	 * @return {string}
	 */
	function parse( template, item ) {
		return template.replace( /{{([^}]+)}}/g, function( _, name ) {
			return name in item ? item[ name ] : "";
		});
	}

	/**
	 * Autocomplete component type
	 * @class
	 * @extends {Component}
	 */
	var Autocomplete = Component.extend({
		init: function() {
			this._super();
			var that = this;
			this.element = jQuery( "<input>" )
				.autocomplete({
					html: true,
					appendTo: Context.selector,
					source: function( req, res ) {
						RepositoryManager.query({
							queryString: req.term,
							objectTypeFilter: that.types
						}, function( data ) {
							res( jQuery.map( data.items, function( item ) {
								return {
									label: parse( that.template, item ),
									value: item.name,
									obj: item
								};
							}));
						});
					}
				})
				.bind( "autocompletechange", jQuery.proxy( function( event, ui ) {
					this.setValue( event.target.value, ui.item ? ui.item.obj : null );
				}, this ) );
		},

		// invoked when the user has changed the value and blurred the field
		/**
		 * Sets the value of the component
		 * @param {string} value Raw value
		 * @param {object} item Structured value
		 */
		setValue: function( value, item ) {}
	});

	return Autocomplete;
});

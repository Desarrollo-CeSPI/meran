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
	'aloha/core',
	'ui/surface',
	'ui/subguarded',
	'vendor/amplify.store'
], function (
	$,
	Aloha,
	Surface,
	subguarded,
	amplifyStore
) {
	'use strict';

	/**
	 * The distance the floating surface should remain from the editable it is
	 * floating to.
	 *
	 * @constant
	 * @type {string}
	 */
	var PADDING = 10;

	/**
	 * The length of time in milliseconds that the floating animation should
	 * take to complete.
	 *
	 * @constant
	 * @type {string}
	 */
	var DURATION = 500;

	/**
	 * Reference to the global window object for quicker lookup.
	 * @type {jQuery.<window>}
	 */
	var $window = $(window);

	/**
	 * Animates the given element into the specified position.
	 *
	 * @param {jQuery.<HTMLElement>} $element The element to move.
	 * @param {object} position The top and left position to which the element
	 *                         should be moved.
	 * @param {number} duration The length of time (in milliseconds) that the
	 *                         animation should run for.
	 * @param {function} callback Function to be invoked when animation
	 *                           completes.
	 */
	function floatTo($element, position, duration, callback) {
		$element.stop().animate(position, duration, function () {
			callback(position);
		});
	}

	/**
	 * Move the element above the given position.
	 *
	 * @param {jQuery.<HTMLElement>} $element The element to move.
	 * @param {object} position The top and left position to which the element
	 *                         should be moved.
	 * @param {number} duration The length of time (in milliseconds) that the
	 *                         animation should run for.
	 * @param {function} callback Function to be invoked when animation
	 *                           completes.
	 */
	function floatAbove($element, position, duration, callback) {
		position.top -= $element.height() + PADDING;
		floatTo($element, position, duration, callback);
	}

	/**
	 * Move the element below the given position.
	 *
	 * @param {jQuery.<HTMLElement>} $element The element to move.
	 * @param {object} position The top and left position to which the element
	 *                         should be moved.
	 * @param {number} duration The length of time (in milliseconds) that the
	 *                         animation should run for.
	 * @param {function} callback Function to be invoked when animation
	 *                           completes.
	 */
	function floatBelow($element, position, duration, callback) {
		position.top += PADDING;
		floatTo($element, position, duration, callback);
	}

	function storePinPosition(offset) {
		amplifyStore.store('Aloha.FloatingMenu.pinned', 'true');
		amplifyStore.store('Aloha.FloatingMenu.top', offset.top);
		amplifyStore.store('Aloha.FloatingMenu.left', offset.left);
	}

	function unstorePinPosition() {
		amplifyStore.store('Aloha.FloatingMenu.pinned', null);
		amplifyStore.store('Aloha.FloatingMenu.top', null);
		amplifyStore.store('Aloha.FloatingMenu.left', null);
	}

	function getPinState() {
		var state = {};

		if (amplifyStore.store('Aloha.FloatingMenu.pinned') === 'true') {
			return {
				top: parseInt(amplifyStore.store('Aloha.FloatingMenu.top'), 10),
				left: parseInt(amplifyStore.store('Aloha.FloatingMenu.left'), 10),
				isPinned: true
			};
		}

		return {
			top: null,
			left: null,
			isPinned: false
		};
	}

	function forcePositionIntoWindow(position) {
		var left = position.left;
		var top = position.top;

		if (top < 0) {
			top = 0;
		} else if (top > $window.height()) {
			top = $window.height() / 2;
		}

		if (left < 0) {
			left = 0;
		} else if (left > $window.width()) {
			left = $window.width() / 2;
		}

		return {
			top: top,
			left: left
		};
	}

	/**
	 * Cause the surface to float to the appropriate position around the given
	 * editable
	 *
	 * @param {Surface} surface The surface to be positioned
	 * @param {Aloha.Editable} editable The editable around which the surface
	 *                                  should be positioned.
	 * @param {number} duration The length of time (in milliseconds) for the
	 *                          animation should run.
	 * @param {function} callback Function to be invoked after the animation
	 *                            is completed.
	 */
	function floatSurface(surface, editable, duration, callback) {
		if (typeof duration !== 'number') {
			duration = DURATION;
		}

		var topGutter = (parseInt($('body').css('marginTop'), 10) || 0)
		              + (parseInt($('body').css('paddingTop'), 10) || 0);

		var $element = surface.$element;
		var surfaceOrientation = $element.offset();
		var editableOrientation = editable.obj.offset();
		var scrollTop = $window.scrollTop();
		var availableSpace = editableOrientation.top - scrollTop - topGutter;
		var left = editableOrientation.left;
		var horizontalOverflow = left + $element.width()
		                       - $window.width() - PADDING;

		if (horizontalOverflow > 0) {
			left -= horizontalOverflow;
		}

		if (availableSpace >= $element.height()) {
			editableOrientation.top -= scrollTop;
			floatAbove($element, editableOrientation, duration, callback);
		} else if (availableSpace + $element.height() >
				editableOrientation.top + editable.obj.height()) {
			floatBelow($element, {
				top: editableOrientation.top + editable.obj.height(),
				left: left
			}, duration, callback);
		} else {
			floatBelow($element, {
				top: topGutter,
				left: left
			}, duration, callback);
		}
	}

	/**
	 * Pins the given surfaces at the speficied position on the view port.
	 *
	 * @param {Surface} surfaces The surfaces that are to be pinned.
	 * @param {object} position The top and left position of where the surface
	 *                          is to be pinned.
	 * @param {boolean} isFloating Whether or not the surface type is in
	 *                             "floating" mode or not.
	 */
	function togglePinSurface(surface, position, isFloating) {
		var $element = surface.$element;

		if (isFloating) {
			unstorePinPosition();
			$element.find('.aloha-ui-pin').removeClass('aloha-ui-pin-down');
		} else {
			storePinPosition(position);
			$element.find('.aloha-ui-pin').addClass('aloha-ui-pin-down');
		}

		$element.css({
			position: 'fixed',
			top: position.top
		});
	}

	function onActivatedSurface(tuples, eventName, $event, range, nativeEvent) {
		var i;
		for (i = 0; i < tuples.length; i++) {
			if (tuples[i][0].isActive()) {
				tuples[i][1]($event, range, nativeEvent);
			}
		}
	}

	function makeFloating(surface, SurfaceTypeManager) {
		subguarded([
			'aloha-selection-changed',
			'aloha.ui.container.selected'
		], onActivatedSurface, surface, function () {
			surface._move();
		});

		var updateSurfacePosition = function () {
			var position = forcePositionIntoWindow({
				top: SurfaceTypeManager.pinTop,
				left: SurfaceTypeManager.pinLeft
			});

			SurfaceTypeManager.setFloatingPosition(position);

			surface.$element.css({
				top: position.top,
				left: position.left
			});
		};

		$window.scroll(function () {
			// TODO: only do this for active surfaces.
			surface._move(0);
		});

		$window.resize(function () {
			if (!SurfaceTypeManager.isFloatingMode) {
				updateSurfacePosition();
			}
		});

		surface.addPin();

		// IE7 will not properly set the position property to "fixed" if our
		// element is not rendered.  We therefore have to do a rigmarore to
		// temorarily render the element in order to set the position
		// correctly.
		if ($.browser.msie) {
			var $parent = surface.$element.parent();
			surface.$element.appendTo('body');
			surface.$element.css('position', 'fixed').appendTo($parent);
		} else {
			surface.$element.css('position', 'fixed');
		}

		if (!SurfaceTypeManager.isFloatingMode) {
			updateSurfacePosition();
		}

		surface.$element.css('z-index', 10100).draggable({
			'distance': 20,
			'stop': function (event, ui) {
				SurfaceTypeManager.setFloatingPosition(ui.position);
				if (!SurfaceTypeManager.isFloatingMode) {
					storePinPosition(ui.position);
				}
			}
		});

		// Resizable toolbars are possible, and would be a nice feature.
		//surface.$element.resizable();
	}

	return {
		getPinState: getPinState,
		makeFloating: makeFloating,
		floatSurface: floatSurface,
		togglePinSurface: togglePinSurface
	};
});

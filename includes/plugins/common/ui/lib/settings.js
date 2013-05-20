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

define(['jquery', 'util/arrays', 'util/maps', 'util/trees'], function($, Arrays, Maps, Trees){
	var defaultToolbarSettings = {
		tabs: [
			// Format Tab
			{
				label: 'Format',
				showOn: { scope: 'Aloha.continuoustext' },
				components: [
					[
						// strong, emphasis and underline are not shown with the default format plugin button configuration
						'bold', 'strong', 'italic', 'emphasis', '\n',
						'subscript', 'superscript', 'strikethrough', 'quote'
					], [
						'formatLink', 'formatAbbr', 'formatNumeratedHeaders', '\n',
						'toggleMetaView', 'wailang', 'toggleFormatlessPaste', '\n',
						'toggleDragDrop'
					], [
						'alignLeft', 'alignCenter', 'alignRight', 'alignJustify', '\n',
						'orderedList', 'unorderedList', 'indentList', 'outdentList'
					], [
						'formatBlock'
					]
				]
			},
			// Insert Tab
			{
				label: "Insert",
				showOn: { scope: 'Aloha.continuoustext' },
				components: [
					[ "createTable", "characterPicker", "insertLink",
					  "insertImage", "insertAbbr", "insertToc",
					  "insertHorizontalRule", "insertTag"]
				]
			},
			// Link Tab
			{
				label: 'Link', 
				showOn: { scope: 'link' },
				components: [ 'editLink', 'removeLink', 'linkBrowser' ]
			},
            // Image Tab
            {
                label: "Image",
                showOn: {scope: 'image'},
                components: [
                    [ "imageSource", "imageTitle",
                      "imageAlignLeft", "imageAlignRight", "imageAlignNone",
                      "imageIncPadding", "imageDecPadding",
                      "imageBrowser",
                      "imageCropButton", "imageCnrReset", "imageCnrRatio",
                      "imageResizeWidth", "imageResizeHeight" ]
                ]
            },
            // Abbr Tab
            {   label: "Abbreviation",
                showOn: { scope: 'abbr' },
                components: [
                    [ "abbrText" ]
                ]
            },
            // Wailang Tab
            {   label: "Wailang",
				showOn: { scope: 'wai-lang' },
                components: [ [ "wailangfield", "removewailang" ] ]
            },
			// Table Tabs
			{
				label: "Table",
				showOn: { scope: 'table.cell' },
				components: [
					[ "mergecells", "splitcells", "tableCaption",
					  "tableSummary", "formatTable" ]
				]
			},
			{ 
				label: "Column",
				showOn: { scope: 'table.column' },
				components: [
					[ "addcolumnleft", "addcolumnright", "deletecolumns",
					  "columnheader", "mergecellsColumn", "splitcellsColumn",
					  "formatColumn" ]
				]
			},
			{
				label: "Row",
				showOn: { scope: 'table.row' },
				components: [
					[ "addrowbefore", "addrowafter", "deleterows", "rowheader",
					  "mergecellsRow", "splitcellsRow", "formatRow" ]
				]
			}
		]
	};

	/**
	 * Combines two toolbar configurations.
	 *
	 * The rules for combining configurations are as follows
	 *
	 * * remove all components and tabs from the default toolbar configuration
	 *   that are listed in the given exclude array,
	 * * add all remaining tabs from the default configuration to the user
	 *   configuration,
	 * * and merge tabs with the same name such that a tab property that is
	 *   omitted in the user configuration will be taken from the default
	 *   configuration,
	 * * and, if both the default tab and the user's tab configuration contain
	 *   a components property, and unless the exclusive property on a tab is
	 *   true, append all remaining components from the default tab to the
	 *   user's tab configuration.
	 *
	 * @param userTabs
	 *        a list of tab configurations
	 * @param defaultTabs
	 *        a list of tab configurations
	 * @param exclude
	 *        a list of component names and tab labels to ignore
	 *        in the given defaultTabs configuration.
	 * @return
	 *         
	 */
	function combineToolbarSettings(userTabs, defaultTabs, exclude) {
		var defaultTabsByLabel = Maps.fillTuples({}, Arrays.map(defaultTabs, function(tab) {
			return [tab.label, tab];
		}));
		var exclusionLookup = makeExclusionMap(userTabs, exclude);
		function pruneDefaultComponents(form) {
			return 'array' === $.type(form) ? !form.length : exclusionLookup[form];
		};
		userTabs = mergeDefaultComponents(userTabs, defaultTabsByLabel, pruneDefaultComponents);
		defaultTabs = remainingDefaultTabs(defaultTabs, exclusionLookup, pruneDefaultComponents);
		return userTabs.concat(defaultTabs);
	}

	function remainingDefaultTabs(defaultTabs, exclusionLookup, pruneDefaultComponents) {
		var i,
		    tab,
		    tabs = [],
		    defaultTab,
		    components;
		for (i = 0; i < defaultTabs.length; i++) {
			defaultTab = defaultTabs[i];
			if (!exclusionLookup[defaultTab.label]) {
				components = Trees.postprune(defaultTab.components, pruneDefaultComponents);
				if (components) {
					tab = $.extend({}, defaultTab);
					tab.components = components;
					tabs.push(tab);
				}
			}
		}
		return tabs;
	}

	function mergeDefaultComponents(userTabs, defaultTabsByLabel, pruneDefaultComponents) {
		var i,
            tab,
		    tabs = [],
		    userTab,
		    components,
		    defaultTab,
		    defaultComponents;
		for (i = 0; i < userTabs.length; i++) {
			userTab = userTabs[i];
			components = userTab.components || [];
			defaultTab = defaultTabsByLabel[userTab.label];
			if (!userTab.exclusive && defaultTab) {
				defaultComponents = Trees.postprune(defaultTab.components, pruneDefaultComponents);
				if (defaultComponents) {
					components = components.concat(defaultComponents);
				}
			}
			tab = $.extend({}, defaultTab || {}, userTab);
			tab.components = components;
			tabs.push(tab);
		}
		return tabs;
	}

	function makeExclusionMap(userTabs, exclude) {
		var i,
		    map = Maps.fillKeys({}, exclude, true);
		for (i = 0; i < userTabs.length; i++) {
			map[userTabs[i].label] = true;
			Maps.fillKeys(map, Trees.flatten(userTabs[i].components), true);
		}
		return map;
	}

	return {
		defaultToolbarSettings: defaultToolbarSettings,
		combineToolbarSettings: combineToolbarSettings
	};
});

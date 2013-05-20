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

// To be included in the compiled aloha-full.js (which includes
// requirejs and jQuery) immediately after jQuery. This will prevent
// Aloha's jQuery from polluting the global namespace.
// TODO: requirejs shouldn't leak either
// NB: this is only for aloha-full.js to preserve behaviour with the way
// older builds of aloha were done. It is now always preferred to use
// aloha-bare.js (which doesn't include either requirejs or jQuery) and
// let the implementer worry exactly how to set up jQuery and requirejs
// to suit his needs.
Aloha = Aloha || {};
Aloha.settings = Aloha.settings || {};
Aloha.settings.jQuery = Aloha.settings.jQuery || jQuery.noConflict(true);

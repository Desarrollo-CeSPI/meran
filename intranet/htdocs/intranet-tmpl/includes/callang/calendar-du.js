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

// ** I18N
Calendar._DN = new Array
("Zondag",
 "Maandag",
 "Dinsdag",
 "Woensdag",
 "Donderdag",
 "Vrijdag",
 "Zaterdag",
 "Zondag");
Calendar._MN = new Array
("Januari",
 "Februari",
 "Maart",
 "April",
 "Mei",
 "Juni",
 "Juli",
 "Augustus",
 "September",
 "Oktober",
 "November",
 "December");

// tooltips
Calendar._TT = {};
Calendar._TT["TOGGLE"] = "Toggle startdag van de week";
Calendar._TT["PREV_YEAR"] = "Vorig jaar (indrukken voor menu)";
Calendar._TT["PREV_MONTH"] = "Vorige month (indrukken voor menu)";
Calendar._TT["GO_TODAY"] = "Naar Vandaag";
Calendar._TT["NEXT_MONTH"] = "Volgende Maand (indrukken voor menu)";
Calendar._TT["NEXT_YEAR"] = "Volgend jaar (indrukken voor menu)";
Calendar._TT["SEL_DATE"] = "Selecteer datum";
Calendar._TT["DRAG_TO_MOVE"] = "Sleep om te verplaatsen";
Calendar._TT["PART_TODAY"] = " (vandaag)";
Calendar._TT["MON_FIRST"] = "Toon Maandag eerst";
Calendar._TT["SUN_FIRST"] = "Toon Zondag eerst";
Calendar._TT["CLOSE"] = "Sluiten";
Calendar._TT["TODAY"] = "Vandaag";

// date formats
Calendar._TT["DEF_DATE_FORMAT"] = "y-mm-dd";
Calendar._TT["TT_DATE_FORMAT"] = "D, M d";

Calendar._TT["WK"] = "wk";

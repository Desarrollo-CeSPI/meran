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

// Calendar SK language
// Author: Peter Valach (pvalach@gmx.net)
// Encoding: utf-8
// Last update: 2003/10/29
// Distributed under the same terms as the calendar itself.

// full day names
Calendar._DN = new Array
("NedeÄľa",
 "Pondelok",
 "Utorok",
 "Streda",
 "Ĺ tvrtok",
 "Piatok",
 "Sobota",
 "NedeÄľa");

// short day names
Calendar._SDN = new Array
("Ned",
 "Pon",
 "Uto",
 "Str",
 "Ĺ tv",
 "Pia",
 "Sob",
 "Ned");

// full month names
Calendar._MN = new Array
("JanuĂˇr",
 "FebruĂˇr",
 "Marec",
 "AprĂ­l",
 "MĂˇj",
 "JĂşn",
 "JĂşl",
 "August",
 "September",
 "OktĂłber",
 "November",
 "December");

// short month names
Calendar._SMN = new Array
("Jan",
 "Feb",
 "Mar",
 "Apr",
 "MĂˇj",
 "JĂşn",
 "JĂşl",
 "Aug",
 "Sep",
 "Okt",
 "Nov",
 "Dec");

// tooltips
Calendar._TT = {};
Calendar._TT["INFO"] = "O kalendĂˇri";

Calendar._TT["ABOUT"] =
"DHTML Date/Time Selector\n" +
"(c) dynarch.com 2002-2005 / Author: Mihai Bazon\n" +
"PoslednĂş verziu nĂˇjdete na: http://www.dynarch.com/projects/calendar/\n" +
"DistribuovanĂ© pod GNU LGPL.  ViÄŹ http://gnu.org/licenses/lgpl.html pre detaily." +
"\n\n" +
"VĂ˝ber dĂˇtumu:\n" +
"- PouĹľite tlaÄŤidlĂˇ \xab, \xbb pre vĂ˝ber roku\n" +
"- PouĹľite tlaÄŤidlĂˇ " + String.fromCharCode(0x2039) + ", " + String.fromCharCode(0x203a) + " pre vĂ˝ber mesiaca\n" +
"- Ak ktorĂ©koÄľvek z tĂ˝chto tlaÄŤidiel podrĹľĂ­te dlhĹˇie, zobrazĂ­ sa rĂ˝chly vĂ˝ber.";
Calendar._TT["ABOUT_TIME"] = "\n\n" +
"VĂ˝ber ÄŤasu:\n" +
"- Kliknutie na niektorĂş poloĹľku ÄŤasu ju zvĂ˝Ĺˇi\n" +
"- Shift-klik ju znĂ­Ĺľi\n" +
"- Ak podrĹľĂ­te tlaÄŤĂ­tko stlaÄŤenĂ©, posĂşvanĂ­m menĂ­te hodnotu.";

Calendar._TT["PREV_YEAR"] = "PredoĹˇlĂ˝ rok (podrĹľte pre menu)";
Calendar._TT["PREV_MONTH"] = "PredoĹˇlĂ˝ mesiac (podrĹľte pre menu)";
Calendar._TT["GO_TODAY"] = "PrejsĹĄ na dneĹˇok";
Calendar._TT["NEXT_MONTH"] = "Nasl. mesiac (podrĹľte pre menu)";
Calendar._TT["NEXT_YEAR"] = "Nasl. rok (podrĹľte pre menu)";
Calendar._TT["SEL_DATE"] = "ZvoÄľte dĂˇtum";
Calendar._TT["DRAG_TO_MOVE"] = "PodrĹľanĂ­m tlaÄŤĂ­tka zmenĂ­te polohu";
Calendar._TT["PART_TODAY"] = " (dnes)";
Calendar._TT["MON_FIRST"] = "ZobraziĹĄ pondelok ako prvĂ˝";
Calendar._TT["SUN_FIRST"] = "ZobraziĹĄ nedeÄľu ako prvĂş";
Calendar._TT["CLOSE"] = "ZavrieĹĄ";
Calendar._TT["TODAY"] = "Dnes";
Calendar._TT["TIME_PART"] = "(Shift-)klik/ĹĄahanie zmenĂ­ hodnotu";

// date formats
Calendar._TT["DEF_DATE_FORMAT"] = "$d. %m. %Y";
Calendar._TT["TT_DATE_FORMAT"] = "%a, %e. %b";

Calendar._TT["WK"] = "tĂ˝Ĺľ";

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
// Calendar PL language
// Author: Artur Filipiak, <imagen@poczta.fm>
// January, 2004
// Encoding: UTF-8
Calendar._DN = new Array
("Niedziela", "Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek", "Sobota", "Niedziela");

Calendar._SDN = new Array
("N", "Pn", "Wt", "Śr", "Cz", "Pt", "So", "N");

Calendar._MN = new Array
("Styczeń", "Luty", "Marzec", "Kwiecień", "Maj", "Czerwiec", "Lipiec", "Sierpień", "Wrzesień", "Październik", "Listopad", "Grudzień");

Calendar._SMN = new Array
("Sty", "Lut", "Mar", "Kwi", "Maj", "Cze", "Lip", "Sie", "Wrz", "Paź", "Lis", "Gru");

// tooltips
Calendar._TT = {};
Calendar._TT["INFO"] = "O kalendarzu";

Calendar._TT["ABOUT"] =
"DHTML Date/Time Selector\n" +
"(c) dynarch.com 2002-2005 / Author: Mihai Bazon\n" + // don't translate this this ;-)
"For latest version visit: http://www.dynarch.com/projects/calendar/\n" +
"Distributed under GNU LGPL.  See http://gnu.org/licenses/lgpl.html for details." +
"\n\n" +
"Wybór daty:\n" +
"- aby wybrać rok użyj przycisków \xab, \xbb\n" +
"- aby wybrać miesiąc użyj przycisków " + String.fromCharCode(0x2039) + ", " + String.fromCharCode(0x203a) + "\n" +
"- aby przyspieszyć wybór przytrzymaj wciśnięty przycisk myszy nad ww. przyciskami.";
Calendar._TT["ABOUT_TIME"] = "\n\n" +
"Wybór czasu:\n" +
"- aby zwiększyć wartość kliknij na dowolnym elemencie selekcji czasu\n" +
"- aby zmniejszyć wartość użyj dodatkowo klawisza Shift\n" +
"- możesz również poruszać myszkę w lewo i prawo wraz z wciśniętym lewym klawiszem.";

Calendar._TT["PREV_YEAR"] = "Poprz. rok (przytrzymaj dla menu)";
Calendar._TT["PREV_MONTH"] = "Poprz. miesiąc (przytrzymaj dla menu)";
Calendar._TT["GO_TODAY"] = "Pokaż dziś";
Calendar._TT["NEXT_MONTH"] = "Nast. miesiąc (przytrzymaj dla menu)";
Calendar._TT["NEXT_YEAR"] = "Nast. rok (przytrzymaj dla menu)";
Calendar._TT["SEL_DATE"] = "Wybierz datę";
Calendar._TT["DRAG_TO_MOVE"] = "Przesuń okienko";
Calendar._TT["PART_TODAY"] = " (dziś)";
Calendar._TT["MON_FIRST"] = "Pokaż Poniedziałek jako pierwszy";
Calendar._TT["SUN_FIRST"] = "Pokaż Niedzielę jako pierwszą";
Calendar._TT["CLOSE"] = "Zamknij";
Calendar._TT["TODAY"] = "Dziś";
Calendar._TT["TIME_PART"] = "(Shift-)klik | drag, aby zmienić wartość";

// date formats
Calendar._TT["DEF_DATE_FORMAT"] = "%Y.%m.%d";
Calendar._TT["TT_DATE_FORMAT"] = "%a, %b %e";

Calendar._TT["WK"] = "wk";
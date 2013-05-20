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

﻿// ** I18N

// Calendar PL language
// Author: Dariusz Pietrzak, <eyck@ghost.anime.pl>
// Author: Janusz Piwowarski, <jpiw@go2.pl>
// Encoding: utf-8
// Distributed under the same terms as the calendar itself.

Calendar._DN = new Array
("Niedziela",
 "Poniedziałek",
 "Wtorek",
 "Środa",
 "Czwartek",
 "Piątek",
 "Sobota",
 "Niedziela");
Calendar._SDN = new Array
("Nie",
 "Pn",
 "Wt",
 "Śr",
 "Cz",
 "Pt",
 "So",
 "Nie");
Calendar._MN = new Array
("Styczeń",
 "Luty",
 "Marzec",
 "Kwiecień",
 "Maj",
 "Czerwiec",
 "Lipiec",
 "Sierpień",
 "Wrzesień",
 "Październik",
 "Listopad",
 "Grudzień");
Calendar._SMN = new Array
("Sty",
 "Lut",
 "Mar",
 "Kwi",
 "Maj",
 "Cze",
 "Lip",
 "Sie",
 "Wrz",
 "Paź",
 "Lis",
 "Gru");

// tooltips
Calendar._TT = {};
Calendar._TT["INFO"] = "O kalendarzu";

Calendar._TT["ABOUT"] =
"DHTML Date/Time Selector\n" +
"(c) dynarch.com 2002-2005 / Author: Mihai Bazon\n" + // don't translate this this ;-)
"Aby pobrać najnowszą wersję, odwiedź: http://www.dynarch.com/projects/calendar/\n" +
"Dostępny na licencji GNU LGPL. Zobacz szczegóły na http://gnu.org/licenses/lgpl.html." +
"\n\n" +
"Wybór daty:\n" +
"- Użyj przycisków \xab, \xbb by wybrać rok\n" +
"- Użyj przycisków " + String.fromCharCode(0x2039) + ", " + String.fromCharCode(0x203a) + " by wybrać miesiąc\n" +
"- Przytrzymaj klawisz myszy nad jednym z powyższych przycisków dla szybszego wyboru.";
Calendar._TT["ABOUT_TIME"] = "\n\n" +
"Wybór czasu:\n" +
"- Kliknij na jednym z pól czasu by zwiększyć jego wartość\n" +
"- lub kliknij trzymając Shift by zmiejszyć jego wartość\n" +
"- lub kliknij i przeciągnij dla szybszego wyboru.";

//Calendar._TT["TOGGLE"] = "Zmień pierwszy dzień tygodnia";
Calendar._TT["PREV_YEAR"] = "Poprzedni rok (przytrzymaj dla menu)";
Calendar._TT["PREV_MONTH"] = "Poprzedni miesiąc (przytrzymaj dla menu)";
Calendar._TT["GO_TODAY"] = "Idź do dzisiaj";
Calendar._TT["NEXT_MONTH"] = "Następny miesiąc (przytrzymaj dla menu)";
Calendar._TT["NEXT_YEAR"] = "Następny rok (przytrzymaj dla menu)";
Calendar._TT["SEL_DATE"] = "Wybierz datę";
Calendar._TT["DRAG_TO_MOVE"] = "Przeciągnij by przesunąć";
Calendar._TT["PART_TODAY"] = " (dzisiaj)";
Calendar._TT["MON_FIRST"] = "Wyświetl poniedziałek jako pierwszy";
Calendar._TT["SUN_FIRST"] = "Wyświetl niedzielę jako pierwszą";
Calendar._TT["CLOSE"] = "Zamknij";
Calendar._TT["TODAY"] = "Dzisiaj";
Calendar._TT["TIME_PART"] = "(Shift-)Kliknij lub przeciągnij by zmienić wartość";

// date formats
Calendar._TT["DEF_DATE_FORMAT"] = "%Y-%m-%d";
Calendar._TT["TT_DATE_FORMAT"] = "%e %B, %A";

Calendar._TT["WK"] = "ty";

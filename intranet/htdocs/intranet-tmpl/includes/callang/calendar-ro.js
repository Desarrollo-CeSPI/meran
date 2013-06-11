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
("Duminică",
 "Luni",
 "Marţi",
 "Miercuri",
 "Joi",
 "Vineri",
 "Sâmbătă",
 "Duminică");
Calendar._SDN_len = 2;
Calendar._MN = new Array
("Ianuarie",
 "Februarie",
 "Martie",
 "Aprilie",
 "Mai",
 "Iunie",
 "Iulie",
 "August",
 "Septembrie",
 "Octombrie",
 "Noiembrie",
 "Decembrie");

// tooltips
Calendar._TT = {};

Calendar._TT["INFO"] = "Despre calendar";

Calendar._TT["ABOUT"] =
"DHTML Date/Time Selector\n" +
"(c) dynarch.com 2002-2005 / Author: Mihai Bazon\n" + // don't translate this this ;-)
"Pentru ultima versiune vizitaţi: http://www.dynarch.com/projects/calendar/\n" +
"Distribuit sub GNU LGPL.  See http://gnu.org/licenses/lgpl.html for details." +
"\n\n" +
"Selecţia datei:\n" +
"- Folosiţi butoanele \xab, \xbb pentru a selecta anul\n" +
"- Folosiţi butoanele " + String.fromCharCode(0x2039) + ", " + String.fromCharCode(0x203a) + " pentru a selecta luna\n" +
"- Tineţi butonul mouse-ului apăsat pentru selecţie mai rapidă.";
Calendar._TT["ABOUT_TIME"] = "\n\n" +
"Selecţia orei:\n" +
"- Click pe ora sau minut pentru a mări valoarea cu 1\n" +
"- Sau Shift-Click pentru a micşora valoarea cu 1\n" +
"- Sau Click şi drag pentru a selecta mai repede.";

Calendar._TT["PREV_YEAR"] = "Anul precedent (lung pt menu)";
Calendar._TT["PREV_MONTH"] = "Luna precedentă (lung pt menu)";
Calendar._TT["GO_TODAY"] = "Data de azi";
Calendar._TT["NEXT_MONTH"] = "Luna următoare (lung pt menu)";
Calendar._TT["NEXT_YEAR"] = "Anul următor (lung pt menu)";
Calendar._TT["SEL_DATE"] = "Selectează data";
Calendar._TT["DRAG_TO_MOVE"] = "Trage pentru a mişca";
Calendar._TT["PART_TODAY"] = " (astăzi)";
Calendar._TT["DAY_FIRST"] = "Afişează %s prima zi";
Calendar._TT["WEEKEND"] = "0,6";
Calendar._TT["CLOSE"] = "Închide";
Calendar._TT["TODAY"] = "Astăzi";
Calendar._TT["TIME_PART"] = "(Shift-)Click sau drag pentru a selecta";

// date formats
Calendar._TT["DEF_DATE_FORMAT"] = "%d-%m-%Y";
Calendar._TT["TT_DATE_FORMAT"] = "%A, %d %B";

Calendar._TT["WK"] = "spt";
Calendar._TT["TIME"] = "Ora:";

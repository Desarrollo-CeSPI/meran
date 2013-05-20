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

// Calendar ALBANIAN language
//author Rigels Gordani rige@hotmail.com

// ditet
Calendar._DN = new Array
("E Diele",
"E Hene",
"E Marte",
"E Merkure",
"E Enjte",
"E Premte",
"E Shtune",
"E Diele");

//ditet shkurt
Calendar._SDN = new Array
("Die",
"Hen",
"Mar",
"Mer",
"Enj",
"Pre",
"Sht",
"Die");

// muajt
Calendar._MN = new Array
("Janar",
"Shkurt",
"Mars",
"Prill",
"Maj",
"Qeshor",
"Korrik",
"Gusht",
"Shtator",
"Tetor",
"Nentor",
"Dhjetor");

// muajte shkurt
Calendar._SMN = new Array
("Jan",
"Shk",
"Mar",
"Pri",
"Maj",
"Qes",
"Kor",
"Gus",
"Sht",
"Tet",
"Nen",
"Dhj");

// ndihmesa
Calendar._TT = {};
Calendar._TT["INFO"] = "Per kalendarin";

Calendar._TT["ABOUT"] =
"Zgjedhes i ores/dates ne DHTML \n" +
"\n\n" +"Zgjedhja e Dates:\n" +
"- Perdor butonat \xab, \xbb per te zgjedhur vitin\n" +
"- Perdor  butonat" + String.fromCharCode(0x2039) + ", " + 
String.fromCharCode(0x203a) +
" per te  zgjedhur muajin\n" +
"- Mbani shtypur butonin e mousit per nje zgjedje me te shpejte.";
Calendar._TT["ABOUT_TIME"] = "\n\n" +
"Zgjedhja e kohes:\n" +
"- Kliko tek ndonje nga pjeset e ores per ta rritur ate\n" +
"- ose kliko me Shift per ta zvogeluar ate\n" +
"- ose cliko dhe terhiq per zgjedhje me te shpejte.";

Calendar._TT["PREV_YEAR"] = "Viti i shkuar (prit per menune)";
Calendar._TT["PREV_MONTH"] = "Muaji i shkuar (prit per menune)";
Calendar._TT["GO_TODAY"] = "Sot";
Calendar._TT["NEXT_MONTH"] = "Muaji i ardhshem (prit per menune)";
Calendar._TT["NEXT_YEAR"] = "Viti i ardhshem (prit per menune)";
Calendar._TT["SEL_DATE"] = "Zgjidh daten";
Calendar._TT["DRAG_TO_MOVE"] = "Terhiqe per te levizur";
Calendar._TT["PART_TODAY"] = " (sot)";

// "%s" eshte dita e pare e javes
// %s do te zevendesohet me emrin e dite
Calendar._TT["DAY_FIRST"] = "Trego te %s te paren";


Calendar._TT["WEEKEND"] = "0,6";

Calendar._TT["CLOSE"] = "Mbyll";
Calendar._TT["TODAY"] = "Sot";
Calendar._TT["TIME_PART"] = "Kliko me (Shift-)ose terhiqe per te ndryshuar 
vleren";

// date formats
Calendar._TT["DEF_DATE_FORMAT"] = "%Y-%m-%d";
Calendar._TT["TT_DATE_FORMAT"] = "%a, %b %e";

Calendar._TT["WK"] = "Java";
Calendar._TT["TIME"] = "Koha:";


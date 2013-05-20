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
Calendar._DN = new Array
("Κυριακή",
 "Δευτέρα",
 "Τρίτη",
 "Τετάρτη",
 "Πέμπτη",
 "Παρασκευή",
 "Σάββατο",
 "Κυριακή");

Calendar._SDN = new Array
("Κυ",
 "Δε",
 "Tρ",
 "Τε",
 "Πε",
 "Πα",
 "Σα",
 "Κυ");

Calendar._MN = new Array
("Ιανουάριος",
 "Φεβρουάριος",
 "Μάρτιος",
 "Απρίλιος",
 "Μάϊος",
 "Ιούνιος",
 "Ιούλιος",
 "Αύγουστος",
 "Σεπτέμβριος",
 "Οκτώβριος",
 "Νοέμβριος",
 "Δεκέμβριος");

Calendar._SMN = new Array
("Ιαν",
 "Φεβ",
 "Μαρ",
 "Απρ",
 "Μαι",
 "Ιουν",
 "Ιουλ",
 "Αυγ",
 "Σεπ",
 "Οκτ",
 "Νοε",
 "Δεκ");

// tooltips
Calendar._TT = {};
Calendar._TT["INFO"] = "Για το ημερολόγιο";

Calendar._TT["ABOUT"] =
"Επιλογέας ημερομηνίας/ώρας σε DHTML\n" +
"(c) dynarch.com 2002-2005 / Author: Mihai Bazon\n" + // don't translate this this ;-)
"Για τελευταία έκδοση: http://www.dynarch.com/projects/calendar/\n" +
"Distributed under GNU LGPL.  See http://gnu.org/licenses/lgpl.html for details." +
"\n\n" +
"Επιλογή ημερομηνίας:\n" +
"- Χρησιμοποιείστε τα κουμπιά \xab, \xbb για επιλογή έτους\n" +
"- Χρησιμοποιείστε τα κουμπιά " + String.fromCharCode(0x2039) + ", " + String.fromCharCode(0x203a) + " για επιλογή μήνα\n" +
"- Κρατήστε κουμπί ποντικού πατημένο στα παραπάνω κουμπιά για πιο γρήγορη επιλογή.";
Calendar._TT["ABOUT_TIME"] = "\n\n" +
"Επιλογή ώρας:\n" +
"- Κάντε κλικ σε ένα από τα μέρη της ώρας για αύξηση\n" +
"- ή Shift-κλικ για μείωση\n" +
"- ή κλικ και μετακίνηση για πιο γρήγορη επιλογή.";
Calendar._TT["TOGGLE"] = "Μπάρα πρώτης ημέρας της εβδομάδας";
Calendar._TT["PREV_YEAR"] = "Προηγ. έτος (κρατήστε για το μενού)";
Calendar._TT["PREV_MONTH"] = "Προηγ. μήνας (κρατήστε για το μενού)";
Calendar._TT["GO_TODAY"] = "Σήμερα";
Calendar._TT["NEXT_MONTH"] = "Επόμενος μήνας (κρατήστε για το μενού)";
Calendar._TT["NEXT_YEAR"] = "Επόμενο έτος (κρατήστε για το μενού)";
Calendar._TT["SEL_DATE"] = "Επιλέξτε ημερομηνία";
Calendar._TT["DRAG_TO_MOVE"] = "Σύρτε για να μετακινήσετε";
Calendar._TT["PART_TODAY"] = " (σήμερα)";
Calendar._TT["MON_FIRST"] = "Εμφάνιση Δευτέρας πρώτα";
Calendar._TT["SUN_FIRST"] = "Εμφάνιση Κυριακής πρώτα";
Calendar._TT["CLOSE"] = "Κλείσιμο";
Calendar._TT["TODAY"] = "Σήμερα";
Calendar._TT["TIME_PART"] = "(Shift-)κλικ ή μετακίνηση για αλλαγή";

// date formats
Calendar._TT["DEF_DATE_FORMAT"] = "dd-mm-y";
Calendar._TT["TT_DATE_FORMAT"] = "D, d M";

Calendar._TT["WK"] = "εβδ";


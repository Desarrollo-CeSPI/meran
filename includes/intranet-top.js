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

var percent_progress_bar = 0;
var interval_ID = 0;
	function updateProgress(percentage){
        percent_progress_bar = parseInt(percentage);
		$('#progress_bar').show();
		$('#progress_bar_value').css('width',percent_progress_bar+'%');
		$('#progress_bar_value').html(percent_progress_bar+"%");
	}


    function pollTest(){
    	if ( (percent_progress_bar != null) && (percent_progress_bar != '-1') && (percent_progress_bar < 100) ) {
	        objAH                   = new AjaxHelper(updatePollTest);
	        objAH.url               = URL_PREFIX+'/poll_job.pl';
	        objAH.debug             = false;
	        objAH.showOverlay       = false;
	        objAH.jobID             = jobID; 
	        objAH.sendToServer();
    	}else{
    		updatePollTest(percent_progress_bar);
			percent_progress_bar = null;
            clearInterval(interval_ID);
    	}

    }
	
    function updatePollTest(responseText){
		if (responseText == -1){
			$('#progress_bar').hide();
			clearInterval(interval_ID);
		}else{
		   if (parseInt(responseText) >= percent_progress_bar)
		    	updateProgress(responseText);
		}
    }
	
    function checkProgress(){
 		interval_ID = window.setInterval('pollTest()', 3000);
    }

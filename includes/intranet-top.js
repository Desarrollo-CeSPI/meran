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

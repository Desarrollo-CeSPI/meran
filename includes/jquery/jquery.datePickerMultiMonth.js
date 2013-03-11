/**
 * Copyright (c) 2008 Kelvin Luck (http://www.kelvinluck.com/)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) 
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 **/

(function($){
    
	$.fn.extend({
		datePickerMultiMonth : function(s)
		{
			s.numMonths = s.numMonths || 2;

			$(this).each(
				function()
				{

					var dps = $.extend({}, $.fn.datePicker.defaults, s);

					var $dpmm = $(this);
					var pickers = [];
					var basePicker;

					var m;
					
					if (s.inline) {

						$dpmm.html('');

						for (var i=0; i<s.numMonths; i++)
						{
							(function(i) {
								var first = i == 0;
								var last = i == s.numMonths - 1;
								var $date =  $('<div></div>')
												.datePicker(dps)
												.bind('dpMonthChanged',
													function(event, displayedMonth, displayedYear)
													{
														if (first) {
															$dpmm.trigger('dpMonthChanged', [displayedMonth, displayedYear]);
														} else {
															pickers[i-1].dpSetDisplayedMonth(displayedMonth-1, displayedYear);
														}
														if (!last)	{
															pickers[i+1].dpSetDisplayedMonth(displayedMonth+1, displayedYear);
														}
														return false;
													}
												)
												.bind(
													'dateSelected',
													function(event, date, $td, status)
													{
														if (first)	{
															$dpmm.trigger('dateSelected', [date, $td, status]);
														} else {
															pickers[i-1].dpSetSelected(date.asString(), status, false);
														}
														if (!last)	{
															pickers[i+1].dpSetSelected(date.asString(), status, false);
														}
														return false;
													}
												);
								$date.find('.dp-nav-prev').css('display', first ? 'block' : 'none');
								$date.find('.dp-nav-next').css('display', last ? 'block' : 'none');
								pickers.push($date);
								$dpmm.append($date);
							})(i);
						}
						basePicker = pickers[0];
						
					} else {
						
						var displayedMonth;
						var displayedYear;
						var selectedDate;

						if (dps.closeOnSelect == false) throw new Error("Popup multi month date pickers must close on select");
						if (dps.selectMultiple == true) throw new Error("Popup multi month date pickers aren't compatible with selectMultiple");

						$dpmm.datePicker(dps).bind(
							'dateSelected',
							function(event, date, $td, status)
							{
								selectedDate = date.asString();
							}
						).bind(
							'dpDisplayed',
							function(event, datePickerDiv)
							{
								var $popup = $(datePickerDiv).empty().css({width: 'auto'});

								var d = $dpmm.dpGetSelected();
								if (d.length) {
									selectedDate = new Date(d[0]).asString();
								}
								

								for (var i=0; i<s.numMonths; i++) {
									(function(i) {

										var s = $.extend({}, dps);
										s.inline = true;
										s.month = displayedMonth + i;
										s.year = displayedYear;
										
										var last = i == s.numMonths-1;
										var first = i == 0;

										var $dp = $('<div></div>');
										$popup.append($dp);


										$dp.datePicker(s).bind(
												'dpMonthChanged',
												function(event, newMonth, newYear)
												{
													if (i == 0)	{
														displayedMonth = newMonth;
														displayedYear = newYear;
													}
													if (!first) {
														pickers[i-1].dpSetDisplayedMonth(newMonth-1, newYear);
													}
													if (!last)	{
														pickers[i+1].dpSetDisplayedMonth(newMonth+1, newYear);
													}
													return false;
												}
											).bind(
												'dateSelected',
												function(event, date, $td, status)
												{
													var d = date.asString();
													if (d != selectedDate) {
														basePicker.dpSetSelected(date.asString());
														basePicker.dpClose();
													}
												}
											).find('.dp-nav-next').css('display', last ? 'block' : 'none').end()
											 .find('.dp-nav-prev').css('display', first ? 'block' : 'none').end();

										if (selectedDate) {
											$dp.dpSetSelected(selectedDate, true, false);
										}
										pickers.push($dp);
									})(i);
								}
							}
						).bind(
							'dpMonthChanged',
							function(event, newMonth, newYear)
							{
								displayedMonth = newMonth;
								displayedYear = newYear;
								$dpmm.trigger('dpMonthChanged', [newMonth, newYear])
							}
						).bind(
							'dpClosed',
							function(event, selected)
							{
								pickers = [];
							}
						);
						basePicker = $dpmm;
					}

					$dpmm.data('dpBasePicker', basePicker);
					$dpmm.data('dpPickers', pickers);

					// dodgy hack so that I can set the month to the correct value and trigger a redraw of the other elements... 
					basePicker.dpSetDisplayedMonth(1, 3000);
					// set the month to the correct value so the other date pickers get set to the correct months...
					basePicker.dpSetDisplayedMonth(Number(s.month), Number(s.year));
				}
			);
			return this;
		},
		dpmmGetSelected : function()
		{
			var basePicker = $(this).data('dpBasePicker');
			return basePicker.dpGetSelected();
		},
		dpmmSetSelected : function(d, v, m, e)
		{
			var basePicker = $(this).data('dpBasePicker');
			return basePicker.dpSetSelected(d, v, m, e);
		},
		dpmmRerenderCalendar : function()
		{
			var pickers = $(this).data('dpPickers');
			for (var i=0; i<pickers.length; i++) {
				pickers[i].dpRerenderCalendar();
			}
		}
	});
	
})(jQuery);
(function ($) {
    $.fn.tabletojson = function (options) {
        var defaults = {
            headers: null,  // add headers seperated by commas if you don't want to use headers in table
            attribHeaders: null,//if you pass in JSON like {'attribute name':'fieldname'} -
			//	"{'customerID':'CustomerID','orderID':'OrderID'}", the plugin will find these attributes
			// and build elements using the fieldname you indicate.
            returnElement: null,
            // if you add a hidden field id like e.g. 	
		    //$("#myTable").tabletojson({returnElement:'#myInputElement'})   
            //here then the chain won't be broken and the json will be dumped to myInputElement, 
            //else, this plugin will just return the json, e.g. var json = 
			//$("#myTable").tabletojson()     
            complete: null  //pass me a function and I'll dish you the json
        };

        var options = $.extend(defaults, options);
        var selector = this;
        var jsonRowItem = ""
        var jsonItem = new Array();
        var jsonRow = new Array();
        var heads = []
        var rowCounter = 1
        var comma = ",";
        var json = "";

        if (options.headers != null) {
            options.headers = options.headers.split(' ').join(''); 
			//this is in case you delimit like this ddd, dddd, ddddd instead of
            heads = options.headers.split(",");                    
			// ddd,dddd,ddddd,ddd  I gotta remove the spaces to make this work 
        }   //right.



        var rows = $(":not(tfoot) > tr", this).length;
        $(":not(tfoot) > tr", this).each(function (i, tr) {
            jsonRowItem = ""

            //use return to continue and return false to exit loop
            if (this.parentNode.tagName == "TFOOT") {
                return;  //we don't care about the footer so continue on...
            }
            if (this.parentNode.tagName == "THEAD") {
                if (options.headers == null) {  //if we don't indicate headers, then grab the actual headers in thead.
                    $('th', tr).each(function (i, th) {
                        heads[heads.length] = $(th).html()
                    });
                }
            }
            else {

                if (options.attribHeaders != null) {
                    var h = eval("(" + options.attribHeaders + ")");

                    for (z in h) {
                        heads[heads.length] = h[z];
                    }
                }

                rowCounter++
                //collect row stuuf
                var headCounter = 0
				
                jsonRowItem = "{"
                jsonItem.length = 0;
                $('td', tr).each(function (i, td) {
                    var re = /&nbsp;/gi
                   var v = $(td).html().replace(re, '')
//                    var v = $(this).children().val()
                    
//                     var v = $('td :text').text();
                    
                    jsonItem[jsonItem.length] = "\"" + heads[headCounter] + "\":\"" + v + "\"";
                    headCounter++

                });

                if (options.attribHeaders != null) {
                    for (z in h) {
                        jsonItem[jsonItem.length] = "\"" + heads[headCounter] + "\":\"" + tr[z] + "\"";
                        headCounter++
                    }
                }
                
                jsonRowItem += jsonItem.join(",");
                jsonRowItem += "}";
                jsonRow[jsonRow.length] = jsonRowItem;


            }

        });
        json += "[" + jsonRow.join(",") + "]"
        
        if (options.complete != null) {
            options.complete(json);
        }

        if (options.returnElement == null)
            return json;
        else {
            $(options.returnElement).val(json);
            return this;
        }

    }
})(jQuery)
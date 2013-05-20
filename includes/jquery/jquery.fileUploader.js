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

/*
 *
 *
*/
var fake_file = "fake_file";

function assignFileName(idInput){
  $("#"+idInput).val($("#myUploadFile").val());
}

; (function($) {


// FUNCION ORIGINAL
  
//     $.fn.extend({
//         fileUploader: function(options) { 
//         	opt = $.extend({}, $.uploadSetUp.defaults, options);
//             if (opt.file_types.match('jpg') && !opt.file_types.match('jpeg')) 
//             	opt.file_types += ',jpeg';
//             $this = $(this);
//             new $.uploadSetUp();
//         }
//     });


    $.fn.extend({
         fileUploader: function(options) { 
         opt = $.extend({}, $.uploadSetUp.defaults, options);
         if (opt.file_types.match('jpg') && !opt.file_types.match('jpeg')) {
                opt.file_types += ',jpeg';
                opt.file_types += ',gif';
         }
         if (opt.file_types.match('xls') && !opt.file_types.match('ods')) {
                opt.file_types += ',ods';
               
         }
         $this = $(this);
        
         new $.uploadSetUp();
      }
    });



    $.uploadSetUp = function() {
        $('body').append($('<div></div>').append($('<iframe src="about:blank" id="myFrame" name="myFrame" style="display: none;"></iframe>')));
        
         if(opt.type_file != "foto"){
              $this.append($('<form target="myFrame" enctype="multipart/form-data" action="' + opt.ajaxFile + '" method="post" name="myUploadForm" id="myUploadForm"></form>')
                  .append(
	   
                $('<input type="hidden" name="id_prov" value="' + opt.prov + '" />'),   
                          $('<input type="hidden" name="upload" value="' + opt.uploadFolder + '" />'),
                          $('<div class="select" title="Subir un presupuesto"></div>').append($(
                                '<div class="fileinputs">'+
                                          '<input id="myUploadFile" class="file" type="file" value="" name="planilla"/>'+
                                          '<div class="fakefile">'+
                                              '<input id="fake_file"/>'+
                                              '<img src='+imagesForJS+"/iconos/subir_foto.png"+' />'+
                                          '</div>'+
                                        '</div>')), 
                          $('<ul id="ul_files"></ul>'))
                      );
        
        } else {
              $this.append($('<form target="myFrame" enctype="multipart/form-data" action="' + opt.ajaxFile + '" method="post" name="myUploadForm" id="myUploadForm"></form>')
                .append(
                  $('<input type="hidden" name="nro_socio" value="' + opt.nro_socio + '" />'),	
                      $('<input type="hidden" name="upload" value="' + opt.uploadFolder + '" />'),
                      $('<div class="select" title="Subir una foto"></div>').append($(
                            '<div class="fileinputs">'+
                                      '<input id="myUploadFile" class="file" type="file" value="" name="picture"/>'+
                                      '<div class="fakefile">'+
                                          '<input id="fake_file"/>'+
                                          '<img src='+imagesForJS+"/iconos/subir_foto.png"+' />'+
                                      '</div>'+
                                    '</div>')), 
                      $('<ul id="ul_files"></ul>'))
                  );
            }
            init();
    };

    $.uploadSetUp.defaults = {
        // image types allowed
        // file_types: "jpg,gif,png",
        // perl script
        ajaxFile: "upload.pl",
        // absolute path for upload pictures folder (don't forget to chmod)
        // uploadFolder: "/ajaxMultiFileUpload/upload/"*/,
        // callback function
	funcionOnComplete: '',
    };

    
//  FUNCION ORIGINAL

//     $.uploadSetUp.defaults = {
//         // image types allowed 
//         file_types: "jpg,gif,png",
//         // perl script
//         ajaxFile: "upload.pl",
//         // absolute path for upload pictures folder (don't forget to chmod)
//         uploadFolder: "/ajaxMultiFileUpload/upload/",
//         // callback function
//     funcionOnComplete: '',
//     };
    
    
    function init() {

        // if file type is allowed, submit form
        $('#myUploadFile').livequery('change', function() {
        	if (checkFileType(this.value)) 
        		$('#myUploadForm').submit(); 
        });
        // execute event.submit when form is submitted
        $('#myUploadForm').submit(function() { 
        	return event.submit(this); 
        });
//         // delete uploaded file
//         $(".delete").livequery('click', function() {
//             // avoid duplicate function call
//             $(this).unbind('click');
//         });

        // function to handle form submission using iframe
        var event = {
            // setup iframe
            frame: function(_form) {
                $("#myFrame")
                	.empty()
                	.one('load',  function() { event.loaded(this, _form) });
            },
            // call event.submit after submit
            submit: function(_form) {
                assignFileName(fake_file);
                $('.select').addClass('waiting');
                event.frame(_form);
            },
            // llama a la funcion, luego de subir el archivo
	    loaded: function() {
			if(opt.funcionOnComplete){
				opt.funcionOnComplete();
			}
	    }
        };
        // check if file extension is allowed
        function checkFileType(file_) {
            var ext_ = file_.toLowerCase().substr(file_.toLowerCase().lastIndexOf('.') + 1);
            if (!opt.file_types.match(ext_)) {
                alert('tipo de archivo ' + ext_ + ' no permitido');
                return false;
            } 
            else return true;
        };
        // check type of iframe
        function frametype(fid) {
            return (fid.contentDocument) ? fid.contentDocument: (fid.contentWindow) ? fid.contentWindow.document: window.frames[fid].document;
        };

    }

})(jQuery);

<link href="/includes/jquery/datetimepicker/flora.datepicker.css" type="text/css" rel="stylesheet"> 

<script type="text/javascript" src="/includes/jquery/datetimepicker/ui.datepicker-min.js"></script>

<!-- Miguel agregue esta de abajo, es la de datepick -->


<script type="text/javascript">

    /* VARIABLES PARA EL datepick */
    
    dayNamesMin= [
                    "[% 'Do' | i18n %]",
                    "[% 'Lu' | i18n %]",
                    "[% 'Ma' | i18n %]",
                    "[% 'Mie' | i18n %]",
                    "[% 'Ju' | i18n %]",
                    "[% 'Vi' | i18n %]",
                    "[% 'Sa' | i18n %]",
                ];
    dayNames= [
                "[% 'Domingo' | i18n %]",
                "[% 'Lunes' | i18n %]",
                "[% 'Martes' | i18n %]",
                "[% 'Miercoles' | i18n %]",
                "[% 'Jueves' | i18n %]",
                "[% 'Viernes' | i18n %]",
                "[% 'Sabado' | i18n %]",
            ];
    
    monthNamesMin= [
                    "[% 'Ene' | i18n %]",
                    "[% 'Feb' | i18n %]",
                    "[% 'Mar' | i18n %]",
                    "[% 'Abr' | i18n %]",
                    "[% 'May' | i18n %]",
                    "[% 'Jun' | i18n %]",
                    "[% 'Jul' | i18n %]",
                    "[% 'Ago' | i18n %]",
                    "[% 'Sep' | i18n %]",
                    "[% 'Oct' | i18n %]",
                    "[% 'Nov' | i18n %]",
                    "[% 'Dic' | i18n %]",
                ];
    monthNames= [
                    "[% 'Enero' | i18n %]",
                    "[% 'Febrero' | i18n %]",
                    "[% 'Marzo' | i18n %]",
                    "[% 'Abril' | i18n %]",
                    "[% 'Mayo' | i18n %]",
                    "[% 'Junio' | i18n %]",
                    "[% 'Julio' | i18n %]",
                    "[% 'Agosto' | i18n %]",
                    "[% 'Septiembre' | i18n %]",
                    "[% 'Octubre' | i18n %]",
                    "[% 'Noviembre' | i18n %]",
                    "[% 'Diciembre' | i18n %]",
                ];

    function crearDatePicker(idElem){

            $('#'+idElem).datepick({  
                            monthNames: monthNames,
                            monthNamesShort: monthNamesMin,
                            dayNames: dayNames,
                            dayNamesShort: dayNamesMin,
                            dayNamesMin: dayNamesMin,
                            dateFormat: 'dd/mm/yyyy', firstDay: 0,
                            renderer: $.datepick.defaultRenderer,
                            prevText: '&#x3c;Ant', prevStatus: '',
                            prevJumpText: '&#x3c;&#x3c;', prevJumpStatus: '',
                            nextText: 'Sig&#x3e;', nextStatus: '',
                            nextJumpText: '&#x3e;&#x3e;', nextJumpStatus: '',
                            currentText: 'Hoy', currentStatus: '',
                            todayText: 'Hoy', todayStatus: '',
                            clearText: 'Limpiar', clearStatus: '',
                            closeText: 'Cerrar', closeStatus: '',
                            yearStatus: '', monthStatus: '',
                            weekText: 'Sm', weekStatus: '',
                            dayStatus: 'D, M d', defaultStatus: '',
                            isRTL: false
             });
    }


    function crearDatePickerMultiple(idElem,numMonths,numSelect,selectFunction){

            $('#'+idElem).datepick({  
                            monthNames: monthNames,
                            monthNamesShort: monthNamesMin,
                            dayNames: dayNames,
                            dayNamesShort: dayNamesMin,
                            dayNamesMin: dayNamesMin,
                            monthsToShow: numMonths,
                            monthsToStep: numMonths,
                            multiSelect: numSelect,
                            onSelect:selectFunction,
                            onDate: $.datepick.noWeekends,
                            dateFormat: 'dd/mm/yyyy', firstDay: 0,
                            renderer: $.datepick.defaultRenderer,
                            prevText: '&#x3c;Ant', prevStatus: '',
                            prevJumpText: '&#x3c;&#x3c;', prevJumpStatus: '',
                            nextText: 'Sig&#x3e;', nextStatus: '',
                            nextJumpText: '&#x3e;&#x3e;', nextJumpStatus: '',
                            currentText: 'Hoy', currentStatus: '',
                            todayText: 'Hoy', todayStatus: '',
                            clearText: 'Limpiar', clearStatus: '',
                            closeText: 'Cerrar', closeStatus: '',
                            yearStatus: '', monthStatus: '',
                            weekText: 'Sm', weekStatus: '',
                            dayStatus: 'D, M d', defaultStatus: '',
                            isRTL: false
            });
    }
</script>
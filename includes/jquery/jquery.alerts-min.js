function jAlert(message){bootbox.alert(message);}
function jConfirm(message,funcion){}
function jPrompt(mensaje,inputText,title,funcion){var result=prompt(mensaje,inputText);if(result)
funcion(result);}
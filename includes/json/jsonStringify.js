/*
JSONstring v 1.0
copyright 2006 Thomas Frank

This program is free software under the terms of the 
GNU General Public License version 2 as published by the Free 
Software Foundation. It is distributed without any warranty.


Based on Steve Yen's implementation:
http://trimpath.com/project/wiki/JsonLibrary
*/

JSONstring={
	compactOutput:false, 		
	includeProtos:false, 	
	includeFunctions: false,
	detectCirculars:true,
	restoreCirculars:true,
	debug: false,
	make:function(arg,restore) {
		this.restore=restore;
		this.mem=[];this.pathMem=[];
		return this.toJsonStringArray(arg).join('');
	},
	clearData:function(x){
		var temp = new String (x);
		//acentos ES áéíóú
		//acentos FR àèìòù
// TODO faltarian otros acentos
		//esto no se permite, segun lo que indica el patron
//		x =  temp.replace(/[\@áéíóúàèìòù|#;'?!¡¿ü]+/g,'');
// 		x =  temp.replace(/[\@|#;'?¿]+/g,'');

//      sacado por el ticket #3984. Comillas (') en AJAX
//        x =  temp.replace(/[|#;'\t]+/g,'');
//        x =  x.replace(/"/,'\"');
        x = encodeURIComponent(x);

		this.log("jsconStringify => clearData: "+x);
		return x;
	},
	log: function(str){
			if( (this.debug)&&(window.console) ){
					window.console.log(str);
			}
	},
	toObject:function(x){
		eval("this.myObj="+x);
		if(!this.restoreCirculars || !alert){return this.myObj};
		this.restoreCode=[];
		this.make(this.myObj,true);
		var r=this.restoreCode.join(";")+";";
		eval('r=r.replace(/\\W([0-9]{1,})(\\W)/g,"[$1]$2").replace(/\\.\\;/g,";")');
		eval(r);
		return this.myObj
	},
	toJsonStringArray:function(arg, out) {
		if(!out){this.path=[]};
		out = out || [];
		var u; // undefined
		switch (typeof arg) {
		case 'object':
			this.lastObj=arg;
			if(this.detectCirculars){
				var m=this.mem; var n=this.pathMem;
				for(var i=0;i<m.length;i++){
					if(arg===m[i]){
						out.push('"JSONcircRef:'+n[i]+'"');return out
					}
				};
				m.push(arg); n.push(this.path.join("."));
			};
			if (arg) {
				if (arg.constructor == Array) {
					out.push('[');
					for (var i = 0; i < arg.length; ++i) {
						this.path.push(i);
						if (i > 0)
							out.push(',\n');
						this.toJsonStringArray(arg[i], out);
						this.path.pop();
					}
					out.push(']');
					return out;
				} else if (typeof arg.toString != 'undefined') {
					out.push('{');
					var first = true;
					for (var i in arg) {
						if(!this.includeProtos && arg[i]===arg.constructor.prototype[i]){continue};
						this.path.push(i);
						var curr = out.length; 
						if (!first)
							out.push(this.compactOutput?',':',\n');
						this.toJsonStringArray(i, out);
						out.push(':');                    
						this.toJsonStringArray(arg[i], out);
						if (out[out.length - 1] == u)
							out.splice(curr, out.length - curr);
						else
							first = false;
						this.path.pop();
					}
					out.push('}');
					return out;
				}
				return out;
			}
			out.push('null');
			return out;
		case 'unknown':
		case 'undefined':
		case 'function':
			out.push(this.includeFunctions?arg:u);
			return out;
		case 'string':
			if(this.restore && arg.indexOf("JSONcircRef:")==0){
				this.restoreCode.push('this.myObj.'+this.path.join(".")+"="+arg.split("JSONcircRef:").join("this.myObj."));
			};
			out.push('"');
			var a=['\n','\\n','\r','\\r','"','\\"'];
			arg+=""; for(var i=0;i<6;i+=2){arg=arg.split(a[i]).join(a[i+1])};
// FIXME aca se puede filtrar XSS, falta verficar
 			arg= this.clearData(arg);
			out.push(arg);
			out.push('"');
			return out;
		default:
			out.push(String(arg));
			return out;
		}
	}
}

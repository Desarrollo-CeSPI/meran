(function(jQuery){this.version='(beta)(0.0.1)';this.maxSize=10;this.keys=new Array();this.cache_length=0;this.items=new Array();this.setItem=function(pKey,pValue)
{if(typeof(pValue)!='undefined')
{if(typeof(this.items[pKey])=='undefined')
{this.cache_length++;}
this.keys.push(pKey);this.items[pKey]=pValue;if(this.cache_length>this.maxSize)
{this.removeOldestItem();}}
return pValue;}
this.removeItem=function(pKey)
{var tmp;if(typeof(this.items[pKey])!='undefined')
{this.cache_length--;var tmp=this.items[pKey];delete this.items[pKey];}
return tmp;}
this.getItem=function(pKey)
{return this.items[pKey];}
this.hasItem=function(pKey)
{return typeof(this.items[pKey])!='undefined';}
this.removeOldestItem=function()
{this.removeItem(this.keys.shift());}
this.clear=function()
{var tmp=this.cache_length;this.keys=new Array();this.cache_length=0;this.items=new Array();return tmp;}
jQuery.jCache=this;return jQuery;})(jQuery);
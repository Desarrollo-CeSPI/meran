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
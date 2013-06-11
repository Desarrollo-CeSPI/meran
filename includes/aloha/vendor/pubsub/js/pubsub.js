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

define("PubSub",[],function(){var g={},e={},h=0;return{sub:function(a,d){if(typeof d!=="function")return-1;var c=g[a];c||(c=g[a]=[]);c.push(++h);e[h]={channel:a,callback:d};return h},unsub:function(a){if(-1===a||!e[a])return!1;var d=e[a]&&g[e[a].channel];delete e[a];for(var c=d.length;c;)if(d[--c]===a)return d.splice(c,1),!0;return!1},pub:function(a,d){var c=a.split("."),i,h=c.length,k="",l=0;for(i=0;i<h;++i){k+=(0===i?"":".")+c[i];var b;var f=k;b=d;if(g[f]){b?typeof b!=="object"&&(b={data:b}):
b={};b.channel=f;for(var f=g[f].concat(),j=void 0,j=0;j<f.length;++j)e[f[j]].callback(b);b=j}else b=0;l+=b}return l}}});

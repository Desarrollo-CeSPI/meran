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

jQuery.fn.highlight=function(pat){function innerHighlight(node,pat){var skip=0;if(node.nodeType==3){var pos=node.data.toUpperCase().indexOf(pat);if(pos>=0){var spannode=document.createElement('span');spannode.className='highlight';var middlebit=node.splitText(pos);var endbit=middlebit.splitText(pat.length);var middleclone=middlebit.cloneNode(true);spannode.appendChild(middleclone);middlebit.parentNode.replaceChild(spannode,middlebit);skip=1;}}
else if(node.nodeType==1&&node.childNodes&&!/(script|style)/i.test(node.tagName)){for(var i=0;i<node.childNodes.length;++i){i+=innerHighlight(node.childNodes[i],pat);}}
return skip;}
return this.each(function(){innerHighlight(this,pat.toUpperCase());});};jQuery.fn.removeHighlight=function(){return this.find("span.highlight").each(function(){this.parentNode.firstChild.nodeName;with(this.parentNode){replaceChild(this.firstChild,this);normalize();}}).end();};
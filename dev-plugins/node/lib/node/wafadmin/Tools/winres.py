#!/usr/bin/env python

# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.

# encoding: utf-8

# Meran - MERAN UNLP is a ILS (Integrated Library System) wich provides Catalog,
# Circulation and User's Management. It's written in Perl, and uses Apache2
# Web-Server, MySQL database and Sphinx 2 indexing.
# Copyright (C) 2009-2013 Grupo de desarrollo de Meran CeSPI-UNLP
#
# This file is part of Meran.
#
# Meran is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Meran is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Meran.  If not, see <http://www.gnu.org/licenses/>.

# Brant Young, 2007

"This hook is called when the class cpp/cc task generator encounters a '.rc' file: X{.rc -> [.res|.rc.o]}"

import os, sys, re
import TaskGen, Task
from Utils import quote_whitespace
from TaskGen import extension

EXT_WINRC = ['.rc']

winrc_str = '${WINRC} ${_CPPDEFFLAGS} ${_CCDEFFLAGS} ${WINRCFLAGS} ${_CPPINCFLAGS} ${_CCINCFLAGS} ${WINRC_TGT_F} ${TGT} ${WINRC_SRC_F} ${SRC}'

@extension(EXT_WINRC)
def rc_file(self, node):
	obj_ext = '.rc.o'
	if self.env['WINRC_TGT_F'] == '/fo': obj_ext = '.res'

	rctask = self.create_task('winrc', node, node.change_ext(obj_ext))
	self.compiled_tasks.append(rctask)

# create our action, for use with rc file
Task.simple_task_type('winrc', winrc_str, color='BLUE', before='cc cxx', shell=False)

def detect(conf):
	v = conf.env

	winrc = v['WINRC']
	v['WINRC_TGT_F'] = '-o'
	v['WINRC_SRC_F'] = '-i'
	# find rc.exe
	if not winrc:
		if v['CC_NAME'] in ['gcc', 'cc', 'g++', 'c++']:
			winrc = conf.find_program('windres', var='WINRC', path_list = v['PATH'])
		elif v['CC_NAME'] == 'msvc':
			winrc = conf.find_program('RC', var='WINRC', path_list = v['PATH'])
			v['WINRC_TGT_F'] = '/fo'
			v['WINRC_SRC_F'] = ''
	if not winrc:
		conf.fatal('winrc was not found!')

	v['WINRCFLAGS'] = ''
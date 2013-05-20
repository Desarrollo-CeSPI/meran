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

# Thomas Nagy, 2008 (ita)

"as and gas"

import os, sys
import Task
from TaskGen import extension, taskgen, after, before

EXT_ASM = ['.s', '.S', '.asm', '.ASM', '.spp', '.SPP']

as_str = '${AS} ${ASFLAGS} ${_ASINCFLAGS} ${SRC} -o ${TGT}'
Task.simple_task_type('asm', as_str, 'PINK', ext_out='.o', shell=False)

@extension(EXT_ASM)
def asm_hook(self, node):
	# create the compilation task: cpp or cc
	try: obj_ext = self.obj_ext
	except AttributeError: obj_ext = '_%d.o' % self.idx

	task = self.create_task('asm', node, node.change_ext(obj_ext))
	self.compiled_tasks.append(task)
	self.meths.append('asm_incflags')

@after('apply_obj_vars_cc')
@after('apply_obj_vars_cxx')
@before('apply_link')
def asm_incflags(self):
	self.env.append_value('_ASINCFLAGS', self.env.ASINCFLAGS)
	var = ('cxx' in self.features) and 'CXX' or 'CC'
	self.env.append_value('_ASINCFLAGS', self.env['_%sINCFLAGS' % var])

def detect(conf):
	conf.find_program(['gas', 'as'], var='AS')
	if not conf.env.AS: conf.env.AS = conf.env.CC
	#conf.env.ASFLAGS = ['-c'] <- may be necesary for .S files
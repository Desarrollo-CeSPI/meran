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

# Stian Selnes, 2008
# Thomas Nagy 2009

import os, sys
import Configure, Options, Utils
import ccroot, ar, gcc
from Configure import conftest

@conftest
def find_icc(conf):
	if sys.platform == 'cygwin':
		conf.fatal('The Intel compiler does not work on Cygwin')

	v = conf.env
	cc = None
	if v['CC']: cc = v['CC']
	elif 'CC' in conf.environ: cc = conf.environ['CC']
	if not cc: cc = conf.find_program('icc', var='CC')
	if not cc: cc = conf.find_program('ICL', var='CC')
	if not cc: conf.fatal('Intel C Compiler (icc) was not found')
	cc = conf.cmd_to_list(cc)

	ccroot.get_cc_version(conf, cc, icc=True)
	v['CC'] = cc
	v['CC_NAME'] = 'icc'

detect = '''
find_icc
find_ar
gcc_common_flags
gcc_modifier_platform
cc_load_tools
cc_add_flags
link_add_flags
'''
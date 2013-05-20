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

# Carlos Rafael Giani, 2007 (dv)

import sys
import Utils, ar
from Configure import conftest

@conftest
def find_gdc(conf):
	conf.find_program('gdc', var='D_COMPILER', mandatory=True)

@conftest
def common_flags_gdc(conf):
	v = conf.env

	# _DFLAGS _DIMPORTFLAGS

	# for mory info about the meaning of this dict see dmd.py
	v['DFLAGS']            = []

	v['D_SRC_F']           = ''
	v['D_TGT_F']           = ['-c', '-o', '']
	v['DPATH_ST']          = '-I%s' # template for adding import paths

	# linker
	v['D_LINKER']          = v['D_COMPILER']
	v['DLNK_SRC_F']        = ''
	v['DLNK_TGT_F']        = ['-o', '']

	v['DLIB_ST']           = '-l%s' # template for adding libs
	v['DLIBPATH_ST']       = '-L%s' # template for adding libpaths

	# debug levels
	v['DLINKFLAGS']        = []
	v['DFLAGS_OPTIMIZED']  = ['-O3']
	v['DFLAGS_DEBUG']      = ['-O0']
	v['DFLAGS_ULTRADEBUG'] = ['-O0']

	v['D_shlib_DFLAGS']    = []
	v['D_shlib_LINKFLAGS'] = ['-shared']

	v['DHEADER_ext']       = '.di'
	v['D_HDR_F']           = '-fintfc -fintfc-file='

def detect(conf):
	conf.find_gdc()
	conf.check_tool('ar')
	conf.check_tool('d')
	conf.common_flags_gdc()
	conf.d_platform_flags()
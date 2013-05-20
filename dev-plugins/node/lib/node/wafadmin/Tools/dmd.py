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
# Thomas Nagy, 2008 (ita)

import sys
import Utils, ar
from Configure import conftest

@conftest
def find_dmd(conf):
	conf.find_program(['dmd', 'ldc'], var='D_COMPILER', mandatory=True)

@conftest
def common_flags_ldc(conf):
	v = conf.env
	v['DFLAGS']         = ['-d-version=Posix']
	v['DLINKFLAGS']     = []
	v['D_shlib_DFLAGS'] = ['-relocation-model=pic']

@conftest
def common_flags_dmd(conf):
	v = conf.env

	# _DFLAGS _DIMPORTFLAGS

	# Compiler is dmd so 'gdc' part will be ignored, just
	# ensure key is there, so wscript can append flags to it
	v['DFLAGS']            = ['-version=Posix']

	v['D_SRC_F']           = ''
	v['D_TGT_F']           = ['-c', '-of']
	v['DPATH_ST']          = '-I%s' # template for adding import paths

	# linker
	v['D_LINKER']          = v['D_COMPILER']
	v['DLNK_SRC_F']        = ''
	v['DLNK_TGT_F']        = '-of'

	v['DLIB_ST']           = '-L-l%s' # template for adding libs
	v['DLIBPATH_ST']       = '-L-L%s' # template for adding libpaths

	# linker debug levels
	v['DFLAGS_OPTIMIZED']  = ['-O']
	v['DFLAGS_DEBUG']      = ['-g', '-debug']
	v['DFLAGS_ULTRADEBUG'] = ['-g', '-debug']
	v['DLINKFLAGS']        = ['-quiet']

	v['D_shlib_DFLAGS']    = ['-fPIC']
	v['D_shlib_LINKFLAGS'] = ['-L-shared']

	v['DHEADER_ext']       = '.di'
	v['D_HDR_F']           = ['-H', '-Hf']

def detect(conf):
	conf.find_dmd()
	conf.check_tool('ar')
	conf.check_tool('d')
	conf.common_flags_dmd()
	conf.d_platform_flags()

	if conf.env.D_COMPILER.find('ldc') > -1:
		conf.common_flags_ldc()
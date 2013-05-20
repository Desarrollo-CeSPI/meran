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

# Thomas Nagy, 2006 (ita)
# Ralf Habacker, 2006 (rh)

import os, optparse
import Utils, Options, Configure
import ccroot, ar
from Configure import conftest

@conftest
def find_sxx(conf):
	v = conf.env
	cc = None
	if v['CXX']: cc = v['CXX']
	elif 'CXX' in conf.environ: cc = conf.environ['CXX']
	if not cc: cc = conf.find_program('c++', var='CXX')
	if not cc: conf.fatal('sunc++ was not found')
	cc = conf.cmd_to_list(cc)

	try:
		if not Utils.cmd_output(cc + ['-flags']):
			conf.fatal('sunc++ %r was not found' % cc)
	except ValueError:
		conf.fatal('sunc++ -flags could not be executed')

	v['CXX']  = cc
	v['CXX_NAME'] = 'sun'

@conftest
def sxx_common_flags(conf):
	v = conf.env

	# CPPFLAGS CXXDEFINES _CXXINCFLAGS _CXXDEFFLAGS

	v['CXX_SRC_F']           = ''
	v['CXX_TGT_F']           = ['-c', '-o', '']
	v['CPPPATH_ST']          = '-I%s' # template for adding include paths

	# linker
	if not v['LINK_CXX']: v['LINK_CXX'] = v['CXX']
	v['CXXLNK_SRC_F']        = ''
	v['CXXLNK_TGT_F']        = ['-o', ''] # solaris hack, separate the -o from the target

	v['LIB_ST']              = '-l%s' # template for adding libs
	v['LIBPATH_ST']          = '-L%s' # template for adding libpaths
	v['STATICLIB_ST']        = '-l%s'
	v['STATICLIBPATH_ST']    = '-L%s'
	v['CXXDEFINES_ST']       = '-D%s'

	v['SONAME_ST']           = '-Wl,-h -Wl,%s'
	v['SHLIB_MARKER']        = '-Bdynamic'
	v['STATICLIB_MARKER']    = '-Bstatic'

	# program
	v['program_PATTERN']     = '%s'

	# shared library
	v['shlib_CXXFLAGS']      = ['-Kpic', '-DPIC']
	v['shlib_LINKFLAGS']     = ['-G']
	v['shlib_PATTERN']       = 'lib%s.so'

	# static lib
	v['staticlib_LINKFLAGS'] = ['-Bstatic']
	v['staticlib_PATTERN']   = 'lib%s.a'

detect = '''
find_sxx
find_cpp
find_ar
sxx_common_flags
cxx_load_tools
cxx_add_flags
'''
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

# Thomas Nagy, 2006-2008 (ita)
# Ralf Habacker, 2006 (rh)
# Yinon Ehrlich, 2009
# Michael Kuhn, 2009

import os, sys
import Configure, Options, Utils
import ccroot, ar
from Configure import conftest

@conftest
def find_xlc(conf):
	cc = conf.find_program(['xlc_r', 'xlc'], var='CC', mandatory=True)
	cc = conf.cmd_to_list(cc)
	conf.env.CC_NAME = 'xlc'
	conf.env.CC      = cc

@conftest
def find_cpp(conf):
	v = conf.env
	cpp = None
	if v['CPP']: cpp = v['CPP']
	elif 'CPP' in conf.environ: cpp = conf.environ['CPP']
	if not cpp: cpp = v['CC']
	v['CPP'] = cpp

@conftest
def xlc_common_flags(conf):
	v = conf.env

	# CPPFLAGS CCDEFINES _CCINCFLAGS _CCDEFFLAGS
	v['CCFLAGS_DEBUG'] = ['-g']
	v['CCFLAGS_RELEASE'] = ['-O2']

	v['CC_SRC_F']            = ''
	v['CC_TGT_F']            = ['-c', '-o', ''] # shell hack for -MD
	v['CPPPATH_ST']          = '-I%s' # template for adding include paths

	# linker
	if not v['LINK_CC']: v['LINK_CC'] = v['CC']
	v['CCLNK_SRC_F']         = ''
	v['CCLNK_TGT_F']         = ['-o', ''] # shell hack for -MD

	v['LIB_ST']              = '-l%s' # template for adding libs
	v['LIBPATH_ST']          = '-L%s' # template for adding libpaths
	v['STATICLIB_ST']        = '-l%s'
	v['STATICLIBPATH_ST']    = '-L%s'
	v['RPATH_ST']            = '-Wl,-rpath,%s'
	v['CCDEFINES_ST']        = '-D%s'

	v['SONAME_ST']           = ''
	v['SHLIB_MARKER']        = ''
	v['STATICLIB_MARKER']    = ''
	v['FULLSTATIC_MARKER']   = '-static'

	# program
	v['program_LINKFLAGS']   = ['-Wl,-brtl']
	v['program_PATTERN']     = '%s'

	# shared library
	v['shlib_CCFLAGS']       = ['-fPIC', '-DPIC'] # avoid using -DPIC, -fPIC aleady defines the __PIC__ macro
	v['shlib_LINKFLAGS']     = ['-G', '-Wl,-brtl,-bexpfull']
	v['shlib_PATTERN']       = 'lib%s.so'

	# static lib
	v['staticlib_LINKFLAGS'] = ''
	v['staticlib_PATTERN']   = 'lib%s.a'

def detect(conf):
	conf.find_xlc()
	conf.find_cpp()
	conf.find_ar()
	conf.xlc_common_flags()
	conf.cc_load_tools()
	conf.cc_add_flags()
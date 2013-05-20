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

# Matthias Jahn jahn dôt matthias ât freenet dôt de, 2007 (pmarat)

import os, sys, imp, types, ccroot
import optparse
import Utils, Configure, Options
from Logs import debug

c_compiler = {
	'win32':  ['gcc'],
	'cygwin': ['gcc'],
	'darwin': ['gcc'],
	'aix':    ['xlc', 'gcc'],
	'linux':  ['gcc', 'icc', 'suncc'],
	'sunos':  ['gcc', 'suncc'],
	'irix':   ['gcc'],
	'hpux':   ['gcc'],
	'default': ['gcc']
}

def __list_possible_compiler(platform):
	try:
		return c_compiler[platform]
	except KeyError:
		return c_compiler["default"]

def detect(conf):
	"""
	for each compiler for the platform, try to configure the compiler
	in theory the tools should raise a configuration error if the compiler
	pretends to be something it is not (setting CC=icc and trying to configure gcc)
	"""
	try: test_for_compiler = Options.options.check_c_compiler
	except AttributeError: conf.fatal("Add set_options(opt): opt.tool_options('compiler_cc')")
	orig = conf.env
	for compiler in test_for_compiler.split():
		conf.env = orig.copy()
		try:
			conf.check_tool(compiler)
		except Configure.ConfigurationError, e:
			debug('compiler_cc: %r' % e)
		else:
			if conf.env['CC']:
				orig.table = conf.env.get_merged_dict()
				conf.env = orig
				conf.check_message(compiler, '', True)
				conf.env['COMPILER_CC'] = compiler
				break
			conf.check_message(compiler, '', False)
			break
	else:
		conf.fatal('could not configure a c compiler!')

def set_options(opt):
	build_platform = Utils.unversioned_sys_platform()
	possible_compiler_list = __list_possible_compiler(build_platform)
	test_for_compiler = ' '.join(possible_compiler_list)
	cc_compiler_opts = opt.add_option_group("C Compiler Options")
	cc_compiler_opts.add_option('--check-c-compiler', default="%s" % test_for_compiler,
		help='On this platform (%s) the following C-Compiler will be checked by default: "%s"' % (build_platform, test_for_compiler),
		dest="check_c_compiler")

	for c_compiler in test_for_compiler.split():
		opt.tool_options('%s' % c_compiler, option_group=cc_compiler_opts)
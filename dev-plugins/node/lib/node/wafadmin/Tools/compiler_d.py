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

import os, sys, imp, types
import Utils, Configure, Options

def detect(conf):
	if getattr(Options.options, 'check_dmd_first', None):
		test_for_compiler = ['dmd', 'gdc']
	else:
		test_for_compiler = ['gdc', 'dmd']

	for d_compiler in test_for_compiler:
		try:
			conf.check_tool(d_compiler)
		except:
			pass
		else:
			break
	else:
		conf.fatal('no suitable d compiler was found')

def set_options(opt):
	d_compiler_opts = opt.add_option_group('D Compiler Options')
	d_compiler_opts.add_option('--check-dmd-first', action='store_true',
			help='checks for the gdc compiler before dmd (default is the other way round)',
			dest='check_dmd_first',
			default=False)

	for d_compiler in ['gdc', 'dmd']:
		opt.tool_options('%s' % d_compiler, option_group=d_compiler_opts)
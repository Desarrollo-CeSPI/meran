
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

import os
import TaskGen, Utils, Utils, Runner, Options, Build
from TaskGen import extension, taskgen, before, after, feature
from Configure import conf, conftest

@taskgen
@before('apply_incpaths', 'apply_lib_vars', 'apply_type_vars')
@feature('node_addon')
@before('apply_bundle')
def init_node_addon(self):
	self.default_install_path = self.env['NODE_PATH']
	self.uselib = self.to_list(getattr(self, 'uselib', ''))
	if not 'NODE' in self.uselib: self.uselib.append('NODE')
	self.env['MACBUNDLE'] = True

@taskgen
@before('apply_link', 'apply_lib_vars', 'apply_type_vars')
@after('apply_bundle')
@feature('node_addon')
def node_addon_shlib_ext(self):
	self.env['shlib_PATTERN'] = "%s.node"

def detect(conf):
  join = os.path.join

  conf.env['PREFIX_NODE'] = get_prefix()
  prefix = conf.env['PREFIX_NODE']
  lib = join(prefix, 'lib')

  conf.env['LIBPATH_NODE'] = lib
  conf.env['CPPPATH_NODE'] = join(prefix, 'include', 'node')

  conf.env.append_value('CPPFLAGS_NODE', '-D_GNU_SOURCE')

  conf.env.append_value('CCFLAGS_NODE', '-D_LARGEFILE_SOURCE')
  conf.env.append_value('CCFLAGS_NODE', '-D_FILE_OFFSET_BITS=64')

  conf.env.append_value('CXXFLAGS_NODE', '-D_LARGEFILE_SOURCE')
  conf.env.append_value('CXXFLAGS_NODE', '-D_FILE_OFFSET_BITS=64')

  # with symbols
  conf.env.append_value('CCFLAGS', ['-g'])
  conf.env.append_value('CXXFLAGS', ['-g'])
  # install path
  conf.env['NODE_PATH'] = get_node_path()
  # this changes the install path of cxx task_gen
  conf.env['LIBDIR'] = conf.env['NODE_PATH']

  found = os.path.exists(conf.env['NODE_PATH'])
  conf.check_message('node path', '', found, conf.env['NODE_PATH'])

  found = os.path.exists(join(prefix, 'bin', 'node'))
  conf.check_message('node prefix', '', found, prefix)

  ## On Cygwin we need to link to the generated symbol definitions
  if Options.platform.startswith('cygwin'): conf.env['LIB_NODE'] = 'node'

  ## On Mac OSX we need to use mac bundles
  if Options.platform == 'darwin': conf.check_tool('osx')

def get_node_path():
    join = os.path.join
    nodePath = None
    if not os.environ.has_key('NODE_PATH'):
        if not os.environ.has_key('HOME'):
            nodePath = join(get_prefix(), 'lib', 'node')
        else:
            nodePath = join(os.environ['HOME'], '.node_libraries')
    else:
        nodePath = os.environ['NODE_PATH']
    return nodePath

def get_prefix():
    prefix = None
    if not os.environ.has_key('PREFIX_NODE'):
        prefix = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..', '..'))
    else:
        prefix = os.environ['PREFIX_NODE']
    return prefix
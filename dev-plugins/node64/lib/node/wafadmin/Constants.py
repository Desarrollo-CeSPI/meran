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

# Yinon dot me gmail 2008

"""
these constants are somewhat public, try not to mess them

maintainer: the version number is updated from the top-level wscript file
"""

# do not touch these three lines, they are updated automatically
HEXVERSION=0x105016
WAFVERSION="1.5.16"
WAFREVISION = "7610:7647M"
ABI = 7

# permissions
O644 = 420
O755 = 493

MAXJOBS = 99999999

CACHE_DIR          = 'c4che'
CACHE_SUFFIX       = '.cache.py'
DBFILE             = '.wafpickle-%d' % ABI
WSCRIPT_FILE       = 'wscript'
WSCRIPT_BUILD_FILE = 'wscript_build'
WAF_CONFIG_LOG     = 'config.log'
WAF_CONFIG_H       = 'config.h'

SIG_NIL = 'iluvcuteoverload'

VARIANT = '_VARIANT_'
DEFAULT = 'Release'

SRCDIR  = 'srcdir'
BLDDIR  = 'blddir'
APPNAME = 'APPNAME'
VERSION = 'VERSION'

DEFINES = 'defines'
UNDEFINED = ()

BREAK = "break"
CONTINUE = "continue"

# task scheduler options
JOBCONTROL = "JOBCONTROL"
MAXPARALLEL = "MAXPARALLEL"
NORMAL = "NORMAL"

# task state
NOT_RUN = 0
MISSING = 1
CRASHED = 2
EXCEPTION = 3
SKIPPED = 8
SUCCESS = 9

ASK_LATER = -1
SKIP_ME = -2
RUN_ME = -3


LOG_FORMAT = "%(asctime)s %(c1)s%(zone)s%(c2)s %(message)s"
HOUR_FORMAT = "%H:%M:%S"

TEST_OK = True

CFG_FILES = 'cfg_files'

# positive '->' install
# negative '<-' uninstall
INSTALL = 1337
UNINSTALL = -1337
# *****************************************************************************
# *****************************************************************************
#
#   installDirs.bash
#
# *****************************************************************************
#
# @author Jay Wheeler.
# @version 0.0.3
# @copyright © 2016, 2017, 2018. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package lms-bash
# @subpackage tests
#
# *****************************************************************************
#
#	Copyright © 2016, 2017, 2018. EarthWalk Software
#	Licensed under the GNU General Public License, GPL-3.0-or-later.
#
#   This file is part of ewsdocker/lms-bash.
#
#   ewsdocker/lms-bash is free software: you can redistribute 
#   it and/or modify it under the terms of the GNU General Public License 
#   as published by the Free Software Foundation, either version 3 of the 
#   License, or (at your option) any later version.
#
#   ewsdocker/lms-bash is distributed in the hope that it will 
#   be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
#   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with ewsdocker/lms-bash.  If not, see 
#   <http://www.gnu.org/licenses/>.
#
# *****************************************************************************
#
#			Version 0.0.1 - 02-24-2016.
#					0.0.2 - 01-24-2017.
#			        0.0.3 - 08-24-2018.
#
# *****************************************************************************
# *****************************************************************************

declare    lmslib_bashRelease="0.1.2"
declare    lmsbase_prefix="/lms-base-${lmslib_bashRelease}"
declare    lmsbase_dirBase="/usr/local"

declare    lmsbase_bash="LMS/Bash"
declare    lmsbase_bashRelease="${lmsbase_bash}-${lmslib_bashRelease}"

declare    lmsbase_dirEtc="etc"
declare    lmsbase_dirLib="lib"
declare    lmsbase_dirShare="share"
declare    lmsbase_dirBin="bin"
declare    lmsbase_dirTests="tests"

declare    lmsbase_dirAppSrc=""
declare    lmsbase_dirApplication=""

# *****************************************************************************

lmsbase_dirBase="${lmsbase_prefix}${lmsbase_dirBase}"

lmsbase_dirBash="${lmsbase_dirBase}/share${lmsbase_bash}"
lmsbase_dirRelease="${lmsbase_bashRelease}"

lmsbase_dirEtc="${lmsbase_dirBase}/etc/${lmsbase_bashRelease}"
lmsbase_dirLib="${lmsbase_dirBase}/lib/${lmsbase_bashRelease}"

lmsbase_dirAppLog="/var/local/log/${lmsbase_bashRelease}/test"

lmsbase_dirAppSrc="${lmsbase_dirRelease}/test"
lmsbase_dirApplication="${lmsbase_dirAppSrc}/${lmsapp_name}"
lmsbase_dirAppLib="${lmsbase_dirAppSrc}/testlib"

# *****************************************************************************
# *****************************************************************************

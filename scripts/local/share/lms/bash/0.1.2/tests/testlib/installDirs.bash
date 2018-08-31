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

declare    lmsbase_development=1
declare    lmsbase_container=1

declare    lmsbase_prefix="/lms-base-${lmslib_release}"
declare    lmsbase_lmsbash="LMS/Bash"
declare    lmsbase_release="${lmsbase_lmsbash}/${lmslib_release}"

declare    lmsbase_dirBase="usr/local"

declare    lmsbase_dirEtc="etc"
declare    lmsbase_dirLib="lib"
declare    lmsbase_dirShare="share"
declare    lmsbase_dirBin="bin"
declare    lmsbase_dirTests="tests"

declare    lmsbase_dirAppSrc=""
declare    lmsbase_dirApplication=""

# *****************************************************************************

if [[ ${lmsbase_development} -eq 0 || ${lmsbase_container} -ne 0 ]]
then
	lmsbase_dirBase="${lmsbase_prefix}/${lmsbase_dirBase}"

	lmsbase_dirBash="${lmsbase_dirBase}/share/${lmsbase_lmsbash}"
	lmsbase_dirRelease="${lmsbase_release}"

	lmsbase_dirEtc="${lmsbase_dirBase}/etc/${lmsbase_release}"
	lmsbase_dirLib="${lmsbase_dirBase}/lib/${lmsbase_release}"
else
	lmsbase_dirBase=${PWD%"/$lmslib_release"*}

	lmsbase_dirBash="${lmsbase_dirBase}"
	lmsbase_dirRelease="${lmsbase_dirBash}/${lmslib_release}"

	lmsbase_dirEtc="${lmsbase_dirRelease}/etc"
	lmsbase_dirLib="${lmsbase_dirRelease}/lib"
fi

lmsbase_dirAppLog="/var/local/log/${lmsbase_release}/test"

lmsbase_dirAppSrc="${lmsbase_dirRelease}/test"
lmsbase_dirApplication="${lmsbase_dirAppSrc}/${lmsapp_name}"
lmsbase_dirAppLib="${lmsbase_dirAppSrc}/testlib"

# *****************************************************************************
# *****************************************************************************

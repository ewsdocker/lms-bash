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

lmsbase_prefix="lms-base-${lmslib_release}"
lmsbase_development=1
lmsbase_container=1

if [[ ${lmsbase_development} -eq 0 || lmsbase_container -ne 0 ]]
then
	dirRoot="/usr/local"

	[[ lmsbase_container -ne 0 ]] && dirRoot="${lmsbase_prefix}${dirRoot}"

	dirBash="${dirRoot}/share/LMS/Bash"
	dirRelease="${dirBash}/${lmslib_release}"

	dirAppLog="/var/local/log/LMS/Bash/${lmslib_release}/test"

	dirAppSrc="${dirRelease}/test"

	dirEtc="${dirRoot}/etc/LMS/Bash/${lmslib_release}"
	dirLib="${dirRoot}/lib/LMS/Bash/${lmslib_release}"
else
	dirRoot=${PWD%"/$lmslib_release"*}

	dirBash="${dirRoot}"
	dirRelease="${dirBash}/${lmslib_release}"

	dirAppLog="/var/local/log/LMS/Bash/${lmslib_release}/test"

	dirAppSrc="${dirRelease}/test"

	dirEtc="${dirRelease}/etc"
	dirLib="${dirRelease}/lib"
fi

dirSource="${dirAppSrc}/${lmsapp_name}"
dirAppLib="${dirAppSrc}/testlib"

# *****************************************************************************
# *****************************************************************************

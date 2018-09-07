# ***********************************************************************************************************
# ***********************************************************************************************************
#
#   lmsStr.sh
#
# *****************************************************************************
#
# @author Jay Wheeler.
# @version 0.2.0
# @copyright © 2016, 2017, 2018. EarthWalk Software.
# @license Licensed under the GNU General Public License, GPL-3.0-or-later.
# @package Linux Management Scripts
# @subpackage lmsString
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
#			Version 0.0.1 - 02-29-2016.
#					0.0.2 - 06-15-2016.
#					0.0.3 - 06-26-2016.
#
#					0.1.0 - 08-26-2016.
#					0.1.1 - 01-13-2017.
#					0.1.2 - 02-08-2017.
#					0.1.3 - 02-12-2017.
#					0.1.4 - 02-15-2017.
#
#					0.2.0 - 08-25-2018.
#
# ***********************************************************************************************************
# ***********************************************************************************************************

declare -r lmslib_lmsStr="0.2.0"	# version of library

# ***********************************************************************************************************

declare    lmsstr_Trimmed=""			# a place to store lmsstr_Trimmed string
declare    lmsstr_Unquoted=""			#
declare -a lmsstr_Exploded=()			# exploded string array
declare -a lmsstr_split=()				# split string array

# ***********************************************************************************************************
#
#    lmsStrTrim
#
#		lmsStrTrim leading and trailing blanks
#
#	parameters:
#		string = the string to lmsStrTrim
#		result = (optional) location to place the lmsstr_Trimmed string
#
#	returns:
#		places the result in the global variable: lmsstr_Trimmed
#
#	Example:
#
#		string="  a string with   enclosed  blanks  "
#       result=""
#
#		lmsStrTrim "${string}" result
#
# ***********************************************************************************************************
function lmsStrTrim()
{
	local string=${1}

	string="${string#"${string%%[![:space:]]*}"}"   # remove leading whitespace characters
	lmsstr_Trimmed="${string%"${string##*[![:space:]]}"}"   # remove trailing whitespace characters

	[[ -n "$2" ]] &&
	 {
		eval "$2"='$'"{lmsstr_Trimmed}"
	 }
}

# ***********************************************************************************************************
#
#    lmsStrTrimBetween
#
#		lmsStrTrim leading chars through the leading char and trailing chars from
#			the trailing chars
#
#	parameters:
#		string = the string to lmsStrTrim
#		result = (optional) location to place the lmsstr_Trimmed string
#
#	returns:
#		places the result in the global variable: lmsstr_Trimmed
#
# ***********************************************************************************************************
function lmsStrTrimBetween()
{
	local string="${1}"
	local var=$2

	local start="${3}"
	local end="${4}"

	local buffer

	buffer="${string#*${start}}"
	buffer="${buffer%${end}*}"

	eval "$var"='$'"{buffer}"
}

# ***********************************************************************************************************
#
#    lmsStrUnquote
#
#		remove leading and trailing quotes
#
#	parameters:
#		string = the string to lmsStrUnquote
#		result = (optional) location to place the lmsstr_Unquoted string
#
#	returns:
#		places the result in the global variable: lmsstr_Unquoted
#
# ***********************************************************************************************************
function lmsStrUnquote()
{
	local quoted=${1}

	lmsstr_Unquoted="${quoted%\"}"
	lmsstr_Unquoted="${lmsstr_Unquoted#\"}"

	[[ -n "$2" ]] &&
	{
		lmsDeclareStr $2 "${lmsstr_Unquoted}"
		[[ $? -eq 0 ]] || return 1
	}

	return 0
}

# ***********************************************************************************************************
#
#	lmsStrSplit
#
#		Splits a string into name and value at the specified seperator character
#
#	attributes:
#		string = string to split
#		parameter = parameter name
#		option = option information
#		separator = (optional) parameter-option separator, defaults to '='
#
#	returns:
#		0 = no error
#		1 = unable to declare parameter
#		2 = unable to declare option
#
# ***********************************************************************************************************
function lmsStrSplit()
{
	local -a strSplit=()
	local    option=""

	lmsStrExplode ${1} ${4:-"="} strSplit
	[[ ${#strSplit[@]} -ne 2 ]] &&
	 {
		lmsDeclareStr ${2} "${1}"
		[[ $? -eq 0 ]] || return $?

		lmsDeclareStr ${3} ""
		return $?
	 }

	lmsDeclareStr ${2} "${strSplit[0]}"
	[[ $? -eq 0 ]] || return 1

	lmsStrUnquote "${strSplit[1]}" option

	lmsDeclareStr ${3} "${option}"
	[[ $? -eq 0 ]] || return 2

	return 0
}

# ***********************************************************************************************************
#
#	lmsStrExplode
#
#		explodes a string into an array of lines split at the specified seperator
#
#	attributes:
#		string = string to explode
#		separator = (optional) parameter-option separator, defaults to ' '
#		copy = (optional) location (array) to copy the exploded data
#
#	places the result in the global array variable: lmsstr_Exploded or optionally in the passed array variable
#
#	returns:
#		result = 0 (no error)
#
# ***********************************************************************************************************
function lmsStrExplode()
{
	local xBuffer="${1}"
	local separator=${2:-" "}

	OIFS="$IFS"
	IFS=$separator

	if [[ -z "${3}" ]]
	then
		read -a lmsstr_Exploded <<< "${xBuffer}"
	else
		read -a ${3} <<< "${xBuffer}"
	fi

	IFS="$OIFS"
	return 0
}

# ***********************************************************************************************************
#
#	lmsStrToLower
#
#		converts a string into all lower-case printable characters
#
#	attributes:
#		string = string to convert
#
#	outputs:
#		string = converted string
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# ***********************************************************************************************************
function lmsStrToLower()
{
    local string=$( echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/" )
    echo "${string}"

	return 0
}

# ***********************************************************************************************************
#
#	lmsStrToUpper
#
#		converts a string into all upper-case printable characters
#
#	attributes:
#		string = string to convert
#
#	outputs:
#		string = converted string
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# ***********************************************************************************************************
function lmsStrToUpper()
{
    local string=$( echo "$1" | sed "y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/" )
    echo "${string}"

	return 0
}

# ***********************************************************************************************************
#
#	lmsStrBold
#
#		make the provided string into a bold string
#
#	attributes:
#		string = string to explode
#
#	outputs:
#		bold = string with bold escape chars
#
#	returns:
#		result = 0 if attribute is valid
#			   = 1 if attribute is a command
#
# ***********************************************************************************************************
function lmsStrBold()
{
	echo "$(tput bold ; ${1} ; tput sgr0)"
}

# ***********************************************************************************************************
#
#	lmsStrIsInteger
#
#		checks if a string contains ONLY numeric characters
#
#	attributes:
#		string = string to check
#
#	returns:
#		0 = numeric
#		1 = NOT numeric
#
# ***********************************************************************************************************
function lmsStrIsInteger()
{
	local value="${1}"

	re='^[0-9]+$'
	[[ "${value}" =~ $re ]] && return 0

	return 1
}

# ***********************************************************************************************************

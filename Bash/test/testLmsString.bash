#!/bin/bash
# *****************************************************************************
# *****************************************************************************
#
#   	testlmsStr.bash
#
# *****************************************************************************
#
# @author Jay Wheeler.
# @version 0.1.2
# @copyright © 2016, 2017. EarthWalk Software.
# @license Licensed under the Academic Free License version 3.0
# @package Linux Management Scripts
# @subpackage tests
#
# *****************************************************************************
#
#	Copyright © 2016, 2017. EarthWalk Software
#	Licensed under the Academic Free License, version 3.0.
#
#	Refer to the file named License.txt provided with the source,
#	or from
#
#			http://opensource.org/licenses/academic.php
#
# *****************************************************************************
#
#		Version 0.0.1 - 02-28-2016.
#				0.1.0 - 01-13-2017.
#				0.1.1 - 01-24-2017.
#				0.1.2 - 02-08-2017.
#
# *****************************************************************************
# *****************************************************************************

testlibDir="../../testlib"

. $testlibDir/installDirs.bash
. $testlibDir/stdLibs.bash
. $testlibDir/cliOptions.bash

. $testlibDir/commonVars.bash

lmsscr_Version="0.1.2"					# script version

# *****************************************************************************
# *****************************************************************************
#
#		External Functions
#
# *****************************************************************************
# *****************************************************************************

. $testlibDir/testDump.bash

# *****************************************************************************
# *****************************************************************************
#
#		Test Functions
#
# *****************************************************************************
# *****************************************************************************

# *****************************************************************************
#
#	testlmsStrTrim
#
# *****************************************************************************
function testlmsStrTrim()
{
	declare -g string="  a string with   enclosed  blanks  "
	declare -g result=""

	lmsConioDisplay "Trimming string =${string}="

	lmsStrTrim "${string}" result

	lmsConioDisplay "result  =${result}="
	lmsConioDisplay "lmsstr_Trimmed =${lmsstr_Trimmed}="

	result=""
	lmsStrTrim "${string}" string

	lmsConioDisplay "result  =${string}="
	lmsConioDisplay "lmsstr_Trimmed =${lmsstr_Trimmed}="

	result=""
	lmsStrTrim "${string}"

	lmsConioDisplay "result  =${string}="
	lmsConioDisplay "lmsstr_Trimmed =${lmsstr_Trimmed}="
}

# *****************************************************************************
#
#	testlmsStrUnquote
#
# *****************************************************************************
function testlmsStrUnquote()
{
	declare string="\"a string enclosed in quotes\""
	result=""

	lmsConioDisplay ""
	lmsConioDisplay "Unquoting string '${string}'"

	lmsStrUnquote "${string}" result

	lmsConioDisplay "result  =${result}="
	lmsConioDisplay "lmsstr_Unquoted =${lmsstr_Unquoted}="

	lmsConioDisplay ""
	lmsStrUnquote "${string}" string

	lmsConioDisplay "string  =${string}="
	lmsConioDisplay "lmsstr_Unquoted =${lmsstr_Unquoted}="

}

# *****************************************************************************
#
#	testlmsStrSplitFields
#
# *****************************************************************************
function testlmsStrSplitFields()
{
	declare string="netuser=\"netshare\""
	key=""
	value=""

	lmsConioDisplay ""
	lmsConioDisplay "spliting string '${string}'"

	lmsStrSplit "${string}" key value "="

	lmsConioDisplay "key:   ${key}"
	lmsConioDisplay "value: '${value}'"

	lmsConioDisplay ""

	key=""
	value=""

	string="netuser/\"netshare\""

	lmsConioDisplay ""
	lmsConioDisplay "spliting string '${string}'"

	lmsStrSplit "${string}" key value "/"

	lmsConioDisplay "key:   ${key}"
	lmsConioDisplay "value: '${value}'"

	lmsConioDisplay ""

}

# *****************************************************************************
#
#	testlmsStrExplode
#
# *****************************************************************************
function testlmsStrExplode()
{
	local resultString
	local string="firstname middlename lastname street city state zipcode "

	lmsConioDisplay "testlmsStrExplode"
	lmsConioDisplay "-----------"
	lmsConioDisplay ""

	lmsConioDisplay "exploding string"
	lmsConioDisplay "    '${string}'"
	lmsConioDisplay " to default array"
	lmsConioDisplay "    'lmsstr_Exploded':"
	lmsConioDisplay ""

	lmsStrExplode "${string}"

	lmsUtilATS lmsstr_Exploded resultString
	lmserr_result=1
	[[ $lmserr_result -eq 0 ]] && lmsConioDisplay "$resultString" || declare -a | grep lmsstr_Exploded

	lmsConioDisplay ""
	lmsConioDisplay "-----------"
	lmsConioDisplay ""

	# *************************************************************************

	lmsConioDisplay "exploding string"
	lmsConioDisplay "    '${string}'"
	lmsConioDisplay " to passed array"
	lmsConioDisplay "    'lmsstr_testArray':"
	lmsConioDisplay ""

	declare -a lmsstr_testArray=()

	lmsStrExplode "${string}" " " lmsstr_testArray

	lmsUtilATS lmsstr_testArray resultString
	lmserr_result=1
	[[ $lmserr_result -eq 0 ]] && lmsConioDisplay "$resultString" || declare -a | grep lmsstr_testArray

	lmsConioDisplay ""
	lmsConioDisplay "-----------"
	lmsConioDisplay ""

}

# *****************************************************************************
# *****************************************************************************
#
#		Start main program below here
#
# *****************************************************************************
# *****************************************************************************

lmsScriptFileName $0

. $testlibDir/openLog.bash
. $testlibDir/startInit.bash

# *****************************************************************************
# *****************************************************************************
#
#		Run the tests starting here
#
# *****************************************************************************
# *****************************************************************************

testlmsStrExplode

lmsConioDisplay ""
lmsConioDisplay "==========================================="
lmsConioDisplay ""

testlmsStrTrim

lmsConioDisplay ""
lmsConioDisplay "==========================================="
lmsConioDisplay ""

testlmsStrUnquote

lmsConioDisplay ""
lmsConioDisplay "==========================================="
lmsConioDisplay ""

testlmsStrSplitFields

lmsConioDisplay ""
lmsConioDisplay "==========================================="
lmsConioDisplay ""

# *****************************************************************************

. $testlibDir/testEnd.bash

# *****************************************************************************

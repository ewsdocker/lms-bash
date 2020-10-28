#!/bin/bash
# *****************************************************************************
# *****************************************************************************
#
#   	testLdcXPath.sh
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
#		Version 0.0.1 - 06-02-2016.
#				0.0.2 - 06-16-2016.
#				0.1.0 - 01-30-2017.
#				0.1.1 - 02-09-2017.
#				0.1.2 - 02-23-2017.
#
# *****************************************************************************
# *****************************************************************************

declare    ldcapp_name="testLdcXPath"
declare    ldclib_bashRelease="0.1.1"

# *****************************************************************************

. testlib/installDirs.sh

. $ldcbase_dirLib/stdLibs.sh

. $ldcbase_dirLib/cliOptions.sh
. $ldcbase_dirLib/commonVars.sh

# *****************************************************************************

ldcscr_Version="0.1.2"						# script version

ldcapp_errors="$ldcbase_dirEtc/errorCodes.xml"

# *****************************************************************************
# *****************************************************************************
#
#		External Functions
#
# *****************************************************************************
# *****************************************************************************

. $ldcbase_dirLib/testDump.sh

# *****************************************************************************
# *****************************************************************************
#
#		Test Functions
#
# *****************************************************************************
# *****************************************************************************

# *******************************************************
#
#	testLdcXPathQuery
#
#		test the performance of the XPathQQuery function
#
#	parameters:
#		query = query to execute
#		raw = 0 ==> process query as is, 1 ==> apply current cd before processing
#
#	returns:
#		0 => no error
#		1 => query error
#
# *******************************************************
function testLdcXPathQuery()
{
	local result=""

	ldcConioDisplay ""
	ldcConioDisplay " ldcXPathQuery: '${1}' '${2}'"

	ldcXPathQuery "${1}" $2
	[[ $? -eq 0 ]] ||
	 {
		echo "$(tput bold)${ldcclr_Red}ldcXPathQuery failed: '${ldcxp_Query}'$(tput sgr0)"
		testXpathExit
	 }

	ldcConioDisplay "  $(tput bold)${ldcclr_Red}'${ldcxp_QueryResult}'$(tput sgr0)"
	return 0
}

# *******************************************************
#
#	testLdcXPathCommand
#
#	parameter:
#		command = command to execute
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# *******************************************************
function testLdcXPathCommand()
{
	local xCommand="${1}"
	local result=0

	ldcXPathCommand "${xCommand}"
	[[ $? -eq 0 ]] ||
	 {
		result=$?
		ldcConioDisplay "$(tput bold)${ldcclr_Red}ldcXMLParseToCmnd failed for '${xCommand}'$(tput sgr0)"
		return $result
	 }

	ldcConioDisplay "'${xCommand}' is:"
	ldcConioDisplay ""
	ldcConioDisplay "$(tput bold)${ldcclr_Red}     '${ldcxp_CommandResult}'$(tput sgr0)"
	ldcConioDisplay ""

	ldcConioDisplay "*******************************************"

	return 0
}

# ******************************************************************************
#
#	testLdcXPathInit
#
#		test the performance of the ldcXPathInit function
#
#	parameters:
#		name = internal name of the xml file
#		file = absolute path to the xml file to query
#		xmllint = (optional) path to the xmllint program
#
#	returns:
#		0 => no error
#		1 => xml file error
#		2 => xmllint error
#
# ******************************************************************************
function testLdcXPathInit()
{
	ldcConioDisplay ""
	ldcConioDisplay "ldcXPathInit: '${1}' '${2}' '${3}'"
	
	ldcXPathInit ${1} ${2} ${3}
	[[ $? -eq 0 ]] ||
	 {
		ldcConioDisplay "ldcXPathInit failed: $ldcxp_Result"
		testXPathExit
	 }
}

# ******************************************************************************
#
#	testLdcXPathCD
#
#		set the query path
#
#	parameters:
#		path = the path expression to set
#
#	returns:
#		0 => no error
#		1 => query path not set
#
# ******************************************************************************
function testLdcXPathCD()
{
	ldcConioDisplay ""
	ldcConioDisplay "ldcXPathCD: '${1}'"
	
	ldcXPathCD "${1}"
	[[ $? -eq 0 ]] ||
	 {
		ldcConioDisplay "ldcXPathCD failed: $?"
		testXPathExit
	 }
	
	ldcConioDisplay "ldcXPathCD path = ${ldcxp_Path}"
}

# ******************************************************************************
#
#	testLdcXPathUnset
#
#		unset the requested name if found in the xpQueryFile array
#
#	parameters:
#		unsetName = name of the entry to unset
#
#	returns:
#		0 => no error
#
# ******************************************************************************
function testLdcXPathUnset()
{
	ldcConioDisplay ""
	ldcConioDisplay "ldcXPathUnset: '${1}'"

	ldcXPathUnset "${1}"
	[[ $? -eq 0 ]] ||
	 {
		ldcConioDisplay "ldcXPathUnset failed: $?"
		testXPathExit
	 }

	return 0
}

# ******************************************************************************
#
#	testLdcXPathSelect
#
#		select the ldcxp_ath query file
#
#	parameters:
#		xpsName = name of the ldcxp_path query file to select
#		xpsFile = path to the query file
#
#	returns:
#		0 => no error
#		non-zero => error code
#
# ******************************************************************************
function testLdcXPathSelect()
{
	ldcConioDisplay ""
	ldcConioDisplay "ldcXPathSelect: '${1}' '${2}'"
	
	ldcXPathSelect ${1} ${2}
	[[ $? -eq 0 ]] ||
	 {
		ldcConioDisplay "ldcXPathSelect failed: $ldcxp_Result"
		testXPathExit
	 }
}

# ******************************************************************************
#
#	testLdcXPathReset
#
#		reset query vars
#
#	parameters:
#		none
#
#	returns:
#		0 => no error
#
# ******************************************************************************
function testLdcXPathReset()
{
	ldcConioDisplay ""
	ldcConioDisplay "ldcXPathReset"

	ldcXPathReset
}

# ******************************************************************************
#
#	testXPathExit
#
#		Common error exit point
#
#	parameters:
#		none
#
#	returns:
#		DOES NOT RETURN
#
# ******************************************************************************
function testXPathExit()
{
	ldcConioDisplay ""
	ldcConioDisplay "Exit"

	[[ $ldccli_optDebug -eq 0  &&  ldccli_optQueueErrors -ne 0 ]]  &&  ldcErrorQDispPop

	ldcConioDisplay "  Log-file: '${ldctst_logName}'"

	exit 1
}

# ******************************************************************************
#
#	testStartup
#
#		run the startup initialization in a test environment
#
#	parameters:
#		vers = script version
#		xmlErrors = error code file name
#
#	returns:
#		0 => no error
#
# ******************************************************************************
function testStartup()
{
	ldcScriptFileName "${0}"

	ldcscr_Version=${1:-"0.0.1"}
	local xmlErrorCodes="${2}"

	ldcScriptDisplayName
	ldcConioDisplay ""

}

# ******************************************************************************
#
#	testLdcErrorInitialize
#
#
#	parameters:
#		vers = script version
#		xmlErrors = error code file name
#
#	returns:
#		0 => no error
#
# ******************************************************************************
function testLdcErrorInitialize()
{
	ldcConioDisplay ""
	ldcConioDisplay "ldcErrorInitialize '${1}'"

	ldcxp_Result=0
	ldcErrorInitialize "ldcErrors" "${1}"
	[[ $? -eq 0 ]] ||
	 {
		ldcxp_Result=$?
		[[ ${ldcdyna_valid} -eq 0  &&  ${ldcerr_result} -eq 0  ]] ||
		 {
			ldcConioDisplay "Unable to load error codes from ${xmlErroCodes} : ${1}."
			testXPathExit
		 }
	 }
}

# *****************************************************************************
# *****************************************************************************
#
#		Start main program below here
#
# *****************************************************************************
# *****************************************************************************

ldcScriptFileName $0
ldcScriptDisplayName
ldcConioDisplay ""

. $ldcbase_dirLib/openLog.sh
#. $ldcbase_dirLib/startInit.sh

# *****************************************************************************
# *****************************************************************************
#
#		Run the tests starting here
#
# *****************************************************************************
# *****************************************************************************

testLdcXPathReset

ldcConioDisplay ""
ldcConioDisplay "*******************************************"

testLdcXPathInit "shell" "$ldcbase_dirEtc/shellHelp.xml"

ldcConioDisplay ""
ldcConioDisplay "*******************************************"

testLdcXPathQuery "/ldc/help/options/var" 0

ldcConioDisplay ""
ldcConioDisplay "*******************************************"

testLdcXPathQuery "//@name" 0

ldcConioDisplay ""
ldcConioDisplay "*******************************************"

testLdcXPathQuery "//options" 0

ldcConioDisplay ""
ldcConioDisplay "*******************************************"

testLdcXPathCD "/ldc/help/options"

ldcConioDisplay ""
ldcConioDisplay "*******************************************"

testLdcXPathQuery "var" 0

ldcConioDisplay ""
ldcConioDisplay "*******************************************"

helpName="batch"
helpCommand="string(//ldc/help/options/var[@name=\"${helpName}\"]/use)"

testLdcXPathCommand ${helpCommand}

#ldcConioDisplay ""
#ldcConioDisplay "*******************************************"

helpName="lib"
helpCommand="string(//ldc/help/options/var[@name=\"${helpName}\"]/use)"

testLdcXPathCommand ${helpCommand}

#ldcConioDisplay ""
#ldcConioDisplay "*******************************************"

helpName="trial"
helpCommand="string(//ldc/help/options/var[@name=\"${helpName}\"]/use)"

testLdcXPathCommand ${helpCommand}

#ldcConioDisplay ""
#ldcConioDisplay "*******************************************"

testLdcErrorInitialize "${ldcapp_errors}"

ldcConioDisplay ""
ldcConioDisplay "*******************************************"

testLdcXPathSelect "ldcErrors" ${ldcapp_errors}

testLdcDmpVar "ldcerr_"

ldcConioDisplay ""
ldcConioDisplay "*******************************************"

testLdcXPathUnset "shell"

testLdcDmpVar "ldcerr_"

ldcConioDisplay ""
ldcConioDisplay "*******************************************"

testLdcXPathUnset "ldcErrors"

testLdcDmpVar "ldcerr_"

# *****************************************************************************

. $ldcbase_dirLib/scriptEnd.sh

# *****************************************************************************

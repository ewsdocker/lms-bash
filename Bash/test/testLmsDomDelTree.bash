#!/bin/bash
# *****************************************************************************
# *****************************************************************************
#
#	testlmsDomDelTree.bash
#
#	Test ability to correctly delete a DOM tree created by the lmsDomRRead library.
#
# *****************************************************************************
#
# @author Jay Wheeler.
# @version 0.0.2
# @copyright © 2016. EarthWalk Software.
# @license Licensed under the Academic Free License version 3.0
# @package Linux Management Scripts
# @subpackage DOMDocument
#
# *****************************************************************************
#
#	Copyright © 2016. EarthWalk Software
#	Licensed under the Academic Free License, version 3.0.
#
#	Refer to the file named License.txt provided with the source,
#	or from
#
#			http://opensource.org/licenses/academic.php
#
# *****************************************************************************
#
#			Version 0.0.1 - 09-06-2016.
#                   0.0.2 - 09-17-2016.
#
# *****************************************************************************
# *****************************************************************************

# *****************************************************************************
# *****************************************************************************
#
#    	External Scripts
#
# *****************************************************************************
# *****************************************************************************

lmscli_optProduction=0

if [ $lmscli_optProduction -eq 1 ]
then
	rootDir="/usr/local"
	libDir="$rootDir/lib/lms/bash"
	etcDir="$rootDir/etc/lms"
else
	rootDir="../.."
	libDir="$rootDir/lib"
	etcDir="$rootDir/etc"
fi

. $libDir/arraySort.bash
. $libDir/lmsCli.bash
. $libDir/lmsColorDef.bash
. $libDir/lmsConio.bash
. $libDir/lmsXCfg.bash
. $libDir/lmsDomDelTree.bash
#. $libDir/lmsDomC.bash
. $libDir/lmsDomD.bash
. $libDir/lmsDomN.bash
. $libDir/lmsDomR.bash
. $libDir/lmsDomTC.bash
. $libDir/lmsDomTs.bash
. $libDir/lmsDmpVar
. $libDir/lmsDynNode.bash
. $libDir/lmsDynArray.bash
. $libDir/lmsError.bash
. $libDir/lmsErrorQDisp.bash
. $libDir/lmsErrorQ.bash
. $libDir/lmsHelp.bash
. $libDir/lmsDeclare.bash
. $libDir/lmsLog.bash
. $libDir/lmsLogRead.bash
. $libDir/lmsRlmsDomD.bash
. $libDir/lmsScriptName.bash
. $libDir/lmsStack.bash
. $libDir/lmsStartup.bash
. $libDir/lmsStr.bash
. $libDir/lmsUId
. $libDir/lmsUtilities.bash
. $libDir/lmsXMLParse
. $libDir/lmsXPath.bash

# *****************************************************************************
# *****************************************************************************
#
#   Global variables - modified by program flow
#
# *****************************************************************************
# *****************************************************************************

declare    lmsscr_Version="0.0.2"						# script version
declare    lmsvar_errors="$etcDir/errorCodes.xml"
declare    lmsvar_help="$etcDir/testHelp.xml"			# path to the help information file

declare	   lmstest_cliOptions="$etcDir/testlmsDomTCConfig.xml"

declare    lmstest_logDir="/var/local/log/lms-test/"
declare    lmstest_logName="test.log"
declare    lmstest_logFile="${lmstest_logDir}${lmstest_logName}"

declare -i lmstest_result=0

# *****************************************************************************

# *****************************************************************************
#
#	updateCliOptions
#
#		Read the cli options and set in lmstest_xxxxOptions
#
#	parameters:
#		none
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# *****************************************************************************
function updateCliOptions()
{
	lmsXCfgLoad ${lmstest_cliOptions} "lmsxmlconfig"
	lmstest_result=$?
	[[ $lmstest_result -eq 0 ]] ||
	 {
		lmsConioDebug $LINENO "ConfigXmlError" "lmsXCfgLoad '${lmstest_Declarations}'"
		return 1
	 }

	lmsCliParseParameter
	lmstest_result=$?
	[[ $lmstest_result -eq 0 ]] ||
	 {
		lmsConioDebug $LINENO "ParamError" "cliParameterParse failed"
		return 2
	 }

	[[ ${lmscli_Errors} -eq 0 ]] &&
	 {
		lmsCliApplyInput
		lmstest_result=$?
		[[ $lmstest_result -eq 0 ]] ||
		 {
			lmsConioDebug $LINENO "ParamError" "lmsCliApplyInput failed." 
			return 3
		 }
	 }

	if [[ $lmscli_debugOptions -ne 0 ]] 
	then
		declare -p | grep lmscli_
		lmsConioDisplay ""
	fi

	return 0
}

# *****************************************************************************
#
#	updateLogFileName
#
#		Read the cli logDir and LogName options and create a log file name
#
#	parameters:
#		none
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# *****************************************************************************
function updateLogFileName()
{
	lmstest_logDir="${lmstest_logDir}"
	lmstest_logName="${lmsscr_Name}.log"

	lmstest_logFile="${lmstest_logDir}${lmstest_logName}"
	lmsConioDebug $LINENO "Debug" "Log file name: $lmstest_logFile"

	return 0
}

# *****************************************************************************
# *****************************************************************************
#
#		Start main program below here
#
# *****************************************************************************
# *****************************************************************************

lmscli_optDebug=0				# (d) Debug output if not 0
lmscli_optSilent=0    			# (q) Quiet setting: non-zero for absolutely NO output
lmscli_optBatch=0				# (b) Batch mode - missing parameters fail
lmscli_optQuiet=0				# set to 1 to lmscli_optOverride the lmscli_optSilent flag
lmscli_optQueueErrors=0

lmsScriptFileName $0
lmstest_logFile="${lmsscr_Name}.log"

lmsLogOpen "${lmstest_logFile}"
lmstest_result=$?
[[ $lmstest_result -eq 0 ]] ||
 {
	logDebugMessaage $LINENO "Debug" "($lmstest_result) Unable to open log file: '${lmstest_logFile}'"
	exit 1
 }

lmsStartupInit $lmsscr_Version ${lmsvar_errors}
lmstest_result=$?
[[ $lmstest_result -eq 0 ]] ||
 {
	logDebugMessaage $LINENO "Debug" "($lmstest_result) Unable to load error codes."
	errorExit "Debug"
 }

updateCliOptions
lmstest_result=$?
[[ $lmstest_result -eq 0 ]] ||
 {
	lmsLogDebugMessage $LINENO "Debug" "($lmstest_result) updateCliOptions failed"
	exit 1
 }

updateLogFileName
lmstest_result=$?
[[ $lmstest_result -eq 0 ]] ||
 {
	lmsLogDebugMessage $LINENO "Debug" "($lmstest_result) Unable to open log file: '${lmstest_logFile}'"
	exit 1
 }

lmsLogClose

lmsLogOpen "${lmstest_logFile}" "new"
lmstest_result=$?
[[ $lmstest_result -eq 0 ]] ||
 {
	lmsConioDebug $LINENO "Debug" "($lmstest_result) Unable to open log file: '${lmstest_logFile}'"
	exit 1
 }

lmsConioDisplay "  Log-file: ${lmstest_logFile}"
lmsConioDisplay ""

lmsXPathSelect ${lmserr_arrayName}
lmstest_result=$?
[[ $lmstest_result -eq 0 ]] ||
 {
	lmsLogDebugMessage $LINENO "Debug" "($lmstest_result) Unable to select ${lmserr_arrayName}"
	exit 1
 }

# *****************************************************************************

lmsDomRInit
lmstest_result=$?
[[ $lmstest_result -eq 0 ]] ||
 {
	lmsLogDebugMessage $LINENO "DomError" "lmsDomRInit failed."
	exit 1
 }

lmsConioDisplay "  Building DOM tree"
lmsConioDisplay ""

lmsDomDParse ${lmstest_cliOptions}
lmstest_result=$?
[[ $lmstest_result -eq 0 ]] ||
 {
	lmsLogDebugMessage $LINENO "DomError" "lmsDomDParse '${lmstest_cliOptions}'"
	exit 1
 }

[[ $lmscli_optDebug -eq 0 ]] ||
 {
	lBuffer=$( lmsDomToStr )
	lmstest_result=$?
	[[ $lmstest_result -eq 0 ]] ||
	 {
		lmsLogDebugMessage $LINENO "DomError" "lmsDomTCConfig failed."
		exit 1
	 }

	echo "$lBuffer"
 }

lmsConioDisplay "  Finished building DOM Tree"
lmsConioDisplay ""

echo ""
declare -p | grep lmsdom_
echo ""

lmsConioDisplay "  Deleting DOM Tree"
lmsConioDisplay ""

lmsDomDTDelete "${lmsdom_docTree}"
lmstest_result=$?
[[ $lmstest_result -eq 0 ]] ||
 {
	lmsLogDebugMessage $LINENO "DomError" "Unable to delete the specified dom tree: '$lmsdom_docTree'"
 }

lmsConioDisplay "  DOM Tree has been deleted(?)"
lmsConioDisplay ""

echo ""
declare -p | grep lmsdom_
echo ""

# *****************************************************************************

if [ $lmscli_optDebug -ne 0 ]
then
	lmsErrorQDispPop
fi

lmsConioDisplay ""
lmsConioDisplay "  Log-file: ${lmstest_logFile}"
lmsConioDisplay ""

lmsErrorExitScript "EndOfTest"


#!/bin/bash
# *****************************************************************************
# *****************************************************************************
#
#   testlmsXCfg.bash
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
#			Version 0.0.1 - 07-02-2016.
#					0.1.0 - 01-24-2017.
#					0.1.1 - 02-09-2017.
#					0.1.2 - 02-14-2017.
#
# *****************************************************************************
# *****************************************************************************

testlibDir="../../testlib"

. $testlibDir/installDirs.bash

. $testlibDir/stdLibs.bash

. $testlibDir/cliOptions.bash
. $testlibDir/commonVars.bash

# *****************************************************************************

lmsscr_Version="0.1.2"						# script version

lmstst_Declarations="$etcDir/testVariables.xml"

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

# *******************************************************
#
#	testShow
#
# *******************************************************
function testShow()
{
	lmsUtilIndent ${1} ${2} 2
	lmsConioDisplay "${2}"
}

# *******************************************************
#
#	testBuildData
#
# *******************************************************
function testBuildData()
{
	case $lmsxml_TagType in

		"OPEN")
			lmsStackWrite global "${lmsxml_TagName}"
			lmsStackSize global lmstst_stackSize

			testShow $lmstst_stackSize "${lmsxml_TagName} (${lmsxml_Entity})"

			lmstst_currentStack=$lmstst_stackSize
			;;

		"CLOSE")
			lmsStackRead global lmstst_item
			;;

		*)
			;;
	esac
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

lmscli_optLogDisplay=0
lmscli_optDebug=1

lmstst_stackSize=0
lmstst_item=""

# *****************************************************************************

lmsXCfgLoad ${lmstst_Declarations} "lmsxcfg_testStack" 1
[[ $? -eq 0 ]] ||
 {
	lmstst_result=$?
	lmscli_optLogDisplay=0
	lmsConioDisplay "lmsXCfgLoad '${lmstst_Declarations}' failed: '${lmstst_result}'" 
 }

lmsConioDisplay ""
lmsConioDisplay "*******************************************************"
lmsConioDisplay ""

testLmsDmpVar "lmstest_ lmsxcfg_ lmsxml_ lmscli_ lmsstk"

# *****************************************************************************

. $testlibDir/testEnd.bash

# *****************************************************************************

#!/bin/bash
# ***************************************************************************************************
# ***************************************************************************************************
#
#   testLmsCli.bash
#
# ***************************************************************************************************
#
# @author Jay Wheeler.
# @version 0.1.2
# @copyright © 2016, 2017. EarthWalk Software.
# @license Licensed under the Academic Free License version 3.0
# @package Linux Management Scripts
# @subpackage tests
#
# ***************************************************************************************************
#
#	Copyright © 2016, 2017. EarthWalk Software
#	Licensed under the Academic Free License, version 3.0.
#
#	Refer to the file named License.txt provided with the source,
#	or from
#
#			http://opensource.org/licenses/academic.php
#
# ***************************************************************************************************
#
#			Version 0.0.1 - 02-24-2016.
#					0.0.2 - 07-01-2016.
#					0.1.0 - 01-17-2017.
#					0.1.1 - 01-23-2017.
#					0.1.2 - 02-11-2017.
#
# ***************************************************************************************************
# ***************************************************************************************************

testlibDir="../../testlib"

. $testlibDir/installDirs.bash

. $testlibDir/stdLibs.bash

. $testlibDir/cliOptions.bash
. $testlibDir/commonVars.bash

# *****************************************************************************

declare    lmsscr_Version="0.1.2"	# script version

declare    lmstst_Declarations="$etcDir/lms-testOptions.xml"

# *****************************************************************************
# *****************************************************************************
#
#		External Functions
#
# *****************************************************************************
# *****************************************************************************

. $testlibDir/testDump.bash
. $testlibDir/testUtilities.bash

# *****************************************************************************
# *****************************************************************************
#
#		Test Functions
#
# *****************************************************************************
# *****************************************************************************

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

lmscli_optDebug=0
lmscli_optQueueErrors=0
lmscli_Errors=0

lmscli_optLogDisplay=1

lmsConioDisplay "Loading cli parameters from ${lmstst_Declarations}"

# *****************************************************************************

lmsXCfgLoad ${lmstst_Declarations} "lmsxmlconfig"
[[ $? -eq 0 ]] || lmsConioDisplay "lmsXCfgLoad '${lmstst_Declarations}'"

# *****************************************************************************


lmsConioDisplay "Before parsing:"
lmsConioDisplay ""

testLmsDmpVar "lmscli lmsxcfg_ lmstest_"

lmsCliParseParameter
[[ $? -eq 0 ]] || lmsConioDisplay "cliParameterParse failed"

[[ ${lmscli_Errors} -eq 0 ]] &&
 {
	lmsCliApplyInput
	[[ $? -eq 0 ]] || lmsConioDisplay "lmsCliApplyInput failed."
 }

lmsConioDisplay ""
lmsConioDisplay "After parsing:"
lmsConioDisplay ""

testLmsDmpVar "lmscli lmsxcfg_ lmstest_"

lmsConioDisplay ""

#testDisplayHelp $lmsvar_help

# *****************************************************************************

. $testlibDir/testEnd.bash

# *****************************************************************************

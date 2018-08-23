#!/bin/bash
# *****************************************************************************
# *****************************************************************************
#
#	testLmsDomC.bash
#
# *****************************************************************************
#
# @author Jay Wheeler.
# @version 0.0.2
# @copyright © 2016, 2017. EarthWalk Software.
# @license Licensed under the Academic Free License version 3.0
# @package Linux Management Scripts
# @subpackage DOMDocument
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
#			Version 0.0.1 - 09-06-2016.
#					0.0.2 - 02-15-2017.
#
# *****************************************************************************
# *****************************************************************************
testlibDir="../../testlib"

. $testlibDir/installDirs.bash
. $testlibDir/stdLibs.bash
. $testlibDir/cliOptions.bash

. $testlibDir/commonVars.bash

# *****************************************************************************

#declare   lmstst_Declarations="$etcDir/testVariables.xml"
declare    lmstst_Declarations="../getSongInfo/getSongOptions.xml"

lmsscr_Version="0.0.2"						# script version

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

echo "lmstst_Declarations: ${lmstst_Declarations}"

lmsDomCLoad ${lmstst_Declarations} "lmstst_stack" 1
[[ $? -eq 0 ]] ||
 {
	lmsConioDisplay "DomError - lmsDomCLoad failed."
	testDumpExit "lmsdom_ lmstst_ lmsstk lmscli"
 }

testDumpExit "lmsdom_ lmstest_ lmstst_ lmsstk lmscli lmshlp_"

# *****************************************************************************

. $testlibDir/testEnd.bash

# *****************************************************************************

#!/bin/bash
# *****************************************************************************
# *****************************************************************************
#
#	testLmsDomC.sh
#
# *****************************************************************************
#
# @author Jay Wheeler.
# @version 0.0.3
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
#					0.0.3 - 02-23-2017.
#
# *****************************************************************************
# *****************************************************************************

declare    lmsapp_name="testLmsDomC"
declare    lmslib_bashRelease="0.1.1"

# *****************************************************************************

. testlib/installDirs.sh

. $lmsbase_dirLib/stdLibs.sh

. $lmsbase_dirLib/cliOptions.sh
. $lmsbase_dirLib/commonVars.sh

# *****************************************************************************

lmsscr_Version="0.0.3"						# script version

#declare   lmstst_Declarations="$lmsbase_dirEtc/testVariables.xml"
declare    lmstst_Declarations="$lmsbase_dirEtc/getSongOptions.xml"

# *****************************************************************************
# *****************************************************************************
#
#		External Functions
#
# *****************************************************************************
# *****************************************************************************

. $lmsbase_dirLib/testDump.sh
. $lmsbase_dirLib/testUtilities.sh

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

. $lmsbase_dirLib/openLog.sh
. $lmsbase_dirLib/startInit.sh

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

. $lmsbase_dirLib/scriptEnd.sh

# *****************************************************************************

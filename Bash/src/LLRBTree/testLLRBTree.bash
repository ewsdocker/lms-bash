#!/bin/bash

# *******************************************************
# *******************************************************
#
#   testLLRBTree.bash
#
#   Copyright (C) 2016. EarthWalk Software
#
#   	By Jay Wheeler.
#
#			Version 1.0 - 04-01-2016.
#
# *******************************************************
# *******************************************************

# *******************************************************
# *******************************************************
#
#    	External Scripts
#
# *******************************************************
# *******************************************************

declare -i lmscli_optProduction=0

if [ $lmscli_optProduction -eq 1 ]
then
	rootDir="/usr/local"
	libDir="$rootDir/lib/lms/bash"
	lmsvar_errors="$rootDir/etc/lms/errorCodes.xml"
else
	rootDir="../.."
	libDir="$rootDir/lib"
	lmsvar_errors="$rootDir/etc/errorCodes.xml"
fi

. $libDir/arraySort.bash
. $libDir/lmsConio.bash
. $libDir/lmsCli.bash
. $libDir/lmsError.bash
. $libDir/lmsErrorQDisp.bash
. $libDir/lmsErrorQ.bash
. $libDir/lmsScriptName.bash
. $libDir/lmsDeclare.bash
. $libDir/lmsStack.bash
. $libDir/lmsStartup.bash
. $libDir/lmsStr.bash
. $libDir/lmsUId
. $libDir/varsFromXml.bash
. $libDir/xmlParser.bash


# *******************************************************
# *******************************************************
#
#		Application Script below here
#
# *******************************************************
# *******************************************************

function runFirstTests()
{
	treeName="NoblePineLodge"
	llrbTreeCreate "${treeName}"
	if [ $? -ne 0 ]
	then
		lmsErrorQWrite $LINENO TreeCreate "Unable to create the requested tree: $treeName"
		errorQueueDisplay 0 1 EndOfTest
	fi

	lmsConioDisplay "Created tree '$treeName'"

	# **************************************************************************
	# **************************************************************************

	keynodeName="${treeName}"
	keynodeUID=""

	result=$( llrbTreeIsRedNode $keynodeName )

	lmsConioDisplay "result = $result"

	lmsConioDisplay "$( llrbNodeToString $keynodeName )"

	# **************************************************************************

	lmsConioDisplay ""
	lmsConioDisplay "*******************************************************"
	lmsConioDisplay ""

	leftnodeData="the maid"
	leftnodeName="Bridget"
	leftnodeUID=""

	lmsConioDisplay "Creating node: ${leftnodeName}"

	llrbNodeCreate "${leftnodeName}" leftnodeUID "${leftnodeData}"
	llrbNodeSet "${leftnodeName}" "color" 0

	lmsConioDisplay "Created node: ${leftnodeName} = $leftnodeUID, linking left child of $keynodeName"
	lmsConioDisplay ""

	llrbNodeSet $keynodeName "left" $leftnodeName

	lmsConioDisplay "$( llrbNodeToString $keynodeName )"

	# **************************************************************************

	lmsConioDisplay ""
	lmsConioDisplay "*******************************************************"
	lmsConioDisplay ""

	rightnodeData="Bridgets brother"
	rightnodeName="Zandar"
	rightnodeUID=""

	lmsConioDisplay "Creating node: ${rightnodeName}"

	llrbNodeCreate "${rightnodeName}" rightnodeUID "${rightnodeData}"
	llrbNodeSet "${rightnodeName}" "color" 0

	lmsConioDisplay "Created node: ${rightnodeName} = $rightnodeUID, linking right child of $keynodeName"
	lmsConioDisplay "" and unwind properly

	llrbNodeSet $keynodeName "right" $rightnodeName

	lmsConioDisplay "$( llrbNodeToString $keynodeName )"

	# **************************************************************************

	displayNodes

	# **************************************************************************

	lmsConioDisplay "flipping color"
	lmsConioDisplay ""

	llrbTreeFlipColors "$keynodeName"
	if [ $? -ne 0 ]
	then
		lmsErrorQWrite $LINENO TreeModifyNode "Unable to flip color on the requested node: $keynodeName"
		errorQueueDisplay 0 1 EndOfTest
	fi

	displayNodes

	# **************************************************************************

	lmsConioDisplay "flipping color AGAIN"
	lmsConioDisplay ""

	llrbTreeFlipColors $keynodeName
	if [ $? -ne 0 ]
	then
		lmsErrorQWrite $LINENO TreeModifyNode "Unable to flip color on the requested node: $keynodeName"
		errorQueueDisplay 0 1 EndOfTest
	fi

	displayNodes

	# **************************************************************************

	lmsConioDisplay "comparison"
	lmsConioDisplay ""

	rname=$( llrbNodeGet $rightnodeName 'key' )
	lname=$( llrbNodeGet $leftnodeName  'key' )

	lmsConioDisplay "Comparing $rname with $lname"

	displayComparison $rname $lname

	displayComparison $lname $rname
}

function displayNodes()
{
	lmsConioDisplay ""
	lmsConioDisplay "******************* NODES *****************************"
	lmsConioDisplay ""

	lmsConioDisplay "$( llrbNodeToString $keynodeName )"

	lmsConioDisplay "$( llrbNodeToString $leftnodeName )"

	lmsConioDisplay "$( llrbNodeToString $rightnodeName )"

	lmsConioDisplay ""
	lmsConioDisplay "*************** END NODES *****************************"
	lmsConioDisplay ""

}

function displayComparison()
{
	local rightnodeName="${1}"
	local leftnodeName="${2}"

	llrbNodeCompare "${rightnodeName}" "${leftnodeName}"
	result=$?

	lmsConioDisplay "Compare result = '$result'"
	case $result in

			0)	lmsConioDisplay "$rightnodeName = $leftnodeName"
				;;

			1)	lmsConioDisplay "$rightnodeName > $leftnodeName"
				;;

			2)	lmsConioDisplay "$rightnodeName < $leftnodeName"
				;;

			*)	lmsErrorQWrite $LINENO NodeCompare "Unable to perform comparison"
				errorQueueDisplay 0 1 EndOfTest
				;;
	esac
}

# *******************************************************
# *******************************************************
#
#		Start main program below here
#
# *******************************************************
# *******************************************************

lmscli_optDebug=0				# (d) Debug output if not 0
lmscli_optSilent=0    			# (q) Quiet setting: non-zero for absolutely NO output
lmscli_optBatch=0					# (b) Batch mode - missing parameters fail
silentOverride=0			# set to 1 to lmscli_optOverride the lmscli_optSilent flag

applicationVersion="1.0"	# Application version

testErrors=0

# *************************************************************************************************
# *************************************************************************************************

lmsErrorInitialize

lmsErrorQInit
if [ $? -ne 0 ]
then
	lmsConioDisplay "Unable to initialize error queue."
	exit 1
fi

lmsConioDisplay ""
lmsConioDisplay "*******************************************************"
lmsConioDisplay "*******************************************************"
lmsConioDisplay ""

lmsScriptDisplayName

lmsConioDisplay ""
lmsConioDisplay "*******************************************************"
lmsConioDisplay "*******************************************************"

# *************************************************************************************************

#runFirstTests

# *************************************************************************************************

treeName="LLRBTree"
llrbTreeCreate "${treeName}"
if [ $? -ne 0 ]
then
	lmsErrorQWrite $LINENO TreeCreate "Unable to create the requested tree: $treeName"
	errorQueueDisplay 0 1 EndOfTest
fi

lmsConioDisplay "Created tree '$treeName'"

# *************************************************************************************************
# *************************************************************************************************

lmsConioDisplay ""
lmsConioDisplay "*******************************************************"
lmsConioDisplay ""

memberData="1980-11-01"
memberName="Edward"
memberUID=""

lmsConioDisplay "Insertting node: ${memberName}"

llrbTreeInsert "${memberName}" "${memberData}"


#dumpNameTable
exit 1



lmsConioDisplay "Created node: ${leftnodeName} = $leftnodeUID, linking left child of $keynodeName"
lmsConioDisplay ""

llrbNodeSet $keynodeName "left" $leftnodeName

lmsConioDisplay "$( llrbNodeToString $keynodeName )"

# *************************************************************************************************

lmsConioDisplay ""
lmsConioDisplay "*******************************************************"
lmsConioDisplay ""

rightnodeData="Bridgets brother"
rightnodeName="Zandar"
rightnodeUID=""

lmsConioDisplay "Creating node: ${rightnodeName}"

llrbNodeCreate "${rightnodeName}" rightnodeUID "${rightnodeData}"
llrbNodeSet "${rightnodeName}" "color" 0

lmsConioDisplay "Created node: ${rightnodeName} = $rightnodeUID, linking right child of $keynodeName"
lmsConioDisplay ""

llrbNodeSet $keynodeName "right" $rightnodeName

lmsConioDisplay "$( llrbNodeToString $keynodeName )"

# *************************************************************************************************

displayNodes

# **********************************************************************

errorQueueDisplay 0 1 EndOfTest

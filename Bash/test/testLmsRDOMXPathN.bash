#!/bin/bash
# *****************************************************************************
# *****************************************************************************
#
#   	testLmsRDomXPathN.bash
#
# *****************************************************************************
#
# @author Jay Wheeler.
# @version 0.0.2
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
#		Version 0.0.1 - 06-30-2016.
#				0.0.2 - 02-10-2017.
#
# *****************************************************************************
# *****************************************************************************

testlibDir="../../testlib"

. $testlibDir/installDirs.bash
. $testlibDir/stdLibs.bash
. $testlibDir/cliOptions.bash

. $testlibDir/commonVars.bash

# *****************************************************************************

declare    lmsscr_Version="0.0.2"				# script version
declare	   lmstst_Declarations="$etcDir/testVariables.xml"

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

# *******************************************************
#
#	testLmsRDomXPNSet
#
#
# *******************************************************
testLmsRDomXPNSet()
{
	lmsConioDisplay ""
	lmsConioDisplay "XML_ENTITY    : '${lmsxml_Entity}'"

	lmsStrTrim "${lmsxml_Content}" lmsxml_Content

	lmsConioDisplay "XML_CONTENT   :     '${lmsxml_Content}'"

	lmsConioDisplay "XML_TAG_NAME  :     '${lmsxml_TagName}'"
	lmsConioDisplay "XML_TAG_TYPE  :     '${lmsxml_TagType}'"

	if [[ "${lmsxml_TagType}" == "OPEN" || "${lmsxml_TagType}" == "OPENCLOSE" ]]
	then
		if [ -n "${lmsxml_Attributes}" ]
		then
			lmsRDomParseAtt

			lmsConioDisplay "XML_ATT_COUNT :     '${#lmsxml_AttributesArray[@]}'"
		
			for attribute in "${!lmsxml_AttributesArray[@]}"
			do
				lmsConioDisplay "XML_ATT_NAME  :     '${attribute}'"
				lmsConioDisplay "XML_ATT_VAL   :     '${lmsxml_AttributesArray[$attribute]}'"
				
			done
		fi
	fi

	lmsStrTrim "${lmsxml_Comment}" lmsxml_Comment

	lmsConioDisplay "XML_COMMENT   :     '${lmsxml_Comment}'"
	lmsConioDisplay "XML_PATH      :     '${lmsxml_Path}'"

	lmsConioDisplay "XPATH         :     '${lmsxml_XPath}'"
}

# *******************************************************
#
#	testLmsRDomXPNData
#
#		Show the xml data element selected
#
# *******************************************************
testLmsRDomXPNData()
{
	local content

	lmsConioDisplay ""
	lmsConioDisplay "XML_ENTITY    : '${lmsxml_Entity}'"

	lmsStrTrim "${lmsxml_Content}" lmsxml_Content

	lmsConioDisplay "XML_CONTENT   :     '${lmsxml_Content}'"

	lmsConioDisplay "XML_TAG_NAME  :     '${lmsxml_TagName}'"
	lmsConioDisplay "XML_TAG_TYPE  :     '${lmsxml_TagType}'"

	if [[ "${lmsxml_TagType}" == "OPEN" || "${lmsxml_TagType}" == "OPENCLOSE" ]]
	then
		if [ -n "${lmsxml_Attributes}" ]
		then
			lmsRDomParseAtt

			lmsConioDisplay "XML_ATT_COUNT :     '${#lmsxml_AttributesArray[@]}'"
		
			for attribute in "${!lmsxml_AttributesArray[@]}"
			do
				lmsConioDisplay "XML_ATT_NAME  :     '${attribute}'"
				lmsConioDisplay "XML_ATT_VAL   :     '${lmsxml_AttributesArray[$attribute]}'"
				
			done
		fi
	fi

	lmsStrTrim "${lmsxml_Comment}" lmsxml_Comment

	lmsConioDisplay "XML_COMMENT   :     '${lmsxml_Comment}'"
	lmsConioDisplay "XML_PATH      :     '${lmsxml_Path}'"

	lmsConioDisplay "XPATH         :     '${lmsxml_XPath}'"
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

lmsStackCreate "global" lmstst_guid 8
[[ $? -eq 0 ]] ||
 {
	lmsConioDebugExit $LINENO "Debug" "StackCreate Unable to open/create stack 'global'"
 }

lmsStackCreate "namespace" lmstst_nsuid 8
[[ $? -eq 0 ]] ||
 {
	lmsConioDebugExit $LINENO "Debug" "StackCreate Unable to open/create stack 'namespace'"
 }

# *******************************************************

if [[ $showData -ne 0 ]]
then
	lmsRDomCallback "testLmsRDomXPNData" 
	[[ $? -eq 0 ]] ||
	 {
		lmsConioDebugExit $LINENO "RDomError" "Callback function name is missing"
	 }

	lmsRDomParseDOM ${lmstst_Declarations}
	[[ $? -eq 0 ]] ||
	 {
		lmsConioDebugExit $LINENO "RDomError" "TDOMParseDOM '${lmstst_Declarations}'"
	 }

	lmsConioDisplay "*******************************************************"

fi

# *******************************************************

lmsRDomCallback "lmsRDOMXPathNode" 
[[ $? -eq 0 ]] ||
 {
	lmsConioDebugExit $LINENO "RDomError" "Callback function name is missing"
 }

lmsRDomParse ${lmstst_Declarations}
[[ $? -eq 0 ]] ||
 {
	lmsConioDebugExit $LINENO "RDomError" "TDOMParseDOM '${lmstst_Declarations}'"
 }

# *****************************************************************************

. $testlibDir/testEnd.bash

# *****************************************************************************


# ******************************************************************************
# ******************************************************************************
#
#   	lmsRDomXPathN.bash
#
#		Creates a single XPath node (array) element from the xml element
#
# *****************************************************************************
#
# @author Jay Wheeler.
# @version 0.0.2
# @copyright © 2016, 2017. EarthWalk Software.
# @license Licensed under the Academic Free License version 3.0
# @package Linux Management Scripts
# @subpackage RDOMXPathNode
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
#			Version 0.0.1 - 07-14-2016.
#					0.0.2 - 02-10-2017.
#
# ******************************************************************************
# ******************************************************************************

declare -r lmslib_RDOMXPathN="0.0.2"		# version of RDOMXPathNode library

# ******************************************************************************
#
#	Global declarations
#
# ******************************************************************************

# ******************************************************************************
# ******************************************************************************
#
#						Functions
#
# ******************************************************************************
# ******************************************************************************

# ******************************************************************************
#
#	lmsRDomXPNSet
#
#		Set the RDOMXPath node values
#
#	parameters:
#		None
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# ******************************************************************************
function lmsRDomXPNSet()
{
	local nodeName=${1}
	local nsNodeName

	if [ -z "${nodeName}" ]
	then
		lmsConioDebug $LINENO "RDOMNodeError" "Node name required."
		return 1
	fi

	lmsRDomXPNInit
	[[ $? -eq 0 ]] ||
	 {
		lmsConioDebug $LINENO "RDOMNodeError" "Node initialize failed."
		return 1
	 }

	nsNodeName="${lmsrdom_xpnNamespace}_node_${nodeName}"

	declare -p "${nsNodeName}" > /dev/null 2>&1
	[[ $? -eq 0 ]] &&
	 {
		lmsConioDebug $LINENO "RDOMNodeError" "Node '${nsNodeName}' already exists.."
		return 1
	 }

	lmsDeclareAssoc "${nsNodeName}"
	[[ $? -eq 0 ]] ||
	 {
		lmsConioDebug $LINENO "RDOMNodeError" "lmsDeclareAssoc unable to create '${nsNodeName}'."
		return 1
	 }

	local entityList=( "XPATH" "XML_ENTITY" "XML_CONTENT" "XML_TAG_NAME" "XML_TAG_TYPE" "XML_COMMENT" "XML_PATH" "XML_ATT_COUNT" )

	for entity in ${entityList}
	do
		case ${entity} in
		
			"XPATH") 
				declareAddElement "XPATH" $lmsxml_XPath
				 ;;
	
			"XML_ENTITY")
				declareAddElement "XML_ENTITY" $lmsxml_Entity
				;;

			"XML_CONTENT")
				declareAddElement "XML_CONTENT"   $lmsxml_Content
				;;

			"XML_TAG_NAME")
				declareAddElement "XML_TAG_NAME"  $lmsxml_TagName
				;;

			"XML_TAG_TYPE")
				declareAddElement "XML_TAG_TYPE"  $lmsxml_TagType
				;;

			"XML_COMMENT")
				declareAddElement "XML_COMMENT"   $lmsxml_Comment

			"XML_PATH")
				declareAddElement "XML_PATH"      $lmsxml_Path
				;;

			"XML_ATT_COUNT")
				declareAddElement "XML_ATT_COUNT" $lmsxml_AttCount
				;;

			*)
				lmsConioDebug $LINENO "RDOMNodeError" "Unknown entity selection: $entity"
				return 1
		esac

		[[ $? -eq 0 ]] ||
		{
			lmserr_result=$?
			lmsConioDebug $LINENO "RDOMNodeError" "Unable to set entity: $entity, error: ${lmserr_result}"
			return 1
		}

	done

	for attribute in "${!lmsxml_AttributesArray[@]}"
	do
		declareAddElement "XML_ATT_NAME" "${attribute}"
		[[ $? -eq 0 ]] ||
		 {
			lmserr_result=$?
			lmsConioDebug $LINENO "RDOMNodeError" "Unable to set attribute: $attribute, error: ${lmserr_result}"
			return 1
		 }

		declareAddElement "XML_ATT_VAL" "${lmsxml_AttributesArray[$attribute]}"
		[[ $? -eq 0 ]] ||
		 {
			lmserr_result=$?
			lmsConioDebug $LINENO "RDOMNodeError" "Unable to set attributeValue: '${lmsxml_AttributesArray[$attribute]}', error: ${lmserr_result}"
			return 1
		 }

	done

	lmsrdom_xpnCurentNode=${nsNodeName}

	return 0
}

# ******************************************************************************
#
#	lmsRDomXPNInit
#
#		Initialize the node
#
#	parameters:
#		None
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# ******************************************************************************
function lmsRDomXPNInit()
{
	declare -p "lmslib_dynaArray" > /dev/null 2>&1
	[[ $? -eq 0 ]] &&
	 {
		lmsConioDebug $LINENO "RDOMNodeError" "RDOMXPathNode requires the following library: 'lmslib_dynamicArrayFunctions'"
		return 1
	 }

	return 0
}


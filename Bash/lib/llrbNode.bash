#!/bin/bash

# *********************************************************************************
# *********************************************************************************
#
#   llrbNode.bash
#
#		Left-Leaning Red-Black Tree Node
#
# *****************************************************************************
#
# @author Jay Wheeler.
# @version 0.0.1
# @copyright © 2016. EarthWalk Software.
# @license Licensed under the Academic Free License version 3.0
# @package Linux Management Scripts
# @subpackage llrbNode
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
#			Version 0.0.1 - 02-29-2016.
#
# *********************************************************************************
# *********************************************************************************

declare -A  lmsllrb_NodeTable		#  lmsllrb_NodeTable[key]=UID
declare -a 	lmsllrb_NodeFields=( [0]=key [1]=data [2]=left [3]=right [4]=color [5]=uid )

declare -r lmsllrb_NodeRED=1
declare -r lmsllrb_NodeBLACK=0

declare -r lmsllrb_NodeLEFT=1
declare -r lmsllrb_NodeRIGHT=0

# *********************************************************************************
# *********************************************************************************
#
#	Each node is declared as a five-element associative array
#
#		"key"		= the name (or key) of the node, to be used in tree placement
#
#		"data"		= the "data" (or value associated with the key) (optional)
#		"left"		= the "key" of the left node, or null
#		"right"		= the "key" of the right node, or null
#		"color"		= the "color" of the node (1 = red, 0 = black)
#
#	The name of the array will be llrbNode_$UID
#		where UID is a (semi) unique identifier assigned to the node
#			for branching purposes.
#
#	The lmsllrb_NodeTable can be used to convert between the UID and the key name
#
# *********************************************************************************
# *********************************************************************************

# *********************************************************************************
#
#	llrbNodeCreate
#
#		Create a new llrb node array and initialize the entries
#
#	parameters:
#		key = the key to store in the tree structure
#		result = the place to return the name of the llrbNode array
#		data = (optional) data to place in the array
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# *********************************************************************************
function llrbNodeCreate()
{
	local llrbKey="${1}"
	local llrbResult=$2
	local llrbData="${3}"

	local llrbUid

	while true
	do
		llrbNodeLookup "${llrbKey}" llrbUid
		if [ $? -eq 1 ]
		then
    		lmsErrorQWrite $LINENO NodeCreate "Node '${llrbKey}' already exists, uid = '${llrbUid}'"
			break
		fi

		lmsUIdUnique llrbUid
		if [ $? -eq 0 ]
		then
			lmsllrb_NodeTable["${llrbKey}"]="$llrbUid"
			break
		fi

   		lmsErrorQWrite $LINENO NodeCreate "Unable to get Unique id"
		return $?
	done

	lmsDeclareAssoc "llrbNode_${llrbUid}"


	lmsDeclareArrayEl "llrbNode_${llrbUid}" "uid"	 "$llrbNode_${llrbUid}"

	lmsDeclareArrayEl "llrbNode_${llrbUid}" "key"   "$llrbKey"
	lmsDeclareArrayEl "llrbNode_${llrbUid}" "data"  "${llrbData}"
	lmsDeclareArrayEl "llrbNode_${llrbUid}" "left"  0
	lmsDeclareArrayEl "llrbNode_${llrbUid}" "right" 0
	lmsDeclareArrayEl "llrbNode_${llrbUid}" "color" $lmsllrb_NodeRED

	eval "$llrbResult='$llrbUid'"

	return 0
}

# *********************************************************************************
#
#	llrbNodeDelete
#
#		delete the llrbNode
#
#	parameters:
#		key   = the node to search for
#
#	returns:
#		0 = no error
#		1 = unable to delete (not in the table)
#
# *********************************************************************************
function llrbNodeDelete()
{
	local llrbNKey="${1}"
	local llrbNUid

	if [ -z "${lmsllrb_NodeTable[$llrbNKey]}" ]
	then
    	lmsErrorQWrite $LINENO NodeDelete "Node '${llrbNKey}' not found."
		return 1
	fi

	llrbNUid=${lmsllrb_NodeTable[$llrbNKey]}
	unset lmsllrb_NodeTable["$llrbNKey"]

	eval "unset llrbNode_${llrbNUid}"

	return 0
}

# *********************************************************************************
#
#	llrbNodeGet
#
#		get the llrbNode element
#
#	parameters:
#		name   	= the node name to search for
#		element	= element of node array to fetch
#		ret 	= place to store the result
#
#	outputs:
#		value = the value from the requested element (if 'ret' is not supplied)
#
#	returns:
#		0 = not found in table, uid is invalid
#		1 = found in table, uid is valid
#
# *********************************************************************************
function llrbNodeGet()
{
	local lnname=$1
	local lnelement=$2

	llrbNodeLookup "${lnname}" llrbUid
	if [ $? -eq 0 ]
	then
    	lmsErrorQWrite $LINENO NodeGet "Node '${lnname}' not found."
    	return 1
	fi

	local element
	eval 'element=$'"{llrbNode_$llrbUid[$lnelement]}"

	if [ -n "${3}" ]
	then
    	eval ${3}="'${element}'"
    else
    	echo "${element}"
	fi
}

# *********************************************************************************
#
#	llrbNodeSet
#
#		set the llrbNode element
#
#	parameters:
#		name   	= the node name to search for
#		element	= element of node array to fetch
#		value 	= value to store in the node element
#
#	returns:
#		0 = not found in table, uid is invalid
#		1 = found in table, uid is valid
#
# *********************************************************************************
function llrbNodeSet()
{
	local llrbGName=$1
	local llrbGElement=$2
	local llrbGValue=${3}

	llrbNodeLookup "${llrbGName}" llrbUid
	if [ $? -eq 0 ]
	then
    	lmsErrorQWrite $LINENO NodeSet "Node '${llrbGName}' not found."
    	return 1
	fi

	eval "llrbNode_$llrbUid[${llrbGElement}]='${llrbGValue}'"
}

# *********************************************************************************
#
#	llrbNodeLookup
#
#		get the llrbNode key uid
#
#	parameters:
#		key   = the key to search for
#		uid   = place to store the result
#
#	returns:
#		0 = not found in table, uid is invalid
#		1 = found in table, uid is valid
#
# *********************************************************************************
function llrbNodeLookup()
{
	local llrbNKey="${1}"
	local llrbNUid=$2

	if [[ ! "${#lmsllrb_NodeTable[@]}" =~ "$llrbNKey" ]]
	then
		return 0
	fi

	llrbNodeVarKey=$llrbNKey
	llrbNodeVarUid=${lmsllrb_NodeTable[$llrbNKey]}
	llrbNodeVarName="llrbNode_"${llrbNodeVarUid}

	if [ -n "${2}" ]
	then
		eval ${2}="'$llrbNodeVarUid'"
	else
		echo "${llrbNodVarUid}"
	fi

	return 1
}

# *********************************************************************************
#
#	llrbNodeToString
#
#		Return a printable buffer containing data about the node in question
#
#	parameters:
#		name   = the node name (key)
#		buffer = place to store the result
#
#	returns:
#		0 = no error
#		1 = error code
#
# *********************************************************************************
function llrbNodeToString()
{
	local llrbSName="${1}"
	local llrbSBuffer=$2

	local llrbSValue=""
	local field=""
	local nodeField=""

	local llrbBuffer
	printf -v llrbBuffer "Node: %s\n" "$llrbSName"

	for field in "${lmsllrb_NodeFields[@]}"
	do
		llrbNodeGet ${llrbSName} ${field} llrbSValue
		if [ $? -eq 1 ]
		then
    		lmsErrorQWrite $LINENO NodeList "Unable to fetch field $field in $llrbSName"
			break
		fi

		printf -v nodeField "    %s = %s\n" "$field" "${llrbSValue}"
		llrbBuffer=$llrbBuffer$nodeField
	done

#	if [ -n "$2" ]
#	then
#		eval "$llrbSBuffer='$llrbBuffer'"
#	else
		echo "${llrbBuffer}"
#	fi
}

# *********************************************************************************
#
#	llrbNodeCopy
#
#		Copy the source node to the destination node
#
#	parameters:
#		destination	= the node name to copy to
#		source 	    = the node name to copy from
#
#	returns:
#		0 = no error
#		1 = error occured
#
# *********************************************************************************
function llrbNodeCopy()
{
	local lldestination=$1
	local llsource=$2

	local llrbUid

	llrbNodeLookup "${llsource}" llrbUid
	if [ $? -eq 0 ]
	then
    	lmsErrorQWrite $LINENO NodeCopy "Source node '${llsource}' not found."
    	return 1
	fi

	llrbNodeLookup "${lldestination}" llrbUid
	if [ $? -eq 0 ]
	then
    	lmsErrorQWrite $LINENO NodeCopy "Destination node '${lldestination}' not found."
    	return 1
	fi

	for key in "${lmsllrb_NodeFields[@]}}"
	do
		if [[ "$key" != "uid" && "$key" != "key" ]]
		then
			value=$( llrbNodeGet $llsource "$key" )
			if [ $? -ne 0 ]
			then
    			lmsErrorQWrite $LINENO NodeCopy "Could not get source node '${llsource}' value."
				return 1
			fi

			llrbNodeSet $lldestination "$key" "${value}"
			if [ $? -ne 0 ]
			then
    			lmsErrorQWrite $LINENO NodeCopy "Could not set destination node '${lldestination}' value."
				return 1
			fi
		fi
	done

	return 0
}

# *********************************************************************************
#
#	llrbNodeCompare
#
#		Compare the source node to the compare node
#			(e.g. source < compare)
#
#	parameters:
#		compare	= the name of the node to compare the source node with
#		source 	= the node name of the source node to compare
#
#	returns:
#		 0 => source = compare
#		 1 => source > compare
#		 2 => source < compare
#		 3 => error
#
# *********************************************************************************
function llrbNodeCompare()
{
	local llsource="${1}"
	local llcompare="${2}"

	local llrbUid

	while true
	do
		llrbNodeLookup "${llsource}" llrbUid
		if [ $? -eq 0 ]
		then
    		lmsErrorQWrite $LINENO NodeCompare "Source node '${llsource}' not found."
    		break
		fi

		llrbNodeLookup "${llcompare}" llrbUid
		if [ $? -eq 0 ]
		then
    		lmsErrorQWrite $LINENO NodeCompare "Comparison node '${llcompare}' not found."
    		break
		fi

		llsname=$( llrbNodeGet "${llsource}" "key" )
		[ $? -ne 0 ] && break

		llcname=$( llrbNodeGet "${llcompare}" "key" )
		[ $? -ne 0 ] && break

		#
		#  less
		#
		if [ "$llsname" \< "$llcname" ]
		then
			return 2
		fi

		#
		#  greater
		#
		if [ "$llsname" \> "$llcname" ]
		then
			return 1
		fi

		return 0

	done

	return 3
}

# *********************************************************************************

# *********************************************************************************
#
#	llrbNode_Field
#
#		Set/Get the node key
#
#	Parameters:
#		llnode = node to get the value for
#		llvalue = storage for the field value
#		llnewValue = (optional) new field value to set FIRST, if not empty
#
#	Returns:
#		0 = no error
#		1 = error occurred
#
# *********************************************************************************
function llrbNode_Field()
{
	local llnode=$1
	local llfield=$2
	local llvalue=$3
	local llnewValue=$4

echo "llfield = '$llfield'"

	if ! [[ ${lmsllrb_NodeFields[@]} =~ ${llfield} ]]
	then
		lmsErrorQWrite $LINENO NodeField "Invalid/unknown field name '${llfield}'."
		return 1
	fi

	if [[ -n "$llnewValue" ]]
	then
		llrbNodeSet $llnode $llfield $llnewValue
		if [[ $? -ne 0 ]]
		then
			lmsErrorQWrite $LINENO NodeField "Unable to set field name '${llfield}' in '$llnode'."
			return 1
		fi
	fi

	llrbNodeGet $llnode $llfield llvalue
	if [[ $? -ne 0 ]]
	then
		lmsErrorQWrite $LINENO NodeField "Unable to get value field name '${llfield}' in '$llnode'."
errorQueueDisplay 1 1
dumpNameTable
exit 1
		return 1
	fi

	return 0
}

# *********************************************************************************


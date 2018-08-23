# *****************************************************************************
# *****************************************************************************
#
#   	lmsDomTs.bash
#
# *****************************************************************************
#
# @author Jay Wheeler.
# @version 0.1.1
# @copyright © 2016, 2017. EarthWalk Software.
# @license Licensed under the Academic Free License version 3.0
# @package Linux Management Scripts
# @subpackage lmsDomToStr
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
#			Version 0.0.1 - 07-24-2016.
#					0.0.2 - 09-06-2016.
#					0.0.3 - 09-15-2016.
#					0.1.0 - 01-15-2017.
#					0.1.1 - 02-10-2017.
#
# *****************************************************************************
# *****************************************************************************

declare -r lmslib_lmsDomToStr="0.1.1"	# version of this library

# *******************************************************
# *******************************************************

declare    lmsdts_buffer
declare    lmsdts_stackName="DTSBranches"

# ****************************************************************************
#
#	lmsDomTsFmtIndent
#
#		Add spaces (indentation) to the buffer
#
# 	Parameters:
#  		stackIndex = how many blocks to indent
#		blockSize = (optional) number of spaces in a block
#
#	Returns:
#		0 = no error
#
# ****************************************************************************
function lmsDomTsFmtIndent()
{
	local -i stkIndent=${1:-0}

	[[ ${stkIndent} -gt 0 ]]  &&  printf -v lmsdts_buffer "%s%*s" "${lmsdts_buffer}" ${stkIndent}
	return 0
}

# ****************************************************************************
#
#	lmsDomTsAddAtt
#
# 	Parameters:
#		aUid = uid of the node
#  		attIndent = columns to indent
#
#	Returns:
#		0 = no error
#		non-zero = error code
#
# ****************************************************************************
function lmsDomTsAddAtt()
{
	local aUid=${1}
	local attIndent=${2}

	local attName="lmsdom_${aUid}_att"
	local attValue
	local attKey

	lmsDynnReset $attName
	[[ $? -eq 0 ]] || return 0

	lmsDynnValid ${attName} lmsdom_nodeValid
	[[ $? -eq 0 ]] || return 1

	while [[ ${lmsdom_nodeValid} -eq 1 ]]
	do
		lmsDynnMap ${attName} attValue attKey
		[[ $? -eq 0 ]] || return 1

		printf -v lmsdts_buffer "%s %s=%s" "${lmsdts_buffer}" ${attKey} "${attValue}"

		lmsDynnNext ${attName}
		lmsDynnValid ${attName} lmsdom_nodeValid
	done

	return 0
}

# ****************************************************************************
#
#	lmsDomTsFmtOut
#
#		Add node info to the buffer
#
# 	Parameters:
#  		uid = node uid to add
#
#	Returns:
#		0 = no error
#		non-zero = error code
#
# ****************************************************************************
function lmsDomTsFmtOut()
{
	local uid=${1}
	local node="lmsdom_${uid}_node"
	local tagName=""
	local attcount=0

	lmsDynaGetAt $node "tagname" tagName
	[[ $? -eq 0 ]] || return 1

	lmsDynaGetAt $node "attcount" attcount
	[[ $? -eq 0 ]] || return 1

	local stackIndent
	lmsStackSize ${lmsdts_stackName} stackIndent
	[[ $? -eq 0 ]] || return 1

	lmsUtilIndent $stackIndent lmsdts_buffer
	printf -v lmsdts_buffer "%s%s" "${lmsdts_buffer}" "${tagName}"

	(( stackIndent++ ))

	[[ ${attcount} -eq 0 ]] ||
	 {
		lmsDomTsAddAtt ${uid} ${stackIndent}
		[[  $? -eq 0 ]] || return 1
	 }

	lmsDynaGetAt $node "content" content
	[[  $? -eq 0 ]] || return 1

	[[ -n "${content}" ]] && printf -v lmsdts_buffer "%s content=\"%s\"" "${lmsdts_buffer}" "${content}"
	printf -v lmsdts_buffer "%s\n" "${lmsdts_buffer}"

	return 0
}

# ****************************************************************************
#
#	lmsDomTsTraverse
#
# 	Parameters:
#  		branch = branch node name to traverse
#
#	Returns:
#		0 = no error
#		non-zero = error code
#
# ****************************************************************************
function lmsDomTsTraverse()
{
	local branch=${1}

	local branchName="lmsdom_${branch}"
	local limbs=0
	local limb

	lmsStackWrite ${lmsdts_stackName} ${branch}
	[[ $? -eq 0 ]] || return 1

	lmsDynnReset "$branchName"
	[[ $? -eq 0 ]] || return 1

	lmsDynnValid "$branchName" lmsdom_nodeValid

	while [[ ${lmsdom_nodeValid} -eq 1 ]]
	do
		lmsDynnMap "$branchName" limb
		[[ $? -eq 0 ]] || return 1

		lmsDomTsFmtOut ${limb}
		[[ $? -eq 0 ]] || return 1

		lmsDomTsTraverse ${limb}
		[[ $? -eq 0 ]] || break

		lmsStackPeek "${lmsdts_stackName}" branch
		[[ $? -eq 0 ]] || return 1

		branchName="lmsdom_${branch}"

		lmsDynnNext "$branchName"
		lmsDynnValid "$branchName" lmsdom_nodeValid
	done

	lmsStackRead ${lmsdts_stackName} branch
	[[ $? -eq 0 ]] || 
	 {
		[[ $? -ne 2 ]] || return 1
	 }
	
	return 0
}

# ****************************************************************************
#
#	lmsDomToStr
#
# 	Parameters:
#  		returnString = place to put the generated string
#
#	Returns:
#		0 = no error
#		non-zero = error code
#
# ****************************************************************************
function lmsDomToStr()
{
	local stackUid
	lmsdts_buffer=""

	[[ -z "${lmsdom_docTree}" ]] && return 1

	lmsStackLookup "${lmsdts_stackName}" stackUid
	[[ $? -eq 0 ]] && lmsStackDestroy ${lmsdts_stackName}

	lmsStackCreate ${lmsdts_stackName} stackUid 12
	[[ $? -eq 0 ]] || return 2

	lmsDomTsFmtOut ${lmsdom_docTree}
	[[ $? -eq 0 ]] || return 3

	lmserr_result=0

	lmsDomTsTraverse ${lmsdom_docTree}
	[[ $? -eq 0 ]] || return 4

	lmsDeclareStr ${1} "${lmsdts_buffer}"
	[[ $? -eq 0 ]] || return 5

	return 0
}



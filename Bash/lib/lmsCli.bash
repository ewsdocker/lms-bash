# *****************************************************************************
# *****************************************************************************
#
#   lmsCli.bash
#
# *****************************************************************************
#
# @author Jay Wheeler.
# @version 0.1.0
# @copyright © 2016, 2017. EarthWalk Software.
# @license Licensed under the Academic Free License version 3.0
# @package Linux Management Scripts
# @subpackage lmsCliParam
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
#			Version 0.0.1 - 02-24-2016.
#					0.0.2 - 07-01-2016.
#					0.0.3 - 08-19-2016.
#					0.0.4 - 09-07-2016.
#					0.1.0 - 01-24-2017.
#					0.1.1 - 02-12-2017.
#
# *****************************************************************************
# *****************************************************************************

declare    lmslib_lmsCli="0.1.1"			# library version number

# *****************************************************************************

declare -a lmscli_ParameterBuffer=( "$@" )		# cli parameter array buffer
declare    lmscli_ParameterList=""			# cli parameter list (string)
declare    lmscli_ParameterPointer=0			# cli parameter buffer index

#declare -a lmscli_cmndsValid=()			# array of valid commands for this object

declare    lmscli_cmnds="lmscli_commands"		# commands
declare    lmscli_cmndNum=0				# command stack index of the current command
declare    lmscli_command=""				# cli command

declare -a lmscli_parsed=()				#
declare -a lmscli_exploded=()				#

#declare -A lmscli_shellParameters=()			# provided by config file
declare -A lmscli_InputParameters=()			# input parameters
declare -a lmscli_InputErrors=()				# input parameter error names

declare -i lmscli_commandErrors=0				# cli command error count
declare -i lmscli_parameterErrors=0				# cli parameter error count
declare -i lmscli_Errors=0						# number of cli errors detected

# **************************************************************************
#
#	lmsCliValidCmnd
#
#	Returns 0 if the command is valid, 1 if not
#
#	parameters:
#		cmnd = command
#
#	returns:
#		result = 0 if found, 1 if not found
#
# **************************************************************************
function lmsCliValidCmnd()
{
	[[ ${#lmscli_cmndsValid[@]} -eq 0  ||  -z "${1}" ]] && return 1
 	[[ " ${lmscli_cmndsValid[@]} " =~ "${1}" ]] && return 0
	return 2
}

# **************************************************************************
#
#	lmsCliCmndNew
#
#		create a new command entry and node
#
#	parameters:
#		pCmnd = command
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# **************************************************************************
function lmsCliCmndNew()
{
	[[ -z "${1}" ]] && return 1

	lmscli_command="${1}"

	lmsCliCmndValid ${lmscli_command}
	[[ $? -eq 0 ]] || return 2
	
	lmsStackSize ${lmscli_cmnds} lmscli_cmndNum
	[[ $? -eq 0 ]] || return 3

	lmsClinName ${lmscli_command} ${lmscli_cmndNum} lmsclin_node

	lmsUtilVarExists ${lmsclin_node}
	[[ $? -eq 0 ]] || return 4

	lmsDynaNew ${lmsclin_node} "A"
	[[ ? -eq 0 ]] || return 5

	lmsStackWrite ${lmscli_cmnds} ${lmscli_command}
	[[ $? -eq 0 ]] && return 0

	return 6

}

# **************************************************************************
#
#	lmsCliValidParameter
#
#	Returns 0 if the parameter name is valid, 1 if not
#
#	parameters:
#		cliParameterName = parameter name
#
#	returns:
#		0 = found, 
#		1 = no valid parameters exist
#		2 = requested parameter is invalid
#
# **************************************************************************
function lmsCliValidParameter()
{
	[[ -z "${1}" ]] && return 1

	[[ ${#lmscli_shellParameters[@]} -gt 0  &&  "${!lmscli_shellParameters[@]}" =~ "${1}" ]] && return 0
	return 2
}

# **************************************************************************
#
#	lmsCliLookupParameter
#
#		Lookup the parameter and set the option name
#
#	parameters:
#		cliParameterName = parameter name
#		OptionName = location to place the option name
#
#	returns:
#		0 = found, 
#		1 = requested parameter is invalid
#
# **************************************************************************
function lmsCliLookupParameter()
{
	[[ -z "${1}"  ||  -z "${2}" ]] && return 1
	
	local parameter="${1}"

	lmsCliValidParameter "${parameter}"
	[[ $? -eq 0 ]] || return 2

	eval ${2}="'${lmscli_shellParameters[$parameter]}'"
	return 0
}

# **************************************************************************
#
#	lmsCliCheckParameter
#
#		check input parameter name and value
#
#	parameters:
#		pName = parameter name
#		pValue = parameter value
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# **************************************************************************
function lmsCliCheckParameter()
{
	[[ -z "${1}" ]] && return 1

	local pName=${1}
	local pValue="${2}"

	lmsCliValidParameter ${pName}
	[[ $? -eq 0 ]] &&
	 {
		lmscli_InputParameters[${pName}]="${pValue}"
		return 0
	 }

	lmscli_InputErrors[${#lmscli_InputErrors[@]}]="${pName}"
	lmscli_ParameterErrors=${#lmscli_InputErrors[@]}
	(( lmscli_Errors++ ))

	return 2
}

# **************************************************************************
#
#	lmsCliSplitParameter
#
#		Splits the parameter string into name and value
#
#	parameters:
#		parameter = parameter string
#
#	returns:
#		result = 0 if parameter is valid
#			   = 1 if parameter is a command
#			   = 2 if valid parameter format, but parameter is not valid
#						(the name and value are stored in lmscli_InputParameters first)
#			   > 2 ==> error code
#
# **************************************************************************
function lmsCliSplitParameter()
{
	[[ -z "${1}" ]] && return 1

	local paramName
	local paramValue

	lmsStrSplit "${1}" paramName paramValue

	if [ -z "${paramValue}" ]
	then
		lmsCliCmndNew $paramName
		[[ $? -eq 0 ]] || return 2
	else
		lmsCliCheckParameter $paramName "$paramValue"
		[[ $? -eq 0 ]] || return 3
	fi

	return 0
}

# **************************************************************************
#
#	lmsCliParseParameter
#
#		parse the cli parameters in global lmscli_ParameterBuffer array
#			and store results in lmscli_shellParameters, lmscli_command,
#		    lmscli_cmndsValid
#
#	parameters:
#		Check-Validity = 1 to check for valid parameter name
#
#	returns:
#		Result = 0 if no error,
#				 1 if empty parameter buffer,
#
# **************************************************************************
function lmsCliParseParameter()
{
	[[ ${#lmscli_ParameterBuffer} -eq 0 ]] && return 0
	lmscli_ParameterList="${lmscli_ParameterBuffer[@]}"

	local validate=${1:-"$lmscli_Validate"}
	
	lmscli_Errors=0
	lmscli_InputErrors=()
	lmscli_InputParameters=()

	lmscli_parameterErrors=0
	lmscli_commandErrors=0

	local pString

	for pString in "${lmscli_ParameterBuffer[@]}"
	do

		lmsCliSplitParameter "${pString}" ${validate}
		[[ $? -eq 0 ]] || break
	done

	[[ "${lmscli_command}" ]] && 
	 {
		lmscli_shellParameters["${lmscli_command}"]="${lmscli_cmndsValid}"
		eval "lmscli_shellParameters[${lmscli_command}]='${lmscli_cmndsValid}'"
	 }

	return 0
}

# **************************************************************************
#
#	lmsCliApplyInput
#
#		Apply the pending cliInputParameters
#
#	parameters:
#		none
#
#	returns:
#		0 = no error
#		non-zero = error code
#
# **************************************************************************
function lmsCliApplyInput()
{
	[[ ${#lmscli_InputParameters[@]} -eq 0 ]] && return 0

	local iName
	local iOption
	local iValue

	for iName in "${!lmscli_InputParameters[@]}"
	do
		iValue="${lmscli_InputParameters[$iName]}"

		lmsCliLookupParameter $iName iOption
		[[ $? -eq 0 ]] || return 1
		
		iOption="lmscli_${iOption}"

		lmsDeclareSet "${iOption}" "${iValue}"
		[[ $? -eq 0 ]] || return 2
	done

	return 0
}


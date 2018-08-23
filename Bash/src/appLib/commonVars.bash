#
# script version - s/b replace in script with actual version
#
lmsscr_Version="0.0.1"						# script version

#
# test files
#
lmsvar_errors="$etcDir/errorCodes.xml"
lmsvar_help="$etcDir/testHelp.xml"			# path to the help information file

#
# test vars
#
lmsapp_guid=""
lmsapp_nsuid=""

lmsapp_logDir="${dirAppLog}"
lmsapp_logName="${dirAppLog}/${lmsapp_name}"

lmsapp_result=0

lmsapp_stackSize=0
lmsapp_stackCurrent=0

lmsapp_buffer=""
lmsapp_item=""

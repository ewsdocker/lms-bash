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
lmstst_guid=""
lmstst_nsuid=""

lmstst_logDir="/var/local/log/lms-test/"

lmstst_result=0

lmstst_stackSize=0
lmstst_stackCurrent=0

lmstst_buffer=""
lmstst_item=""

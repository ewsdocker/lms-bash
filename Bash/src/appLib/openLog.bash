#
#	Use the script name to create a log name and prepend the path
#
lmsapp_logName="${dirAppLog}/${lmsapp_name}.log"

#
#	Open the newly named log file
#
lmsLogOpen "${lmsapp_logName}" "new"
[[ $? -eq 0 ]] ||
 {
	lmscli_optSilent=0
	lmsConioDisplay "Unable to open log file: '${lmsapp_logName}'"
	exit 1
 }


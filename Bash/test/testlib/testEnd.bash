
[[ $lmscli_optDebug -eq 0  &&  lmscli_optQueueErrors -ne 0 ]]  &&  lmsErrorQDispPop

lmsConioDisplay ""
lmsConioDisplay "$(tput bold) Log-file: '${lmstst_logName}' $(tput sgr0)"

lmsErrorExitScript "EndOfTest"


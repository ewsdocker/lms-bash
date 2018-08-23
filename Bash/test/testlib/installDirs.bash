lmscli_optProduction=0

if [[ $lmscli_optProduction -eq 1 ]]
then
	rootDir="/usr/local"
	libDir="$rootDir/lib/lms/bash"
	etcDir="$rootDir/etc/lms"
	srcDir="../src"
else
	rootDir="../.."
	libDir="$rootDir/lib"
	etcDir="$rootDir/etc"
	srcDir="../src"
fi

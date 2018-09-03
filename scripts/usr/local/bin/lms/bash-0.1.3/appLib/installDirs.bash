
if [[ ${lmscli_optProduction} -eq 1 ]]
then
	lmsbase_dirBase="/usr/local"

	dirBash="${lmsbase_dirBase}/share/LMS/Bash/${lmslib_bashRelease}"
	lmsbase_dirAppSrc="${dirBash}"

	lmsbase_dirEtc="${lmsbase_dirBase}/etc/LMS/Bash/${lmslib_bashRelease}"
	lmsbase_dirLib="${lmsbase_dirBase}/lib/LMS/Bash/${lmslib_bashRelease}"

	lmsbase_dirAppLog="/var/local/log/LMS/Bash/${lmslib_bashRelease}"
	dirAppBkup="/var/local/backup/LMS/Bash/${lmslib_bashRelease}"
else
	lmsbase_dirBase=${PWD%"/$lmslib_bashRelease"*}

	dirBash="${lmsbase_dirBase}/${lmslib_bashRelease}"
	lmsbase_dirAppSrc="${dirBash}/src"

	lmsbase_dirEtc="${dirBash}/etc"
	lmsbase_dirLib="${dirBash}/lib"

	lmsbase_dirAppLog="/var/local/log/LMS/Bash/${lmslib_bashRelease}/test"
	dirAppBkup="/media/sf_Shared/Backup/LMS/Bash/${lmslib_bashRelease}"
fi

lmsbase_dirApplication="${lmsbase_dirAppSrc}/${lmsapp_name}"
lmsbase_dirLib="${lmsbase_dirAppSrc}/appLib"

dirAppTmp="/var/local/temp/LMS"


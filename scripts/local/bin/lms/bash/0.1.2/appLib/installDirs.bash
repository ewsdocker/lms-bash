
if [[ ${lmscli_optProduction} -eq 1 ]]
then
	lmsbase_dirBase="/usr/local"

	dirBash="${lmsbase_dirBase}/share/LMS/Bash/${lmslib_release}"
	lmsbase_dirAppSrc="${dirBash}"

	lmsbase_dirEtc="${lmsbase_dirBase}/etc/LMS/Bash/${lmslib_release}"
	lmsbase_dirLib="${lmsbase_dirBase}/lib/LMS/Bash/${lmslib_release}"

	lmsbase_dirAppLog="/var/local/log/LMS/Bash/${lmslib_release}"
	dirAppBkup="/var/local/backup/LMS/Bash/${lmslib_release}"
else
	lmsbase_dirBase=${PWD%"/$lmslib_release"*}

	dirBash="${lmsbase_dirBase}/${lmslib_release}"
	lmsbase_dirAppSrc="${dirBash}/src"

	lmsbase_dirEtc="${dirBash}/etc"
	lmsbase_dirLib="${dirBash}/lib"

	lmsbase_dirAppLog="/var/local/log/LMS/Bash/${lmslib_release}/test"
	dirAppBkup="/media/sf_Shared/Backup/LMS/Bash/${lmslib_release}"
fi

lmsbase_dirApplication="${lmsbase_dirAppSrc}/${lmsapp_name}"
lmsbase_dirLib="${lmsbase_dirAppSrc}/appLib"

dirAppTmp="/var/local/temp/LMS"


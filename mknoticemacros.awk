#!/usr/bin/awk -f
BEGIN { FS="\t" }
{
	printf "m4_define(`NOTICE_TITLE', `%s')\n", $1
	printf "m4_define(`NOTICE_LINK', `%s')\n", $2
	printf "m4_define(`NOTICE_DATE', `%s')\n", $3
	printf "m4_define(`NOTICE_EXCERPT', `%s')\n", $4
	printf "m4_include(`notice_template.html')"
}

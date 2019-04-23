#!/bin/sh

PANUI_LOG_FILE=panui.log
# HTTPS seems to send back different (outdated) content...
PANUI_URL=http://www.rutherford.school.nz/daily-panui/
PANUI_RAW_HTML_FILE=.raw_panui.html
# The code below depends on it being CSV-like (commas as field delimeters).
MAILING_LIST_FILE=mailing_list.csv

# HTML not contained in a root `html` tag.
ORPHAN_NOTICES_FILE=.notices.html

UNSENT_MAIL_BODY_FILE=.panui_mail.html
PLAINTEXT_PART_FILE=nohtmlmessage.txt

# Prevent script from running during holidays.
if ! $(awk 'NF == 1 { print $1, $1 } NF == 2 { print $1, $2 }' ${HOLIDAYS:='holidays.txt'} | python blockondates.py 2>> $PANUI_LOG_FILE);
then
	exit 1
fi

# Prevent script from running on the weekend.
if ! $(python failonweekend.py 2>> $PANUI_LOG_FILE);
then
	exit 2
fi


#!/bin/sh

# TODO: Write documentation (at least for this main script).
# TODO: Don't write to a log file? Should the consumer of the script decide?

PANUI_LOG_FILE=panui.log
# The code below depends on it being CSV-like (commas as field delimeters).
MAILING_LIST_FILE=mailing_list.csv

# HTTPS seems to send back different (outdated) content...
PANUI_URL=http://www.rutherford.school.nz/daily-panui/
# The file to read the daily panui into when downloaded.
PANUI_RAW_HTML_FILE=.raw_panui.html

# HTML not contained in a root `html` tag.
ORPHAN_NOTICES_FILE=.notices.html

UNSENT_MAIL_BODY_FILE=.panui_mail.html
PLAINTEXT_PART_FILE=nohtmlmessage.txt

# Prevent script from running during holidays.
if ! ./ensure2fields.awk ${HOLIDAYS:='holidays.txt'} | ./failondates.awk 2>> $PANUI_LOG_FILE;
then
	exit 1
fi

# Prevent script from running on the weekend.
if ! ./failonweekend.py 2>> $PANUI_LOG_FILE;
then
	exit 2
fi

# Download daily panui.
wget --append-output=$PANUI_LOG_FILE --output-document=$PANUI_RAW_HTML_FILE $PANUI_URL

# Generate notices markup.

mail_subject=$(date +"Rutherford Panui, %d/%m/%y")
# Generate and send emails.
for recipient_record in $(cat $MAILING_LIST_FILE);
do
	name=$(echo $recipient_record | cut -f 1 -d ',')
	email=$(echo $recipient_record | cut -f 2 -d ',')
	
	# Generate email for current recipient.
	cat $ORPHAN_NOTICES_FILE | ./mkpanuimail.sh "$name" > "$UNSENT_MAIL_BODY_FILE"

	# Send email to current recipient.
	# I don't if the daily panui will have non US-ASCII letters. (which is why encoding is 8--not 7--bit)
	mail.mailutils -s "$mail_subject" --alternative \
		--content-type=text/html --encoding=8bit --attach="$UNSENT_MAIL_BODY_FILE" \
		"$email" < "$PLAINTEXT_PART_FILE"
done
./getnoticesinfo.sh < "$PANUI_RAW_HTML_FILE" 2>> "$PANUI_LOG_FILE" | tr -s '\n' | ./mknoticemacros.awk | m4 --prefix-builtins > "$ORPHAN_NOTICES_FILE"

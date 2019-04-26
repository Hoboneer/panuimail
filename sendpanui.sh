#!/bin/sh

# TODO: Write documentation (at least for this main script).
# TODO: Don't write to a log file? Should the consumer of the script decide?

PANUI_LOG_FILE=panui.log
# The code below depends on it being CSV-like (commas as field delimeters).
MAILING_LIST_FILE=mailing_list.csv
IGNORE_DATES_FILE=holidays.txt

# HTTPS seems to send back different (outdated) content...
PANUI_URL=http://www.rutherford.school.nz/daily-panui/
# The file to read the daily panui into when downloaded.
PANUI_RAW_HTML_FILE=.raw_panui.html

# HTML not contained in a root `html` tag.
ORPHAN_NOTICES_FILE=.notices.html

# Files used in processing for the plaintext part of the emails.
RAW_PLAINTEXT_NOTICES_FILE=.raw_notices.txt
PLAINTEXT_NOTICES_FILE=.notices.txt

# Strings enclosing the panui in the plaintext raw output (html2text).
# The end string will be excluded by further processing.
PANUI_START_STRING='****** Daily Panui ******'
PANUI_END_STRING='Copyright Rutherford_College - All Rights Reserved'

# Files whose content will be sent in the emails.
HTML_MAIL_BODY_FILE=.panui_mail.html
PLAINTEXT_MAIL_BODY_FILE=.panui_mail.txt

# Prevent script from running during holidays.
if ! ./ensure2fields.awk "$IGNORE_DATES_FILE" | ./failondates.awk 2>> "$PANUI_LOG_FILE"; then
	exit 1
fi

# Prevent script from running on the weekend.
if ! ./failonweekend.py 2>> "$PANUI_LOG_FILE"; then
	exit 2
fi

# Download daily panui.
wget --append-output="$PANUI_LOG_FILE" --output-document="$PANUI_RAW_HTML_FILE" "$PANUI_URL"

# Generate notices markup.
./getnoticesinfo.sh < "$PANUI_RAW_HTML_FILE" 2>> "$PANUI_LOG_FILE" | tr -s '\n' | ./mknoticemacros.awk | m4 --prefix-builtins > "$ORPHAN_NOTICES_FILE"

# Generate plaintext version of notices.
html2text -utf8 -o "$RAW_PLAINTEXT_NOTICES_FILE" "$PANUI_RAW_HTML_FILE"
# Lines from $starting_line to $ending_line (exclusive) are to be used in email with little processing.
starting_line=$(grep -Fn "$PANUI_START_STRING" "$RAW_PLAINTEXT_NOTICES_FILE" | cut -f 1 -d ':')
ending_line=$(grep -Fn "$PANUI_END_STRING" "$RAW_PLAINTEXT_NOTICES_FILE" | cut -f 1 -d ':')
ending_line=$((ending_line-1))

# Shell expansion makes calling sed a bit tricky without this.
sed_expr=$(printf "%s,%sp" "$starting_line" "$ending_line")
# Cut out daily panui from page.
sed -n "$sed_expr" "$RAW_PLAINTEXT_NOTICES_FILE" > "$PLAINTEXT_NOTICES_FILE"

# XXX: Just for now.
cp "$PLAINTEXT_NOTICES_FILE" "$PLAINTEXT_MAIL_BODY_FILE"

# Generate and send emails while looping through each record from the mailing list.
while IFS=, read -r name email; do
	# Ignore line if name or email is not present in the mailing list.
	if [ -z "$name" ] && [ -z "$email" ]; then
		# Skip empty line
		continue
	elif [ -z "$name" ]; then
		printf "Name undefined for email: %s\n" "$email" >> "$PANUI_LOG_FILE"
		continue
	elif [ -z "$email" ]; then
		printf "Email undefined for name: %s\n" "$name" >> "$PANUI_LOG_FILE"
		continue
	fi

	# Generate HTML mail body for current recipient.
	./mkpanuimail.sh "$name" < "$ORPHAN_NOTICES_FILE" > "$HTML_MAIL_BODY_FILE"

	# Generate and send email for current recipient.
	./mkmimemail.sh "$email" "$PLAINTEXT_MAIL_BODY_FILE" "$HTML_MAIL_BODY_FILE" | sendmail -t
done < "$MAILING_LIST_FILE"

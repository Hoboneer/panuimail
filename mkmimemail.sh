#!/bin/sh

# "$1" refers to email of recipient.
# "$2" refers to filename of plaintext part of mail.
# "$3" refers to filename of html part of mail.

EMAIL_BOUNDARY_START='--'
BOUNDARY='===stefsuckz123ab3=='

print_boundary () {
	printf "%s%s\n" "$EMAIL_BOUNDARY_START" "$BOUNDARY"
}

# Print main headers.
printf "To: %s\n" "$1"
printf "Subject: %s\n" "$(date +"Rutherford Panui, %d/%m/%y")"
printf "Date: %s\n" "$(date --rfc-email)"
printf "Mime-Version: 1.0\n"
printf "Content-Type: multipart/alternative; boundary=\"%s\"\n" "$BOUNDARY"

# Separate bodies from main headers.
printf "\n"

# Plaintext part of mail.
print_boundary
printf "Content-Type: text/plain; charset=\"us-ascii\"\n"
printf "Mime-Version: 1.0\n"
printf "Content-Transfer-Encoding: 7bit\n"
printf "\n"
# Convert special chars to ASCII.
printf "%s\n" "$(iconv -f UTF8 -t ASCII//TRANSLIT "$2")"

# HTML part of mail.
print_boundary
printf "Content-Type: text/html; charset=\"utf-8\"\n"
printf "Mime-Version: 1.0\n"
printf "Content-Transfer-Encoding: base64\n"
printf "\n"
# It seems that encoding to base64 is a good idea.
printf "%s\n" "$(base64 "$3")"

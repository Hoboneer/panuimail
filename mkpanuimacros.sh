#!/bin/sh

curr_day_num=$(date +"%d")
curr_day_ordinal=$(./num2ordinal.py "$curr_day_num")
# FULL_DAY_NAME ORDINAL_DAY of FULL_MONTH_NAME, FULL_YEAR_NUM; e.g.,
# "Friday 19th of April, 2019"
pretty_date=$(date +"%A $curr_day_ordinal of %B, %Y")

# Print body.
printf "m4_define(\`PANUI_RECIPIENT_NAME', \`%s')\n" "$1"
printf "m4_define(\`PANUI_PRETTY_DATE', \`%s')\n" "$pretty_date"
printf "m4_define(\`PANUI_NOTICES', \`%s')\n" "$(cat -)"
printf "m4_include(\`panui_template.html')\n"


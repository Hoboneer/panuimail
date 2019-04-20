#!/bin/sh

PANUI_LOG_FILE=panui.log

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


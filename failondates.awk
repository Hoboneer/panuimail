#!/usr/bin/awk -f

# This is a script that fails if the current date is within the bounds
# specified in the input. It uses the property of ISO (8601) formatted dates
# which allows them to be compared just by their character values.
#
# The exit values on error start from 3 since (at least for gawk) exit codes
# 1 and 2 are taken, and would thus be ambiguous.

BEGIN { 
	FS = "\t"
	command_str = "date -Idate"
	# Execute `command_str` in a subshell and assign `current_date` to its output.
	command_str | getline current_date
}

# Date within bounds.
$1 <= current_date && current_date <= $2 {
	print "Current date within range"
	exit 3
}

# Mismatched start and end dates.
$1 > $2 {
	print "The end date cannot be later than the start date!"
	exit 4
}	


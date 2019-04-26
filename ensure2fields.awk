#!/usr/bin/awk -f

# Just duplicate the first field.
NF == 1 { print $1, $1 }
NF == 2 { print $1, $2 }

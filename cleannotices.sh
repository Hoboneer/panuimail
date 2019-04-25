#!/bin/sh

# `tr` is called a bunch of times to make this script portable.
# That is, setting `RS="\0"` (NUL) in `awk` is not portable between
# implementations. Therefore, chars must be translated.
#
# Remove trailing null character. This caused an extra notice to appear.
cat - | tr -s '\0' | tr '\n' '\t' | tr '\0' '\n'

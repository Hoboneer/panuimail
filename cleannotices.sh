#!/bin/sh

# `tr` is called a bunch of times to make this script portable.
# That is, setting `RS="\0"` (NUL) in `awk` is not portable between
# implementations. Therefore, chars must be translated.
cat - | expand -t 1 | tr '\n' '\t' | tr '\0' '\n'

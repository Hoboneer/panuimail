#!/bin/sh

# This is a program to print out the data necessary to reconstruct a panui
# notice. This prints out the notice in 4 columns separated by tab chars.
#
# "$1" refers to the XHTML to filter.

# Print title of entry.
echo "$1" | hxselect -ic -s '\t' '.vcex-blog-entry-title > a::attr(title)'
# Print link to entry.
echo "$1" | hxselect -ic -s '\t' '.vcex-blog-entry-title > a::attr(href)'
# Print entry date.
echo "$1" | hxselect -ic -s '\t' '.vcex-blog-entry-date'
# Print entry excerpt. Removes any newlines while preserving word separation.
#
# Excerpts do not require a tab after since it is the last field before
# the newline.
echo "$1" | hxselect -ic '.vcex-blog-entry-excerpt' | tr '\n' ' '

printf "\n"

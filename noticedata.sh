#!/bin/sh

# This is a program to print out the data necessary to reconstruct a panui
# notice.

# "$1" refers to the XHTML to filter.

# Print title of entry.
echo $1 | echo `hxselect -ic '.vcex-blog-entry-title > a::attr(title)'`
# Print link to entry.
echo $1 | echo `hxselect -ic '.vcex-blog-entry-title > a::attr(href)'`
# Print entry date.
echo $1 | echo `hxselect -ic '.vcex-blog-entry-date'`
# Print entry excerpt.
echo $1 | echo `hxselect -ic '.vcex-blog-entry-excerpt'`

# Allow notices to be separated by null chars (used by xargs).
printf "\0"


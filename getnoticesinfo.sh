#!/bin/sh
# Separate each notice by null characters from panui in stdin.
cat - | tidy -q -asxml | hxselect -i -s '\0' '.vcex-blog-entry-details' | xargs -0 -n 1 ./noticedata.sh

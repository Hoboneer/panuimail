#!/bin/sh

# "$1" refers to name of current recipient

cat - | ./mkpanuimacros.sh "$1" | m4 --prefix-builtins


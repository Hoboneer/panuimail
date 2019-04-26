#!/usr/bin/python3

# This is a script to convert a cardinal number to its ordinal value.
#
# It takes its first argument as the input and ignores any further
# arguments.
#
# Fails with status code `1` when input is not a valid number (int).

import sys

DIGIT_TO_ORDINAL = {
    "1": "st",
    "2": "nd",
    "3": "rd",
    "4": "th",
    "5": "th",
    "6": "th",
    "7": "th",
    "8": "th",
    "9": "th",
    "0": "th",
}


def num_to_ordinal(num):
    """Convert an `int` to its ordinal string.

    E.g., "2" becomes "2nd".

    >>> num_to_ordinal(2)
    '2nd'
    >>> num_to_ordinal(11)
    '11th'
    """
    num_str = str(num)
    last_digit = num_str[-1]

    # Handle special cases.
    if num == 11:
        return "11th"
    elif num == 12:
        return "12th"
    elif num == 13:
        return "13th"

    return num_str + DIGIT_TO_ORDINAL[last_digit]


if __name__ == "__main__":
    try:
        num_arg = sys.argv[1]
    except IndexError:
        sys.exit()

    try:
        num = int(num_arg)
    except ValueError:
        print("`{}` is not a valid integer".format(num_arg))
        sys.exit(1)

    print(num_to_ordinal(num))

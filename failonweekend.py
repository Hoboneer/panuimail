#!/usr/bin/python3

import sys
from datetime import date

if __name__ == "__main__":
    today = date.today()
    # Monday is 0.
    if today.weekday() > 4:
        print("Failing because it is a weekend", file=sys.stderr)
        sys.exit(1)
    # Exit code 0.

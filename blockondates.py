#!/usr/bin/python3

import sys
import datetime


def get_date(datestring):
    try:
        date = datetime.datetime.fromisoformat(datestring)
    except ValueError:
        print("Invalid ISO date: {}".format(datestring), file=sys.stderr)
        sys.exit(3)
    return date.date()


if __name__ == "__main__":
    for line in sys.stdin:
        start, end, *_ = line.split()

        start_date = get_date(start)
        end_date = get_date(end)

        if end_date < start_date:
            print(
                "End date must be the same date or after the start date",
                file=sys.stderr,
            )
            sys.exit(2)

        current_date = datetime.datetime.now().date()
        if current_date >= start_date or current_date <= end_date:
            print("Current date within range", file=sys.stderr)
            sys.exit(1)
    # Exit code 0

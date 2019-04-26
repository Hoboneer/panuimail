panuimail
=========

A set of shell scripts using Unix tools to get the daily panui and send it to
a list of people. We don't want to use the website or the app...

To run:

```sh
./sendpanui.sh
```

Prerequisites
--------------

* A configured MTA.
* The packages specified in `dependencies.txt` (some of them are not strictly
  required).

Mailing List Syntax
-------------------

This has a CSV syntax, with columns delimited by single comments (",") (from
left to right):

1. Name
2. Email

It is, by default, named `mailing_list.csv`, which can be changed by setting
the `MAILING_LIST_FILE` constant in `sendpanui.sh`.

Ignore Certain Dates
------------------------

This file specifies individual dates and *ranges* of dates that it does not
run on.  It is a tab-delimited file, with newlines separating records. There
may be 1 or 2 fields per record. There may be an unlimited number of records.

If there are 2 fields, then it will be a date range, with the first field
being the start and second field, the end.

If there is only 1 field, then the script will not run just for that day.

It is, by default, named `holidays.txt`, which can be changed by setting the
`IGNORE_DATES_FILE` constant in `sendpanui.sh`.


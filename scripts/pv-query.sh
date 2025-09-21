#!/bin/bash

SQLITE3_DATABASE_PATH="$1"

if  [ -z "$SQLITE3_DATABASE_PATH" ]; then
  echo "Usage: $0 <path_to_sqlite3_database>"
  exit 1
fi

if [ ! -f "$SQLITE3_DATABASE_PATH" ]; then
  echo "Error: File '$SQLITE3_DATABASE_PATH' does not exist."
  exit 1
fi

sqlite3 $SQLITE3_DATABASE_PATH <<_EOF
.mode table
select * from report_packages
_EOF

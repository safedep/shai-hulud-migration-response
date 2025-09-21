#!/bin/bash

source "$(dirname $0)/common.sh"

SQLITE3_DATABASE_PATH="$1"
if [ -z "$SQLITE3_DATABASE_PATH" ]; then
  SQLITE3_DATABASE_PATH="$PV_SCAN_REPORT_PATH"
fi

if [ -z "$SQLITE3_DATABASE_PATH" ]; then
  echo "Usage: $0 <path_to_sqlite3_database>"
  exit 1
fi

if [ ! -f "$SQLITE3_DATABASE_PATH" ]; then
  echo "Error: File '$SQLITE3_DATABASE_PATH' does not exist."
  exit 1
fi

# Path to the malicious package versions JSONL file
IOC_FILE="$(dirname $0)/../data/ioc/malicious-package-versions.jsonl"

if [ ! -f "$IOC_FILE" ]; then
  echo "Error: IOC file not found at $IOC_FILE"
  exit 1
fi

# Generate WHERE clause conditions from IOC data
mapfile -t CONDITIONS < <(jq -r '"(report_packages.name = '\''" + .name + "'\'' AND report_packages.version = '\''" + .version + "'\'')"' "$IOC_FILE")
IOC_CONDITIONS=""
for i in "${!CONDITIONS[@]}"; do
    if [ $i -eq 0 ]; then
        IOC_CONDITIONS="${CONDITIONS[$i]}"
    else
        IOC_CONDITIONS="$IOC_CONDITIONS OR ${CONDITIONS[$i]}"
    fi
done

if [ -z "$IOC_CONDITIONS" ]; then
  echo "Error: No IOC conditions generated from $IOC_FILE"
  exit 1
fi

# Store query result
QUERY_RESULT=$(sqlite3 $SQLITE3_DATABASE_PATH <<_EOF
.mode table
SELECT report_package_manifests.display_path, report_packages.name, report_packages.version
FROM report_packages
  JOIN report_package_manifest_packages ON report_packages.id = report_package_manifest_packages.report_package_id
  JOIN report_package_manifests ON report_package_manifest_packages.report_package_manifest_id = report_package_manifests.id
WHERE $IOC_CONDITIONS;
_EOF
)

if [ -z "$QUERY_RESULT" ]; then
    echo "No malicious packages found in the database."
else
    echo "$QUERY_RESULT"
fi

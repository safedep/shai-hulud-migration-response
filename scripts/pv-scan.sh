#!/bin/bash

set -eo pipefail

source "$(dirname $0)/common.sh"

vet scan -D / --report-sqlite3=$PV_SCAN_REPORT_PATH \
  --report-sqlite3-overwrite \
  --enrich=false --malware=false --malware-query=false


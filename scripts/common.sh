# Use workspace directory from environment or fallback to /tmp
WORKSPACE_DIR="${WORKSPACE_DIR:-/tmp}"

PV_SCAN_REPORT_PATH="$WORKSPACE_DIR/vet-pv-scan-fullscan.db"
DATA_IOCS_PATH="$(dirname $0)/../data/ioc"
DATA_IOCS_MALICIOUS_PACKAGE_VERSIONS_PATH="$DATA_IOCS_PATH/malicious-package-versions.jsonl"

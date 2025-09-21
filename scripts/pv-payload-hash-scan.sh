#!/bin/bash

source "$(dirname $0)/common.sh"

# Set scan path from first argument or default to entire filesystem
SCAN_PATH="${1:-/}"

# Validate scan path exists
if [[ ! -d "$SCAN_PATH" ]]; then
  echo "Error: Scan path '$SCAN_PATH' does not exist or is not a directory" >&2
  exit 1
fi

# Path to the malicious hashes JSONL file
HASHES_FILE="$(dirname $0)/../data/ioc/malicious-payload-hashes.jsonl"

# Check if the hashes file exists
if [[ ! -f "$HASHES_FILE" ]]; then
  echo "Error: Malicious hashes file not found at $HASHES_FILE" >&2
  exit 1
fi

# Extract hashes from JSONL file into an array
mapfile -t MALICIOUS_HASHES < <(jq -r '.hash' "$HASHES_FILE")

# Check if we have any hashes to scan for
if [[ ${#MALICIOUS_HASHES[@]} -eq 0 ]]; then
  echo "Error: No hashes found in $HASHES_FILE" >&2
  exit 1
fi

echo "Scanning path '$SCAN_PATH' for ${#MALICIOUS_HASHES[@]} known malicious payload hashes..."
echo "This may take a while depending on directory size..."

# Initialize counters
files_scanned=0
malicious_files_found=0

# Find all .js files and compute their SHA256 hashes
find "$SCAN_PATH" -type f -name "*.js" 2>/dev/null | while IFS= read -r file; do
  # Skip if we can't read the file
  if [[ ! -r "$file" ]]; then
    echo "Warning: Cannot read file '$file', skipping..." >&2
    continue
  fi

  # Increment files scanned counter
  ((files_scanned++))

  # Compute SHA256 hash of the file
  file_hash=$(sha256sum "$file" 2>/dev/null | cut -d' ' -f1)

  # Check if this hash matches any of our malicious hashes
  for malicious_hash in "${MALICIOUS_HASHES[@]}"; do
    if [[ "$file_hash" == "$malicious_hash" ]]; then
      echo "MALICIOUS FILE DETECTED: $file (SHA256: $file_hash)"
      ((malicious_files_found++))
    fi
  done

  # Show progress every 100 files
  if ((files_scanned % 100 == 0)); then
    echo "Progress: $files_scanned files scanned..."
  fi
done

echo "Scan of '$SCAN_PATH' complete."
echo "Files scanned: $files_scanned"
echo "Malicious files found: $malicious_files_found"

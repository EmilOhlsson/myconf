#!/bin/bash

# Output file
OUTPUT_FILE="ingest.txt"

# Clear output file if it exists
: > $OUTPUT_FILE

# Get all tracked files from git and process them
git ls-files | sort | while read file; do
  # Skip binary files
  if file "$file" | grep -q "text"; then
    echo -e "\n\n===== FILE: $file =====\n\n" >> $OUTPUT_FILE
    cat "$file" >> $OUTPUT_FILE
  fi
done

echo "All files have been concatenated to $OUTPUT_FILE"

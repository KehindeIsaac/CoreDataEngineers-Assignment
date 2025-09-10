#!/bin/bash

# PURPOSE:
#   This script organizes files by moving all CSV and JSON files 
#   from a "source_files" folder into a "json_and_CSV" folder.
#
#   For example:
#     - "orders.csv" inside "source_files" will be moved to "json_and_CSV"
#     - "data.json" inside "source_files" will also be moved there
#
#   This is useful for keeping related file types together and
#   maintaining a clean project structure.
# ============================================================

# -------------------------------
# Step 1: Define source and destination folders
# -------------------------------
SRC_DIR="source_files"     # Folder where raw files are stored
DEST_DIR="json_and_CSV"    # Folder where CSV/JSON files will be moved to

# -------------------------------
# Step 2: Create folders if they do not exist
# -------------------------------
mkdir -p $SRC_DIR   # Ensure source folder exists (won’t overwrite if already there)
mkdir -p $DEST_DIR  # Ensure destination folder exists

# -------------------------------
# Step 3: Move CSV and JSON files
# -------------------------------
echo ">>> Moving CSV and JSON files from $SRC_DIR to $DEST_DIR ..."

# Move all CSV files (if any exist)
mv $SRC_DIR/*.csv $DEST_DIR/ 2>/dev/null

# Move all JSON files (if any exist)
mv $SRC_DIR/*.json $DEST_DIR/ 2>/dev/null

# -------------------------------
# Step 4: Final confirmation
# -------------------------------
echo "All CSV and JSON files (if found) have been moved into $DEST_DIR"

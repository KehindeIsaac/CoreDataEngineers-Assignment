#!/bin/bash

# ============================================================
# ETL PIPELINE SCRIPT - Annual Enterprise Survey 2023
# This script performs the ETL pipeline in three stages:
#   1. Extract - Download raw survey data
#   2. Transform - Clean and select needed columns
#   3. Load - Save the cleaned file into the Gold layer
#
# Each step includes verification to make sure it was successful.
# ============================================================

# -------------------------------
# Step 1: Define file variables
# -------------------------------
FILE_URL="https://stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/annual-enterprise-survey-2023-financial-year-provisional.csv"
FILE_DIR="$HOME/CDE/Assignment"
FILE_NAME=$(basename "$FILE_URL")
FULL_PATH="$FILE_DIR/$FILE_NAME"

# -------------------------------
# Step 2: Create directory
# -------------------------------
mkdir -p "$FILE_DIR"
echo "Directory ready: $FILE_DIR"

# -------------------------------
# Step 3: Extract (Download file)
# -------------------------------
echo "Downloading $FILE_NAME ..."
wget -q "$FILE_URL" -O "$FULL_PATH"

if [ $? -eq 0 ] && [ -f "$FULL_PATH" ]; then
  echo "Download successful. File saved at $FULL_PATH"
  ls -lh "$FULL_PATH"
else
  echo "Download failed."
  exit 1
fi

# -------------------------------
# Step 4: Rename file
# -------------------------------
NEW_FILE_NAME="annual_enterprise_survey_2023.csv"
NEW_FULL_PATH="$FILE_DIR/$NEW_FILE_NAME"

mv "$FULL_PATH" "$NEW_FULL_PATH"

# Check if renaming worked
if [ -f "$NEW_FULL_PATH" ]; then
  echo "File renamed successfully."
  echo "Old Name: $FILE_NAME"
  echo "New Name: $NEW_FILE_NAME"
  ls -lh "$NEW_FULL_PATH"
else
  echo "File renaming failed."
  exit 1
fi

# Update variables to use new filename
FILE_NAME="$NEW_FILE_NAME"
FULL_PATH="$NEW_FULL_PATH"

# -------------------------------
# Step 5: Display column headers
# -------------------------------
echo "Reading original column headers..."
columns=$(head -n 1 "$FULL_PATH")
echo "Original Columns: $columns"

# -------------------------------
# Step 6: Rename column Variable_code
# -------------------------------
if echo "$columns" | grep -q "Variable_code"; then
  echo "Column 'Variable_code' found. Renaming it..."
  sed -i 's/Variable_code/variable_code/' "$FULL_PATH"

  # Verify that renaming worked
  updated_columns=$(head -n 1 "$FULL_PATH")
  if echo "$updated_columns" | grep -q "variable_code"; then
    echo "Column rename successful."
    echo "Updated Columns: $updated_columns"
  else
    echo "Column rename failed. 'variable_code' not found."
    exit 1
  fi
else
  echo "Column 'Variable_code' not found. No changes made."
fi

# -------------------------------
# Step 7: Extract selected columns
# -------------------------------
TRANS_FILE_NAME="2023_year_finance.csv"
TRANS_FILE_DIR="$FILE_DIR/Transformed"
TRANS_FULL_PATH="$TRANS_FILE_DIR/$TRANS_FILE_NAME"

mkdir -p "$TRANS_FILE_DIR"
echo "Created folder for transformed files: $TRANS_FILE_DIR"

echo "Extracting columns: year, Value, Units, variable_code ..."
awk -F, 'NR==1 {
  for (i=1; i<=NF; i++) {
    if ($i=="year") year_col=i
    if ($i=="Value") value_col=i
    if ($i=="Units") units_col=i
    if ($i=="variable_code") var_col=i
  }
  print "year,value,units,variable_code"
  next
}
{
  print $year_col","$value_col","$units_col","$var_col
}' "$FULL_PATH" > "$TRANS_FULL_PATH"

# Verify transformation
if [ -f "$TRANS_FULL_PATH" ]; then
  echo "Transformation successful. File created at: $TRANS_FULL_PATH"
  echo "Preview of transformed file:"
  head -n 3 "$TRANS_FULL_PATH"
else
  echo "Transformation failed."
  exit 1
fi

# -------------------------------
# Step 8: Load into Gold layer
# -------------------------------
LOAD_FILE_DIR="$FILE_DIR/Gold"
LOAD_FILE_PATH="$LOAD_FILE_DIR/$TRANS_FILE_NAME"

mkdir -p "$LOAD_FILE_DIR"
cp "$TRANS_FULL_PATH" "$LOAD_FILE_PATH"

if [ -f "$LOAD_FILE_PATH" ]; then
  echo "Load successful. File copied to Gold layer at: $LOAD_FILE_PATH"
  ls -lh "$LOAD_FILE_PATH"
else
  echo "Load failed. File not found in Gold layer."
  exit 1
fi

echo "ETL process completed successfully."

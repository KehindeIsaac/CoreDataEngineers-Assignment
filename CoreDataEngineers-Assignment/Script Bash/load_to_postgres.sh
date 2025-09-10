#!/bin/bash

# PURPOSE:
#   This script will loop through all CSV files in the current folder
#   and load them into PostgreSQL tables using the \COPY command.

# Step 1: Database connection details
DB="posey"             # Database name
USER="postgres"        # Database user

# Step 2: Check if CSV files exist
shopt -s nullglob
csv_files=(*.csv)

if [ ${#csv_files[@]} -eq 0 ]; then
  echo "No CSV files found in the current directory."
  exit 1
fi

# Step 3: Loop through CSV files
for file in "${csv_files[@]}"; do
  # Get table name (strip .csv extension)
  table=$(basename "$file" .csv)

  echo "Preparing to load file: $file"
  echo "Target table in PostgreSQL: $table"

  # Run the COPY command
  psql -U "$USER" -d "$DB" -c "\COPY $table FROM '$file' CSV HEADER;"

  # Verify success/failure
  if [ $? -eq 0 ]; then
    echo "File $file was successfully loaded into table: $table"

    # Count rows after load
    row_count=$(psql -U "$USER" -d "$DB" -t -c "SELECT COUNT(*) FROM $table;")
    echo "Table $table now contains $row_count rows."
  else
    echo "Failed to load $file into table: $table"
  fi
done

# Step 4: Final message
echo "All CSV files processed. Please log into the database $DB to verify the data."

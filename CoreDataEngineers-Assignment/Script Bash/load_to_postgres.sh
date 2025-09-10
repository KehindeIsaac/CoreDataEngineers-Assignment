#!/bin/bash

# PURPOSE:
#   This script will loop through all CSV files in the current folder
#   and load them into PostgreSQL tables using the \COPY command.
#
#   For example:
#     - A file called "orders.csv" will be loaded into a table called "orders"
#     - A file called "accounts.csv" will be loaded into a table called "accounts"
#
#   Make sure:
#     1. PostgreSQL is installed and running
#     2. The target database exists (here we use "posey")
#     3. The tables already exist in the database with the same names as the CSV files
# Step 1: Database connection details
# -------------------------------
DB="posey"             # The name of the database where CSVs will be loaded
USER="postgres"        # Database username
PASSWORD="yourpassword" # Replace this with your real PostgreSQL password

# Export password so psql won't ask for it interactively
export PGPASSWORD=$PASSWORD

# -------------------------------
# Step 2: Loop through all CSV files
# -------------------------------
for file in *.csv; do
  # Extract the base name of the file (e.g., "orders.csv" -> "orders")
  table=$(basename "$file" .csv)

  echo "-----------------------------------------"
  echo "Preparing to load file: $file"
  echo "Target table in Postgres: $table"

  # Run the COPY command to insert CSV data into the table
  psql -U $USER -d $DB -c "\COPY $table FROM '$file' CSV HEADER;"

  # Check if the last command was successful
  if [ $? -eq 0 ]; then
    echo "Successfully loaded $file into table: $table"
  else
    echo "Failed to load $file into table: $table"
  fi
  echo "-----------------------------------------"
done

# -------------------------------
# Step 3: Final message
# -------------------------------
echo "All CSV files processed. Please check your database '$DB' to confirm the data was inserted."


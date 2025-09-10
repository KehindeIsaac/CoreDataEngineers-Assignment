Data Engineering Assignment – ETL Pipeline with PostgreSQL and Cron Jobs
Introduction

This assignment demonstrates how I designed and implemented a simple ETL (Extract, Transform, Load) pipeline using Bash scripts, PostgreSQL, and cron jobs. The goal of the project is to automate the process of moving raw data files into a structured folder, loading them into a PostgreSQL database, and scheduling the pipeline to run automatically every day.

Working on this task helped me understand how data pipelines are set up in practice, how files can be organized, how data gets loaded into databases, and how automation with cron ensures processes run without manual effort.

Project Structure

The project is organized into the following folders:

Data-Engineering-Assignment/
│
├── Scripts/
│   ├── Bash/
│   │   ├── move_json_csv.sh        # Script to move CSV and JSON files into one folder
│   │   └── etl_pipeline.sh         # Script to load CSV files into PostgreSQL
│   │
│   └── SQL/
│       └── (place SQL queries here if needed)
│
├── Data/
│   └── (raw CSV/JSON files used for testing)
│
├── README.md                       # Project documentation

Part 1: Organizing Files with Bash

The first step in any data engineering task is to organize raw files.
I created a Bash script called move_json_csv.sh which collects all .csv and .json files from a source_files folder and moves them into a single folder called json_and_CSV.

Script: move_json_csv.sh

Defines the source and destination folders.

Creates both folders if they do not already exist.

Moves all CSV and JSON files found in the source folder into the destination folder.

Prints a confirmation message when done.

This helps to keep related files together and ensures a clean project structure before loading into the database.

Part 2: Loading Data into PostgreSQL

The next step was to load the cleaned CSV files into PostgreSQL tables. I wrote another Bash script called etl_pipeline.sh.

Script: etl_pipeline.sh

Connects to a PostgreSQL database.

Reads all CSV files in the current folder.

Creates a table name based on the filename.

Loads each CSV file into its corresponding table using the \COPY command.

Prints a message for each file that is successfully loaded.

I also exported the PostgreSQL password inside the script so that it runs smoothly without prompting for a password every time.

Part 3: Automating the Pipeline with Cron Jobs

After creating the ETL pipeline, the final task was to automate it.
I used cron jobs to schedule the pipeline so that it runs every day at 12:00 AM.

Steps followed:

Opened the cron configuration with:

crontab -e


Added the following line to schedule the script:

0 0 * * * /path/to/project/Scripts/Bash/etl_pipeline.sh >> /path/to/project/logs/etl.log 2>&1


0 0 * * * means run at 12:00 AM every day.

The script output is saved into a log file for monitoring.

Saved and exited the crontab editor.

Verified that the job was successfully added using:

crontab -l


This showed the scheduled task.

Now the pipeline runs automatically every night without requiring manual execution.

How to Run This Project

Clone the repository to your computer.

git clone <repository_link>
cd Data-Engineering-Assignment


Place your raw CSV or JSON files into the source_files folder.

Run the file organization script:

bash Scripts/Bash/move_json_csv.sh


Run the ETL pipeline script to load the data into PostgreSQL:

bash Scripts/Bash/etl_pipeline.sh


(Optional) Set up the cron job if you want automation.

Key Learnings

How to structure a simple data pipeline project.

Writing Bash scripts to organize and process files.

Loading data into PostgreSQL tables from CSV files.

Scheduling automated jobs using cron.

This project helped me see how different tools work together in a typical data engineering workflow.

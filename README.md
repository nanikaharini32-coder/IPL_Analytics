# IPL Data Analytics — Tableau & SQL

## Project Overview

This project analyzes Indian Premier League (IPL) match data using Tableau for visualization and MySQL for data-quality checks and cleaning.

The project explores team performance, player achievements, match venues, toss decisions, and season-wise trends.

## Tools Used

- **Tableau:** Dashboard creation and data visualization
- **MySQL:** SQL data cleaning and data-quality validation
- **CSV:** Source dataset format
- **GitHub:** Project documentation and version control

## Dataset

The dataset contains IPL match-level information, including:

- Match ID and season
- Match date and city
- Venue
- Competing teams
- Toss winner and toss decision
- Match winner and result
- Result margin
- Player of the Match
- Target runs and overs

## Tableau Dashboards

### 1. Team Performance

This dashboard explores:
- Team performance across seasons
- Total matches won by teams
- Players with the most Player of the Match awards
- Matches played by team

### 2. Venue Analysis

This dashboard explores:
- Total matches, seasons, and runs
- Match distribution across venues
- Toss decisions
- The relationship between winning the toss and winning the match
- Season-wise run trends

Dashboard screenshots are included in the project for quick viewing.

## SQL Data Cleaning

The SQL script is located in `sql/ipl_matches_data_cleaning.sql`.

The workflow includes:

1. Checking the total number of records.
2. Identifying duplicate match IDs.
3. Checking missing values in important columns.
4. Inspecting distinct category values.
5. Trimming unnecessary leading and trailing spaces.
6. Converting empty text values to SQL NULL in the cleaned view.
7. Standardizing recognized toss-decision and super-over labels.
8. Flagging potential numeric anomalies for investigation.
9. Comparing raw and cleaned-view row counts.

The SQL script creates a separate cleaned view and preserves the raw table. It does not automatically delete duplicate records or invent missing values.


## How to Run the SQL Script

1. Install MySQL and open MySQL Workbench.
2. Import the source CSV into a table named `ipl_matches_raw`.
3. Open `sql/ipl_matches_data_cleaning.sql`.
4. Execute the script.
5. Review the data-quality checks and inspect the `ipl_matches_cleaned` view.

The script assumes that the imported table contains the columns referenced in the SQL queries.

## Key Learning Outcomes

- Practiced SQL data-quality checks and text cleaning.
- Learned to identify duplicates and missing values.
- Created a cleaned SQL view while preserving raw data.
- Developed Tableau dashboards to explore IPL match statistics.
- Practiced documenting an analytics project for GitHub.

## Conclusion

This project demonstrates a data analytics workflow combining SQL-based data-quality checks with Tableau dashboards. The original dataset and existing dashboards are preserved while the SQL cleaning workflow is documented separately.
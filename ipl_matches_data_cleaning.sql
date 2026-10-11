-- IPL Matches Dataset: SQL Data Quality Checks and Cleaning View
-- Purpose: Demonstrate SQL cleaning for GitHub without changing the source CSV
-- Database: MySQL 8.0+
-- IMPORTANT: This script creates a cleaned VIEW from a separately imported raw table.
-- It does not overwrite the CSV or modify your existing Power BI dashboard.

-- STEP 1: Import your original matches CSV into MySQL Workbench as a table named `ipl_matches_raw`.
-- Keep the source columns named as follows:
-- id, season, city, date, match_type, player_of_match, venue, team1, team2,
-- toss_winner, toss_decision, winner, result, result_margin, target_runs,
-- target_overs, super_over, method, umpire1, umpire2

-- STEP 2: Inspect row count and duplicate match IDs.
SELECT COUNT(*) AS total_rows
FROM ipl_matches_raw;

SELECT id, COUNT(*) AS id_count
FROM ipl_matches_raw
GROUP BY id
HAVING COUNT(*) > 1;

-- STEP 3: Check missing values in important columns.
SELECT
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS missing_id,
    SUM(CASE WHEN season IS NULL OR TRIM(season) = '' THEN 1 ELSE 0 END) AS missing_season,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS missing_date,
    SUM(CASE WHEN venue IS NULL OR TRIM(venue) = '' THEN 1 ELSE 0 END) AS missing_venue,
    SUM(CASE WHEN team1 IS NULL OR TRIM(team1) = '' THEN 1 ELSE 0 END) AS missing_team1,
    SUM(CASE WHEN team2 IS NULL OR TRIM(team2) = '' THEN 1 ELSE 0 END) AS missing_team2,
    SUM(CASE WHEN winner IS NULL OR TRIM(winner) = '' THEN 1 ELSE 0 END) AS missing_winner
FROM ipl_matches_raw;

-- STEP 4: Inspect distinct values before standardizing categories.
SELECT DISTINCT toss_decision
FROM ipl_matches_raw
ORDER BY toss_decision;

SELECT DISTINCT result
FROM ipl_matches_raw
ORDER BY result;

SELECT DISTINCT super_over
FROM ipl_matches_raw
ORDER BY super_over;

-- STEP 5: Create a cleaned view.
-- TRIM cleans whitespace. NULLIF turns empty strings into NULL.
-- Missing values are preserved as NULL; no match rows are deleted.
-- Original column names are retained for easier comparison with the source.
CREATE OR REPLACE VIEW ipl_matches_cleaned AS
SELECT
    id,
    NULLIF(TRIM(CAST(season AS CHAR)), '') AS season,
    NULLIF(TRIM(city), '') AS city,
    date,
    NULLIF(TRIM(match_type), '') AS match_type,
    NULLIF(TRIM(player_of_match), '') AS player_of_match,
    NULLIF(TRIM(venue), '') AS venue,
    NULLIF(TRIM(team1), '') AS team1,
    NULLIF(TRIM(team2), '') AS team2,
    NULLIF(TRIM(toss_winner), '') AS toss_winner,
    CASE
        WHEN LOWER(TRIM(toss_decision)) IN ('bat', 'field')
            THEN LOWER(TRIM(toss_decision))
        ELSE NULLIF(TRIM(toss_decision), '')
    END AS toss_decision,
    NULLIF(TRIM(winner), '') AS winner,
    NULLIF(TRIM(result), '') AS result,
    result_margin,
    target_runs,
    target_overs,
    CASE
        WHEN UPPER(TRIM(super_over)) IN ('Y', 'N')
            THEN UPPER(TRIM(super_over))
        ELSE NULLIF(TRIM(super_over), '')
    END AS super_over,
    NULLIF(TRIM(method), '') AS method,
    NULLIF(TRIM(umpire1), '') AS umpire1,
    NULLIF(TRIM(umpire2), '') AS umpire2
FROM ipl_matches_raw;

-- STEP 6: Verify that the view retains the same number of rows.
SELECT
    (SELECT COUNT(*) FROM ipl_matches_raw) AS raw_rows,
    (SELECT COUNT(*) FROM ipl_matches_cleaned) AS cleaned_view_rows;

-- STEP 7: Recheck duplicate IDs in the cleaned view.
SELECT id, COUNT(*) AS id_count
FROM ipl_matches_cleaned
GROUP BY id
HAVING COUNT(*) > 1;

-- STEP 8: Review rows with missing winner/player-of-match values.
-- Do not delete these rows automatically; some matches may have no winner.
SELECT id, season, date, result, winner, player_of_match
FROM ipl_matches_cleaned
WHERE winner IS NULL OR player_of_match IS NULL
ORDER BY date;

-- STEP 9: Review possible numeric anomalies for investigation.
-- These queries flag records; they do not change or delete them.
SELECT id, season, date, result_margin, target_runs, target_overs
FROM ipl_matches_cleaned
WHERE result_margin < 0
   OR target_runs <= 0
   OR target_overs <= 0;

-- STEP 10: Preview the cleaned data.
SELECT *
FROM ipl_matches_cleaned
ORDER BY date, id
LIMIT 20;

-- To use the cleaned view in a separate Power BI test, connect to this view.
-- Keep your existing dashboard connected to its current source unless you
-- deliberately test and validate a source change.

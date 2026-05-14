# Quiz Score Importer Fix

## Task Overview

Your edtech platform operations team runs a nightly job that imports student quiz scores from a CSV export (`scores.csv`) into the PostgreSQL `quiz_results` table. The script `main.py` was written by a previous engineer and partially works — it can connect to the database and process clean rows — but it has two critical bugs that make it unreliable in production. First, whenever the CSV contains a row with a blank or non-numeric score (which happens regularly due to students abandoning quizzes mid-way), the script crashes entirely and leaves the database in a partially updated state. Second, re-running the import — a common need when scores are revised — creates duplicate rows for the same student and quiz rather than updating the existing record. Your job is to fix both bugs so the script becomes robust and safe to re-run.

The PostgreSQL database is fully deployed and pre-populated with students, quizzes, and an initial set of quiz results. The Python environment is also ready with all dependencies installed. The script `main.py` runs without syntax errors but exhibits the two bugs described above. You only need to modify `main.py` to fix the broken behavior.

## Objectives

- **Objective 1 — Graceful handling of invalid rows:** The script must not crash when it encounters a row in `scores.csv` where the `score` column is empty or contains a non-numeric value. Such rows must be counted and skipped silently.
- **Objective 2 — Idempotent upsert logic:** For each valid row, the script must check whether a record already exists in `quiz_results` for the same `student_id` and `quiz_id`. If it exists, the script must update the score and `submitted_at` timestamp. If it does not exist, the script must insert a new record.
- **Objective 3 — Parameterized queries:** All SQL statements that use values from the CSV must use parameterized queries (no string formatting or concatenation of user data into SQL).
- **Objective 4 — Summary output:** After processing all rows, the script must print a single summary line: `Imported: X, Skipped: Y` showing how many rows were written to the database and how many were skipped.

## Database Access

The PostgreSQL database is running locally via Docker and is accessible with the following credentials:

- **Host:** `<DROPLET_IP>`
- **Port:** `5432`
- **Database:** `edtech_db`
- **Username:** `edtech_user`
- **Password:** `edtech_pass`

You may use any database client you prefer — pgAdmin, DBeaver, psql, or DataGrip — to inspect the schema and verify data. The same credentials are already configured in `main.py`.

## How to Verify

1. **Run the script with the provided CSV (which contains intentionally bad rows):**
   ```
   python main.py
   ```
   The script must complete without raising an exception and must print a summary like `Imported: 8, Skipped: 2`.

2. **Verify no duplicates exist after multiple runs:** Run the script a second time. Query the database directly:
   ```sql
   SELECT student_id, quiz_id, COUNT(*) FROM quiz_results GROUP BY student_id, quiz_id HAVING COUNT(*) > 1;
   ```
   This query must return zero rows — confirming no duplicates were created on re-run.

3. **Verify updated scores:** Pick a `(student_id, quiz_id)` pair that exists both in `scores.csv` and already in `quiz_results` before running the script. After running, confirm the score in the database matches the value from the CSV, not the original seeded value.

4. **Verify skipped rows:** Confirm that the `Skipped` count in the printed summary matches the number of rows in `scores.csv` with blank or non-numeric score values.

## Helpful Tips

- Consider what Python built-in mechanisms are available for handling exceptions that arise during type conversion (e.g., converting a string to a number).
- Think about the order of operations: what database check needs to happen before you decide whether to insert or update a row?
- Consider how psycopg2 parameterized queries differ from building SQL strings with f-strings or `%` formatting — and why the former is the correct approach.
- Review the structure of `quiz_results` carefully — specifically which columns together form the natural unique identifier for a score record.
- Think about how you can use a single counter variable to track skipped rows across the loop without resetting it accidentally.
- Explore what `cursor.fetchone()` returns when a `SELECT` finds no matching row — and how that return value can drive your insert-or-update decision.

import csv
import psycopg2
from datetime import datetime

DB_CONFIG = {
    "host":     "localhost",
    "port":     5432,
    "dbname":   "edtech_db",
    "user":     "edtech_user",
    "password": "edtech_pass",
}

CSV_PATH = "scores.csv"


def get_connection():
    return psycopg2.connect(**DB_CONFIG)


def load_scores(csv_path, conn):
    imported = 0
    skipped  = 0

    with open(csv_path, newline="") as f:
        reader = csv.DictReader(f)
        cursor = conn.cursor()

        for row in reader:
            student_id   = int(row["student_id"])
            quiz_id      = int(row["quiz_id"])
            score        = float(row["score"])
            submitted_at = row["submitted_at"]

            cursor.execute(
                "INSERT INTO quiz_results (student_id, quiz_id, score, submitted_at) "
                "VALUES (%s, %s, %s, %s)",
                (student_id, quiz_id, score, submitted_at),
            )
            imported += 1

        conn.commit()
        cursor.close()

    print(f"Imported: {imported}, Skipped: {skipped}")


def main():
    conn = get_connection()
    load_scores(CSV_PATH, conn)
    conn.close()


if __name__ == "__main__":
    main()

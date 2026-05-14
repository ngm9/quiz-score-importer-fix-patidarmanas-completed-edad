-- ============================================================
-- Schema
-- ============================================================

CREATE TABLE IF NOT EXISTS students (
    student_id   SERIAL PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(150) NOT NULL UNIQUE,
    enrolled_at  DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS quizzes (
    quiz_id      SERIAL PRIMARY KEY,
    title        VARCHAR(200) NOT NULL,
    subject      VARCHAR(100) NOT NULL,
    max_score    INTEGER NOT NULL DEFAULT 100
);

CREATE TABLE IF NOT EXISTS quiz_results (
    result_id    SERIAL PRIMARY KEY,
    student_id   INTEGER NOT NULL REFERENCES students(student_id),
    quiz_id      INTEGER NOT NULL REFERENCES quizzes(quiz_id),
    score        NUMERIC(5,2) NOT NULL,
    submitted_at TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_quiz_results_student_quiz
    ON quiz_results (student_id, quiz_id);

-- ============================================================
-- Students (20 rows)
-- ============================================================

INSERT INTO students (full_name, email, enrolled_at) VALUES
    ('Aarav Mehta',      'aarav.mehta@mailtest.io',      '2023-01-10'),
    ('Priya Nair',       'priya.nair@mailtest.io',       '2023-01-12'),
    ('Rohan Sharma',     'rohan.sharma@mailtest.io',     '2023-02-01'),
    ('Sneha Kapoor',     'sneha.kapoor@mailtest.io',     '2023-02-14'),
    ('Vikram Bose',      'vikram.bose@mailtest.io',      '2023-03-05'),
    ('Ananya Pillai',    'ananya.pillai@mailtest.io',    '2023-03-18'),
    ('Karan Joshi',      'karan.joshi@mailtest.io',      '2023-04-02'),
    ('Divya Reddy',      'divya.reddy@mailtest.io',      '2023-04-20'),
    ('Arjun Singh',      'arjun.singh@mailtest.io',      '2023-05-07'),
    ('Meera Iyer',       'meera.iyer@mailtest.io',       '2023-05-15'),
    ('Ravi Verma',       'ravi.verma@mailtest.io',       '2023-06-01'),
    ('Pooja Desai',      'pooja.desai@mailtest.io',      '2023-06-10'),
    ('Amit Choudhary',   'amit.choudhary@mailtest.io',   '2023-07-03'),
    ('Nisha Tiwari',     'nisha.tiwari@mailtest.io',     '2023-07-22'),
    ('Siddharth Roy',    'siddharth.roy@mailtest.io',    '2023-08-08'),
    ('Kavya Menon',      'kavya.menon@mailtest.io',      '2023-08-19'),
    ('Tarun Gupta',      'tarun.gupta@mailtest.io',      '2023-09-01'),
    ('Swati Agarwal',    'swati.agarwal@mailtest.io',    '2023-09-14'),
    ('Nikhil Patil',     'nikhil.patil@mailtest.io',     '2023-10-05'),
    ('Ritika Saxena',    'ritika.saxena@mailtest.io',    '2023-10-20');

-- ============================================================
-- Quizzes (5 rows)
-- ============================================================

INSERT INTO quizzes (title, subject, max_score) VALUES
    ('Python Basics',          'Python',     100),
    ('SQL Fundamentals',       'SQL',        100),
    ('Data Structures 101',    'CS Theory',  80),
    ('Web Concepts',           'Web',        60),
    ('Mathematics for CS',     'Math',       100);

-- ============================================================
-- Quiz Results — pre-existing scores for 6 students
-- (These are the rows that the CSV import will update or
--  add new ones alongside.)
-- ============================================================

INSERT INTO quiz_results (student_id, quiz_id, score, submitted_at) VALUES
    (1,  1, 55.00, '2024-01-15 09:00:00'),
    (2,  1, 70.00, '2024-01-15 09:30:00'),
    (3,  2, 60.00, '2024-01-16 10:00:00'),
    (4,  2, 45.00, '2024-01-16 10:45:00'),
    (5,  3, 50.00, '2024-01-17 11:00:00'),
    (6,  3, 65.00, '2024-01-17 11:30:00');

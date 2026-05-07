-- ============================================================
--  College Attendance System – Multi-Class + Login Schema
-- ============================================================

PRAGMA foreign_keys = ON;

-- ------------------------------------------------------------
-- teachers (login accounts)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS teachers (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    name         TEXT    NOT NULL,
    username     TEXT    NOT NULL UNIQUE,
    password     TEXT    NOT NULL,   -- stored as sha256 hex
    created_at   TEXT    DEFAULT (date('now'))
);

-- ------------------------------------------------------------
-- teacher_email_settings
--   Each teacher's saved SMTP email + app password
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS teacher_email_settings (
    teacher_id   INTEGER PRIMARY KEY REFERENCES teachers(id) ON DELETE CASCADE,
    email        TEXT    NOT NULL,
    app_password TEXT    NOT NULL
);

-- ------------------------------------------------------------
-- classes
--   Each teacher can have multiple classes
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS classes (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    teacher_id INTEGER NOT NULL REFERENCES teachers(id) ON DELETE CASCADE,
    name       TEXT    NOT NULL,
    section    TEXT,
    subject    TEXT,
    created_at TEXT    DEFAULT (date('now'))
);

-- ------------------------------------------------------------
-- students
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS students (
    id       INTEGER PRIMARY KEY AUTOINCREMENT,
    class_id INTEGER NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    name     TEXT    NOT NULL,
    email    TEXT    NOT NULL,
    gender   TEXT    DEFAULT 'Male',   -- Male / Female
    quota    TEXT    DEFAULT 'PGCET',   -- PGCET / Management
    stream   TEXT    DEFAULT 'CS',     -- CS / AI
    UNIQUE (class_id, email)
);

-- ------------------------------------------------------------
-- holidays  (per teacher, or global if teacher_id IS NULL)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS holidays (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    teacher_id   INTEGER REFERENCES teachers(id) ON DELETE CASCADE,
    holiday_date TEXT    NOT NULL,
    reason       TEXT,
    UNIQUE (teacher_id, holiday_date)
);

-- ------------------------------------------------------------
-- attendance
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS attendance (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    date       TEXT    NOT NULL,
    status     REAL    NOT NULL DEFAULT 1,
    UNIQUE (student_id, date)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_attendance_student ON attendance(student_id);
CREATE INDEX IF NOT EXISTS idx_attendance_date    ON attendance(date);
CREATE INDEX IF NOT EXISTS idx_students_class     ON students(class_id);
CREATE INDEX IF NOT EXISTS idx_classes_teacher    ON classes(teacher_id);

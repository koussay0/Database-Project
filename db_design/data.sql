-- Insert University Table Data 

USE university;

-- BUILDINGS
INSERT INTO buildings (name) VALUES
    ('Watson'), --ID 1
    ('Taylor'), --ID 2
    ('Painter'), --ID 3
    ('Packard'); --ID 4

-- DEPARTMENTS
INSERT INTO departments (name, budget, building_id) VALUES
    ('Biology', 90000.00, 1), --ID 1
    ('Comp Sci.', 100000.00, 2),
    ('Elec. Eng.', 85000.00, 2),
    ('Finance', 120000.00, 3),
    ('History', 50000.00, 3),
    ('Music', 80000.00, 4),
    ('Physics', 70000.00, 1); -- ID 7

-- CLASSROOMS
INSERT INTO classrooms (building_id, room_number, capacity) VALUES
    (4, '101', 500),
    (3, '514', 10),
    (2, '3128', 70),
    (1, '100', 30),
    (1, '120', 50);

-- TIMESLOTS
INSERT INTO timeslots (day, start_time, end_time) VALUES
    ('M', '08:00:00', '09:15:00')
    ;

-- COURSES
INSERT INTO courses (dept_id, course_number, title, credits) VALUES
    (1, 'MATH-101', 'Calculus I', 4),
    (1, 'MATH-201', 'Calculus II', 4)
    ;

-- PREREQUISITES
INSERT INTO prerequisites (course_id, prereq_id) VALUES
    (2, 1)  -- Calculus II requires Calculus I
    ; 

-- INSTRUCTORS
INSERT INTO instructors (first_name, last_name, email, salary, dept_id) VALUES
    ('Bob',   'Smith',   'b.smith@university.edu',   75000.00, 1)
    ;

-- STUDENTS
INSERT INTO students (first_name, last_name, email, dept_id) VALUES
    ('Ella',   'Jones',    'ella.jones@university.edu', 1)
    ;

-- ADVISORS
INSERT INTO advisors (student_id, instructor_id) VALUES
    (1, 1)  -- Ella  → Bob Smith
    ;

-- ACCOUNTS
INSERT INTO accounts (username, password_hash, role) VALUES
    ('admin',       'hashedadminpassword1', 'admin'),
    ('b.smith',    'hashedinstructorpassword1', 'instructor'),
    ('ella.jones',     'hashedstudentpassword1', 'student')
    ;

-- STUDENT ACCOUNTS (account_id matches INSERT order above)
INSERT INTO student_accounts (account_id, student_id) VALUES
    (3, 1)  -- ella.jones  → Ella Jones
    ;

-- INSTRUCTOR ACCOUNTS
INSERT INTO instructor_accounts (account_id, instructor_id) VALUES
    (2, 1)  -- b.smith → Bob Smith
    ;

-- SECTIONS
INSERT INTO sections (course_id, classroom_id, timeslot_id, semester, year, capacity) VALUES
    (1, 1, 1, 'Fall',   2024, 30)  -- MATH101
    ;

-- TEACHES 
INSERT INTO teaches (section_id, instructor_id) VALUES
    (1, 1)  -- MATH101 Fall 2024  → Bob Smith
    ;

-- ENROLLMENTS
INSERT INTO enrollments (student_id, section_id, grade, status) VALUES
    (1, 1, 'A', 'current')  -- Ella  in MATH101
    ;

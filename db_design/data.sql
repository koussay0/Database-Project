-- Insert University Table Data 

USE university;

-- BUILDINGS
INSERT INTO buildings (name) VALUES
    ('Watson'), -- ID 1
    ('Taylor'), -- ID 2
    ('Painter'), -- ID 3
    ('Packard'); -- ID 4

-- DEPARTMENTS
INSERT INTO departments (name, budget, building_id) VALUES
    ('Biology', 90000.00, 1), -- ID 1
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
    ('F', '08:00:00', '08:50:00'),
    ('M', '08:00:00', '08:50:00'),
    ('W', '08:00:00', '08:50:00'),
    ('F', '09:00:00', '09:50:00'),
    ('M', '09:00:00', '09:50:00'),
    ('W', '09:00:00', '09:50:00'),
    ('F', '11:00:00', '11:50:00'),
    ('M', '11:00:00', '11:50:00'),
    ('W', '11:00:00', '11:50:00'),
    ('F', '13:00:00', '13:50:00'),
    ('M', '13:00:00', '13:50:00'),
    ('W', '13:00:00', '13:50:00'),
    ('R', '10:30:00', '11:45:00'),
    ('T', '10:30:00', '11:45:00'),
    ('R', '14:30:00', '15:45:00'),
    ('T', '14:30:00', '15:45:00'),
    ('F', '16:00:00', '16:50:00'),
    ('M', '16:00:00', '16:50:00'),
    ('W', '16:00:00', '16:50:00'),
    ('W', '10:00:00', '12:30:00');

-- COURSES
INSERT INTO courses (dept_id, course_number, title, credits) VALUES
    (1, 'BIO-101', 'Intro. to Biology', 4),
    (1, 'BIO-301', 'Genetics', 4),
    (1, 'BIO-399', 'Computational Biology', 3),
    (2, 'CS-101', 'Intro. to Computer Science', 4),
    (2, 'CS-190', 'Game Design', 4),
    (2, 'CS-315', 'Robotics', 3),
    (2, 'CS-319', 'Image Processing', 3),
    (2, 'CS-347', 'Database System Concepts', 3),
    (3, 'EE-181', 'Intro. to Digital Systems', 3),
    (4, 'FIN-201', 'Investment Banking', 3),
    (5, 'HIS-351', 'World History', 3),
    (6, 'MU-199', 'Music Video Production', 3),
    (7, 'PHY-101', 'Physical Principles', 4);

-- PREREQUISITES
INSERT INTO prerequisites (course_id, prereq_id) VALUES
    (2, 1),
    (3, 1),
    (5, 4),
    (6, 4),
    (7, 4),
    (8, 4),
    (9, 13); 

-- INSTRUCTORS
INSERT INTO instructors (first_name, last_name, email, salary, dept_id) VALUES
    ('Jack',   'Srinivasan',   'j.srinivasan@university.edu',   65000.00, 2), -- ID 1
    ('Annabelle',   'Katz',   'a.katz@university.edu',   75000.00, 2),
    ('Steven',   'Brandt',   's.brandt@university.edu',   92000.00, 2),
    ('Wendy',   'Wu',   'w.wu@university.edu',   90000.00, 4),
    ('Phoebe',   'Singh',   'p.singh@university.edu',   80000.00, 4),
    ('Wolfgang',   'Mozart',   'w.mozart@university.edu',   40000.00, 6),
    ('Albert',   'Einstein',   'a.einstein@university.edu',   95000.00, 7),
    ('William',   'Gold',   'w.gold@university.edu',   40000.00, 7),
    ('Michael',   'El Said',   'm.el-said@university.edu',   60000.00, 5),
    ('Zackary',   'Califieri',   'z.califieri@university.edu',   62000.00, 5),
    ('Hannah',   'Crick',   'h.crick@university.edu',   72000.00, 1),
    ('Yimiko',   'Kim',   'y.kim@university.edu',   62000.00, 3); -- ID 12

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

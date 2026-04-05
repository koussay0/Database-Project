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
    ('W', '08:00:00', '08:50:00'), -- ID A (1-3)
    ('F', '09:00:00', '09:50:00'),
    ('M', '09:00:00', '09:50:00'),
    ('W', '09:00:00', '09:50:00'), -- ID B (4-6)
    ('F', '11:00:00', '11:50:00'),
    ('M', '11:00:00', '11:50:00'),
    ('W', '11:00:00', '11:50:00'), -- ID C (7-9)
    ('F', '13:00:00', '13:50:00'),
    ('M', '13:00:00', '13:50:00'),
    ('W', '13:00:00', '13:50:00'), -- ID D (10-12)
    ('R', '10:30:00', '11:45:00'),
    ('T', '10:30:00', '11:45:00'), -- ID E (13-14)
    ('R', '14:30:00', '15:45:00'),
    ('T', '14:30:00', '15:45:00'), -- ID F (15-16)
    ('F', '16:00:00', '16:50:00'),
    ('M', '16:00:00', '16:50:00'),
    ('W', '16:00:00', '16:50:00'), -- ID G (17-19)
    ('W', '10:00:00', '12:30:00'); -- ID H (20)

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
    ('Wendy',   'Wu',   'w.wu@university.edu',   90000.00, 4),
    ('Wolfgang',   'Mozart',   'w.mozart@university.edu',   40000.00, 6),
    ('Albert',   'Einstein',   'a.einstein@university.edu',   95000.00, 7),
    ('Michael',   'El Said',   'm.el-said@university.edu',   60000.00, 5),
    ('William',   'Gold',   'w.gold@university.edu',   40000.00, 7),
    ('Annabelle',   'Katz',   'a.katz@university.edu',   75000.00, 2),
    ('Zackary',   'Califieri',   'z.califieri@university.edu',   62000.00, 5),
    ('Phoebe',   'Singh',   'p.singh@university.edu',   80000.00, 4),
    ('Hannah',   'Crick',   'h.crick@university.edu',   72000.00, 1),
    ('Steven',   'Brandt',   's.brandt@university.edu',   92000.00, 2),
    ('Yimiko',   'Kim',   'y.kim@university.edu',   62000.00, 3); -- ID 12

-- STUDENTS
INSERT INTO students (first_name, last_name, email, dept_id) VALUES
    ('Peter',   'Zhang',    'peter.zhang@university.edu', 2), -- ID 1
    ('Kammi',   'Shankar',    'kammi.shankar@university.edu', 2),
    ('Elias',   'Brandt',    'elias.brandt@university.edu', 5),
    ('Randy',   'Chavez',    'randy.chavez@university.edu', 4),
    ('Claire',   'Peltier',    'claire.peltier@university.edu', 7),
    ('Oliver',   'Levy',    'oliver.levy@university.edu', 7),
    ('Amanda',   'Williams',    'amanda.williams@university.edu', 2),
    ('Franco',   'Sanchez',    'franco.sanchez@university.edu', 6),
    ('Zara',   'Snow',    'zara.snow@university.edu', 7),
    ('Jaxon',   'Brown',    'jaxon.brown@university.edu', 2),
    ('Mika',   'Aoi',    'mika.aoi@university.edu', 3),
    ('Victor',   'Bourikas',    'victor.bourikas@university.edu', 3),
    ('Gio',   'Tanaka',    'gio.tanaka@university.edu', 1); -- ID 13 

-- ADVISORS
INSERT INTO advisors (student_id, instructor_id) VALUES
    (2, 1),  -- Kammi  → Jack
    (5, 4),
    (6, 4),
    (1, 7),
    (10, 7),
    (4, 9),
    (13, 10),
    (11, 12),
    (12, 12);

-- ACCOUNTS
INSERT INTO accounts (username, password_hash, role) VALUES
    ('admin',       'hashedadminpassword1', 'admin'),
    ('j.srinivasan',    'hashedinstructorpassword1', 'instructor'),
    ('w.wu',    'hashedinstructorpassword2', 'instructor'),
    ('w.mozart',    'hashedinstructorpassword3', 'instructor'),
    ('a.einstein',    'hashedinstructorpassword4', 'instructor'),
    ('m.el-said',    'hashedinstructorpassword5', 'instructor'),
    ('w.gold',    'hashedinstructorpassword6', 'instructor'),
    ('a.katz',    'hashedinstructorpassword7', 'instructor'),
    ('z.califieri',    'hashedinstructorpassword8', 'instructor'),
    ('p.singh',    'hashedinstructorpassword9', 'instructor'),
    ('h.crick',    'hashedinstructorpassword10', 'instructor'),
    ('s.brandt',    'hashedinstructorpassword11', 'instructor'),
    ('y.kim',    'hashedinstructorpassword12', 'instructor'),
    ('peter.zhang',     'hashedstudentpassword1', 'student'),
    ('kammi.shankar',     'hashedstudentpassword2', 'student'),
    ('elias.brandt',     'hashedstudentpassword3', 'student'),
    ('randy.chavez',     'hashedstudentpassword4', 'student'),
    ('claire.peltier',     'hashedstudentpassword5', 'student'),
    ('oliver.levy',     'hashedstudentpassword6', 'student'),
    ('amanda.williams',     'hashedstudentpassword7', 'student'),
    ('franco.sanchez',     'hashedstudentpassword8', 'student'),
    ('zara.snow',     'hashedstudentpassword9', 'student'),
    ('jaxon.brown',     'hashedstudentpassword10', 'student'),
    ('mika.aoi',     'hashedstudentpassword11', 'student'),
    ('victor.bourikas',     'hashedstudentpassword12', 'student'),
    ('gio.tanaka',     'hashedstudentpassword13', 'student');

-- STUDENT ACCOUNTS (account_id matches INSERT order above)
INSERT INTO student_accounts (account_id, student_id) VALUES
    (14, 1),  -- peter.zhang  → Peter Zhang
    (15, 2),
    (16, 3),
    (17, 4),
    (18, 5),
    (19, 6),
    (20, 7),
    (21, 8),
    (22, 9),
    (23, 10),
    (24, 11),
    (25, 12),
    (26, 13);

-- INSTRUCTOR ACCOUNTS
INSERT INTO instructor_accounts (account_id, instructor_id) VALUES
    (2, 1),  -- j.srinivasan → Jack Srinivasan
    (3, 2),
    (4, 3),
    (5, 4),
    (6, 5),
    (7, 6),
    (8, 7),
    (9, 8),
    (10, 9),
    (11, 10),
    (12, 11),
    (13, 12);

-- SECTIONS
INSERT INTO sections (course_id, classroom_id, timeslot_id, semester, year, capacity) VALUES
    (1, 2, 4, 'Summer',   2017, 10),  -- BIO101: sec 1
    (2, 2, 1, 'Summer',   2018, 10), -- BIO301
    (4, 1, 20, 'Fall',   2017, 500), -- CS101
    (4, 1, 15, 'Spring',   2018, 500), -- CS101 Section 2
    (5, 3, 13, 'Spring',   2017, 70), -- CS190
    (5, 3, 2, 'Spring',   2017, 70), -- CS190 Section 2
    (6, 4, 10, 'Spring',   2018, 30), -- CS315
    (7, 5, 5, 'Spring',   2018, 50), -- CS319
    (7, 3, 9, 'Spring',   2018, 70), -- CS319 Section 2
    (8, 3, 3, 'Fall',   2017, 70), -- CS347
    (9, 3, 7, 'Spring',   2017, 70), -- EE181
    (10, 1, 4, 'Spring',   2018, 500), -- FIN201
    (11, 2, 8, 'Spring',   2018, 10), -- HIS351
    (12, 1, 11, 'Spring',   2018, 500), -- MUS199
    (13, 4, 1, 'Fall',   2017, 30); -- CS319: sec 2

-- TEACHES 
INSERT INTO teaches (section_id, instructor_id) VALUES
    (1, 1)  -- MATH101 Fall 2024  → Bob Smith
    ;

-- ENROLLMENTS
INSERT INTO enrollments (student_id, section_id, grade, status) VALUES
    (1, 1, 'A', 'current')  -- Ella  in MATH101
    ;

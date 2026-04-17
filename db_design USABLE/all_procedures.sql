USE university;
DELIMITER //

############# ADMIN STORED PROCEDURES #############


-- CRUD Course

CREATE PROCEDURE create_course (
    IN dept_id_n INT,
    IN course_number_n VARCHAR(10),
    IN title_n VARCHAR(100),
    IN credits_n INT
)
BEGIN
    INSERT INTO courses (dept_id, course_number, title, credits)
    VALUES (dept_id_n, course_number_n, title_n, credits_n);
END //

CREATE PROCEDURE read_courses()
BEGIN
    SELECT
        courses.course_id,
        courses.course_number,
        courses.title,
        courses.credits,
        departments.name AS department
    FROM courses
    LEFT JOIN departments ON courses.dept_id = departments.dept_id;
END //

CREATE PROCEDURE update_course(
    IN course_id_n INT,
    IN dept_id_n INT,
    IN course_number_n VARCHAR(10),
    IN title_n VARCHAR(100),
    IN credits_n INT
)
BEGIN
    UPDATE courses
    SET course_number = course_number_n, title = title_n, credits = credits_n, dept_id = dept_id_n
    WHERE course_id = course_id_n;
END //

CREATE PROCEDURE delete_course (
    IN course_id_n INT
)
BEGIN
    DELETE FROM courses WHERE course_id = course_id_n;
END //

-- CRUD Section

CREATE PROCEDURE create_section(
    IN course_id_n INT,
    IN classroom_id_n INT,
    IN timeslot_id_n INT,
    IN semester_n ENUM('Fall', 'Spring', 'Summer'),
    IN year_n INT,
    IN capacity_n INT
)
BEGIN
    INSERT INTO sections (course_id, classroom_id, timeslot_id, semester, year, capacity)
    VALUES (course_id_n, classroom_id_n, timeslot_id_n, semester_n, year_n, capacity_n);
END //

CREATE PROCEDURE read_sections()
BEGIN
    SELECT 
        sections.section_id, 
        courses.title,
        courses.course_number,
        buildings.name,
        classrooms.room_number,
        timeslots.day,
        timeslots.start_time,
        timeslots.end_time,
        sections.semester, 
        sections.year,
        sections.capacity
    FROM sections
    JOIN courses ON sections.course_id = courses.course_id
    LEFT JOIN classrooms ON sections.classroom_id = classrooms.classroom_id
    LEFT JOIN buildings ON classrooms.building_id = buildings.building_id
    LEFT JOIN timeslots ON sections.timeslot_id = timeslots.timeslot_id;
END //

CREATE PROCEDURE update_section(
    IN section_id_n INT,
    IN course_id_n INT,
    IN classroom_id_n INT,
    IN timeslot_id_n INT,
    IN semester_n ENUM('Fall', 'Spring', 'Summer'),
    IN year_n INT,
    IN capacity_n INT
)
BEGIN
    UPDATE sections
    SET course_id = course_id_n, classroom_id = classroom_id_n, timeslot_id = timeslot_id_n, semester = semester_n, year = year_n, capacity = capacity_n
    WHERE section_id = section_id_n;
END //

CREATE PROCEDURE delete_section(
    IN section_id_n INT
)
BEGIN
    DELETE FROM sections WHERE section_id = section_id_n;
END //


-- CRUD Classroom

CREATE PROCEDURE create_classroom (
    building_id_n INT,
    room_number_n VARCHAR(10),
    capacity_n INT
)
BEGIN
    INSERT INTO classrooms (building_id, room_number, capacity)
    VALUES (building_id_n, room_number_n, capacity_n);
END //

CREATE PROCEDURE read_classroom()
BEGIN
    SELECT
        classrooms.classroom_id,
        buildings.name,
        classrooms.room_number,
        classrooms.capacity
    FROM classrooms
    JOIN buildings ON classrooms.building_id = buildings.building_id;
END //

CREATE PROCEDURE update_classroom(
    classroom_id_n INT,
    building_id_n INT,
    room_number_n VARCHAR(10),
    capacity_n INT
)
BEGIN
    UPDATE classrooms
    SET building_id = building_id_n, room_number = room_number_n, capacity = capacity_n
    WHERE classroom_id = classroom_id_n;
END //

CREATE PROCEDURE delete_classroom (
    IN classroom_id_n INT
)
BEGIN
    DELETE FROM classrooms WHERE classroom_id = classroom_id_n;
END //


-- CRUD Department

CREATE PROCEDURE create_department (
    name_n VARCHAR(100),
    budget_n DECIMAL(10, 2),
    building_id_n INT
)
BEGIN
    INSERT INTO departments (name, budget, building_id)
    VALUES (name_n, budget_n, building_id_n);
END //

CREATE PROCEDURE read_department()
BEGIN
    SELECT
        departments.dept_id,
        departments.name,
        departments.budget,
        buildings.name
    FROM departments
    JOIN buildings ON departments.building_id = buildings.building_id;
END //

CREATE PROCEDURE update_department(
    dept_id_n INT,
    name_n VARCHAR(100),
    budget_n DECIMAL(10, 2),
    building_id_n INT
)
BEGIN
    UPDATE departments
    SET name = name_n, budget = budget_n, building_id = building_id_n
    WHERE dept_id = dept_id_n;
END //

CREATE PROCEDURE delete_department (
    IN dept_id_n INT
)
BEGIN
    DELETE FROM departments WHERE dept_id = dept_id_n;
END //

-- CRUD Timeslot
CREATE PROCEDURE create_timeslot(
    IN day_n ENUM('M', 'T', 'W', 'R', 'F'),
    IN start_time_n TIME,
    IN end_time_n TIME
)
BEGIN
    INSERT INTO timeslots (day, start_time, end_time)
    VALUES (day_n, start_time_n, end_time_n);
END //

CREATE PROCEDURE read_timeslot()
BEGIN
    SELECT
        timeslots.timeslot_id,
        timeslots.day,
        timeslots.start_time,
        timeslots.end_time
    FROM timeslots;
END //

CREATE PROCEDURE update_timeslot(
    timeslot_id_n INT,
    day_n ENUM('M', 'T', 'W', 'R', 'F'),
    start_time_n TIME,
    end_time_n TIME 
)
BEGIN
    UPDATE timeslots
    SET day = day_n, start_time = start_time_n, end_time = end_time_n
    WHERE timeslot_id = timeslot_id_n;
END //

CREATE PROCEDURE delete_timeslot (
    IN timeslot_id_n INT
)
BEGIN
    DELETE FROM timeslots WHERE timeslot_id = timeslot_id_n;
END //

-- CRUD Instructor

CREATE PROCEDURE create_instructor (
    IN first_name_n VARCHAR(50),
    IN last_name_n VARCHAR(50),
    IN email_n VARCHAR(100),
    IN salary_n DECIMAL(10,2),
    IN dept_id_n INT
)
BEGIN 
    INSERT INTO instructors(first_name, last_name, email, salary, dept_id)
    values (first_name_n, last_name_n, email_n, salary_n, dept_id_n);
END //

CREATE PROCEDURE read_instructors()
BEGIN   
    SELECT
        instructors.instructor_id,
        instructors.first_name,
        instructors.last_name,
        instructors.email,
        instructors.salary,
        departments.name
    FROM instructors
    LEFT JOIN departments ON instructors.dept_id = departments.dept_id;
END //

CREATE PROCEDURE update_instructor(
    IN instructor_id_n INT,
    IN first_name_n VARCHAR(50),
    IN last_name_n VARCHAR(50),
    IN email_n VARCHAR(100),
    IN salary_n DECIMAL(10,2),
    IN dept_id_n INT
)
BEGIN   
    UPDATE instructors
    SET first_name = first_name_n, last_name = last_name_n, email = email_n, salary = salary_n, dept_id = dept_id_n
    WHERE instructor_id = instructor_id_n;
END // 

CREATE PROCEDURE delete_instructor (
    IN instructor_id_n INT
)
BEGIN 
    DELETE FROM instructors WHERE instructor_id = instructor_id_n;
END //

-- CRUD Student

CREATE PROCEDURE create_student (
    IN first_name_n VARCHAR(50),
    IN last_name_n VARCHAR(50),
    IN email_n VARCHAR(100),
    IN dept_id_n INT
)
BEGIN
    INSERT INTO students(first_name, last_name, email, dept_id)
    VALUES (first_name_n, last_name_n, email_n, dept_id_n);
END //

CREATE PROCEDURE read_students()
BEGIN
    SELECT
        students.student_id,
        students.first_name,
        students.last_name,
        students.email,
        departments.name 
    FROM students
    LEFT JOIN departments ON students.dept_id = departments.dept_id;
END //

CREATE PROCEDURE update_student(
    IN student_id_n INT,
    IN first_name_n VARCHAR(50),
    IN last_name_n VARCHAR(50),
    IN email_n VARCHAR(100),
    IN dept_id_n INT
)
BEGIN
    UPDATE students
    SET first_name = first_name_n, last_name = last_name_n, email = email_n, dept_id = dept_id_n
    WHERE student_id = student_id_n;
END //

CREATE PROCEDURE delete_student (
    IN student_id_n INT
)
BEGIN
    DELETE FROM students WHERE student_id = student_id_n;
END //

-- Assign/modify/remove teachers to classes

-- Assign
CREATE PROCEDURE assign_instructor_to_section(
    IN instructor_id_n INT,
    IN section_id_n INT
)
BEGIN
    INSERT INTO teaches (instructor_id, section_id)
    VALUES (instructor_id_n, section_id_n);
END //

-- Modify
CREATE PROCEDURE modify_instructor_assignment(
    IN instructor_id_n INT,
    IN old_section_id_n INT,  
    IN new_section_id_n INT
)
BEGIN
    UPDATE teaches
    SET section_id = new_section_id_n
    WHERE instructor_id = instructor_id_n AND section_id = old_section_id_n;
END //

-- Remove
CREATE PROCEDURE remove_instructor_from_section(
    IN instructor_id_n INT,
    IN section_id_n INT
)
BEGIN
    DELETE FROM teaches
    WHERE instructor_id = instructor_id_n AND section_id = section_id_n;
END //

-- Modify personal information (username)

CREATE PROCEDURE modify_admin_info(
    IN account_id_n INT,
    IN username_n VARCHAR(50)
)
BEGIN
    UPDATE accounts
    SET username = username_n
    WHERE account_id = account_id_n;
END //


############# INSTRUCTOR STORED PROCEDURES #############

-- Submit/change grades

CREATE PROCEDURE change_grade(
    IN section_id_n INT,
    IN student_id_n INT,
    IN new_grade_n ENUM('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F', 'W')
)
BEGIN
    UPDATE enrollments
    SET grade = new_grade_n, status = IF(new_grade_n = 'F', 'failed', 'passed')
    WHERE section_id = section_id_n AND student_id = student_id_n;
END //

-- Add students as advisees

CREATE PROCEDURE add_advisee(
    IN student_id_n INT,
    IN instructor_id_n INT
)
BEGIN
    INSERT INTO advisors (student_id, instructor_id)
    VALUES (student_id_n, instructor_id_n);
END //

-- Remove students as advisees

CREATE PROCEDURE remove_advisee(
    IN student_id_n INT,
    IN instructor_id_n INT
)
BEGIN
    DELETE FROM advisors
    WHERE student_id = student_id_n 
      AND instructor_id = instructor_id_n;
END //

-- View Advisees

CREATE PROCEDURE view_advisees(
    IN advisor_id_n INT
)
BEGIN
    SELECT DISTINCT students.student_id, students.first_name, students.last_name, departments.name
    FROM students
    JOIN advisors ON students.student_id = advisors.student_id
    JOIN departments ON students.dept_id = departments.dept_id
    WHERE advisors.instructor_id = advisor_id_n;
END //

-- Modify course prerequisites

CREATE PROCEDURE add_course_prerequisite(
    IN course_id_n INT,
    IN prereq_id_n INT
)
BEGIN
    INSERT INTO prerequisites (course_id, prereq_id)
    VALUES (course_id_n, prereq_id_n);
END //

CREATE PROCEDURE remove_course_prerequisite(
    IN course_id_n INT,
    IN prereq_id_n INT
)
BEGIN
    DELETE FROM prerequisites 
    WHERE course_id = course_id_n AND prereq_id = prereq_id_n;
END //

-- Remove student from section

CREATE PROCEDURE remove_student_from_section(
    IN student_id_n INT,
    IN section_id_n INT
)
BEGIN
    DELETE FROM enrollments
    WHERE student_id = student_id_n AND section_id = section_id_n;
END //

-- Check section roster

CREATE PROCEDURE check_section_roster(
    IN section_id_n INT
)
BEGIN
    SELECT students.student_id,students.first_name, students.last_name, enrollments.grade
    FROM students
    JOIN enrollments ON students.student_id = enrollments.student_id
    WHERE enrollments.section_id = section_id_n;
END //

-- Check sections teaching based on semester
CREATE PROCEDURE check_sections_teaching(
    IN instructor_id_n INT,
    IN semester_n VARCHAR(10), 
    IN year_n INT
)
BEGIN
    SELECT 
        courses.title, 
        courses.course_number, 
        timeslots.day, 
        timeslots.start_time, 
        timeslots.end_time, 
        sections.semester, 
        sections.year, 
        sections.capacity,
        sections.section_id
    FROM sections
    JOIN courses ON sections.course_id = courses.course_id
    JOIN timeslots ON sections.timeslot_id = timeslots.timeslot_id
    JOIN teaches ON sections.section_id = teaches.section_id
    WHERE teaches.instructor_id = instructor_id_n
      AND (semester_n = 'all' OR sections.semester = semester_n)
      AND (year_n IS NULL OR sections.year = year_n);
END //

-- Modify personal information (username, first name, last name, email)

CREATE PROCEDURE modify_instructor_info(
    IN account_id_n INT,
    IN username_n VARCHAR(50),
    IN first_name_n VARCHAR(50),
    IN last_name_n VARCHAR(50),
    IN email_n VARCHAR(100)
)
BEGIN
    UPDATE accounts 
    SET username = username_n
    WHERE account_id = account_id_n;

    UPDATE instructors
    JOIN instructor_accounts ON instructors.instructor_id = instructor_accounts.instructor_id
    SET instructors.first_name = first_name_n,
        instructors.last_name = last_name_n,
        instructors.email = email_n
    WHERE instructor_accounts.account_id = account_id_n;

END //

-- Give average grade of all students based on department

CREATE PROCEDURE average_grade_by_department(
    IN department_id_n INT
)
BEGIN
    SELECT departments.name,
        ROUND(AVG(
            CASE 
                WHEN enrollments.grade = 'A'  THEN 95
                WHEN enrollments.grade = 'A-' THEN 91
                WHEN enrollments.grade = 'B+' THEN 88
                WHEN enrollments.grade = 'B'  THEN 85
                WHEN enrollments.grade = 'B-' THEN 81
                WHEN enrollments.grade = 'C+' THEN 78
                WHEN enrollments.grade = 'C'  THEN 75
                WHEN enrollments.grade = 'C-' THEN 71
                WHEN enrollments.grade = 'D+' THEN 68
                WHEN enrollments.grade = 'D'  THEN 65
                WHEN enrollments.grade = 'D-' THEN 61
                WHEN enrollments.grade = 'F'  THEN 0
            END
        ), 2) AS average_grade
    FROM departments
    JOIN courses ON departments.dept_id = courses.dept_id
    JOIN sections ON courses.course_id = sections.course_id
    JOIN enrollments ON sections.section_id = enrollments.section_id
    WHERE departments.dept_id = department_id_n
      AND enrollments.grade IS NOT NULL 
      AND enrollments.grade != 'W'
    GROUP BY departments.dept_id, departments.name;
END //

-- Give average grade of course based on semester range

CREATE PROCEDURE avg_course_grade(
    IN course_id_n INT, 
    IN start_semester VARCHAR(10),
    IN start_year INT,
    IN end_semester VARCHAR(10), 
    IN end_year INT
    )
BEGIN
    SELECT courses.title, 
    ROUND(AVG(
                CASE 
                    WHEN enrollments.grade = 'A'  THEN 95
                    WHEN enrollments.grade = 'A-' THEN 91
                    WHEN enrollments.grade = 'B+' THEN 88
                    WHEN enrollments.grade = 'B'  THEN 85
                    WHEN enrollments.grade = 'B-' THEN 81
                    WHEN enrollments.grade = 'C+' THEN 78
                    WHEN enrollments.grade = 'C'  THEN 75
                    WHEN enrollments.grade = 'C-' THEN 71
                    WHEN enrollments.grade = 'D+' THEN 68
                    WHEN enrollments.grade = 'D'  THEN 65
                    WHEN enrollments.grade = 'D-' THEN 61
                    WHEN enrollments.grade = 'F'  THEN 0
                END
            ), 2) AS average_grade
    FROM enrollments 
    JOIN sections ON enrollments.section_id = sections.section_id
    JOIN courses ON sections.course_id = courses.course_id
    WHERE courses.course_id = course_id_n AND sections.year BETWEEN start_year AND end_year AND (
    (sections.year > start_year OR (sections.year = start_year AND sections.semester >= start_semester))
    AND 
    (sections.year < end_year OR (sections.year = end_year AND sections.semester <= end_semester))
)
    GROUP BY courses.course_id;
END //

-- Show best performing class (based on grades) for a selected semester 
CREATE PROCEDURE get_best_class(
    IN sem_n VARCHAR(10), 
    IN year_n INT
    )
BEGIN
    SELECT courses.title, 
    ROUND(AVG(
                CASE 
                    WHEN enrollments.grade = 'A'  THEN 95
                    WHEN enrollments.grade = 'A-' THEN 91
                    WHEN enrollments.grade = 'B+' THEN 88
                    WHEN enrollments.grade = 'B'  THEN 85
                    WHEN enrollments.grade = 'B-' THEN 81
                    WHEN enrollments.grade = 'C+' THEN 78
                    WHEN enrollments.grade = 'C'  THEN 75
                    WHEN enrollments.grade = 'C-' THEN 71
                    WHEN enrollments.grade = 'D+' THEN 68
                    WHEN enrollments.grade = 'D'  THEN 65
                    WHEN enrollments.grade = 'D-' THEN 61
                    WHEN enrollments.grade = 'F'  THEN 0
                END
            ), 2) AS average_grade
    FROM enrollments 
    JOIN sections ON enrollments.section_id = sections.section_id
    JOIN courses ON sections.course_id = courses.course_id
    WHERE sections.semester = sem_n AND sections.year = year_n
    GROUP BY sections.section_id, courses.title
    ORDER BY average_grade DESC;
END //

-- Show worst performing class (based on grades) for a selected semester 
CREATE PROCEDURE get_worst_class(
    IN sem_n VARCHAR(10), 
    IN year_n INT
    )
BEGIN
    SELECT courses.title, 
    ROUND(AVG(
                CASE 
                    WHEN enrollments.grade = 'A'  THEN 95
                    WHEN enrollments.grade = 'A-' THEN 91
                    WHEN enrollments.grade = 'B+' THEN 88
                    WHEN enrollments.grade = 'B'  THEN 85
                    WHEN enrollments.grade = 'B-' THEN 81
                    WHEN enrollments.grade = 'C+' THEN 78
                    WHEN enrollments.grade = 'C'  THEN 75
                    WHEN enrollments.grade = 'C-' THEN 71
                    WHEN enrollments.grade = 'D+' THEN 68
                    WHEN enrollments.grade = 'D'  THEN 65
                    WHEN enrollments.grade = 'D-' THEN 61
                    WHEN enrollments.grade = 'F'  THEN 0
                END
            ), 2) AS average_grade
    FROM enrollments 
    JOIN sections ON enrollments.section_id = sections.section_id
    JOIN courses ON sections.course_id = courses.course_id
    WHERE sections.semester = sem_n AND sections.year = year_n
    GROUP BY sections.section_id, courses.title
    ORDER BY average_grade ASC;
END //

-- Show total number of students (past and current) according to department
CREATE PROCEDURE total_students_dept(
    IN dept_id_n INT
    )
BEGIN
    SELECT departments.name, COUNT(DISTINCT students.student_id)
    FROM departments
    JOIN students ON departments.dept_id = students.dept_id
    WHERE departments.dept_id = dept_id_n;
END //

-- Show total number of students currently enrolled according to department
CREATE PROCEDURE current_students_dept(
    IN dept_id_n INT
    )
BEGIN
    SELECT departments.name, COUNT(DISTINCT enrollments.student_id)
    FROM departments 
    JOIN courses ON departments.dept_id = courses.dept_id
    JOIN sections ON courses.course_id = sections.course_id
    JOIN enrollments ON sections.section_id = enrollments.section_id
    WHERE departments.dept_id = dept_id_n AND enrollments.status = 'in progress';
END //


############# STUDENT STORED PROCEDURES #############

-- Add class

CREATE PROCEDURE enroll_student_in_section(
    IN student_id_n INT,
    IN section_id_n INT
)
BEGIN
    INSERT INTO enrollments (student_id, section_id, grade, status)
    VALUES (student_id_n, section_id_n, NULL, 'in progress');
END //

-- Drop class

CREATE PROCEDURE drop_class(
    IN student_id_n INT,
    IN section_id_n INT
)
BEGIN
    UPDATE enrollments
    SET status = 'dropped', grade = 'W'
    WHERE student_id = student_id_n AND section_id = section_id_n;
END //

-- Check courses based on semester, including status + Check final grade for section + Check for section information

CREATE PROCEDURE get_student_courses(
    IN student_id_n INT,
    IN semester_n VARCHAR(10),
    IN year_n INT
)
BEGIN
    SELECT 
        sections.section_id, 
        courses.course_number, 
        courses.title, 
        enrollments.status, 
        enrollments.grade, 
        sections.semester,
        sections.year,
        courses.credits,
        buildings.name,
        classrooms.room_number,
        timeslots.day,
        timeslots.start_time,
        timeslots.end_time
    FROM enrollments 
    JOIN sections ON enrollments.section_id = sections.section_id
    JOIN courses ON sections.course_id = courses.course_id
    LEFT JOIN classrooms on sections.classroom_id = classrooms.classroom_id
    LEFT JOIN buildings ON classrooms.building_id = buildings.building_id
    LEFT JOIN timeslots ON sections.timeslot_id = timeslots.timeslot_id
    WHERE enrollments.student_id = student_id_n 
      AND (semester_n = 'all' OR sections.semester = semester_n)
      AND (year_n IS NULL OR sections.year = year_n);
END //

-- Check for advisor information --> hardcoded into student.py 'personal' route

-- Modify personal information (username, first name, last name, email)
CREATE PROCEDURE modify_student_info(
    IN account_id_n INT,
    IN username_n VARCHAR(50),
    IN first_name_n VARCHAR(50),
    IN last_name_n VARCHAR(50),
    IN email_n VARCHAR(100)
)
BEGIN
    UPDATE accounts 
    SET username = username_n
    WHERE account_id = account_id_n;

    UPDATE students
    JOIN student_accounts ON students.student_id = student_accounts.student_id
    SET students.first_name = first_name_n,
        students.last_name = last_name_n,
        students.email = email_n
    WHERE student_accounts.account_id = account_id_n;

END //

DELIMITER ;

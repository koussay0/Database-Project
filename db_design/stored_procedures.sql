-- Stored Procedures for CRUD and Major Transactions

USE university;

DELIMITER //

-- INSTRUCTOR CRUD

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

-- STUDENT CRUD

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

-- SECTION CRUD

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
        sections.course_id,
        sections.classroom_id,
        sections.timeslot_id,
        sections.semester, 
        sections.year,
        sections.capacity
    FROM sections;
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

# MAJOR TRANSACTIONS

# enroll student in section
CREATE PROCEDURE enroll_student_in_section(
    IN student_id_n INT,
    IN section_id_n INT
)
BEGIN
    INSERT INTO enrollments (student_id, section_id, grade, status)
    VALUES (student_id_n, section_id_n, NULL, 'in progress');
END //


# assign instructor to section
CREATE PROCEDURE assign_instructor_to_section(
    IN instructor_id_n INT,
    IN section_id_n INT
)
BEGIN
    INSERT INTO teaching (instructor_id, section_id)
    VALUES (instructor_id_n, section_id_n);
END //

# drop student from section
CREATE PROCEDURE drop_student_from_section(
    IN student_id_n INT,
    IN section_id_n INT
)
BEGIN
    UPDATE enrollments
    SET status = 'dropped', grade = 'W'
    WHERE student_id = student_id_n AND section_id = section_id_n;
END //

# give grade to section
CREATE PROCEDURE give_grade(
    IN section_id_n INT,
    IN student_id_n INT,
    IN grade_n ENUM('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F', 'W')
)
BEGIN
    UPDATE enrollments
    SET grade = grade_n, status = IF(grade_n = 'F', 'failed', 'passed')
    WHERE section_id = section_id_n AND student_id = student_id_n;
END //

DELIMITER ;

# STUDENT STORED PROCEDURES

USE university;
DELIMITER //

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

-- Check courses based on semester, including status + Check final grade for section

CREATE PROCEDURE get_student_courses(
    IN student_id_n INT,
    IN semester_n VARCHAR(10),
    IN year_n INT
)
BEGIN
    SELECT 
        courses.course_number, 
        courses.title, 
        sections.section_id, 
        sections.semester,
        sections.year,
        enrollments.status, 
        enrollments.grade, 
        courses.credits
    FROM enrollments 
    JOIN sections ON enrollments.section_id = sections.section_id
    JOIN courses ON sections.course_id = courses.course_id
    WHERE enrollments.student_id = student_id_n 
    AND sections.semester = semester_n 
    AND sections.year = year_n;
    ORDER BY 
        sections.year DESC, 
        CASE sections.semester
            WHEN 'Summer' THEN 1
            WHEN 'Spring' THEN 2
            WHEN 'Fall' THEN 3
        END ASC;
END //

-- Check for section information

CREATE PROCEDURE get_section_info(
    IN section_id_n INT
)
BEGIN
    SELECT 
        courses.title, 
        courses.course_number, 
        sections.semester, 
        sections.year, 
        buildings.name, 
        classrooms.room_number, 
        timeslots.day, 
        timeslots.start_time, 
        timeslots.end_time
    FROM sections
    JOIN courses ON sections.course_id = courses.course_id
    LEFT JOIN classrooms ON sections.classroom_id = classrooms.classroom_id
    LEFT JOIN buildings ON classrooms.building_id = buildings.building_id
    LEFT JOIN timeslots ON sections.timeslot_id = timeslots.timeslot_id
    WHERE sections.section_id = section_id_n;
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

# INSTRUCTOR STORED PROCEDURES

USE university;
DELIMITER //

-- Submit grades

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

-- Change grades

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

-- Add students as advisor

CREATE PROCEDURE add_advisee(
    IN student_id_n INT,
    IN advisor_id_n INT
)
BEGIN
    INSERT INTO advisors (student_id, advisor_id)
    VALUES (student_id_n, advisor_id_n);
END //

-- Remove students as advisor

CREATE PROCEDURE remove_advisee(
    IN student_id_n INT,
    IN advisor_id_n INT
)
BEGIN
    DELETE FROM advisors
    WHERE student_id = student_id_n AND advisor_id = advisor_id_n;
END //

-- Modify course prerequisites

CREATE PROCEDURE modify_prerequisites(
    IN course_id_n INT,
    IN prerequisites_n VARCHAR(255)
)
BEGIN
    UPDATE courses
    SET prerequisites = prerequisites_n
    WHERE id = course_id_n;
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
    SELECT students.first_name, students.last_name, enrollments.grade
    FROM students
    JOIN enrollments ON students.student_id = enrollments.student_id
    WHERE enrollments.section_id = section_id_n;
END //

-- Check sections teaching based on semester

CREATE PROCEDURE check_sections_teaching(
    IN instructor_id_n INT,
    IN semester_n ENUM('Fall', 'Spring', 'Summer'),
    IN year_n INT
)
BEGIN
    SELECT courses.title, courses.course_number, timeslots.day, timeslots.start_time, timeslots.end_time, sections.semester, sections.year, sections.capacity
    FROM sections
    JOIN courses ON sections.course_id = courses.id
    JOIN timeslots ON sections.timeslot_id = timeslots.id
    WHERE teaches.instructor_id = instructor_id_n
      AND sections.semester = semester_n
      AND sections.year = year_n;
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

-- Give average grade of course based on semester range

-- Show best performing class (based on grades) for a selected semester

-- Show worst performing class (based on grades) for a selected semester

-- Show total number of students (past and current) according to department

-- Show total number of students currently enrolled according to department


DELIMITER ;

-- Register Class
DELIMITER //
CREATE PROCEDURE registerClass (
    IN s_ID INT,
    IN s_section INT
)
BEGIN
    INSERT INTO enrollments (student_id, course_id, grade, status)
    VALUES (s_ID, s_section, NULL, 'in progress');
END //

-- Drop Class
CREATE PROCEDURE drop_class (
    IN s_ID INT,
    IN s_section INT
)
BEGIN
    -- to show that a course is dropped it won't disappear normally from transcript so values need to be changed
    UPDATE enrollments
    SET status = 'dropped',
        grade = 'W'
    where student.student_id = s_ID and section.section_id = s_section;
END //

-- Show Final Grades
CREATE PROCEDURE show_final_grades (
    IN s_ID INT
)
BEGIN
    select * from enrollments
    where student.student_id = s_ID and enrollment.status != 'in progress';
END //

-- Check courses based on semester including status
CREATE PROCEDURE check_section_info(
    IN s_ID INT,
    IN s_semester VARCHAR(10)
)
BEGIN
    select * courses, enrollments.status
    from courses
    JOIN sections ON sections.course_id = courses.course_id
    JOIN enrollment ON enrollment.section_id = sections.section_id
    where s_ID = enrollments.student_id and s_semester = sections.semester;
END //

-- Section info
CREATE PROCEDURE check_section_info(
    IN sec_ID INT
)
BEGIN
    SELECT DISTINCT * sections
    from sections
    where sec_ID = sections.section_id;
END //

-- Advisor info
CREATE PROCEDURE check_advisor(
    IN a_ID INT
)
BEGIN
    SELECT DISTINCT instructors.instructor_id, instructors.first_name, instructors.last_name, instructors.dept_id
    FROM instructors
    JOIN advisors on instructors.instructor_id = advisors.instructor_id
    where a_ID = advisors.instructor_id;
END //

-- Modify Student Info
CREATE PROCEDURE modify_student_info(
    IN account_id INT,
    IN username VARCHAR(50),
    IN first_name VARCHAR(50),
    IN last_name VARCHAR(50),
    IN email VARCHAR(100)
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

DELIMITER;

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

-- Check final grade for section

-- Check courses based on semester, including status

-- Check for section information

-- Check for advisor information

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

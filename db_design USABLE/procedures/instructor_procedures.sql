# INSTRUCTOR STORED PROCEDURES

USE university;
DELIMITER //

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

DELIMITER ;

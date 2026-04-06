--- store procedures for instructor table following CRUD
-- insert an instructor
DELIMETER //
CREATE PROCEDURE create_instructor(
    IN instructor_id1 INT,
    IN first_name1 VARCHAR(50),
    IN last_name1 VARCHAR(50),
    IN email1 VARCHAR(100),
    IN salary1 DECIMAL(12, 2))
BEGIN
    INSERT INTO instructor (instructor_id, first_name, last_name, email, salary)
    VALUES (instructor_id1, first_name1, last_name1, email1, salary1)
END
//
DELIMETER ;

-- update an instructor
DELIMETER //
CREATE PROCEDURE update_instructor(
    IN instructor_id1 INT,
    IN first_name1 VARCHAR(50),
    IN last_name1 VARCHAR(50),
    IN email1 VARCHAR(100),
    IN salary1 DECIMAL(12, 2))
BEGIN
    UPDATE instructor
    SET first_name = first_name1,
        last_name = last_name1,
        email = email1,
        salary = salary1
    WHERE instructor_id = instructor_id1
END
//
DELIMETER ;
-- delete an instructor
DELIMETER //
CREATE PROCEDURE delete_instructor(
    IN instructor_id1 INT)
AS
BEGIN
    DELETE FROM instructor
    WHERE instructor_id = instructor_id1
END
//
DELIMETER ;
-- show an instructor
DELIMETER //
CREATE PROCEDURE retrieve_instructor(
    IN instructor_id1 INT)
BEGIN
    SELECT instructor_id, first_name, last_name, email, salary
    FROM instructor
    WHERE instructor_id = instructor_id1
END
//
DELIMETER ;
--- store procedures for student table following CRUD
DELIMETER //
CREATE PROCEDURE create_student(
    IN student_id1 INT,
    IN first_name1 VARCHAR(50),
    IN last_name1 VARCHAR(50),
    IN email1 VARCHAR(100))
BEGIN
    INSERT INTO student (STUDENT_ID, FIRST_NAME, LAST_NAME, EMAIL)
    VALUES (student_id1, first_name1, last_name1, email1)
END
//
DELIMETER ;
-- update a student
CREATE PROCEDURE update_student(
    IN student_id1 INT,
    IN first_name1 VARCHAR(50),
    IN last_name1 VARCHAR(50),
    IN email1 VARCHAR(100))
BEGIN
    UPDATE student
    SET FIRST_NAME = first_name1,
        LAST_NAME = last_name1,
        EMAIL = email1
    WHERE STUDENT_ID = student_id1
END
//
DELIMITER  ;

-- delete a student
DELIMITER  //
CREATE PROCEDURE delete_student(
    IN student_id1 INT)
BEGIN
    DELETE FROM student
    WHERE STUDENT_ID = student_id1
END
//
DELIMITER  ;

-- show a student
DELIMETER //
CREATE PROCEDURE retrieve_student(
    IN student_id1 INT)
BEGIN
    SELECT STUDENT_ID, FIRST_NAME, LAST_NAME, EMAIL
    FROM student
    WHERE STUDENT_ID = student_id1
END
//
DELIMETER  ;

--- store procedures for section table following CRUD
DELIMETER //
CREATE PROCEDURE create_section(
    IN section_id1 INT,
    IN semester1 INT,
    IN year1 INT,
    IN capacity1 INT)
BEGIN 
    INSERT INTO section(section_id, semester,year, capacity)
    VALUES (section_id1, semester1, year1, capacity1)
END
//
DELIMETER ;
-- update a section
CREATE PROCEDURE update_section(
    IN section_id1 INT,
    IN semester1 INT,
    IN year1 INT,
    IN capacity1 INT)
BEGIN 
    UPDATE section
    SET semester = semester1,
        year = year1,
        capacity = capacity1
    WHERE section_id = section_id1
END
//
DELIMETER ;
-- delete a section
CREATE PROCEDURE delete_section(
    IN section_id1 INT)
BEGIN 
    DELETE FROM section
    WHERE section_id = @section_id
END
//
DELIMETER ;
-- show a section
CREATE PROCEDURE retrieve_section(
    IN section_id1 INT)
BEGIN
    SELECT section_id, semester, year, capacity
    FROM section
    WHERE section_id = section_id1
END
//
DELIMETER ;


--- Transactions starts here
-- enrol in a class
CREATE PROCEDURE enrol_in_class(
    IN student_id1 INT,
    IN section_id1 INT)
BEGIN
    BEGIN TRANSACTION
    -- check if the section has capacity
    IF (SELECT capacity FROM section WHERE section_id = section_id1) > 0
    BEGIN
        -- insert into enrollment table
        INSERT INTO enrollment (student_id, section_id)
        VALUES (student_id1, section_id1)

        -- decrease the capacity of the section by 1
        UPDATE section
        SET capacity = capacity - 1
        WHERE section_id = section_id1
        COMMIT TRANSACTION
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION
        PRINT 'Section is full. Cannot enroll.'
    END
END

-- transactions to  assign an instructor to a class, drop a section, give a grade to a section

CREATE PROCEDURE assign_instructor_to_class(
    IN instructor_id1 INT,
    IN section_id1 INT)
BEGIN
    BEGIN TRANSACTION
    -- check if the instructor is available
    IF (SELECT COUNT(*) FROM section WHERE instructor_id = instructor_id1) = 0
    BEGIN        
        -- assign the instructor to the section
        UPDATE section
        SET instructor_id = instructor_id1
        WHERE section_id = section_id1
        COMMIT TRANSACTION
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION
        PRINT 'instructor is assigned and we cannot perform the operation.'
    END
END

CREATE PROCEDURE drop_section(
    IN section_id1 INT)
BEGIN
    BEGIN TRANSACTION   
    -- delete all enrollments for the section
    DELETE FROM enrollment
    WHERE section_id = section_id1
    -- delete the section
    DELETE FROM section
    WHERE section_id = section_id1
    COMMIT TRANSACTION
END

CREATE PROCEDURE give_grade(
    IN student_id1 INT,
    IN section_id1 INT,
    IN grade1 VARCHAR(2))
BEGIN
    BEGIN TRANSACTION
    -- check if the student is enrolled in the section
    IF (SELECT COUNT(*) FROM enrollment WHERE student_id = student_id1 AND section_id = section_id1) > 0
    BEGIN        
        -- update the grade for the enrollment
        UPDATE enrollment
        SET grade = grade1
        WHERE student_id = student_id1 AND section_id = section_id1
        COMMIT TRANSACTION
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION
        PRINT 'the student is not in the section thus he/she doesnt have a grade.'
    END
END

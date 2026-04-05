--- store procedures for instructor table following CRUD
-- insert an instructor
CREATE PROCEDURE create_instructor
    @instructor_id INT,
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @email NVARCHAR(100),
    @salary DECIMAL(18, 2)
AS
BEGIN
    INSERT INTO instructor (instructor_id, first_name, last_name, email, salary)
    VALUES (@instructor_id, @first_name, @last_name, @email, @salary)
END
-- update an instructor
CREATE PROCEDURE update_instructor
    @instructor_id INT,
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @email NVARCHAR(100),
    @salary DECIMAL(18, 2)
AS
BEGIN
    UPDATE instructor
    SET first_name = @first_name,
        last_name = @last_name,
        email = @email,
        salary = @salary
    WHERE instructor_id = @instructor_id
END
-- delete an instructor
CREATE PROCEDURE delete_instructor
    @instructor_id INT
AS
BEGIN
    DELETE FROM instructor
    WHERE instructor_id = @instructor_id
END
-- show an instructor
CREATE PROCEDURE retrieve_instructor
    @instructor_id INT
AS
BEGIN
    SELECT instructor_id, first_name, last_name, email, salary
    FROM instructor
    WHERE instructor_id = @instructor_id
END

--- store procedures for student table following CRUD
CREATE PROCEDURE create_student
    @student_id INT,
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @email NVARCHAR(100)
AS
BEGIN
    INSERT INTO student (STUDENT_ID, FIRST_NAME, LAST_NAME, EMAIL)
    VALUES (@student_id, @first_name, @last_name, @email)
END

CREATE PROCEDURE update_student
    @student_id INT,
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @email NVARCHAR(100)
AS
BEGIN
    UPDATE student
    SET FIRST_NAME = @first_name,
        LAST_NAME = @last_name,
        EMAIL = @email
    WHERE STUDENT_ID = @student_id
END

CREATE PROCEDURE delete_student
    @student_id INT
AS
BEGIN
    DELETE FROM student
    WHERE STUDENT_ID = @student_id
END

CREATE PROCEDURE retrieve_student
    @student_id INT
AS
BEGIN
    SELECT STUDENT_ID, FIRST_NAME, LAST_NAME, EMAIL
    FROM student
    WHERE STUDENT_ID = @student_id
END

--- store procedures for section table following CRUD
CREATE PROCEDURE create_section
    @section_id INT,
    @semester INT,
    @year INT,
    @capacity INT
AS
BEGIN 
    INSERT INTO section(section_id, semester, year, capacity)
    VALUES (@section_id, @semester, @year, @capacity)
END

CREATE PROCEDURE update_section
    @section_id INT,
    @semester INT,
    @year INT,
    @capacity INT
AS
BEGIN 
    UPDATE section
    SET semester = @semester,
        year = @year,
        capacity = @capacity
    WHERE section_id = @section_id
END

CREATE PROCEDURE delete_section
    @section_id INT
AS
BEGIN 
    DELETE FROM section
    WHERE section_id = @section_id
END

CREATE PROCEDURE retrieve_section
    @section_id INT
AS
BEGIN
    SELECT section_id, semester, year, capacity
    FROM section
    WHERE section_id = @section_id
END

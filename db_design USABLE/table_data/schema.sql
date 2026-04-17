-- University Database Schema

DROP DATABASE IF EXISTS university;
CREATE DATABASE university CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE university;

-- BUILDINGS
CREATE TABLE buildings (
    building_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- DEPARTMENTS
CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    budget DECIMAL(10, 2) NOT NULL,
    building_id INT NOT NULL,
    FOREIGN KEY (building_id) REFERENCES buildings(building_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- CLASSROOMS
CREATE TABLE classrooms (
    classroom_id INT AUTO_INCREMENT PRIMARY KEY,
    building_id INT NOT NULL,
    room_number VARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    FOREIGN KEY (building_id) REFERENCES buildings(building_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- TIMESLOTS
CREATE TABLE timeslots (
    timeslot_id INT AUTO_INCREMENT PRIMARY KEY,
    day ENUM('M', 'T', 'W', 'R', 'F') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL
);

-- COURSES
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_id INT NOT NULL,
    course_number VARCHAR(10) NOT NULL,
    title VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- PRE-REQUISITES
CREATE TABLE prerequisites (
    course_id INT NOT NULL,
    prereq_id INT NOT NULL,
    PRIMARY KEY(course_id, prereq_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (prereq_id) REFERENCES courses(course_id)  ON UPDATE CASCADE ON DELETE RESTRICT
);

-- INSTRUCTORS
CREATE TABLE instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    salary DECIMAL(10, 2) NOT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON UPDATE CASCADE ON DELETE SET NULL
);

-- STUDENTS
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON UPDATE CASCADE ON DELETE SET NULL
);

-- ADVISORS
CREATE TABLE advisors (
    advisor_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    instructor_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)  ON UPDATE CASCADE ON DELETE RESTRICT
);

-- ACCOUNTS
CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('student', 'instructor', 'admin') NOT NULL
);

-- STUDENT ACCOUNTS
CREATE TABLE student_accounts(
    account_id INT PRIMARY KEY,
    student_id INT UNIQUE,
    FOREIGN KEY(account_id) REFERENCES accounts(account_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(student_id) REFERENCES students(student_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- INSTRUCTOR ACCOUNTS
CREATE TABLE instructor_accounts(
    account_id INT PRIMARY KEY,
    instructor_id INT UNIQUE,
    FOREIGN KEY(account_id) REFERENCES accounts(account_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(instructor_id) REFERENCES instructors(instructor_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- SECTIONS
CREATE TABLE sections (
    section_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    classroom_id INT,
    timeslot_id INT,
    semester ENUM('Fall', 'Spring', 'Summer') NOT NULL,
    year INT NOT NULL,
    capacity INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (classroom_id) REFERENCES classrooms(classroom_id) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (timeslot_id) REFERENCES timeslots(timeslot_id) ON UPDATE CASCADE ON DELETE SET NULL
);

-- TEACHES
CREATE TABLE teaches (
    section_id INT NOT NULL,
    instructor_id INT NOT NULL,
    PRIMARY KEY (section_id, instructor_id),
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)  ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (section_id) REFERENCES sections(section_id)  ON UPDATE CASCADE ON DELETE CASCADE
);

-- ENROLLMENTS
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    section_id INT NOT NULL,
    grade ENUM('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F', 'W'),
    status ENUM('in progress', 'failed', 'passed', 'dropped') NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES sections(section_id)  ON UPDATE CASCADE ON DELETE RESTRICT
);

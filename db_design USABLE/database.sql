-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 17, 2026 at 03:11 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

DROP DATABASE IF EXISTS `university`;
CREATE DATABASE `university`;
USE `university`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `university`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_advisee` (IN `student_id_n` INT, IN `instructor_id_n` INT)   BEGIN
    INSERT INTO advisors (student_id, instructor_id)
    VALUES (student_id_n, instructor_id_n);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_course_prerequisite` (IN `course_id_n` INT, IN `prereq_id_n` INT)   BEGIN
    INSERT INTO prerequisites (course_id, prereq_id)
    VALUES (course_id_n, prereq_id_n);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `assign_instructor_to_section` (IN `instructor_id_n` INT, IN `section_id_n` INT)   BEGIN
    INSERT INTO teaches (instructor_id, section_id)
    VALUES (instructor_id_n, section_id_n);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `average_grade_by_department` (IN `department_id_n` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `avg_course_grade` (IN `course_id_n` INT, IN `start_semester` VARCHAR(10), IN `start_year` INT, IN `end_semester` VARCHAR(10), IN `end_year` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_grade` (IN `section_id_n` INT, IN `student_id_n` INT, IN `new_grade_n` ENUM('A','A-','B+','B','B-','C+','C','C-','D+','D','D-','F','W'))   BEGIN
    UPDATE enrollments
    SET grade = new_grade_n, status = IF(new_grade_n = 'F', 'failed', 'passed')
    WHERE section_id = section_id_n AND student_id = student_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_sections_teaching` (IN `instructor_id_n` INT, IN `semester_n` VARCHAR(10), IN `year_n` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_section_roster` (IN `section_id_n` INT)   BEGIN
    SELECT students.student_id,students.first_name, students.last_name, enrollments.grade
    FROM students
    JOIN enrollments ON students.student_id = enrollments.student_id
    WHERE enrollments.section_id = section_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_classroom` (`building_id_n` INT, `room_number_n` VARCHAR(10), `capacity_n` INT)   BEGIN
    INSERT INTO classrooms (building_id, room_number, capacity)
    VALUES (building_id_n, room_number_n, capacity_n);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_course` (IN `dept_id_n` INT, IN `course_number_n` VARCHAR(10), IN `title_n` VARCHAR(100), IN `credits_n` INT)   BEGIN
    INSERT INTO courses (dept_id, course_number, title, credits)
    VALUES (dept_id_n, course_number_n, title_n, credits_n);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_department` (`name_n` VARCHAR(100), `budget_n` DECIMAL(10,2), `building_id_n` INT)   BEGIN
    INSERT INTO departments (name, budget, building_id)
    VALUES (name_n, budget_n, building_id_n);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_instructor` (IN `first_name_n` VARCHAR(50), IN `last_name_n` VARCHAR(50), IN `email_n` VARCHAR(100), IN `salary_n` DECIMAL(10,2), IN `dept_id_n` INT)   BEGIN 
    INSERT INTO instructors(first_name, last_name, email, salary, dept_id)
    values (first_name_n, last_name_n, email_n, salary_n, dept_id_n);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_section` (IN `course_id_n` INT, IN `classroom_id_n` INT, IN `timeslot_id_n` INT, IN `semester_n` ENUM('Fall','Spring','Summer'), IN `year_n` INT, IN `capacity_n` INT)   BEGIN
    INSERT INTO sections (course_id, classroom_id, timeslot_id, semester, year, capacity)
    VALUES (course_id_n, classroom_id_n, timeslot_id_n, semester_n, year_n, capacity_n);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_student` (IN `first_name_n` VARCHAR(50), IN `last_name_n` VARCHAR(50), IN `email_n` VARCHAR(100), IN `dept_id_n` INT)   BEGIN
    INSERT INTO students(first_name, last_name, email, dept_id)
    VALUES (first_name_n, last_name_n, email_n, dept_id_n);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_timeslot` (IN `day_n` ENUM('M','T','W','R','F'), IN `start_time_n` TIME, IN `end_time_n` TIME)   BEGIN
    INSERT INTO timeslots (day, start_time, end_time)
    VALUES (day_n, start_time_n, end_time_n);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `current_students_dept` (IN `dept_id_n` INT)   BEGIN
    SELECT departments.name, COUNT(DISTINCT enrollments.student_id)
    FROM departments 
    JOIN courses ON departments.dept_id = courses.dept_id
    JOIN sections ON courses.course_id = sections.course_id
    JOIN enrollments ON sections.section_id = enrollments.section_id
    WHERE departments.dept_id = dept_id_n AND enrollments.status = 'in progress';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_classroom` (IN `classroom_id_n` INT)   BEGIN
    DELETE FROM classrooms WHERE classroom_id = classroom_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_course` (IN `course_id_n` INT)   BEGIN
    DELETE FROM courses WHERE course_id = course_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_department` (IN `dept_id_n` INT)   BEGIN
    DELETE FROM departments WHERE dept_id = dept_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_instructor` (IN `instructor_id_n` INT)   BEGIN 
    DELETE FROM instructors WHERE instructor_id = instructor_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_section` (IN `section_id_n` INT)   BEGIN
    DELETE FROM sections WHERE section_id = section_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_student` (IN `student_id_n` INT)   BEGIN
    DELETE FROM students WHERE student_id = student_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_timeslot` (IN `timeslot_id_n` INT)   BEGIN
    DELETE FROM timeslots WHERE timeslot_id = timeslot_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `drop_class` (IN `student_id_n` INT, IN `section_id_n` INT)   BEGIN
    UPDATE enrollments
    SET status = 'dropped', grade = 'W'
    WHERE student_id = student_id_n AND section_id = section_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `enroll_student_in_section` (IN `student_id_n` INT, IN `section_id_n` INT)   BEGIN
    INSERT INTO enrollments (student_id, section_id, grade, status)
    VALUES (student_id_n, section_id_n, NULL, 'in progress');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_best_class` (IN `sem_n` VARCHAR(10), IN `year_n` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_student_courses` (IN `student_id_n` INT, IN `semester_n` VARCHAR(10), IN `year_n` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_worst_class` (IN `sem_n` VARCHAR(10), IN `year_n` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `modify_admin_info` (IN `account_id_n` INT, IN `username_n` VARCHAR(50))   BEGIN
    UPDATE accounts
    SET username = username_n
    WHERE account_id = account_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `modify_instructor_assignment` (IN `instructor_id_n` INT, IN `old_section_id_n` INT, IN `new_section_id_n` INT)   BEGIN
    UPDATE teaches
    SET section_id = new_section_id_n
    WHERE instructor_id = instructor_id_n AND section_id = old_section_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `modify_instructor_info` (IN `account_id_n` INT, IN `username_n` VARCHAR(50), IN `first_name_n` VARCHAR(50), IN `last_name_n` VARCHAR(50), IN `email_n` VARCHAR(100))   BEGIN
    UPDATE accounts 
    SET username = username_n
    WHERE account_id = account_id_n;

    UPDATE instructors
    JOIN instructor_accounts ON instructors.instructor_id = instructor_accounts.instructor_id
    SET instructors.first_name = first_name_n,
        instructors.last_name = last_name_n,
        instructors.email = email_n
    WHERE instructor_accounts.account_id = account_id_n;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `modify_student_info` (IN `account_id_n` INT, IN `username_n` VARCHAR(50), IN `first_name_n` VARCHAR(50), IN `last_name_n` VARCHAR(50), IN `email_n` VARCHAR(100))   BEGIN
    UPDATE accounts 
    SET username = username_n
    WHERE account_id = account_id_n;

    UPDATE students
    JOIN student_accounts ON students.student_id = student_accounts.student_id
    SET students.first_name = first_name_n,
        students.last_name = last_name_n,
        students.email = email_n
    WHERE student_accounts.account_id = account_id_n;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_classroom` ()   BEGIN
    SELECT
        classrooms.classroom_id,
        buildings.name,
        classrooms.room_number,
        classrooms.capacity
    FROM classrooms
    JOIN buildings ON classrooms.building_id = buildings.building_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_courses` ()   BEGIN
    SELECT
        courses.course_id,
        courses.course_number,
        courses.title,
        courses.credits,
        departments.name AS department
    FROM courses
    LEFT JOIN departments ON courses.dept_id = departments.dept_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_department` ()   BEGIN
    SELECT
        departments.dept_id,
        departments.name,
        departments.budget,
        buildings.name
    FROM departments
    JOIN buildings ON departments.building_id = buildings.building_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_instructors` ()   BEGIN   
    SELECT
        instructors.instructor_id,
        instructors.first_name,
        instructors.last_name,
        instructors.email,
        instructors.salary,
        departments.name
    FROM instructors
    LEFT JOIN departments ON instructors.dept_id = departments.dept_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_sections` ()   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_students` ()   BEGIN
    SELECT
        students.student_id,
        students.first_name,
        students.last_name,
        students.email,
        departments.name 
    FROM students
    LEFT JOIN departments ON students.dept_id = departments.dept_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `read_timeslot` ()   BEGIN
    SELECT
        timeslots.timeslot_id,
        timeslots.day,
        timeslots.start_time,
        timeslots.end_time
    FROM timeslots;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_advisee` (IN `student_id_n` INT, IN `instructor_id_n` INT)   BEGIN
    DELETE FROM advisors
    WHERE student_id = student_id_n 
      AND instructor_id = instructor_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_course_prerequisite` (IN `course_id_n` INT, IN `prereq_id_n` INT)   BEGIN
    DELETE FROM prerequisites 
    WHERE course_id = course_id_n AND prereq_id = prereq_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_instructor_from_section` (IN `instructor_id_n` INT, IN `section_id_n` INT)   BEGIN
    DELETE FROM teaches
    WHERE instructor_id = instructor_id_n AND section_id = section_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_student_from_section` (IN `student_id_n` INT, IN `section_id_n` INT)   BEGIN
    DELETE FROM enrollments
    WHERE student_id = student_id_n AND section_id = section_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `total_students_dept` (IN `dept_id_n` INT)   BEGIN
    SELECT departments.name, COUNT(DISTINCT students.student_id)
    FROM departments
    JOIN students ON departments.dept_id = students.dept_id
    WHERE departments.dept_id = dept_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_classroom` (`classroom_id_n` INT, `building_id_n` INT, `room_number_n` VARCHAR(10), `capacity_n` INT)   BEGIN
    UPDATE classrooms
    SET building_id = building_id_n, room_number = room_number_n, capacity = capacity_n
    WHERE classroom_id = classroom_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_course` (IN `course_id_n` INT, IN `dept_id_n` INT, IN `course_number_n` VARCHAR(10), IN `title_n` VARCHAR(100), IN `credits_n` INT)   BEGIN
    UPDATE courses
    SET course_number = course_number_n, title = title_n, credits = credits_n, dept_id = dept_id_n
    WHERE course_id = course_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_department` (`dept_id_n` INT, `name_n` VARCHAR(100), `budget_n` DECIMAL(10,2), `building_id_n` INT)   BEGIN
    UPDATE departments
    SET name = name_n, budget = budget_n, building_id = building_id_n
    WHERE dept_id = dept_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_instructor` (IN `instructor_id_n` INT, IN `first_name_n` VARCHAR(50), IN `last_name_n` VARCHAR(50), IN `email_n` VARCHAR(100), IN `salary_n` DECIMAL(10,2), IN `dept_id_n` INT)   BEGIN   
    UPDATE instructors
    SET first_name = first_name_n, last_name = last_name_n, email = email_n, salary = salary_n, dept_id = dept_id_n
    WHERE instructor_id = instructor_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_section` (IN `section_id_n` INT, IN `course_id_n` INT, IN `classroom_id_n` INT, IN `timeslot_id_n` INT, IN `semester_n` ENUM('Fall','Spring','Summer'), IN `year_n` INT, IN `capacity_n` INT)   BEGIN
    UPDATE sections
    SET course_id = course_id_n, classroom_id = classroom_id_n, timeslot_id = timeslot_id_n, semester = semester_n, year = year_n, capacity = capacity_n
    WHERE section_id = section_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_student` (IN `student_id_n` INT, IN `first_name_n` VARCHAR(50), IN `last_name_n` VARCHAR(50), IN `email_n` VARCHAR(100), IN `dept_id_n` INT)   BEGIN
    UPDATE students
    SET first_name = first_name_n, last_name = last_name_n, email = email_n, dept_id = dept_id_n
    WHERE student_id = student_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_timeslot` (`timeslot_id_n` INT, `day_n` ENUM('M','T','W','R','F'), `start_time_n` TIME, `end_time_n` TIME)   BEGIN
    UPDATE timeslots
    SET day = day_n, start_time = start_time_n, end_time = end_time_n
    WHERE timeslot_id = timeslot_id_n;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `view_advisees` (IN `advisor_id_n` INT)   BEGIN
    SELECT DISTINCT students.student_id, students.first_name, students.last_name, departments.name
    FROM students
    JOIN advisors ON students.student_id = advisors.student_id
    JOIN departments ON students.dept_id = departments.dept_id
    WHERE advisors.instructor_id = advisor_id_n;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `account_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('student','instructor','admin') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `advisors`
--

CREATE TABLE `advisors` (
  `advisor_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `instructor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `advisors`
--

INSERT INTO `advisors` (`advisor_id`, `student_id`, `instructor_id`) VALUES
(1, 2, 1),
(2, 5, 4),
(3, 6, 4),
(4, 1, 7),
(5, 10, 7),
(6, 4, 9),
(7, 13, 10),
(8, 11, 12),
(9, 12, 12);

-- --------------------------------------------------------

--
-- Table structure for table `buildings`
--

CREATE TABLE `buildings` (
  `building_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `buildings`
--

INSERT INTO `buildings` (`building_id`, `name`) VALUES
(1, 'Watson'),
(2, 'Taylor'),
(3, 'Painter'),
(4, 'Packard');

-- --------------------------------------------------------

--
-- Table structure for table `classrooms`
--

CREATE TABLE `classrooms` (
  `classroom_id` int(11) NOT NULL,
  `building_id` int(11) NOT NULL,
  `room_number` varchar(10) NOT NULL,
  `capacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `classrooms`
--

INSERT INTO `classrooms` (`classroom_id`, `building_id`, `room_number`, `capacity`) VALUES
(1, 4, '101', 500),
(2, 3, '514', 10),
(3, 2, '3128', 70),
(4, 1, '100', 30),
(5, 1, '120', 50);

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL,
  `dept_id` int(11) NOT NULL,
  `course_number` varchar(10) NOT NULL,
  `title` varchar(100) NOT NULL,
  `credits` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`course_id`, `dept_id`, `course_number`, `title`, `credits`) VALUES
(1, 1, 'BIO-101', 'Intro. to Biology', 4),
(2, 1, 'BIO-301', 'Genetics', 4),
(3, 1, 'BIO-399', 'Computational Biology', 3),
(4, 2, 'CS-101', 'Intro. to Computer Science', 4),
(5, 2, 'CS-190', 'Game Design', 4),
(6, 2, 'CS-315', 'Robotics', 3),
(7, 2, 'CS-319', 'Image Processing', 3),
(8, 2, 'CS-347', 'Database System Concepts', 3),
(9, 3, 'EE-181', 'Intro. to Digital Systems', 3),
(10, 4, 'FIN-201', 'Investment Banking', 3),
(11, 5, 'HIS-351', 'World History', 3),
(12, 6, 'MU-199', 'Music Video Production', 3),
(13, 7, 'PHY-101', 'Physical Principles', 4);

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `dept_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `budget` decimal(10,2) NOT NULL,
  `building_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`dept_id`, `name`, `budget`, `building_id`) VALUES
(1, 'Biology', 90000.00, 1),
(2, 'Comp Sci.', 100000.00, 2),
(3, 'Elec. Eng.', 85000.00, 2),
(4, 'Finance', 120000.00, 3),
(5, 'History', 50000.00, 3),
(6, 'Music', 80000.00, 4),
(7, 'Physics', 70000.00, 1);

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `enrollment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `grade` enum('A','A-','B+','B','B-','C+','C','C-','D+','D','D-','F','W') DEFAULT NULL,
  `status` enum('in progress','failed','passed','dropped') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`enrollment_id`, `student_id`, `section_id`, `grade`, `status`) VALUES
(1, 1, 3, 'A', 'passed'),
(2, 1, 10, 'A-', 'passed'),
(3, 2, 3, 'C', 'passed'),
(4, 2, 6, 'A', 'passed'),
(5, 2, 7, 'A', 'passed'),
(6, 2, 10, 'A', 'passed'),
(7, 3, 13, NULL, 'in progress'),
(8, 4, 12, NULL, 'in progress'),
(9, 5, 15, 'B-', 'passed'),
(10, 6, 3, 'F', 'failed'),
(11, 6, 4, NULL, 'in progress'),
(12, 6, 8, NULL, 'in progress'),
(13, 7, 3, 'A-', 'passed'),
(14, 7, 6, 'B+', 'passed'),
(15, 8, 14, NULL, 'in progress'),
(16, 10, 3, 'A', 'passed'),
(17, 10, 9, NULL, 'in progress'),
(18, 11, 11, 'C', 'passed'),
(19, 12, 3, 'C-', 'passed'),
(20, 12, 7, NULL, 'in progress'),
(21, 13, 1, 'A', 'passed'),
(22, 13, 2, 'W', 'dropped');

-- --------------------------------------------------------

--
-- Table structure for table `instructors`
--

CREATE TABLE `instructors` (
  `instructor_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `salary` decimal(10,2) NOT NULL,
  `dept_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `instructors`
--

INSERT INTO `instructors` (`instructor_id`, `first_name`, `last_name`, `email`, `salary`, `dept_id`) VALUES
(1, 'Jack', 'Srinivasan', 'j.srinivasan@university.edu', 65000.00, 2),
(2, 'Wendy', 'Wu', 'w.wu@university.edu', 90000.00, 4),
(3, 'Wolfgang', 'Mozart', 'w.mozart@university.edu', 40000.00, 6),
(4, 'Albert', 'Einstein', 'a.einstein@university.edu', 95000.00, 7),
(5, 'Michael', 'El Said', 'm.el-said@university.edu', 60000.00, 5),
(6, 'William', 'Gold', 'w.gold@university.edu', 40000.00, 7),
(7, 'Annabelle', 'Katz', 'a.katz@university.edu', 75000.00, 2),
(8, 'Zackary', 'Califieri', 'z.califieri@university.edu', 62000.00, 5),
(9, 'Phoebe', 'Singh', 'p.singh@university.edu', 80000.00, 4),
(10, 'Hannah', 'Crick', 'h.crick@university.edu', 72000.00, 1),
(11, 'Steven', 'Brandt', 's.brandt@university.edu', 92000.00, 2),
(12, 'Yimiko', 'Kim', 'y.kim@university.edu', 62000.00, 3);

-- --------------------------------------------------------

--
-- Table structure for table `instructor_accounts`
--

CREATE TABLE `instructor_accounts` (
  `account_id` int(11) NOT NULL,
  `instructor_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prerequisites`
--

CREATE TABLE `prerequisites` (
  `course_id` int(11) NOT NULL,
  `prereq_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `prerequisites`
--

INSERT INTO `prerequisites` (`course_id`, `prereq_id`) VALUES
(2, 1),
(3, 1),
(5, 4),
(6, 4),
(7, 4),
(8, 4),
(9, 13);

-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `sections` (
  `section_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `classroom_id` int(11) DEFAULT NULL,
  `timeslot_id` int(11) DEFAULT NULL,
  `semester` enum('Fall','Spring','Summer') NOT NULL,
  `year` int(11) NOT NULL,
  `capacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`section_id`, `course_id`, `classroom_id`, `timeslot_id`, `semester`, `year`, `capacity`) VALUES
(1, 1, 2, 4, 'Summer', 2017, 10),
(2, 2, 2, 1, 'Summer', 2018, 10),
(3, 4, 1, 20, 'Fall', 2017, 500),
(4, 4, 1, 15, 'Spring', 2018, 500),
(5, 5, 3, 13, 'Spring', 2017, 70),
(6, 5, 3, 2, 'Spring', 2017, 70),
(7, 6, 4, 10, 'Spring', 2018, 30),
(8, 7, 5, 5, 'Spring', 2018, 50),
(9, 7, 3, 9, 'Spring', 2018, 70),
(10, 8, 3, 3, 'Fall', 2017, 70),
(11, 9, 3, 7, 'Spring', 2017, 70),
(12, 10, 1, 4, 'Spring', 2018, 500),
(13, 11, 2, 8, 'Spring', 2018, 10),
(14, 12, 1, 11, 'Spring', 2018, 500),
(15, 13, 4, 1, 'Fall', 2017, 30);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `dept_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `first_name`, `last_name`, `email`, `dept_id`) VALUES
(1, 'Peter', 'Zhang', 'peter.zhang@university.edu', 2),
(2, 'Kammi', 'Shankar', 'kammi.shankar@university.edu', 2),
(3, 'Elias', 'Brandt', 'elias.brandt@university.edu', 5),
(4, 'Randy', 'Chavez', 'randy.chavez@university.edu', 4),
(5, 'Claire', 'Peltier', 'claire.peltier@university.edu', 7),
(6, 'Oliver', 'Levy', 'oliver.levy@university.edu', 7),
(7, 'Amanda', 'Williams', 'amanda.williams@university.edu', 2),
(8, 'Franco', 'Sanchez', 'franco.sanchez@university.edu', 6),
(9, 'Zara', 'Snow', 'zara.snow@university.edu', 7),
(10, 'Jaxon', 'Brown', 'jaxon.brown@university.edu', 2),
(11, 'Mika', 'Aoi', 'mika.aoi@university.edu', 3),
(12, 'Victor', 'Bourikas', 'victor.bourikas@university.edu', 3),
(13, 'Gio', 'Tanaka', 'gio.tanaka@university.edu', 1);

-- --------------------------------------------------------

--
-- Table structure for table `student_accounts`
--

CREATE TABLE `student_accounts` (
  `account_id` int(11) NOT NULL,
  `student_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `teaches`
--

CREATE TABLE `teaches` (
  `section_id` int(11) NOT NULL,
  `instructor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `teaches`
--

INSERT INTO `teaches` (`section_id`, `instructor_id`) VALUES
(1, 10),
(2, 10),
(3, 1),
(4, 7),
(5, 11),
(6, 11),
(7, 1),
(8, 7),
(9, 11),
(10, 1),
(11, 12),
(12, 2),
(13, 5),
(14, 3),
(15, 4);

-- --------------------------------------------------------

--
-- Table structure for table `timeslots`
--

CREATE TABLE `timeslots` (
  `timeslot_id` int(11) NOT NULL,
  `day` enum('M','T','W','R','F') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `timeslots`
--

INSERT INTO `timeslots` (`timeslot_id`, `day`, `start_time`, `end_time`) VALUES
(1, 'F', '08:00:00', '08:50:00'),
(2, 'M', '08:00:00', '08:50:00'),
(3, 'W', '08:00:00', '08:50:00'),
(4, 'F', '09:00:00', '09:50:00'),
(5, 'M', '09:00:00', '09:50:00'),
(6, 'W', '09:00:00', '09:50:00'),
(7, 'F', '11:00:00', '11:50:00'),
(8, 'M', '11:00:00', '11:50:00'),
(9, 'W', '11:00:00', '11:50:00'),
(10, 'F', '13:00:00', '13:50:00'),
(11, 'M', '13:00:00', '13:50:00'),
(12, 'W', '13:00:00', '13:50:00'),
(13, 'R', '10:30:00', '11:45:00'),
(14, 'T', '10:30:00', '11:45:00'),
(15, 'R', '14:30:00', '15:45:00'),
(16, 'T', '14:30:00', '15:45:00'),
(17, 'F', '16:00:00', '16:50:00'),
(18, 'M', '16:00:00', '16:50:00'),
(19, 'W', '16:00:00', '16:50:00'),
(20, 'W', '10:00:00', '12:30:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`account_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `advisors`
--
ALTER TABLE `advisors`
  ADD PRIMARY KEY (`advisor_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `instructor_id` (`instructor_id`);

--
-- Indexes for table `buildings`
--
ALTER TABLE `buildings`
  ADD PRIMARY KEY (`building_id`);

--
-- Indexes for table `classrooms`
--
ALTER TABLE `classrooms`
  ADD PRIMARY KEY (`classroom_id`),
  ADD KEY `building_id` (`building_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`),
  ADD KEY `dept_id` (`dept_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`dept_id`),
  ADD KEY `building_id` (`building_id`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`enrollment_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `section_id` (`section_id`);

--
-- Indexes for table `instructors`
--
ALTER TABLE `instructors`
  ADD PRIMARY KEY (`instructor_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `dept_id` (`dept_id`);

--
-- Indexes for table `instructor_accounts`
--
ALTER TABLE `instructor_accounts`
  ADD PRIMARY KEY (`account_id`),
  ADD UNIQUE KEY `instructor_id` (`instructor_id`);

--
-- Indexes for table `prerequisites`
--
ALTER TABLE `prerequisites`
  ADD PRIMARY KEY (`course_id`,`prereq_id`),
  ADD KEY `prereq_id` (`prereq_id`);

--
-- Indexes for table `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`section_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `classroom_id` (`classroom_id`),
  ADD KEY `timeslot_id` (`timeslot_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `dept_id` (`dept_id`);

--
-- Indexes for table `student_accounts`
--
ALTER TABLE `student_accounts`
  ADD PRIMARY KEY (`account_id`),
  ADD UNIQUE KEY `student_id` (`student_id`);

--
-- Indexes for table `teaches`
--
ALTER TABLE `teaches`
  ADD PRIMARY KEY (`section_id`,`instructor_id`),
  ADD KEY `instructor_id` (`instructor_id`);

--
-- Indexes for table `timeslots`
--
ALTER TABLE `timeslots`
  ADD PRIMARY KEY (`timeslot_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `advisors`
--
ALTER TABLE `advisors`
  MODIFY `advisor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `buildings`
--
ALTER TABLE `buildings`
  MODIFY `building_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `classrooms`
--
ALTER TABLE `classrooms`
  MODIFY `classroom_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `dept_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `enrollment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `instructors`
--
ALTER TABLE `instructors`
  MODIFY `instructor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `section_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `timeslots`
--
ALTER TABLE `timeslots`
  MODIFY `timeslot_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `advisors`
--
ALTER TABLE `advisors`
  ADD CONSTRAINT `advisors_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `advisors_ibfk_2` FOREIGN KEY (`instructor_id`) REFERENCES `instructors` (`instructor_id`) ON UPDATE CASCADE;

--
-- Constraints for table `classrooms`
--
ALTER TABLE `classrooms`
  ADD CONSTRAINT `classrooms_ibfk_1` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`building_id`) ON UPDATE CASCADE;

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON UPDATE CASCADE;

--
-- Constraints for table `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`building_id`) ON UPDATE CASCADE;

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `sections` (`section_id`) ON UPDATE CASCADE;

--
-- Constraints for table `instructors`
--
ALTER TABLE `instructors`
  ADD CONSTRAINT `instructors_ibfk_1` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `instructor_accounts`
--
ALTER TABLE `instructor_accounts`
  ADD CONSTRAINT `instructor_accounts_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `instructor_accounts_ibfk_2` FOREIGN KEY (`instructor_id`) REFERENCES `instructors` (`instructor_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `prerequisites`
--
ALTER TABLE `prerequisites`
  ADD CONSTRAINT `prerequisites_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prerequisites_ibfk_2` FOREIGN KEY (`prereq_id`) REFERENCES `courses` (`course_id`) ON UPDATE CASCADE;

--
-- Constraints for table `sections`
--
ALTER TABLE `sections`
  ADD CONSTRAINT `sections_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `sections_ibfk_2` FOREIGN KEY (`classroom_id`) REFERENCES `classrooms` (`classroom_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `sections_ibfk_3` FOREIGN KEY (`timeslot_id`) REFERENCES `timeslots` (`timeslot_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `student_accounts`
--
ALTER TABLE `student_accounts`
  ADD CONSTRAINT `student_accounts_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `student_accounts_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `teaches`
--
ALTER TABLE `teaches`
  ADD CONSTRAINT `teaches_ibfk_1` FOREIGN KEY (`instructor_id`) REFERENCES `instructors` (`instructor_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `teaches_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `sections` (`section_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- Step 1
-- create table command
CREATE TABLE students (
    github VARCHAR(30) PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30)
);

-- insert rows into the table
INSERT INTO students
VALUES ('jhacks', 'Jane', 'Hacker');

INSERT INTO students
VALUES ('sdevelops', 'Sarah', 'Developer');

-- Step 2: Getting data out of the database
-- 1
SELECT last_name FROM students;
-- 2
SELECT github, first_name FROM students;
-- 3
SELECT * FROM students
WHERE first_name = 'Sarah';
-- 4
SELECT * FROM students
WHERE github = 'sdevelops';
-- 5
SELECT first_name, last_name FROM students
WHERE github = 'jhacks';

-- Step 3: The projects table
CREATE TABLE projects (
    title VARCHAR(30) PRIMARY KEY,
    description TEXT,
    max_grade INT
);

INSERT INTO projects (title, description, max_grade)
VALUES ('Markov', 'Tweets generated from Markov chains', 50);

INSERT INTO projects
VALUES ('Blockly', 'Programmatic Logic Puzzle Game', 100);

INSERT INTO projects
VALUES 
    ('Pseudo', 'Pattern detection in comments', 100),
    ('Wipeout', 'Removing data using cybersecurity', 80),
    ('Scooby', 'Simulated mystery solutions', 100);

-- Step 4: Dump/Restore a PostgreSQL Database
-- dumping the database into an SQL file (command line)
pg_dump -d project-tracker -f project-tracker.sql

-- drop the old table from your computer
dropdb project-tracker
-- create the database anew
createdb project-tracker

-- setting your new database with your info from the .sql file
psql -d project-tracker -f project-tracker.sql

-- Step 5: Advanced Querying
-- 1
SELECT title, max_grade FROM projects
WHERE max_grade > 50;
-- 2
SELECT title, max_grade FROM projects
WHERE max_grade BETWEEN 10 AND 60;
-- 3
SELECT title, max_grade FROM projects
WHERE max_grade NOT BETWEEN 25 and 75;
-- 4
SELECT * FROM projects
ORDER BY max_grade;
-- Extra
SELECT title, max_grade FROM projects
WHERE title LIKE '%y%';

-- Step 6: Linking the Tables Together
CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    student_github VARCHAR(30) REFERENCES students,
    project_title VARCHAR(30) REFERENCES projects,
    grade INT
);

-- Insert grade data
INSERT INTO grades (student_github, project_title, grade)
VALUES 
    ('jhacks', 'Markov', 10),
    ('jhacks', 'Blockly', 2);

INSERT INTO grades (student_github, project_title, grade)
VALUES 
    ('sdevelops', 'Markov', 50),
    ('sdevelops', 'Blockly', 100);
-- Extra data
INSERT INTO grades (student_github, project_title, grade)
VALUES 
    ('jhacks', 'Wipeout', 60),
    ('jhacks', 'Scooby', 78),
    ('jhacks', 'Pseudo', 25);

INSERT INTO grades (student_github, project_title, grade)
VALUES 
    ('sdevelops', 'Wipeout', 79),
    ('sdevelops', 'Scooby', 100),
    ('sdevelops', 'Pseudo', 67);

-- Test for non-valid github user
INSERT INTO grades (student_github, project_title, grade)
VALUES 
    ('sboy', 'Wipeout', 65);

-- Step 7: Getting Jane's Project Grades

-- Query 1:
SELECT first_name, last_name 
FROM students
WHERE github = 'jhacks';
-- Query 2:
SELECT project_title, grade
FROM grades
WHERE student_github = 'jhacks';
-- Query 3:
SELECT title, max_grade
FROM projects;

-- Basic Join
SELECT *
FROM students
    JOIN grades 
        ON (students.github = grades.student_github);

-- Join students and grades
SELECT s.first_name, 
    s.last_name, 
    g.project_title, 
    g.grade
FROM students AS s
    JOIN grades AS g 
        ON (s.github = g.student_github);

-- Joining all three tables
SELECT *
FROM students
    JOIN grades ON (students.github = grades.student_github)
    JOIN projects ON (grades.project_title = projects.title)
WHERE github = 'jhacks';

-- Final Query
SELECT s.first_name,
    s.last_name,
    g.project_title,
    g.grade,
    p.max_grade
FROM students AS s
    JOIN grades AS g
        ON (s.github = g.student_github)
    JOIN projects AS p
        ON (g.project_title = p.title)
WHERE github = 'jhacks';
    
-- Further Study
-- Create a view. We can manipulate a view as if it was a defined table
CREATE VIEW report_card_view AS
SELECT s.first_name,
    s.last_name,
    g.project_title,
    g.grade,
    p.max_grade
FROM students AS s
    JOIN grades AS g
        ON (s.github = g.student_github)
    JOIN projects AS p
        ON (g.project_title = p.title);

-- With this defined, we can then query it like another table
SELECT *
FROM report_card_view;

SELECT *
FROM report_card_view
ORDER BY first_name, project_title;

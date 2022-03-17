CREATE TABLE IF NOT EXISTS library_system (
  matric_number VARCHAR(9) NOT NULL ,
  email VARCHAR(256) NOT NULL,
  library VARCHAR(7) NOT NULL, CHECK (library IN ('CLB','SLB')),
  time_entered TIMESTAMPTZ DEFAULT Now(),
  time_exited TIMESTAMPTZ ,
  PRIMARY KEY(matric_number,email) );  --So that student can have multiple entries in the system where they entered at different times

CREATE TABLE IF NOT EXISTS student(
  student VARCHAR(9),
  email VARCHAR(256),
  level INT,
  table_no DEC,
  leaving_for_a_while VARCHAR(3), CHECK (leaving_for_a_while = 'YES' or NULL),
  leaving_for_good VARCHAR(3), CHECK (leaving_for_good = 'YES' or NULL),
  FOREIGN KEY (student, email) REFERENCES library_system(matric_number,email)
  ON DELETE CASCADE DEFERRABLE
);

CREATE TABLE IF NOT EXISTS available(
	library VARCHAR(7) NOT NULL, CHECK (library IN ('CLB','SLB')),
	level INT NOT NULL,
	total_seats INT NOT NULL,
	available_seats INT NOT NULL,
	PRIMARY KEY(library, level)
);

SELECT * FROM library_system;
SELECT * FROM student;
SELECT * FROM available ORDER BY library;
DROP TABLE library_system;
DROP TABLE student;
DROP TABLE available;

/*When a student taps into the library*/
INSERT INTO library_system VALUES('A0217795N','abs@gmail.com','CLB');
INSERT INTO library_system VALUES('A1234567N','efg@gmail.com','SLB');

/*When a student scans the QR CODE on the table*/
INSERT INTO student VALUES('A0217795N','abs@gmail.com',4 ,1.1);
INSERT INTO student VALUES('A1234567N','efg@gmail.com',5 ,2.2);

/* UPDATE the available_seats table available*/
UPDATE available 
SET available_seats = available_seats - 1
WHERE library =  (
SELECT l.library
FROM student s, library_system l
WHERE s.student = l.matric_number AND s.student = 'A0217795N') 
AND level = (SELECT s.level
FROM student s, library_system l
WHERE s.student = l.matric_number AND s.student = 'A0217795N') 

UPDATE available 
SET available_seats = available_seats - 1
WHERE library =  (
SELECT l.library
FROM student s, library_system l
WHERE s.student = l.matric_number AND s.student = 'A1234567N') 
AND level = (SELECT s.level
FROM student s, library_system l
WHERE s.student = l.matric_number AND s.student = 'A1234567N') 

/*When a student indicate that he is leaving for a while*/
UPDATE student
SET leaving_for_a_while = 'YES'
WHERE student = 'A0217795N' ;

/*When a student taps out of the library*/
UPDATE library_system
SET time_exited = Now()
WHERE matric_number = 'A0217795N' ;

/*When a student taps into the library again*/

UPDATE library_system
SET time_entered = Now(), time_exited = NUll
WHERE matric_number = 'A0217795N' ;
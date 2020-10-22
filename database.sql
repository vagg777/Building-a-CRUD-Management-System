/* TO INITIALIZE DATABASES AND POPULATE THEM */

DROP DATABASE IF EXISTS devdb;
DROP DATABASE IF EXISTS testdb;
DROP DATABASE IF EXISTS proddb;

CREATE DATABASE devdb;
CREATE DATABASE testdb;
CREATE DATABASE proddb;

USE devdb;

CREATE TABLE IF NOT EXISTS users(userName VARCHAR(255) NOT NULL UNIQUE, password VARCHAR(255) NOT NULL)ENGINE=INNODB;
CREATE TABLE IF NOT EXISTS department(id INT(20) NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255) NOT NULL UNIQUE, street VARCHAR(255) DEFAULT NULL, employees_count INT(20) DEFAULT 0) ENGINE=INNODB;
CREATE TABLE IF NOT EXISTS employee(id INT(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,first_name VARCHAR(255) NOT NULL, last_name VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL UNIQUE, born INT(20) NOT NULL, country VARCHAR(255) NOT NULL, department_name VARCHAR(255) DEFAULT NULL, FOREIGN KEY (department_name) REFERENCES department(name) ON UPDATE CASCADE ON DELETE SET NULL) ENGINE=INNODB;
ALTER TABLE `employee` ADD UNIQUE INDEX `unique_department_name_employee` (`department_name`, `first_name`, `last_name`, `email` ); /*Each First_Name - Last_Name - Email Combination can only work in only 1 department */
ALTER TABLE `department` ADD UNIQUE INDEX `unique_department_name_street` (`name`, `street`); /*Each Department Name - Department Street - Combination can only appear once */


DROP TRIGGER IF EXISTS users_trigger;
DROP TRIGGER IF EXISTS department_trigger;
DROP TRIGGER IF EXISTS employee_trigger;


CREATE TRIGGER users_trigger BEFORE INSERT ON `users`   /* Username and Password must at least 3 characters long */
FOR EACH ROW
  BEGIN
    DECLARE usernameLength INT;
    DECLARE passwordLength INT;
    SET usernameLength = (SELECT LENGTH(NEW.userName));
    IF (usernameLength) < 3 THEN
      SIGNAL SQLSTATE '45000' set message_text='Error: Username must consist of 3 characters at least!!!';
    END IF;
    SET passwordLength = (SELECT LENGTH(NEW.password));
    IF (passwordLength) < 3 THEN
      SIGNAL SQLSTATE '45000' set message_text='Error: Password must consist of 3 characters at least!!!';
    END IF;
  END;

CREATE TRIGGER department_trigger BEFORE INSERT ON `department` /* Department Name and Street must at least 3 characters long */
FOR EACH ROW
  BEGIN
    DECLARE departmentNameLength INT;
    DECLARE departmentStreetLength INT;
    SET departmentNameLength = (SELECT LENGTH(NEW.name));
    IF (departmentNameLength) < 3 THEN
      SIGNAL SQLSTATE '45000' set message_text='Error: Department Name must consist of 3 characters at least!!!';
    END IF;
    SET departmentStreetLength = (SELECT LENGTH(NEW.street));
    IF (departmentStreetLength) < 3 THEN
      SIGNAL SQLSTATE '45000' set message_text='Error: Department Street must consist of 3 characters at least!!!';
    END IF;
  END;

CREATE TRIGGER employee_trigger BEFORE INSERT ON `employee` /* Employee First and Last names must at least 3 characters long, Birth Year only 4 characters long */
FOR EACH ROW
  BEGIN
    DECLARE employeeFirstNameLength INT;
    DECLARE employeeLastNameLength INT;
    DECLARE employeeBirthYearLength INT;
    SET employeeFirstNameLength = (SELECT LENGTH(NEW.first_name));
    IF (employeeFirstNameLength) < 3 THEN
      SIGNAL SQLSTATE '45000' set message_text='Error: First Name must consist of 3 characters at least!!!';
    END IF;
    SET employeeLastNameLength = (SELECT LENGTH(NEW.last_name));
    IF (employeeLastNameLength) < 3 THEN
      SIGNAL SQLSTATE '45000' set message_text='Error: Last Name must consist of 3 characters at least!!!';
    END IF;
    SET employeeBirthYearLength = (SELECT LENGTH(NEW.born));
    IF (employeeBirthYearLength) != 4 THEN
      SIGNAL SQLSTATE '45000' set message_text='Error: Birth Year must consist of 4 characters!!!';
    END IF;
  END;



INSERT INTO users VALUES ('vagg77','pass');
INSERT INTO users VALUES ('maria66','maria66');
INSERT INTO users VALUES ('john_john','jonhny13');
INSERT INTO users VALUES ('markos1','mark1mark1');
INSERT INTO users VALUES ('dimi_pap','dimi1992');
INSERT INTO users VALUES ('george1995','george1221995');
INSERT INTO users VALUES ('marinos_kuriak','kuriak8');
INSERT INTO users VALUES ('james8g','password');


INSERT INTO department(name,street) VALUES ('Alexandroupoli', 'Leoforos Dimokratias 21');
INSERT INTO department(name,street) VALUES ('Athens','Basilisis Sofias 111');
INSERT INTO department(name,street) VALUES ('Patras','Smurnis 34');
INSERT INTO department(name,street) VALUES ('Kalamata','Leoforos Fountas 241');
INSERT INTO department(name,street) VALUES ('Heraklion','Leoforos Enetwn 132');
INSERT INTO department(name,street) VALUES ('Thessaloniki','Karolou 45');
INSERT INTO department(name,street) VALUES ('Xanthi','Agia Barbasa 68');
INSERT INTO department(name,street) VALUES ('Larisa','Hroon Polutexneiou 12');


INSERT INTO employee(first_name,last_name,email,born,country,department_name) VALUES('Vaggelis','Michos','vagg7@gmail.com','1995','Greece','Athens');
INSERT INTO employee(first_name,last_name,email,born,country,department_name) VALUES('James','Gunn','james8@gmail.com','1970','United States','Athens');
INSERT INTO employee(first_name,last_name,email,born,country,department_name) VALUES('George','McMahon','george95@gmail.com','1978','United States','Patras');
INSERT INTO employee(first_name,last_name,email,born,country,department_name) VALUES('John','Jones','john13@gmail.com','1992','England','Patras');
INSERT INTO employee(first_name,last_name,email,born,country,department_name) VALUES('Marinos','Kuriakopoulos','marin_kur@gmail.com','1986','Greece','Alexandroupoli');
INSERT INTO employee(first_name,last_name,email,born,country,department_name) VALUES('Dimitris','Nikolaou','dimitis8@yahoo.gr','1984','Greece','Larisa');
INSERT INTO employee(first_name,last_name,email,born,country,department_name) VALUES('Soufiane','El Kaddouri','sofiane@yahoo.com','1974','France','Xanthi');
INSERT INTO employee(first_name,last_name,email,born,country,department_name) VALUES('Maria','Apostolou','mariamaria1@gmail.com','1997','Greece','Larisa');
INSERT INTO employee(first_name,last_name,email,born,country,department_name) VALUES('Ioannis','Marinou','ioannis_ap@yahoo.gr','1982','Greece','Kalamata');
INSERT INTO employee(first_name,last_name,email,born,country,department_name) VALUES('Thanasis','Athanasiou','thanos89@gmail.com','1989','Cyprus','Heraklion');


UPDATE department SET employees_count = (SELECT COUNT(*) FROM employee WHERE department.name = employee.department_name);
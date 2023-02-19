#DATABASE CREATION

drop database if exists wfh2DB;
CREATE database wfh2DB;
use wfh2DB;

DROP TABLE IF EXISTS department;
CREATE TABLE department (
departmentID int(5) NOT NULL,
departmentName varchar(30) NOT NULL,
PRIMARY KEY (departmentID)
);


DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
employeeID int(5) NOT NULL,
employeeLastName varchar(20) NOT NULL,
employeeFirstName varchar(20) NOT NULL,
employeeEmail varchar(50) NOT NULL,
employeeStreetAddress varchar(50) NOT NULL,
employeeCity varchar(30) DEFAULT NULL,
employeeState varchar(10) DEFAULT NULL,
employeeZipCode varchar(10) DEFAULT NULL,
employeeDoB date NOT NULL,
employeeGender varchar(2) NOT NULL,
employeeEthnicity varchar(15) NOT NULL,
ip1 varchar(15) NOT NULL,
ip2 varchar(15) NOT NULL,
departmentID int(5) NOT NULL,
PRIMARY KEY (employeeID),
FOREIGN KEY (departmentID) REFERENCES department (departmentID)
);



DROP TABLE IF EXISTS manager;
CREATE TABLE manager (
managerID int(5) NOT NULL,
departmentID int(5) NOT NULL,
PRIMARY KEY (managerID),
FOREIGN KEY (managerID) REFERENCES employee (employeeID),
FOREIGN KEY (departmentID) REFERENCES department (departmentID)
);



DROP TABLE IF EXISTS warehouse;
CREATE TABLE warehouse (
warehouseID int(5) NOT NULL,
sectionCount int NOT NULL,
warehouseStreetAddress varchar(50) NOT NULL,
warehouseCity varchar(30) DEFAULT NULL,
warehouseState varchar(2) DEFAULT NULL,
warehouseZipCode varchar(10) DEFAULT NULL,
warehouseIP varchar(15) NOT NULL,
PRIMARY KEY (warehouseID)
);

DROP TABLE IF EXISTS section;
CREATE TABLE section (
sectionID int(5) NOT NULL,
warehouseID int(5) NOT NULL,
capacity int NOT NULL,
PRIMARY KEY (sectionID),
FOREIGN KEY (warehouseID) REFERENCES warehouse (warehouseID)
);

DROP TABLE IF EXISTS product;
CREATE TABLE product (
productID int NOT NULL,
productName varchar(50) NOT NULL,
PRIMARY KEY (productID)
);

DROP TABLE IF EXISTS projects;
CREATE TABLE projects (
projectID char(6) NOT NULL,
projectName varchar(50) NOT NULL,
startDate date NOT NULL,
finishDate date DEFAULT NULL,
PRIMARY KEY (projectID)
);

DROP TABLE IF EXISTS log_detail;
CREATE TABLE log_detail (
logID char(7) NOT NULL,
productID int NOT NULL,
sectionID int(5) NOT NULL,
logDate datetime NOT NULL,
inflowCount int DEFAULT NULL,
outflowCount int DEFAULT NULL,
projectID char(6) NOT NULL,
PRIMARY KEY (logID),
FOREIGN KEY (productID) REFERENCES product (productID),
FOREIGN KEY (sectionID) REFERENCES section (sectionID),
FOREIGN KEY (projectID) REFERENCES projects (projectID)
);

DROP TABLE IF EXISTS remoteDesk;
CREATE TABLE remoteDesk (
remoteID char(7) NOT NULL,
employeeID int(5) NOT NULL,
instantIP varchar(15) NOT NULL,
remoteDate date NOT NULL,
logIn time NOT NULL,
logOut time NOT NULL,
PRIMARY KEY (remoteID),
FOREIGN KEY (employeeID) REFERENCES employee (employeeID)
);

DROP TABLE IF EXISTS remoteDeskWarning;
CREATE TABLE remoteDeskWarning (
remoteID char(7) NOT NULL,
warning varchar(50),
PRIMARY KEY (remoteID)
);


DROP TRIGGER IF EXISTS ip_warning;
DELIMITER $$
    CREATE TRIGGER ip_warning after insert on remoteDesk
    FOR EACH ROW 
    BEGIN
      IF (strcmp(trim(trailing SUBSTRING_INDEX(NEW.instantIP, '.', -1) from NEW.instantIP), 
      trim(trailing SUBSTRING_INDEX((select ip1 from employee where new.employeeID = employeeID), '.', -1) from (select ip1 from employee where new.employeeID = employeeID))) != 0)
      THEN
            insert into remoteDeskWarning (remoteID, warning)
            values (new.remoteID, 1);
      END IF;
    END$$
DELIMITER ;



DROP TABLE IF EXISTS meeting;
CREATE TABLE meeting (
meetID char(6) NOT NULL,
meetingDate date NOT NULL,
beginTime time NOT NULL,
endTime time NOT NULL,
meetingAgenda varchar(50) NOT NULL,
projectID char(6) DEFAULT NULL,
PRIMARY KEY (meetID),
FOREIGN KEY (projectID) REFERENCES projects (projectID)
);

DROP TABLE IF EXISTS meeting_attendance;
CREATE TABLE meeting_attendance (
meetID char(6) NOT NULL,
employeeID int(5) NOT NULL,
PRIMARY KEY (meetID, employeeID),
FOREIGN KEY (meetID) REFERENCES meeting (meetID),
FOREIGN KEY (employeeID) REFERENCES employee (employeeID) 
);


DROP TABLE IF EXISTS project_team;
CREATE TABLE project_team (
projectID char(6) NOT NULL,
employeeID int(5) NOT NULL,
PRIMARY KEY (projectID, employeeID),
FOREIGN KEY (projectID) REFERENCES projects (projectID),
FOREIGN KEY (employeeID) REFERENCES employee (employeeID)
);


DROP TABLE IF EXISTS section_codes;
CREATE TABLE section_codes (
codes char(5) NOT NULL,
sectionID int(5) NOT NULL,
projectID char(6) NOT NULL,
PRIMARY KEY (codes),
FOREIGN KEY (sectionID) REFERENCES section (sectionID),
FOREIGN KEY (projectID) REFERENCES projects (projectID)
);


### DATA INSERTION

INSERT INTO `wfh2db`.`department`
(`departmentID`,`departmentName`)
VALUES
(1,'Sales'),
(2,'Operations'),
(3,'Administration Systems');

INSERT INTO `wfh2db`.`employee`
values
(1001,'Abraham','John','johnabraham@myco.com','9877 Hacienda Drive', 'Tacoma', 'WA', '98413',STR_TO_DATE('24-May-1998', '%d-%M-%Y'),'M', 'White', '3.127.255.0', '3.127.255.255',2),
(1002,'Clark','Michael','michaelclark@myco.com','908 W. Capital Way', 'Palm Springs', 'CA', '92263',STR_TO_DATE('11-Jan-1994', '%d-%M-%Y'),'M','Black','3.255.255.0', '3.255.255.255',2),
(1003,'Nicholls','Heather','heathernicholls@myco.com','611 Alpine Drive', 'Redmond', 'WA', '98052',STR_TO_DATE('22-Sep-1995', '%d-%M-%Y'),'F','White','4.127.255.0', '4.127.255.255',1),
(1004,'Jose','Tom','tomjose@myco.com','4110 Old Redmond Rd.', 'Seattle', 'WA', '98105',STR_TO_DATE('25-Oct-1988', '%d-%M-%Y'),'M','White','4.143.255.0', '4.143.255.255',2),
(1005,'Pinto','Jerry','jerrypinto@myco.com','4726 - 11th Ave. N.E.', 'Medford',	'OR','97501',STR_TO_DATE('1-May-1992', '%d-%M-%Y'),'M','Hispanic','4.159.255.0', '4.159.255.255',3),
(1006,'Mathew','Philip','philipmathew@myco.com','66 Spring Valley Drive', 'Auburn',	'WA','98002',STR_TO_DATE('3-Mar-1994', '%d-%M-%Y'),'M','White','4.191.255.0', '4.191.255.255',1),
(1007,'Young','Nancy','nancyyoung@myco.com','908 W. Capital Way', 'Portland', 'OR', '97208',STR_TO_DATE('13-Mar-1994', '%d-%M-%Y'),'F','Asian','4.255.255.0', '4.255.255.255',2),
(1008,'Rai','Sandra','sandrarai@myco.com','16679 NE 41st Court', 'Eugene', 'OR', '97401',STR_TO_DATE('24-Apr-1995', '%d-%M-%Y'),'F','White','6.255.255.0', '6.255.255.255',2),
(1009,'Neilsen','John','johnneilsen@myco.com','30301 - 166th Ave. N.E', 'Tacoma', 'WA','98413',STR_TO_DATE('2-Nov-1995', '%d-%M-%Y'),'M','White','7.255.255.0', '7.255.255.255',3),
(1010,'Austin','Tiffany','austintiffany@myco.com','908 W. Capital Way', 'Portland', 'OR', '97208',STR_TO_DATE('13-Mar-1989', '%d-%M-%Y'),'F','Black','8.127.255.0', '8.127.255.255',1);


INSERT INTO `wfh2db`.`manager`
(`managerID`,`departmentID`)
VALUES
(1010,1),
(1007,2),
(1009,3);



INSERT INTO warehouse
(warehouseID, sectioncount, warehouseStreetAddress, warehouseCity , warehouseState , warehouseZipCode , warehouseIP)
VALUES
(001, 2, '910 Vine Street', 'Queens','NY','97313', '173.68.52.118'),
(002, 2, '9273 Thorne Ave', 'Temple', 'PA' ,'19122','63.228.187.0'),
(003, 2, '769C Honey Creek St', 'Chestnut Hill','MA','02467','136.167.157.138');

INSERT INTO section
(sectionID, warehouseID, capacity)
VALUES
(01, 001, 50),
(02, 001, 80),
(03, 002, 60),
(04, 002, 100),
(05, 003, 75),
(06, 003, 80);

INSERT INTO product
(productID, productName)
VALUES
(100, 'iphone13'),
(200, 'Dell 15 Laptop'),
(300, 'JBL TV speaker'),
(400, 'One plus 9'),
(500, 'HP 218 Color Printer'),
(600, 'Samsung S8 Case'),
(700, 'Apple Macbook Air'),
(800, 'Google Home');


INSERT INTO `wfh2db`.`projects`
(`projectID`,`projectName`,`startDate`,`finishDate`)
VALUES
('PR01','North sales enhancement','2022-07-05', null),
('TC02','Amazon warehouse management','2022-07-06','2022-07-08'),
('RT03','Walmart electronic storage','2022-07-05','2022-07-07'),
('DG04','Ebay account and sales','2022-07-07', null),
('Int','Internal meetnigs','2022-07-04', null);



INSERT INTO log_detail
(logID, productID, sectionID, logDate, inflowCount, outflowCount,projectID)
VALUES
('Log01', 600, 01,'2022-07-05', 20, 10,'RT03'),
('Log02', 200, 05,'2022-07-05', 40,  2,'RT03'),
('Log03', 300, 03,'2022-07-06', 35, 0,'TC02'),
('Log04', 200, 05,'2022-07-06', 20, 15,'RT03'), 
('Log05', 100, 02,'2022-07-06', 20, 15,'TC02'), 
('Log06', 500, 06,'2022-07-07', 25, 0,'DG04'), 
('Log07', 200, 05,'2022-07-07', 50, 35,'RT03'),
('Log08', 700, 04,'2022-07-07', 10, 2,'DG04'),
('Log09', 100, 02,'2022-07-07', 50, 0,'TC02'),
('Log10', 200, 05,'2022-07-07', 0, 58,'RT03'),
('Log11', 600, 01,'2022-07-07', 0, 10,'RT03'),
('Log12', 800, 01,'2022-07-08', 40, 0,'DG04'),
('Log13', 300, 03,'2022-07-08', 0, 35,'TC02'),
('Log14', 100, 02,'2022-07-08', 0, 55,'TC02'),
('Log15', 500, 02,'2022-07-08', 0, 20,'DG04');


INSERT INTO `wfh2db`.`remoteDesk`
(`remoteID`,`employeeID`,`instantIP`,`remoteDate`,`logIn`,`logOut`)
VALUES
('RMID01',1002,'3.255.255.110','2022-07-05','08:10:42','14:00:00'),
('RMID02',1003,'4.127.255.123','2022-07-05','07:55:35','16:30:48'),
('RMID03',1004,'4.143.255.255','2022-07-05','08:05:40','16:30:15'),
('RMID04',1005,'4.159.255.123','2022-07-05','08:00:42','17:10:42'),
('RMID05',1006,'4.191.255.126','2022-07-05','08:24:50','17:22:58'),
('RMID06',1007,'4.255.255.59','2022-07-05','08:22:24','17:22:40'),
('RMID07',1008,'6.255.255.203','2022-07-05','08:15:58','17:10:40'),
('RMID08',1009,'7.255.255.123','2022-07-05','09:23:56','12:50:28'),
('RMID09',1010,'8.127.255.132','2022-07-05','09:30:20','18:50:59'),
('RMID10',1001,'3.127.255.156','2022-07-06','08:05:40','14:50:42'),
('RMID11',1002,'3.255.255.23','2022-07-06','08:00:42','15:50:36'),
('RMID12',1003,'4.127.255.67','2022-07-06','08:24:50','12:50:28'),
('RMID13',1005,'4.159.255.100','2022-07-06','08:15:58','17:10:40'),
('RMID14',1006,'4.191.255.120','2022-07-06','08:23:56','12:00:00'),
('RMID15',1007,'4.255.255.103','2022-07-06','09:30:20','18:50:59'),
('RMID16',1008,'6.255.255.78','2022-07-06','08:45:56','16:50:42'),
('RMID17',1009,'7.255.255.235','2022-07-06','09:20:28','15:50:36'),
('RMID18',1001,'103.54.152.245','2022-07-07','08:05:40','16:50:42'),
('RMID19',1002,'3.255.255.56','2022-07-07','08:00:42','19:00:36'),
('RMID20',1003,'4.127.255.89','2022-07-07','08:24:50','16:50:28'),
('RMID21',1004,'4.143.255.255','2022-07-07','08:15:58','17:10:40'),
('RMID22',1005,'4.159.255.82','2022-07-07','08:23:56','19:01:00'),
('RMID23',1006,'4.191.255.108','2022-07-07','09:30:20','17:00:59'),
('RMID24',1007,'4.255.255.110','2022-07-07','08:45:56','18:50:42'),
('RMID25',1008,'6.255.255.128','2022-07-07','08:45:56','18:50:42'),
('RMID26',1009,'7.255.255.99','2022-07-07','09:20:28','15:50:36'),
('RMID27',1001,'3.127.255.90','2022-07-08','12:20:28','18:30:36'),
('RMID28',1002,'3.255.255.76','2022-07-08','09:20:28','17:00:36'),
('RMID29',1003,'4.127.255.187','2022-07-08','09:20:28','18:00:36'),
('RMID30',1004,'4.143.255.255','2022-07-08','11:25:33','19:00:36'),
('RMID31',1005,'4.159.255.101','2022-07-08','09:20:28','18:00:55'),
('RMID32',1006,'4.191.255.10','2022-07-08','14:20:28','18:16:47'),
('RMID33',1007,'4.255.255.20','2022-07-08','09:20:28','19:00:36'),
('RMID34',1008,'6.255.255.67','2022-07-08','09:20:28','15:00:19'),
('RMID35',1009,'7.255.255.52','2022-07-08','12:45:12','18:15:00'),
('RMID36',1010,'8.127.255.189','2022-07-08','13:34:08','18:32:36');

INSERT INTO `wfh2db`.`meeting`
(`meetID`,`meetingDate`,`beginTime`,`endTime`,`meetingAgenda`,`projectID`)
VALUES
('MT01','2022-07-05','13:30:00','14:00:00','Sales strategy', 'PR01'),
('MT02','2022-07-05','12:00:00','13:45:00','Walmart project initiation', 'RT03'),
('MT03','2022-07-05','13:00:00','15:00:00','Internal meet','Int'),
('MT04','2022-07-06','11:30:00','12:00:00','Amazon project initiation','TC02'),
('MT05','2022-07-06','13:30:00','14:30:00','Walmart status update','RT03'),
('MT06','2022-07-07','11:00:00','12:00:00','Ebay project initiation','DG04'),
('MT07','2022-07-07','15:00:00','16:30:00','North Sales update','PR01'),
('MT08','2022-07-07','13:00:00','14:00:00','Internal meet','Int'),
('MT09','2022-07-07','16:00:00','18:00:00','Walmart Project closing','RT03'),
('MT10','2022-07-08','13:00:00','14:00:00','Amazon project closing','TC02'),
('MT11','2022-07-08','16:00:00','18:00:00','Ebay sales updates','DG04'),
('MT12','2022-07-08','15:30:00','17:30:00','Sales strategy update','PR01');



INSERT INTO `wfh2db`.`meeting_attendance`
(`meetID`,`employeeID`)
VALUES
('MT01',1003),
('MT01',1006),
('MT01',1010),
('MT01',1005),
('MT02',1002),
('MT02',1008),
('MT02',1007),
('MT02',1005),
('MT03',1009),
('MT03',1010),
('MT04',1001),
('MT04',1002),
('MT04',1007),
('MT04',1008),
('MT04',1009),
('MT05',1002),
('MT05',1007),
('MT05',1005),
('MT06',1009),
('MT06',1001),
('MT06',1004),
('MT06',1007),
('MT06',1003),
('MT06',1006),
('MT06',1010),
('MT07',1010),
('MT07',1006),
('MT07',1003),
('MT08',1005),
('MT08',1009),
('MT09',1002),
('MT09',1008),
('MT09',1007),
('MT09',1005),
('MT10',1001),
('MT10',1002),
('MT10',1004),
('MT10',1007),
('MT10',1008),
('MT10',1009), 
('MT11',1001),
('MT11',1004),
('MT11',1007),
('MT11',1006),
('MT11',1009),
('MT12',1010),
('MT12',1005),
('MT12',1003);


INSERT INTO `wfh2db`.`project_team`
(`projectID`,`employeeID`)
VALUES
('PR01',1003), 
('PR01',1006), 
('PR01',1010), 
('PR01',1005), 
('TC02',1001),
('TC02',1002),
('TC02',1004),
('TC02',1007),
('TC02',1008),
('TC02',1009), 
('RT03',1002),
('RT03',1008),
('RT03',1007),
('RT03',1005),
('DG04',1001),
('DG04',1004),
('DG04',1007),
('DG04',1003),
('DG04',1006),
('DG04',1010),
('DG04',1009);



INSERT INTO section_codes
(codes, sectionID, projectID)
VALUES
('3faf6', 01, 'RT03'),
('347q8', 05, 'RT03'),
('849fj', 03, 'TC02'),
('vdif6', 02, 'TC02'), 
('vhe93', 06, 'DG04'), 
('j389f', 04, 'DG04'),
('84fji', 01, 'DG04'),
('9fjui', 02, 'DG04');




### QUERIES

USE wfh2db;

/*1. When Walmart delivered some items to the warehouse located in Chestnut Hill, 
which sections were used, what security codes were sent to the delivery staff, and how many times
has the section been accessed?*/
select distinct s.sectionID, codes, count(logID) as accessTimes from log_detail ld
inner join section s on s.sectionID = ld.sectionID
inner join warehouse w on w.warehouseID = s.warehouseID
inner join projects p on ld.projectID = p.projectID
inner join section_codes sc on sc.projectID = ld.projectID and sc.sectionID = ld.sectionID
where p.projectName like 'Walmart%'
and w.warehouseCity = 'Chestnut Hill'
group by s.sectionID, codes;
/*----------------------------------------------------------------------------------------*/

/*2. What is the capacity utilization for the warehouse at NY on 7 July 2022? */
DROP FUNCTION IF EXISTS get_warehouse_cap;
DELIMITER $$
create function get_warehouse_cap( 
warehouse_state varchar(10)
)
returns int
deterministic
begin
declare warehouse_cap int;
select sum(capacity) 
into warehouse_cap 
from section 
inner join warehouse on warehouse.warehouseID = section.warehouseID 
where warehouse.warehouseState = warehouse_state ;
return warehouse_cap;
end$$
delimiter ;

SELECT w.warehouseState, get_warehouse_cap('NY') as total_cap, sum(ld.inflowCount-ld.outflowCount) as utilization, sum(ld.inflowCount-ld.outflowCount) / get_warehouse_cap('NY') as cap_utilization
FROM warehouse w
JOIN section s ON s.warehouseID = w.warehouseID
JOIN log_detail ld ON ld.sectionID = s.sectionID
WHERE w.warehouseState = 'NY'
AND ld.logDate <= '2022-07-07'
group by w.warehouseState;
/*----------------------------------------------------------------------------------------*/

/*3. How many total iphone 13 were present in Amazon inventory as on 7 July 2022 ?*/
SELECT pd.productName,sum(ld.inflowCount-ld.outflowCount) as tot_count FROM log_detail ld
JOIN projects p ON ld.projectID = p.projectID
JOIN product pd ON pd.productID = ld.productID
WHERE p.projectName LIKE 'Amazon%'
AND pd.productName = 'iphone13'
AND ld.logDate <= '2022-07-07'
GROUP BY ld.productID;
/*----------------------------------------------------------------------------------------*/

/*4. Show the latest usage of sections located in Queens, NY. */
drop view if exists section_usage_view;
CREATE VIEW section_usage_view AS
SELECT ld.sectionID,(s.capacity+sum(ld.inflowCount)-sum(ld.outflowCount)) AS 'Usage' FROM section s
JOIN log_detail ld ON s.sectionID = ld.sectionID
GROUP BY ld.sectionID;

SELECT * FROM section_usage_view
where sectionID in 
(select section.sectionID from 
section join warehouse
on section.warehouseID = warehouse.warehouseID
where warehouseCity = 'Queens' and 
warehouseState = 'NY');
/*----------------------------------------------------------------------------------------*/

/*5. How many employees, who were part of the project team, were absent from 
"project closing" meeting held between 7 July-8 July ? */
SELECT m.projectID,count(e.employeeID) NOT IN 
(SELECT count(employeeID) FROM project_team
WHERE projectID IN (SELECT projectID FROM meeting
WHERE meetingAgenda LIKE '%project closing')
GROUP BY projectID) as No_of_Emp_Not_Attended_Meeting FROM employee e
JOIN project_team pt ON pt.employeeID = e.employeeID
JOIN meeting m ON m.projectID = pt.projectID
WHERE m.meetingAgenda LIKE '%project closing'
AND m.meetingDate BETWEEN '2022-07-07' AND '2022-07-08'
GROUP BY m.meetID;
 /*----------------------------------------------------------------------------------------*/
 
 /*6. Between 4 Jul 2022 - 8 Jul 2022, how many internal meetings were held with non-administrative 
employees attending ? */
SELECT m.meetingDate, count(m.meetID) as count 
FROM meeting as m INNER JOIN meeting_attendance as ma
ON m.meetID = ma.meetID
INNER JOIN employee as e
ON ma.employeeID = e.employeeID
INNER JOIN department as d ON e.departmentID = d.departmentID
WHERE m.meetingAgenda = "Internal meet"
AND d.departmentName NOT LIKE 'Administration%'
AND meetingDate BETWEEN '2022-07-04' AND '2022-07-08'
GROUP BY m.meetingDate;
/*----------------------------------------------------------------------------------------*/ 

/*7. On 7 July 2022 which employees did not log in even 
though they had a project meeting that day? */
SELECT distinct ma.employeeID FROM meeting_attendance ma
JOIN meeting m ON m.meetID = ma.meetID
where m.meetingDate = '2022-07-07'
and ma.employeeID Not IN (SELECT r.employeeID FROM remotedesk r
WHERE r.remoteDate = '2022-07-07');
/*----------------------------------------------------------------------------------------*/

/*8. Between 5 July 2022 - 8 July 2022 how many employees logged 
in half day (after 12PM) in order to attend a meeting ?*/
SELECT count(distinct rd.employeeID) AS emp_count FROM remotedesk rd
join meeting_attendance ma on ma.employeeID = rd.employeeID
join meeting m on m.meetID = ma.meetID and m.meetingDate = rd.remoteDate
WHERE remoteDate BETWEEN '2022-07-05' AND '2022-07-08'	
AND logIn > '12:00:00';
/*----------------------------------------------------------------------------------------*/

/*9. Are there any abnormal logins? If so, list the employee ID, the login time, and the abnormal IP address.*/
/*Trigger*/
DROP TRIGGER IF EXISTS ip_warning;
DELIMITER $$
    CREATE TRIGGER ip_warning after insert on remoteDesk
    FOR EACH ROW 
    BEGIN
      IF (strcmp(trim(trailing SUBSTRING_INDEX(NEW.instantIP, '.', -1) from NEW.instantIP), 
      trim(trailing SUBSTRING_INDEX((select ip1 from employee where new.employeeID = employeeID), '.', -1) from (select ip1 from employee where new.employeeID = employeeID))) != 0)
      THEN
            insert into remoteDeskWarning (remoteID, warning)
            values (new.remoteID, 1);
      END IF;
    END$$
DELIMITER ;

select employeeID, remoteDate, logIn, logOut, instantIP from remoteDesk as rd
right join remoteDeskWarning as rdw
on rd.remoteID = rdw.remoteID;
/*----------------------------------------------------------------------------------------*/

/*10. As a small firm looking to raise funds, our client cares about the social impact. 
Hence they want to know how many days on average did the female 
department heads logged in versus male department heads between 6 July 2022 - 7 July 2022?*/
DROP FUNCTION IF EXISTS get_dept_head;
DELIMITER $$
CREATE FUNCTION get_dept_head( 
emp_ID int,
gender char
)
RETURNS int
DETERMINISTIC
BEGIN
DECLARE emp_Count int;
SELECT count(employeeID) INTO emp_Count
FROM manager m
JOIN employee e ON e.employeeID = m.managerID
WHERE e.employeeGender = gender
GROUP BY e.employeeGender;
RETURN emp_Count;
END$$
DELIMITER ;
/*SP*/
DROP PROCEDURE IF EXISTS dept_head_log;
DELIMITER //
CREATE PROCEDURE dept_head_log()
BEGIN
select distinct (count(employeeID)/get_dept_head(employeeID,'F')) as avg_wo_days,
(count(employeeID)/get_dept_head(employeeID,'M')) as avg_man_days
FROM remotedesk
WHERE employeeID IN (SELECT managerID FROM manager)
AND remotedate BETWEEN '2022-07-06' AND '2022-07-07'
GROUP BY employeeID;
END //
DELIMITER ;
/*Call SP*/
CALL dept_head_log();
/*----------------------------------------------------------------------------------------*/

/*11.List non-white employees who worked overtime (post 5PM) between 4 Jul 2022 - 8 July 2022? */
SELECT e.employeeFirstName, e.employeeLastName, e.employeeEthnicity, rd.remoteDate, rd.logOut 
FROM employee as e INNER JOIN remotedesk as rd 
ON e.employeeID = rd.employeeID
WHERE (remoteDate BETWEEN "2022-07-04" AND "2022-07-08") AND (logOut  > '17:00:00') AND 
(employeeEthnicity != 'White');
/*----------------------------------------------------------------------------------------*/





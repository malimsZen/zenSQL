-- CREATE TABLE table_name (
column1_name column1_data_type,
column2_name column2_data_type,
. . .
columnN_name columnN_data_type
);


CREATE TABLE faveParks(
    parkName VARCHAR(30),
    yearBuilt INT,
    firstVisit DATE,
    lastVisit DATE
);

CREATE Table parkInfo AS (
    SELECT parkName, yearBuilt
    FROM faveParks
);

-- If you're creating a table that already exists, an error is caused. 
-- To avoid this erro, you can include the IF NOT EXISTS option in your
-- CREATE TABLE command.This will tell the database to check whether a 
-- a DB with the specified name already existts and, if so, to isse a 
-- warning instead og an error.

CREATE TABLE IF NOT EXISTS parkInfo (
name varchar(30),
squareFootage int,
designer varchar(30)
);

-- IF NOT EXISTS is useful more so when running transactions; an error will CREATE
-- cause the entire transaction to fail, while a warning will mean only the statement 
-- that caused it will fail. 

-- Altering Tables 
-- There are times when you may need to change a table’s definition. This is different
-- from updating the data within the table; instead, it involves changing the structure 
-- of the table itself. 

-- ALTER TABLE table_name ALTER_OPTION sub_options . . . ;

ALTER Table faveParks RENAME to faveNYCParks;
-- ALTER TABLE faveNYCParks DROP COLUMN borough;

-- The following example uses MySQL’s MODIFY COLUMN clause, changing the yearBuilt column 
-- to use the smallint data type rather than the original int type:

ALTER Table favenycparks MODIFY COLUMN yearBuilt SMALLINT;


-- DELETING TABLES 
-- To delete a table and all of its data, use the DROP TABLE syntax:

-- You can delete multiple tables with a single DROP statement by 
-- separating their names with a comma and a space, like this:
-- DROP TABLE table1, table2, table3;

-- Note that this example includes the IF EXISTS option. This has
-- the opposite function of the IF NOT EXISTS option available for 
-- CREATE TABLE. In this context, IF EXISTS will cause the DROP TABLE 
-- statement to return a warning instead of an error message if one of 
-- the specified tables doesn’t exist.

-- You can delete multiple tables with a single DROP statement by 
-- separating their names with a comma and a space, like this:
-- DROP TABLE table1, table2, table3;

-- **** CONSTRAINTS **** 


CREATE DATABASE constraintsDB;
USE constraintsDB;

CREATE Table employeeinfo
(
    empId int UNIQUE,
    empName VARCHAR(30),
    empPhoneNum int
);

-- This statemennt defines the UNIQUE constraint immediately after 
-- the empID column, meaning that the constraint applies only to that
-- column. 

--  If you were to try adding any data to this table, the DBMS will check
-- the existing contents of only the empId to ensure that any new values you
-- add to empId are in fact unique. This is what’s referred to as a colum-level constraint.

CREATE Table racerInfo
(
    racerId int,
    finish int,
    racerName varchar(30),
    check(finish > 0)
);
-- Below the column definitions, it also applies a CHECK constraint to finish 
-- column to ensure that every racer has a finish greater than or equal to 1
-- (since no racer can place below first place)

-- Because the constraint is applied outside of any individual column definition, 
-- you need to specify the name of the columns you want the constraint to apply to 
-- in parentheses. Any time you specify a constraint outside of the definition of a
-- single column, it’s known as a table-level constraint. Column-level constraints 
-- only apply to individual columns, but table constraints like this can apply to or
--  reference multiple columns.

-- *** Naming  Constraints ***.  
-- Whenever you define a constraint, your RDBMS generates a name for it automaticlly.  
-- This name is used to reference the constraint in error messages in commands used to   
-- manage constraints. 

CREATE Table newRacersInfo 
(
    racerId int,
    finish int,
    racerName VARCHAR(30),
    constraint noNegativeFinish
    check (finish >= 1)
);

-- To name a constraint, precede the constraint type with CONSTRAINT keyword foloowed by 
-- the name of your choice. This example statement recreates the racerInfo table, renaming
-- it to newRacerInfo and adding noNegativeFinish as the name for the CHECK constraint.

-- MySQL includes the SHOW CREATE TABLE statement, which returns the entire CREATE TABLE 
-- statement that created the named table:
-- SHOW CREATE TABLE table_name;


-- Managing constraints  
-- In MySQL, you can add constraint to exosting tables as well as delete them with ALTER TABLE statements. 
-- For example, the following command adds a UNIQUE constraint to the empName column in the  employeeInfo
-- table created previously:

USE constraintsDB;
ALTER Table employeeInfo ADD unique (empName);
-- When adding a constraint to an existing table, you can also use the CONSTRAINT keyword to provide a name 
-- identify the constraint. The example below adds a UNIQUE constraint names uID to the racerID column from 
-- the racerInfo table. 


use Zen;
ALTER Table racerinfo add constraint uID unique (racerID);
-- If, before adding a constraint like this, you inserted any records that would violate the condition of the 
-- new constraint, the ALTER TABLE statement will fail. 

-- To delete a constraint, use the DROP CONSTRAINT syntax followed bu the name of the constraint you want to  
-- delete. This command deletes the racersPK constraint created in the previous command: 
-- ALTER TABLE racersInfo DROP CONSTRAINT uID;


-- **** How To Insert Data in SQL  
-- You can specify individual rows of data with the VALUES keyword, copy the entire set of data from existing tables 
-- with select queries, as well as define colums in ways that will cause SQL to insert data into them automatically. 

CREATE DATABASE insertDB;
use insertDB;

CREATE Table factEmployee
(
    name VARCHAR(30),
    position VARCHAR(30),
    department VARCHAR(20),
    hourlyWage DECIMAL(4,2),
    startDate DATE

);

-- *** Inserting Data Manually ***
-- The general syntax for insertign data in SQL looks like this: 
--INSERT INTO table_name
--(column1, column2, . . . columnN)
--VALUES
--(value1, value2, . . . valueN);

use insertDB;
INSERT into factEmployee
(name,position, department, hourlyWage, startDate)
VALUES
('Agnes','thingamajig foreman','management',26.50,'2022-05-19');


-- The order in which you list the colums does not matter. It's
-- important to remember that the order of the values you supply
-- aligns with the order of the columns. 

insert into factEmployee
(department, hourlyWage,startDate,name,position)
VALUES
('production',15.59,'2018-04-28','Jim','widget tightener');

-- If you don't align the values correctly, SQL may enter your
-- data into the wrong columns. Additionally, it will cause an 
-- errror if any of the values conflict with the column's data
-- type. 

-- Be aware that while you must provide a value for everly column
-- you specify, you aren't necessarily required to specify every
-- column in a table when adding a new row of data. As long as none 
-- of the columns you omit have a constraint that would cause an 
-- error in this case (SUCH as NOT NULL), MySQL will add NULL to 
-- any unspecified columns.ADD

-- If you plan to enter a row with valies for every column in the 
-- table, you don't need to include the column names at all. Keep
-- in mind that the VALUes you enter must still align with the order
-- the columns were defined in the table's definition. 

INSERT INTO factemployee
VALUES
('Marie','doodad welder','production',27.88,'2018-03-29');

-- You can also add multiple records at once by separating each
-- row with a comma, like this:

INSERT INTO factemployee
VALUES
('Giles','gizmo inspector','quality assurance',26.50,'2019-08-06'),
('Daphne','gizmo presser','production',32.45,'2017-11-12'),
('Joan','whatzit analyst','quality assurance',29.30,'2017-04-29');




-- Copying Data with SELECT Statements
-- Rather than specifying data row by row, you can copy multiple
-- rows of data from one table and insert them into another with 
-- a select query. 

-- INSERT INTO table_A (col_A1, col_A2, col_A3)
-- SELECT col_B1, col_B2, col_B3
-- FROM table_B;

-- Instead of following the column list with the values keyword,
-- this example syntax follows it with a SELECT statement. The SELECT
-- statement in this example syntax only includes the FROM clause, but 
-- any valid query can work.

CREATE Table showroomEmployees
(
    name VARCHAR(30),
    hourWage DECIMAL(4,2),
    startDate DATE
);

-- Now I can load this new table with some data from the factEmployees
-- table created previously by including a SELECT query in the INSER INTO
-- statement. 

-- If the SELECT query returns the same number of columns in the same order 
-- as the target table's columns, and they also have compatible matching data
-- types, you can omit the column list from an INSERT INTO statement.

INSERT INTO showroomEmployees
SELECT
factEmployee.name,
factEmployee.hourlyWage,
factEmployee.startDate
FROM factEmployee
WHERE name = 'Agnes';

-- When you specify a table name when referring to a column like this, it's known
-- as a fully qualified column reference. This isn't necessary in this particular 
-- case. In fact, the following example INSERT INTO statement would produce the 
-- same result as the previous one:

-- INSERT INTO showroomEmployees
-- SELECT
-- name,
-- hourlyWage,
-- startDate
-- FROM factoryEmployees
-- WHERE name = 'Agnes';

-- Not only can fully qualified column references be used fro clarity, but doing so can 
-- be a good habit to practice. Not only can they help to make your SQL 
-- easier to understand and troubleshoot, fully qualified column references become 
-- necessary in certain operations that refer to more than one table, such as queries 
-- that include JOIN clauses.


-- You can insert multiple rows of data with any query that will return more than one 
-- row from the source table. For example, the query in the following statement will return 
-- every record in the factEmployee database in which the value in the name column does not 
-- start with J:

INSERT into showroomemployees
SELECT
factEmployee.name,
factEmployee.hourlyWage,
factEmployee.startDate
FROM factemployee
WHERE name NOT LIKE 'J%';


-- Notice that there are two identical rows with Agnes in the name column. Every time you run an 
-- INSERT INTO statement that uses SELECT, SQL treats the results from the query as a new set of data.
-- Unless you impose certain constraints on your table or develop more granular queries, there’s nothing
-- to prevent your database from being loaded with duplicate records when adding data like this.


-- *** Inserting Data Automatically ***
-- When creating a table, you can apply certain attributes to columns that will cause the RDBMS to 
-- populate them with data automatically.

-- To illustrate, run the following statement to define a table named interns. This will create a table
-- named interns that has three columns. The first column in this example, internID, holds data of the int
-- type. Notice, though, that it also includes the AUTO_INCREMENT attribute. This attribute will cause SQL 
-- to automatically generate a unique numeric value for every new row, starting with 1 by default and then 
--incrementing up by one with each subsequent record.

-- Similarly, the second column, department, includes the DEFAULT keyword. This will cause the RDBMS to insert
--  the default value — 'production' in this example — automatically if you omit department from an INSERT INTO 
--statement’s column list. 

CREATE TABLE interns (
internID int AUTO_INCREMENT PRIMARY KEY,
department varchar(20) DEFAULT 'production',
name varchar(30)
);

-- To demonstrate these features, load the interns table with some data by running the following INSERT INTO statement. 
-- This operation only specifies values for the name column:

INSERT INTO interns (name) VALUES ('Pierre'), ('Sheila'), ('Francois');

-- To add a value other than the default to the department column you would need to specify that column in the INSERT INTO
-- statement, like this:

INSERT INTO interns (name, department)
VALUES
('Jacques', 'management'),
('Max', 'quality assurance'),
('Edith', 'management'),
('Daniel', DEFAULT);

-- Notice that the last row of values provided in this example includes the DEFAULT keyword instead of a string value. 
-- This will cause the database to insert the default value ('production').


-- *** How To Update Data in SQL ***
-- SQL provides the UPDATE keyword which allows users to change existing data in a table.

-- I'm about to learn how to use SQL's update syntax to change data in one or mor tables.
-- It also explains how SQL handles UPDATE operations that conflict with foreign key constraints.

create database updateDB;
use updateDB;


-- For the example used, imagine that you run a talent agency and have decided to begin tracking 
-- your clients and their performances in an SQL database. You plan to start off with two tables, 
-- the first of which will store information about your clients:
CREATE Table clients
(
    clientID int PRIMARY KEY,
    name VARCHAR(20),
    routine VARCHAR(30),
    performanceFee DECIMAL(5,2)
);

-- The second Table will store information about your client's performances at a local venue.

CREATE Table shows
(
    showID int PRIMARY KEY,
    showDate DATE,
    clientID int,
    attendance int,
    ticketPrice DECIMAL(4,2),
    constraint client_fk
    FOREIGN KEY (clientID)
    REFERENCES clients (clientID)
);

-- To ensure that the clientID column only holds values that represent valid client ID numbers,
-- you decide to apply a foreign key constraint to the clientID column that references the clients
-- table’s clientID column. A foreign key constraint is a way to express a relationship between two 
-- tables by requiring that values in the column on which it applies must already exist in the column 
-- that it references. In the following example, the FOREIGN KEY constraint requires that any value
-- added to the clientID column in the shows table must already exist in the client table’s clientID column.


-- to load the clients table with five rows of sample data:
INSERT INTO clients
VALUES
(1, 'Gladys', 'song and dance', 180),
(2, 'Catherine', 'standup', 99.99),
(3, 'Georgeanna', 'standup', 45),
(4, 'Wanda', 'song and dance', 200),
(5, 'Ann', 'trained squirrel', 79.99);

-- Load the shows table with ten rows of sample data:
INSERT INTO shows
VALUES
(1, '2019-12-25', 4, 124, 15),
(2, '2020-01-11', 5, 84, 29.50),
(3, '2020-01-17', 3, 170, 12.99),
(4, '2020-01-31', 5, 234, 14.99),
(5, '2020-02-08', 1, 86, 25),
(6, '2020-02-14', 3, 102, 39.5),
(7, '2020-02-15', 2, 101, 26.50),
(8, '2020-02-27', 2, 186, 19.99),
(9, '2020-03-06', 4, 202, 30),
(10, '2020-03-07', 5, 250, 8.99);


-- *** Updating Data in a Single Table ***
-- The general syntax of an UPDATE statement looks like this:

-- UPDATE table_name
-- SET column_name = value_expression
-- WHERE conditions_apply;


-- Following the UPDATE keyword is the name of the table 
-- storing the data you want to update. After that is a SET 
-- clause which specifies which column’s data should be updated 
-- and how. Think of the SET clause as setting values in the 
-- specified column as equal to whatever value expression you provide.

-- You must  include at least one value assignment in every UPDATE
-- statement, but you can include more than one to update data in multiple columns.

-- After the SET clause is a WHERE clause. Including a WHERE clause 
-- in an UPDATE statement like in this example syntax allows you to filter 
--out any rows that you don’t want to update. A WHERE clause is entirely 
-- optional in UPDATE statements, but if you don’t include one the operation
-- will update every row in the table

-- Say for example. that you notice Katherine's name is misspelled - 
-- it should begin with a  "K" but in the table it begins with a "C" - 
-- so you decide to change that value by running an update statement.

UPDATE clients
SET name = 'Katherine'
WHERE name = 'Katherin';

UPDATE clients
set performanceFee = 140
WHERE routine LIKE 'S%';


-- If any columns in your table hold numeric values, you can update them using an 
-- arithmetic operation in the SET clause. Say that youu also negotaite a forty percent 
-- increase for each of your clients' performance fees. To reflec this in the clients table, 
-- you could run an update operation like this:

UPDATE clients
SET performanceFee = performanceFee * 1.4;


-- As mentioned previously, you can also update data in multiple columns with a single UPDATE statement. 
-- To do this, you must specify every column you want to update, following each with the respective value
-- expression, and then separate each column and value expression pair with a comma.

-- To reflect the actual numbers and prices, you update the table to add twenty attendees to each of their
-- performances and increase each of their ticketPrice values by fifty percent.


-- To reflect the actual numbers and prices, you update the table to add twenty attendees to each of their
-- performances and increase each of their ticketPrice value by fifty percent.

UPDATE shows
SET attendance = attendance + 20,
ticketPrice = ticketPrice * 1.5
WHERE clientID IN 
(SELECT clientID
FROM clients
WHERE name = 'Georgeanna' OR name = 'Wanda');

-- Oftentimes, abstract values like identification numbers can be hard to remember, but this method of using a 
-- subquery to find a  value can be helpful when you only know certain attributes about the records in question.



-- ***Using JOIN Clauses to Update Data in Multiple Tables***
-- SQL Implementations allow you to update multiple columns in multiple multiple tables by temporarily combining 
-- the tables with a JOIN clause. ADD

-- Here's the general syntax you can use to update multiple tables with a JOIN clause:
-- UPDATE table_1 JOIN table_2
-- ON table_1.related_column = table_2.related_column    ON cluse describes how the query should join the two tables together.
-- SET table_1.column_name = value_expression,
-- table_2.column_name = value_expression
-- WHERE conditions_apply;

-- In most implementations, you can join tables by finding matches between any set of columns that have what the 
-- SQL standard refers to as “JOIN eligible” data types. This means that, in general, you can join any column holding 
-- numeric data with any other column that holds numeric data, regardless of their respective data types. Likewise,
--  you can join any columns that hold character values with any other column holding character data.

UPDATE clients JOIN shows
USING (clientID)
SET clients.routine = 'mine',
shows.ticketPrice = 30
WHERE name = 'Gladys';

-- This will join the clients and shows tables on their respective clientID colums, and then update the routine and ticketPrice 
-- values for Glady's recprd in the clients tables and each of her performances listed in the shows table.

-- This  updates joins the tables with the USING keyword instead of the ON keyword. This is possible because both tables 
-- have a clientID column that share a similar data type.



-- **** Changing Foreign Key UPDATE Behavior ****
-- By default, any UPDATE statement that would cause a conflict with a FOREIGN KEY constraint will fail.
-- If you attempt to update the primary key value of a record in the parent table that also appears in the foreign key column in 
-- the child table, it will cause an error.
-- You can avoid this erro by replacing the existing foreign key constraint with one that treats update operations differently.
-- To replace the current constrinat, you must first remove it with an ALTER TABLE statement. 

-- Following that, create a new foreign key constraint that conigureed to treate UPDATE operations in a way that makes sense for 
-- the given use cas.

-- ON UPDATE SET NULL: This option will allow you to update records from the parent tabes, and will reset any values in the child 
-- tabes that reference them as NULL.
-- ON UPDATE CASCADE: When you update a row in the parent table, this option will cause SQL to automaticaly update any records that 
-- reference it in the child table so that they align with the new value in the parent table.ADD
-- To add a FOREIGN KEY constraint that follows the ON UPDATE CASCADE behavior, run the following  ALTER TABLE statement.


ALTER Table shows
ADD constraint new_client_fk
FOREIGN key (clientID)
References clients (clientID)
ON UPDATE CASCADE;


-- Instead of altering a table's definition to change how a foreign key handles UPDATE operations, you can define this behavior 
-- from the start in the CREATE TABLE statement like this:

DROP table shows;

CREATE TABLE shows
(showID int PRIMARY KEY,
showDate date,
clientID int,
attendance int,
ticketPrice decimal (4,2),
CONSTRAINT client_fk
FOREIGN KEY (clientID)
REFERENCES clients(clientID)
ON UPDATE CASCADE
);

-- Following that, I'm able to update the clientID calue of any record in the clients table, and those changes will cascase down 
-- to any rows in the shows tables that reference it:

UPDATE clients
SET clientID = 9
WHERE name = 'Ann';


create database deletedb;

use deletedb;
-- As an example, imaine that you and some of your friends started a club  in which  members can share music equipment with one another.
-- To help you keep track of club members and their equipment, you decide to create a couple of tables. 

CREATE Table clubMembers
(
    memberID INT PRIMARY KEY,
    name VARCHAR(30),
    homeBorough varchar(15),
    email VARCHAR(30)
);


CREATE TABLE clubEquipment
(
    equipmentID INT PRIMARY KEY,
    equipmentType VARCHAR(30),
    brand VARCHAR(30),
    ownerID INT,
    constraint fk_ownerID 
    FOREIGN KEY (ownerID) REFERENCES clubMembers(memberID)
);


-- when creating a foreign key constraint, make it a single statemen. Starting with the CONSTRAINT name, FOREIGN KEY (column) REFERENCES(COLUMN or PRIMARY KEY)
-- This example gives a name for the foreign key constraint, fk_ownerID.

-- Loading clubMembers table with six rows of sample data:

INSERT INTO clubMembers
VALUES
(1, 'Rosetta', 'Manhattan', 'hightower@example.com'),
(2, 'Linda', 'Staten Island', 'lyndell@example.com'),
(3, 'Labi', 'Brooklyn', 'siffre@example.com'),
(4, 'Bettye', 'Queens', 'lavette@example.com'),
(5, 'Phoebe', 'Bronx', 'snow@example.com'),
(6, 'Mariya', 'Brooklyn', 'takeuchi@example.com');

-- Loading the clubEquipment table with twenty rows of sample data:

INSERT INTO clubEquipment
VALUES
(1, 'electric guitar', 'Gilled', 6),
(2, 'trumpet', 'Yemehe', 5),
(3, 'drum kit', 'Purl', 3),
(4, 'mixer', 'Bearinger', 3),
(5, 'microphone', 'Sure', 1),
(6, 'bass guitar', 'Fandar', 4),
(7, 'acoustic guitar', 'Marten', 6),
(8, 'synthesizer', 'Korgi', 4),
(9, 'guitar amplifier', 'Vax', 4),
(10, 'keytar', 'Poland', 3),
(11, 'acoustic/electric bass', 'Pepiphone', 2),
(12, 'trombone', 'Cann', 2),
(13, 'mandolin', 'Rouge', 1),
(14, 'electric guitar', 'Vax', 6),
(15, 'accordion', 'Nonher', 5),
(16, 'electric organ', 'Spammond', 1),
(17, 'bass guitar', 'Peabey', 1),
(18, 'guitar amplifier', 'Fandar', 3),
(19, 'cello', 'Yemehe', 2),
(20, 'PA system', 'Mockville', 5);

-- The general syntax for deleting data in SQL is:
-- DELETE FROM table_name
-- WHERE conditions_apply;

-- The important part of this syntax is the WHERE clause, as this is what allows you to specify exactly what rows of data should get deleted. Without it, 
-- a command like DELETE FROM table_name; would execute correctly, but it would detele every row of data from the table. 
-- One way to help make sure you don't accidentally delete the wrong data is to first issue a SELECT query to see what data wil get returned by a DELETE  
-- operations WHERE clause. 
-- Note that unlike a SELECT query or an INSERT INTO operation, DELETE operations do not allow you to specify individual columns, as they're intended to 
-- delete entire rows of data. 


SELECT * FROM clubEquipment
WHERE brand = 'Korgi';

-- To delete this row you would run a DELETE operation that has from and WHERE clauses identical to the previous select statement:

DELETE FROM clubEquipment
WHERE brand = 'Korgi';


SELECT * FROM clubequipment
WHERE equipmentType LIKE '%electric%';


DELETE FROM clubequipment
WHERE equipmentType LIKE '%electric%'

-- You can also use subqueries to return and delete ore granular result sets. A subquery is a complete query operation - meaning, 
-- an SQL statement that starts with SELECT and includes a FROM clause - embedded within another operation, following the sorrounding 
-- operation's own FROM clause. 


SELECT * FROM clubequipment
WHERE ownerID IN 
(SELECT memberID FROM clubmembers
WHERE name LIKE 'L%');

--  I could then remove the data with the following DELETE statement:
DELETE FROM clubequipment
WHERE ownerID IN
(SELECT memberID FROM clubmembers
WHERE name LIKE '%L');

----- **** Deketing Data from Multiple Tables ------


-- You can delete from more than one table in a single operation by including a JOIN clause.
-- JOIN clauses are used to combine rows from two or more tables into a single query result. They do this by finding a related column 
-- between the tables and sorting the results appropriately in the output. 

-- The syntax for a delete operation that includes a JOIN clause looks like this:

-- DELETE table_1, table_2
-- FROM table_1 JOIN table_2
-- ON table_2.related_column = table_1.related_column
-- WHERE conditions_apply;

-- Note that because JOIN clauses compare the contents of more than one table, this example syntax specifies which table to select each 
-- column from by preceding the name of the column with the name of the table and a period. (known as fukky quakified column reference)

-- Say your club decided to limit what brands of muscical equipment members can share. Create a table named prohibitedBrands in which you 
-- will list whatbrands are no longer acceptable for the club. 

CREATE Table prohibitedBrands 
(
    brandName VARCHAR(30),
    homeCountry VARCHAR(30)
);


INSERT INTO prohibitedBrands
VALUES 
('Fandar', 'USA'),
('Givson', 'USA'),
('Muug', 'USA'),
('Peabey', 'USA'),
('Yemehe', 'Japan');

-- The club decides to delete any records of quipment from the clubEquipment table whose brands appear in the prohibitedBrands table and 
-- are based in the United States. 

SELECT *
FROM clubEquipment JOIN prohibitedBrands
on clubEquipment.brand = prohibitedBrands.brandName
WHERE homeCountry = 'USA';

-- To delete the brands from thr prohibited table and the associated equipment from clubEquipment.

DELETE clubEquipment, prohibitedBrands
FROM clubEquipment JOIN prohibitedBrands
ON clubEquipment.brand = prohibitedBrands.brandName
WHERE homeCountry = 'USA';



--- ***** Changing Foreign Key DELETE Behaviour ***** -----
-- By default, any DELETE statement that would cause a conflict with a foreign key will fail. 

-- To replace the current constraint, you must first remove it with an ALTER TABLE statement. 
ALTER Table clubequipment
DROP Foreign key fk_ownerID;

-- Following that, I'll create a new foreign key constraint that's configured to treate DELETE operations in a way that makes sense for
-- the given use case.
--  Aside from the default setting which prohibits DELETE statements that violate the foreign key, there are two other options available on most RDBMSs:

-- ON DELETE SET NULL: This option will allow you to delete records from the parent table, and will reset any values in the child table that reference them as NULL.
-- ON DELETE CASCADE: When you delete a row in the parent table, this option will cause SQL to automatically delete any records that reference it in the child table.

ALTER Table clubequipment
ADD CONSTRAINT newfk_ownerID
FOREIGN KEY (ownerID)
REFERENCE clubmembers(memberID)
ON DELETE CASCADE;

--  Instead of altering a table’s definition to change how a foreign key handles DELETE operations, you can define this behavior from the start in the CREATE TABLE statement.



---- **** How to SELECT Rows FROM Tables in SQL **** ----
-- In RDMS, any operation used to retrieve information from a table is referred to as a query.

-- Crearing a new database; queries_db.

CREATE DATABASE queries_db;

use queries_db;

-- To follow along with the examples used in this guide, imagine that you run a public parks cleanup initiative in New York City. The program is made up of volunteers who 
-- commit to cleaning up a city park near their homes by regularly picking up litter. Upon joining the initiative, these volunteers each set a goal of how many trash bags of 
-- litter they’d like to pick up each week. You decide to store information about the volunteers’ goals in an SQL database with a table that has five columns:


CREATE Table volunteers
(
    vol_id int PRIMARY KEY UNIQUE,
    name VARCHAR(20),
    park VARCHAR(20),
    weekly_goal int,
    max_bags int
);

-- Then load the volunteers table with some sample data.
INSERT INTO volunteers
VALUES
(1, 'Gladys', 'Prospect Park', 3, 5),
(2, 'Catherine', 'Central Park', 2, 2),
(3, 'Georgeanna', 'Central Park', 2, 1),
(4, 'Wanda', 'Van Cortland Park', 1, 1),
(5, 'Ann', 'Prospect Park', 2, 7),
(6, 'Juanita', 'Riverside Park', 1, 4),
(7, 'Georgia', 'Prospect Park', 1, 3);


--- *** Required Query Componenets: the SELECT and FROM Clauses **** ---
-- Here's the general syntax of an SQL query:

--SELECT columns_to_return
-- FROM table_to_query;

-- At a minimum, SQL queries one require you to include two calusesL the SELECT and FROM clauses.

-- Every SQL query begins with a SELECT clause, leading some to refer to queries generally as SELECT statements.
-- After the SELECT keyword comes a list of whatever columns you want returned in the result set. These columns 
-- are drawn from the table specified in the FROM clause.

--In SQL queries, the order of execution begins with the FROM clause. This can be confusing since the SELECT clause
-- is written before the FROM clause, but keep in mind that the RDBMS must first know the full working data set to be
-- queried before it starts retrieving information from it. It can be helpful to think of queries as SELECT-ing the 
-- specified columns FROM the specified table. Lastly, it’s important to note that every SQL statement must end with a semicolon (;).

SELECT name
FROM volunteers;

-- You can retrieve information from mulitple columns by separating each one's with a comma.

SELECT park, name, vol_id
from volunteers;
-- SQL databses will generally return columns in whatever order they're listed in the SELECT clause.

-- When selecting everything at the table, use asterisk (*). It's the shorthand for "every column."

SELECT *
FROM volunteers;

-- I can retrieve information from multiple tables in the same query with the JOIN keyword.ADD

---- **** Removing Duplicate Values with DISTINCT **** -----
-- There may be times, though, when you only want to know what unique values  are held in the colummn. You can issue queries that remove duplicate calues by following SELECT with the DISTINCT keyword.
-- The following query will return every unique value in the parks column, removing any duplicates. 

SELECT DISTINCT park
FROM volunteers;

-- Note that SQL treats every row of a result as an individual record, and DISTINCT will only eliminaet duplicates if multple rows share identical values in each column.

SELECT DISTINCT name, park
FROM volunteers;

-- The duplicate values in the park column — three occurrences of Prospect Park and two of Central Park — appear in this result set, even though the query included the DISTINCT keyword. 
-- Although individual columns in a result set may contain duplicate values, an entire row must be an exact duplicate of another for it to be removed by DISTINCT. In this case, 
-- every value in the name column is unique so DISTINCT doesn’t remove any rows when that column is specified in the SELECT clause.


-- *** Filtering Data with WHERE clauses ***
-- There may be times when you want to retrieve more granular information from tables in your database.

-- SELECT columns_to_return
-- FROM table_to_query
--WHERE search_condition;

-- Following the WHERE keyword in this example syntax is a search condition, which is what actually determines which rows get filtered out from the result set.
--  A search condition is a set of one or more predicates, or expressions that can evaluate one or more value expressions. In SQL, a value expression — also sometimes referred to as a scalar expression — is any expression that will return a single value. 
-- A value expression can be a literal value (like a string or numeric value), a mathematical expression, or a column name.

-- Typical WHERE syntax:
-- WHERE value expression OPERATOR value_expression


-- After the WHERE keyword, you provide a value expression followed by one of several special SQL operators used to evaluate the column’s values against the value expression (or value expressions) that comes after the operator. 
-- There are several such operators available in SQL and this guide will briefly highlight a few of them later in this section, but for illustration purposes it will focus only on one of the most commonly used operators: the equals sign (=).
-- This operator tests whether two value expressions are equivalent.

-- Predicates always return a result of either “true,” “false,” or “unknown.” When running SQL queries that contain a WHERE clause, the DBMS will apply the search condition sequentially to every row in the table defined in the FROM clause.
-- It will only return the rows for which every predicate in the search condition evaluates to “true.”


SELECT name
FROM volunteers
WHERE (2 + 2) = 4;

-- To illustrate this idea, run the following SELECT statement. This query returns values from the volunteers table’s name column. Instead of evaluating values from one of the table’s columns, however, this WHERE clause tests whether two value expressions — (2 + 2) and 4 — are equivalent:
-- Rather than comparing two literal values like this, you’ll typically use a column name as one of the value expressions in a WHERE clause’s search condition. By doing so, you’re telling the database management system to use each row’s value from that column as a value expression for that row’s iteration of the search condition.


SELECT name, max_bags
FROM volunteers
WHERE max_bags = 4;

-- *** Comparison: Comparison predicates compare one value expression with another; in queries, it's almost always the case that at least one of these value expressions is the name of a column.
-- =: tests whether the two values are equivalent
-- <>: tests whether two values are not equivalent
-- <: tests whether the first value is less than the second
-- >: tests whether the first value is greater than the second
-- <=: tests whether the first value is less than or equal to the second
-- >=: tests whether the first value is greater than or equal to the second

-- Null: Predicates that use the IS NULL operator test whether values in a given column are Null Range: Range predicates use the BETWEEN operator to test whether one value expression falls between two others Membership: 
-- This type of predicate uses the IN operator to test whether a value is a member of a given set Pattern Match: Pattern matching predicates use the LIKE operator to test whether a value matches a string pattern containing wildcard values


-- ***** Sorting Query Results with ORDER BY *****
-- Sometimes queries will return information in ways that may not be intuitive, or may not suit your particular needs. You can sort query results by appending an ORDER BY clause to the end of the query statement.
-- The general syntax of a quert with an ORDER BY clause:
-- SELECT columns_to_return
-- FROM table_to_query
--ORDER BY column_name;

SELECT name, max_bags
FROM volunteers
ORDER BY max_bags;

-- As this output indicates, the default behavior of SQL queries that include an ORDER BY clause is to sort the specified column’s values in ascending (increasing) order. 
-- You can change this behavior and sort them in descending order by appending the DESC keyword to the ORDER BY clause:

SELECT name, max_bags
FROM volunteers
ORDER BY max_bags DESC;


-- ****How To Use WHERE Clauses in SQL
-- WHERE clauses limit what rows the given operation will affect. THey do this bydefininng specific criteria, referred to as search conditions, that each row must meet in order 
-- for it to be impacted by the operation. 


CREATE DATABASE where_db;
USE where_db;

-- To follow along with the examples used in this guide, imagine that you run a golf league at a local golf course. You decide to track information about the individual performances
-- of the league’s players at the outings they attend. To do so, you decide to store the information in an SQL database.

CREATE TABLE golfers (
name varchar(20),
rounds_played int,
best int,
worst int,
average decimal (4,1),
wins int
);


INSERT INTO golfers
VALUES
('George', 22, 68, 103, 84.6, 3),
('Pat', 25, 65, 74, 68.7, 9),
('Grady', 11, 78, 118, 97.6, 0),
('Diane', 23, 70, 92, 78.8, 1),
('Calvin', NULL, 63, 76, 68.5, 7),
('Rose', NULL, 69, 84, 76.7, 4),
('Raymond', 18, 67, 92, 81.3, 1);


-- You may also notice that each golfer’s best value is less than their worst. This is because, in common golf rules, a golfer’s score is determined by the number of strokes it takes for them 
-- to get their ball into each hole in the course, with the winner being the person with the fewest total strokes. Thus, unlike most other sports, a golfer’s best score will be lower than their worst.

-- ***Filtering Data with WHERE clauses.***
-- SELECT columns_to_query
-- FROM table_to_query
-- WHERE search_condition;

--Predicates in a WHERE clause search condition can take many forms, bu they typically follow this syntax:
-- WHERE column_name OPERATOR value_expression
-- In SQL, a value expression - also sometimes reffered to as a scalle expression is any expression that will return a single value.A value expression can be either a string or numeric value.

-- **** Comparison ***
-- Comparison predicates use a comparison operator to compare one value (in queries, typically values in a specified column) with another. 
SELECT name, wins
FROM golfers
WHERE wins <> 1;
-- Tests whether two values are not equal. 


SELECT name, wins
FROM golfers
WHERE wins <= 1;
-- Tests whether the first value is less than or equal to the second.

-- ***NULL***
-- Predicates that use the IS NUL operator test whether values in a given column are Null. If so, the predicate evaluates to "true" and the row is included in the result set.

SELECT name, rounds_played
FROM golfers
WHERE rounds_played is NULL;

-- **** Range****
-- Range predicates use the BETWEEN operator to test whether the specified column values fall between two values expressions:
SELECT name, best
FROM golfers
WHERE best BETWEEN 67 AND 73;


-- ***Membership***
-- Membership predicates use the IN operator to test whether a value is a member of a given set:
SELECT name, best
FROM golfers
WHERE best IN (65,67,69,71);

-- ***Pattern Match***
-- Pattern matching predicates use the LIKE operator to test whether a value matches a string pattern that contain one or more wildcard characters,
-- also known as wildcards. SQL defines two wildcards, % and _

-- An underscore(_) represents a sinngle unkown character
SELECT name, rounds_played
FROM golfers
WHERE rounds_played LIKE '2_';


-- A percentae sign(%) represents zero or more unkown characters
SELECT name, rounds_played
FROM golfers
WHERE name LIKE 'G%';

-- **** Combining Multiple Predicates with AND and OR****
SELECT name,best, worst,average
FROM golfers
WHERE best < 70 AND worst < 96;

-- The first predicate tests whether each row’s best value is less than 70, 
-- while the second tests whether each row’s worst value is less than 96. 
-- If either test evaluates to “false” for a row, that row will not get returned in the result set.ADD

SELECT name, best, worst, average
FROM golfers
WHERE best < 70 OR worst < 96;

-- Because only one of the predicates must evaluate to “true” for a row to be returned.
-- You can include as many predicates as you’d like in a single WHERE clause as long as you combine them with the correct syntax. 
-- As your search conditions get more complex, though, it can become difficult to predict what data they will filter.

-- It’s important to note that database systems generally give precedence to AND operators. 
-- This means that any predicates separated by an AND operator (or operators in the case of more than two predicates) are treated as a single, 
-- isolated search condition that gets tested before any other predicates in a WHERE clause.

SELECT name, average, worst, rounds_played
FROM golfers 
WHERE average < 85 OR worst < 95 AND rounds_played BETWEEN 19 AND 23;

-- You can prioritize a set two or more predicates by wrapping them in parentheses. The following example is identical to the previous one, 
-- but it wraps the average < 85 and worst < 95 predicates, separated by an OR operator, in parentheses:

SELECT name, average, worst, rounds_played
FROM golfers
WHERE (average < 85 OR worst < 95) AND rounds_played BETWEEN 19 AND 23;

-- Because the first two predicates are surrounded by parentheses, the subsequent AND operator treats them as a discrete search condition that must evaluate to “true”.
-- If both of these predicates — average < 85 and worst < 95 — evaluate to “false”, then the entire search condition evaluates to “false” and the query immediately drops 
-- the row from the result set before moving on to evaluate the next one.

-- Although it isn’t always necessary to do so, it’s recommended that you always include parentheses when combining more than two predicates in a single search condition. 
-- Doing so can help make queries more readable and easier to understand.


-- **** Excluding Results with NOT ****
-- You can write queries that exclude specific rows by includinng the NOT operator in the WHERE clauses.
-- WHERE column_name NOT OPERATOR value_exoression

SELECT name
FROM golfers
WHERE name NOT LIKE 'R%';

-- Things get a little different when adding the NOT operator to IS NULL predicates.
-- In such cases you place the NOT between IS and NULL, as in the following example.

SELECT name, rounds_played
FROM golfers
WHERE rounds_played IS NOT NULL;

-- You can also place the NOT operator immediately after the WHERE keyword.
-- This is useful if you’re excluding rows based on whether they meet multiple search conditions.

SELECT name, average, best, wins
FROM golfers
WHERE NOT (average < 80 AND best < 70) OR wins = 9;

-- Take note of this result set’s second row. Pat’s average score is less than 80 and her best score is less than 70. 
-- However, her row is still included in the result set, as the NOT operator only negates the search condition wrapped in parentheses.

-- Recall that when you wrap multiple predicates separated by AND or OR in parentheses, SQL will prioritize those predicates and treat them as a single isolated search condition. 
-- Because of this, the NOT operator only excludes rows based on the first two predicates, average < 80 and best < 70. But it includes rows based on the third predicate, wins = 9.


-- You can rewrite the query to exclude rows based on the third predicate along with the first two by wrapping all three in parentheses, like this.
SELECT name, average, best, wins
FROM golfers
WHERE NOT ((average < 80 AND best < 70) OR wins = 9);

-- The reason for this error is that the NOT operator generally isn’t used with comparison operators (=, <>, <, <=, >, and >=), since you can achieve the opposite effect of one comparison operator by replacing it with another that would return the rows that the first would exclude.
-- For example, you can replace the equivalence operator (=) with the inequivalence operator (<>).




-- **** How To Use the Between and IN Operators in SQL****
-- In certain Structured Query Language (SQL) statements, WHERE clauses can be used to limit what rows the given operation will affect. They do this by defining specific criteria that each row must meet for it to be impacted, known as a search condition.
-- Search conditions are made up of one or more predicates, or special expressions that evaluate to either “true,” “false,” or “unknown,” and operations only affect those rows for which every predicate in the WHERE clause evaluates to “true.”


CREATE DATABASE between_in_db;
USE between_in_db;

-- To follow along with the examples used in this guide, imagine that you manage a company’s sales team. This company only sells three products: widgets, doodads, and gizmos. You begin tracking the number of units of each product each member of your team has sold in an SQL database. 
--You decide that this database will have one table with four columns:

CREATE TABLE sales (
name varchar(20),
widgets int,
doodads int,
gizmos int
);

-- Loading the table with sample data.
INSERT INTO sales
VALUES
('Tyler', 12, 22, 18),
('Blair', 19, 8, 13),
('Lynn', 7, 29, 3),
('Boris', 16, 16, 15),
('Lisa', 17, 2, 31),
('Maya', 5, 9, 7),
('Henry', 14, 2, 0);

-- **** Range Predicates *****
SELECT *
FROM sales
WHERE gizmos BETWEEN doodads AND widgets;


-- Be aware of the order in which you list the value expressions that define the range: the first value after the BETWEEN operator is always the lower end of the range and the second is always the upper end. The following query is identical to the previous one, 
-- except that it flips the order of the columns defining each end of the range:

SELECT *
FROM sales
WHERE gizmos BETWEEN widgets AND doodads;


SELECT name
FROM sales
WHERE name BETWEEN 'A' AND 'M';

-- Notice that this result set doesn’t include Maya even though the range provided in the search condition is from A to M. This is because, alphabetically, the letter “M” comes before any string that starts with the letter “M” and has more than one letter,
-- so Maya is excluded from this result set along with any other salespeople whose names do not lie within the given range.

-- *****Membership Predicates *****
-- Membership predicates allow you to filter query results based on whether a value is a member of a specified set of data. In WHERE clauses, they generally follow this syntax:
-- . . .
--WHERE column_name IN (set_of_data)
-- . . .

SELECT name, doodads
FROM sales
WHERE doodads IN (1, 2, 11, 12, 21, 22);

-- Instead of writing out each member of a set yourself, you can derive a set by following the IN operator with a subquery. A subquery — also known as a nested or inner query — is a SELECT statement embedded within one of the clauses of another SELECT statement. 
-- A subquery can retrieve information from any table in the same database as the table defined in the FROM clause of the “outer” operation.

-- As an example of using a subquery to define a set in a membership predicate, run the following statement to create a table named example_set_table that only has one column. This column will be named prime_numbers and will hold values of the int data type:
CREATE TABLE example_set_table (
prime_numbers int
);

INSERT INTO example_set_table
VALUES
(2),
(3),
(5),
(7),
(11),
(13),
(17),
(19),
(23),
(29);

-- Then run the following query. This returns values from the name and widgets columns from the sales table, and its WHERE clause tests whether each value in the widgets column is in the set derived by the subquery SELECT prime_numbers FROM example_set_table:
SELECT name, widgets
FROM sales
WHERE widgets IN (SELECT prime_numbers FROM example_set_table);


-- ******* How  TO Use Comparison and IS NULL Operators in SQL *****
CREATE DATABASE comparison_null_db;
USE comparison_null_db;

CREATE TABLE running_goals (
name varchar(15),
goal int,
result int
);

-- Load the running goals with some sample data. 
INSERT INTO running_goals
VALUES
('Michelle', 55, 48),
('Jerry', 25, NULL),
('Milton', 45, 52),
('Bridget', 40, NULL),
('Wanda', 30, 38),
('Stewart', 35, NULL),
('Leslie', 40, 44);


-- ***** How to Use Wildcards in SQL ******
-- Wildcards are special placeholder characters that can represent one or more other characters or values. 
-- This is a convenient feature in SQL, as it allows you to search your database for your data without knowing the exact values held within it.

CREATE DATABASE wildcardDB;
USE wildcardDB;

-- create a table named user_profiles to hold profile information of users of an application.
CREATE TABLE user_profiles (
user_id int,
name varchar(30),
email varchar(40),
birthdate date,
quote varchar(300),
PRIMARY KEY (user_id)
);


--INSERT INTO user_profiles
--VALUES
-- (1, 'Kim', 'bd_eyes@example.com', '1945-07-20', '"Never let the fear of striking out keep you from playing the game." -Babe Ruth'),
-- (2, 'Ann', 'cantstandrain@example.com', '1947-04-27', '"The future belongs to those who believe in the beauty of their dreams." -Eleanor Roosevelt'),
-- (3, 'Phoebe', 'poetry_man@example.com', '1950-07-17', '"100% of the people who give 110% do not understand math." -Demitri Martin'),
-- (4, 'Jim', 'u_f_o@example.com', '1940-08-13', '"Whoever is happy will make others happy too." -Anne Frank'), 
-- (5, 'Timi', 'big_voice@example.com', '1940-08-04', '"It is better to fail in originality than to succeed in imitation." -Herman Melville'),
-- (6, 'Taeko', 'sunshower@example.com', '1953-11-28', '"You miss 100% of the shots you don\'t take." -Wayne Gretzky'),
-- (7, 'Irma', 'soulqueen_NOLA@example.com', '1941-02-18', '"You have brains in your head. You have feet in your shoes. You can steer yourself any direction you choose." -Dr. Seuss'), 
-- (8, 'Iris', 'our_town@example.com', '1961-01-05', '"You will face many defeats in life, but never let yourself be defeated." -Maya Angelou');
-- (The above query was converted to a comment).

-- Quering Data with Wildcards --
-- _: When used as a wildcard, an underscore represents a single character. For example, s_mmy would match sammy, sbmmy, or sxmmy.
-- %: The percentage sign wildcard represents zero or more characters. For example, s%mmy would match sammy, saaaaaammy, or smmy.

-- These wildcards are used exclusively in a query’s WHERE clause with either the LIKE or NOT LIKE operators.

SELECT * FROM user_profiles WHERE name LIKE '_im';

-- The NOT LIKE operator has the opposite effect of LIKE. Rather than returning every record that matches the wildcard pattern, it will return every row that doesn’t match the pattern.
SELECT * FROM user_profiles WHERE name NOT LIKE '_im';

-- As another example, let’s say you know several of the users listed in the database have names that start with “I,” but you can’t remember all of them.
SELECT user_id, name, email FROM user_profiles WHERE name LIKE 'I%';

-- Note that in MySQL, by default, the LIKE and NOT LIKE operators are not case sensitive. This means the previous query will return the same results even if you don’t capitalize the “I” in the wildcard pattern.

-- *** Escaping Wildcard Characters ***
-- There may be times when you want to search for data entries that contain one of SQL’s wildcard characters.
-- In such cases, you can use an escape character which will instruct SQL to ignore the wildcard function of either % or _ and instead interpret them as plain text.


SELECT user_id, name, quote FROM user_profiles WHERE quote LIKE '%';

--To escape the percentafe sign, you can precede it with a backslash (\). 
SELECT * FROM user_profiles WHERE quote LIKE '\%';
-- However, this query won’t be helpful either, since it specifies that the contents of the quote column should only consist of a percentage sign.
-- To correct this, you’d need to include percentage sign wildcards at the beginning and end of the search pattern following the LIKE operator:

SELECT user_id, name, quote FROM user_profiles WHERE quote LIKE '%\%%';
-- In this query, the backslash only escapes the second percentage sign, while the first and third ones are still acting as wildcards. 
-- Thus, this query will return every row whose quote column includes at least one percentage sign.
-- Note that you can also define custom escape characters with the ESCAPE clause, as in the following example:

SELECT user_id, name, email FROM user_profiles WHERE email LIKE '%@_%' ESCAPE '@';


-- *** How To Use Joins in SQL ***
-- Many database designs separate informatiion into different tables based on the relationships between certain data point. Even in cases like this, it's likely
-- that there will be times when someone will want to retrieve information from more than one table at a time.


-- A common way of accessing data from multiple tables in a single Structured Query Language (SQL) operation is to combine the tables with a JOIN clause. 
-- Based on join operations in relational algebra, a JOIN clause combines separate tables by matching up rows in each table that relate to one another. 
-- Usually, this relationship is based on a pair of columns — one from each table — that share common values, such as one table’s foreign key and the primary key of another table that the foreign key references.


CREATE DATABASE joinsDB;

USE joinsDB;

--  imagine that you run a factory and have decided to begin tracking information about your product line, employees on your sales team, and your company’s sales in an SQL database. You plan to start off with three tables, 
-- the first of which will store information about your products.

CREATE TABLE products (
productID int UNIQUE,
productName varchar(20),
price decimal (4,2),
PRIMARY KEY (productID)
);

-- The second table will store information about the employees on the company's sales team. 
CREATE TABLE team (
empID int UNIQUE,
empName varchar(20),
productSpecialty int,
PRIMARY KEY (empID),
FOREIGN KEY (productSpecialty) REFERENCES products (productID)
);

-- The last table you create will hold records of the company's sales. 
CREATE TABLE sales (
saleID int UNIQUE,
quantity int,
productID int,
salesperson int,
PRIMARY KEY (saleID),
FOREIGN KEY (productID) REFERENCES products (productID),
FOREIGN KEY (salesperson) REFERENCES team (empID)
);

-- Loading the products table by running the INSERT INTO operation.
INSERT INTO products
VALUES
(1, 'widget', 18.99),
(2, 'gizmo', 14.49),
(3, 'thingamajig', 39.99),
(4, 'doodad', 11.50),
(5, 'whatzit', 29.99);

-- Load the team table with some sample data:
INSERT INTO team
VALUES
(1, 'Florence', 1),
(2, 'Mary', 4),
(3, 'Diana', 3),
(4, 'Betty', 2);

-- Load the sales table with sample data:
INSERT INTO sales
VALUES
(1, 7, 1, 1),
(2, 10, 5, 4),
(3, 8, 2, 4),
(4, 1, 3, 3),
(5, 5, 1, 3);

-- Imagine that your company makes a few sales without the involvement of anyone on your sales team.
-- To record these sales, run the following operation to add three rows to the sales table that don't include a value for the salesperson column:

INSERT INTO sales (saleID, quantity, productID)
VALUES
(6, 1, 5),
(7, 3, 1),
(8, 4, 5);

-- Understanding the Syntax of JOIN Operations --
-- JOIN clauses can be used in a variety of SQL statements, including UPDATE and DELETE operations.
-- The general syntax of a SELECT ssstatement that includes a JOIN clause:

-- SELECT table1.column1, table2.column2
-- FROM table1 JOIN table2
-- ON search_condition;

-- Note that because JOIN clauses compare the contents of more than one table, 
-- this example syntax specifies which table to select each column from by preceding the name of the column with the name of the table and a period. This is known as a fully qualified column reference.

-- You can use fully qualified column references like these in any operation, but doing so is technically only necessary in operations where two columns from different tables share the same name. 
--It’s good practice to use them when working with multiple tables, though, as they can help make JOIN operations easier to read and understand.


-- Following that is an ON clause, which describes how the query should join the two tables together by defining a search condition. A search condition is a set of one or more predicates, or expressions that can evaluate whether a certain condition is “true,” “false,” or “unknown.”
-- It can be helpful to think of a JOIN operation as combining every row from both tables, and then returning any rows for which the search condition in the ON clause evaluates to “true”.

-- In an ON clause, it usually makes sense to include a search condition that tests whether two related columns — like one table’s foreign key and the primary key of another table that the foreign key references — have values that are equal. This is sometimes referred to as an equi join.

SELECT team.empName, products.productName, products.price
FROM products JOIN team
ON products.productID = team.productSpecialty;
-- This statement will join the products and team tables with a search condition that tests for matching values in their respective productID and productSpecialty columns. 
-- It will then return the names of every member of the sales team, the name of each product they specialize in, and the price of those products.
-- Though, the columns you match to join two tables will typically be ones that already signify a relationship between the tables, like a foreign key and the primary key of another table that it references.

-- In an ON clause, it usually makes sense to include a search condition that tests whether two related columns — like one table’s foreign key and the primary key of another table that the foreign key references — have values that are equal. 
--This is sometimes referred to as an equi join.

--  As stated previously, though, the columns you match to join two tables will typically be ones that already signify a relationship between the tables, like a foreign key and the primary key of another table that it references.

-- Many SQL implementations also allow you to join columns that have the same name with the USING keyword instead of ON. This is how the syntax for such an operation might look:
-- SELECT table1.column1, table2.column2
-- FROM table1 JOIN table2
-- USING (related_column);
-- In this example syntax, the USING clause is equivalent to ON
-- table1.related_column = table2.related_column;


SELECT sales.saleID, sales.quantity, products.productName, products.price
FROM sales JOIN products
USING (productID)
ORDER BY saleID;

-- *** Joining More than Two Tables *** --
-- There may be times when you need to combine data from more than just two tables. You can join any number of tables together by embedding JOIN clauses within other JOIN clauses. The following syntax is an example of how this can look when joining three tables:
-- SELECT table1.column1, table2.column2, table3.column3
-- FROM table1 JOIN table2
-- ON table1.related_column = table2.related_column
-- JOIN table3
-- ON table3.related_column = table1_or_2.related_column;

-- This example syntax’s FROM clause starts by joining table1 with table2. After this joining’s ON clause, it starts a second JOIN that combines the initial set of joined tables with table3. Note that the third table can be joined to a column in either the first or second table.

-- To illustrate, imagine that you want to know how much revenue your employee’s sales have brought in, but you only care about sales records that involve an employee selling the product they specialize in.
-- To get this information, you could run the following query. This query starts by joining the products and sales tables together by matching their respective productID columns. It then joins the team table to the first two by matching each row in the initial JOIN to its productSpecialty column.
-- The query then filters the results with a WHERE clause to only return rows where the matched employee was also the person who made the sale. This query also includes an ORDER BY clause that sorts the final results in ascending order based on the value in the saleID column:

SELECT sales.saleID,
team.empName,
products.productName,
(sales.quantity * products.price)
FROM products JOIN sales
USING (productID)
JOIN team
ON team.productSpecialty = sales.productID
WHERE team.empID = sales.salesperson
ORDER BY sales.saleID;

-- To get this information, you could run the following query. This query starts by joining the products and sales tables together by matching their respective productID columns. It then joins the team table to the first two by matching each row in the initial JOIN to its productSpecialty column. 
-- The query then filters the results with a WHERE clause to only return rows where the matched employee was also the person who made the sale. This query also includes an ORDER BY clause that sorts the final results in ascending order based on the value in the saleID column:

-- *** Inner vs. Outer JOIN Operations
-- There are two main types of JOIN clauses: INNER joins and OUTER joins. The difference between these two types of joins has to do with what data they return. INNER join operations return only matching rows from each joined table, while OUTER joins return both matching and non-matching rows.
-- The example syntaxes and queries from the previous sections all used INNER JOIN clauses even though none of them include the INNER keyword. Most SQL implementations treat any JOIN clause as an INNER join unless explicitly stated otherwise.
-- Queries that specify an OUTER JOIN combine multiple tables and return any rows that match as well as rows that do not match. This can be useful for finding rows with missing values, or in cases where partial matches are acceptable.

-- OUTER join operations can be further divided into three types: LEFT OUTER joins, RIGHT OUTER joins, and FULL OUTER joins. LEFT OUTER joins, or just LEFT joins, return every matching row from the two joined tables, as well as every non-matching row from the “left” table. In the context of JOIN operations, 
-- the “left” table is always the first table specified immediately after the FROM keyword and to the left of the JOIN keyword.
--  Likewise, the “right” table is the second table, or the one immediately following JOIN, and RIGHT OUTER joins return every matching row from the joined tables along with every non-matching row from the “right” table.
-- A FULL OUTER JOIN returns every row from both tables, including any rows from either table that don’t have matches.


SELECT sales.saleID, sales.quantity, sales.salesperson, team.empName 
FROM sales JOIN team
ON sales.salesperson = team.empID;
-- This first example uses an INNER JOIN to combine the sales and team tables together by matching their respective salesperson and empID columns. Again, the INNER keyword is implied even though it’s not explicitly included.
-- This version of the query uses a LEFT OUTER JOIN clause instead:
SELECT sales.saleID, sales.quantity, sales.salesperson, team.empName
FROM sales LEFT OUTER JOIN team
ON sales.salesperson = team.empID; 
-- Like the previous query, this one also returns every matching value from both tables. However, it also returns any values from the “left” table (in this case, sales) that don’t have matches in the “right” table (team). 
-- Because these rows in the left table don’t have matches in the right, the unmatched values are returned as NULL:

-- This next version of the query instead uses a RIGHT JOIN clause:
SELECT sales.saleID, sales.quantity, sales.salesperson, team.empName
FROM sales RIGHT JOIN team
ON sales.salesperson = team.empID;

-- Notice that this query’s JOIN clause reads RIGHT JOIN instead of RIGHT OUTER JOIN. Similarly to how the INNER keyword isn’t required to specify an INNER JOIN clause, OUTER is implied any time you write LEFT JOIN or RIGHT JOIN.
-- This query’s result is the opposite of the previous one in that it returns every row from both tables, but only the unmatched rows from the “right” table.


-- ** Aliasing Table and COlumn Names in JOIN Clauses.
-- When joining tables with long or highly descriptive names, having to write multiple fully qualified column references can become tedious. To avoid this, users sometimes find it helpful to provide table or column names with shorter aliases.
-- You can do this in SQL by following any table definition in the FROM clause with the AS keyword, and then following that with an alias of your choice.

-- SELECT t1.column1, t2.column2
-- FROM table1 AS t1 JOIN table2 AS t2
-- ON t1.related_column = t2.related_column;
-- This example syntax uses aliases in the SELECT clause even though they aren’t defined until the FROM clause. This is possible because, in SQL queries, the order of execution begins with the FROM clause. This can be confusing, but it’s helpful to remember this and think of your aliases before you begin writing the query.

SELECT S.saleID, S.quantity,
P.productName,
(P.price * S.quantity) AS revenue 
FROM sales AS S JOIN products AS P
USING (productID);

-- Note that when defining an alias the AS keyword is technically optional. The previous example could also be written like this.
-- Even though the AS keyword isn’t needed to define an alias, it’s considered a good practice to include it. Doing so can help keep the query’s purpose clear and improve its readability.


-- ***** How To Use Mathematical Expressions and Aggregate Funcions in SQL *****

-- Structured Query Language (SQL) is used to store, manage, and organize information in a relational database management system (RDBMS). SQL can also perform calculations and manipulate data through expressions. Expressions combine various SQL operators, functions, and values, to calculate a value. 
-- Mathematical expressions are commonly used to add, subtract, divide, and multiply numerical values. Additionally, aggregate functions are used to evaluate and group values to generate a summary, such as the average or sum of values in a given column. Mathematical and aggregate expressions can provide valuable insights through data analysis that can inform future decision-making.

CREATE DATABASE mathDB;
USE mathDB;

-- We'll create a taable names product_information to store inventory and sales information for a small tea shop. The table will hold eight columns:
CREATE TABLE product_information (
product_id int, 
product_name varchar(30), 
product_type varchar(30), 
total_inventory int(200),
product_cost decimal(3, 2), 
product_retail decimal(3, 2), 
store_units int(100),
online_units int(100),
PRIMARY KEY (product_id)
); 

-- Inserting some sample data into the empty table:
INSERT INTO product_information
(product_id, product_name, product_type, total_inventory, product_cost, product_retail, store_units, online_units)
VALUES
(1, 'chamomile', 'tea', 200, 5.12, 7.50, 38, 52),
(2, 'chai', 'tea', 100, 7.40, 9.00, 17, 27),
(3, 'lavender', 'tea', 200, 5.12, 7.50, 50, 112),
(4, 'english_breakfast', 'tea', 150, 5.12, 7.50, 22, 74),
(5, 'jasmine', 'tea', 150, 6.17, 7.50, 33, 92),
(6, 'matcha', 'tea', 100, 6.17, 7.50, 12, 41),
(7, 'oolong', 'tea', 75, 7.40, 9.00, 10, 29),
(8, 'tea sampler', 'tea', 50, 6.00, 8.50, 18, 25),
(9, 'ceramic teapot', 'tea item', 30, 7.00, 9.75, 8, 15),
(10, 'golden teaspoon', 'tea item', 100, 2.00, 5.00, 18, 67);

-- ** alculating with Mathematical Expressions **
-- Please note this list is not comprehensive and that many RDBMSs have a unique set of mathematical operators:
-- Addition uses the + symbol
-- Subtraction uses the - symbol
-- Multiplication uses the * symbol
-- Division uses the / symbol
-- Modulo operations use the % symbol
-- Exponentiation uses POW(x,y)


SELECT 893 + 579;
-- Note that because you’re not retrieving any data from the database and you’re only calculating raw numbers, you don’t need to include a FROM clause in this or other example queries as this one.

-- ++++++ Understanding Order of Operations in SQL ++++++


-- You may be familiar with the term PEMDAS, which stands for parentheses, exponents, multiplication, division, addition, and subtraction. This term serves as a guideline for the order of operations necessary to solve more complex equations. PEMDAS is the term used in the U.S., 
-- while other countries may use different acronyms to represent their order of operations rule.
-- When it comes to combining different mathematica operations nested within parentheses, SQL reads them from left to right, and then values beginning from the inside to the outside. For this reason, ensure your values within parentheses accurately capture the problem you're trying to solve.
SELECT (2 + 4 ) * 8; 
-- Remember, parantheses placement mattter and if you're not careful, the entire result can change. For example, the following uses the same three values and operatrors, but with a different parentheses placement.

SELECT 2 + (4  * 8);
-- This procedure produces a different result.
-- If you prefer to perform calculations without parentheses, you can do that as well. Verify that this is the equation you want based on the operation order ot will be evaluated upon.
SELECT 100 / 5 - 300;

-- ++++ Analyzing Data with Aggregate Functions ++++
-- Imagine that you’re the owner of a small tea shop, and you want to perform calculations pertinent to the information you’ve stored in your database. 
-- SQL can use mathematical expressions to query and manipulate data by retrieving it from your database table and different columns. This helps with generating new information about the data you’re interested in analyzing. In this section, 
-- you’ll practice querying and manipulating sample data with aggregate functions to find information about the tea shop’s business.

-- The primamry aggregate functions in SQL include SUM, MAX< MIN, AVG, and COUNT. The SUM function adds all of the values in a column.
-- For example, use SUM to add up the amount for the total_inventory column in your sample data set:
SELECT SUM(total_inventory) FROM product_information;

-- The MAX functions finds the maximum value held in the selected column. 
SELECT MAX(product_cost) AS cost_max 
FROM product_information;

-- The MIN function is the opposite of the MAX function because it caluclates the minimum value.
SELECT MIN(product_retail) AS retail_min 
FROM product_information;

-- The AVG function calculates the average of all the values from the specified column in your table.
-- Also, note that you can run more than one aggregate function in the same query.

SELECT AVG(product_retail) AS retail_average, 
AVG(product_cost) AS cost_average 
FROM product_information;

-- The COUNT function operates differently from the others because it calculates a value from the table
-- itself by counting the number of rows retured by the query.

SELECT COUNT(product_retail) 
FROM product_information 
WHERE product_retail > 8.00;

-- Querying the number of products from product_cost that were purchased by the store for more than $8.00:
SELECT COUNT(product_cost) 
FROM product_information 
WHERE product_cost > 8.00;

-- ++++ Applying Mathematical Expressions in a Business Scenario ++++
-- As a first scenario, calculate the total units currently available in inventory to understand how many products are remaining for in-store and online sales. 

SELECT product_name, 
total_inventory - (store_units + online_units) 
AS remaining_inventory 
FROM product_information 
ORDER BY(remaining_inventory) DESC;

-- This query is useful because it calcuates the remaining inventory, which can help the tea shop owners make plans to purchase more orders if they're running low on a product.
SELECT product_name, 
(online_units * product_retail) AS o, 
(store_units * product_retail) AS s 
FROM product_information;

-- Next, calculate the total revenue from in-store and online sales using the SUM function and several mathematical operators:
SELECT SUM(online_units * product_retail) + 
SUM(store_units * product_retail) 
AS total_sales 
FROM product_information;

-- Performing these queries is important for two reasons. The first reason is so that the tea shop owners can evaluate which items are best-sellers and prioritize those products when purchasing more in the future. 
-- Second, they can analyze how well the tea shop performed overall with products sales in-store and online.

-- Next, you’ll find the profit margin for each product. The profit margin for a given product is the amount of revenue that the business gains for each unit of that product that it sells. 
--  understand how much revenue you earned, you can multiply the sales by the profit margin.

-- To calculate the profit margin for your individual products, subtract product_cost from product_retail for each row. Then divide this value by the product retail to calculate the profit margin percentage:
SELECT product_name, 
(product_retail - product_cost) / product_retail 
AS profit_margin
FROM product_information;

-- Based on this output, you’ll learn that the product with the highest profit margin is the golden teaspoon at 60%, and the lowest is for the Chai, Jasmine, Matcha, and Oolong teas at 18%. For the golden teaspoon, 
-- this means at a retail value of $5.00 with a profit margin of 60%, you create $3.00 in revenue.

-- You could also use the aggregate function AVG to calculate the average profit margin for all of the tea shop’s products. This average serves as a benchmark for the tea shop owners to then identify what products fall below that number and strategize how to improve:
SELECT AVG((product_retail - product_cost) / product_retail) 
AS avg_profit_margin 
FROM product_information;

-- From this calculation, you can conclude that the mean profit margin for products at this tea shop is 28%.
-- With this new information, imagine that the tea shop owners want to increase the profit margin to 31% in the next quarter for any products that currently have a profit margin less than 27%. In order to do this, 
-- you’ll subtract your target profit margin from 1 (1 - 0.31) and then divide each of the returned products’ costs by this value. The result will be the new price that the product must sell for at retail to achieve a 31% profit margin:

SELECT product_name, product_cost / (1 - 0.31) 
AS new_retail 
FROM product_information 
WHERE (product_retail - product_cost) / product_retail < 0.27;

-- These results display the new retail prices necessary for under-performing products to achieve a 31% profit margin. 
-- Data analysis such as this equips the tea shop owners with the ability to make decisive business decisions about how to improve their revenue for the next quarter and understand what to aim for.


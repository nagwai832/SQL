--1.	Create the following schema and transfer the following tables to it 
--a.Company Schema 
--i. Department table (Programmatically)
create schema Company
alter schema hr transfer dbo
--ii. Project table (visually)
--b.Human Resource Schema
--i. Employee table (Programmatically)
create schema HumanResource
alter schema HumanResource transfer Employee
-------------------------------------------Part 1: Use ITI DB------------------------------------------------------------
--1. Create a view that displays student full name, course name if the student has a grade more than 50.
alter view v1 (fullName , C_name, GD) with encryption
as
select s.St_Fname +' ' + s.St_Lname , c.Crs_Name , sc.Grade
from Student s , Course c , Stud_Course sc
where s.St_Id = sc.St_Id and c.Crs_Id = sc.Crs_Id and sc.Grade >= 50
with check option

sp_helptext 'v1'

select * from v1


--2. Create an Encrypted view that displays manager names and the topics they teach.
create view v2  with encryption 
as
select i.Ins_Name ,d.Dept_Name , t.Top_Name
from Instructor i , Course c  , Ins_Course ic , Department d , Topic t
where d.Dept_Id = i.Dept_Id and i.Ins_Id = ic.Ins_Id and c.Crs_Id = ic.Crs_Id  and t.Top_Id = c.Top_Id
with check option

sp_helptext 'v1'

select * from v2

--3.(important)Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
--“use Schema binding” and describe what is the meaning of Schema Binding
alter view v3  with schemabinding 
as
select i.Ins_Name ,d.Dept_Name 
from dbo.Instructor i , dbo.Department d  -- write schema name
where d.Dept_Id = i.Dept_Id  and d.Dept_Name in ('SD','Java')

with check option

select * from v3

alter table Instructor alter column Ins_Name char(20) -- error
alter table Instructor alter column [Ins_Degree] char(20) -- run successfully
alter table Instructor alter column [Ins_Degree] nvarchar(50)

--4.	Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
create view v4  with encryption
as
select s.* , d.Dept_Location
from Student s, Department d
where d.Dept_Id = s.Dept_Id and d.Dept_Location in('alex', 'Cairo')
with check option

select * from v4

update v4
set Dept_Location = 'tanta'
where Dept_Location = 'alex'
--Note: Prevent the users to run the following query Update V1 set st_address=’tanta’ Where st_address=’alex’.

----------------------------------------------Part 2: Use Company DB------------------------------------------------------
--1. Fill the Create a view that will display the project name and the number of employees work on it
create view v5  with encryption
as
select p.Pname , count(e.[SSN]) as numEmployee 
from [dbo].[Project] p,  [HumanResource].[Employee] e , [Company].[Departments] d
where d.Dnum = p.Dnum and e.SSN = d.MGRSSN
group by p.Pname
with check option

select * from v5

--2. (important)Create a view named  “v_count “ that will display the project name and the number of hours for each one.
alter view v_count with encryption
as 
select p.Pname , sum(w.Hours) as HourSum
from Project p , Works_for w
where p.Pnumber = w.Pno
group by p.Pname
with check option


select * from v_count

--3. Create a view named   “v_D30” that will display employee number, project number, hours of the projects in department 30. updated
alter view v_D30 with encryption
as
select e.[SSN], p.Pnumber , w.Hours
from Project p , [HumanResource].[Employee] e, Works_for w, [Company].[Departments] d
where e.SSN = d.MGRSSN and d.[Dnum] = p.Dnum and p.Pnumber = w.Pno   and d.[Dnum] =30
with check option

select * from v_D30

--4. Create a view named ” v_project_500” that will display the emp no. for the project 500, use the previously created view  “v_D30”
create view v_project_500 with encryption
as
select SSN
from v_D30 v
where Pnumber = 500
with check option

select * from v_project_500

--5. Delete the views  “v_D30” and “v_count”
drop view v_D30
drop view v_count

--6. Display the project name that contains the letter “c” Use the previous view created in Q#1
select Pname
from v5
where Pname like '%c%'



--7.(important) add new column Enter_Date in Works_for table and insert it then create view name “v_2021_check” that will display employee no., 
--which must be from the first of January and the last of December 2021.
--this view will be used to insert data so make sure that the coming new data matchs the condition.

alter table Works_for
add Enter_Date date

go
alter view v_2021_check with encryption
as
select w.ESSn , w.Enter_Date
from Works_for w
where w.Enter_Date between '2021-01-01' and '2021-12-31'
with check option

select * from v_2021_check

--8. display Salary that is less than 2000 using rule.
create rule r1 as @x< 2000
sp_bindrule r1 , '[HumanResource].[Employee].Salary'

--9. Create a new user data type named loc with the following Criteria:
--•	nchar(2) 
--•	default: NY 
--•	create a rule for this Data type :values in (NY,DS,KW)) and associate it to the location column

create type loc from nchar(2) 
create default def1 as 'NY' 

create rule r as @x in ('NY','DS','KW')
sp_bindrule r , loc
sp_bindefault def1, loc

-- 7.Create New table Named newStudent, and use the new UDD on it.
--		a.	Make ID column and don’t make it identity.
create table newStudent2 (ID int  , Adress loc )
select * from newStudent2

drop table newStudent2

--8.	Create a new sequence for the ID values of the previous table.
--	a.	Insert 3 records in the table using the sequence.
alter sequence ID2
start with 1
increment by 1
minValue 1
maxValue 3 

create sequence ID1
start with 1
increment by 1


insert into newStudent2
values (next value for ID1 , 'DS'),(next value for ID1 , 'NY'),(next value for ID1 , 'KW')

select * from newStudent2

--b. Delete the second row of the table.
delete newStudent2
where ID = 2

--c. Insert 2 other records using the sequence.
insert into newStudent2
values (next value for ID1 , 'NY'),(next value for ID1 , 'KW')
--d. Can you insert another record without using the sequence? Try it! Can you do the same if it was an identity column?
insert into newStudent2 (Adress)
values ( 'DS')

create table newStudent11 (ID int identity(1,1)  , Adress loc)
select * from newStudent11

insert into newStudent11
values ( 'DS'),( 'NY'),( 'KW')

delete newStudent11
where ID = 2

insert into newStudent11 (Adress)
values ( 'NY'),('KW')

insert into newStudent11 (Adress)
values ( 'DS')


select * from newStudent11
select * from newStudent2
--e. Can you edit the value if the ID column in any of the inserted records? Try it!
update newStudent2
set Adress = 'DS'
where ID = 5
--f. Can you use the same sequence to insert in another table?
insert into Project (Pnumber,Plocation)
values (next value for ID1, 'KW')
select * from Project
--g. If yes, do you think that the sequence will start from its initial value in the new table and insert the same IDs that were inserted in the old table?
-- no , continue id in old table 

--h. How to skip some values from the sequence not to be inserted in the table? Try it.

--i. Can you do the same with the Identity column?

create table newStudent11 (ID int identity(1,1)  , Adress loc)
select * from newStudent11

insert into newStudent11
values ( 'DS'),( 'NY'),( 'KW')

delete newStudent11
where ID = 2

insert into newStudent11 (Adress)
values ( 'NY'),('KW')

insert into newStudent11 (Adress)
values ( 'DS')


select * from newStudent11


--j. What’re the differences between Identity column and Sequence?

-- Identity column == column can't edit it and give it start point and increment number ,  it is tied to the table,
--						engine store value that in column
-- Sequence == object generate Sequence of number in certain specification, column can edit it and give it start point , increment number  , min and max value , 
--				it is not tied to any specific table meaning its value can be shared by multiple tables.

-- problem of Identity ==> Uniqueness of the value – 
	--						engine store value that in column
--							Consecutive values within a transaction 
--							Consecutive values after server restart or other failures 
--							Reuse of values – For a given identity property with specific seed/increment, the identity values are not reused by the engine. If a particular insert statement fails or if the insert statement is rolled back then the consumed identity values are lost and will not be generated again. This can result in gaps when the subsequent identity values are generated.


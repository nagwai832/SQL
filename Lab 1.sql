---------------------------------------------------Demo------------------------------------------------------------------

---------------------------Cross join---------------------------------
select s.St_Fname + ' ' + s.St_Lname [Full Name] , d.Dept_Name
from Student s , Department d
--------------------------Inner join=Equi joins------------------------

-- 1. --Find Student names and their Departments name
select s.St_Fname + ' ' + s.St_Lname [Full Name] , d.Dept_Name
from Student s , Department d
where d.Dept_Id = s.Dept_Id

select s.St_Fname + ' ' + s.St_Lname [Full Name] , d.Dept_Name
from Student s inner join Department d
on d.Dept_Id = s.Dept_Id

--2. --Find Student names and their Departments name and Dept_Id
select s.St_Fname + ' ' + s.St_Lname [Full Name] , d.Dept_Name , d.Dept_Id
from Student s, Department d
where d.Dept_Id = s.Dept_Id

--3.Find Students Name and department info
select s.St_Fname + ' ' + s.St_Lname [Full Name] , d.*
from Student s , Department d
where d.Dept_Id = s.Dept_Id

--4. Find Students name and thier Dept_Name who live in cairo
select s.St_Fname + ' ' + s.St_Lname [Full Name] , d.Dept_Name
from Student s , Department d
where d.Dept_Id = s.Dept_Id and d.Dept_Location = 'Cairo'
-----------------------Left Outer join------------------------
--Find Student names and thier department even they have department or not
select s.St_Fname + ' ' + s.St_Lname [Full Name] , d.Dept_Name
from Student s left outer join Department d
on d.Dept_Id = s.Dept_Id

---------------------Right Outer join----------------------
--Find student names and department names even department has students or not
select s.St_Fname + ' ' + s.St_Lname [Full Name] , d.Dept_Name
from Student s right outer join Department d
on d.Dept_Id = s.Dept_Id

---------Full
select s.St_Fname + ' ' + s.St_Lname [Full Name] , d.Dept_Name
from Student s full outer join Department d
on d.Dept_Id = s.Dept_Id


--------------------Self Join------------------------------
--(Important)Find Student name and their leaders name
select * from Student
select s.St_Fname + ' ' + s.St_Lname [Student Name] , super.St_Fname + ' ' + super.St_Lname [Leader Name] 
from Student s, Student super
where  super.St_Id = s.St_super

----Find Student name and their leaders Information
select s.St_Fname + ' ' + s.St_Lname [Student Name] , super.*
from Student s, Student super
where  super.St_Id = s.St_super

--Find Student names and their courses and course grades
select s.St_Fname + ' ' + s.St_Lname [Student Name] , c.Crs_Name , sc.Grade
from Student s , Course c, Stud_Course sc
where sc.St_Id = s.St_Id and sc.Crs_Id = c.Crs_Id

--another way using microsoft syntax
select s.St_Fname + ' ' + s.St_Lname [Student Name] , c.Crs_Name , sc.Grade
from  Course c inner join  Stud_Course sc on sc.Crs_Id = c.Crs_Id
		inner join Student s  on sc.St_Id = s.St_Id  

--Find Student names and Department name and their courses and course grades
select s.St_Fname + ' ' + s.St_Lname [Student Name] ,d.Dept_Name, c.Crs_Name , sc.Grade
from  Course c inner join  Stud_Course sc on sc.Crs_Id = c.Crs_Id
		inner join Student s  on sc.St_Id = s.St_Id  inner join Department d on d.Dept_Id = s.Dept_Id

----------------------------Joins with DML----------------------------
--(important)Joins with Update
--Increase grade 10 marks for alex students

update Stud_Course
set Grade += 10
from Student s , Stud_Course sc
where s.St_Id = sc.St_Id and s.St_Address = 'alex'

--(important)Joins with Insert
create table TopStuduent( id int , std_name varchar(20) , grade int)

insert into TopStuduent (id, grade)
select s.St_Id , sc.Grade
from Student s , Stud_Course sc
where s.St_Id = sc.St_Id and sc.Grade>80

select * from TopStuduent


--(important)Joins with Delete 
delete s
from Student s inner join Stud_Course sc
on s.St_Id = sc.St_Id
where s.St_Address = 'alex'

----sub query 
--1. In select (1 , 15) 
select St_Id , (select count(St_Id) from Student) as Total
from Student 

--2. In from
select * from 
(
select St_Fname+' ' +St_Lname as fullName , St_Age 
from Student 
) newTable
where  fullName = 'ahmed hassan'

--3. In where 
select * 
from Student 
where st_age < (select avg(St_Age) from Student)

--4. Check 
select Dept_Name
from Department
where Dept_Id  not in (
select distinct s.Dept_Id
from Student s
where Dept_Id is not null
)

-------------------------Union family ------
--union all , union , intersect , except

select s.St_Fname 
from Student s
union all 
select i.Ins_Name
from Instructor i

select s.St_Fname 
from Student s
union 
select i.Ins_Name
from Instructor i

select s.St_Fname 
from Student s
intersect 
select i.Ins_Name
from Instructor i

select s.St_Fname 
from Student s
except 
select i.Ins_Name
from Instructor i



----------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------Part-1: Use ITI DB------------------------------------------------
--1.	Display instructor Name and Department Name 
--Note: display all the instructors if they are attached to a department or not

select i.Ins_Name , d.Dept_Name
from Instructor i left outer join Department d
on  d.Dept_Id = i.Dept_Id

--2.	Display student full name and the name of the course he is taking For only courses which have a grade  
select s.St_Fname + ' ' + s.St_Lname [Student Name] , c.Crs_Name , sc.Grade
from Student s , Course c , Stud_Course sc
where  s.St_Id = sc.St_Id and c.Crs_Id = sc.Crs_Id

--3.	Display number of courses for each topic name
select count(c.Crs_Id) , t.Top_Name
from Course c , Topic t
where t.Top_Id =c.Top_Id -- خدى بالك
group by Top_Name

--4.	Display max and min salary for instructors
select i.Ins_Id,(i.Salary) , min(i.Salary) 
from Instructor i
group by i.Ins_Id
--5.	Display instructors who have salaries less than the average salary of all instructors.
select i.Ins_Name
from Instructor i
where i.Salary < (select AVG(i.Salary) from Instructor i) -- use subquery because AVG not use with where

--6.	Display the Department name that contains the instructor who receives the minimum salary.
select d.Dept_Name 
from Department d ,Instructor i
where d.Dept_Id = i.Dept_Id and i.Salary = (select min(i.Salary) from Instructor i)

--7.	Select max two salaries in instructor table
select top(2) i.Salary
from Instructor i

----------------------------------Part-2: Use AdventureWorks DB----------------------------------------------------
--1.	Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) 
--to designate SalesOrders that occurred within the period ‘7/28/2008’ and ‘7/29/2014’
select s.SalesOrderID , s.ShipDate 
from  SalesLT.SalesOrderHeader s
where s.OrderDate  between '2004-06-01' and '2004-06-01'

--2.	Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
select p.ProductID, p.Name 
from [SalesLT].[Product] p
where p.StandardCost < $110.00
--3.	Display ProductID, Name if its weight is unknown
select p.ProductID, p.Name 
from [SalesLT].[Product] p
where p.Weight is null
--4.	 Display all Products with a Silver, Black, or Red Color
select p.*
from [SalesLT].[Product] p
where p.Color in ('Silver','Black','Red')

--5.	 Display any Product with a Name starting with the letter B
select p.Name
from [SalesLT].[Product] p
where p.Name like 'B%'

--6. Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.
--Store table  in a newly created table named [store_Archive]
--Note: Check your database to see the new table and how many rows in it?
--Try the previous query but without transferring the data

create table store_Archive (rowguid uniqueidentifier , Name nvarchar(50) ,SalesPersonID int ,Demographics xml(CONTENT Sales.StoreSurveySchemaCollection)) 

insert into store_Archive_1
select s.rowguid , s.Name , s.SalesPersonID , s.Demographics
from Sales.Store s

select * from store_Archive_1

----------------------------------Part-3:  Use Company_SD DB----------------------------------------------------

--1.	Display the Department id, name and SSN and the name of its manager.
select d.Dnum , d.Dname, d.MGRSSN , e.Fname
from Departments d, Employee e
where d.Dnum = e.Dno
--2.	Display the name of the departments and the name of the projects under its control.
select d.Dname , p.Pname
from Departments d , Project p
where d.Dnum = p.Dnum
--3.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly.
select e.Fname +' ' + e.Lname [Full Name] 
from Employee e
where e.Dno =30 and e.Salary between 1000 and 2000
--4. Retrieve the names of all employees in department 10 who works more than or equal 10 hours per week on "AL Rabwah" project.
select e.Fname +' ' + e.Lname [Full Name] 
from Employee e, Project p , Works_for w
where e.SSN= w.ESSn and p.Pnumber = w.Pno and  e.Dno =10 and w.Hours >= 10 and p.Pname = 'AL Rabwah'
--5.	Find the names of the employees who directly supervised with Kamel Mohamed.
select super.Fname +' ' + super.Lname [Full Name] , e.Fname +' ' + e.Lname [Full Name] 
from Employee e, Employee super
where super.SSN = e.Superssn and super.Fname = 'Kamel' and super.Lname = 'Mohamed'

--6. Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select super.Fname +' ' + super.Lname [Full Name] , e.Fname +' ' + e.Lname [Full Name] 
from Employee e, Employee super
where super.SSN = e.Superssn and super.Fname = 'Kamel' and super.Lname = 'Mohamed'
--7.	For each project located in Cairo City , find the project number, the controlling department name ,
--the department manager last name ,address and birthdate
select p.Pnumber, d.Dname, e.Lname , e.Address, e.Bdate
from Project p , Departments  d , Employee e
where d.Dnum = e.Dno and d.Dnum= p.Dnum and p.City = 'Cairo'

--8.	Display All Data of the mangers
select e.*  , d.*
from Employee e, Departments d
where e.SSN = d.MGRSSN
--9.	Display All Employees data and the data of their dependents even if they have no dependents
select e.*  , d.*
from Employee e left outer join Dependent d
on e.SSN = d.ESSN
-------------------------------------------------Bouns---------------------------------------------------------
--Display results of the following two statements and explain what is the meaning of @@AnyExpression
select @@VERSION
select @@SERVERNAME

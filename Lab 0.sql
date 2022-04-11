--1. Display all the employees Data.
select * from Employee

--2. Display the employee First name, last name, Salary and Department number.
select e.Fname, e.Lname, e.Salary, e.Dno
from Employee e

--3. Display all the projects names, locations and the department which is responsible about it.
select p.Pname, p.Plocation, p.Dnum
from Project p

/**(important)4. If you know that the company policy is to pay an annual commission for each 
employee with specific percent equals 10% of his/her annual salary .Display each 
employee full name and his annual commission in an ANNUAL COMM column (alias).**/
select e.Fname+' '+e.Lname [full name] , (e.Salary*12)*.1 [ANNUAL COMM]
from Employee e

--5. Display the employees Id, name who earns more than 1000 LE monthly.
select e.SSN,e.Fname+' '+e.Lname [full name]
from Employee e
where e.Salary > 1000

--6. Display the employees Id, name who earns more than 10000 LE annually.
select e.SSN, e.Fname+' '+e.Lname [full name] 
from Employee e
where (e.Salary*12) > 10000

--7. Display the names and salaries of the female employees 
select e.Fname+' '+e.Lname [full name] , e.Salary
from Employee e
where e.Sex = 'F'

--8. Display each department id, name which managed by a manager with id equals 968574.
select d.Dnum, d.Dname
from Departments d
where d.MGRSSN = 968574

--9. Dispaly the ids, names and locations of the pojects which controled with department 10.
select p.Pnumber, p.Pname, p.Plocation
from Project p
where p.Dnum = 10

--10. For each department, retrieve the department num and the maximum, minimum and average salary of its employees.

select e.Dno , max(e.Salary) MaxSalary, min(e.Salary) MinSalary, avg(e.Salary) AVGSalary
from Departments d, Employee e
group by e.Dno


--DML
/**1. Insert your personal data to the employee table as a new employee in department number 30, 
SSN = 102672, Superssn = 112233, salary=3000.**/

insert into Employee (SSN,Salary,Superssn,Dno)
values (102672,3000,112233,30)

select SSN,Salary,Superssn,Dno from Employee

/**2. Insert another employee with personal data your friend as new employee in department 
number 30, SSN = 102660, but don’t enter any value for salary or manager number to 
him.**/

insert into Employee (SSN,Dno)
values (102660,30)

select SSN,Salary,Superssn,Dno from Employee


--3. Upgrade your salary by 20 % of its last value

update Employee
set Salary = Salary*.2

select Salary from Employee

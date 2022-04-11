--Note: Use ITI DB
--1. Create a scalar function that takes date and returns Month name of that date.
alter  function MonthName (@date date)
returns varchar(20)
as
	begin
		declare @monthName varchar(20)
		select @monthName = format(@date, 'MMMM')
		return @monthName

	end

select dbo.MonthName(GETDATE()) as 'Month Name'

--2. Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
alter function RangeValues (@num1 int , @num2 int)
returns @tab table (rangeValues int)
as
	begin
		while(@num1 < @num2) 
			begin
				insert into @tab values(@num1)
				set @num1 += 1 
			end 
	return	
	end

select * from dbo.RangeValues(4,10)

--3. Create a tabled valued function that takes Student No and returns Department Name with Student full name.
create function StudentInfo (@studentNo int)
returns table
as
return
		(
			select d.Dept_Name , s.St_Fname + ' ' +s.St_Lname [FullName]
			from Student s, Department d
			where s.St_Id = @studentNo and d.Dept_Id = s.Dept_Id
		)

select * from StudentInfo(5)
--4. Create a scalar function that takes Student ID and returns a message to user 
--a. If first name and Last name are null then display 'First name & last name are null'
--b. If First name is null then display 'first name is null'
--c. If Last name is null then display 'last name is null'
--d. Else display 'First name & last name are not null'

create function Message (@ID int)
returns varchar(50)
as 
	begin
		declare @message  varchar(50) , @fname  varchar(50), @lname  varchar(50)
		select @fname = s.St_Fname , @lname = s.St_Lname
		from Student s
		where s.St_Id = @ID

		if (@fname is not null and @lname is not null) 
			set @message = 'First name & last name are null'
		else if (@fname is not null ) 
			set @message = 'First name is null'
		else if (@lname is not null) 
			set @message = 'last name is null'
		else 
			set @message=  'First name & last name are not null'
		return @message
	end
select dbo.Message(13) as 'Message'

--5.(Not sure) Create a function that takes integer which represents the format of the Manager hiring date and displays department name,
--Manager Name and hiring date with this format. 
alter function func (@MGRHiredate int)
returns table 
as
return
	(	
		select d.Dept_Name , i.Ins_Name , CONVERT(varchar(20),GETDATE(),@MGRHiredate) as hireDate 
		from Department d , Instructor i 
		where d.Dept_Id = i.Dept_Id 
	)
select * from func(106)
select * from func(108)

--6. Create multi-statements table-valued function that takes a string
--If string='first name' returns student first name
--If string='last name' returns student last name 
--If string='full name' returns Full Name from student table 
--Note: Use “ISNULL” function

create function StudentName_1(@string varchar(50))
returns @tab table(StudentName varchar(50))
as 
	begin
		if (@string = 'first name')
			insert into @tab
			select s.St_Fname
			from Student s
		else if (@string = 'last name')
			insert into @tab
			select s.St_Lname
			from Student s
		else if (@string = 'full name')
			insert into @tab
			select s.St_Fname+' ' +s.St_Lname
			from Student s
	return
	end
select * from dbo.StudentName_1('First name')

--7. Write a query that returns the Student No and Student first name without the last char
select s.St_Id , SUBSTRING(s.St_Fname,1,len(s.St_Fname)-1)
from Student s


--8. Write a query that takes the columns list and table name into variables and then return the result of this query “Use exec command”
declare @column varchar(20) = '[St_Address]' , @table varchar(20) = '[dbo].[Student]'

execute('select' + @column +'from' + @table)

--Part 2: Use Company DB
--1.	Create function that takes project number and display all employees in this project

alter function empInfo (@pno int)
returns table
as return (
			select e.* , p.Pnumber
			from Project p , [HumanResource].[Employee] e , Works_for w
			where e.[SSN] = w.ESSn  and w.Pno= p.Pnumber and p.Pnumber = @pno
		)
select * from empInfo(400)





--1. Scalar Function
--String GetStudentName (int id){}
create function StudentName (@id int)
returns varchar(50)
	begin
		declare @name varchar(50)
		select @name = s.St_Fname 
		from Student s
		where s.St_Id = @id
		return @name

	end

select dbo.StudentName(5)

--2.inline Function
--function take dept_id retrun ins_name , annualSalary
create function GetInsInf (@id int)
returns table
as
return 
	( select i.Ins_Name, (i.Salary*12 ) annualSalary
	from Instructor i
	where i.Ins_Id = @id
	)

select * from GetInsInf(10)

--3.Multi Statement
--table GetStudentData (@fromat varchar(20))
create function GetStudentsData (@format varchar(20))
returns @tab table (id int , ename varchar(50))
as
	begin
		if(@format = 'first')
			insert into @tab
			select s.St_Id , s.St_Fname
			from Student s
		else if(@format = 'Last')
			insert into @tab
			select s.St_Id , s.St_Lname
			from Student s
		else if(@format = 'full')
			insert into @tab
			select s.St_Id , s.St_Fname + ' ' + s.St_Lname
			from Student s
		
	return 
	end

select * from dbo.GetStudentsData('full')
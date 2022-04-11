--1. Create a stored procedure to show the number of students per department.[use ITI DB] 
alter proc sp_1 
as 
	select d.Dept_Name, count(s.St_Id) as [Student Number]
	from Student s , Department d
	where d.Dept_Id = s.Dept_Id
	group by d.Dept_Name

sp_1

--3. Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
--“Print a message for user to tell him that he can’t insert a new record in that table”
create trigger t_1
on [dbo].[Department]
instead of insert
as 
	select 'can’t insert a new record in that table'

insert into Department(Dept_Name) values ('BI')
select * from Department
--4.(important) Create a stored procedure that will check for the number of total of employees in the project no.100  
--if they are more than 3 print message to the user “'The number of employees in the project 100 is 3 or more'”
--if they are less display a message to the user “'The following employees work for the project 100” in addition to the first name and last name of each one. [Company DB] 
alter proc TotalEmp_1  @pno int 
as 
	declare @TotalNum int 
	select @TotalNum =count(w.ESSn) 
	from  Works_for w
	where w.Pno = @pno
	if @TotalNum > 3 
		select 'The number of employees in the project 100 is 3 or more'
	else if @TotalNum < 3 
		select 'The following employees work for the project 100'  -- impo
		select e.Fname , e.Lname
		from HumanResource.Employee e , Works_for w
		where e.SSN = w.ESSn and @pno = w.Pno
			
TotalEmp_1 100 


--6. Create a stored procedure that will be used in case there is an old employee has left the project and a new one become instead of him. 
--The procedure should take 3 parameters (old Emp.SSN, new Emp.SSN and the project no.) and it will be used to update works_on table. [Company DB]

create proc SP_2 @oldEmp int , @newEmp int , @pno int
as
	update Works_for 
	set ESSn = @newEmp
	where ESSn = @oldEmp

execute SP_2 669955 , 521634 , 700

select * from Works_for

-- 7.Create an Audit table with the following structure 
-- This table will be used to audit the update trials on the Budget column (Project table, Company DB)
--Example:
--If a user updated the Hours column then the project no., the user name that made that update, 
--the date of the modification and the value of the old and the new Hours will be inserted into the Audit table 
--Note: This process will take place only if the user updated the Hours column
create table tab (ProjectNo  int , UserName varchar(50) , ModifiedDate  date , Hours_Old  int , Hours_New int)

alter trigger audit_table
on [dbo].[Works_for]
after update
as
	if (update([Hours]))
		begin
		declare @old_hour int , @new_hour int , @pno int
		select @old_hour = [Hours] from deleted
		select @new_hour = [Hours] from inserted
		select @pno = [Pno] from inserted
		select * from inserted
		insert into tab values (@pno, SUSER_NAME(), getdate(), @old_hour,@new_hour)
		end


update [dbo].[Works_for]
set Hours = 10
where Hours = 29 and Pno = 100

select * from Works_for

select * from tab
-- 8.(impo) Create a trigger that prevents the insertion Process for Employee table in March 

create trigger t2
on [HumanResource].[Employee]
instead of insert
as
	if(format(GETDATE(),'MMMm') = 'March')
		begin
		select 'Not allowed to insert'
		delete from [HumanResource].[Employee]
		select * from inserted
		end
select * from HumanResource.Employee
insert into HumanResource.Employee(SSN ,Fname,Lname)
values (1245858,'Mahmoud' , 'Ahmed')

-- 9.Create a trigger that prevents users from altering any table in Company DB.

create trigger t_3
on database
for alter_table
as
	select 'Not Allowed'
	rollback

alter table [dbo].[Project]
add p_Add varchar(20)
-- 10.	(impo)Create a trigger on student table after insert to add Row in Student Audit table (Server User Name , Date, Note)
--where note will be “[username] Inserted New row with Key=[Key Value] in table [table name]” .[use ITI DB]
create table StudentAudit2 (ServerUserName varchar(50) , Date date, note varchar(150))

create trigger t_4
on [dbo].[Student]
after insert
as
		declare @key varchar(20)
		select @key = St_Id from inserted
		insert into StudentAudit2 values (SUSER_NAME(), getdate(),SUSER_NAME()+ 'Inserted New row with Key='+@key+ 'in table student' )


select * from Student
select * from StudentAudit2
insert into Student (St_Id , St_Fname)
values (17, 'aya')
-- 11. Create a trigger on student table instead of delete to add row in Student Audit table 
-- (Server User Name, Date, Note) where note will be “[username] tried to delete row with Key=[Key Value]” .[use ITI DB]
create table StudentAudit3 (ServerUserName varchar(50) , Date date, note varchar(150))

create trigger t_5
on [dbo].[Student]
instead of delete
as
		declare @key varchar(20)
		select @key = St_Id from deleted
		insert into StudentAudit3 values (SUSER_NAME(), getdate(),SUSER_NAME()+'tried to delete row with Key='+ convert(varchar(20),@key) )
	--insert into Student -- rollback
	--select * from deleted
delete from Student
where St_Id =17

select * from Student

select * from  StudentAudit3
	   
		

	


	
	




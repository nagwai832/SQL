--1.	Display all the data from the Employee table as an XML document “Use XML Raw”. Use company DB 
--A)	Elements
select * from HumanResource.Employee
for xml raw ('Employee') , elements
--B)	Attributes
select * from HumanResource.Employee
for xml raw ('Employee') 

-- 2.	Display Each Department Name with its instructors. “Use ITI DB”
--A)	Use XML Raw
select d.Dept_Name , i.Ins_Name 
from Department d , Instructor i
where d.Dept_Id = i.Dept_Id
for xml raw ('Instructor') , elements , Root('Instructors')
--B)	Use XML Auto
select Dept_Name , Ins_Name 
from Department , Instructor
where Department.Dept_Id = Instructor.Dept_Id
for xml auto , elements , Root('Instructors')
--C)	Use XML Path
select Dept_Name  , Ins_Name 
from Department , Instructor
where Department.Dept_Id = Instructor.Dept_Id
for xml path ('Instructor') , elements , Root('Instructors')


-- 3.	Use the following variable to create a new table “customers” inside the company DB. Use OpenXML
declare @docs xml ='<customers>
              <customer FirstName="Bob" Zipcode="91126">
                     <order ID="12221">Laptop</order>
              </customer>
              <customer FirstName="Judy" Zipcode="23235">
                     <order ID="12221">Workstation</order>
              </customer>
              <customer FirstName="Howard" Zipcode="20009">
                     <order ID="3331122">Laptop</order>
              </customer>
              <customer FirstName="Mary" Zipcode="12345">
                     <order ID="555555">Server</order>
              </customer>
       </customers>'
declare @hdocs int
Exec sp_xml_preparedocument @hdocs output , @docs

select * from openxml (@hdocs, '//customer')
with (  FirstName varchar(10) '@FirstName' ,
		Zipcode int  '@Zipcode' ,
		OrderName varchar(10) 'order',
		OrderId int 'order/@ID' )

Exec sp_xml_removedocument @hdocs

-- 4.	find count of times that Khalid appeared after Ahmed in st_Fname column one time

declare c1 cursor 
for select s.St_Fname
	from Student s
for read only
declare @name varchar(20) , @count int =0
open c1
fetch c1 into @name
while @@FETCH_STATUS =0
	begin 
		if (@name = 'Ahmed')
			begin
				fetch c1 into @name
				if(@name = 'Khalid')
					set @count +=1
			end
		fetch c1 into @name 
	end
select @count
close c1
deallocate c1
select * from Student
--5.	Using cursor, reset every first name of student that is null to ‘no first name’.updates
declare c1 cursor 
for select s.St_Fname
	from Student s
for update
declare @name1 varchar(20)
open c1
fetch c1 into @name1
while @@FETCH_STATUS =0
	begin 
		if (@name1 is null)
			update Student
			set  St_Fname = 'no first name'
			where current of c1

		fetch c1 into @name1
	end
close c1
deallocate c1

select * from Student
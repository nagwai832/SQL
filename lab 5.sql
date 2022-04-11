--1. Write a query to rank the students according to their ages in each dept without gapping in ranking.use ITI
select * , Dense_rank() over (partition by [Dept_Id] order by s.St_Age desc)  as DR
from Student s
where s.Dept_Id is not null

--2. Divide the products into 30 segments according to their weight to handle some operations in shipment use AdventureWorks
select p.Name,p.Color, p.Weight, Ntile(30) over(order by p.Weight desc) NT
from [SalesLT].[Product] p
where p.Weight is not null
--3. Write a query to select the all highest two salaries for instructors in Each Department who have salaries. “using one of Ranking Functions”.use ITI
select * from
(select i.Dept_Id,i.Salary , Dense_Rank() over(partition by i.Dept_Id order by i.Salary desc ) as RN
from Instructor i
where i.Dept_Id is not null) as newTable
where RN <=2

--4.(important)Write a query to select the third project that took long time (works_for table). use Company_SD
--●	 try to redo it use CTE

--with cte1 as(select w.Pno, sum(w.Hours) as totalHour from Works_for w group by w.Pno)

with cte2
as(
	select * , Dense_Rank() over( order by totalHour desc ) as RN
	from (select w.Pno, sum(w.Hours) as totalHour from Works_for w group by w.Pno) as newTable
  )
select * from cte2
where RN = 3
--5. Try to create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen?
create nonclustered index ii
on [dbo].[Department]([Manager_hiredate])
--6. Try to create index that allow u to enter unique ages in student table.
--What will happen?
create view vindex with schemabinding
as 
	select s.St_Id , s.St_Fname , s.St_Age
	from [dbo].[Student] s
create unique clustered index iii
on vindex([St_Age])
--7.	create a non-clustered index on column(Dept_Manager) that allows you to enter a unique instructor id in the table Department.
create unique nonclustered index ii2
on [dbo].[Department]([Dept_Manager])
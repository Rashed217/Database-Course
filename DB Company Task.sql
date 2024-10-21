Use Company_SD

-- Display all the employees Data
Select * 
From Employee

-- Display the employee First name, last name, Salary and Department number
Select Fname, Lname, Salary, Dno
From Employee

-- Display all the projects names, locations and the department which is responsible about it
Select Pname, Plocation, Dnum
From Project

-- Display each employee full name and his annual commission in an ANNUAL COMM column (alias)
Select Fname + ' ' + Lname AS [Full Name], Salary * 0.1 AS [ANNUAL COMM]
From Employee


-- Display the employees Id, name who earns more than 1000 LE monthly
Select SSN, Fname + ' ' + Lname AS [Full Name]
From Employee
Where Salary > 1000

-- Display the employees Id, name who earns more than 10000 LE annually
Select SSN, Fname +  ' ' + Lname AS [Full Name]
From Employee
Where Salary > 10000

-- Display the names and salaries of the female employees
Select Fname + ' ' + Lname AS [Full Name], Salary
From Employee
Where Sex = 'f'

-- Display each department id, name which managed by a manager with id equals 968574.
Select Dnum, Dname
From Departments
Where MGRSSN = 968574

-- Dispaly the ids, names and locations of  the pojects which controled with department 10.
Select Pname, Pnumber, Plocation
From Project
Where Dnum = 10

-- Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
Insert into Employee
Values ('Rashed','Said',102013, 1999-06-23,'Sur','M',3000,112233,30)

-- Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or supervisor number to him.
Insert into Employee (Fname,lname,SSN,Bdate,Address,Sex,Dno )
Values ('Salem','Said',102660,1995-10-04,'Muscat','M',30)


-- Upgrade your salary by 20 % of its last value.
Update Employee
Set Salary+= Salary*0.2
Where SSN=102013


-------------------------------------------------------------------------
-- Joins

--1
Select Dname, Dnum, Fname
From Departments inner join Employee on MGRSSN = SSN


--2
Select Dname, Pname
From Departments D inner join Project P on D.Dnum = P.Dnum


--3
Select D.*,E.Fname
From Dependent D inner join Employee E on ESSN = SSN


--4
Select Pname, Pnumber, Plocation, City
From Project
Where City in ('Cairo', 'Alex')


--5
Select *
From Project
Where Pname like 'a%'


--6
Select *
From Employee
Where Dno = 10 and Salary between 1000 and 2000


--7
Select Fname +' '+ Lname as [Full Name]
From Employee inner join Works_for on SSN = ESSN and Hours >= 10 and Dno = 10
              inner join Project on Pno=Pnumber and Pname = 'Al rabwah'


--8
Select X.Fname +' '+ X.Lname as Employee
from Employee X inner join Employee Y On Y.SSN = X.Superssn
Where Y.Fname='kamel' and Y.Lname='mohamed'


--9
Select Fname, Pname
From Employee inner join Works_for on ESSN = SSN
              inner join Project on Pno = Pnumber
			  Order by Pname


--10
Select Pnumber, Dname, Lname, Address, Bdate
From Employee inner join Departments D on SSN = MGRSSN
              inner join Project P on P.Dnum = D.Dnum


-- 11
Select M.* 
From Employee M inner join Departments D on M.SSN = D.MGRSSN


--12
Select * 
From Employee E left join Dependent D on E.ssn=D.ESSN


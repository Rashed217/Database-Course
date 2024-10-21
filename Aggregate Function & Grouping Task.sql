Use Company_SD


--1 
Select Sum(W.Hours) as [Sum of Hours], P.Pname as [Project Name]
From Works_for W inner join Project P on W.Pno = P.Pnumber
Group by P.Pname


--2
Select D.Dname as [Dept. Name], Max(E.Salary) as [Max Salary], Min(E.Salary) as [Min Salary], AVG(E.Salary) as [Avg Salary]
From Departments D inner join Employee E on D.Dnum = E.Dno
Group by D.Dname
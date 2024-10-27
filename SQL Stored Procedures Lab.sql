Use ITI

--1. Stored procedure to show the number of students per department name.
Create Proc ShowStudentCountPerDepartment
AS
Begin try

    Select d.Dept_Name, COUNT(s.St_ID) AS StudentCount
    From Department d
    Left Join Student s ON d.Dept_ID = s.Dept_ID
    Group by d.Dept_Name
    Order by d.Dept_Name;
End try

Begin catch
    Select 'Error',ERROR_MESSAGE()
End catch

exec ShowStudentCountPerDepartment

--2. Stored procedure to check the number of employees in project

Use Company_SD


Create Proc CheckEmployeesInProject
AS
Begin

  Declare @EmployeeCount INT;
  Select @EmployeeCount = COUNT(*)
  From Works_for W
  Where W.Pno = 100;


  If @EmployeeCount >= 3
    Begin
      Select 'The number of employees in the project 100 is 3 or more';
    End
  Else
    Begin
      Select 'The following employees work for the project 100';

      Select Fname, Lname
      From Employee E
      Where E.SSN IN (Select Essn From Works_for W Where W.Pno = 100);
    End
End;

exec CheckEmployeesInProject



--3. Stored procedure to update the works_on table when an employee leaves a project and a new employee replaces them.

Create Proc UpdateEmployeeOnProject (
    @OldEmployeeID Int,
    @NewEmployeeID Int,
    @ProjectNumber Int
)
AS
Begin

    If Exists (Select 1 From Works_for Where Essn = @OldEmployeeID AND Pno = @ProjectNumber)
    Begin

        Update Works_for
        Set Essn = @NewEmployeeID
        Where Essn = @OldEmployeeID AND Pno = @ProjectNumber;


        Select 'Employee on project updated successfully.';
    End
    Else
    Begin

        Select 'Error: Old employee not found in the works_on table.';
    End
End

Exec UpdateEmployeeOnProject




--4. Add the Budget column to the Project table
Alter Table Project
Add Budget int;


Update Project
SET Budget = 100000
WHERE Pnumber = 100;

Update Project
Set Budget = 200000
Where Pnumber = 200;

Update Project
Set Budget = 50000
Where Pnumber = 300;


Create Table Audit (
    ProjectNo int NOT NULL,
    UserName VARCHAR(50) NOT NULL,
    ModifiedDate DATE NOT NULL,
    Budget_Old int,
    Budget_New int
);


Create Trigger TR_Project_Budget_Update
ON Project
After Update
AS
Begin

    If Update(Budget)
    Begin

        Insert into Audit (ProjectNo, UserName, ModifiedDate, Budget_Old, Budget_New)
        SELECT
            i.ProjectNo,
			i.UserName,
            GETDATE(),
            d.Budget,
            i.Budget
        FROM inserted i
        JOIN deleted d ON i.Pnumber = d.Pnumber;
    END
END;


Update Project
Set Budget = 250000
Where ProjectNo = 200;

Select * From Audit;



--5. Create a trigger to prevent inserts into the Department table
Create Trigger TR_PreventDepartmentInsert
On Departments
Instead of insert
AS
Begin

    RaisError('You are not allowed to insert a new record into the Department table.', 16, 1)
    Return
End



--6. Create a trigger that prevents the insertion Process for Employee table in March [Company DB].

Create Trigger Prevent_Insertion_In_March
On Employee
Instead of insert
AS
Begin
   
   If Month(GetDate()) = 3
   Begin
   RaisError('Employee insertion is not allowed in March', 16, 1)
   Return
   End

   Insert into Employee
   Select *
   From Inserted
End


--7. Create a trigger on student table instead of delete to add Row in Student Audit table

Create Table StudentAudit (
    ServerUserName Varchar(30) not null,
    Date DateTime not null,
    Note Varchar(300)
);

Create Trigger TR_Student_Insert
ON Student
After Insert
AS
Begin

    Declare @InsertedUserName Varchar(30);
    Declare @InsertedStudentID Int;
    Declare @Note Varchar(300);

    Select @InsertedUserName = St_Fname,
           @InsertedStudentID = St_Id
    From inserted;

	Set @Note = CONCAT(SUSER_NAME(), ' inserted a new row with key = ', @InsertedStudentID, ' in table Student.');


    Insert into StudentAudit
    Values (SUSER_NAME(), GETDATE(), @Note);

End;



--8.  Create a trigger on student table instead of delete to add Row in Student Audit table.

Create Trigger TR_Student_Delete
On Student
Instead of Delete
AS
Begin

    Declare @StudentID INT;
    Select @StudentID = St_ID
    From deleted;


    Insert into StudentAudit (ServerUserName, [Date], Note)
    Values (SUSER_NAME(), GETDATE(), 'Try to delete Row with Key=' + CAST(@StudentID AS Varchar));

End;


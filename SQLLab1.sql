Create Database SQLLab1

Use SQLLab1

Create Table Instructor (
    ID int primary key identity (1, 1),
    FirstName varchar(15),
    LastName varchar(15),
    Salary int,
    OverTime int,
    BirthDate Date,
    hiredate Date Default GetDate(),
    Address varchar(100),
    Age AS (Year(GetDate()) - Year(BirthDate)),
    NetSalary AS (Salary + OverTime)
);


Create Table Course (

    InstructorID int,
    CID int primary key identity (1, 1),
	CName varchar(25),
	Duration int,
	Foreign key (InstructorID) References Instructor(ID),
);


Create Table Lab (

    CourseID int,
    LID int primary key identity (1, 1),
	Location varchar(100),
	Capacity int check (Capacity <= 20),
	Foreign key (CourseID) References Course(CID),
);


Create Table Teach (

    InstructorID int,
	CourseID int,
	Primary key (InstructorID, CourseID),
	Foreign key (InstructorID) References Instructor(ID),
	Foreign key (CourseID) References Course(CID),
);


Alter Table Instructor
Add constraint CK_Salary Check (Salary Between 1000 and 5000);


Alter Table Instructor
Add constraint UQ_OverTime Unique (OverTime);


Alter Table Course
Add constraint UQ_Duration Unique (Duration);




BACKUP DATABASE SQLLab1
TO DISK = 'C:\Users\Codeline User\Documents\Codeline Projects\Database Projects\SQLLab1.bak'
WITH FORMAT, 
     INIT, 
     COMPRESSION, 
     STATS = 10;
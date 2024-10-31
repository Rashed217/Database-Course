Use Database_Project

Create Table Hotels (
   HotelID int identity primary key,
   HName Varchar(30) not null Unique,
   Location Varchar(255) not null,
   ContactNumber Varchar(15) not null,
   Rating decimal (2, 1) Check (Rating between 1 and 5)
);


Create Table Rooms (
   RoomID int identity primary key,
   RoomNumber Varchar(10) not null Unique,
   RoomType Varchar(20) not null Check (RoomType in ('Single', 'Double' , 'Suite')),
   PricePerNight decimal(10, 2) not null Check (PricePerNight > 0),
   IsAvailable bit not null default 1,
   HotelID int not null,
   Foreign key (HotelID) References Hotels (HotelID) on delete cascade on update cascade
);


Create Table Guests (
   GuestID int identity primary key,
   GName Varchar(30) not null,
   ContactNo Varchar(50) not null,
   IDProofType Varchar (50) not null,
   IDProofNumber Varchar(50) not null
);


Create Table Bookings (
   BookingID int identity primary key,
   BookingDate Date not null,
   CheckInDate Date not null,
   CheckOutDate Date not null,
   Status Varchar(20) not null Check (Status in ('Pending' , 'Confirmed' , 'Canceled'  , 'CheckIn' , 'CheckOut')),
   TotalCost decimal (10, 2) not null,
   RoomID int not null,
   GuestID int not null,
   Foreign key (RoomID) References Rooms (RoomID) on delete cascade on update cascade,
   Foreign key (GuestID) References Guests (GuestID) on delete cascade on update cascade
);


Create Table Payment (
   PaymentID int identity Primary key,
   PaymentDate Date not null,
   Amount decimal (10 ,2) not null Check (Amount > 0),
   Method Varchar(50) not null,
   BookingID int not null,
   Foreign key (BookingID) References Bookings (BookingID) on delete cascade on update cascade
);


Create Table Staff (
   StaffID int identity primary key,
   SName Varchar(30) not null,
   Position Varchar(100) not null,
   ContactNumber Varchar(15) not null,
   HotelID int not null,
   Foreign key (HotelID) References Hotels (HotelID) on delete cascade on update cascade
);



Create Table Reviews (
   ReviewID int identity primary key,
   RRating int not null Check (RRating Between 1 and 5),
   Comments Varchar(1000)  not null,
   ReviewDate Date not null,
   HotelID int not null,
   GuestID int  not null,
   Foreign key (HotelID) References Hotels (HotelID) on delete cascade on update cascade,
   Foreign key (GuestID) References Guests (GuestID) on delete cascade on update cascade
);


Create Trigger CheckInOutDates
 on Bookings
 After insert, Update
 as
 Begin
     If exists (
	   Select * From Bookings
	   Where CheckInDate > CheckOutDate
	 )

	 Begin
	    Raiserror ('CheckInDate must be less than or equal to CheckOutDate.', 16, 1);
		Rollback transaction;
	End
End;


-- Insert sample data into Hotels
INSERT INTO Hotels (HName, Location, ContactNumber, Rating)
VALUES 
('Grand Plaza', 'New York', '123-456-7890', 4.5),
('Royal Inn', 'London', '234-567-8901', 4.0),
('Ocean Breeze', 'Miami', '456-789-0123', 4.2),
('Mountain Retreat', 'Denver', '567-890-1234', 3.9),
('City Lights Hotel', 'Las Vegas', '678-901-2345', 4.7),
('Desert Oasis', 'Phoenix', '789-012-3456', 4.3),
('Lakeview Lodge', 'Minnesota', '890-123-4567', 4.1),
('Sunset Resort', 'California', '345-678-9012', 3.8);

-- Insert sample data into Rooms
INSERT INTO Rooms (HotelID, RoomNumber, RoomType, PricePerNight, IsAvailable)
VALUES 
(1, 101, 'Single', 100, 1),
(1, 102, 'Double', 150, 1),
(1, 103, 'Suite', 300, 1),
(2, 201, 'Single', 90, 1),
(2, 202, 'Double', 140, 0),
(3, 301, 'Suite', 250, 1),
(4, 401, 'Single', 120, 1),
(4, 402, 'Double', 180, 1),
(5, 501, 'Suite', 350, 1),
(5, 502, 'Single', 130, 0),
(6, 601, 'Double', 200, 1),
(6, 602, 'Suite', 400, 0),
(7, 701, 'Single', 110, 1),
(7, 702, 'Double', 160, 1),
(8, 801, 'Suite', 380, 1),
(8, 802, 'Single', 140, 1);

-- Insert sample data into Guests
INSERT INTO Guests (GName, ContactNo, IDProofTyep, IDProofNumber)
VALUES 
('John Doe', '567-890-1234', 'Passport', 'A1234567'),
('Alice Smith', '678-901-2345', 'Driver License', 'D8901234'),
('Robert Brown', '789-012-3456', 'ID Card', 'ID567890'),
('Sophia Turner', '012-345-6789', 'Passport', 'B2345678'),
('James Lee', '123-456-7890', 'ID Card', 'ID890123'),
('Emma White', '234-567-8901', 'Driver License', 'DL3456789'),
('Daniel Kim', '345-678-9012', 'Passport', 'C3456789'),
('Olivia Harris', '456-789-0123', 'ID Card', 'ID234567'),
('Noah Brown', '567-890-1234', 'Driver License', 'DL4567890'),
('Ava Scott', '678-901-2345', 'Passport', 'D4567890'),
('Mason Clark', '789-012-3456', 'ID Card', 'ID345678');

-- Insert sample data into Bookings
INSERT INTO Bookings (GuestID, RoomID, BookingDate, CheckInDate, CheckOutDate, Status, TotalCost)
VALUES 
(1, 1, '2024-10-01', '2024-10-05', '2024-10-10', 'Confirmed', 500),
(2, 2, '2024-10-15', '2024-10-20', '2024-10-25', 'Pending', 750),
(3, 3, '2024-10-05', '2024-10-07', '2024-10-09', 'CheckIn', 600),
(4, 4, '2024-10-10', '2024-10-12', '2024-10-15', 'Confirmed', 360),
(5, 5, '2024-10-16', '2024-10-18', '2024-10-21', 'Pending', 540),
(6, 6, '2024-10-05', '2024-10-08', '2024-10-12', 'CheckIn', 800),
(7, 7, '2024-10-22', '2024-10-25', '2024-10-28', 'Confirmed', 450),
(8, 8, '2024-10-15', '2024-10-18', '2024-10-20', 'Pending', 420),
(1, 9, '2024-10-25', '2024-10-27', '2024-10-29', 'Confirmed', 340),
(2, 10, '2024-10-19', '2024-10-21', '2024-10-24', 'CheckIn', 480);

-- Insert sample data into Payments
INSERT INTO Payment (BookingID, PaymentDate, Amount, Method)
VALUES 
(1, '2024-10-02', 250, 'Credit Card'),
(1, '2024-10-06', 250, 'Credit Card'),
(2, '2024-10-16', 750, 'Debit Card'),
(4, '2024-10-11', 180, 'Credit Card'),
(4, '2024-10-14', 180, 'Credit Card'),
(5, '2024-10-17', 270, 'Debit Card'),
(5, '2024-10-20', 270, 'Credit Card'),
(6, '2024-10-06', 400, 'Cash'),
(6, '2024-10-09', 400, 'Credit Card'),
(7, '2024-10-23', 450, 'Debit Card');

-- Insert sample data into Staff
INSERT INTO Staff (SName, Position, ContactNumber, HotelID)
VALUES 
('Michael Johnson', 'Manager', '890-123-4567', 1),
('Emily Davis', 'Receptionist', '901-234-5678', 2),
('David Wilson', 'Housekeeper', '012-345-6789', 3),
('Laura Thompson', 'Manager', '901-234-5678', 4),
('Ryan Foster', 'Receptionist', '012-345-6789', 5),
('Sophia Roberts', 'Housekeeper', '123-456-7890', 6),
('Ethan Walker', 'Chef', '234-567-8901', 7),
('Liam Mitchell', 'Security', '345-678-9012', 8),
('Isabella Martinez', 'Manager', '456-789-0123', 1);

-- Insert sample data into Reviews
INSERT INTO Reviews (GuestID, HotelID, RRating, Comments, ReviewDate)
VALUES 
(1, 1, 5, 'Excellent stay!', '2024-10-11'),
(2, 2, 4, 'Good service, but room was small.', '2024-10-26'),
(3, 3, 3, 'Average experience.', '2024-10-12'),
(4, 1, 4, 'Good experience, but room service was slow.', '2024-10-16'),
(5, 2, 5, 'Amazing ambiance and friendly staff.', '2024-10-20'),
(6, 3, 3, 'Decent stay, but room cleanliness needs improvement.', '2024-10-25'),
(7, 4, 4, 'Great location, will visit again!', '2024-10-27'),
(8, 5, 2, 'Not satisfied with the facilities.', '2024-10-29'); 




--- Indexes ---


-- For hotels Table

Create nonclustered index IND_Hotel_Name on Hotels(HName);
Create nonclustered index IND_Hotels_Rating on Hotels(Rating);


-- For Rooms Table

Create nonclustered index IND_Room_HotelID_RoomNumber on Rooms(HotelID, RoomNumber);
Create nonclustered index IND_Room_RoomType on Rooms (RoomType);


-- For Bookings Table

Create nonclustered index IND_Booking_GuestID on Bookings (GuestID);
Create nonclustered index IND_Booking_Status on Bookings (Status);
Create nonclustered index IND_Bookings_Room_CheckIn_CheckOut on Bookings (RoomID, CheckInDate, CheckOutDate);




--- Views ---

-- View for top-rated Hotels

Create view ViewTopRatedHotels as

   Select H.HotelID, H.HName,
   Count(R.RoomID) as TotalRooms,
   AVG(R.PricePerNight) as AvarageRoomPrice
   From Hotels H
   Join Rooms R on H.HotelID = R.HotelID
   WHere H.Rating > 4.5
   Group by H.HotelID, H.HName;

   Select * from ViewTopRatedHotels


-- View for Guests Bookings

Create View ViewGuestsBookings as

  Select G.GuestID, G.GName,
  Count (B.BookingID) as TotalBookings,
  Sum (B.TotalCost) as TotalSpent
  From Guests G
  Left Join Bookings B on G.GuestID = B.GuestID
  Group by G.GuestID, G.GName;

  Select * from ViewGuestsBookings

-- View for Available Rooms

Create View ViewAvailableRooms as
  
  Select
     H.HotelID,
	 H.HName as HotelName,
	 R.RoomType,
	 R.RoomNumber,
	 R.PricePerNight
  From Rooms R
  Join Hotels H on R.HotelID = H.HotelID
  Where R.IsAvailable = 1

  Select * from ViewAvailableRooms



-- View for Bookings Summery


Create View ViewBookingSummery as

  Select
    H.HotelID,
	H.HName as HotelName,

  Count (B.BookingID) as TotalBookings, 
  Sum (Case when B.Status = 'Confirmed' then 1 else 0 end) as ConfirmedBookings,
  Sum (Case when B.Status = 'Pending' then 1 else 0 end) as PendingBookings,
  Sum (Case when B.Status = 'Canceled' then 1 else 0 end) as CanceledBookings

  From Hotels H
  Left Join Bookings B on H.HotelID = B.RoomID
  Group by H.HotelID, H.HName; 

  Select * from ViewBookingSummery


-- View for Payment History

Create View ViewPaymentHistory as

  Select
    P.PaymentID,
	G.GName as GuestName,
	H.Hname as HotelName,
	B.Status as BookingStatus,
	P.Amount as totalPayment

  From Payment P
  Join Bookings B on P.BookingID = B.BookingID
  Join Guests G on B.GuestID = G.GuestID
  Join Hotels H on B.RoomID = H.HotelID;

  Select * from ViewPaymentHistory


--- Functions ---


-- Function for average rating for hotels

Create Function GetHotelAverageRating (@HotelID int)
  Returns decimal (3, 2) as
  Begin
    Declare @AvgRating decimal (3, 2);
	Select @AvgRating = AVG(RRating)
	From Reviews
	Where HotelID = @HotelID;
	Return @AvgRating;
End;



-- Function to get the next available room of a specific type within a hotel

Create Function GetNextAvailableRoom (@HotelID int, @RoomType Varchar(50))
   Returns int as

 Begin
   Declare @RoomID int;
   Select top 1 @RoomID = @RoomID
   From Rooms
   Where HotelID = @HotelID and RoomType = @RoomType and IsAvailable = 1;
   Return @RoomID;
End;



-- Function to calculate occupancy rate for a hotel

Create Function CalculateOccupancyRate (@HotelID int)
   Returns decimal (5, 2) as
   Begin
      Declare @OccupancyRate decimal (5, 2);
	  Declare @TotalRooms int;
	  Declare @OccupiedRooms int;
	  
	  Select @TotalRooms = Count(*) from Rooms
	  Where HotelID = @HotelID;

	  Select @OccupiedRooms = Count(*) from Bookings B
	  Where B.RoomID in (Select RoomID from Rooms Where HotelID = @HotelID)
	  And b.CheckInDate <= GetDate() and B.CheckOutDate <= GetDate();

	  If @TotalRooms = 0
	    Set @OccupancyRate = 0;
	  Else
	    Set @OccupancyRate = (@OccupiedRooms * 100.0 / @TotalRooms);

		Return @OccupancyRate;
End;




--- Stored Procedures ---

-- Stored Procedure to mark room as unavailable 

Create Proc sp_MarkRoomUnavailable @RoomID int as

Begin
  Update Rooms
  Set IsAvailable = 0
  Where RoomID = @RoomID;
End;


-- Stored Procedure to update booking status

Create Proc sp_UpdateBookingStatus @BookingID int, @NewStatus Varchar(50) as

  Begin
    Update Bookings
	Set Status = @NewStatus
	Where BookingID = @BookingID
End;


-- Stored Procedure to rank guests by total spending

Create Proc sp_RankGuestsBySpending as
  Begin
  Select G.GuestID, G.GName,
  Sum(B.TotalCost) as TotalSpent,
  Rank() Over (Order by Sum(B.TotalCost) Desc) as Rank
  From Guests G
  Left Join Bookings B on G.GuestID = B.GuestID
  Group by G.GuestID, G.GName;
End;



--- Triggers ---

-- Trigger to update room availability

Create Trigger UpdateRoomAvailability

   On Bookings
   After insert
   as
   Begin
     Update Rooms
	 Set IsAvailable = 0
	 Where RoomID in (Select RoomID from inserted);
End;



-- Trigger to calculate total revenue for a hotel

Create Trigger CalculateTotalRevenue

  On Payment
  After insert
  as
  Begin
    Declare @HotelID int;
	Declare @TotalRevenue decimal(10, 2);

	Select @HotelID = B.HotelID
	From Bookings B
	Join inserted I on B.BookingID = I.BookingID;

	Select @TotalRevenue = Sum(Amount)
	From Payment
	Where BookingID in (Select BookingID from Bookings where HotelID = @HotelID);
End;



-- Trigger to check booking date validation

Create Trigger CheckInDateValidation

  On Bookings
  Instead of insert
  as
  Begin
    If exists (Select 1 from inserted where CheckInDate > CheckOutDate)
	Begin
	  Raiserror ('Check-in date must be less than or equal to Check-out date.', 16, 1);
	  Rollback transaction;
	End;

	Else
	Begin
	  Insert into Bookings (BookingDate, CheckInDate, CheckOutDate, Status, TotalCost, RoomID, GuestID)
	  Select
	    BookingDate,
		CheckInDate,
		CheckOutDate,
		Status,
		TotalCost,
		RoomID,
		GuestID
	  From inserted;
	End
End;
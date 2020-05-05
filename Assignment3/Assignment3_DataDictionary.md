# Assignment 3 – Speeding Ticket Database Design

## Data Dictionary

__Author: Laercio M da Silva Jr__

__Date: 02/02/2020__

__Changed: 04/14/2020__

### User

|Key    |Name         |Type    |Size|Default  |Description                |Sample Data       |
|-------|-------------|--------|----|---------|---------------------------|------------------|
|PK     |UserID       |INT     |11  |IDENTITY |Unique sequential integer. |123456            |
|*IX*   |FirstName    |NVARCHAR|32  |-        |User's first name.         |Laercio           |
|*IX*   |LastName     |NVARCHAR|32  |-        |User's last name.          |Silva             |
|-      |Photo        |IMAGE   |-   |NULL     |User's ID photo.           |_image.jpg_       |
|-      |PhoneNumber  |*NCHAR* |11  |-        |User's phone number.       |17828821234       |
|*CK*   |EmailAddress |NVARCHAR|32  |-        |User's email address.      |laercio@gmail.com |
|-      |BirthDate    |DATE    |-   |-        |User's birth date.         |1991-03-09        |
|*UQ/IX*|Username     |NVARCHAR|32  |-        |User's username to access. |LaercioSilva      |
|*CK/DF*|Password     |NVARCHAR|32  |-        |User's password to access. |ABCDEF12          |

### Staff

|Key    |Name         |Type    |Size|Default  |Description                 |Sample Data       |
|-------|-------------|--------|----|---------|----------------------------|------------------|
|PK     |StaffID      |INT     |11  |IDENTITY |Unique sequential integer.  |123456            |
|*IX*   |FirstName    |NVARCHAR|32  |-        |Staff's first name.         |John              |
|*IX*   |LastName     |NVARCHAR|32  |-        |Staff's last name.          |Seinfield         |
|-      |Photo        |IMAGE   |-   |NULL     |Staff's ID photo.           |_image.jpg_       |
|-      |PhoneNumber  |*NCHAR* |11  |-        |Staff's phone number.       |17828829876       |
|*CK*   |EmailAddress |NVARCHAR|32  |-        |Staff's email address.      |john_s@staff.com  |
|-      |BirthDate    |DATE    |-   |-        |Staff's birth date.         |1985-11-01        |
|*UQ/IX*|Username     |NVARCHAR|32  |-        |Staff's username to access. |JohnSeinfield     |
|*CK/DF*|Password     |NVARCHAR|32  |-        |Staff's password to access. |ABCDEF12          |

### Hardware

|Key |Name            |Type    |Size|Default  |Description                |Sample Data       |
|----|----------------|--------|----|---------|---------------------------|------------------|
|PK  |HardwareID      |INT     |11  |IDENTITY |Unique sequential integer. |123456            |
|-   |Description     |NVARCHAR|80  |-        |Hardware description.      |Mouse Optical USB |
|-   |Category        |NVARCHAR|32  |-        |Hardware category.         |Mouse             |
|-   |Brand           |NVARCHAR|32  |-        |Hardware brand.            |Razer             |
|*DF*|AcquisitionDate |DATE    |-   |-        |Hardware acquisition date. |2018-11-15        |
|-   |WarrantyDate    |DATE    |-   |-        |Hardware warranty date.    |2019-11-15        |
|*IX*|SerialCode      |NVARCHAR|32  |-        |Hardware serial code.      |MOU58768524A      |

### Category

|Key|Name            |Type    |Size|Default  |Description                |Sample Data          |
|---|----------------|--------|----|---------|---------------------------|---------------------|
|PK |CategoryID      |INT     |11  |IDENTITY |Unique sequential integer. |123456               |
|-  |Description     |NVARCHAR|32  |-        |Category description.      |Software - MS Office |
|-  |SLA             |NVARCHAR|32  |-        |Category SLA.              |Medium Priority      |

### Ticket

|Key |Name        |Type     |Size|Default  |Description                 |Sample Data          |
|----|------------|---------|----|---------|----------------------------|---------------------|
|PK  |TicketID    |INT      |11  |IDENTITY |Unique sequential integer.  |123456               |
|-   |Description |NVARCHAR |255 |-        |Ticket description.         |Mouse doens`t work...|
|*DF*|StartDate   |DATETIME2|-   |-        |Ticket start date.          |2020-01-26 14:12:20  |
|-   |SLA         |DATETIME2|-   |-        |Ticket SLA date.            |2020-01-28 14:12:20  |
|*DF*|Status      |NVARCHAR |32  |-        |Ticket status.              |Open                 |
|-   |EndDate     |DATETIME2|-   |NULL     |Ticket end date.            |2020-01-27 09:47:00  |
|FK  |UserID      |INT      |11  |NULL     |User ID (from User)         |123456               |
|FK  |CategoryID  |INT      |11  |-        |Category ID (from Category) |123456               |
|FK  |HardwareID  |INT      |11  |NULL     |Hardware ID (from Hardware) |123456               |

### Comment

|Key |Name        |Type     |Size|Default  |Description                 |Sample Data             |
|----|------------|---------|----|---------|----------------------------|------------------------|
|PK  |CommentID   |INT      |11  |IDENTITY |Unique sequential integer.  |123456                  |
|-   |Description |NVARCHAR |255 |-        |Comment description.        |I called the user but...|
|*DF*|Date        |DATETIME2|-   |-        |Comment creation date.      |2020-01-26 15:10:50     |
|FK  |TicketID    |INT      |11  |-        |Ticket ID (from Ticket)     |123456                  |
|FK  |UserID      |INT      |11  |NULL     |User ID (from User)         |123456                  |
|FK  |StaffID     |INT      |11  |NULL     |Staff ID (from Staff)       |123456                  |

__The table below was created in the most recent version of the database__

### Task

|Key|Name        |Type     |Size|Default  |Description             |Sample Data         |
|---|------------|---------|----|---------|------------------------|--------------------|
|PK |TaskID      |INT      |11  |-        |Ticket ID (from Ticket) |123456              |
|   |Description |NVARCHAR |255 |-        |Task description        |Install Software    |
|FK |TicketID    |INT      |-   |-        |Ticket ID (from Ticket) |123456              |
|FK |StaffID     |INT      |-   |NULL     |Staff ID (from Staff)   |123456              |

### TicketStaff

|Key   |Name            |Type     |Size|Default  |Description               |Sample Data         |
|------|----------------|---------|----|---------|--------------------------|--------------------|
|PK/FK |TicketID        |INT      |11  |-        |Ticket ID (from Ticket)   |123456              |
|PK/FK |StaffID         |INT      |11  |-        |Staff ID (from Staff)     |123456              |
|      |AssignedDate    |DATETIME2|-   |-        |Assigned date.            |2020-01-26 14:12:20 |
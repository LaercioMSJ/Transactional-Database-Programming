USE master;
GO


-- create the database
DROP DATABASE IF EXISTS SpeedingTickets;
CREATE DATABASE SpeedingTickets;
GO


USE SpeedingTickets;
GO


-- create the tables
DROP TABLE IF EXISTS "User";
CREATE TABLE "User"
(
    UserID        INT IDENTITY  NOT NULL,
    FirstName     NVARCHAR(32)  NOT NULL,
    LastName      NVARCHAR(32)  NOT NULL,
    Photo         IMAGE         NULL,
    PhoneNumber   NCHAR(11)     NOT NULL,
    EmailAddress  NVARCHAR(32)  NOT NULL,
    BirthDate     DATE          NOT NULL,
    Username      NVARCHAR(32)  NOT NULL,
    Password      NVARCHAR(32)  NOT NULL,
    PRIMARY KEY (UserID)
);

DROP TABLE IF EXISTS Staff;
CREATE TABLE Staff
(
    StaffID       INT IDENTITY  NOT NULL,
    FirstName     NVARCHAR(32)  NOT NULL,
    LastName      NVARCHAR(32)  NOT NULL,
    Photo         IMAGE         NULL,
    PhoneNumber   NCHAR(11)     NOT NULL,
    EmailAddress  NVARCHAR(32)  NOT NULL,
    BirthDate     DATE          NOT NULL,
    Username      NVARCHAR(32)  NOT NULL,
    Password      NVARCHAR(32)  NOT NULL,
    PRIMARY KEY (StaffID)
);

DROP TABLE IF EXISTS Hardware;
CREATE TABLE Hardware
(
    HardwareID       INT IDENTITY  NOT NULL,
    Description      NVARCHAR(80)  NOT NULL,
    Category         NVARCHAR(32)  NOT NULL,
    Brand            NVARCHAR(32)  NOT NULL,
    AcquisitionDate  DATE          NOT NULL,
    WarrantyDate     DATE          NOT NULL,
    SerialCode       NVARCHAR(32)  NOT NULL,
    PRIMARY KEY (HardwareID)
);

DROP TABLE IF EXISTS Category;
CREATE TABLE Category
(
    CategoryID   INT IDENTITY  NOT NULL,
    Description  NVARCHAR(32)  NOT NULL,
    SLA          NVARCHAR(32)  NOT NULL,
    PRIMARY KEY (CategoryID)
);

DROP TABLE IF EXISTS Ticket;
CREATE TABLE Ticket
(
    TicketID     INT IDENTITY   NOT NULL,
    Title        NVARCHAR(80)   NOT NULL,
    Description  NVARCHAR(255)  NOT NULL,
    StartDate    DATETIME2      NOT NULL,
    SLA          DATETIME2      NOT NULL,
    Status       NVARCHAR(32)   NOT NULL,
    EndDate      DATETIME2      NULL,
    UserID       INT            NULL,
    CategoryID   INT            NOT NULL,
    HardwareID   INT            NULL,
    PRIMARY KEY (TicketID)
);

DROP TABLE IF EXISTS Comment;
CREATE TABLE Comment
(
    CommentID    INT IDENTITY   NOT NULL,
    Description  NVARCHAR(255)  NOT NULL,
    Date         DATETIME2      NOT NULL,
    TicketID     INT            NOT NULL,
    UserID       INT            NULL,
    StaffID      INT            NULL,
    PRIMARY KEY (CommentID)
);

DROP TABLE IF EXISTS Task;
CREATE TABLE Task
(
    TaskID       INT IDENTITY   NOT NULL,
    Description  NVARCHAR(255)  NOT NULL,
    TicketID     INT            NOT NULL,
    StaffID      INT            NULL,
    PRIMARY KEY (TaskID)
);

DROP TABLE IF EXISTS TicketStaff;
CREATE TABLE TicketStaff
(
    StaffID       INT           NOT NULL,
    TicketID      INT           NOT NULL,
    AssignedDate  DATETIME2     NOT NULL
);


-- create relationships
ALTER TABLE Ticket
    DROP CONSTRAINT IF EXISTS FK__User__UserID_T;
ALTER TABLE Ticket
    ADD CONSTRAINT FK__User__UserID_T
    FOREIGN KEY (UserID) REFERENCES "User" (UserID)
    ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE Ticket
    DROP CONSTRAINT IF EXISTS FK__Category__CategoryID_T;
ALTER TABLE Ticket
    ADD CONSTRAINT FK__Category__CategoryID_T
    FOREIGN KEY (CategoryID) REFERENCES Category (CategoryID)
    ON DELETE NO ACTION ON UPDATE CASCADE;

ALTER TABLE Ticket
    DROP CONSTRAINT IF EXISTS FK__Hardware__HardwareID_T;
ALTER TABLE Ticket
    ADD CONSTRAINT FK__Hardware__HardwareID_T
    FOREIGN KEY (HardwareID) REFERENCES Hardware (HardwareID)
    ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE Comment
    DROP CONSTRAINT IF EXISTS FK__Ticket__TicketID_C;
ALTER TABLE Comment
    ADD CONSTRAINT FK__Ticket__TicketID_C
    FOREIGN KEY (TicketID) REFERENCES Ticket (TicketID)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Comment
    DROP CONSTRAINT IF EXISTS FK__User__UserID_C;
ALTER TABLE Comment
    ADD CONSTRAINT FK__User__UserID_C
    FOREIGN KEY (UserID) REFERENCES "User" (UserID);
    --ON DELETE SET NULL ON UPDATE CASCADE; It was necessary to comment this line So that the error "multiple cascade paths" did not occur but now it is impossible to delete a user who has a ticket and comment

ALTER TABLE Comment
    DROP CONSTRAINT IF EXISTS FK__Staff__StaffID_C;
ALTER TABLE Comment
    ADD CONSTRAINT FK__Staff__StaffID_C
    FOREIGN KEY (StaffID) REFERENCES Staff (StaffID)
    ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE Task
    DROP CONSTRAINT IF EXISTS FK__Ticket__TicketID_Ta;
ALTER TABLE Task
    ADD CONSTRAINT FK__Ticket__TicketID_Ta
    FOREIGN KEY (TicketID) REFERENCES Ticket (TicketID)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Task
    DROP CONSTRAINT IF EXISTS FK__Staff__StaffID_Ta;
ALTER TABLE Task
    ADD CONSTRAINT FK__Staff__StaffID_Ta
    FOREIGN KEY (StaffID) REFERENCES Staff (StaffID)
    ON DELETE SET NULL ON UPDATE CASCADE;


-- create composite key in the TicketStaff table
ALTER TABLE TicketStaff
    DROP CONSTRAINT IF EXISTS PK__TicketStaff;
ALTER TABLE TicketStaff
    ADD CONSTRAINT PK__TicketStaff
    PRIMARY KEY (StaffID, TicketID);

ALTER TABLE TicketStaff
    DROP CONSTRAINT IF EXISTS FK__Staff_StaffID_TS;
ALTER TABLE TicketStaff
    ADD CONSTRAINT FK__Staff_StaffID_TS
    FOREIGN KEY (StaffID) REFERENCES Staff (StaffID)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE TicketStaff
    DROP CONSTRAINT IF EXISTS FK__Ticket_TicketID_TS;
ALTER TABLE TicketStaff
    ADD CONSTRAINT FK__Ticket_TicketID_TS
    FOREIGN KEY (TicketID) REFERENCES Ticket (TicketID)
    ON DELETE CASCADE ON UPDATE CASCADE;


-- create check constraint
ALTER TABLE "User"
    DROP CONSTRAINT IF EXISTS CK__User__EmailAddress;
ALTER TABLE "User"
    ADD CONSTRAINT CK__User__EmailAddress CHECK (EmailAddress LIKE '%_@_%.__%');

ALTER TABLE "User"
    DROP CONSTRAINT IF EXISTS CK__User__Password;
ALTER TABLE "User"
    ADD CONSTRAINT CK__User__Password CHECK (Password LIKE '[A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9]');


ALTER TABLE Staff
    DROP CONSTRAINT IF EXISTS CK__Staff__EmailAddress;
ALTER TABLE Staff
    ADD CONSTRAINT CK__Staff__EmailAddress CHECK (EmailAddress LIKE '%_@_%.__%');

ALTER TABLE Staff
    DROP CONSTRAINT IF EXISTS CK__Staff__Password;
ALTER TABLE Staff
    ADD CONSTRAINT CK__Staff__Password CHECK (Password LIKE '[A-Z][A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9]');


-- create unique constraint
ALTER TABLE "User"
    DROP CONSTRAINT IF EXISTS UQ__User__Username;
ALTER TABLE "User"
    ADD CONSTRAINT UQ__User__Username UNIQUE (Username);

ALTER TABLE Staff
    DROP CONSTRAINT IF EXISTS UQ__Staff__Username;
ALTER TABLE Staff
    ADD CONSTRAINT UQ__Staff__Username UNIQUE (Username);


-- create default constraint
ALTER TABLE "User"
    DROP CONSTRAINT IF EXISTS DF__User__Password;
ALTER TABLE "User"
    ADD CONSTRAINT DF__User__Password DEFAULT ('ABCDEF12') FOR Password;


ALTER TABLE Staff
    DROP CONSTRAINT IF EXISTS DF__Staff__Password;
ALTER TABLE Staff
    ADD CONSTRAINT DF__Staff__Password DEFAULT ('ABCDEF12') FOR Password;


ALTER TABLE Hardware
    DROP CONSTRAINT IF EXISTS DF__Hardware__AcquisitionDate;
ALTER TABLE Hardware
    ADD CONSTRAINT DF__Hardware__AcquisitionDate DEFAULT (GetDate()) FOR AcquisitionDate;


ALTER TABLE Ticket
    DROP CONSTRAINT IF EXISTS DF__Ticket__StartDate;
ALTER TABLE Ticket
    ADD CONSTRAINT DF__Ticket__StartDate DEFAULT (GetDate()) FOR StartDate;

ALTER TABLE Ticket
    DROP CONSTRAINT IF EXISTS DF__Ticket__Status;
ALTER TABLE Ticket
    ADD CONSTRAINT DF__Ticket__Status DEFAULT ('New') FOR Status;


ALTER TABLE Comment
    DROP CONSTRAINT IF EXISTS DF__Comment__Date;
ALTER TABLE Comment
    ADD CONSTRAINT DF__Comment__Date DEFAULT (GetDate()) FOR Date;


ALTER TABLE TicketStaff
    DROP CONSTRAINT IF EXISTS DF__TicketStaff__AssignedDate;
ALTER TABLE TicketStaff
    ADD CONSTRAINT DF__TicketStaff__AssignedDate DEFAULT (GetDate()) FOR AssignedDate;


-- create indexes to non-key fields used for Searching records
CREATE INDEX IX__User__FirstNameLastName
    ON "User" (FirstName, LastName DESC);

CREATE INDEX IX__User__Username
    ON "User" (Username);


CREATE INDEX IX__Staff__FirstNameLastName
    ON Staff (FirstName, LastName DESC);

CREATE INDEX IX__Staff__Username
    ON Staff (Username);


CREATE INDEX IX__Hardware__SerialCode
    ON Hardware (SerialCode);

GO


-- Assignment 3 Starts here!!!
-- INSERT Statements
SET IDENTITY_INSERT "User" ON;  --allows a record to contain a value in the identity field during an insert
INSERT INTO "User"
	(UserID, FirstName, LastName, Photo, PhoneNumber, EmailAddress, BirthDate, Username, Password)
VALUES
	(1 , 'Joao',      'Machado',   NULL, '17828821111', 'joao.machado@speed.com',       '1982-12-31', 'joaomachado',       'ABCDEF12'),
	(2 , 'Paulo',     'Oliveira',  NULL, '17828512525', 'paulo.oliveira@speed.com',     '1988-05-15', 'paulooliveira',     'ABCDEF12'),
	(3 , 'Caio',      'Vieira',    NULL, '17826665555', 'caio.vieira@speed.com',        '1992-01-11', 'caiovieira',        'ABCDEF12'),
	(4 , 'Pedro',     'Silva',     NULL, '17821239876', 'pedro.silva@speed.com',        '1995-03-09', 'pedrosilva',        'ABCDEF12'),
	(5 , 'Gustavo',   'Almeida',   NULL, '17829875463', 'gustavo.almeida@speed.com',    '1979-12-21', 'gustavoalmeida',    'ABCDEF12'),
	(6 , 'Carlos',    'Porto',     NULL, '17829996666', 'carlos.porto@speed.com',       '1990-11-19', 'carlosporto',       'ABCDEF12'),
	(7 , 'Maria',     'Aparecida', NULL, '17823215656', 'maria.aparecida@speed.com',    '1991-10-31', 'mariaaparecida',    'ABCDEF12'),
	(8 , 'Fernanda',  'Goncalves', NULL, '17827771515', 'fernanda.goncalves@speed.com', '1987-07-06', 'fernandagoncalves', 'ABCDEF12'),
	(9 , 'Daniel',    'Dalago',    NULL, '17826563232', 'daniel.dalago@speed.com',      '1992-10-31', 'danieldalago',      'ABCDEF12'),
	(10, 'Cristiane', 'Pereira',   NULL, '17825552211', 'cristiane.pereira@speed.com',  '1996-04-12', 'cristianepereira',  'ABCDEF12');
SET IDENTITY_INSERT "User" OFF;

SET IDENTITY_INSERT Staff ON;
INSERT INTO Staff
	(StaffID, FirstName, LastName, Photo, PhoneNumber, EmailAddress, BirthDate, Username, Password)
VALUES
	(1 , 'Gabriel',   'Azevedo',   NULL, '17828821111', 'gabriel.azevedo@speed.com',    '1982-12-31', 'gabrielazevedo',    'ABCDEF12'),
	(2 , 'Juliana',   'Ferreira',  NULL, '17828512525', 'juliana.ferreira@speed.com',   '1988-05-15', 'julianaferreira',   'ABCDEF12'),
	(3 , 'Alexandre', 'Porto',     NULL, '17826665555', 'alexandre.porto@speed.com',    '1992-01-11', 'alexandreporto',    'ABCDEF12'),
	(4 , 'Edson',     'Cechet',    NULL, '17821239876', 'edson.cechet@speed.com',       '1995-03-09', 'edsoncechet',       'ABCDEF12'),
	(5 , 'Vanessa',   'Almeida',   NULL, '17829875463', 'vanessa.almeida@speed.com',    '1979-12-21', 'vanessaalmeida',    'ABCDEF12'),
	(6 , 'Luciane',   'Ody',       NULL, '17829996666', 'luciane.ody@speed.com',        '1990-11-19', 'lucianeody',        'ABCDEF12'),
	(7 , 'Bruno',     'Fischer',   NULL, '17823215656', 'bruno.fischer@speed.com',      '1991-10-31', 'brunofischer',      'ABCDEF12'),
	(8 , 'Patricia',  'Goncalves', NULL, '17827771515', 'patricia.goncalves@speed.com', '1987-07-06', 'patriciagoncalves', 'ABCDEF12'),
	(9 , 'Rodrigo',   'Dalago',    NULL, '17826563232', 'rodrigo.dalago@speed.com',     '1992-10-31', 'rodrigodalago',     'ABCDEF12'),
	(10, 'Marcel',    'Pereira',   NULL, '17825552211', 'marcel.pereira@speed.com',     '1996-04-12', 'marcelpereira',     'ABCDEF12');
SET IDENTITY_INSERT Staff OFF;

SET IDENTITY_INSERT Hardware ON;
INSERT INTO Hardware
	(HardwareID, Description, Category, Brand, AcquisitionDate, WarrantyDate, SerialCode)
VALUES
	(1,  'Desktop Dell i5 16GB RAM 1TB', 'Desktop',  'Dell',      '2018-12-05', '2020-12-05', 'D016R1HDI500001'),
	(2,  'Desktop Dell i5 16GB RAM 1TB', 'Desktop',  'Dell',      '2018-12-05', '2020-12-05', 'D016R1HDI500002'),
	(3,  'Desktop Dell i5 16GB RAM 1TB', 'Desktop',  'Dell',      '2018-12-05', '2020-12-05', 'D016R1HDI500003'),
	(4,  'Desktop Dell i5 16GB RAM 1TB', 'Desktop',  'Dell',      '2018-12-05', '2020-12-05', 'D016R1HDI500004'),
	(5,  'Desktop Dell i5 16GB RAM 1TB', 'Desktop',  'Dell',      '2018-12-05', '2020-12-05', 'D016R1HDI500005'),
	(6,  'Desktop Dell i5 16GB RAM 1TB', 'Desktop',  'Dell',      '2018-12-05', '2020-12-05', 'D016R1HDI500006'),
	(7,  'Desktop Dell i5 16GB RAM 1TB', 'Desktop',  'Dell',      '2018-12-05', '2020-12-05', 'D016R1HDI500007'),
	(8,  'Mouse Microsoft 5000bpi',      'Mouse',    'Microsoft', '2017-06-01', '2021-06-01', 'M0U53MS5000B001'),
	(9,  'Mouse Microsoft 5000bpi',      'Mouse',    'Microsoft', '2017-06-01', '2021-06-01', 'M0U53MS5000B002'),
	(10, 'Keyboard Microsoft',           'Keyboard', 'Microsoft', '2019-05-20', '2022-05-20', 'K3YB0MS0FT00001');
SET IDENTITY_INSERT Hardware OFF;

SET IDENTITY_INSERT Category ON;
INSERT INTO Category
	(CategoryID, Description, SLA)
VALUES
	(1,  'Hardware Peripheral',   '7 days'),
	(2,  'Hardware Desktop',      '2 days'),
	(3,  'Microsoft Office',      '3 days'),
	(4,  'SAP',                   '1 day'),
	(5,  'Oracle Database',       '6 hours'),
	(6,  'Access Problem',        '6 hours'),
	(7,  'Internet Problem',      '1 day'),
	(8,  'Software Installation', '2 days'),
	(9,  'Hardware Monitor',      '4 days'),
	(10, 'Other Software',        '3 days');
SET IDENTITY_INSERT Category OFF;

SET IDENTITY_INSERT Ticket ON;
INSERT INTO Ticket
	(TicketID, Title, Description, StartDate, SLA, Status, EndDate, UserID, CategoryID, HardwareID)
VALUES
	(1,  'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'New',    NULL,                  1,    2, 2),
	(2,  'SAP issue',              'SAP does not work.',                                        '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'Open',   NULL,                  4,    4, NULL),
	(3,  'MS Word issue',          'Microsoft Word does not work.',                             '2020-03-02 14:15:10', '2020-03-10 14:15:10', 'Closed', '2020-03-09 14:15:10', 4,    3, NULL),
	(4,  'Mouse issue',            'Broken mouse.',                                             '2020-03-03 14:15:10', '2020-03-10 14:15:10', 'Open',   NULL,                  NULL, 1, 9),
	(5,  'Oracle DB issue',        'Oracle database is unavailable.',                           '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'Open ',  NULL,                  NULL, 5, NULL),
	(6,  'MS Excel issue',         'Microsoft Excel does not work.',                            '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'New',    NULL,                  7,    3, NULL),
	(7,  'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'Open',   NULL,                  7,    1, 3),
	(8,  'Internet issue',         'Computer without internet access.',                         '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'Closed', '2020-03-09 14:15:10', 9,    1, 4),
	(9,  'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'Open',   NULL,                  8,    1, 6),
	(10, 'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'New',    NULL,                  6,    1, 6);
SET IDENTITY_INSERT Ticket OFF;

SET IDENTITY_INSERT Comment ON;
INSERT INTO Comment
	(CommentID, Description, Date, TicketID, UserID, StaffID)
VALUES
	(1,  'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 1, NULL, 2),
	(2,  'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 2, NULL, 3),
	(3,  'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 3, NULL, 4),
	(4,  'First attempt to contact by phone but initial comment.',     '2020-03-08 15:15:10', 4, NULL, 1),
	(5,  'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 1, NULL, 2),
	(6,  'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 2, NULL, 3),
	(7,  'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 3, NULL, 4),
	(8,  'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 4, NULL, 1),
	(9,  'I am Sorry. Could you phone me now? I am at my desk now.',   '2020-03-08 15:15:10', 1, 2,    NULL),
	(10, 'I am Sorry. Could you phone me now? initial comment.',       '2020-03-08 15:15:10', 2, 4,    NULL);
SET IDENTITY_INSERT Comment OFF;

SET IDENTITY_INSERT Task ON;
INSERT INTO Task
	(TaskID, Description, TicketID, StaffID)
VALUES
    (1,  'Install Software',           1,  1   ),
    (2,  'Install a new power Supply', 2,  2   ),
    (3,  'Install Software',           3,  3   ),
    (4,  'Install a new power Supply', 4,  4   ),
    (5,  'Install Software',           5,  5   ),
    (6,  'Install a new power Supply', 6,  1   ),
    (7,  'Install Software',           10,  null),
    (8,  'Install a new power Supply', 8,  1   ),
    (9,  'Install Software',           10, 1   ),
	(10, 'Install a new power Supply', 10, null);
SET IDENTITY_INSERT Task OFF;

INSERT INTO TicketStaff
	(StaffID, TicketID, AssignedDate)
VALUES
	(1, 1, '2020-03-08 15:15:10'),
	(2, 2, '2020-03-09 15:15:10'),
    (3, 3, '2020-03-09 16:15:10'),
    (4, 4, '2020-03-08 19:15:10'),
    (5, 5, '2020-03-09 10:15:10'),
    (6, 6, '2020-03-08 12:15:10'),
    (7, 7, '2020-03-10 15:15:10'),
    (1, 8, '2020-03-09 09:15:10'),
    (2, 1, '2020-03-09 18:15:10'),
    (3, 1, '2020-03-08 11:15:10');

GO


-- DELETE Statements
-- A. Delete an user that has created a ticket
DELETE FROM "User"
WHERE UserID = 1;
GO

-- B. Delete a Support Staff member that is currently assigned to a ticket
DELETE FROM Staff
WHERE StaffID = 1;
GO

-- C. Delete a ticket that has a task and a comment
DELETE FROM Ticket
WHERE TicketID = 1;
GO

-- D. Delete a hardware that has more than one ticket
DELETE FROM Hardware
WHERE HardwareID = 6;
GO


-- UPDATE Statements
-- A. Assign a Staff member to a ticket
UPDATE TicketStaff
SET StaffID = 2
WHERE StaffID = 7 AND TicketID = 7;
GO

-- B. Change the Status of a ticket to completed (or the like)
UPDATE Ticket
SET Status = 'Closed', EndDate = GetDate()
WHERE TicketID = 9;
GO

-- C. Change the user id (primary key), for a user	that has created tickets, to a new value
ALTER TABLE "User" DROP CONSTRAINT IF EXISTS UQ__User__Username;

SET IDENTITY_INSERT "User" ON;
INSERT INTO "User"
    (UserID, FirstName, LastName, Photo, PhoneNumber, EmailAddress, BirthDate, Username, Password)
SELECT 11, FirstName, LastName, Photo, PhoneNumber, EmailAddress, BirthDate, Username, Password
FROM "User"
WHERE UserID = 9;
SET IDENTITY_INSERT "User" OFF;

UPDATE Ticket
SET UserID = 11
WHERE UserID = 9;

UPDATE Comment
SET UserID = 11
WHERE UserID = 9;

DELETE FROM "User"
WHERE UserID = 9;

ALTER TABLE "User" ADD CONSTRAINT UQ__User__Username UNIQUE (Username);
GO


-- SELECT Statements
-- A. Retrieve a list of all open tickets
SELECT * FROM Ticket
WHERE EndDate IS NULL -- WHERE Status LIKE 'Open'
ORDER BY TicketID;
GO

-- B. Retrieve a list of tickets reported after Mar. 1, 2020 at 4:30PM and	before	Mar. 4, 2020 at 8:30AM
SELECT * FROM Ticket
WHERE StartDate  BETWEEN '2020-03-01 16:30:00' AND '2020-03-04 08:30:00'
ORDER BY StartDate;
GO

-- C. Retrieve a list of all tickets for three Specific categories
SELECT C.Description, T.*
FROM Category C INNER JOIN Ticket T ON C.CategoryID = T.CategoryID
WHERE C.Description = 'Hardware Peripheral' OR C.Description = 'Hardware Desktop' OR C.Description = 'Microsoft Office'
ORDER BY C.Description;
GO

-- D. Retrieve a list of tickets assigned to a particular Staff member and	ordered	by assigned date
SELECT TS.AssignedDate, T.TicketID
FROM TicketStaff TS
    LEFT OUTER JOIN Staff S
        ON TS.StaffID = S.StaffID
    RIGHT OUTER JOIN Ticket T
        ON TS.TicketID = T.TicketID
WHERE S.FirstName = 'Juliana' AND S.LastName = 'Ferreira'
ORDER BY TS.AssignedDate;
GO

-- E. Retrieve a list of users’ names and the number of tickets created by each user
-- Display zero	(0) for those users that have not created any tickets and order	the list by the	user’s	last names.
SELECT U.FirstName, U.LastName, COUNT(T.TicketID) AS NumberOfTickets
FROM "User" U LEFT OUTER JOIN Ticket T ON U.UserID = T.UserID
GROUP BY U.FirstName, U.LastName
ORDER BY U.LastName;
GO

-- F. Retrieve a list of ticket titles that have comments with the	phrase “initial comment” Somewhere in the text
SELECT T.Title, C.CommentID, C.Description
FROM Ticket T INNER JOIN Comment C ON T.TicketID = C.TicketID
WHERE C.Description LIKE '%initial comment%';
GO

-- G. Retrieve a list of the categories for tickets than have more	than two (2) active tasks that have not been assigned to any Staff member
SELECT CT.Description, T.TicketID
FROM Ticket T
    LEFT JOIN Category CT
        ON T.CategoryID = CT.CategoryID
    RIGHT JOIN Task TK
        ON T.TicketID = TK.TicketID
WHERE TK.StaffID IS NULL
GROUP BY T.TicketID, CT.Description
HAVING COUNT(TK.TicketID) > 2;
GO
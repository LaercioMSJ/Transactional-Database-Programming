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
    StartDate    DATETIME2      NOT NULL,
    EndDate      DATETIME2      NULL,
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
	(3,  'MS Word issue',          'Microsoft Word does not work.',                             '2020-02-02 14:15:10', '2020-02-10 14:15:10', 'Closed', '2020-02-09 14:15:10', 4,    3, NULL),
	(4,  'Mouse issue',            'Broken mouse.',                                             '2020-03-03 14:15:10', '2020-03-10 14:15:10', 'Open',   NULL,                  NULL, 1, 9),
	(5,  'Oracle DB issue',        'Oracle database is unavailable.',                           '2020-02-08 14:15:10', '2020-02-10 14:15:10', 'Open ',  NULL,                  NULL, 5, NULL),
	(6,  'MS Excel issue',         'Microsoft Excel does not work.',                            '2020-02-01 14:15:10', '2020-02-10 14:15:10', 'New',    NULL,                  7,    3, NULL),
	(7,  'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-02-02 14:15:10', '2020-02-10 14:15:10', 'Open',   NULL,                  2,    7, 3),
	(8,  'Internet issue',         'Computer without internet access.',                         '2020-03-03 14:15:10', '2020-03-10 14:15:10', 'Closed', '2020-03-09 14:15:10', 9,    1, 4),
	(9,  'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-04-11 14:15:10', '2020-04-10 14:15:10', 'Open',   NULL,                  8,    1, 6),
	(10, 'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-03-12 14:15:10', '2020-03-10 14:15:10', 'New',    NULL,                  6,    6, 6),
	(11, 'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-03-13 14:15:10', '2020-03-10 14:15:10', 'New',    NULL,                  1,    2, 2),
	(12, 'SAP issue',              'SAP does not work.',                                        '2020-03-20 14:15:10', '2020-03-10 14:15:10', 'Open',   NULL,                  4,    4, NULL),
	(13, 'MS Word issue',          'Microsoft Word does not work.',                             '2020-04-21 14:15:10', '2020-04-10 14:15:10', 'Closed', '2020-04-09 14:15:10', 4,    3, NULL),
	(14, 'Mouse issue',            'Broken mouse.',                                             '2020-03-22 14:15:10', '2020-03-10 14:15:10', 'Open',   NULL,                  NULL, 1, 9),
	(15, 'Oracle DB issue',        'Oracle database is unavailable.',                           '2020-03-23 14:15:10', '2020-03-10 14:15:10', 'Open ',  NULL,                  NULL, 5, NULL),
	(16, 'MS Excel issue',         'Microsoft Excel does not work.',                            '2020-03-31 14:15:10', '2020-03-10 14:15:10', 'New',    NULL,                  7,    3, NULL),
	(17, 'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-04-30 14:15:10', '2020-04-10 14:15:10', 'Open',   NULL,                  2,    7, 3),
	(18, 'Internet issue',         'Computer without internet access.',                         '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'Closed', '2020-03-09 14:15:10', 9,    1, 4),
	(19, 'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'Open',   NULL,                  8,    1, 6),
	(20, 'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'New',    NULL,                  6,    6, 6),
	(21, 'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-04-08 14:15:10', '2020-04-10 14:15:10', 'New',    NULL,                  1,    2, 2),
	(22, 'SAP issue',              'SAP does not work.',                                        '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'Open',   NULL,                  4,    4, NULL),
	(23, 'MS Word issue',          'Microsoft Word does not work.',                             '2020-03-02 14:15:10', '2020-03-10 14:15:10', 'Closed', '2020-03-09 14:15:10', 4,    3, NULL),
	(24, 'Mouse issue',            'Broken mouse.',                                             '2020-03-03 14:15:10', '2020-03-10 14:15:10', 'Open',   NULL,                  NULL, 1, 9),
	(25, 'Oracle DB issue',        'Oracle database is unavailable.',                           '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'Open ',  NULL,                  NULL, 5, NULL),
	(26, 'MS Excel issue',         'Microsoft Excel does not work.',                            '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'New',    NULL,                  7,    3, NULL),
	(27, 'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-03-08 14:15:10', '2020-03-10 14:15:10', 'Open',   NULL,                  3,    1, 3),
	(28, 'Internet issue',         'Computer without internet access.',                         '2020-04-08 14:15:10', '2020-04-10 14:15:10', 'Closed', '2020-04-09 14:15:10', 9,    9, 4),
	(29, 'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-04-08 14:15:10', '2020-04-10 14:15:10', 'Open',   NULL,                  8,    1, 6),
	(30, 'Computer does not work', 'Computer does not Start when the power button is pressed.', '2020-04-08 14:15:10', '2020-04-10 14:15:10', 'New',    NULL,                  6,    10, 6);

SET IDENTITY_INSERT Ticket OFF;

SET IDENTITY_INSERT Comment ON;
INSERT INTO Comment
	(CommentID, Description, Date, TicketID, UserID, StaffID)
VALUES
	(1,  'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 1, NULL, 2),
	(2,  'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 2, NULL, 3),
	(3,  'First attempt to contact by phone but user did not answer.', '2020-02-08 15:15:10', 2, NULL, 4),
	(4,  'First attempt to contact by phone but initial comment.',     '2020-03-08 15:15:10', 2, NULL, 1),
	(5,  'First attempt to contact by phone but user did not answer.', '2020-02-08 15:15:10', 3, NULL, 2),
	(6,  'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 3, NULL, 3),
	(7,  'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 3, NULL, 4),
	(8,  'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 4, NULL, 1),
	(9,  'I am Sorry. Could you phone me now? I am at my desk now.',   '2020-02-08 15:15:10', 4, 2,    NULL),
	(10, 'I am Sorry. Could you phone me now? initial comment.',       '2020-03-08 15:15:10', 5, 4,    NULL),
	(11, 'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 5, NULL, 2),
	(12, 'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 6, NULL, 3),
	(13, 'First attempt to contact by phone but user did not answer.', '2020-02-08 15:15:10', 7, NULL, 4),
	(14, 'First attempt to contact by phone but initial comment.',     '2020-04-08 15:15:10', 8, NULL, 1),
	(15, 'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 8, NULL, 2),
	(16, 'First attempt to contact by phone but user did not answer.', '2020-02-08 15:15:10', 9, NULL, 3),
	(17, 'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 10, NULL, 4),
	(18, 'First attempt to contact by phone but user did not answer.', '2020-02-08 15:15:10', 10, NULL, 1),
	(19, 'I am Sorry. Could you phone me now? I am at my desk now.',   '2020-03-08 15:15:10', 11, 2,    NULL),
	(20, 'I am Sorry. Could you phone me now? initial comment.',       '2020-03-08 15:15:10', 12, 4,    NULL),
 	(21, 'First attempt to contact by phone but user did not answer.', '2020-02-08 15:15:10', 13, NULL, 2),
	(22, 'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 10, NULL, 3),
	(23, 'First attempt to contact by phone but user did not answer.', '2020-04-08 15:15:10', 10, NULL, 4),
	(24, 'First attempt to contact by phone but initial comment.',     '2020-03-08 15:15:10', 11, NULL, 1),
	(25, 'First attempt to contact by phone but user did not answer.', '2020-04-08 15:15:10', 12, NULL, 2),
	(26, 'First attempt to contact by phone but user did not answer.', '2020-03-08 15:15:10', 13, NULL, 3),
	(27, 'First attempt to contact by phone but user did not answer.', '2020-04-08 15:15:10', 23, NULL, 4),
	(28, 'First attempt to contact by phone but user did not answer.', '2020-04-08 15:15:10', 24, NULL, 1),
	(29, 'I am Sorry. Could you phone me now? I am at my desk now.',   '2020-04-08 15:15:10', 25, 2,    NULL),
	(30, 'I am Sorry. Could you phone me now? initial comment.',       '2020-04-08 15:15:10', 20, 4,    NULL);
SET IDENTITY_INSERT Comment OFF;

SET IDENTITY_INSERT Task ON;
INSERT INTO Task
	(TaskID, Description, StartDate, EndDate, TicketID, StaffID)
VALUES
    (1,  'Install Software',           '2020-04-08 15:15:10', '2020-04-09 15:15:10', 1,  2   ),
    (2,  'Install a new power Supply', '2020-04-08 15:15:10', null,                  2,  2   ),
    (3,  'Install Software',           '2020-04-08 15:15:10', null,                  3,  3   ),
    (4,  'Install a new power Supply', '2020-04-08 15:15:10', null,                  4,  4   ),
    (5,  'Install Software',           '2020-04-08 15:15:10', null,                  5,  5   ),
    (6,  'Install a new power Supply', '2020-04-08 15:15:10', null,                  6,  1   ),
    (7,  'Install Software',           '2020-04-08 15:15:10', '2020-04-09 15:15:10', 10,  null),
    (8,  'Install a new power Supply', '2020-04-08 15:15:10', null,                  8,  3   ),
    (9,  'Install Software',           '2020-04-08 15:15:10', null,                  10, 2   ),
	(10, 'Install a new power Supply', '2020-04-08 15:15:10', '2020-04-09 15:15:10', 10, null),
    (11,  'Install Software',           '2020-04-08 15:15:10', '2020-04-09 15:15:10', 1,  10   ),
    (12,  'Install a new power Supply', '2020-04-08 15:15:10', null,                  2,  2   ),
    (13,  'Install Software',           '2020-04-08 15:15:10', null,                  3,  3   ),
    (14,  'Install a new power Supply', '2020-04-08 15:15:10', null,                  4,  4   ),
    (15,  'Install Software',           '2020-04-08 15:15:10', null,                  5,  5   ),
    (16,  'Install a new power Supply', '2020-04-08 15:15:10', null,                  6,  1   ),
    (17,  'Install Software',           '2020-04-08 15:15:10', '2020-04-09 15:15:10', 10,  null),
    (18,  'Install a new power Supply', '2020-04-08 15:15:10', null,                  8,  3   ),
    (19,  'Install Software',           '2020-04-08 15:15:10', null,                  10, 2   ),
	(20, 'Install a new power Supply', '2020-04-08 15:15:10', '2020-04-09 15:15:10', 10, null);
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


-- Assignment 4 Starts here!!!
-- 1. Display a list of all tickets submitted within a given month of the current year.
-- The month will be supplied to the routine as a word (e.g. April)

DROP PROCEDURE IF EXISTS usp_GetTicketsByMonth;
GO
CREATE PROCEDURE usp_GetTicketsByMonth
    @month NVARCHAR(10)
AS
BEGIN
    SELECT * From Ticket
    WHERE DATENAME(MONTH,StartDate) LIKE @month AND YEAR(StartDate) = YEAR(GETDATE())
    ORDER BY TicketID;
END;
GO

EXEC usp_GetTicketsByMonth N'February';
GO

EXEC usp_GetTicketsByMonth N'march';
GO

EXEC usp_GetTicketsByMonth N'APRIL';
GO

EXEC usp_GetTicketsByMonth N'may'; -- There is not any ticket in May and because of this there is not any selected ticked
GO


-- 2. Display a list of the top 10 tickets that have had the most activity in the form
-- of comments. A start date and end date will be supplied to the routine in the
-- form ‘yyyy-mm-dd’.

DROP PROCEDURE IF EXISTS usp_GetTicketsWithMoreComments;
GO
CREATE PROCEDURE usp_GetTicketsWithMoreComments
    @startDate NVARCHAR(10), @endDate NVARCHAR(10)
AS
BEGIN
    SELECT TOP 10 T.TicketID, COUNT(C.CommentID) AS NumberOfComments FROM Ticket T
    INNER JOIN Comment C ON T.TicketID = C.TicketID
    WHERE C.Date >= CONVERT(DATETIME, @startDate) AND C.Date <= CONVERT(DATETIME, @endDate)
    GROUP BY T.TicketID
    ORDER BY NumberOfComments DESC;
END;
GO

EXEC usp_GetTicketsWithMoreComments N'2020-02-01', N'2020-04-30';
GO

EXEC usp_GetTicketsWithMoreComments N'2020-04-01', N'2020-04-30';
GO

EXEC usp_GetTicketsWithMoreComments N'2020-02-01', N'2020-03-31';
GO

EXEC usp_GetTicketsWithMoreComments N'2020-03-10', N'2020-03-31'; -- There is not any comment in that range and because of this there is not any selected ticked
GO


-- 3. Display a list of tickets for a particular category, ordered by descending date,
-- with the corresponding date displayed in the format (Month dddd, yyyy) e.g.
-- November 21st, 2009. A category name will be supplied to the routine.

DROP PROCEDURE IF EXISTS usp_GetTicketsByCategory;
GO
CREATE PROCEDURE usp_GetTicketsByCategory
    @categoryName NVARCHAR(32)
AS
BEGIN
    SELECT CT.Description, T.TicketID, DATENAME(MONTH,T.StartDate) +
       CASE
            WHEN DAY(T.StartDate) % 100 IN (11, 12, 13) THEN CONCAT(' ',DAY(T.StartDate), 'th')
            WHEN DAY(T.StartDate) % 10 = 1 THEN CONCAT(' ',DAY(T.StartDate), 'st')
            WHEN DAY(T.StartDate) % 10 = 2 THEN CONCAT(' ',DAY(T.StartDate), 'nd')
            WHEN DAY(T.StartDate) % 10 = 3 THEN CONCAT(' ',DAY(T.StartDate), 'rd')
        ELSE CONCAT(' ',DAY(T.StartDate), 'th') END
	    + FORMAT(T.StartDate, ', yyyy')
    AS TicketDate FROM Category CT
    INNER JOIN Ticket T ON CT.CategoryID = T.CategoryID
    WHERE CT.Description LIKE @categoryName
    ORDER BY T.StartDate DESC;
END;
GO

EXEC usp_GetTicketsByCategory N'Hardware Peripheral';
GO

EXEC usp_GetTicketsByCategory N'Hardware Desktop';
GO

EXEC usp_GetTicketsByCategory N'Microsoft Office';
GO

EXEC usp_GetTicketsByCategory N'SAP';
GO

EXEC usp_GetTicketsByCategory N'Oracle Database';
GO

EXEC usp_GetTicketsByCategory N'Access Problem';
GO

EXEC usp_GetTicketsByCategory N'Internet Problem';
GO

EXEC usp_GetTicketsByCategory N'Software Installation'; -- No ticket in this Category because of this nothing is selected
GO

EXEC usp_GetTicketsByCategory N'Hardware Monitor';
GO

EXEC usp_GetTicketsByCategory N'Other Software';
GO

EXEC usp_GetTicketsByCategory N'Other Soft'; -- Category name incorrect because of this nothing is selected
GO


-- 4. Return the total number of active tasks for a given support staff member. An
-- employee number will be supplied to the routine. The routine should also
-- return zero (0), if there are no active tasks for that person, and negative one
-- (-1), if the support staff member could not be found.

DROP FUNCTION IF EXISTS ufn_GetNumberOfActiveTasksByStaffID;
GO
CREATE FUNCTION ufn_GetNumberOfActiveTasksByStaffID(@staffID INT)
RETURNS SMALLINT
AS
BEGIN
	DECLARE @tasks SMALLINT;

	IF EXISTS (SELECT * FROM Staff S
	            WHERE S.StaffID = @staffID)
    BEGIN
        SET @tasks = (SELECT COUNT(TaskID) AS NumberOfActiveTasks FROM Task
                        WHERE StaffID = @staffID AND EndDate IS NULL);
    END

    ELSE

    BEGIN
        SET @tasks = -1;
    END
    RETURN @tasks;
END;
GO

DECLARE @activeTasks SMALLINT;
DECLARE @staffID INT = 0;
DECLARE @name VARCHAR(32);
SELECT TOP 1 @staffID = StaffID, @name = CONCAT(FirstName, ' ', LastName)
FROM Staff
WHERE StaffID > @staffID
ORDER BY StaffID;
WHILE @@ROWCOUNT > 0
BEGIN
    EXEC @activeTasks = ufn_GetNumberOfActiveTasksByStaffID @staffID;
    PRINT 'StaffID ' + LTRIM(STR(@staffID)) + ' ' + @name + ' has ' + LTRIM(STR(@activeTasks)) + ' active tasks';
    SELECT TOP 1 @staffID = StaffID, @name = CONCAT(FirstName, ' ', LastName)
    FROM Staff
    WHERE StaffID > @staffID
    ORDER BY StaffID;
END
SET @staffID = 11;
EXEC @activeTasks = ufn_GetNumberOfActiveTasksByStaffID @staffID;
PRINT 'StaffID ' + LTRIM(STR(@staffID)) + ' has ' + LTRIM(STR(@activeTasks)) + ' active tasks';
GO


-- Another example using name
DROP FUNCTION IF EXISTS ufn_GetNumberOfActiveTasksByStaffName;
GO
CREATE FUNCTION ufn_GetNumberOfActiveTasksByStaffName(@firstName NVARCHAR(32), @lastName NVARCHAR(32))
RETURNS SMALLINT
AS
BEGIN
	DECLARE @tasks SMALLINT;

	IF EXISTS (SELECT * FROM Staff S
	            WHERE S.FirstName LIKE @firstName AND S.LastName LIKE @lastName)
    BEGIN
        SET @tasks = (SELECT COUNT(TaskID) FROM Task T
	                    INNER JOIN Staff S ON T.StaffID = S.StaffID
	                    WHERE S.FirstName LIKE @firstName AND S.LastName LIKE @lastName AND T.EndDate IS NULL);
    END

    ELSE

    BEGIN
        SET @tasks = -1;
    END
    RETURN @tasks;
END;
GO

DECLARE @firstName NVARCHAR(32);
DECLARE @lastName NVARCHAR(32);
SET @firstName = 'Alexandre';
SET @lastName = 'Porto';
DECLARE @activeTasks SMALLINT;
EXEC @activeTasks = ufn_GetNumberOfActiveTasksByStaffName @firstName, @lastName;
PRINT @firstName + ' ' + @lastName + ' has ' + LTRIM(STR(@activeTasks)) + ' active tasks';
SET @firstName = 'Julian';
SET @lastName = 'Porto';
EXEC @activeTasks = ufn_GetNumberOfActiveTasksByStaffName @firstName, @lastName;
PRINT @firstName + ' ' + @lastName + ' has ' + LTRIM(STR(@activeTasks)) + ' active tasks';
GO


-- 5. Display a “page” of ticket information by passing, to the routine, a page
-- number and the number of tickets per page. For example, passing “1,10” will
-- return the first ten tickets (ordered by ticket id), but passing “2,10” will
-- return next ten tickets (i.e. page 2).

DROP PROCEDURE IF EXISTS usp_GetTicketsByPage;
GO
CREATE PROCEDURE usp_GetTicketsByPage
    @PageNumber SMALLINT, @TicketsPerPage SMALLINT
AS
BEGIN
    SELECT * FROM Ticket
    ORDER BY TicketID
    OFFSET ((@PageNumber - 1) * @TicketsPerPage) ROWS
    FETCH NEXT @TicketsPerPage ROWS ONLY;
END;
GO

EXEC usp_GetTicketsByPage 1,10;
GO

EXEC usp_GetTicketsByPage 2,10;
GO

EXEC usp_GetTicketsByPage 3,5;
GO

EXEC usp_GetTicketsByPage 4,7;
GO

EXEC usp_GetTicketsByPage 10,2;
GO

EXEC usp_GetTicketsByPage 4,8;
GO
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
    Description  NVARCHAR(255)  NOT NULL,
    StartDate    DATETIME2      NOT NULL,
    SLA          DATETIME2      NOT NULL,
    Status       NVARCHAR(32)   NOT NULL,
    EndDate      DATETIME2      NULL,
    UserID       INT            NULL,
    StaffID      INT            NOT NULL,
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

DROP TABLE IF EXISTS TicketStaff;
CREATE TABLE TicketStaff
(
    StaffID       INT           NOT NULL,
    TicketID      INT           NOT NULL,
    Action        NVARCHAR(32)  NOT NULL
);


-- create relationships
ALTER TABLE Ticket
    DROP CONSTRAINT IF EXISTS FK__User__UserID_T;
ALTER TABLE Ticket
    ADD CONSTRAINT FK__User__UserID_T
    FOREIGN KEY (UserID) REFERENCES "User" (UserID);

ALTER TABLE Ticket
    DROP CONSTRAINT IF EXISTS FK__Staff__StaffID_T;
ALTER TABLE Ticket
    ADD CONSTRAINT FK__Staff__StaffID_T
    FOREIGN KEY (StaffID) REFERENCES Staff (StaffID);

ALTER TABLE Ticket
    DROP CONSTRAINT IF EXISTS FK__Category__CategoryID_T;
ALTER TABLE Ticket
    ADD CONSTRAINT FK__Category__CategoryID_T
    FOREIGN KEY (CategoryID) REFERENCES Category (CategoryID);

ALTER TABLE Ticket
    DROP CONSTRAINT IF EXISTS FK__Hardware__HardwareID_T;
ALTER TABLE Ticket
    ADD CONSTRAINT FK__Hardware__HardwareID_T
    FOREIGN KEY (HardwareID) REFERENCES Hardware (HardwareID);


ALTER TABLE Comment
    DROP CONSTRAINT IF EXISTS FK__Ticket__TicketID_C;
ALTER TABLE Comment
    ADD CONSTRAINT FK__Ticket__TicketID_C
    FOREIGN KEY (TicketID) REFERENCES Ticket (TicketID);

ALTER TABLE Comment
    DROP CONSTRAINT IF EXISTS FK__User__UserID_C;
ALTER TABLE Comment
    ADD CONSTRAINT FK__User__UserID_C
    FOREIGN KEY (UserID) REFERENCES "User" (UserID);

ALTER TABLE Comment
    DROP CONSTRAINT IF EXISTS FK__Staff__StaffID_C;
ALTER TABLE Comment
    ADD CONSTRAINT FK__Staff__StaffID_C
    FOREIGN KEY (StaffID) REFERENCES Staff (StaffID);


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
    FOREIGN KEY (StaffID) REFERENCES Staff (StaffID);

ALTER TABLE TicketStaff
    DROP CONSTRAINT IF EXISTS FK__Ticket_TicketID_TS;
ALTER TABLE TicketStaff
    ADD CONSTRAINT FK__Ticket_TicketID_TS
    FOREIGN KEY (TicketID) REFERENCES Ticket (TicketID);


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
    ADD CONSTRAINT DF__Ticket__Status DEFAULT ('Open') FOR Status;


ALTER TABLE Comment
    DROP CONSTRAINT IF EXISTS DF__Comment__Date;
ALTER TABLE Comment
    ADD CONSTRAINT DF__Comment__Date DEFAULT (GetDate()) FOR Date;


ALTER TABLE TicketStaff
    DROP CONSTRAINT IF EXISTS DF__TicketStaff__Action;
ALTER TABLE TicketStaff
    ADD CONSTRAINT DF__TicketStaff__Action DEFAULT ('Working on the issue') FOR Action;


-- create indexes to non-key fields used for searching records
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

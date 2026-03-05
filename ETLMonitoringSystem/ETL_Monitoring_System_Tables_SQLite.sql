-- ETLMS ==>> ETL_Monitoring_System_Tables.sql (SQLite version)
-- ETLMS tables needed to run the automatic monitoring system for ETLs.
-- Converted to SQLite
-- Carlos Kassab


-- Table: ETLMS_Projects
-- Create one row by each ETL project

-- DROP TABLE IF EXISTS ETLMS_Projects;

CREATE TABLE ETLMS_Projects (
    ProjectID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProjectName TEXT,
    Description TEXT
);

INSERT INTO ETLMS_Projects (ProjectName, Description) VALUES( 'General Data', 'ETL General Processes');

-- Ensuring our first project will be number 1.
INSERT INTO ETLMS_Projects (ProjectID, ProjectName, Description) VALUES(1, 'General Data', 'ETL General Processes');



-- Table: ETLMS_ProcStatus

-- DROP TABLE IF EXISTS ETLMS_ProcStatus;

CREATE TABLE ETLMS_ProcStatus (
	StatusCode INTEGER NOT NULL,
	StatusDescription TEXT NOT NULL,
	CONSTRAINT ETLMS_ProcStatus_PK PRIMARY KEY (StatusCode)
);

-- Insert the next default values
INSERT INTO ETLMS_ProcStatus (StatusCode, StatusDescription) VALUES(1, 'Start Process or Sequence');
INSERT INTO ETLMS_ProcStatus (StatusCode, StatusDescription) VALUES(2, 'End Process or Sequence Successfully');
INSERT INTO ETLMS_ProcStatus (StatusCode, StatusDescription) VALUES(3, 'Error Ending Process or Sequence');



-- Table: ETLMS_ErrorCodes
-- Insert all standard/common error codes, but also it can have error codes specific to certain ETL process.

-- DROP TABLE IF EXISTS ETLMS_ErrorCodes;

CREATE TABLE ETLMS_ErrorCodes (
	ErrorCode INTEGER NOT NULL,
	ErrorDescription TEXT(100) NOT NULL,
	CONSTRAINT ETLMS_ErrorCodes_PK PRIMARY KEY (ErrorCode)
);

INSERT INTO ETLMS_ErrorCodes (ErrorCode, ErrorDescription) VALUES(3001, 'Data Source Connection Error.');
INSERT INTO ETLMS_ErrorCodes (ErrorCode, ErrorDescription) VALUES(3002, 'Process Error, Check Log in Text Files.');
INSERT INTO ETLMS_ErrorCodes (ErrorCode, ErrorDescription) VALUES(3003, 'Process Custom Message, Check Process Script, Log Text Files And/Or Table:ETLMS_ProcessesLog');



-- Table: ETLMS_Processes
-- Insert all main ETL process numbers by ProjectID
-- SubProcesses, if you have a main ETL process number 200(Items Catalog), inside this, you may have sub processes:
-- 205(Load General Libraries), 210(Read Items Catalog), etc

-- DROP TABLE IF EXISTS ETLMS_Processes;

CREATE TABLE ETLMS_Processes (
    ProjectID INTEGER NOT NULL,
    ProcessNumber INTEGER NOT NULL,    
    SubProcessNumber INTEGER NOT NULL,
    Description TEXT(100) NOT NULL,
    CONSTRAINT ETLMS_Processes_PK PRIMARY KEY (ProjectID, ProcessNumber, SubProcessNumber)
);

-- Inserts With Sample Data
INSERT INTO ETLMS_Processes (ProjectID, ProcessNumber, SubProcessNumber, Description) VALUES(1, 200, 0, 'Get sites catalog.');
INSERT INTO ETLMS_Processes (ProjectID, ProcessNumber, SubProcessNumber, Description) VALUES(1, 200, 205, 'Import Sites Catalog Library.');
INSERT INTO ETLMS_Processes (ProjectID, ProcessNumber, SubProcessNumber, Description) VALUES(1, 200, 210, 'Read Sites Catalog From Source DB.');
INSERT INTO ETLMS_Processes (ProjectID, ProcessNumber, SubProcessNumber, Description) VALUES(1, 200, 215, 'Truncate Sites Catalog Table on Target DB.');
INSERT INTO ETLMS_Processes (ProjectID, ProcessNumber, SubProcessNumber, Description) VALUES(1, 200, 220, 'Insert New Data Into Target DB, Sites Catalog Table.');


-- Table: ETLMS_ProcessesLog
-- This table will contain every step executed in the ETL process.

-- DROP TABLE IF EXISTS ETLMS_ProcessesLog;

CREATE TABLE ETLMS_ProcessesLog (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    RunNumber NUMERIC NOT NULL,
    ProjectID INTEGER NOT NULL,
    ProcessNumber INTEGER NOT NULL,
    SubProcessNumber INTEGER NOT NULL,
    StatusCode INTEGER NOT NULL,
    Date NUMERIC NOT NULL,
    ErrorCode INTEGER NOT NULL,
    Notes TEXT(300)
);

INSERT INTO ETLMS_ProcessesLog (RunNumber, ProjectID, ProcessNumber, SubProcessNumber, StatusCode, Date, ErrorCode, Notes) 
VALUES( 20190125150445, 1, 200, 0, 1, 20190125153600, 0, '');



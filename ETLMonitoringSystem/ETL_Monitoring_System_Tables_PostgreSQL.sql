
-- ETLMS ==>> ETL_Monitoring_System_Tables.sql (PostgreSQL version)
-- ETLMS tables needed to run the automatic monitoring system for ETLs.
-- 
-- Carlos Kassab


-- Table: public."ETLMS_Projects"
-- Create one row by each ETL project

-- DROP TABLE public."ETLMS_Projects";

CREATE TABLE public."ETLMS_Projects"
(
    "ProjectID" integer NOT NULL DEFAULT nextval('"ETLMS_Projects_ProjectID_seq"'::regclass),
    "ProjectName" character varying COLLATE pg_catalog."default",
    "Description" character varying COLLATE pg_catalog."default",
    CONSTRAINT "ETLMS_Projects_pkey" PRIMARY KEY ("ID")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."ETLMS_Projects"
    OWNER to "dwhuser"; -- <<== This is your database user on every table in the target DB
		
INSERT INTO ETLMS_Projects ("ProjectName", "Description") VALUES('General Data', 'ETL General Processes');



-- Table: ETLMS_ProcStatus

-- DROP TABLE IF EXISTS ETLMS_ProcStatus;

CREATE TABLE ETLMS_ProcStatus (
	"StatusCode" integer NOT NULL,
	"StatusDescription" character varying COLLATE pg_catalog."default",
	CONSTRAINT "ETLMS_ProcStatus_pkey" PRIMARY KEY ("StatusCode")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."ETLMS_ProcStatus"
    OWNER to "dwhuser"; -- <<== This is your database user on every table in the target DB

-- Insert the next default values
INSERT INTO ETLMS_ProcStatus ("StatusCode", "StatusDescription") VALUES(1, 'Initializing ETL(Loading Config, Libraries, Delete Logs, Connect DBs, etc.)');
INSERT INTO ETLMS_ProcStatus ("StatusCode", "StatusDescription") VALUES(2, 'Start Proc Sequence');
INSERT INTO ETLMS_ProcStatus ("StatusCode", "StatusDescription") VALUES(3, 'End Proc Sequence Successfully');
INSERT INTO ETLMS_ProcStatus ("StatusCode", "StatusDescription") VALUES(4, 'End Proc Sequence with ERROR');



-- Table: ETLMS_ErrorCodes
-- Insert all standard/common error codes, but also it can have error codes specific to certain ETL process.

-- DROP TABLE public."ETLMS_ErrorCodes";

CREATE TABLE public."ETLMS_ErrorCodes"
(
    "ErrorCode" integer NOT NULL,
    "Description" character varying COLLATE pg_catalog."default",
    CONSTRAINT "ETLMS_ErrorCodes_pkey" PRIMARY KEY ("ErrorCode")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."ETLMS_ErrorCodes"
    OWNER to "dwhuser"; -- <<== This is your database user on every table in the target DB

INSERT INTO ETLMS_ErrorCodes ("ErrorCode", "ErrorDescription") VALUES(3001, 'Data Source Connection Error.');
INSERT INTO ETLMS_ErrorCodes ("ErrorCode", "ErrorDescription") VALUES(3002, 'Process Error, Check Process And Sub Processes on Table:ETLMS_ProcessesLog');
INSERT INTO ETLMS_ErrorCodes ("ErrorCode", "ErrorDescription") VALUES(3003, 'Process Custom Error Message, Check Process Script And/Or Table:ETLMS_ProcessesLog');



-- Table: ETLMS_Processes
-- Insert all main ETL process numbers by ProjectID
-- SubProcesses, if you have a main ETL process number 200(Items Catalog), inside this, you may have sub processes:
-- 205(Load General Libraries), 210(Read Items Catalog), etc

-- DROP TABLE public."ETLMS_Processes";

CREATE TABLE public."ETLMS_Processes"
(
    "ProjectID" integer NOT NULL,
    "ProcessNumber" integer NOT NULL,
    "SubProcessNumber" integer NOT NULL,
    "Description" character varying COLLATE pg_catalog."default",
    CONSTRAINT "ETLMS_Processes_pkey" PRIMARY KEY ("ProjectID", "ProcessNumber", "SubProcessNumber")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."ETLMS_Processes"
    OWNER to "dwhuser"; -- <<== This is your database user on every table in the target DB

-- Inserts With Sample Data
INSERT INTO ETLMS_Processes ("ProjectID", "ProcessNumber", "SubProcessNumber", "Description") VALUES(1, 200, 0, 'Get sites catalog.');
INSERT INTO ETLMS_Processes ("ProjectID", "ProcessNumber", "SubProcessNumber", "Description") VALUES(1, 200, 205, 'Import Sites Catalog Library.');
INSERT INTO ETLMS_Processes ("ProjectID", "ProcessNumber", "SubProcessNumber", "Description") VALUES(1, 200, 210, 'Read Sites Catalog From Source DB.');
INSERT INTO ETLMS_Processes ("ProjectID", "ProcessNumber", "SubProcessNumber", "Description") VALUES(1, 200, 215, 'Truncate Sites Catalog Table on Target DB.');
INSERT INTO ETLMS_Processes ("ProjectID", "ProcessNumber", "SubProcessNumber", "Description") VALUES(1, 200, 220, 'Insert New Data Into Target DB, Sites Catalog Table.');



-- Table: public."ETLMS_ProcessesLog"
-- This table will contain every step executed in the ETL process.

-- DROP TABLE public."ETLMS_ProcessesLog";

CREATE TABLE public."ETLMS_ProcessesLog"
(
    "ID" integer NOT NULL DEFAULT nextval('"ETLMS_ProcessesLog_ID_seq"'::regclass),
    "RunNumber" numeric(14,0),
    "ProjectID" integer,
    "ProcessNumber" integer,
    "SubProcessNumber" integer,
    "StatusCode" integer,
    "Date" numeric(14,0),
    "ErrorCode" integer,
    "Notes" character varying COLLATE pg_catalog."default",
    CONSTRAINT "AMS_Processes_Log_pkey" PRIMARY KEY ("ID")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public."ETLMS_ProcessesLog"
    OWNER to "dwhuser"; -- <<== This is your database user on every table in the target DB
		
INSERT INTO ETLMS_ProcessesLog ("RunNumber", "ProjectID", "ProcessNumber", "SubProcessNumber", "StatusCode", "Date", "ErrorCode", "Notes") 
VALUES( 20190125150445, 1, 200, 0, 1, 20190125153600, 0, '');
		




-- ###>>> GET PROCESSES LOG <<<###
SELECT a.ID, a.RunNumber, a.ProjectID, b.ProjectName , a.ProcessNumber,
a.SubProcessNumber, c.Description AS "Process - SubProcess- Desc" , a.StatusCode,
CASE a.StatusCode 
	WHEN 1 THEN "Starting"
	WHEN 2 THEN "Done"
	WHEN 3 THEN "Error"
	END AS StatusDesc, Date, ErrorCode, Notes
FROM ETLMS_ProcessesLog a
LEFT JOIN ETLMS_Projects b ON a.ProjectID = b.ProjectID 
LEFT JOIN ETLMS_Processes c ON a.ProjectID = c.ProjectID AND a.ProcessNumber =  c.ProcessNumber AND a.SubProcessNumber = c.SubProcessNumber 
-- WHERE a.RunNumber = 20260302120328
ORDER BY a.RunNumber DESC, a.ID;


--  ###>>> INSERT NEW PROCESSES <<<###
-- Before running the insert, set new values.
INSERT INTO ETLMS_Processes
(ProjectID, ProcessNumber, SubProcessNumber, Description)
VALUES
	(1, 300, 0, 'Get Products Catalog.'),
	(1, 300, 305, 'Import Products Catalog Library.'), -- In JavaScript ETLs, we use this step
	(1, 300, 306, 'Run Get Products Catalog Main Process.'),
	(1, 300, 310, 'Read Products Catalog From Source DB.'),
	(1, 300, 315, 'Truncate Products Catalog Table on Target DB.'),
	(1, 300, 320, 'Insert New Data Into Target DB, Produtcs Catalog Table.');


--  ###>>> SUPPORT QUERIES <<<###

SELECT ProjectID, ProjectName, Description
FROM ETLMS_Projects;

SELECT ProjectID, ProcessNumber, SubProcessNumber, Description
FROM ETLMS_Processes
ORDER BY ProjectID, ProcessNumber, SubProcessNumber 

SELECT ErrorCode, ErrorDescription
FROM ETLMS_ErrorCodes;


SELECT ID, RunNumber, ProjectID, ProcessNumber, SubProcessNumber, StatusCode, Date, ErrorCode, Notes
FROM ETLMS_ProcessesLog;
ORDER BY RunNumber, ProcessNumber, SubProcessNumber DESC

INSERT INTO ETLMS_ProcessesLog (RunNumber, ProjectID, ProcessNumber, SubProcessNumber, StatusCode, Date, ErrorCode, Notes)
VALUES (20260301114452, 2, 200, 206, 1, 20260301114452, 0, '' );


-- DELETE FROM ETLMS_ProcessesLog
-- WHERE ID=0;


-- UPDATE ETLMS_ProcessesLog
-- SET ProjectID=1
-- RunNumber=0, ProjectID=0, ProcessNumber=0, SubProcessNumber=0, StatusCode=0, Date=0, ErrorCode=0, Notes=''
-- WHERE ID=0;







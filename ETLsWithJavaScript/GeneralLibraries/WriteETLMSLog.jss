/*******************************************************************************
* WriteETLMSLog.jss
* Write a log record in ETLMS Processes Log table.
* Carlos Kassab
* 2025-August-20
********************************************************************************/


var WriteETLMSLog = function( dbConn, runNumber, projectID, procNumber, subProcNum
											, statusCode, errorCode, notes ) {

  const eventDate = GetNumericDateTime()

  // Insert for SQLite
  var insertQuery = "INSERT INTO ETLMS_ProcessesLog (RunNumber, ProjectID, ProcessNumber, SubProcessNumber, StatusCode, Date, ErrorCode, Notes) VALUES(" + 
  runNumber + "," + projectID + "," + procNumber + "," + subProcNum + "," + statusCode + "," + eventDate + "," + errorCode + ",'" +  notes + "');"

  try {
    var stmt = dbConn.createStatement()
    stmt.execute(insertQuery)
  } catch (error) {
    print("Error writing data to ETLMS_ProcessesLog, function 'WriteETLMSLog':" + error);
    print("Insert query:" + insertQuery);
  }									
}


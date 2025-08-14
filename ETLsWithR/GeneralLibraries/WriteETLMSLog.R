#*******************************************************************************
#* WriteETLMSLog.R
#* Write a log record in ETLMS Processes Log table.
#* Carlos Kassab
#* 2019-January-25
#*******************************************************************************


WriteETLMSLog = function( dbConn, runNumber, projectID, procNumber, subProcNum
											, statusCode, errorCode, notes ) {

  eventDate = paste0( format( Sys.Date(), "%Y%m%d" )
										, format( Sys.time(), "%H%M%S" ) ) # "yyyyMMddHHmmss"

  # Insert for SQLite
  insertQuery = paste0( "INSERT INTO ETLMS_ProcessesLog (
    RunNumber, ProjectID, ProcessNumber, SubProcessNumber
    , StatusCode, Date, ErrorCode, Notes)"
   , "	VALUES (", runNumber, ",", projectID, ",", procNumber, ",", subProcNum
   , ",", statusCode, ",", eventDate, ",", errorCode, ",'", notes, "' );" )  
  
  
  dbSendQuery( dbConn, insertQuery )
										
}


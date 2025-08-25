/*******************************************************************************
* BICatalogs.jss
* Get catalog tables needed
* 
* Carlos Kassab
* 2025-August-20
********************************************************************************/

load('BICatalogsConfig.jss') // Loading ETL script configuration file
load('../../../GeneralLibraries/ETL_GeneralLibs.jss') // Loading the collection of libraries used by all ETL scripts
load('../Queries/SitesQueries.jss')

var date = Date()
print(date)

var procSequences; // Declare it but keep it undefined
const processRunNumber = GetNumericDateTime()
print("Process Run Number(RunNumber):" + processRunNumber)
if( parameters.length > 1 ) { // Get parameter values if they exists
  try {
    function myFunction(myVar, index, arr) {
      // The script path folder must always be included.
      // Avoid blank spaces with equal sign ==>> scriptPath=$scriptpath
      if(myVar.substr(0, 10) === "scriptPath") { 
        scriptPath = arr[index].split("=")[1]
        //print("Working Directory:" + scriptPath) 
      }

      if(myVar.substr(0, 10) === "procSequences") { 
        scriptPath = arr[index].split("=")[1]
        //print("Working Directory:" + scriptPath) 
      }      
    }
    parameters.forEach(myFunction)
  } catch(error) {
    print("Error getting parameters:" + error)
  } finally {
    if (typeof procSequences === "undefined") {
      procSequences = [99]
    }    
  }
}


// Preparing the log file
const logFileDateValue = GetNumericDateTime()
const logFileName = config.logsFolder + logFileDateValue + ".txt"
const eightyStars = "********************************************************************************\n"
var errorsInETL = false // Flag to send Email alert to admins in case of ETL error

//################################################################################
// Opening DataBase Connections.
//################################################################################

WriteToTextFile("******************       Opening DataBase Connections.      *******************\n", logFileName)

try {
  // ETLMS tables are in target DB, Opening TARGET DB connection first
  WriteToTextFile("******************    Opening Target DataBase Connection.   *******************\n", logFileName)  
  targetDBConn = sqliteDBConn(config.targetDBPath)
  WriteToTextFile("*****************  Opening Target DataBase Connection Done.  ******************\n", logFileName)  

} catch (error) {
  WriteToTextFile("**************** Error Opening Target DataBase Connection. ******************\n" + error + "\n", logFileName)
  // Send email alert to admins
  SendEmail( config.emailRecipients, "Error with process run number:" + processRunNumber,
             "<p><strong>Error opening target database connection, check text file logs for details.</strong></p>" + error )    
}


try {
  // ### Logging to ETLMS ==> main process start.
  WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 0, 0, 1, 0, 'ETL Process Start.' )
  //### Opening Data Source Connection.
  WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 100, 0, 1, 0, 'Opening Data Source Connection.' )

  sourceDBConn = h2DBConn(config.sourceDBPath, config.sourceDBUser, config.sourceDBPassword);

  //### Opening Data Source Connection Done Successfully.
  WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 100, 0, 2, 0, 'Data Source Connected Successfully.' )
} catch (error) {
  WriteToTextFile(eightyStars + "**************** Error Opening DataBase Connections. ******************\n" + error + "\n", logFileName)
  //### Opening Data Source Connection Error.
  WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 100, 3, 3001, exceptionError )
  
  //# Problems with the data source, stop ETL process.
  WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 0, 3, 3001, exceptionError )  
  
  // Send email alert to admins
  SendEmail( config.emailRecipients, "Error with process run number:" + processRunNumber,
             "<p><strong>Data Source Connection Error.</strong></p><p>" + error )    
}


/*******************************************************************************
# Start processing ETL process sequences
********************************************************************************/
for (let procSeq = 0; procSeq < procSequences.length; procSeq++) {

  /**************************************************************************
  # Run get(read) sites catalog
  ***************************************************************************/
  if( procSequences[procSeq] === 99 || procSequences[procSeq] === 200 ) {
    // Read Data And Store it in Target DataBase - Start.
    WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 200, 0, 1, 0, '' )    
    try {
      WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 200, 205, 1, 0, '' )
      load( "../Libraries/SitesCatalog.jss" ) // Import ETL Library For Catalog.
      WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 200, 205, 2, 0, '' )

      // Read Data And Store it in Target DataBase
      WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 200, 206, 1, 0, '' )
      if( MainProcess( sourceDBConn, targetDBConn, processRunNumber, config.projectCode, 200 ) ) {
        WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 200, 206, 2, 0, '' )
      } else {
        WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 200, 206, 3, 3002, '' ) // Error.
        errorsInETL = true
      }      
    } catch (error) {
      // Catalog Library Cannot be Imported.
      WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 200, 205, 3, 3002, '' )

      // Cannot Read Data And Store it in Target DataBase.
      WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 200, 0, 3, 3003, 'ETL Library For Catalog Cannot be Imported' )
      errorsInETL = true
    } finally {}
  } //if( procSequences[procSeq] === 99 || procSequences[procSeq] === 200 ) {


  /**************************************************************************
  # Run get production line catalog
  ***************************************************************************/
  if( procSequences[procSeq] === 99 || procSequences[procSeq] === 300 ) {
    // Read Data And Store it in Target DataBase - Start.
    WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 300, 0, 1, 0, '' )    
    try {
      WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 300, 305, 1, 0, '' )
      load( "../Libraries/ProductionLineCatalog.jss" ) // Import ETL Library For Catalog.
      WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 300, 305, 2, 0, '' )

      // Read Data And Store it in Target DataBase
      WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 300, 306, 1, 0, '' )
      if( MainProcess( sourceDBConn, targetDBConn, processRunNumber, config.projectCode, 300 ) ) {
        WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 300, 306, 2, 0, '' )
      } else {
        WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 300, 306, 3, 300, 'Process Error, Check Logs.' ) // Error.
        errorsInETL = true
      }      
    } catch (error) {
      // Catalog Library Cannot be Imported.
      WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 300, 305, 3, 305, '' )

      // Error Reading Data And Store it in Target DataBase.
      WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 300, 0, 3, 300, 'ETL Library For Catalog Cannot be Imported' )
      errorsInETL = true
    } finally {}
  } //if( procSequences[procSeq] === 99 || procSequences[procSeq] === 300 ) {  
} 


/*******************************************************************************
# Closing ETL
********************************************************************************/

// Send alert to admins about the ETL process status
if( errorsInETL === true ){
  WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 0, 0, 3, 0, 'Error Ending ETL Process.' )  
  SendEmail( config.emailRecipients, "Catalogs ETL Error with process run number:" + processRunNumber,
             "<p><strong>Catalogs ETL process finished with errors, check logs.</strong></p>" )
} else {
  WriteETLMSLog( targetDBConn, processRunNumber, config.projectCode, 0, 0, 2, 0, 'Successfully Ending ETL Process.' )
  SendEmail( config.emailRecipients, "Catalogs ETL process done successfully, run number:" + processRunNumber,
            "<p><strong>Catalogs ETL process done successfully.</strong></p>" )  
}


/*******************************************************************************
#  Closing DataBase Connections
********************************************************************************/

try {
  sourceDBConn.close()
} catch (error) {
  WriteToTextFile("**************** Error Clossing Source DataBase Connection. ******************\n" + error + "\n", logFileName)
}


try {
  targetDBConn.close()
} catch (error) {
  WriteToTextFile("**************** Error Opening Target DataBase Connection. ******************\n" + error + "\n", logFileName)
}






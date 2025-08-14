#*******************************************************************************
#* BICatalogs.R
#* Get catalog tables needed
#* 
#* Carlos Kassab
#* 2019-January-24
#*******************************************************************************
#args = c( "/home/ckassab/Development/ETLs/ETLsHowTo/ETLsWithR/Projects/Catalogs/Scripts" ) # Example of arguments

args <- commandArgs( trailingOnly = TRUE ) # read script arguments

setwd( args[1] ) # Always the first argument must be the actual script path folder, normally passed by the shell/batch file.

procSequences = c() # Initialize vector with proc sequences to run
# proc sequences are steps to run in the ETL script, like read data, transform data, etc.

if( length( args ) > 1 ) {
  for( i in 2:length( args ) ) {
    if( i == 2 ) {
      processRunNumber = args[i] #
    }
    
    if( i > 2 ) {
      # Copy proc sequences to execute to a separate vector variable
      procSequences = c( procSequences, args[i] )
    }
  }
  
} else {
  processRunNumber = paste0( format( Sys.Date(), "%Y%m%d" )
                             , format( Sys.time(), "%H%M%S" ) ) # "yyyyMMddHHmmss"
  procSequences = c( 99 ) # Proc sequence 99 means: run all process sequences in this ETL script
  procSequences = c( 300 )
}

### Loading ETL script configuration file
source( "BICatalogsConfig.R" )

###   Delete old log files   ###
lastWrite = Sys.Date() - numDaysToKeepLogFiles
logFiles = list.files( logsFolder, full.names = TRUE )
for( i in 1: length( logFiles ) ){
  if( file.info( logFiles[i] )[2] == FALSE ) { # Is file?
    fileDate = strsplit( as.character( file.mtime( logFiles[i] ) ), " " )[[1]][1]
    if( fileDate < lastWrite ) {
      file.remove( logFiles[i] ) # Delete file
    }
  }
}
  

logFileDateValue = paste0( format( Sys.Date(), "%Y%m%d" )
                           , format( Sys.time(), "%H%M%S" ) ) # "yyyyMMddHHmmss"

logFileName = paste0( logsFolder, logFileDateValue, ".txt" )
eightyStars = "********************************************************************************\n"

errorsInETL = FALSE # Flag to send Email alert to admins in case of ETL error


################################################################################
# Loading the collection of libraries used by all ETL scripts
################################################################################

if( file.exists( "../../../GeneralLibraries/ETL_GeneralLibs.R" ) ) {
  write( "Importing ../../../GeneralLibraries/ETL_GeneralLibs.R"
         , file = logFileName, append = FALSE )
  
  tryCatch( {
    source( "../../../GeneralLibraries/ETL_GeneralLibs.R" )
  }, error = function( exceptionError ) {
    write( paste( eightyStars, "Libraries file"
                  , "../../../GeneralLibraries/ETL_GeneralLibs.R"
                  , "cannot be imported.", exceptionError )
           , file = logFileName, append = TRUE )     
    q( save = "no" )
  } )
  
  write( paste( eightyStars, "Libraries file"
                , "../../../GeneralLibraries/ETL_GeneralLibs.R"
                , "Successfully imported." )
         , file = logFileName, append = TRUE )  
} else {
  write( "Libraries file ../../../GeneralLibraries/ETL_GeneralLibs.R not found."
         , file = logFileName, append = FALSE )
  q( save = "no" )
}


################################################################################
# Opening DataBase Connections.
################################################################################

write( paste( eightyStars, "******************       Opening DataBase Connections.      "
              , "*******************" )
       , file = logFileName, append = TRUE )

tryCatch( {
  # ETLMS tables are in target DB, Opening TARGET DB connection first
  write( paste( eightyStars, "******************       Opening Target DataBase Connection.    "
                , "*******************" )
         , file = logFileName, append = TRUE )
  
  targetDBConn = sqliteDBConn(targetDBPath)
  
  write( paste( eightyStars, "****************** Opening Target DataBase Connection Done"
                , "Succesfully. *******************" )
         , file = logFileName, append = TRUE )  
  
}, error = function( exceptionError ) {
  write( paste( eightyStars, "ERROR Openning Target Database Connection.", exceptionError )
         , file = logFileName, append = TRUE )
  # Send email alert to admins
  SendEmail( emailRecipients, paste( "Error with process run number:", processRunNumber )
             , "<p><strong>Error opening target database connection, check text file logs for details.</strong></p>", exceptionError )  
  q( save = "no" )
} )


tryCatch( {
  ### Logging to ETLMS ==> main process start.
  WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 0, 0, 1, 0, 'ETL Process Start.' )
  ### Opening Data Source Connection.
  WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 100, 0, 1, 0, 'Opening Data Source Connection.' )
  
  sourceDBConn = h2DBConn(sourceDBPath, sourceDBjarPath, sourceDBUser, sourceDBPassword)

  ### Opening Data Source Connection Done Successfully.
  WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 100, 0, 2, 0, 'Data Source Connected Successfully.' )
}, error = function( exceptionError ) {
  write( paste( eightyStars, "Error Openning Database Connections.", exceptionError )
         , file = logFileName, append = TRUE )  
  ### Opening Data Source Connection Error.
  WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 100, 3, 3001, exceptionError )
  
  # Problems with the data source, stop process.
  WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 0, 3, 3001, exceptionError )
  
  # Alert admins
  SendEmail( emailRecipients, paste( "Error with process run number:", processRunNumber )
             , "<p><strong>Data Source Connection Error.</strong></p><p>", exceptionError, "</p>" )
  
  q( save = "no" )
} )


################################################################################
# Start processing ETL process sequences
################################################################################
for( procSeq in 1:length( procSequences ) ) {
  
  ###########################################################################
  # Run get(read) sites catalog
  ###########################################################################  
  if( procSequences[procSeq] == 99 || procSequences[procSeq] == 200 ) {
    
    # Read Data And Store it in Target DataBase - Start.
    WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 0, 1, 0, '' )
    tryCatch( {
      WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 205, 1, 0, '' )
      source( "../Libraries/SitesCatalog.R" ) # Import ETL Library For Catalog.
      WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 205, 2, 0, '' )
      
      # Read Data And Store it in Target DataBase
      WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 206, 1, 0, '' )
      if( MainProcess( sourceDBConn, targetDBConn, processRunNumber, projectCode, 200 ) ) {
        WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 206, 2, 0, '' )
      } else {
        WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 206, 3, 3002, '' ) # Error.
        errorsInETL = TRUE
      }
      
    }, error = function( exceptionError ) {
      
      # Catalog Library Cannot be Imported.
      WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 205, 3, 3002, '' )

      # Cannot Read Data And Store it in Target DataBase.
      WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 0, 3, 3003, 'ETL Library For Catalog Cannot be Imported' )
      errorsInETL = TRUE
    } )
    
  } # if( procSequences[procSeq] == 99 || procSequences[procSeq] == 200 ) {
  
  
  ###########################################################################
  # Run get production line catalog 
  ###########################################################################  
  if( procSequences[procSeq] == 99 || procSequences[procSeq] == 300 ) {
    
    # Read Data And Store it in Target DataBase - Start.
    WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 300, 0, 1, 0, '' )
    tryCatch( {
      WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 300, 305, 1, 0, '' )
      source( "../Libraries/ProductionLineCatalog.R" ) # Import ETL Library For Catalog.
      WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 300, 305, 2, 0, '' )
      
      # Read Data And Store it in Target DataBase
      WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 300, 306, 1, 0, '' )
      if( MainProcess( sourceDBConn, targetDBConn, processRunNumber, projectCode, 300 ) ) {
        WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 300, 306, 2, 0, '' )
      } else {
        WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 300, 306, 3, 300, 'Process Error, Check Logs.' ) #Error.
        errorsInETL = TRUE
      }
      
    }, error = function( exceptionError ) {
      
      # Catalog Library Cannot be Imported.
      WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 300, 305, 3, 305, '' )
      
      # Read Data And Store it in Target DataBase Error.
      WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 300, 0, 3, 300, 'ETL Library For Catalog Cannot be Imported' ) 
      errorsInETL = TRUE
    } )
    
  } # if( procSequences[procSeq] == 99 || procSequences[procSeq] == 300 ) {
  

} # for( procSeq in 1:length( procSequences ) ) {



#*******************************************************************************
# Closing ETL
#*******************************************************************************

# Send alert to admins about the ETL process status
if( errorsInETL ){
  WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 0, 0, 3, 0, 'Error Ending ETL Process.' )  
  SendEmail( emailRecipients, paste( "Catalogs ETL Error with process run number:", processRunNumber )
             , "<p><strong>Catalogs ETL process finished with errors, check logs.</strong></p>" )
} else {
  WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 0, 0, 2, 0, 'Successfully Ending ETL Process.' )
  SendEmail( emailRecipients, paste( "Catalogs ETL process done successfully, run number:", processRunNumber )
           , "<p><strong>Catalogs ETL process done successfully.</strong></p>" )  
}


#*******************************************************************************
#  Closing DataBase Connections
#*******************************************************************************

tryCatch( { 
  dbDisconnect( targetDBConn )
}, error = function( exceptionError ) {
  } )

tryCatch( { 
  dbDisconnect( sourceDBConn )
}, error = function( exceptionError ) {
} )




  
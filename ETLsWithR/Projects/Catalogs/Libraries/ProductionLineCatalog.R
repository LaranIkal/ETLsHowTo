#*******************************************************************************
#* ProductionLineCatalog.R
#* Production line Catalog
#* Carlos Kassab
#* 2019-Jan-29
#*******************************************************************************


#*******************************************************************************
# This function may be called to execute any code before the sql query for data
# extraction.
#*******************************************************************************
BeforeDataExtract = function( srcConn, trgtConn, procRunNum, projectID, procNum ) {
  
  tryCatch( {
    print( "Do something and return a value." )
    return( c(1,2,3,4) )
  }, error = function( ex ) {
    print( paste( "Cannot run process:", ex ) )
    return( FALSE )
  } )   
  
}




#*******************************************************************************
# This function is to extract data from source database, Product Line catalog table by 
# executing the select query in queries script.
#*******************************************************************************

DataExtract = function( srcConn, trgtConn, procRunNum, projectID, procNum, getDataQuery ) {
  
  tryCatch( {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 310, 1, 0, '' ) # Start.
    sourceData = dbGetQuery( srcConn, getDataQuery )
    names(sourceData)[names(sourceData) == 'LINECODE'] <- 'LineCode' 
    names(sourceData)[names(sourceData) == 'LINEDESCRIPTION'] <- 'LineDescription'    
    WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 310, 2, 0, '' ) # End
    return( sourceData )
  }, error = function( ex ) {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 310, 3, 310, paste( "Error reading catalogs from Source Table:", ex ) )
    return( FALSE )
  } )   
  
}




#*******************************************************************************
# Process data after data was read from source table
#*******************************************************************************

AfterDataExtract = function( dataExtracted, trgtConn, procRunNum, projectID
                                  , procId, deleteQuery ) {
  
  tryCatch( {
    # Truncate Target Table.
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 315, 1, 0, '' )
    truncateResult = dbSendQuery( trgtConn, deleteQuery )
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 315, 2, 0, '' )
  }, error = function( ex ) {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 315, 3, 0, paste( "Error truncating table:", ex ) )
    return( FALSE )
  } )   

  tryCatch( {
    # Insert New Data Into Target Table.
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 320, 1, 0, '' )
    insertResult = dbWriteTable( trgtConn, "CAT_ProductionLine", dataExtracted, append = T, row.names = FALSE )
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 320, 2, 0, '' )
    return( TRUE )
  }, error = function( ex ) {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 320, 3, 0, paste( "Error inserting into table:", ex ) )
    return( FALSE )
  } )   
  
}



MainProcess = function( srcConn, trgtConn, procRunNum, projectID, procId ){
  tryCatch( {
    source( "../Queries/ProductionLineQueries.R" )

    dataExtracted = DataExtract( srcConn, trgtConn, procRunNum, projectID
                                      , procId, selectQuery )
    
    if( typeof( dataExtracted ) == "logical" ) return( FALSE )
    
    if( !AfterDataExtract( dataExtracted, trgtConn, procRunNum, projectID, procId, truncateQuery ) ) return( FALSE )

    return( TRUE )
  }, error = function( ex ) {
    print( paste( "Cannot read query data:", ex ) )
    return( FALSE )
  } )  
  
  
}




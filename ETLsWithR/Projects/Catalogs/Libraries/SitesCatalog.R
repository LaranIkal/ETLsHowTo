#*******************************************************************************
#* SitesCatalog.R
#* Sites Catalog
#* Carlos Kassab
#* 2019-Jan-28
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
# This function is to extract data from source database, sites catalog table by 
# executing the select query in queries script.
#*******************************************************************************

DataExtract = function( srcConn, trgtConn, procRunNum, projectID, procNum, getDataQuery ) {
  
  tryCatch( {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 210, 1, 0, '' ) # Start.
    sourceData = dbGetQuery( srcConn, getDataQuery )
    names(sourceData)[names(sourceData) == 'ID'] <- 'SiteID' 
    names(sourceData)[names(sourceData) == 'SITE'] <- 'Site'
    names(sourceData)[names(sourceData) == 'DESCRIPTION'] <- 'Description'
    WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 210, 2, 0, '' ) # End
    return( sourceData )
  }, error = function( ex ) {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 210, 3, 3003, paste( "Error reading sites catalog:", ex ) )
    return( FALSE )
  } )   
  
}



#*******************************************************************************
# Process data after data was read from source table.
#*******************************************************************************

AfterDataExtract = function( dataExtracted, trgtConn, procRunNum, projectID
                            , procId, deleteQuery ) {
  
  tryCatch( {
    # Truncate Table on Target DB.
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 215, 1, 0, '' )
    truncateResult = dbSendQuery( trgtConn, deleteQuery )
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 215, 2, 0, '' )
  }, error = function( ex ) {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 215, 3, 3003, paste( "Error truncating sites table:", ex ) )
    return( FALSE )
  } )   

  tryCatch( {
    # Insert New Data Into Target Table.
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 220, 1, 0, '' )
    insertResult = dbWriteTable( trgtConn, "CAT_Sites", dataExtracted, append = T, row.names = FALSE )
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 220, 2, 0, '' )
    return( TRUE )
  }, error = function( ex ) {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 220, 3, 3003, paste( "Error inserting into sites table:", ex ) )
    return( FALSE )
  } )   
  
}



#*******************************************************************************
# After Loading This File, Call This function to process data.
#*******************************************************************************

MainProcess = function( srcConn, trgtConn, procRunNum, projectID, procId ){
  tryCatch( {
    source( "../Queries/SitesQueries.R" )

    dataExtracted = DataExtract( srcConn, trgtConn, procRunNum, projectID, procId, selectQuery )
    
    if( typeof( dataExtracted ) == "logical" ) return( FALSE )
    
    if( !AfterDataExtract( dataExtracted, trgtConn, procRunNum, projectID, procId, truncateQuery ) ) return( FALSE )

    return( TRUE )
  }, error = function( ex ) {
    print( paste( "Cannot read sites query data:", ex ) )
    return( FALSE )
  } )
  
}

/*******************************************************************************
#* SitesCatalog.jss
#* Sites Catalog
#* Carlos Kassab
#* 2025-August-20
********************************************************************************/


/*******************************************************************************
 This function may be called to execute any code before the sql query for data
 extraction.
********************************************************************************/
var BeforeDataExtract = function( srcConn, trgtConn, procRunNum, projectID, procNum ) {
  
  try {
    print( "Do something and return a value." )
    return( 3333 )
  } catch(error) {
    print("Cannot run process:" + error)
    return false
  }
  
}



/*******************************************************************************
 This function is to extract data from source database, sites catalog table by 
 executing the select query in queries script.
********************************************************************************/
var DataExtract = function( srcConn, trgtConn, procRunNum, projectID, procNum, getDataQuery ) {
  
  try {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 210, 1, 0, '' ) // Start.
    var stmt = srcConn.prepareStatement(getDataQuery)
    var sourceData = stmt.executeQuery()
    WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 210, 2, 0, '' ) // End
    return( sourceData )
  } catch(error) {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 210, 3, 3003, "Error reading sites catalog:" + error )
    return false
  }
  
}



/*******************************************************************************
* Process data after data was read from source DB.
********************************************************************************/
var AfterDataExtract = function( dataExtracted, trgtConn, procRunNum, projectID
                                , procId, deleteQuery ) {
  
  try {
    // Truncate Table on Target DB.
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 215, 1, 0, '' )
    var truncateStmt = trgtConn.createStatement()
    truncateStmt.execute(deleteQuery)    
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 215, 2, 0, '' )
  } catch(error) {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 215, 3, 3003, "Error truncating CAT_Sites table:" + error )
    return false
  }

  try {
    // Insert New Data Into Target Table.
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 220, 1, 0, '' )
    var insertStatement = ""
    var insertStmt = trgtConn.createStatement()
    while (dataExtracted.next()) {
      //print( "- SiteID = " + dataExtracted.getString(1) + " - Site: " +  + " - Description: " + dataExtracted.getString(3) + "\n" )
      insertStatement = "INSERT INTO CAT_Sites (SiteID, Site, Description) VALUES(" 
                        + dataExtracted.getString(1) + ",'" + dataExtracted.getString(2) + "', '" + dataExtracted.getString(3) + "');"
      insertStmt.execute(insertStatement)
    }
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 220, 2, 0, '' )
    return true
  } catch(error) {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 220, 3, 3003, "Error inserting into CAT_Sites table:" + error )
    return false
  }
  
}



/*******************************************************************************
* After Loading This File, Call This function to process data.
********************************************************************************/
var MainProcess = function( srcConn, trgtConn, procRunNum, projectID, procId ) {
  try {
    load( '../Queries/SitesQueries.jss' )

    var dataExtracted = DataExtract( srcConn, trgtConn, procRunNum, projectID, procId, selectQuery )
    
    if( typeof dataExtracted  === "boolean" ) return false
    
    if( !AfterDataExtract( dataExtracted, trgtConn, procRunNum, projectID, procId, truncateQuery ) ) return false

    return true
  } catch(error) {
    print( "Cannot read sites query data:" + error )
    return false
  }
  
}

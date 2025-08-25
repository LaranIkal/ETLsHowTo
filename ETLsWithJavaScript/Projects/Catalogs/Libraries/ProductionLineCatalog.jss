/*******************************************************************************
#* ProductionLineCatalog.jss
#* Production Line Catalog
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
    WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 310, 1, 0, '' ) // Start.
    var stmt = srcConn.prepareStatement(getDataQuery)
    var sourceData = stmt.executeQuery()
    WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 310, 2, 0, '' ) // End
    return( sourceData )
  } catch(error) {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 310, 3, 310, "Error reading PRODUCTIONLINE catalog:" + error )
    return false
  }
  
}



/*******************************************************************************
* Process data after data was read from source table.
********************************************************************************/
var AfterDataExtract = function( dataExtracted, trgtConn, procRunNum, projectID
                                , procId, deleteQuery ) {
  
  try {
    // Truncate Table on Target DB.
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 315, 1, 0, '' )
    var truncateStmt = trgtConn.createStatement()
    truncateStmt.execute(deleteQuery)    
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 315, 2, 0, '' )
  } catch(error) {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 315, 3, 0, "Error truncating CAT_ProductionLine table:" + error )
    return false
  }

  try {
    // Insert New Data Into Target Table.
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 320, 1, 0, '' )
    var insertStatement = ""
    var insertStmt = trgtConn.createStatement()
    while (dataExtracted.next()) {
      //print( "- LineCode = " + dataExtracted.getString(1) + " - LineDescription: " + dataExtracted.getString(2) + "\n" )
      insertStatement = "INSERT INTO CAT_ProductionLine (LineCode, LineDescription) VALUES("
                        + "'" + dataExtracted.getString(1) + "', '" + dataExtracted.getString(2) + "');"
      insertStmt.execute(insertStatement)
    }
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 320, 2, 0, '' )
    return true
  } catch(error) {
    WriteETLMSLog( trgtConn, procRunNum, projectID, procId, 320, 3, 0, "Error inserting into CAT_ProductionLine table:" + error )
    return false
  }
  
}



/*******************************************************************************
* After Loading This File, Call This function to process data.
********************************************************************************/
var MainProcess = function( srcConn, trgtConn, procRunNum, projectID, procId ) {
  try {
    load( '../Queries/ProductionLineQueries.jss' )

    var dataExtracted = DataExtract( srcConn, trgtConn, procRunNum, projectID, procId, selectQuery )
    
    if( typeof dataExtracted  === "boolean" ) return false
    
    if( !AfterDataExtract( dataExtracted, trgtConn, procRunNum, projectID, procId, truncateQuery ) ) return false

    return true
  } catch(error) {
    print( "Cannot read ProductionLineQueries query data:" + error )
    return false
  }
  
}

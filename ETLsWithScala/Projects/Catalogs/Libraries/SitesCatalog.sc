
import java.sql._

/*******************************************************************************
 This method may be called to execute any logic before the sql query for data
 extraction.
********************************************************************************/
def BeforeDataExtract(srcConn: Connection, trgtConn: Connection, procRunNum: String, projectID: Int, procNum: Int): Any = {
  try {
    println( "Do something and return a value." )
    return 3333
  } catch {
    case error: Exception => {
      println(s"Cannot execute BeforeDataExtract:${error.getMessage()}")
      return -1
    }
  }  
}



/*******************************************************************************
 This method is to extract data from source database, sites catalog table by 
 executing the select query in queries script.
********************************************************************************/
def DataExtract(srcConn: Connection, writeETLMSLog: (Int, Int, Int, String ) => Unit): ResultSet = {
  
  val sourceData = try { // Using EOP(Expression Oriented Programming) style
    println( "Extract Data from Source DataBase." )
    val stmt = srcConn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY)
    stmt.executeQuery(SitesQueries.selectQuery)
    stmt.getResultSet
  } catch {
    case error: Exception => {
      println(s"Cannot execute DataExtract:${error.getMessage()}")
      writeETLMSLog(210,3,3003,s"Cannot execute DataExtract:${error.getMessage()}")
      return null
    }
  }

  return sourceData
}



/*******************************************************************************
* Process data after data was read from source DB.
********************************************************************************/
def AfterDataExtract(trgtConn: Connection, dataExtracted: java.sql.ResultSet, writeETLMSLog: (Int, Int, Int, String ) => Unit): Boolean = {

  var processStatus = false

  try {
    // Truncate Table on Target DB.
    writeETLMSLog( 215, 1, 0, "" )
    val truncateStmt = trgtConn.createStatement()
    val rowsAffected = truncateStmt.executeUpdate(SitesQueries.truncateQuery)
    writeETLMSLog(215, 2, 0, "" )
    processStatus = true
  } catch {
    case error: Exception => {
      writeETLMSLog(215, 3, 3003, s"Error truncating CAT_Sites table: ${error.getMessage()}")
      processStatus = false
    }
  }

  try {
    // Insert New Data Into Target Table.
    writeETLMSLog( 220, 1, 0, "" )
    val insertStmt = trgtConn.prepareStatement(SitesQueries.insertQuery)
    
    while (dataExtracted.next()) {
      insertStmt.setInt(2, dataExtracted.getInt("SiteID"))
      insertStmt.setString(2, dataExtracted.getString("SITE"))
      insertStmt.setString(3, dataExtracted.getString("DESCRIPTION"))
      insertStmt.executeUpdate()
    }
    insertStmt.close()
    writeETLMSLog(220, 2, 0, "" )
    processStatus = true
  } catch {
    case error: Exception => {
      writeETLMSLog(220, 3, 3003, s"Error inserting into CAT_Sites table: ${error.getMessage()}")
      processStatus = false
    }
  }

  return processStatus
}



/*******************************************************************************
* After Loading This File, Call This function to run the ETL process.
********************************************************************************/
def MainProcess( srcConn: Connection, trgtConn: Connection, procRunNum: String, projectID: Int, procNum: Int, logFileName: String, writeETLLog: (Int, Int, Int, String) => Unit ): Boolean = {
  
  var processStatus = false

  try {

    println(s"Catalogs Select Query:${SitesQueries.selectQuery}")
    writeETLLog(210, 1, 0, "")
    val dataExtracted = DataExtract(srcConn, writeETLLog( _: Int, _: Int, _: Int, _: String ))
    writeETLLog(210, 2, 0, "")

    if(dataExtracted.next()) {
      dataExtracted.beforeFirst() // Reset cursor before calling method to insert rows
      if !AfterDataExtract(trgtConn, dataExtracted, writeETLLog( _: Int, _: Int, _: Int, _: String ) ) then processStatus = true
    }
    dataExtracted.close()
    
    processStatus = true
  } catch {
    case error: Exception => {
      println(s"Cannot execute MainProcess:${error.getMessage()}")
      processStatus = false
    }
  }

  return processStatus
}


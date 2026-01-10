error id: file://<WORKSPACE>/Libraries/SitesCatalog.sc:createStatement.
file://<WORKSPACE>/Libraries/SitesCatalog.sc
empty definition using pc, found symbol in pc: createStatement.
semanticdb not found
empty definition using fallback
non-local guesses:
	 -java/sql/conn/createStatement.
	 -java/sql/conn/createStatement#
	 -java/sql/conn/createStatement().
	 -conn/createStatement.
	 -conn/createStatement#
	 -conn/createStatement().
	 -scala/Predef.conn.createStatement.
	 -scala/Predef.conn.createStatement#
	 -scala/Predef.conn.createStatement().
offset: 1108
uri: file://<WORKSPACE>/Libraries/SitesCatalog.sc
text:
```scala
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
 This function is to extract data from source database, sites catalog table by 
 executing the select query in queries script.
********************************************************************************/
def DataExtract(srcConn: Connection, trgtConn: Connection, procRunNum: String, projectID: Int, procNum: Int, getDataQuery: String): ResultSet = {
  
  val sourceData = try {

    val stmt = conn.cr@@eateStatement()
    stmt.executeQuery("SELECT id, name FROM users")    
    println( "Extract Data from Source DataBase." )
    return 
  } catch {
    case error: Exception => {
      println(s"Cannot execute DataExtract:${error.getMessage()}")
      return List()
    }
  }  
}





def MainProcess( srcConn: Connection, trgtConn: Connection, procRunNum: String, projectID: Int, procNum: Int ): Boolean = {
  try {
    //> using file Queries/SitesQueries.sc
    println( "Extract Data from Source DataBase and Load it to Target DataBase." )
    return true
  } catch {
    case error: Exception => {
      println(s"Cannot execute MainProcess:${error.getMessage()}")
      return false
    }
  }  
}








```


#### Short summary: 

empty definition using pc, found symbol in pc: createStatement.
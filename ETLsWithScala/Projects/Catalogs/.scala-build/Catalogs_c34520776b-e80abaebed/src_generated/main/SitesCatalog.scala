

final class SitesCatalog$_ {
def args = SitesCatalog_sc.args$
def scriptPath = """SitesCatalog.sc"""
/*<script>*/


// //> using file ../../../GeneralLibraries/Utils.sc
//import Utils_sc.script

import java.sql._

/*******************************************************************************
 This method may be called to execute any logic before the sql query for data
 extraction.
********************************************************************************/
override def BeforeDataExtract(srcConn: Connection, trgtConn: Connection, procRunNum: String, projectID: Int, procNum: Int): Any = {
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
override def DataExtract(srcConn: Connection, trgtConn: Connection, procRunNum: String, projectID: Int, procNum: Int, getDataQuery: String, logFileName: String ): ResultSet = {
  
  val sourceData = try { // Using EOP(Expression Oriented Programming) style
    println( "Extract Data from Source DataBase." )
    //WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 200, 1, 0, "", logFileName ) // Start.
    //WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 210, 1, 0, "", logFileName ) // Start.
    //Utils.WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 220, 1, 0, "", logFileName ) // Running.
    val stmt = srcConn.createStatement()
    stmt.executeQuery(getDataQuery)
    stmt.getResultSet
  } catch {
    case error: Exception => {
      println(s"Cannot execute DataExtract:${error.getMessage()}")
      return null
    }
  }
  return sourceData
}





override def MainProcess( srcConn: Connection, trgtConn: Connection, procRunNum: String, projectID: Int, procNum: Int, logFileName: String, writeETLLog: (Int, Int, Int, String) => Unit ): Boolean = {
  try {
    //> using file Queries/SitesQueries.sc
    //println( "Extract Data from Source DataBase and Load it to Target DataBase." )
    //writeETLLog.asInstanceOf[( Connection, String, Int, Int, Int, Int, Int, String, String ) => Unit]
    //  .apply( trgtConn, procRunNum, projectID, procNum, 210, 1, 0, "", logFileName ) // Start.
    writeETLLog(210, 1, 0, "")
    //Utils.WriteETLMSLog( trgtConn, procRunNum, projectID, procNum, 0, 1, 0, "", logFileName ) // Start.
    // Call the MainProcess method from SitesCatalog library
    return true
  } catch {
    case error: Exception => {
      println(s"Cannot execute MainProcess:${error.getMessage()}")
      return false
    }
  }  
}








/*</script>*/ /*<generated>*//*</generated>*/
}

object SitesCatalog_sc {
  private var args$opt0 = Option.empty[Array[String]]
  def args$set(args: Array[String]): Unit = {
    args$opt0 = Some(args)
  }
  def args$opt: Option[Array[String]] = args$opt0
  def args$: Array[String] = args$opt.getOrElse {
    sys.error("No arguments passed to this script")
  }

  lazy val script = new SitesCatalog$_

  def main(args: Array[String]): Unit = {
    args$set(args)
    val _ = script.hashCode() // hashCode to clear scalac warning about pure expression in statement position
  }
}

export SitesCatalog_sc.script as `SitesCatalog`


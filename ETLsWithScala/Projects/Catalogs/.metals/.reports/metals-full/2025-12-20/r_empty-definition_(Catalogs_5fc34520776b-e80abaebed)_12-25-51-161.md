file://<WORKSPACE>/Catalogs.sc
empty definition using pc, found symbol in pc: 
semanticdb not found
empty definition using fallback
non-local guesses:
	 -logFileName.
	 -logFileName#
	 -logFileName().
	 -scala/Predef.logFileName.
	 -scala/Predef.logFileName#
	 -scala/Predef.logFileName().
offset: 2128
uri: file://<WORKSPACE>/Catalogs.sc
text:
```scala

//> using scala "3"
//> using toolkit default
//> using file Libraries // import all from Libraries directory
//> using file ../../GeneralLibraries // import all common libraries

import java.time.LocalDateTime
import java.time.format.DateTimeFormatter


object script {

  def main(parameters: Array[String]): Unit = { 
    if (parameters.isEmpty) {
      println("dude, i need at least one parameter")
      sys.exit(1)
    }
    val filename = parameters(0)

    val catalogsConfig = Utils.LoadConfig("Catalogs.config")
    val logFileDateValue = LocalDateTime.now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
    val logFileName = s"${catalogsConfig("logsFolder")}/$logFileDateValue.txt"


    Utils.WriteToTextFile(s"Log entry at $logFileDateValue\n", logFileName)
    Utils.WriteToTextFile(s"Another log entry at $logFileDateValue\n", logFileName)

    

    println(catalogsConfig("sourceDBPath"))

    //################################################################################
    // Opening DataBase Connections.
    //################################################################################

    Utils.WriteToTextFile("******************       Opening DataBase Connections.      *******************\n", logFileName)

    val targetDBConn = try {
      // ETLMS tables are in target DB, Opening TARGET DB connection first
      Utils.WriteToTextFile("******************    Opening Target DataBase Connection.   *******************\n", logFileName)
      DataBaseConnections.sqliteDBConn(catalogsConfig("targetDBPath"))
      Utils.WriteToTextFile("*****************  Opening Target DataBase Connection Done.  ******************\n", logFileName)
    } catch {
      
      case e: Exception => { println(s"Error connecting to target database: ${e.getMessage}") }
        Utils.WriteToTextFile("**************** Error Opening Target DataBase Connection. ******************\n" + error + "\n", logFileName)
    }



    // Connecting to sourcedb and getting some data.

    try {
      Utils.WriteToTextFile("******************    Opening Source DataBase Connection.   *******************\n", logF@@ileName)
      println("Source DB Path:" + catalogsConfig("sourceDBPath"))
      val sourceDBConn = DataBaseConnections.h2DBConn(
        catalogsConfig("sourceDBPath"),
        catalogsConfig("sourceDBUser"),
        catalogsConfig("sourceDBPassword")
      )
      Utils.WriteToTextFile("*****************  Opening Source DataBase Connection Done.  ******************\n", logFileName)

      val selectQuery = "SELECT ID AS SiteID, SITE, DESCRIPTION FROM PUBLIC.SITES;"
      val stmt = sourceDBConn.prepareStatement(selectQuery)
      val myData = stmt.executeQuery()
      while (myData.next()) {
        val id = myData.getInt("SiteID")
        val site = myData.getString("SITE")
        val description = myData.getString("DESCRIPTION")
        println(s"SiteID: $id, Site: $site, Description: $description")
      }

      sourceDBConn.close()

    } catch {
      case e: Exception =>
        println(s"Error connecting to source database: ${e.getMessage}")
    }

  }
}

```


#### Short summary: 

empty definition using pc, found symbol in pc: 
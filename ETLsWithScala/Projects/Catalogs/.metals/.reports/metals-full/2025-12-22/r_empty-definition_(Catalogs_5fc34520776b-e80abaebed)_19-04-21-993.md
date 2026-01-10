error id: file://<WORKSPACE>/Catalogs.sc:isEmpty.
file://<WORKSPACE>/Catalogs.sc
empty definition using pc, found symbol in pc: isEmpty.
found definition using semanticdb; symbol scala/collection/ArrayOps#isEmpty().
empty definition using fallback
non-local guesses:

offset: 487
uri: file://<WORKSPACE>/Catalogs.sc
text:
```scala

//> using scala "3"
//> using toolkit default
//> using file Libraries // import all from Libraries directory
//> using file ../../GeneralLibraries // import all common libraries
//> using dep "com.sun.mail:jakarta.mail:2.0.2"
//> using dep "com.sun.activation:jakarta.activation:2.0.1"   
import java.sql.Connection

import java.time.LocalDateTime
import java.time.format.DateTimeFormatter


object script {

  def main(parameters: Array[String]): Unit = { 


    if (!procSequences.is@@Empty) {
      val procList = parameters.map(_.toLong).toList

      println(s"you passed me ${parameters.length} parameters")
      
      for (procList) {

        println(s"procNumber $procNumber will be processed")
      }
    }
  sys.exit(1)

    val catalogsConfig = Utils.LoadConfig("Catalogs.config")
    val etlConfig = Utils.LoadConfig("../../GeneralLibraries/GeneralETL.config")
    val processRunNumber = LocalDateTime.now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
    val logFileName = s"${catalogsConfig("logsFolder")}/$processRunNumber.txt"
    var errorsInETLProcess = false 

    //etlConfig.foreach { case (k, v) => println(s"$k -> $v") } 
    //println(s"smtp server: ${etlConfig("mailSmtpServer")}")
    
    //################################################################################
    // Opening DataBase Connections.
    //################################################################################
    Utils.WriteToTextFile("******************       Opening DataBase Connections.      *******************\n", logFileName)

    //### Opening Data Source Connection.
    val sourceDBConn: Connection = try {
      Utils.WriteToTextFile("******************    Opening Source DataBase Connection.   *******************\n", logFileName)
      DataBaseConnections.h2DBConn( catalogsConfig("sourceDBPath"), catalogsConfig("sourceDBUser"), catalogsConfig("sourceDBPassword") )      
    } catch {
      case e: Exception => {
        Utils.WriteToTextFile("**************** Error Opening Source DataBase Connection. ******************\n" + e.getMessage + "\n", logFileName)
        Utils.SendEmail(catalogsConfig("emailRecipients"), s"Source DB Conn Error, process run number: ${processRunNumber}",
          s"<p><strong>Error opening source database connection, check text file logs for details.</strong></p> ${e.getMessage}", etlConfig)
          sys.exit(1)
      }
    }
    Utils.WriteToTextFile("*****************  Opening Source DataBase Connection Done.  ******************\n", logFileName)


    //### Opening Data Target Connection.
    val targetDBConn: Connection = try {
      Utils.WriteToTextFile("******************    Opening Target DataBase Connection.   *******************\n", logFileName)
      DataBaseConnections.sqliteDBConn(catalogsConfig("targetDBPath"))      
    } catch {      
      case e: Exception => {
        Utils.WriteToTextFile("**************** Error Opening Target DataBase Connection. ******************\n" + e.getMessage + "\n", logFileName)
        Utils.SendEmail(catalogsConfig("emailRecipients"), s"Target DB Conn Error, process run number: ${processRunNumber}",
          s"<p><strong>Error opening target database connection, check text file logs for details.</strong></p> ${e.getMessage}", etlConfig)
          sys.exit(1)
      }
    }
    Utils.WriteToTextFile("*****************  Opening Target DataBase Connection Done.  ******************\n", logFileName)


    /*******************************************************************************
    # Start processing ETL process sequences
    ********************************************************************************/










    /*******************************************************************************
    #  Closing DataBase Connections
    ********************************************************************************/
    Utils.WriteToTextFile("******************       Closing DataBase Connections.       *******************\n", logFileName)
    try {
      sourceDBConn.close()
      } catch {
        case e: Exception => {
          Utils.WriteToTextFile("**************** Error Closing Source DataBase Connection. ******************\n" + e.getMessage + "\n", logFileName)
        }
      }

    try {
      targetDBConn.close()
      } catch {
        case e: Exception => {
          Utils.WriteToTextFile("**************** Error Closing Target DataBase Connection. ******************\n" + e.getMessage + "\n", logFileName)
        }
      }
    Utils.WriteToTextFile("******************       DataBase Connections Closed.       *******************\n", logFileName)
  }
}

```


#### Short summary: 

empty definition using pc, found symbol in pc: isEmpty.
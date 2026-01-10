

final class Catalogs$_ {
def args = Catalogs_sc.args$
def scriptPath = """Catalogs.sc"""
/*<script>*/

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

    val procSequences: List[Int] = if (parameters.isEmpty) {
      List(99) // default process to run all process sequences
    } else {
      parameters.map(_.toInt).toList
    }


for (procSeq <- procSequences) {
      println(s"Process Sequence to run: $procSeq")
    }
sys.exit(0)

    val catalogsConfig = Utils.LoadConfig("Catalogs.config")
    val etlConfig = Utils.LoadConfig("../../GeneralLibraries/GeneralETL.config")
    val processRunNumber = LocalDateTime.now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
    val logFileName = s"${catalogsConfig("logsFolder")}/$processRunNumber.txt"
    var errorsInETL = false 

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
    for (procSeq <- procSequences) {
      val projectCode = catalogsConfig("projectCode").toInt
      if( procSeq == 99 || procSeq == 200 ) {
          // Read Data And Store it in Target DataBase - Start.
          Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 0, 1, 0, "" )    
          try {
            Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 205, 1, 0, "" )
            //load( "../Libraries/SitesCatalog.jss" ) // Import ETL Library For Catalog.
            Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 205, 2, 0, "" )

            // Read Data And Store it in Target DataBase
            Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 206, 1, 0, "" )
            /*
            if( MainProcess( sourceDBConn, targetDBConn, processRunNumber, projectCode, 200 ) ) {
              Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 206, 2, 0, "" )
            } else {
              Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 206, 3, 3002, "" ) // Error.
              errorsInETL = true
            } */     
          } catch {
            case error: Exception => {
              // Catalog Library Cannot be Imported.
              Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 205, 3, 3002, "" )

              // Cannot Read Data And Store it in Target DataBase.
              Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 0, 3, 3003, s"ETL Library For Catalog Cannot be Imported: ${error.getMessage()}" )
              errorsInETL = true
            }
          } 
        } //if( procSeq == 99 || procSeq == 200 ) {



      println(s"Process Sequence to run: $procSeq")
    }










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

/*</script>*/ /*<generated>*//*</generated>*/
}

object Catalogs_sc {
  private var args$opt0 = Option.empty[Array[String]]
  def args$set(args: Array[String]): Unit = {
    args$opt0 = Some(args)
  }
  def args$opt: Option[Array[String]] = args$opt0
  def args$: Array[String] = args$opt.getOrElse {
    sys.error("No arguments passed to this script")
  }

  lazy val script = new Catalogs$_

  def main(args: Array[String]): Unit = {
    args$set(args)
    script.script.main(args) // hashCode to clear scalac warning about pure expression in statement position
  }
}

export Catalogs_sc.script as `Catalogs`


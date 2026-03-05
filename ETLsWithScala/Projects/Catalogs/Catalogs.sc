

//> using file Libraries 
//> using file Queries
//> using file ../../GeneralLibraries
//> using dep "com.sun.mail:jakarta.mail:2.0.2"
//> using dep "com.sun.activation:jakarta.activation:2.0.1"   

import java.sql.Connection
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter


object script {

  def main(parameters: Array[String]): Unit = { 

    // Getting process sequences to run
    val procSequences: List[Int] = if (parameters.isEmpty) {
      List(99) // default process number to run all process sequences
    } else {
      parameters.map(_.toInt).toList
    }

    val catalogsConfig =  Utils.LoadConfig("Catalogs.config")
    val etlConfig = Utils.LoadConfig("../../GeneralLibraries/GeneralETL.config")
    val processRunNumber = LocalDateTime.now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
    val logFileName = s"${catalogsConfig("logsFolder")}/$processRunNumber.txt"
    var errorsInETL = false 

    // #### For debug purposes, printing config values. ###
    // etlConfig.foreach { case (k, v) => println(s"$k -> $v") } 
    // println(s"smtp server: ${etlConfig("mailSmtpServer")}")
    println(s"Target DataBase Path:${catalogsConfig("targetDBPath")}")
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
    val projectCode = catalogsConfig("projectCode").toInt
    Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 0, 0, 1, 0, "Catalogs ETL Process Start.", logFileName )

    for (procSeq <- procSequences) {

      if( procSeq == 99 || procSeq == 200 ) {
        // Read Sites Catalogs Data And Store it in Target DataBase
        val procSequence = 200 // Process Number to be Executed

        // For short method calling, Initializing writeETLMSLog with Utils.WriteETLMSLog constant values on this proc sequence.
        val writeETLMSLog = Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, procSequence, _: Int, _: Int, _: Int, _: String, logFileName )
            // Variable values for writeETLMSLog(subProcNum, statusCode, errorCode, notes )
            // subProcNum: Process sequence inside our main procSequence(200 in this case), 0 -> subProcNum when Starting procSequence(200 in this case) 
                // subPRocNum should be a valida value in table -> ETLMS_Processes(Target DB)
            // statusCode:(1 = Starting, 2 = Done, 3 = Error)
            // errorCode: Internal error code number in SQLite(Target DB) table -> ETLMS_ErrorCodes 0 -> no error, just initializing 
            // notes: It can be the error exception from the program: "Error reading sites catalog:" + errorException  
        try {
          // 206 = Read Data And Store it in Target DataBase
          writeETLMSLog(206, 1, 0, "Starting Process to Import Sites Catalogs.") // Starting subProcNum 206, statusCode = 1(Starting),  errorCode = 0, notes = ""
          if( SitesCatalog.MainProcess( sourceDBConn, targetDBConn, processRunNumber, projectCode, 200, logFileName, writeETLMSLog( _: Int, _: Int, _: Int, _: String ) )  ) {
            writeETLMSLog(206, 2, 0, "Process to Import Sites Catalogs Done.")
          } else {
            writeETLMSLog(206, 3, 3002, "") // Errors in ETL
          }

        } catch {
          case error: Exception => {
            // Cannot Read Data And Store it in Target DataBase.
            writeETLMSLog(206, 3, 3003, s"Exception when running ETL Library For Sites Catalogs: ${error.getMessage()}")
            errorsInETL = true
          }
        } 
      } //if( procSeq == 99 || procSeq == 200 ) {

    }

    Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 0, 0, 2, 0, "Catalogs ETL Process End.", logFileName )

    if(catalogsConfig("sendEmails").toBoolean) {
      println("The process is sending emails.")
    } else {
      println("The process is NOT sending emails.")
    }

    println(s"Is the process sending emails?:${catalogsConfig("sendEmails")}")






    /*******************************************************************************
    #  Closing DataBase Connections
    ********************************************************************************/
    Utils.CloseDBConnections( sourceDBConn, targetDBConn, logFileName )

  }
}

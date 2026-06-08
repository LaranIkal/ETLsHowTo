
import java.io.{File, FileWriter}
import java.sql.Connection
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.Properties

import jakarta.mail.{Authenticator, Message, PasswordAuthentication, Session, Transport, Address}
import jakarta.mail.internet.{InternetAddress, MimeMessage}

import scala.io.Source
import scala.util.Using
import scala.util.Try

/*******************************************************************************
* Title: Method to write text to file.
* Author: Carlos Kassab - 2025-December-20
********************************************************************************/
def WriteToTextFile( textToWrite: String, fileName: String ): Unit = 

  // FileWriter checks if file exists, if not it creats it, and appends text to file
  Using(new FileWriter(fileName, true)) { 
    fileWriter => fileWriter.write(textToWrite)
  }.recover {
    case e: Exception => e.printStackTrace()
  }



/*******************************************************************************
* Method to load config files to a Map variable.
* Author: Carlos Kassab - 2025-December-20
********************************************************************************/
def LoadConfig(configFileName: String): Map[String, String] =

  Using(Source.fromFile(configFileName)) { 
    myConfig => myConfig.getLines().map(_.trim)
      .filterNot(line => line.isEmpty || line.startsWith("//") || line.startsWith("#"))
      .flatMap { 
        line => line.split("->", 2).map(_.trim) match {
          case Array(key, value) => Some(key -> value)
          case _                 => None
        }
      }.toMap
  }.recover {
    case e: Exception =>
      println(s"Error reading configuration file: ${e.getMessage}")
      Map.empty
  }.getOrElse(Map.empty)



/*******************************************************************************
* Method to send email alerts mainly to admins.
* Author: Carlos Kassab - 2025-December-20
********************************************************************************/
def SendEmail( mailRecipients: String, mailSubject: String, mailBody: String, etlConfig: Map[String, String] ): Unit = {

  Try {
    val props = new Properties()
    props.put("mail.smtp.host", etlConfig.getOrElse("mailSmtpServer", ""))
    props.put("mail.smtp.auth", "true")
    props.put("mail.smtp.port", "587")
    props.put("mail.smtp.starttls.enable", "true")

    val authenticator = new Authenticator {
      override protected def getPasswordAuthentication: PasswordAuthentication =
        new PasswordAuthentication(
          etlConfig.getOrElse("mailSmtpUser", ""), 
          etlConfig.getOrElse("mailSmtpPassword", "")
        )
    }

    val session = Session.getInstance(props, authenticator)
    val message = new MimeMessage(session)

    message.setFrom(new InternetAddress(etlConfig.getOrElse("mailSmtpUser", "")))
    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(mailRecipients).asInstanceOf[Array[Address]])
    message.setSubject(mailSubject)
    message.setText(mailBody)

    Transport.send(message) // Send the email
    //println("Email sent successfully.")

  }.recover {
    case e: Exception => e.printStackTrace()
  }
}



/*******************************************************************************
* Method to write a log record in ETLMS(ETL Monitoring System) processes log table.
* Author: Carlos Kassab - 2025-December-22
********************************************************************************/
def WriteETLMSLog( dbConn: Connection, runNumber:String, projectID: Int, procNumber: Int, subProcNum: Int,
                   statusCode: Int, errorCode: Int, notes: String, logFileName: String ): Unit = {

  val eventDateTime = LocalDateTime.now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
  val insertQuery =
    """
      |INSERT INTO ETLMS_ProcessesLog (RunNumber, ProjectID, ProcessNumber, SubProcessNumber, StatusCode, Date, ErrorCode, Notes)
      |VALUES (?, ?, ?, ?, ?, ?, ?, ?);
    """.stripMargin

  Using(dbConn.prepareStatement(insertQuery)) { statement =>
    statement.setString(1, runNumber)
    statement.setInt   (2, projectID)
    statement.setInt   (3, procNumber)
    statement.setInt   (4, subProcNum)
    statement.setInt   (5, statusCode)
    statement.setString(6, eventDateTime)
    statement.setInt   (7, errorCode)
    statement.setString(8, notes)
    statement.executeUpdate()
  }.recover {
    case e: Exception =>
      writeToTextFile("*** Error Writing ETLMS_ProcessesLog, function 'writeETLMSLog':\n" + e.getMessage + "\n", logFileName)
      writeToTextFile(s"Insert Query:\n${insertQuery}\n", logFileName)
  }

} 



/*******************************************************************************
#  Closing DataBase Connections
********************************************************************************/
def CloseDBConnections( sourceConn: Connection, targetConn:Connection,  logFileName: String ): Unit = {
  WriteToTextFile("******************       Closing DataBase Connections.       *******************\n", logFileName)

  Try(if( sourceConn != null && !sourceConn.isClosed ) sourceConn.close())
    .recover {
      case e: Exception =>
        WriteToTextFile("**************** Error Closing Source DataBase Connection. ******************\n" + e.getMessage + "\n", logFileName)
    }

  Try(if( targetConn != null && !targetConn.isClosed ) targetConn.close())
    .recover {
      case e: Exception =>
        WriteToTextFile("**************** Error Closing Target DataBase Connection. ******************\n" + e.getMessage + "\n", logFileName)
    }
}












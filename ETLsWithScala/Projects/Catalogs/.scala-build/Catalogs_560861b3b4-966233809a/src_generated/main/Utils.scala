

final class Utils$_ {
def args = Utils_sc.args$
def scriptPath = """Utils.sc"""
/*<script>*/

import java.io.{File, FileWriter}
import java.sql.Connection
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

/*******************************************************************************
* Title: Method to write text to file.
* Author: Carlos Kassab - 2025-December-20
********************************************************************************/
def WriteToTextFile( textToWrite: String, fileName: String ): Unit = {

  try {

    // Set File Name
    val file = new File( fileName )

    if ( file.exists() ) {
      //File exists. Appending content...
      
      val fileWriter = new FileWriter( file, true )
      fileWriter.write( textToWrite )
      fileWriter.close()

    } else {
      //File does not exist. Creating new file...
      val fileWriter = new FileWriter( file )
      fileWriter.write( textToWrite )
      fileWriter.close()
    }

  } catch {
    case e: Exception => e.printStackTrace()
  } 
}



/*******************************************************************************
* Method to load config files to a Map variable.
* Author: Carlos Kassab - 2025-December-20
********************************************************************************/
def LoadConfig( configFileName: String ): Map[String, String] = {
  import scala.io.Source
  import scala.collection.mutable.Map

  val configMap: Map[String, String] = Map()

  val configFile = new java.io.File(configFileName)
  if (!configFile.exists()) {
    println(s"Configuration file not found: ${configFile.getAbsolutePath}")
    sys.exit(1)
  }

  try {
    val myConfig = Source.fromFile(configFileName) // open the file

    for ( line <- myConfig.getLines() ) {
      if(line.trim.nonEmpty && !line.trim.startsWith("//") && !line.trim.startsWith("#")) {
        val parts = line.split("->", -1).map(_.trim)
        configMap += ( parts(0) -> parts(1) )
      }
    }
    myConfig.close() // close the file

  } catch {
    case e: Exception => { println(s"Error reading configuration file: ${e.getMessage}") }
  }

  return configMap.toMap
}



/*******************************************************************************
* Method to send email alerts mainly to admins.
* Author: Carlos Kassab - 2025-December-20
********************************************************************************/
def SendEmail( mailRecipients: String, mailSubject: String, mailBody: String, etlConfig: Map[String, String] ): Unit = {

  import java.util.Properties
  import jakarta.mail._ //{Authenticator, Message, PasswordAuthentication, Session, Transport}
  import jakarta.mail.internet.{InternetAddress, MimeMessage}

  try {
    val props = new Properties()
    props.put("mail.smtp.host", etlConfig("mailSmtpServer"))
    props.put("mail.smtp.auth", "true")
    props.put("mail.smtp.port", "587")
    props.put("mail.smtp.starttls.enable", "true")

    val authenticator = new Authenticator {
      override protected def getPasswordAuthentication: PasswordAuthentication =
        new PasswordAuthentication(etlConfig("mailSmtpUser"), etlConfig("mailSmtpPassword"))
    }

    val session = Session.getInstance(props, authenticator)

    val message = new MimeMessage(session)
    message.setFrom(new InternetAddress(etlConfig("mailSmtpUser")))
    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(mailRecipients).asInstanceOf[Array[Address]])
    message.setSubject(mailSubject)
    message.setText(mailBody)

    Transport.send(message) // Send the email
    //println("Email sent successfully.")

  } catch {
    case e: Exception => e.printStackTrace()
  }
}



/*******************************************************************************
* Method to write a log record in ETLMS(ETL Monitoring System) processes log table.
* Author: Carlos Kassab - 2025-December-22
********************************************************************************/
def WriteETLMSLog( dbConn: Connection, runNumber:String, projectID: Int, procNumber: Int, subProcNum: Int,
                   statusCode: Int, errorCode: Int, notes: String, logFileName: String ): Unit = {

  val statement = dbConn.createStatement()
  val eventDateTime = LocalDateTime.now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
  val insertQuery =
    s"""
      |INSERT INTO ETLMS_ProcessesLog (RunNumber, ProjectID, ProcessNumber, SubProcessNumber, StatusCode, Date, ErrorCode, Notes)
      |VALUES (${runNumber}, ${projectID}, ${procNumber}, ${subProcNum}, ${statusCode}, ${eventDateTime}, ${errorCode}, ${notes});
    """.stripMargin // Using pipeline operator to remove leading spaces

  try {
    statement.executeUpdate(insertQuery)
    statement.close()
  } catch {
    case e: Exception => { 
      WriteToTextFile("*** Error Writing ETLMS_ProcessesLog, function 'WriteETLMSLog':\n" + e.getMessage + "\n", logFileName)
      WriteToTextFile(s"Insert Query:\n${insertQuery}\n", logFileName)
    }
  }
} 



/*******************************************************************************
#  Closing DataBase Connections
********************************************************************************/
def CloseDBConnections( sourceConn: Connection, targetConn:Connection,  logFileName: String ): Unit = {
  WriteToTextFile("******************       Closing DataBase Connections.       *******************\n", logFileName)
  try {
    if ( sourceConn != null && !sourceConn.isClosed() ) {
      sourceConn.close()
    }
  } catch {
    case e: Exception => {
      Utils.WriteToTextFile("**************** Error Closing Source DataBase Connection. ******************\n" + e.getMessage + "\n", logFileName)
    }
  }

  try {
    if ( targetConn != null && !targetConn.isClosed() ) {
      targetConn.close()
    }
  } catch {
    case e: Exception => {
      Utils.WriteToTextFile("**************** Error Closing Target DataBase Connection. ******************\n" + e.getMessage + "\n", logFileName)
    }
  }
}



/*</script>*/ /*<generated>*//*</generated>*/
}

object Utils_sc {
  private var args$opt0 = Option.empty[Array[String]]
  def args$set(args: Array[String]): Unit = {
    args$opt0 = Some(args)
  }
  def args$opt: Option[Array[String]] = args$opt0
  def args$: Array[String] = args$opt.getOrElse {
    sys.error("No arguments passed to this script")
  }

  lazy val script = new Utils$_

  def main(args: Array[String]): Unit = {
    args$set(args)
    val _ = script.hashCode() // hashCode to clear scalac warning about pure expression in statement position
  }
}

export Utils_sc.script as `Utils`


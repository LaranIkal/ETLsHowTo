error id: file://<WORKSPACE>/Utils.sc:close.
file://<WORKSPACE>/Utils.sc
empty definition using pc, found symbol in pc: close.
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -dbConn/close.
	 -dbConn/close#
	 -dbConn/close().
	 -scala/Predef.dbConn.close.
	 -scala/Predef.dbConn.close#
	 -scala/Predef.dbConn.close().
offset: 5211
uri: file://<WORKSPACE>/Utils.sc
text:
```scala

import java.io.{File, FileWriter}
import java.sql.Connection


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
def WriteETLMSLog( dbConn: Connection, runNumber:String, projectID: Int, procNumber: Int, subProcNum: Int, statusCode: Int, errorCode: Int, notes: String   ): Unit = {

  import java.sql.{Connection, DriverManager, PreparedStatement}

  var connection: Connection = null
  var preparedStatement: PreparedStatement = null

/*
  try {
    // Establish database connection
    connection = DriverManager.getConnection(
      etlConfig("etlmsDbUrl"),
      etlConfig("etlmsDbUser"),
      etlConfig("etlmsDbPassword")
    )

    // Prepare SQL insert statement
    val insertSQL =
      """
INSERT INTO etl_process_logs (process_name, log_message, log_level, log_timestamp)
VALUES (?, ?, ?, CURRENT_TIMESTAMP)
      """.stripMargin

    preparedStatement = connection.prepareStatement(insertSQL)
    preparedStatement.setString(1, etlProcessName)
    preparedStatement.setString(2, logMessage)
    preparedStatement.setString(3, logLevel)

    // Execute insert
    preparedStatement.executeUpdate()

  } catch {
    case e: Exception => e.printStackTrace()
  } finally {
    // Close resources
    if (preparedStatement != null) preparedStatement.close()
    if (connection != null) connection.close()
  }
  */
} 



def CloseDBConnections( sourceConn: Connection, targetConn:Connection ): Unit = {
  try {
    if ( dbConn != null && !dbConn.isClosed() ) {
      dbConn.cl@@ose()
    }
  } catch {
    case e: Exception => e.printStackTrace()
  }
}



```


#### Short summary: 

empty definition using pc, found symbol in pc: close.
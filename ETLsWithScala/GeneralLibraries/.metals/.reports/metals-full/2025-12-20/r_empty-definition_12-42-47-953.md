error id: file://<WORKSPACE>/Utils.sc:properties.
file://<WORKSPACE>/Utils.sc
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -jakarta/mail/properties.
	 -properties.
	 -scala/Predef.properties.
offset: 2668
uri: file://<WORKSPACE>/Utils.sc
text:
```scala

import java.io.{File, FileWriter}



/*******************************************************************************
* Title: Function to write text to file.
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
* Function to send email alerts mainly to admins.
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
* Function to send email alerts mainly to admins.
* Author: Carlos Kassab - 2025-December-20
********************************************************************************/
def SendEmailAlert( mailRecipients: String, mailSubject: String, mailBody: String): Unit = {
  import java.util.Properties
  import jakarta.mail.*
  
/*
  import jakarta.mail.Session
  import jakarta.mail.internet.MimeMessage
  import jakarta.mail.internet.InternetAddress
  import jakarta.mail.PasswordAuthentication
  import jakarta.mail.Message
  import jakarta.mail.Transport
*/


  try {
    val props = new Properties()
    proper@@ties.put("mail.smtp.host", smtpServer)
    val session = Session.getDefaultInstance(properties, null)

    val message = new MimeMessage(session)
    message.setFrom(new InternetAddress(fromAddress))
    message.addRecipient(Message.RecipientType.TO, new InternetAddress(toAddress))
    message.setSubject(subject)
    message.setText(body)

    Transport.send(message)
    println("Email sent successfully.")

  } catch {
    case e: Exception => e.printStackTrace()
  }
}

```


#### Short summary: 

empty definition using pc, found symbol in pc: 
error id: file://<WORKSPACE>/Utils.sc:PasswordAuthentication.
file://<WORKSPACE>/Utils.sc
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -jakarta/mail/PasswordAuthentication.
	 -jakarta/mail/PasswordAuthentication#
	 -jakarta/mail/PasswordAuthentication().
	 -PasswordAuthentication.
	 -PasswordAuthentication#
	 -PasswordAuthentication().
	 -scala/Predef.PasswordAuthentication.
	 -scala/Predef.PasswordAuthentication#
	 -scala/Predef.PasswordAuthentication().
offset: 2602
uri: file://<WORKSPACE>/Utils.sc
text:
```scala

import java.io.{File, FileWriter}
//> using lib "com.sun.mail:jakarta.mail:2.0.2"
//> using lib "com.sun.activation:jakarta.activation:2.0.1"   

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
def SendEmail( mailRecipients: String, mailSubject: String, mailBody: String,
                    mailSmtpServer: String, mailSmtpUser: String, mailSmtpPassword: String): Unit = {
  import java.util.Properties
  import jakarta.mail.{Authenticator, Message, Passw@@ordAuthentication, Session, Transport}
  import jakarta.mail.internet.{InternetAddress, MimeMessage}

  try {
    val props = new Properties()
    props.put("mail.smtp.host", mailSmtpServer)
    props.put("mail.smtp.auth", "true")
    props.put("mail.smtp.port", "587")
    props.put("mail.smtp.starttls.enable", "true")

    val authenticator = new Authenticator {
      override protected def getPasswordAuthentication: PasswordAuthentication =
        new PasswordAuthentication(mailSmtpUser, mailSmtpPassword)
    }

    val session = Session.getInstance(props, authenticator)

    val message = new MimeMessage(session)
    message.setFrom(new InternetAddress(mailSmtpUser))
    message.addRecipient(Message.RecipientType.TO, InternetAddress.parse(mailRecipients))
    message.setSubject(mailSubject)
    message.setText(mailBody)

    Transport.send(message) // Send the email
    //println("Email sent successfully.")

  } catch {
    case e: Exception => e.printStackTrace()
  }
}

```


#### Short summary: 

empty definition using pc, found symbol in pc: 
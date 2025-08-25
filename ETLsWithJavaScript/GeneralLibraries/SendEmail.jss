/*******************************************************************************
* SendEmail.jss
* Function to send email alerts mainly to admins.
* Carlos Kassab
* 2025-August-20
********************************************************************************/

var SendEmail = function(mailRecipients, mailSubject, mailBody) {

  var Properties = Java.type('java.util.Properties');
  var Session = Java.type('jakarta.mail.Session');
  var MimeMessage = Java.type('jakarta.mail.internet.MimeMessage');
  var InternetAddress = Java.type('jakarta.mail.internet.InternetAddress');
  var PasswordAuthentication = Java.type('jakarta.mail.PasswordAuthentication');
  var Message = Java.type('jakarta.mail.Message');
  var Transport = Java.type('jakarta.mail.Transport');

  // SMTP properties
  var props = new Properties();
  props.put("mail.smtp.host", mailSmtpServer);
  props.put("mail.smtp.auth", "true");
  props.put("mail.smtp.port", "587");
  props.put("mail.smtp.starttls.enable", "true");

  // Authenticator (must use Java.extend in GraalVM)
  var Authenticator = Java.extend(Java.type('jakarta.mail.Authenticator'), {
    getPasswordAuthentication: function() {
      return new PasswordAuthentication(mailSmtpUser, mailSmtpPassword);
    }
  });

  var session = Session.getInstance(props, new Authenticator());

  // Create the email
  var message = new MimeMessage(session);
  message.setFrom(new InternetAddress(mailSmtpUser));
  message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(mailRecipients));
  message.setSubject(mailSubject);
  message.setText(mailBody);

  // Send the email
  try {
    Transport.send(message);
  } catch (error) {
    print("Error Sending Email, function 'SendEmail':" + error)
  }
}
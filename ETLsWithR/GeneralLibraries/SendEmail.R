#*******************************************************************************
#* SendEmail.R
#* Function to send email alerts mainly to admins.
#* Carlos Kassab
#* 2019-January-28
#*******************************************************************************

library( "mailR" )

# Send email using smtp.office365.com, this is using tls = TRUE
#SendEmail = function( mailRecipients, mailSubject, mailBody ) {
#  
#	mailBody = paste( mailBody, "<p><i>This is an automated message, do not reply.</i></p>"
#										, '<p><font color="blue"><b>Processes Monitoring Service.<br>'
#										, 'IMI Analytics Area.</b></font></p>' )
#										
#  send.mail( from = imiSmtpUser
#             , to = mailRecipients
#             , subject = mailSubject
#             , body = mailBody
#             , html = TRUE
#             , smtp = list( host.name = mailSmtpServer, port = 587
#                            , user.name = mailSmtpUser
#                            , passwd = mailSmtpPassword, tls = TRUE )
#             , authenticate = TRUE
#             , send = TRUE
#            )
#}



# Send email using google smtp, but using config variables from config file.
SendEmail = function( mailRecipients, mailSubject, mailBody ) {
  
	mailBody = paste( mailBody, "<p><i>This is an automated message, do not reply.</i></p>"
										, '<p><font color="blue"><b>Processes Monitoring Service.<br>'
										, 'IMI Analytics Area.</b></font></p>' )
										
  send.mail( from = mailSmtpUser
             , to = mailRecipients
             , subject = mailSubject
             , body = mailBody
             , html = TRUE
             , smtp = list( host.name = mailSmtpServer, port = 465
                            , user.name = mailSmtpUser
                            , passwd = mailSmtpPassword, ssl = TRUE )
             , authenticate = TRUE
             , send = TRUE
            )
}


					
					
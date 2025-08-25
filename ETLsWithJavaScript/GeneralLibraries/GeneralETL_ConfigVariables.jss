/*******************************************************************************
* GeneralETL_ConfigVariables.jss
*
* Variable values using in almost all ETL programs 
*
* How to call it:
* When ETL general libs is imported, the variables will be initialized.
* load('../../../GeneralLibraries/GeneralETL_ConfigVariables.jss')
*
* Carlos Kassab
* 2025-August-20
********************************************************************************/

//smtpServer = "smtp.office365.com"
//smtpUser = "carlos.kassab@company.com"
//smtpPassword = "*******"

const mailSmtpServer = "smtp.gmail.com"
Object.freeze(mailSmtpServer)

const mailSmtpUser = "mymail@gmail.com"
Object.freeze(mailSmtpUser)

const mailSmtpPassword = "ThePassw0rd"
Object.freeze(mailSmtpPassword)


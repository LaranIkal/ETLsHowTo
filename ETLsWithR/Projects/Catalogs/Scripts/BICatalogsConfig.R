#*******************************************************************************
#* BI_CatalogsConfig.R
#* Initial Parameters for program BICatalogs.R
#* Carlos Kassab
#* 2019-Jan-24
#*******************************************************************************

logsFolder = "../Log/" # Path to log files

sourceDBPath = "/home/ckassab/Development/ETLs/ETLsHowTo/ETLsWithR/Data/SourceDB/SourceDB.h2" # Full path to H2 database.
sourceDBjarPath = "/home/ckassab/Apps/dbjarlib/h2-2.3.232.jar"
sourceDBUser = "sa"
sourceDBPassword = ""

targetDBPath = "/home/ckassab/Development/ETLs/ETLsHowTo/ETLsWithR/Data/TargetDB/TargetDB.sqlite" # Full path to SQLite database.

emailRecipients = c( "carlos.kassab@company.com" ) # Admins' email addresses, separated by comma.

numDaysToKeepLogFiles = 8

# Project and processes values.
projectCode = 2 # General data


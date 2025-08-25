/*******************************************************************************
* BICatalogsConfig.jss
* Initial Parameters for program BICatalogs.jss
* Carlos Kassab
* 2025-August-20
********************************************************************************/

var config = {
  logsFolder:'../Log/', // Path to log files

  sourceDBPath:'/home/ckassab/Development/ETLs/ETLsHowTo/ETLsWithJavaScript/Data/SourceDB/SourceDB.h2', // Full path to H2 database.
  sourceDBUser:'sa',
  sourceDBPassword:'',

  targetDBPath:'/home/ckassab/Development/ETLs/ETLsHowTo/ETLsWithJavaScript/Data/TargetDB/TargetDB.sqlite', // Full path to SQLite database.
  SQLITEDB:'data/sample.sqlite1',
  
  emailRecipients:'carlos.kassab@company.com', // Admins' email addresses, separated by comma.

  numDaysToKeepLogFiles:8,

  // Project and processes values.
  projectCode:2 // General data
}
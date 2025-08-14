#*******************************************************************************
#* DataBaseConnections.R
#* Functions to initialize database connections.
#* Carlos Kassab
#* 2019-January-25
#* 
#* Packages install:
#* install.packages("duckdb", dependencies = TRUE) ==>> Important for data analytics
#* install.packages("RH2", dependencies=TRUE)
#* install.packages("RSQLite", dependencies = TRUE)
#* install.packages("RPostgreSQL", dependencies = TRUE) ==> run this before installing the R package:sudo apt install libpq-dev
#* install.packages("ROracle", dependencies = TRUE) ==>> If using Oracle, install Oracle instant client before the R package.
#*******************************************************************************


# oracleTraceProdConn = function() {
# 	library( "ROracle" ) # Load Oracle library
# 
# 	# Important to set this value to avoid problems with PostgreSQL below.
# 	oraDrv = dbDriver( "Oracle" ) 
# 
# 	# Using tnsnames.ora dbname= configname in file tnsnames.ora
# 	oraConn <- dbConnect( oraDrv, username = "REPORTS_USER", password = "RPT_2019"
# 											 , dbname = "TRACDB.WORLD" )
# 											 
# 	return( oraConn )
# }


postgreSQLDBConn = function() {
	library( "RPostgreSQL" ) # Load PostgreSQL library

	# Keep the standard to assign driver to a variable
	psDrv = dbDriver( "PostgreSQL" )

	# Connect to PostgreSQL
	psConn <- dbConnect( psDrv, user = 'ETL_dwh', password = 'DWH$#1012'
											, dbname = 'DWH', host = '192.168.15.14' )

	return( psConn)
}


sqliteDBConn = function(sqliteDBPath) {
  library( "RSQLite" ) # Load SQLite library
  
  # Keep the standard to assign driver to a variable
  sqliteDrv = dbDriver( "SQLite" )
  
  # Connect to SQLite
  sqliteConn <- dbConnect(sqliteDrv, sqliteDBPath)

  return( sqliteConn )
}


h2DBConn = function(h2DBPath, h2DBjarPath, h2DBuser, h2DBpassword) {
  library( "RH2" ) # Load H2 library

  h2Drv <- H2('org.h2.Driver', h2DBjarPath)
  
  # Connect to H2
  h2Con <- dbConnect(h2Drv, paste("jdbc:h2:", h2DBPath, ";AUTO_SERVER=TRUE", sep = ""), h2DBuser, h2DBpassword)
  
  return( h2Con )
}






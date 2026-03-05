/*******************************************************************************
* DataBaseConnections.jss
* Functions to initialize database connections.
* Carlos Kassab
* 2025-August-20
* 
* JDBC libraries needed:
* SQLite: https://github.com/xerial/sqlite-jdbc/releases/download/3.50.3.0/sqlite-jdbc-3.50.3.0.jar
* H2: https://h2database.com/html/main.html, download and extract the all platforms zip, copy file h2/bin/h2-2.3.232.jar
* Optional: https://db.apache.org/derby/derby_downloads.html, https://jdbc.postgresql.org/download/
********************************************************************************/


const postgreSQLDBConn = function() {
  var Properties = Java.type("java.util.Properties")
  var properties = new Properties()
  var conn = null;

  var Driver = Java.type("org.postgresql.Driver")
  var driver = new Driver()
  var cServer = System.getenv("PSQLDBSERVER").toString()
  var cPortNumber = System.getenv("PSQLDBPORT").toString()
  var cDbName = System.getenv("PSQLDBNAME").toString()        
  var cUserName = System.getenv("PSQLDBUSER").toString()
  var cPassw = System.getenv("PSQLDBPASS").toString()

  try {
    properties.setProperty("user", cUserName)
    properties.setProperty("password", cPassw)
    conn = driver.connect("jdbc:postgresql://" + cServer + ":" + cPortNumber + "/" + cDbName, properties)
  } catch (error) {
    print("Error connecting db:" + error);
  } finally {

  }
	return conn;
}



const sqliteDBConn = function(sqliteDBPath) {
  var Properties = Java.type("java.util.Properties")
  var properties = new Properties()
  var conn = null;
  // Get connection information from system environment.
  var System = Java.type("java.lang.System")

  // Create SQLite Connection and return it
  var Driver = Java.type("org.sqlite.JDBC")
  var driver = new Driver()
  try {
    conn = driver.connect("jdbc:sqlite:" + sqliteDBPath, properties)
  } catch (error) {
    print("Error connecting db:" + error);
  } finally {

  } 
  return conn;
}



const h2DBConn = function(h2DBPath, h2DBuser, h2DBpassword) {
  var Properties = Java.type("java.util.Properties")
  var properties = new Properties()
  properties.setProperty("user", h2DBuser);
  properties.setProperty("password", h2DBpassword);  
  var conn = null;
  // Create H2 db Connection and return it
  var Driver = Java.type("org.h2.Driver")
  var driver = new Driver()
  try {
    conn = driver.connect("jdbc:h2:" + h2DBPath + ";AUTO_SERVER=TRUE", properties)
  } catch (error) {
    print("Error connecting db:" + error);    
  } finally {

  } 
  return conn;  
}



const ApacheDerbyConn = function(cServer, cPortNumber, cDbName) {
  var Properties = Java.type("java.util.Properties")
  var properties = new Properties()
  var conn = null;

  var Driver = Java.type("org.apache.derby.jdbc.ClientDriver")
  var driver = new Driver()
  // Optional
  //var cUserName = System.getenv("DERBYDBUSER").toString()
  //var cPassw = System.getenv("DERBYDBPASS").toString()

  try {
    conn = driver.connect("jdbc:derby://" + cServer + ":" + cPortNumber + "/" + cDbName + ";create=false", properties)
  } catch (error) {
    print("Error connecting db:" + error);
  } finally {

  } 
  return conn;
}
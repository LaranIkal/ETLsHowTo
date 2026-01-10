

//> using dep org.xerial:sqlite-jdbc:3.51.1.0
//> using dep com.h2database:h2:2.4.240


import java.io.File

import java.sql.Connection
import java.util.Properties


def sqliteDBConn(sqliteDBPath: String): Connection = {
  import org.sqlite.JDBC  // Besides the "using" directive, we need to indicate this import here
                          // for the SQLite JDBC driver

  val connectionProperties = new Properties()
  val driver = new JDBC()
  var conn: Connection = null

  try {
    if( new File( sqliteDBPath.toString ).exists() == false ) then
      throw new Exception(s"SQLite database file does not exist at path: $sqliteDBPath")

    conn = driver.connect(s"jdbc:sqlite:$sqliteDBPath", connectionProperties)

  } catch {      
    case e: Exception => println(s"Error establishing SQLite DB connection: ${e.getMessage}")
  }

  return conn
}



def h2DBConn(h2DBPath: String, h2DBuser: String, h2DBpassword: String): Connection = {
  import org.h2.Driver  // Besides the "using" directive, we need to indicate this import here
                        // for the H2 JDBC driver

  val connectionProperties = new Properties()
  val driver = new Driver()
  var conn: Connection = null

  connectionProperties.setProperty("user", h2DBuser)
  connectionProperties.setProperty("password", h2DBpassword)

  try {
    if( new File( h2DBPath.toString + ".mv.db").exists() == false ) then
      throw new Exception(s"H2 database file does not exist at path: $h2DBPath")

    conn = driver.connect(s"jdbc:h2:file:$h2DBPath", connectionProperties)

  } catch {      
    case e: Exception => println(s"Error establishing H2 DB connection: ${e.getMessage}")
  }

  return conn
}





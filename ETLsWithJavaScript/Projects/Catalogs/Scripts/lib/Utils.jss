
// Connect to database
var getConnection = function(dbType) {

  var Properties = Java.type("java.util.Properties")
  var properties = new Properties()
  var conn = null;
  // Get connection information from system environment.
  var System = Java.type("java.lang.System")
  
  // It is assumed you are configuring your database connection 
  // in the environment.
  // Only SQLITE is using the separate config file.
  switch (dbType) {
    case 'Oracle':
      var Driver = Java.type("oracle.jdbc.OracleDriver")
      var driver = new Driver()
      var cServer = System.getenv("ORADBSERVER").toString()
      var cPortNumber = System.getenv("ORADBPORT").toString()
      var cDbName = System.getenv("ORADBNAME").toString()        
      var cUserName = System.getenv("ORADBUSER").toString()
      var cPassw = System.getenv("ORADBPASS").toString()
      
      try {
          properties.setProperty("user", cUserName)
          properties.setProperty("password", cPassw)
          conn = driver.connect("jdbc:oracle:thin:@" + cServer + ":" + cPortNumber + "/" + cDbName, properties)
          return conn;
      } finally {

      }
      break
    case 'PostgreSQL':
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
          return conn;
      } finally {

      }
      break;      
    case 'ApacheDerby':
      var Driver = Java.type("org.apache.derby.jdbc.ClientDriver")
      var driver = new Driver()
      var cServer = System.getenv("DERBYDBSERVER").toString()
      var cPortNumber = System.getenv("DERBYDBPORT").toString()
      var cDbName = System.getenv("DERBYDBNAME").toString()        
      //var cUserName = System.getenv("DERBYDBUSER").toString()
      //var cPassw = System.getenv("DERBYDBPASS").toString()
      
      try {
          conn = driver.connect("jdbc:derby://" + cServer + ":" + cPortNumber + "/" + cDbName + ";create=false", properties)
          return conn;
      } finally {

      }   
      break
      case 'sqlite':
        // Create SQLite Connection and return it
        var Driver = Java.type("org.sqlite.JDBC")
        var driver = new Driver()
        try {
            conn = driver.connect("jdbc:sqlite:" + config.SQLITEDB, properties)
            return conn;
        } finally {
  
        }   
        break      
    default:
      return("Invalid DB Type.")
  }

}



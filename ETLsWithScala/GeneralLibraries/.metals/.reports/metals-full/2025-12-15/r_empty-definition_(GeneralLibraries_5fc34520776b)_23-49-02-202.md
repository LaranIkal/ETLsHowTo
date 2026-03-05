error id: file://<WORKSPACE>/DataBaseConnections.sc:
file://<WORKSPACE>/DataBaseConnections.sc
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -org/sqlite/JDBC.
	 -org/sqlite/JDBC#
	 -org/sqlite/JDBC().
	 -JDBC.
	 -JDBC#
	 -JDBC().
	 -scala/Predef.JDBC.
	 -scala/Predef.JDBC#
	 -scala/Predef.JDBC().
offset: 111
uri: file://<WORKSPACE>/DataBaseConnections.sc
text:
```scala
import java.sql.Connection




def sqliteDBConn(sqliteDBPath: String): Connection = {
  
  import org.sqlite.JD@@BC

  val connectionProperties = new java.util.Properties()
  val driver = new org.sqlite.JDBC()
  var conn: Connection = null

  try {
    conn = driver.connect(s"jdbc:sqlite:$sqliteDBPath", connectionProperties)
  } catch {
    case e: Exception => e.printStackTrace()
  }

  return conn
}

```


#### Short summary: 

empty definition using pc, found symbol in pc: 
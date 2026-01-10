

final class DataBaseConnections$_ {
def args = DataBaseConnections_sc.args$
def scriptPath = """DataBaseConnections.sc"""
/*<script>*/


//> using dep org.xerial:sqlite-jdbc:3.51.1.0
//> using file WriteToFile.sc

import java.io.File

import java.sql.Connection
import java.util.Properties




def sqliteDBConn(sqliteDBPath: Any): Any = { // Should set variable type as any to avoid map value conversion to string
  import org.sqlite.JDBC  // Besides the using directive, we need to indicate this import here
                          // for the SQLite JDBC driver

  val connectionProperties = new Properties()
  val driver = new JDBC()

  val conn = try {
      if ( sqliteDBPath == null ) {
        throw new Exception("SQLite database path is null.")
      }

      if( new File( sqliteDBPath.toString ).exists() == false ) {
        throw new Exception(s"SQLite database file does not exist at path: $sqliteDBPath")
      }

      driver.connect(s"jdbc:sqlite:$sqliteDBPath", connectionProperties)

    } catch {
      case e: Exception => e.printStackTrace()
    }

  return conn
}

/*</script>*/ /*<generated>*//*</generated>*/
}

object DataBaseConnections_sc {
  private var args$opt0 = Option.empty[Array[String]]
  def args$set(args: Array[String]): Unit = {
    args$opt0 = Some(args)
  }
  def args$opt: Option[Array[String]] = args$opt0
  def args$: Array[String] = args$opt.getOrElse {
    sys.error("No arguments passed to this script")
  }

  lazy val script = new DataBaseConnections$_

  def main(args: Array[String]): Unit = {
    args$set(args)
    val _ = script.hashCode() // hashCode to clear scalac warning about pure expression in statement position
  }
}

export DataBaseConnections_sc.script as `DataBaseConnections`


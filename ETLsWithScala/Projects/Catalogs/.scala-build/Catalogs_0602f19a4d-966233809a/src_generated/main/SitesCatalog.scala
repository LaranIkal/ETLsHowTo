

final class SitesCatalog$_ {
def args = SitesCatalog_sc.args$
def scriptPath = """SitesCatalog.sc"""
/*<script>*/

import java.io.{File, FileWriter}

def WriteToTextFile( textToWrite: String, fileName: String ): Unit = {

  try {

    // Set File Name
    val file = new File( fileName )

    if ( file.exists() ) {
      //File exists. Appending content...
      
      val fileWriter = new FileWriter( file, true )
      fileWriter.write( textToWrite )
      fileWriter.close()

    } else {
      //File does not exist. Creating new file...
      val fileWriter = new FileWriter( file )
      fileWriter.write( textToWrite )
      fileWriter.close()
    }

  } catch {
    case e: Exception => e.printStackTrace()
  } 
}

/*</script>*/ /*<generated>*//*</generated>*/
}

object SitesCatalog_sc {
  private var args$opt0 = Option.empty[Array[String]]
  def args$set(args: Array[String]): Unit = {
    args$opt0 = Some(args)
  }
  def args$opt: Option[Array[String]] = args$opt0
  def args$: Array[String] = args$opt.getOrElse {
    sys.error("No arguments passed to this script")
  }

  lazy val script = new SitesCatalog$_

  def main(args: Array[String]): Unit = {
    args$set(args)
    val _ = script.hashCode() // hashCode to clear scalac warning about pure expression in statement position
  }
}

export SitesCatalog_sc.script as `SitesCatalog`


error id: file://<WORKSPACE>/Utils.sc:
file://<WORKSPACE>/Utils.sc
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -line/split.
	 -line/split#
	 -line/split().
	 -scala/Predef.line.split.
	 -scala/Predef.line.split#
	 -scala/Predef.line.split().
offset: 938
uri: file://<WORKSPACE>/Utils.sc
text:
```scala

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


def LoadConfig( configFilePath: String ): Map[String, String] = {
  import scala.io.Source
  import scala.collection.mutable.Map

  val configMap = Map[String, String]()

  try {
    val source = Source
      .fromFile( configFilePath )
      .getLines()
    for ( line <- source.getLines() ) {
      val keyValue = line.split@@( "->", 2 )
      if ( keyValue.length == 2 ) {
        configMap( keyValue( 0 ).trim ) = keyValue( 1 ).trim
      }
    }
    source.close()
  } catch {
    case e: Exception => e.printStackTrace()
  }

  configMap.toMap
}


```


#### Short summary: 

empty definition using pc, found symbol in pc: 
error id: 763C2C82743FD1652A88561680671224
file://<WORKSPACE>/.scala-build/Catalogs_c34520776b-e80abaebed/src_generated/main/Catalogs.sc.scala
### java.lang.AssertionError: assertion failed: position error, parent span does not contain child span
parent      = new SitesCatalog(
  if
    (MainProcess(sourceDBConn, targetDBConn, processRunNumber, projectCode, 200)
      )

    {
      Utils.WriteETLMSLog(targetDBConn, processRunNumber, projectCode, 200,
        206, 2, 0, "")
    }
   else
    {
      Utils.WriteETLMSLog(targetDBConn, processRunNumber, projectCode, 200,
        206, 3, 3002, "")
      (errorsInETL = true)
    } */ _root_.scala.Predef.???
) # -1,
parent span = <4509..4910>,
child       = if (MainProcess(sourceDBConn, targetDBConn, processRunNumber, projectCode, 200))

  {
    Utils.WriteETLMSLog(targetDBConn, processRunNumber, projectCode, 200, 206,
      2, 0, "")
  }
 else
  {
    Utils.WriteETLMSLog(targetDBConn, processRunNumber, projectCode, 200, 206,
      3, 3002, "")
    (errorsInETL = true)
  } */ _root_.scala.Predef.??? # -1,
child span  = [4539..4926]

occurred in the presentation compiler.



action parameters:
offset: 4554
uri: file://<WORKSPACE>/.scala-build/Catalogs_c34520776b-e80abaebed/src_generated/main/Catalogs.sc.scala
text:
```scala


final class Catalogs$_ {
def args = Catalogs_sc.args$
def scriptPath = """Catalogs.sc"""
/*<script>*/


//> using file Libraries // import all from Libraries directory
//> using file ../../GeneralLibraries // import all common libraries
//> using dep "com.sun.mail:jakarta.mail:2.0.2"
//> using dep "com.sun.activation:jakarta.activation:2.0.1"   

import java.sql.Connection
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter


object script {

  def main(parameters: Array[String]): Unit = { 

    // Getting process sequences to run
    val procSequences: List[Int] = if (parameters.isEmpty) {
      List(99) // default process number to run all process sequences
    } else {
      parameters.map(_.toInt).toList
    }

    val catalogsConfig = Utils.LoadConfig("Catalogs.config")
    val etlConfig = Utils.LoadConfig("../../GeneralLibraries/GeneralETL.config")
    val processRunNumber = LocalDateTime.now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
    val logFileName = s"${catalogsConfig("logsFolder")}/$processRunNumber.txt"
    var errorsInETL = false 

    //etlConfig.foreach { case (k, v) => println(s"$k -> $v") } 
    //println(s"smtp server: ${etlConfig("mailSmtpServer")}")
    
    //################################################################################
    // Opening DataBase Connections.
    //################################################################################
    Utils.WriteToTextFile("******************       Opening DataBase Connections.      *******************\n", logFileName)

    //### Opening Data Source Connection.
    val sourceDBConn: Connection = try {
      Utils.WriteToTextFile("******************    Opening Source DataBase Connection.   *******************\n", logFileName)
      DataBaseConnections.h2DBConn( catalogsConfig("sourceDBPath"), catalogsConfig("sourceDBUser"), catalogsConfig("sourceDBPassword") )      
    } catch {
      case e: Exception => {
        Utils.WriteToTextFile("**************** Error Opening Source DataBase Connection. ******************\n" + e.getMessage + "\n", logFileName)
        Utils.SendEmail(catalogsConfig("emailRecipients"), s"Source DB Conn Error, process run number: ${processRunNumber}",
          s"<p><strong>Error opening source database connection, check text file logs for details.</strong></p> ${e.getMessage}", etlConfig)
          sys.exit(1)
      }
    }
    Utils.WriteToTextFile("*****************  Opening Source DataBase Connection Done.  ******************\n", logFileName)

    //### Opening Data Target Connection.
    val targetDBConn: Connection = try {
      Utils.WriteToTextFile("******************    Opening Target DataBase Connection.   *******************\n", logFileName)
      DataBaseConnections.sqliteDBConn(catalogsConfig("targetDBPath"))      
    } catch {      
      case e: Exception => {
        Utils.WriteToTextFile("**************** Error Opening Target DataBase Connection. ******************\n" + e.getMessage + "\n", logFileName)
        Utils.SendEmail(catalogsConfig("emailRecipients"), s"Target DB Conn Error, process run number: ${processRunNumber}",
          s"<p><strong>Error opening target database connection, check text file logs for details.</strong></p> ${e.getMessage}", etlConfig)
          sys.exit(1)
      }
    }
    Utils.WriteToTextFile("*****************  Opening Target DataBase Connection Done.  ******************\n", logFileName)


    /*******************************************************************************
    # Start processing ETL process sequences
    ********************************************************************************/
    for (procSeq <- procSequences) {
      val projectCode = catalogsConfig("projectCode").toInt
      if( procSeq == 99 || procSeq == 200 ) {
          // Read Data And Store it in Target DataBase - Start.
          Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 0, 1, 0, "", logFileName )    
          try {
            Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 205, 1, 0, "", logFileName )
            //> using file Libraries/SitesCatalog.cs // Import ETL Library For Catalog.
            Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 205, 2, 0, "", logFileName )

            // Read Data And Store it in Target DataBase
            Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 206, 1, 0, "", logFileName )
            val etlLibrary = new SitesCatalog(
            if( MainProcess@@( sourceDBConn, targetDBConn, processRunNumber, projectCode, 200 ) ) {
              Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 206, 2, 0, "" )
            } else {
              Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 206, 3, 3002, "" ) // Error.
              errorsInETL = true
            } */     
          } catch {
            case error: Exception => {
              // Catalog Library Cannot be Imported.
              Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 205, 3, 3002, error.getMessage(), logFileName )

              // Cannot Read Data And Store it in Target DataBase.
              Utils.WriteETLMSLog( targetDBConn, processRunNumber, projectCode, 200, 0, 3, 3003, s"ETL Library For Catalog Cannot be Imported: ${error.getMessage()}", logFileName )
              errorsInETL = true
            }
          } 
        } //if( procSeq == 99 || procSeq == 200 ) {



      println(s"Process Sequence to run: $procSeq")
    }










    /*******************************************************************************
    #  Closing DataBase Connections
    ********************************************************************************/
    Utils.CloseDBConnections( sourceDBConn, targetDBConn, logFileName )

  }
}
}
```


presentation compiler configuration:
Scala version: 3.7.4-bin-nonbootstrapped
Classpath:
<WORKSPACE>/.scala-build/Catalogs_c34520776b-e80abaebed/classes/main [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala3-library_3/3.7.4/scala3-library_3-3.7.4.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/sun/mail/jakarta.mail/2.0.2/jakarta.mail-2.0.2.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/sun/activation/jakarta.activation/2.0.1/jakarta.activation-2.0.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/toolkit_3/0.7.0/toolkit_3-0.7.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/xerial/sqlite-jdbc/3.51.1.0/sqlite-jdbc-3.51.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/h2database/h2/2.4.240/h2-2.4.240.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.13.16/scala-library-2.13.16.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/softwaremill/sttp/client4/core_3/4.0.0-RC1/core_3-4.0.0-RC1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/softwaremill/sttp/client4/upickle_3/4.0.0-RC1/upickle_3-4.0.0-RC1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/upickle_3/4.1.0/upickle_3-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/os-lib_3/0.11.3/os-lib_3-0.11.3.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/softwaremill/sttp/model/core_3/1.7.11/core_3-1.7.11.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/softwaremill/sttp/shared/core_3/1.4.2/core_3-1.4.2.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/softwaremill/sttp/shared/ws_3/1.4.2/ws_3-1.4.2.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/softwaremill/sttp/client4/json-common_3/4.0.0-RC1/json-common_3-4.0.0-RC1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/ujson_3/4.1.0/ujson_3-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/upack_3/4.1.0/upack_3-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/upickle-implicits_3/4.1.0/upickle-implicits_3-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/geny_3/1.1.1/geny_3-1.1.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/upickle-core_3/4.1.0/upickle-core_3-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/sourcegraph/semanticdb-javac/0.10.0/semanticdb-javac-0.10.0.jar [exists ], <WORKSPACE>/.scala-build/Catalogs_c34520776b-e80abaebed/classes/main/META-INF/best-effort [missing ]
Options:
-Xsemanticdb -sourceroot <WORKSPACE> -Ywith-best-effort-tasty




#### Error stacktrace:

```
scala.runtime.Scala3RunTime$.assertFailed(Scala3RunTime.scala:8)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:186)
	dotty.tools.dotc.ast.Positioned.check$1$$anonfun$3(Positioned.scala:216)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:15)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:10)
	scala.collection.immutable.List.foreach(List.scala:334)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:216)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.check$1$$anonfun$3(Positioned.scala:216)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:15)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:10)
	scala.collection.immutable.List.foreach(List.scala:334)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:216)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.check$1$$anonfun$3(Positioned.scala:216)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:15)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:10)
	scala.collection.immutable.List.foreach(List.scala:334)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:216)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.check$1$$anonfun$3(Positioned.scala:216)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:15)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:10)
	scala.collection.immutable.List.foreach(List.scala:334)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:216)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.check$1$$anonfun$3(Positioned.scala:216)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:15)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:10)
	scala.collection.immutable.List.foreach(List.scala:334)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:216)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.check$1$$anonfun$3(Positioned.scala:216)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:15)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:10)
	scala.collection.immutable.List.foreach(List.scala:334)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:216)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:211)
	dotty.tools.dotc.ast.Positioned.check$1$$anonfun$3(Positioned.scala:216)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:15)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:10)
	scala.collection.immutable.List.foreach(List.scala:334)
	dotty.tools.dotc.ast.Positioned.check$1(Positioned.scala:216)
	dotty.tools.dotc.ast.Positioned.checkPos(Positioned.scala:237)
	dotty.tools.dotc.parsing.Parser.parse$$anonfun$1(ParserPhase.scala:39)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:15)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:10)
	dotty.tools.dotc.core.Phases$Phase.monitor(Phases.scala:510)
	dotty.tools.dotc.parsing.Parser.parse(ParserPhase.scala:40)
	dotty.tools.dotc.parsing.Parser.$anonfun$2(ParserPhase.scala:52)
	scala.collection.Iterator$$anon$6.hasNext(Iterator.scala:479)
	scala.collection.Iterator$$anon$9.hasNext(Iterator.scala:583)
	scala.collection.immutable.List.prependedAll(List.scala:152)
	scala.collection.immutable.List$.from(List.scala:685)
	scala.collection.immutable.List$.from(List.scala:682)
	scala.collection.IterableOps$WithFilter.map(Iterable.scala:900)
	dotty.tools.dotc.parsing.Parser.runOn(ParserPhase.scala:51)
	dotty.tools.dotc.Run.runPhases$1$$anonfun$1(Run.scala:380)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:15)
	scala.runtime.function.JProcedure1.apply(JProcedure1.java:10)
	scala.collection.ArrayOps$.foreach$extension(ArrayOps.scala:1324)
	dotty.tools.dotc.Run.runPhases$1(Run.scala:373)
	dotty.tools.dotc.Run.compileUnits$$anonfun$1$$anonfun$2(Run.scala:420)
	dotty.tools.dotc.Run.compileUnits$$anonfun$1$$anonfun$adapted$1(Run.scala:420)
	scala.Function0.apply$mcV$sp(Function0.scala:42)
	dotty.tools.dotc.Run.showProgress(Run.scala:482)
	dotty.tools.dotc.Run.compileUnits$$anonfun$1(Run.scala:420)
	dotty.tools.dotc.Run.compileUnits$$anonfun$adapted$1(Run.scala:432)
	dotty.tools.dotc.util.Stats$.maybeMonitored(Stats.scala:69)
	dotty.tools.dotc.Run.compileUnits(Run.scala:432)
	dotty.tools.dotc.Run.compileSources(Run.scala:319)
	dotty.tools.dotc.interactive.InteractiveDriver.run(InteractiveDriver.scala:161)
	dotty.tools.pc.CachingDriver.run(CachingDriver.scala:45)
	dotty.tools.pc.AutoImportsProvider.autoImports(AutoImportsProvider.scala:36)
	dotty.tools.pc.ScalaPresentationCompiler.autoImports$$anonfun$1(ScalaPresentationCompiler.scala:323)
	scala.meta.internal.pc.CompilerAccess.withSharedCompiler(CompilerAccess.scala:149)
	scala.meta.internal.pc.CompilerAccess.withNonInterruptableCompiler$$anonfun$1(CompilerAccess.scala:133)
	scala.meta.internal.pc.CompilerAccess.onCompilerJobQueue$$anonfun$1(CompilerAccess.scala:210)
	scala.meta.internal.pc.CompilerJobQueue$Job.run(CompilerJobQueue.scala:153)
	java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1144)
	java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:642)
	java.base/java.lang.Thread.run(Thread.java:1583)
```
#### Short summary: 

java.lang.AssertionError: assertion failed: position error, parent span does not contain child span
parent      = new SitesCatalog(
  if
    (MainProcess(sourceDBConn, targetDBConn, processRunNumber, projectCode, 200)
      )

    {
      Utils.WriteETLMSLog(targetDBConn, processRunNumber, projectCode, 200,
        206, 2, 0, "")
    }
   else
    {
      Utils.WriteETLMSLog(targetDBConn, processRunNumber, projectCode, 200,
        206, 3, 3002, "")
      (errorsInETL = true)
    } */ _root_.scala.Predef.???
) # -1,
parent span = <4509..4910>,
child       = if (MainProcess(sourceDBConn, targetDBConn, processRunNumber, projectCode, 200))

  {
    Utils.WriteETLMSLog(targetDBConn, processRunNumber, projectCode, 200, 206,
      2, 0, "")
  }
 else
  {
    Utils.WriteETLMSLog(targetDBConn, processRunNumber, projectCode, 200, 206,
      3, 3002, "")
    (errorsInETL = true)
  } */ _root_.scala.Predef.??? # -1,
child span  = [4539..4926]
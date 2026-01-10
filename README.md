# Creating ETLs Using Scripting Languages
There are different ways to create ETLs, here I am showing different ways by using different programming languages.

The reason of doing this: 
Many companies ask me if I know Informatica or SSIS, I tell them, I have been creating ETLs for more than 9 years now using programing languages like Scala, Perl, R, PowerShell and JavaScript.
These ETLs work well, they are fast and eficient. 

ETLsWithPerl are using EplSite, it is Perl development with web interface, and you can run your ETL definitions in batch mode, using a bash script.

ETLsWithScala are using scala-cli, this still in development, in a future it will include the way to generate a jar file with the ETL process.

ETLsWithJavaScript, these scripts are using Java JDBC libraries for all the database connections, file log writings, etc.
I am doing this using my project: https://github.com/LaranIkal/jss
jss(JavaScript Shell) project is using GRAALVM:  https://www.graalvm.org/

NOTE. You can include all your Java libraries(such as JDBC drivers) in your jss pom.xml file and package them together. This way you won't need to have all your JARs inside a jarlib directory.


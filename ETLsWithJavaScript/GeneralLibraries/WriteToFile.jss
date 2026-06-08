/*******************************************************************************
* WriteToFile.jss
* Write text to file.
* Carlos Kassab
* 2025-August-20
********************************************************************************/


var WriteToTextFile = function( textToWrite, fileName ) {

  try {
    
    var FileClass = Java.type('java.io.File'); // Obtain the Java File class    
    var FileWriterClass = Java.type('java.io.FileWriter'); // Obtain the FileWriter class

    var file = new FileClass(fileName); // Set File Name

    // Open the file in append mode, if the file does not exist, it creates it
    var writer = new FileWriterClass(file, true);    
    
    writer.write(textToWrite); // Write content to file

    writer.close(); // Close the writer to flush the data
  } catch (error) {
    print("Error " + error + " writing to file:" + fileName)
  }
}


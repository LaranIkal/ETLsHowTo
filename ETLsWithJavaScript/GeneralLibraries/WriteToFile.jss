/*******************************************************************************
* WriteToFile.jss
* Write text to file.
* Carlos Kassab
* 2025-August-20
********************************************************************************/


var WriteToTextFile = function( textToWrite, fileName ) {

  try {
  // Obtain the Java File class
  var FileClass = Java.type('java.io.File');
  // Obtain the FileWriter class
  var FileWriterClass = Java.type('java.io.FileWriter');


  // Set File Name
  var file = new FileClass(fileName);

  if (file.exists()) {
    //File exists. Appending content...
    
    // Open the file in append mode
    var writer = new FileWriterClass(file, true);

    // Write content to the file
    writer.write(textToWrite);

  } else {
    //File does not exist. Creating a new file...
    
    // Create a FileWriter instance for new file, passing the File object
    var writer = new FileWriterClass(file);

    // Write content to the file
    writer.write(textToWrite);
  }

  // Close the writer to flush the data
  writer.close();
  } catch (error) {
    print("Error " + error + " writing to file:" + fileName)
  }
}


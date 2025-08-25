/*******************************************************************************
* GeneralETL_ConfigVariables.jss
*
* Variable values using in almost all ETL programs 
*
* How to call it:
* When ETL general libs is imported, the variables will be initialized.
* load('../../../GeneralLibraries/GeneralETL_ConfigVariables.jss')
*
* Carlos Kassab
* 2025-August-20
********************************************************************************/

var GetNumericDateTime = function() {
 
  // Get current date and time
  const nowDateTime = new Date();

  // Get date components
  const year = nowDateTime.getFullYear();
  const month = String(nowDateTime.getMonth() + 1).padStart(2, '0');
  const day = String(nowDateTime.getDate()).padStart(2, '0');

  // Get time components
  const hours = String(nowDateTime.getHours()).padStart(2, '0');
  const minutes = String(nowDateTime.getMinutes()).padStart(2, '0');
  const seconds = String(nowDateTime.getSeconds()).padStart(2, '0');

  // Combine into numeric format YYYYMMDDHHMMSS
  const numericDateTime = `${year}${month}${day}${hours}${minutes}${seconds}`;

  return (numericDateTime)

}
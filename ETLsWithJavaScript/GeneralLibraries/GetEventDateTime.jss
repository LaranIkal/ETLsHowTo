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
 
  const deviceTimeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  const numericDateTime = () => new Date().toLocaleString('sv-SE', { timeZone: deviceTimeZone })
                                            .replaceAll('-', '').replaceAll(':', '').replaceAll(' ', '').slice(0, 14)

  return (numericDateTime)

}


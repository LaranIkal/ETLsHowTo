/*******************************************************************************
* ProductionLineQuery.jss
* Production line catalog
* Carlos Kassab
* 2019-Jan-29
********************************************************************************/

// Production line catalog
var selectQuery = "SELECT LINECODE, LINEDESCRIPTION FROM PUBLIC.PRODUCTIONLINE;"

// Truncate target table.
var truncateQuery = "DELETE FROM CAT_ProductionLine WHERE LineCode!='';"


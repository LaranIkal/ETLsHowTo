/*******************************************************************************
* SitesQuery.jss
* Sites Query 
* Carlos Kassab
* 2025-August-20
********************************************************************************/


var selectQuery = "SELECT ID AS SiteID, SITE, DESCRIPTION FROM PUBLIC.SITES;"

// Truncate target table.
var truncateQuery = "DELETE FROM CAT_Sites WHERE SiteID !=0"

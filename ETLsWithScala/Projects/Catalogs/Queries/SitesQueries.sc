/*******************************************************************************
* Sites Queries 
* Carlos Kassab -- 2025-December-28
********************************************************************************/


val selectQuery = "SELECT ID AS SiteID, SITE, DESCRIPTION FROM PUBLIC.SITES;"

// Truncate target table.
val truncateQuery = "DELETE FROM CAT_Sites WHERE SiteID !=0"

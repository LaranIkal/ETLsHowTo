/*******************************************************************************
* Sites Queries 
* Carlos Kassab -- 2025-December-28
********************************************************************************/



// Using methods to return query strings for lazy evaluation, saves memory

// Query string to select from source data, the query below is a simple examples.
  def selectQuery = "SELECT ID AS SiteID, SITE, DESCRIPTION FROM PUBLIC.SITES;"

// Delete target table data.
  def truncateQuery = "DELETE FROM CAT_Sites WHERE SiteID !=0"

  def insertQuery = "INSERT INTO CAT_Sites (SiteID, Site, Description) VALUES (?, ?, ?)"


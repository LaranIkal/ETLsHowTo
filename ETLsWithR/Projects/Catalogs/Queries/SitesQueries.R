#*******************************************************************************
#* SitesQuery.R
#* Sites Query For IMI Analytics
#* Carlos Kassab
#* 2019-Jan-28
#*******************************************************************************


selectQuery = "SELECT ID AS SiteID, SITE, DESCRIPTION FROM PUBLIC.SITES;"

# Truncate target table.
truncateQuery = "DELETE FROM CAT_Sites WHERE SiteID !=0"


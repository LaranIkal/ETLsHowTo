#*******************************************************************************
#* ProductionLineQuery.R
#* Operation type, operation and line catalogs Query For IMI Analytics
#* Carlos Kassab
#* 2019-Jan-29
#*******************************************************************************

# Production line catalog
selectQuery = "SELECT LINECODE, LINEDESCRIPTION FROM PUBLIC.PRODUCTIONLINE;"

# Truncate target table.
truncateQuery = "DELETE FROM CAT_ProductionLine WHERE LineCode=!''"


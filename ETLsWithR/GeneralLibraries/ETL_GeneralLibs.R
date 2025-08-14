#*******************************************************************************
#* ETL_GeneralLibs.R
#* Loading the collection of libraries used by ETL scripts
#* Carlos Kassab
#* 2019-January-25
#*******************************************************************************

# This file must be loaded from the main ETL script of a project in this way:
# source( "../../../GeneralLibraries/ETL_GeneralLibs.R" )

source( "../../../GeneralLibraries/GeneralETL_ConfigVariables.R" )

source( "../../../GeneralLibraries/DataBaseConnections.R" )

source( "../../../GeneralLibraries/WriteETLMSLog.R" )

source( "../../../GeneralLibraries/SendEmail.R" )

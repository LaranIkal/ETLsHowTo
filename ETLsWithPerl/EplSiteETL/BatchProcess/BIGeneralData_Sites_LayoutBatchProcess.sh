#!/bin/sh

cd .. # Move to the parent directory where hypertextperl.pl is located

#echo "\nStarting Layout Batch Process...\n"

## Output to file: Set target database connection($ARGV[6]) to 3333, it will send the data to a pipe delimited file.
## This is the only option for output to file for now.


# Output to file example
./hypertextperl.pl BatchProcess/LayoutBatchProcess.ppl Layout 001 BIGeneralData 4 16 3333 /tmp


# Output to database example
./hypertextperl.pl BatchProcess/LayoutBatchProcess.ppl Layout 001 BIGeneralData 4 16 17


# You can get the IDs from the respective tables in the database(Mentioned below).
# or from the EplSite ETL web interface ~> EplSite ETL Main Menu, by selecting the "EplSite ETL Scheme to Display Menu"
#
#Parameters needed to run the LayoutBatchProcess.ppl script:"
#<Layout or Script> ~> e.g. "Layout"
#<TransformationCode or ScriptID> ~> e.g. "001" - From table: eplsite_etl_transformation_definitions
#<ETLSchemeCode> ~> e.g. "ETLSample" -  From table: eplsite_etl_schemes
#<ETLSchemeID> ~> e.g. "2" - From table: eplsite_etl_schemes
#<DBConnSourceID> ~> e.g. "9" - From table: eplsite_etl_data_sources
#<DBConnTargetID> ~> e.g. "9" or "3333" (for output to file)
#<OutputFilesDirectory> ~> e.g. "/tmp" (only needed when using output to file)


#echo "\nLayout Batch Process End...\n"

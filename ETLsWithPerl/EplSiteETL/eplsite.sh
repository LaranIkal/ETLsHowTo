#Set the path to Oracle Libraries
#export LD_LIBRARY_PATH=/home/laran/Apps/instantclient_11_2
#Run eplsite preloading your modules
#In this file you can add or delete DBI/DBD modules preloaded.


#If you are running plackup from your Perl linux distribution(Recommended):
#listening on localhost only(--host=localhost):
#plackup -MDBI -MDBD::SQLite -MDBD::CSV -MDBD::DuckDB -MDBD::ODBC -MDBD::Oracle -MDBD::Pg -MDBD::mysql -MMIME::Base64 --loader Shotgun -s Starlet --host=localhost --port=3333 --timeout=3600 --max-workers=3 --access-log eplsite_access.log eplsite.pl

plackup -MDBI -MDBD::SQLite -MDBD::CSV -MDBD::DuckDB -MMIME::Base64 --loader Shotgun -s Starlet --host=localhost --port=3333 --timeout=3600 --max-workers=3 --access-log eplsite_access.log eplsite.pl


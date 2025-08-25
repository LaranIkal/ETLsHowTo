echo off

set scriptpath=%CD%

set myScript=BICatalogs.jss

java -cp jss-1.0.jar;jarlib/* org.jss.jss %myScript% scriptPath=%scriptpath%

REM # Sample assigning procSequence: Note. NO BLANK SPACES BETWEEN VALUES
REM java -cp jss-1.0.jar;jarlib/* org.jss.jss %myScript% scriptPath=%scriptpath% procSequences=200,300

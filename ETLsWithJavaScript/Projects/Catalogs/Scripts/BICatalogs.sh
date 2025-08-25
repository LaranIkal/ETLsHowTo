#!/bin/sh

# clear

cd "/home/ckassab/Development/ETLs/ETLsHowTo/ETLsWithJavaScript/Projects/Catalogs/Scripts"

scriptpath=$(pwd -P)
myScript="BICatalogs.jss"

java -cp jss-1.0.jar:jarlib/* org.jss.jss $myScript scriptPath=$scriptpath

# Sample assigning procSequence: Note. NO BLANK SPACES BETWEEN VALUES
#java -cp jss-1.0.jar:jarlib/* org.jss.jss $myScript scriptPath=$scriptpath procSequences=200,300


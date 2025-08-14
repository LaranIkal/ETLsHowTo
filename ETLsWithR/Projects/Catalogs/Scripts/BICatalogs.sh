!/bin/sh

# clear

cd "/home/ckassab/Development/ETLs/ETLsHowTo/ETLsWithR/Projects/Catalogs/Scripts"

# Set local path variable by getting the current working directory
scriptpath=$(pwd -P)

echo "$scriptpath"

# Run Rscript with local path argument as first parameter for the script
Rscript BICatalogs.R $scriptpath



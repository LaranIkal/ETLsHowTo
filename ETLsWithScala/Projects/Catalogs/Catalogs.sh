#!/bin/sh

# clear

# The next command is needed to run cron jobs, and run the ETL from inside our project directory:
#cd /home/ckassab/Development/ETLs/ETLsHowTo/ETLsWithScala/Projects/Catalogs

scala-cli --suppress-warning-directives-in-multiple-files -no-indent Catalogs.sc -- $*


# --suppress-warning-directives-in-multiple-files: disables the warning that appears for using directives are spread across multiple source files.

# -no-indent: tells the compiler to disable the spaces indentation-based syntax, curly braces {} must be used instead.

# -- $*: This passes all command-line arguments provided after -- directly to the script as a list (accessible via args in the Scala code)

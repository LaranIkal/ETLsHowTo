#!/bin/sh


# This command generates the necessary configuration files to help the IDE(vscode, vscodium,  IntelliJ IDEA) 
# to have full IDE support for your Scala scripting project, 
# avoiding red underscore on libraries like SitesQueries.selectQuery

scala-cli setup-ide .

# Probably it is needed to run this command many times when editing the project scripts



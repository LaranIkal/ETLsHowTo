#!/bin/sh

# clear

scala-cli --suppress-warning-directives-in-multiple-files -no-indent Catalogs.sc -- $*



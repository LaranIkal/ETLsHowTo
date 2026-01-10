#!d:\Utils\wamp\bin\Perl\bin\perl -X
##
##  printenv -- demo CGI program which just prints its environment
##

#~ print "Content-type: text/plain; charset=iso-8859-1\n\n";
foreach $var (sort(keys(%ENV))) {
  $val = $ENV{$var};
  $val =~ s|\n|\\n|g;
  $val =~ s|"|\\"|g;
  echo ( "${var}=\"${val}\"<br>");
}


print "Content-type: text/xml\n\n";
print "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n\n";
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'config.prc');
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'mainprogram.prc');
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'skins/'.$globalp->{skin}.'/colors.prc');
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'includes/subs.prc');


$sthbackend = $globalp->{dbh} -> prepare ("SELECT sid, title FROM ".$globalp->{table_prefix}."_stories ORDER BY sid DESC limit 10") or die "Cannot SELECT from ".$globalp->{table_prefix}."_stories";
$sthbackend -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_stories";
$sthbackend -> bind_columns(undef, \$sid, \$title);

print "<!DOCTYPE rss PUBLIC \"-//Netscape Communications//DTD RSS 0.91//EN\"\n";
print " \"http://my.netscape.com/publish/formats/rss-0.91.dtd\">\n\n";
print "<rss version=\"0.91\">\n\n";
print "<channel>\n";
print "<title>".$globalp->{pagetitle}."</title>\n";
print "<link>$globalp->{eplsite_url}</link>\n";
print "<description>".$globalp->{backend_title}."</description>\n";
print "<language>$globalp->{backend_language}</language>\n\n";

while( $datbackend = $sthbackend -> fetchrow_arrayref ) {
  print "<item>\n";
  print "<title>".$globalp->{htmlspecialchars}($title)."</title>\n";
  print "<link>".$globalp->{eplsite_url}."index.prc?module=News;option=read;sid=$sid</link>\n";
  print "<description>".$globalp->{htmlspecialchars}($title)."</description>\n";
  print "</item>\n\n";
}
$sthbackend->finish();

print "</channel>\n";
print "</rss>";
$globalp->{dbh}->disconnect();

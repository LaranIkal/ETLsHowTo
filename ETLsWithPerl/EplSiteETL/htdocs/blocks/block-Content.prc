#!/usr/bin/perl

$sthcontent = $globalp->{dbh} -> prepare ("SELECT pid, title FROM ".$globalp->{table_prefix}."_pages WHERE active='1'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
$sthcontent -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
$sthcontent -> bind_columns(undef, \$pid, \$ptitle);

while ($datcontent = $sthcontent -> fetchrow_arrayref) {
  $content .= "<strong><big>&middot;</big></strong>&nbsp;<a href=\"index.epl?module=Content&amp;pa=showpage&amp;pid=$pid\">".$ptitle."</a><br>";
}
$sthcontent->finish();


if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else{ echo("Access denied"); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }

$sthadmauth = $globalp->{dbh} -> prepare ("select radminsuper from ".$globalp->{table_prefix}."_authors where aid='$globalp->{aid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
$sthadmauth -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
$sthadmauth -> bind_columns(undef, \$radminsuper);
$datadmauth = $sthadmauth -> fetchrow_arrayref;
$sthadmauth->finish();

if( $radminsuper != 1 ) { echo("Access denied!!!!"); $globalp->{clean_exit}(); }

local $escmode = 0;
$globalp->{siteheader}(); $globalp->{theheader}();
$globalp->{GraphicAdmin}();
echo("</div>");

$sth = $globalp->{dbh}->do("ANALYZE") or die "Cannot run command ANALYZE on database" ;
$sth = $globalp->{dbh}->do("VACUUM") or die "Cannot run command VACUUM on database" ;
echo("<br>");

$globalp->{OpenTable}();
echo("<center><font class=\"title\">ANALYZE and VACUUM commands on EplSite SQLITE DB successfully executed.</font></center>");
$globalp->{CloseTable}();

$globalp->{sitefooter}();


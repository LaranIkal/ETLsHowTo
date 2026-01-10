#!/usr/bin/perl

# Here we make the Modules block with the correspondent links

$sth2 = $globalp->{dbh}->prepare ("select title, custom_title from ".$globalp->{table_prefix}."_modules where active='1' and inmenu='1' ORDER BY mid ASC")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_modules";
$sth2 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_modules";
$sth2 -> bind_columns(undef,\$m_title, \$custom_title);
$content = '<strong><big>&middot;</big></strong>&nbsp;<a href="index.prc">'.$globalp->{_HOME}.'</a><br>';

while ($dat2 = $sth2 -> fetchrow_arrayref) {
  $m_title2 = $m_title;
  $m_title2 =~ s/_/ /g;

  if( $custom_title ne "" ) { $m_title2 = $custom_title; }

  if( $m_title ne $globalp->{main_module} ) { $content .= '<strong><big>&middot;</big></strong>&nbsp;<a href="index.prc?module='.$m_title.'">'.$m_title2.'</a><br>'; }
}
$sth2->finish();







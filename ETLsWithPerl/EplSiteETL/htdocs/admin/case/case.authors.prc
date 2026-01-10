if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else { echo("$ENV{'SCRIPT_NAME'} Access denied"); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }

if( ( $fdat{option} eq "mod_authors" )
  || ( $fdat{option} eq "modifyadmin" )
  || ( $fdat{option} eq "UpdateAuthor" )
  || ( $fdat{option} eq "AddAuthor" )
  || ( $fdat{option} eq "deladmin2" )
  || ( $fdat{option} eq "deladmin" )
  || ( $fdat{option} eq "assignstories" )
  || ( $fdat{option} eq "deladminconf" ) ) {
    Execute ($globalp->{eplsite_path}.'admin/modules/authors.prc');
}

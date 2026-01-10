if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else{ echo("Access denied"); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }

if( ( $fdat{option} eq "messages" )
  || ( $fdat{option} eq "addmsg" )
  || ( $fdat{option} eq "editmsg" )
  || ( $fdat{option} eq "deletemsg" )
  || ( $fdat{option} eq "savemsg" ) ) {
    Execute ($globalp->{eplsite_path}.'admin/modules/messages.prc');
}

if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else{ echo("Access denied"); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }

if( ( $fdat{option} eq "upgrade" ) 
	|| ( $fdat{option} eq "doupgrade" ) ) {
    Execute ($globalp->{eplsite_path}.'admin/modules/upgrade/upgrade.prc');
}

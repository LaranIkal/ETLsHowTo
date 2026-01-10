if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else{ echo("Access denied"); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }

if( ( $fdat{option} eq "modules" )
  || ( $fdat{option} eq "module_status" )
  || ( $fdat{option} eq "module_edit" )
  || ( $fdat{option} eq "module_edit_save" )
  || ( $fdat{option} eq "home_module" ) ) {
    Execute ($globalp->{eplsite_path}.'admin/modules/modules.prc');
}

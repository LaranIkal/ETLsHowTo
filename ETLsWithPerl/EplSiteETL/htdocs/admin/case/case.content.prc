if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else{ echo("Access denied."); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }


if( ( $fdat{option} eq "content" )
  || ( $fdat{option} eq "content_edit" )
  || ( $fdat{option} eq "content_delete" )
  || ( $fdat{option} eq "content_save" )
  || ( $fdat{option} eq "content_save_edit" )
  || ( $fdat{option} eq "content_change_status" )
  || ( $fdat{option} eq "add_category" )
  || ( $fdat{option} eq "edit_category" )
  || ( $fdat{option} eq "save_category" )
  || ( $fdat{option} eq "del_content_cat" ) ) {
    Execute ($globalp->{eplsite_path}.'admin/modules/content.prc');
}


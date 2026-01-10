if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else{ echo("Access denied"); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }

if( ( $fdat{option} eq "EplSiteReportsManager" )
  || ( $fdat{option} eq "reports_user_save" )
  || ( $fdat{option} eq "Reports Edit User" )
  || ( $fdat{option} eq "Reports User Delete" )
  || ( $fdat{option} eq "report_group_save" )
  || ( $fdat{option} eq "Edit Report Group" )
  || ( $fdat{option} eq "Delete Report Group" )
  || ( $fdat{option} eq "reports_show_persons" )
  || ( $fdat{option} eq "eplsite_report_save" )
  || ( $fdat{option} eq "Edit Report Perl Script" )
  || ( $fdat{option} eq "EplSite Report Delete" )
  || ( $fdat{option} eq "eplsite_javascript_save" )
  || ( $fdat{option} eq "Edit JavaScript" )
  || ( $fdat{option} eq "Delete JavaScript" ) ) {
    Execute ($globalp->{eplsite_path}.'admin/modules/eplsitereports.prc');
}

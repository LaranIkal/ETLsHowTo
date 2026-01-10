if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else{ echo("Access denied"); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }

if( ( $fdat{option} eq "EplSiteETLManager" )
  || ( $fdat{option} eq "resour_save" )
  || ( $fdat{option} eq $globalp->{_EDITUSER} )
  || ( $fdat{option} eq $globalp->{_DELETEUSER} )
  || ( $fdat{option} eq "show_etl_users" )
  || ( $fdat{option} eq "Transformation_save" )
  || ( $fdat{option} eq "Edit Transformation" )
  || ( $fdat{option} eq "Delete Transformation" )  
  || ( $fdat{option} eq "ETL_ExtractScript_save" )
  || ( $fdat{option} eq "Edit Perl ScriptLet" )
  || ( $fdat{option} eq "Delete Extract Script" )    
  || ( $fdat{option} eq "ETLS_save" )
  || ( $fdat{option} eq "Edit ETLS" )
  || ( $fdat{option} eq "Delete ETLS" )    
  || ( $fdat{option} eq "Catalog_save" )
  || ( $fdat{option} eq "Edit Catalog" )
  || ( $fdat{option} eq "Delete Catalog" )
  || ( $fdat{option} eq "DBConnection_save" )
  || ( $fdat{option} eq "Edit DB Connection" )
  || ( $fdat{option} eq "Delete DB Connection" )
  || ( $fdat{option} eq "Test DB Connection" )
  || ( $fdat{option} eq "ETL_delete_logs" )
  || ( $fdat{option} eq "ETL_delete_logsByRunNumber" )
  || ( $fdat{option} eq "ETL_delete_xreflogs" )
  || ( $fdat{option} eq "ETL_delete_xreflogsByRunNumber" )
  || ( $fdat{option} eq "ETL_delete_catlogs" )
  || ( $fdat{option} eq "ETL_delete_catlogsByRunNumber" ) ) {
    Execute ($globalp->{eplsite_path}.'admin/modules/eplsiteetl.prc');
}

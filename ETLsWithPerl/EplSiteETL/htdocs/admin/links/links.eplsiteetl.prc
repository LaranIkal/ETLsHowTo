if( ( $globalp->{radminsuper} == 1 ) || ( $globalp->{radminworkflow} == 1 ) ) {
    $globalp->{adminmenu}("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}", "EplSite ETL", "icefox_blue1.png");
}

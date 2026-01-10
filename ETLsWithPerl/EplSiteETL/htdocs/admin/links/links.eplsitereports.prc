if( ( $globalp->{radminsuper} == 1 ) || ( $globalp->{radminworkflow} == 1 ) ) {
    $globalp->{adminmenu}("admin.prc?option=EplSiteReportsManager&amp;session=$globalp->{session}", "EplSite Reports", "workflow.png");
}

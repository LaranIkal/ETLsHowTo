if( ( $globalp->{radminsuper} == 1 ) || ( $globalp->{radmincontent} == 1 ) ) {
    $globalp->{adminmenu}("admin.prc?option=content&session=$globalp->{session}", "".$globalp->{_CONTENTMANAGER}."", "content.png");
}


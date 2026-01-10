if( $globalp->{radminsuper} == 1 ) {
    $globalp->{adminmenu}("admin.prc?option=modules&session=$globalp->{session}", "".$globalp->{_MODULES}."", "modules.png");
}
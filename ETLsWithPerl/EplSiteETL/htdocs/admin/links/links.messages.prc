if( $globalp->{radminsuper} == 1 ) {
    $globalp->{adminmenu}("admin.prc?option=messages&session=$globalp->{session}", "".$globalp->{_MESSAGES}."", "messages.png");
}
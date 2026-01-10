if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else{ echo("Access denied"); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }


    $sthadmauth = $globalp->{dbh} -> prepare ("select radminsuper from ".$globalp->{table_prefix}."_authors where aid='$globalp->{aid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
    $sthadmauth -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
    $sthadmauth -> bind_columns(undef, \$radminsuper);
    $datadmauth = $sthadmauth -> fetchrow_arrayref;
    $sthadmauth -> finish();

if( $radminsuper != 1 )
{
    echo("Access denied!!!!"); $globalp->{clean_exit}();
}



#*********************************************************
#* REVIEWS Block Functions                               *
#*********************************************************

sub modules() {

    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
	echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>".$globalp->{_MODULESADMIN}."</b></font></center>");
    $globalp->{CloseTable}();

    opendir (MODULES,$globalp->{eplsite_path}."modules") || die "can't opendir modules dir: $!";
    rewinddir(MODULES);
    @modules = readdir(MODULES);
    foreach $files (@modules)
    {
       if( $files =~ /\./ ){ $nothingtodo = 1} else{ $modslist .= "$files "; }
    }
    closedir(MODULES);

    @modlist = split(' ', $modslist);
    @moddirs = sort @modlist;
    $i = 0;
    foreach (@moddirs)
    {

    if( $moddirs[$i] ne "")
    {
           $mid = "";
           $sthresult = $globalp->{dbh} -> prepare ("select mid from ".$globalp->{table_prefix}."_modules where title='$moddirs[$i]'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_modules";
           $sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_modules";
           $sthresult -> bind_columns(undef, \$mid);
           $datresult = $sthresult -> fetchrow_arrayref;
           $sthresult -> finish();

       if( $mid eq "")
       {
           $globalp->{dbh}->do("insert into ".$globalp->{table_prefix}."_modules values (NULL, '$moddirs[$i]', '$moddirs[$i]', '0', '0', '0')");
       }
    }
           $i++;
    }

    $sthresult = $globalp->{dbh} -> prepare ("select title from ".$globalp->{table_prefix}."_modules") or die "Cannot SELECT from ".$globalp->{table_prefix}."_modules";
    $sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_modules";
    $sthresult -> bind_columns(undef, \$title);

    while ( $datresult = $sthresult -> fetchrow_arrayref )
    {
        $a = 0;
        opendir (MODULES,$globalp->{eplsite_path}."modules") || die "can't opendir modules dir: $!";
        rewinddir(MODULES);
        @modules = readdir(MODULES);
        foreach $file (@modules)
        {
            $a = 1 if( $file eq $title );
        }
        closedir(MODULES);

        if( $a == 0)
        {
            $globalp->{dbh}->do("delete from ".$globalp->{table_prefix}."_modules where title='$title'");
        }
    }
    $sthresult -> finish();

    echo("<br>");
    $globalp->{OpenTable}();
    echo("<br><center><font class=\"option\">".$globalp->{_MODULESADDONS}."</font><br><br>"
             ."<font class=\"content\">".$globalp->{_MODULESACTIVATION}."</font><br><br>"
             ."".$globalp->{_MODULEHOMENOTE}."<br><br>"
             ."<form action=\"admin.prc\" method=\"post\">"
             ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">"
             ."<table border=\"1\" align=\"center\" width=\"90%\"><tr><td align=\"center\" bgcolor=\"$bgcolor2\">"
             ."<b>".$globalp->{_TITLE}."</b></td><td align=\"center\" bgcolor=\"$bgcolor2\"><b>".$globalp->{_CUSTOMTITLE}."</b></td><td align=\"center\" bgcolor=\"$bgcolor2\"><b>".$globalp->{_STATUS}."</b></td><td align=\"center\" bgcolor=\"$bgcolor2\"><b>".$globalp->{_INMENU}."</b></td><td align=\"center\" bgcolor=\"$bgcolor2\"><b>".$globalp->{_VIEW}."</b></td><td align=\"center\" bgcolor=\"$bgcolor2\"><b>".$globalp->{_FUNCTIONS}."</b></td></tr>");

     $sthresult = $globalp->{dbh} -> prepare ("select mid, title, custom_title, active, view, inmenu from ".$globalp->{table_prefix}."_modules order by title ASC") or die "Cannot SELECT from ".$globalp->{table_prefix}."_modules";
     $sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_modules";
     $sthresult -> bind_columns(undef, \$mid, \$title, \$custom_title, \$active, \$view, \$minmenu);

    while( $datresult = $sthresult -> fetchrow_arrayref )
    {
        if( $active == 1 )
        {
            $active = $globalp->{_ACTIVE};
            $change = $globalp->{_DEACTIVATE};
            $act = 0;
        }
        else
        {
            $active = "<i>".$globalp->{_INACTIVE}."</i>";
            $change = $globalp->{_ACTIVATE};
            $act = 1;
        }
        if( $custom_title eq "" )
        {
            $custom_title = $title;
            $custom_title =~ s/_/ /g;
        }
        if( $view == 0 ) { $who_view = $globalp->{_MVALL}; }
        elsif( $view == 1 ) { $who_view = $globalp->{_MVUSERS}; }
        elsif( $view == 2 ) { $who_view = $globalp->{_MVADMIN}; }

        if( $minmenu eq "1" ){$is_in_menu = "Yes"; }
        elsif( $minmenu eq "0" ) { $is_in_menu = "No"; }
        if( $title eq $globalp->{main_module} )
        {
            $title = "<b>$title</b>";
            $custom_title = "<b>$custom_title</b>";
            $active = "<b>$active (".$globalp->{_INHOME}.")</b>";
            $who_view = "<b>$who_view</b>";
            $puthome = "<i>".$globalp->{_PUTINHOME}."</i>";
            $change_status = "<i>$change</i>";
            $background = "bgcolor=\"$bgcolor2\"";
        }
        else
        {
            $puthome = "<a href=\"admin.prc?session=$globalp->{session}&option=home_module&mid=$mid\">".$globalp->{_PUTINHOME}."</a>";
            $change_status = "<a href=\"admin.prc?session=$globalp->{session}&option=module_status&mid=$mid&active=$act\">$change</a>";
            $background = "";
        }

        echo("<tr><td $background>&nbsp;$title</td><td align=\"center\" $background>$custom_title</td><td align=\"center\" $background>$active</td><td align=\"center\" $background>$is_in_menu</td><td align=\"center\" $background>$who_view</td><td align=\"center\" $background>[ <a href=\"admin.prc?session=$globalp->{session}&option=module_edit&mid=$mid\">".$globalp->{_EDIT}."</a> | $change_status | $puthome ]</td></tr>");
    }
    $sthresult -> finish();

    echo("</table>");
    $globalp->{CloseTable}();
    $globalp->{sitefooter}();
}



sub home_module
{

    if( $fdat{ok} == 0 )
    {
        $globalp->{siteheader}(); $globalp->{theheader}();
        $globalp->{GraphicAdmin}();
		echo("</div>");
        $globalp->{print_title}("".$globalp->{_HOMECONFIG}."");
        $globalp->{OpenTable}();
        $sthresult = $globalp->{dbh} -> prepare ("select title from ".$globalp->{table_prefix}."_modules where mid='$fdat{mid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_modules";
        $sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_modules";
        $sthresult -> bind_columns(undef, \$new_m);
        $datresult = $sthresult -> fetchrow_arrayref;
        $sthresult -> finish();

        echo("<center><b>".$globalp->{_DEFHOMEMODULE}."</b><br><br>"
                 ."".$globalp->{_SURETOCHANGEMOD}." <b>$globalp->{main_module}</b> ".$globalp->{_TO}." <b>$new_m</b>?<br><br>"
                 ."[ <a href=\"admin.prc?session=$globalp->{session}&option=modules\">".$globalp->{_NO}."</a> | <a href=\"admin.prc?session=$globalp->{session}&option=home_module&mid=$fdat{mid}&ok=1\">".$globalp->{_YES}."</a> ]</center>");
        $globalp->{CloseTable}();
        $globalp->{sitefooter}();
    }
    else
    {
        $globalp->{read_eplsite_config}();
        $sthresult = $globalp->{dbh} -> prepare ("select title from ".$globalp->{table_prefix}."_modules where mid='$fdat{mid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_modules";
        $sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_modules";
        $sthresult -> bind_columns(undef, \$globalp->{main_modulecc});
        $datresult = $sthresult -> fetchrow_arrayref;
        $sthresult -> finish();

        $active = 1;
        $view = 0;
        $globalp->{update_eplsite_config}();

        $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_modules set active='$active', view='$view' where mid='$fdat{mid}'");
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?session=$globalp->{session}&option=modules");
    }
}




sub module_status
{
    $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_modules set active='$fdat{active}' where mid='$fdat{mid}'");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?session=$globalp->{session}&option=modules");
}



sub module_edit
{

    $sthresult = $globalp->{dbh} -> prepare ("select title, custom_title, view, inmenu from ".$globalp->{table_prefix}."_modules where mid='$fdat{mid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_modules";
    $sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_modules";
    $sthresult -> bind_columns(undef, \$mtitle, \$mcustom_title, \$view, \$minmenu);
    $datresult = $sthresult -> fetchrow_arrayref;
    $sthresult -> finish();

    $globalp->{siteheader}(); $globalp->{theheader}();

    $globalp->{GraphicAdmin}();
	echo("</div>");
    $globalp->{print_title}("".$globalp->{_MODULEEDIT}."");
    $globalp->{OpenTable}();

    if( $view == 0 )
    {
        $sel1 = "selected";
        $sel2 = "";
        $sel3 = "";
    }
    elsif( $view == 1 )
    {
        $sel1 = "";
        $sel2 = "selected";
        $sel3 = "";
    }
    elsif( $view == 2 )
    {
        $sel1 = "";
        $sel2 = "";
        $sel3 = "selected";
    }


    if( $minmenu eq "0" )
    {
        $sel11 = "selected";
        $sel12 = "";
    }
    elsif( $minmenu eq "1" )
    {
        $sel11 = "";
        $sel12 = "selected";
    }


    if( $mtitle eq $globalp->{main_module})
    {
        $a = " - ".$globalp->{_INHOME}."";
    } else {
        $a = "";
    }
    echo("<center><b>".$globalp->{_CHANGEMODNAME}."</b><br>($mtitle$a)</center><br><br>"
             ."<form action=\"admin.prc\" method=\"post\">"
             ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">"
             ."<table border=\"0\"><tr><td>"
             ."".$globalp->{_CUSTOMMODNAME}."</td><td>"
             ."<input type=\"text\" name=\"custom_title\" value=\"$mcustom_title\" size=\"50\"></td></tr>");
    if( $title eq $globalp->{main_module} )
    {
        echo("<input type=\"hidden\" name=\"view\" value=\"0\">"
                 ."</table><br><br>");
    }
    else
    {
        echo("<tr><td>".$globalp->{_VIEWPRIV}."</td><td><select name=\"view\">"
                 ."<option value=\"0\" $sel1>".$globalp->{_MVALL}."</option>"
                 ."<option value=\"1\" $sel2>".$globalp->{_MVUSERS}."</option>"
                 ."<option value=\"2\" $sel3>".$globalp->{_MVADMIN}."</option>"
                 ."</select>"
                 ."</td></tr>"
                 ."<tr><td>".$globalp->{_INMENU}."</td><td><select name=\"inmenu\">"
                 ."<option value=\"0\" $sel11>".$globalp->{_INMENUN}."</option>"
                 ."<option value=\"1\" $sel12>".$globalp->{_INMENUY}."</option>"
                 ."</select>"
                 ."</td></tr></table><br><br>");
    }


    echo("<input type=\"hidden\" name=\"mid\" value=\"$fdat{mid}\">"
             ."<input type=\"hidden\" name=\"option\" value=\"module_edit_save\">"
             ."<input type=\"submit\" value=\"".$globalp->{_SAVECHANGES}."\">"
             ."</form>"
             ."<br><br><center>".$globalp->{_GOBACK}."</center>");
    $globalp->{CloseTable}();
    $globalp->{sitefooter}();
}



sub module_edit_save
{
    $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_modules set custom_title='$fdat{custom_title}', view='$fdat{view}' , inmenu='$fdat{inmenu}' where mid='$fdat{mid}'");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?session=$globalp->{session}&option=modules");
}



if( $fdat{option} eq "modules" ) { &modules();}
elsif( $fdat{option} eq "module_status" ) { &module_status; }
elsif( $fdat{option} eq "module_edit" ) { &module_edit; }
elsif( $fdat{option} eq "module_edit_save" ) { &module_edit_save; }
elsif( $fdat{option} eq "home_module" ) { &home_module; }


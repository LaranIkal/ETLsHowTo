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
#* Messages Functions                                    *
#*********************************************************

sub MsgDeactive
{
    $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_message set active='0' WHERE mid='$fdat{mid}'");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?session=$globalp->{session}&option=messages");
}

sub messages()
{
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
	echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>".$globalp->{_MESSAGESADMIN}."</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>".$globalp->{_ALLMESSAGES}."</b></font><br><br><table border=\"1\" width=\"100%\" bgcolor=\"$globalp->{bgcolor1}\">"
             ."<td bgcolor=\"$globalp->{bgcolor2}\" align=\"center\"><b>".$globalp->{_ID}."</b></td>"
             ."<td bgcolor=\"$globalp->{bgcolor2}\" align=\"center\"><b>".$globalp->{_TITLE}."</b></td>"
             ."<td bgcolor=\"$globalp->{bgcolor2}\" align=\"center\">&nbsp;<b>".$globalp->{_LANGUAGE}."</b>&nbsp;</td>"
             ."<td bgcolor=\"$globalp->{bgcolor2}\" align=\"center\" nowrap>&nbsp;<b>".$globalp->{_VIEW}."</b>&nbsp;</td>"
             ."<td bgcolor=\"$globalp->{bgcolor2}\" align=\"center\" nowrap>&nbsp;<b>".$globalp->{_EXPIREIN}."</b>&nbsp;</td>"
             ."<td bgcolor=\"$globalp->{bgcolor2}\" align=\"center\">&nbsp;<b>".$globalp->{_ACTIVE}."</b>&nbsp;</td>"
             ."<td bgcolor=\"$globalp->{bgcolor2}\" align=\"center\">&nbsp;<b>".$globalp->{_FUNCTIONS}."</b>&nbsp;</td></tr>");

    $sthresult = $globalp->{dbh} -> prepare ("select mid, title, content, date, expire, active, view, mlanguage from ".$globalp->{table_prefix}."_message") or die "Cannot SELECT from ".$globalp->{table_prefix}."_message";
    $sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_message";
    $sthresult -> bind_columns(undef, \$mid, \$title, \$content, \$mdate, \$expire, \$active, \$view, \$mlanguage);

    while( $datresult = $sthresult -> fetchrow_arrayref )
    {
        if( $expire == 0 )
        {
            $remain = $globalp->{_UNLIMITED};
        }
        else
        {
            $etime = ( ( $mdate + $expire ) - time() ) / 3600;
            $etime = int($etime);
            if( $etime < 1 )
            {
                $remain = $globalp->{_EXPIRELESSHOUR};
            } else {
                $remain = "".$globalp->{_EXPIREIN}." $etime ".$globalp->{_HOURS}."";
            }
        }

        if( $active == 1 ) { $mactive = "".$globalp->{_YES}.""; }
        elsif( $active == 0) { $mactive = "".$globalp->{_NO}.""; }

        if( $view == 1 ) { $mview = "".$globalp->{_MVALL}.""; }
        elsif( $view == 2 ) { $mview = "".$globalp->{_MVUSERS}.""; }
        elsif( $view == 3) { $mview = "".$globalp->{_MVANON}.""; }
        elsif( $view == 4) { $mview = "".$globalp->{_MVADMIN}.""; }

        $mlanguage = "".$globalp->{_ALL}."" if( $mlanguage eq "");

        echo("<tr><td align=\"right\"><b>$mid</b>"
                 ."</td><td align=\"left\" width=\"100%\"><b>$title</b>"
                 ."</td><td align=\"center\">$mlanguage"
                 ."</td><td align=\"center\" nowrap>$mview"
                 ."</td><td align=\"center\">$remain"
                 ."</td><td align=\"center\">$mactive"
                 ."</td><td align=\"right\" nowrap>(<a href=\"admin.prc?session=$globalp->{session}&option=editmsg&mid=$mid\">".$globalp->{_EDIT}."</a>-<a href=\"admin.prc?session=$globalp->{session}&option=deletemsg&mid=$mid\">".$globalp->{_DELETE}."</a>)"
                 ."</td></tr>");
    }
    $sthresult->finish();

    echo("</table></center><br>");
    $globalp->{CloseTable}();
    echo("<br>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>".$globalp->{_ADDMSG}."</b></font></center><br>");
    echo("<form action=\"admin.prc\" method=\"post\">"
             ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">"
             ."<br><b>".$globalp->{_MESSAGETITLE}.":</b><br>"
             ."<input type=\"text\" name=\"add_title\" value=\"\" size=\"50\" maxlength=\"100\"><br><br>"
             ."<b>".$globalp->{_MESSAGECONTENT}.":</b><br>"
             ."<textarea name=\"add_content\" rows=\"15\" wrap=\"virtual\" cols=\"60\"></textarea><br><br>"
             ."<input type=\"hidden\" name=\"add_mlanguage\" value=\"\">");

    $now = time();
    echo("<b>".$globalp->{_EXPIRATION}.":</b> <select name=\"add_expire\">"
             ."<option value=\"86400\" >1 ".$globalp->{_DAY}."</option>"
             ."<option value=\"172800\" >2 ".$globalp->{_DAYS}."</option>"
             ."<option value=\"432000\" >5 ".$globalp->{_DAYS}."</option>"
             ."<option value=\"1296000\" >15 ".$globalp->{_DAYS}."</option>"
             ."<option value=\"2592000\" >30 ".$globalp->{_DAYS}."</option>"
             ."<option value=\"0\" >".$globalp->{_UNLIMITED}."</option>"
             ."</select><br><br>"
             ."<b>Active?</b> <input type=\"radio\" name=\"add_active\" value=\"1\" checked>".$globalp->{_YES}." "
             ."<input type=\"radio\" name=\"add_active\" value=\"0\" >".$globalp->{_NO}.""
             ."<br><br><b>".$globalp->{_VIEWPRIV}."</b> <select name=\"add_view\">"
             ."<option value=\"1\" >".$globalp->{_MVALL}."</option>"
             ."<option value=\"2\" >".$globalp->{_MVUSERS}."</option>"
             ."<option value=\"3\" >".$globalp->{_MVANON}."</option>"
             ."<option value=\"4\" >".$globalp->{_MVADMIN}."</option>"
             ."</select><br><br>"
             ."<input type=\"hidden\" name=\"option\" value=\"addmsg\">"
             ."<input type=\"hidden\" name=\"add_mdate\" value=\"$now\">"
             ."<input type=\"submit\" value=\"".$globalp->{_ADDMSG}."\">"
             ."</form>");
    $globalp->{CloseTable}();
    $globalp->{sitefooter}();
}




sub editmsg
{

    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
	echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>".$globalp->{_MESSAGESADMIN}."</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

    $sthresult = $globalp->{dbh} -> prepare ("select mid, title, content, date, expire, active, view, mlanguage from ".$globalp->{table_prefix}."_message WHERE mid='$fdat{mid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_message";
    $sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_message";
    $sthresult -> bind_columns(undef, \$mid, \$title, \$content, \$mdate, \$expire, \$active, \$view, \$mlanguage);
    $datresult = $sthresult -> fetchrow_arrayref;
    $sthresult->finish();

    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>".$globalp->{_EDITMSG}."</b></font></center>");
    if( $active == 1 )
    {
        $asel1 = "checked";
        $asel2 = "";
    }
    elsif( $active == 0 )
    {
        $asel1 = "";
        $asel2 = "checked";
    }
    if( $view == 1 )
    {
        $sel1 = "selected";
        $sel2 = "";
        $sel3 = "";
        $sel4 = "";
    }
    elsif( $view == 2 )
    {
        $sel1 = "";
        $sel2 = "selected";
        $sel3 = "";
        $sel4 = "";
    }
    elsif( $view == 3 )
    {
        $sel1 = "";
        $sel2 = "";
        $sel3 = "selected";
        $sel4 = "";
    }
    elsif( $view == 4)
    {
        $sel1 = "";
        $sel2 = "";
        $sel3 = "";
        $sel4 = "selected";
    }
    if( $expire == 86400 )
    {
        $esel1 = "selected";
        $esel2 = "";
        $esel3 = "";
        $esel4 = "";
        $esel5 = "";
        $esel6 = "";
    }
    elsif( $expire == 172800 )
    {
        $esel1 = "";
        $esel2 = "selected";
        $esel3 = "";
        $esel4 = "";
        $esel5 = "";
        $esel6 = "";
    }
    elsif( $expire == 432000 )
    {
        $esel1 = "";
        $esel2 = "";
        $esel3 = "selected";
        $esel4 = "";
        $esel5 = "";
        $esel6 = "";
    }
    elsif( $expire == 1296000 )
    {
        $esel1 = "";
        $esel2 = "";
        $esel3 = "";
        $esel4 = "selected";
        $esel5 = "";
        $esel6 = "";
    }
    elsif( $expire == 2592000 )
    {
        $esel1 = "";
        $esel2 = "";
        $esel3 = "";
        $esel4 = "";
        $esel5 = "selected";
        $esel6 = "";
    }
    elsif( $expire == 0)
    {
        $esel1 = "";
        $esel2 = "";
        $esel3 = "";
        $esel4 = "";
        $esel5 = "";
        $esel6 = "selected";
    }
    echo("<form action=\"admin.prc\" method=\"post\">"
             ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">"
			 ."<input type=\"hidden\" name=\"lmid\" value=\"$mid\">"
             ."<br><b>ID:</b><br>"
             ."<input type=\"text\" name=\"mess_id\" value=\"$mid\" size=\"10\" maxlength=\"11\"><br><br>"
             ."<br><b>".$globalp->{_MESSAGETITLE}.":</b><br>"
             ."<input type=\"text\" name=\"title\" value=\"$title\" size=\"50\" maxlength=\"100\"><br><br>"
             ."<b>".$globalp->{_MESSAGECONTENT}.":</b><br>"
             ."<textarea name=\"content\" rows=\"15\" wrap=\"virtual\" cols=\"60\">$content</textarea><br><br>"
             ."<input type=\"hidden\" name=\"mlanguage\" value=\"\">"
             ."<b>".$globalp->{_EXPIRATION}.":</b> <select name=\"expire\">"
             ."<option name=\"expire\" value=\"86400\" $esel1>1 ".$globalp->{_DAY}."</option>"
             ."<option name=\"expire\" value=\"172800\" $esel2>2 ".$globalp->{_DAYS}."</option>"
             ."<option name=\"expire\" value=\"432000\" $esel3>5 ".$globalp->{_DAYS}."</option>"
             ."<option name=\"expire\" value=\"1296000\" $esel4>15 ".$globalp->{_DAYS}."</option>"
             ."<option name=\"expire\" value=\"2592000\" $esel5>30 ".$globalp->{_DAYS}."</option>"
             ."<option name=\"expire\" value=\"0\" $esel6>".$globalp->{_UNLIMITED}."</option>"
             ."</select><br><br>"
             ."<b>$globalp->{_ACTIVE}?</b> <input type=\"radio\" name=\"active\" value=\"1\" $asel1>".$globalp->{_YES}." "
             ."<input type=\"radio\" name=\"active\" value=\"0\" $asel2>".$globalp->{_NO}."");
    if( $active == 1 )
    {
        echo("<br><br><b>".$globalp->{_CHANGEDATE}."</b>"
                 ."<input type=\"radio\" name=\"chng_date\" value=\"1\">".$globalp->{_YES}." "
                 ."<input type=\"radio\" name=\"chng_date\" value=\"0\" checked>".$globalp->{_NO}."<br><br>");
    }
    elsif( $active == 0 )
    {
        echo("<br><font class=\"tiny\">".$globalp->{_IFYOUACTIVE}."</font><br><br>"
                 ."<input type=\"hidden\" name=\"chng_date\" value=\"1\">");
    }
    echo("<b>".$globalp->{_VIEWPRIV}."</b> <select name=\"view\">"
             ."<option name=\"view\" value=\"1\" $sel1>".$globalp->{_MVALL}."</option>"
             ."<option name=\"view\" value=\"2\" $sel2>".$globalp->{_MVANON}."</option>"
             ."<option name=\"view\" value=\"3\" $sel3>".$globalp->{_MVUSERS}."</option>"
             ."<option name=\"view\" value=\"4\" $sel4>".$globalp->{_MVADMIN}."</option>"
             ."</select><br><br>"
             ."<input type=\"hidden\" name=\"mdate\" value=\"$mdate\">"
             ."<input type=\"hidden\" name=\"mid\" value=\"$fdat{mid}\">"
             ."<input type=\"hidden\" name=\"option\" value=\"savemsg\">"
             ."<input type=\"submit\" value=\"".$globalp->{_SAVECHANGES}."\">"
             ."</form>");
    $globalp->{CloseTable}();
    $globalp->{sitefooter}();
}




sub savemsg
{
    $title = $globalp->{FixQuotes}($fdat{title});
    $content = $globalp->{FixQuotes}($fdat{content});
    if( $fdat{chng_date} == 1 ) { $newdate = time();}
    elsif( $fdat{chng_date} == 0 ) { $newdate = $fdat{mdate}; }
	
    $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_message set mid =$fdat{mess_id}, title='$title', content='$content', date='$newdate', expire='$fdat{expire}', active='$fdat{active}', view='$fdat{view}', mlanguage='$fdat{mlanguage}' WHERE mid='$fdat{lmid}'");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?session=$globalp->{session}&option=messages");
}



sub addmsg
{
    $title = $globalp->{FixQuotes}($fdat{add_title});
    $content = $globalp->{FixQuotes}($fdat{add_content});
    $globalp->{dbh}->do("insert into ".$globalp->{table_prefix}."_message values (NULL, '$title', '$content', '$fdat{add_mdate}', '$fdat{add_expire}', '$fdat{add_active}', '$fdat{add_view}', '$fdat{add_mlanguage}')");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?session=$globalp->{session}&option=messages");
}



sub deletemsg
{

    if( $fdat{ok} == 1 )
    {
        $result = $globalp->{dbh}->do("delete from ".$globalp->{table_prefix}."_message where mid=$fdat{mid}");
        echo("Message Can not be deleted") if( !$result );
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?session=$globalp->{session}&option=messages");
    }
    else
    {
        $globalp->{siteheader}(); $globalp->{theheader}();
        $globalp->{GraphicAdmin}();
		echo("</div>");
        $globalp->{OpenTable}();
        echo("<center><font size=\"4\"><b>".$globalp->{_MESSAGESADMIN}."</b></font></center>");
        $globalp->{CloseTable}();
        echo("<br>");
        $globalp->{OpenTable}();
        echo("<center>".$globalp->{_REMOVEMSG}."");
        echo("<br><br>[ <a href=\"admin.prc?session=$globalp->{session}&option=messages\">".$globalp->{_NO}."</a> | <a href=\"admin.prc?session=$globalp->{session}&option=deletemsg&amp;mid=$fdat{mid}&amp;ok=1\">".$globalp->{_YES}."</a> ]</center>");
        $globalp->{CloseTable}();
        $globalp->{sitefooter}();
    }
}



if( $fdat{option} eq "messages" ) { &messages(); }
elsif( $fdat{option} eq "editmsg" ) { &editmsg; }
elsif( $fdat{option} eq "addmsg" ) { &addmsg; }
elsif( $fdat{option} eq "deletemsg" ) { &deletemsg; }
elsif( $fdat{option} eq "savemsg" ) { &savemsg; }


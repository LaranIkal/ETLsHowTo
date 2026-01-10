if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else{ echo("Access denied"); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }

$sthadmauth = $globalp->{dbh} -> prepare ("select radminsuper from ".$globalp->{table_prefix}."_authors where aid='$globalp->{aid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
$sthadmauth -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
$sthadmauth -> bind_columns(undef, \$radminsuper);
$datadmauth = $sthadmauth -> fetchrow_arrayref;
$sthadmauth -> finish();

if( $radminsuper != 1 ) { echo("Access denied !!!!"); $globalp->{clean_exit}(); }


#*********************************************************
#* Admin/Authors Functions                               *
#********************************************************

sub displayadmins() {

	$globalp->{siteheader}(); $globalp->{theheader}();
  $globalp->{GraphicAdmin}();
	echo("</div>");
  $globalp->{OpenTable}();
  echo("<center><font class=\"title\"><b>".$globalp->{_AUTHORSADMIN}."</b></font></center>");
  $globalp->{CloseTable}();
  echo("<br>");
  $globalp->{OpenTable}();
  echo("<center><font class=\"option\"><b>".$globalp->{_EDITADMINS}."</b></font></center><br><table border=\"1\" align=\"center\">");

  $sthadmauth1 = $globalp->{dbh} -> prepare ("select aid, name, admlanguage from ".$globalp->{table_prefix}."_authors") or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
  $sthadmauth1 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
  $sthadmauth1 -> bind_columns(undef, \$a_aid, \$name, \$admlanguage);

  while( $datadmauth1 = $sthadmauth1 -> fetchrow_arrayref ) {
    echo("<tr><td align=\"center\">$a_aid</td>");
    if( $admlanguage eq "" ) { $admlanguage = "".$globalp->{_ALL}.""; }

    echo("<td align=\"center\">$admlanguage</td><td><a href=\"admin.prc?session=$globalp->{session}&option=modifyadmin&amp;chng_aid=$a_aid\">".$globalp->{_MODIFYINFO}."</a></td>");
    if( $name eq "root") {
      echo("<td>".$globalp->{_MAINACCOUNT}."</td></tr>");
    } else {
      echo("<td><a href=\"admin.prc?session=$globalp->{session}&option=deladmin&amp;del_aid=$a_aid\">".$globalp->{_DELAUTHOR}."</a></td></tr>");
    }
  }
  $sthadmauth1 -> finish();

  echo("</table><br><center><font class=\"tiny\">".$globalp->{_GODNOTDEL}."</font></center>");
  $globalp->{CloseTable}();
  echo("<br>");
  $globalp->{OpenTable}();
  echo("<center><font class=\"option\"><b>".$globalp->{_ADDAUTHOR}."</b></font></center>"
    ."<form action=\"admin.prc\" method=\"post\">"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">"
    ."<table border=\"0\">"
    ."<tr><td>".$globalp->{_NAME}.":</td>"
    ."<td colspan=\"3\"><input type=\"text\" name=\"add_name\" size=\"30\" maxlength=\"50\"> <font class=\"tiny\">".$globalp->{_REQUIREDNOCHANGE}."</font></td></tr>"
    ."<tr><td>".$globalp->{_NICKNAME}.":</td>"
    ."<td colspan=\"3\"><input type=\"text\" name=\"add_aid\" size=\"30\" maxlength=\"30\"> <font class=\"tiny\">".$globalp->{_REQUIRED}."</font></td></tr>"
    ."<tr><td>".$globalp->{_EMAIL}.":</td>"
    ."<td colspan=\"3\"><input type=\"text\" name=\"add_email\" size=\"30\" maxlength=\"60\"> <font class=\"tiny\">".$globalp->{_REQUIRED}."</font></td></tr>"
    ."<tr><td>".$globalp->{_URL}.":</td>"
    ."<td colspan=\"3\"><input type=\"text\" name=\"add_url\" size=\"30\" maxlength=\"60\"></td></tr>"
    ."<input type=\"hidden\" name=\"add_admlanguage\" value=\"\">"
    ."<tr><td>".$globalp->{_PERMISSIONS}.":</td>"
    ."<td><input type=\"checkbox\" name=\"add_radminarticle\" value=\"1\"> ".$globalp->{_ARTICLES}."</td>"
    ."<td><input type=\"checkbox\" name=\"add_radmintopic\" value=\"1\"> ".$globalp->{_TOPICS}."</td>"
    ."<td><input type=\"checkbox\" name=\"add_radminuser\" value=\"1\"> ".$globalp->{_USERS}."</td>"
    ."</tr><tr><td>&nbsp;</td>"
    ."<td><input type=\"checkbox\" name=\"add_radminsurvey\" value=\"1\"> ".$globalp->{_SURVEYS}."</td>"
    ."<td><input type=\"checkbox\" name=\"add_radminsection\" value=\"1\"> ".$globalp->{_SECTIONS}."</td>"
    ."<td><input type=\"checkbox\" name=\"add_radminlink\" value=\"1\"> ".$globalp->{_WEBLINKS}."</td>"
    ."</tr><tr><td>&nbsp;</td>"
    ."<td><input type=\"checkbox\" name=\"add_radminephem\" value=\"1\"> ".$globalp->{_EPHEMERIDS}."</td>"
    ."<td><input type=\"checkbox\" name=\"add_radminfaq\" value=\"1\"> ".$globalp->{_FAQ}."</td>"
    ."<td><input type=\"checkbox\" name=\"add_radmindownload\" value=\"1\"> ".$globalp->{_DOWNLOAD}."</td>"
    ."</tr><tr><td>&nbsp;</td>"
    ."<td><input type=\"checkbox\" name=\"add_radminreviews\" value=\"1\"> ".$globalp->{_REVIEWS}."</td>"
    ."<td><input type=\"checkbox\" name=\"add_radminnewsletter\" value=\"1\"> ".$globalp->{_NEWSLETTER}."</td>"
    ."<td><input type=\"checkbox\" name=\"add_radminforum\" value=\"1\"> ".$globalp->{_BBFORUM}."</td>"
    ."</tr><tr><td>&nbsp;</td>"
    ."<td><input type=\"checkbox\" name=\"add_radmincontent\" value=\"1\"> ".$globalp->{_CONTENT}."</td>"
    ."<td><input type=\"checkbox\" name=\"add_radminency\" value=\"1\"> ".$globalp->{_ENCYCLOPEDIA}."</td>"
    ."<td><input type=\"checkbox\" name=\"chng_radminworkflow\" value=\"1\" $sel16> ".$globalp->{_WORKFLOW}."</td>"
    ."</tr><tr><td>&nbsp;</td>"
    ."<td><input type=\"checkbox\" name=\"add_radminsuper\" value=\"1\"> <b>".$globalp->{_SUPERUSER}."</b></td>"
    ."</tr>"
    ."<tr><td>&nbsp;</td><td colspan=\"3\"><font class=\"tiny\"><i>".$globalp->{_SUPERWARNING}."</i></font></td></tr>"
    ."<tr><td>".$globalp->{_PASSWORD}."</td>"
    ."<td colspan=\"3\"><input type=\"password\" name=\"add_pwd\" size=\"12\" maxlength=\"12\"> <font class=\"tiny\">".$globalp->{_REQUIRED}."</font></td></tr>"
    ."<input type=\"hidden\" name=\"option\" value=\"AddAuthor\">"
    ."<tr><td><input type=\"submit\" value=\"".$globalp->{_ADDAUTHOR2}."\"></td></tr>"
    ."</table></form>"
  );
  $globalp->{CloseTable}();
	$globalp->{sitefooter}();
}



sub modifyadmin {

	$globalp->{siteheader}(); $globalp->{theheader}();
  $globalp->{GraphicAdmin}();
	echo("</div>");
  $globalp->{OpenTable}();
  echo("<center><font class=\"title\"><b>".$globalp->{_AUTHORSADMIN}."</b></font></center>");
  $globalp->{CloseTable}();
  echo("<br>");
  $globalp->{OpenTable}();
  echo("<center><font class=\"option\"><b>".$globalp->{_MODIFYINFO}."</b></font></center><br><br>");

  $adm_aid = $fdat{chng_aid};
  $sthadmauth2 = $globalp->{dbh} -> prepare ("select aid, name, url, email, pwd, radminarticle,radmintopic,radminuser,radminsurvey,radminsection,radminlink,radminephem,radminfaq,radmindownload,radminreviews,radminnewsletter,radminforum,radmincontent,radminency,radminworkflow,radminsuper,admlanguage from ".$globalp->{table_prefix}."_authors where aid='$fdat{chng_aid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
  $sthadmauth2 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
  $sthadmauth2 -> bind_columns(undef, \$chng_aid, \$chng_name, \$chng_url, \$chng_email, \$chng_pwd, \$chng_radminarticle, \$chng_radmintopic, \$chng_radminuser, \$chng_radminsurvey, \$chng_radminsection, \$chng_radminlink, \$chng_radminephem, \$chng_radminfaq, \$chng_radmindownload, \$chng_radminreviews, \$chng_radminnewsletter, \$chng_radminforum, \$chng_radmincontent, \$chng_radminency, \$chng_radminworkflow, \$chng_radminsuper, \$chng_admlanguage);
  $datadmauth2 = $sthadmauth2 -> fetchrow_arrayref;
  $sthadmauth2 -> finish();

  $aid = $chng_aid;
  echo("<form action=\"admin.prc\" method=\"post\">"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">"
    ."<table border=\"0\">"
    ."<tr><td>".$globalp->{_NAME}.":</td>"
    ."<td colspan=\"3\"><b>$chng_name</b> <input type=\"hidden\" name=\"chng_name\" value=\"$chng_name\"></td></tr>"
    ."<tr><td>".$globalp->{_NICKNAME}.":</td>"
    ."<td colspan=\"3\"><input type=\"text\" name=\"chng_aid\" value=\"$chng_aid\"> <font class=\"tiny\">".$globalp->{_REQUIRED}."</font></td></tr>"
    ."<tr><td>".$globalp->{_EMAIL}.":</td>"
    ."<td colspan=\"3\"><input type=\"text\" name=\"chng_email\" value=\"$chng_email\" size=\"30\" maxlength=\"60\"> <font class=\"tiny\">".$globalp->{_REQUIRED}."</font></td></tr>"
    ."<tr><td>".$globalp->{_URL}.":</td>"
    ."<td colspan=\"3\"><input type=\"text\" name=\"chng_url\" value=\"$chng_url\" size=\"30\" maxlength=\"60\"></td></tr>"
    ."<input type=\"hidden\" name=\"chng_admlanguage\" value=\"\">"
    ."<tr><td>".$globalp->{_PERMISSIONS}.":</td>"
  );

  if( $chng_radminarticle == 1 ) { $sel1 = "checked"; } else { $sel1 = ""; }

  if( $chng_radmintopic == 1 ) { $sel2 = "checked"; } else { $sel2 = ""; }

  if( $chng_radminuser == 1 ) { $sel3 = "checked"; } else { $sel3 = ""; }

  if( $chng_radminsurvey == 1 ) { $sel4 = "checked"; } else { $sel4 = ""; }

  if( $chng_radminsection == 1 ) { $sel5 = "checked"; } else { $sel5 = ""; }
  
  if( $chng_radminlink == 1 ) { $sel6 = "checked"; } else { $sel6 = ""; }

  if( $chng_radminephem == 1 ) { $sel7 = "checked"; } else { $sel7 = ""; }

  if( $chng_radminfaq == 1 ) { $sel8 = "checked"; } else { $sel8 = ""; }

  if( $chng_radmindownload == 1 ) { $sel9 = "checked"; } else { $sel9 = ""; }

  if( $chng_radminreviews == 1 ) { $sel10 = "checked";
    } else {
        $sel10 = "";
    }
    if( $chng_radminnewsletter == 1 ) {
        $sel11 = "checked";
    } else {
        $sel11 = "";
    }
    if( $chng_radminforum == 1 ) {
        $sel12 = "checked";
    } else {
        $sel12 = "";
    }
    if( $chng_radmincontent == 1 ) {
        $sel13 = "checked";
    } else {
        $sel13 = "";
    }
    if( $chng_radminency == 1 ) {
        $sel14 = "checked";
    } else {
        $sel14 = "";
    }
    if( $chng_radminsuper == 1 ) {
        $sel15 = "checked";
    } else {
        $sel15 = "";
    }

    if( $chng_radminworkflow == 1 ) {
        $sel16 = "checked";
    } else {
        $sel16 = "";
    }


    echo("<td><input type=\"checkbox\" name=\"chng_radminuser\" value=\"1\" $sel3> ".$globalp->{_USERS}."</td>"
             ."</tr><tr><td>&nbsp;</td>"
             #."<td><input type=\"checkbox\" name=\"chng_radminsection\" value=\"1\" $sel5> ".$globalp->{_SECTIONS}."</td>"
             ."<td><input type=\"checkbox\" name=\"chng_radminlink\" value=\"1\" $sel6> ".$globalp->{_WEBLINKS}."</td>"
             ."</tr><tr><td>&nbsp;</td>"
             ."<td><input type=\"checkbox\" name=\"chng_radmincontent\" value=\"1\" $sel13> ".$globalp->{_CONTENT}."</td>"
             ."</tr><tr><td>&nbsp;</td>"
             ."<td><input type=\"checkbox\" name=\"chng_radminsuper\" value=\"1\" $sel15> <b>".$globalp->{_SUPERUSER}."</b></td>"
             ."</tr><tr><td>&nbsp;</td>"
             ."<td colspan=\"3\"><font class=\"tiny\"><i>".$globalp->{_SUPERWARNING}."</i></font></td></tr>"
             ."<tr><td>".$globalp->{_PASSWORD}.":</td>"
             ."<td colspan=\"3\"><input type=\"password\" name=\"chng_pwd\" size=\"12\" maxlength=\"12\"></td></tr>"
             ."<tr><td>".$globalp->{_RETYPEPASSWD}.":</td>"
             ."<td colspan=\"3\"><input type=\"password\" name=\"chng_pwd2\" size=\"12\" maxlength=\"12\"> <font class=\"tiny\">".$globalp->{_FORCHANGES}."</font></td></tr>"
             ."<input type=\"hidden\" name=\"adm_aid\" value=\"$adm_aid\">"
             ."<input type=\"hidden\" name=\"option\" value=\"UpdateAuthor\">"
             ."<tr><td><input type=\"submit\" value=\"".$globalp->{_SAVE}."\"> ".$globalp->{_GOBACK}.""
             ."</td></tr></table></form>");
    $globalp->{CloseTable}();
	$globalp->{sitefooter}();
}




sub updateadmin
{


    if (!defined($fdat{chng_aid}) && !defined($fdat{chng_name}) && !defined($fdat{chng_email}) )
    {
        &redirect_url_to("admin.prc?session=$globalp->{session}&option=mod_authors");
    }
    if( $fdat{chng_pwd2} ne "" )
    {
        if( $fdat{chng_pwd} ne $fdat{chng_pwd2} )
        {
            $globalp->{GraphicAdmin}();
			echo("</div>");
            $globalp->{OpenTable}();
            echo("".$globalp->{_PASSWDNOMATCH}."<br><br>"
                     ."<center>".$globalp->{_GOBACK}."</center>");
            $globalp->{CloseTable}();
            exit;
        }
        $chng_pwd = md5_hex($fdat{chng_pwd});
        if( $fdat{chng_radminsuper} == 1 )
        {
            $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_authors set aid='$fdat{chng_aid}', email='$fdat{chng_email}', url='$fdat{chng_url}', radminarticle='0', radmintopic='0', radminuser='0', radminsurvey='0', radminsection='0', radminlink='0', radminephem='0', radminfaq='0', radmindownload='0', radminreviews='0', radminnewsletter='0', radminforum='0', radmincontent='0', radminency='0', radminsuper='$fdat{chng_radminsuper}', pwd='$chng_pwd', admlanguage='$fdat{chng_admlanguage}' where name='$fdat{chng_name}'");
            &redirect_url_to("admin.prc?session=$globalp->{session}&option=mod_authors");
        }
        else
        {
            $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_authors set aid='$fdat{chng_aid}', email='$fdat{chng_email}', url='$fdat{chng_url}', radminarticle='$fdat{chng_radminarticle}', radmintopic='$fdat{chng_radmintopic}', radminuser='$fdat{chng_radminuser}', radminsurvey='$fdat{chng_radminsurvey}', radminsection='$fdat{chng_radminsection}', radminlink='$fdat{chng_radminlink}', radminephem='$fdat{chng_radminephem}', radminfaq='$fdat{chng_radminfaq}', radmindownload='$fdat{chng_radmindownload}', radminreviews='$fdat{chng_radminreviews}', radminnewsletter='$fdat{chng_radminnewsletter}', radminforum='$fdat{chng_radminforum}', radmincontent='$fdat{chng_radmincontent}', radminency='$fdat{chng_radminency}', radminworkflow='$fdat{chng_radminworkflow}', radminsuper='0', pwd='$chng_pwd', admlanguage='$fdat{chng_admlanguage}' where name='$fdat{chng_name}'");
            &redirect_url_to("admin.prc?session=$globalp->{session}&option=mod_authors");
        }
    }
    else
    {
        if( $fdat{chng_radminsuper} == 1)
        {
            $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_authors set aid='$fdat{chng_aid}', email='$fdat{chng_email}', url='$fdat{chng_url}', radminarticle='0', radmintopic='0', radminuser='0', radminsurvey='0', radminsection='0', radminlink='0', radminephem='0', radminfaq='0', radmindownload='0', radminreviews='0', radminnewsletter='0', radminforum='$fdat{chng_radminforum}', radmincontent='$fdat{chng_radmincontent}', radminency='$fdat{chng_radminency}', radminsuper='$fdat{chng_radminsuper}', admlanguage='$fdat{chng_admlanguage}' where name='$fdat{chng_name}'");
            &redirect_url_to("admin.prc?session=$globalp->{session}&option=mod_authors");
        }
        else
        {
            $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_authors set aid='$fdat{chng_aid}', email='$fdat{chng_email}', url='$fdat{chng_url}', radminarticle='$fdat{chng_radminarticle}', radmintopic='$fdat{chng_radmintopic}', radminuser='$fdat{chng_radminuser}', radminsurvey='$fdat{chng_radminsurvey}', radminsection='$fdat{chng_radminsection}', radminlink='$fdat{chng_radminlink}', radminephem='$fdat{chng_radminephem}', radminfaq='$fdat{chng_radminfaq}', radmindownload='$fdat{chng_radmindownload}', radminreviews='$fdat{chng_radminreviews}', radminnewsletter='$fdat{chng_radminnewsletter}', radminforum='$fdat{chng_radminforum}', radmincontent='$fdat{chng_radmincontent}', radminency='$fdat{chng_radminency}', radminworkflow='$fdat{chng_radminworkflow}', radminsuper='0', admlanguage='$fdat{chng_admlanguage}' where name='$fdat{chng_name}'");
            &redirect_url_to("admin.prc?session=$globalp->{session}&option=mod_authors");
        }
    }
    if( $fdat{adm_aid} ne $fdat{chng_aid} )
    {
        $sthadmupdt1 = $globalp->{dbh} -> prepare ("select sid, aid, informant from ".$globalp->{table_prefix}."_stories where aid='$fdat{adm_aid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_stories";
        $sthadmupdt1 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_stories";
        $sthadmupdt1 -> bind_columns(undef, \$sid, \$old_aid, \$informant);

        while( $datadmupdt1 = $sthadmupdt1 -> fetchrow_arrayref )
        {
            if( $old_aid eq $informant )
            {
                $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_stories set informant='$fdat{chng_aid}' where sid='$sid'");
            }

            $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_stories set aid='$fdat{chng_aid}' WHERE sid='$sid'");
        }
        $sthadmupdt1 -> finish();
    }
}



sub deladmin2
{

    $sthadmdel1 = $globalp->{dbh} -> prepare ("select name, radminarticle, radminsuper from ".$globalp->{table_prefix}."_authors where aid='$fdat{del_aid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
    $sthadmdel1 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
    $sthadmdel1 -> bind_columns(undef, \$name, \$radminarticle, \$radminsuper);
    $datadmdel1 = $sthadmdel1 -> fetchrow_arrayref;
    $sthadmdel1 -> finish();

    if( ( $radminarticle == 1 || $radminsuper == 1 ) &&  ( $name ne "root" ) )
    {
        $sthadmdel2 = $globalp->{dbh} -> prepare ("select sid from ".$globalp->{table_prefix}."_stories where aid='$fdat{del_aid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_stories";
        $sthadmdel2 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_stories";
        $sthadmdel2 -> bind_columns(undef, \$sid);
        $datadmdel2 = $sthadmdel2 -> fetchrow_arrayref;
        $sthadmdel2 -> finish();

        if( $sid ne "")
        {
			$globalp->{siteheader}(); $globalp->{theheader}();
            $globalp->{GraphicAdmin}();
			echo("</div>");
            $globalp->{OpenTable}();
            echo("<center><font class=\"title\"><b>".$globalp->{_AUTHORSADMIN}."</b></font></center>");
            $globalp->{CloseTable}();
            echo("<br>");
            $globalp->{OpenTable}();
            echo("<center><font class=\"option\"><b>".$globalp->{_PUBLISHEDSTORIES}."</b></font><br><br>"
                     ."".$globalp->{_SELECTNEWADMIN}.":<br><br>"
                     ."<form action=\"admin.prc\" method=\"post\"><select name=\"newaid\">"
                     ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">");

            $sthadmdel3 = $globalp->{dbh} -> prepare ("select aid from ".$globalp->{table_prefix}."_authors where aid!='$fdat{del_aid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
            $sthadmdel3 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
            $sthadmdel3 -> bind_columns(undef, \$oaid);

            while( $datadmdel3 = $sthadmdel3 -> fetchrow_arrayreflist )
            {
                echo("<option name=\"newaid\" value=\"$oaid\">$oaid</option>");
            }
            $sthadmdel3 -> finish();

            echo("</select><input type=\"hidden\" name=\"del_aid\" value=\"$del_aid\">"
                     ."<input type=\"hidden\" name=\"option\" value=\"assignstories\">"
                     ."<input type=\"submit\" value=\"".$globalp->{_OK}."\">"
                     ."</form>");
            $globalp->{CloseTable}();
			$globalp->{sitefooter}();
            return;
        }
    }
    if( $name ne "root" )
    {
        $globalp->{dbh}->do("delete from ".$globalp->{table_prefix}."_authors where aid='$fdat{del_aid}'");
    }
    &redirect_url_to("admin.prc?session=$globalp->{session}&option=deladminconf&del_aid=$del_aid");
}



    use Digest::MD5  qw(md5_hex);

    if( $fdat{option} eq "mod_authors" ) { &displayadmins(); }
    elsif( $fdat{option} eq "modifyadmin" ) { &modifyadmin(); }
    elsif( $fdat{option} eq "UpdateAuthor" ) { &updateadmin(); }
    elsif( $fdat{option} eq "AddAuthor" )
    {
        if( !defined($fdat{add_aid}) && !defined($fdat{add_name}) && !defined($fdat{add_email}) && !defined($fdat{add_pwd}) )
        {
			$globalp->{siteheader}(); $globalp->{theheader}();
            $globalp->{GraphicAdmin}();
			echo("</div>");
            $globalp->{OpenTable}();
            echo("<center><font class=\"title\"><b>".$globalp->{_AUTHORSADMIN}."</b></font></center>");
            $globalp->{CloseTable}();
            echo("<br>");
            $globalp->{OpenTable}();
            echo("<center><font class=\"option\"><b>".$globalp->{_CREATIONERROR}."</b></font><br><br>"
                     ."".$globalp->{_COMPLETEFIELDS}."<br><br>"
                     ."".$globalp->{_GOBACK}."</center>");
            $globalp->{CloseTable}();
			$globalp->{sitefooter}();
            return;
        }
        $add_pwd = md5_hex($fdat{add_pwd});
        $result = $globalp->{dbh}->do("insert into ".$globalp->{table_prefix}."_authors values ('$fdat{add_aid}', '$fdat{add_name}', '$fdat{add_url}', '$fdat{add_email}', '$add_pwd', '0', '$fdat{add_radminarticle}','$fdat{add_radmintopic}','$fdat{add_radminuser}','$fdat{add_radminsurvey}','$fdat{add_radminsection}','$fdat{add_radminlink}','$fdat{add_radminephem}','$fdat{add_radminfaq}','$fdat{add_radmindownload}','$fdat{add_radminreviews}','$fdat{add_radminnewsletter}','$fdat{add_radminforum}','$fdat{add_radmincontent}','$fdat{add_radminency}','$fdat{chng_radminworkflow}','$fdat{add_radminsuper}','$fdat{add_admlanguage}')");

        if( !$result ) { return; }
        &redirect_url_to("admin.prc?session=$globalp->{session}&option=mod_authors");
    }
    elsif( $fdat{option} eq "deladmin" )
    {
		$globalp->{siteheader}(); $globalp->{theheader}();
        $globalp->{GraphicAdmin}();
		echo("</div>");
        $globalp->{OpenTable}();
        echo("<center><font class=\"title\"><b>".$globalp->{_AUTHORSADMIN}."</b></font></center>");
        $globalp->{CloseTable}();
        echo("<br>");
        $globalp->{OpenTable}();
        echo("<center><font class=\"option\"><b>".$globalp->{_AUTHORDEL}."</b></font><br><br>"
                 ."".$globalp->{_AUTHORDELSURE}." <i>$fdat{del_aid}</i>?<br><br>"
                 ."[ <a href=\"admin.prc?session=$globalp->{session}&option=deladmin2&amp;del_aid=$fdat{del_aid}\">".$globalp->{_YES}."</a> | <a href=\"admin.prc?session=$globalp->{session}&option=mod_authors\">".$globalp->{_NO}."</a> ]");
        $globalp->{CloseTable}();
		$globalp->{sitefooter}();
    }
    elsif( $fdat{option} eq "deladmin2" ){ &deladmin2(); }
    elsif( $fdat{option} eq "assignstories" )
    {
        $sthadmasgn = $globalp->{dbh} -> prepare ("select sid from ".$globalp->{table_prefix}."_stories where aid='$fdat{del_aid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_stories";
        $sthadmasgn -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_stories";
        $sthadmasgn -> bind_columns(undef, \$sid);

        while( $datadmasgn = $sthadmasgn -> fetchrow_arrayreflist )
        {
            $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_stories set aid='$fdat{newaid}', informant='$fdat{newaid}' where aid='$fdat{del_aid}'");
        }
        $sthadmasgn->finish();
    }
    elsif( $fdat{option} eq "deladminconf" )
    {
        $globalp->{dbh}->do("delete from ".$globalp->{table_prefix}."_authors where aid='$fdat{del_aid}'");
        &redirect_url_to("admin.prc?session=$globalp->{session}&option=mod_authors");
    }




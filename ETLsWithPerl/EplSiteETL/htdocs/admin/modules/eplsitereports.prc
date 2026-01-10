if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else{ echo("Access denied"); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }

	my $AdminSelect = "SELECT radminworkflow, radminsuper FROM ";
	$AdminSelect .= $globalp->{table_prefix}."_authors WHERE aid='$globalp->{aid}'";
	
    $sthadmauth = $globalp->{dbh} -> prepare ($AdminSelect) 
	or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
    $sthadmauth -> execute  
	or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
    $sthadmauth -> bind_columns(undef, \$radminworkflow,\$radminsuper);
    $datadmauth = $sthadmauth -> fetchrow_arrayref;
    $sthadmauth->finish();

if( $radminsuper != 1 )
{
    if( $radminworkflow != 1 )
    {
        echo("Access denied!!!!"); $globalp->{clean_exit}();
    }
}

use Digest::MD5 qw(md5_hex);

#*********************************************************
#* WorkFlow Manager Functions, Main WorkFlow Manager Routines
#*********************************************************

sub EplSiteReportsManager()
{

    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
	echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite Reports Manager</b></font></center>");
    $globalp->{CloseTable}();
	
    echo("<br>");

    $globalp->{OpenTable}();
    echo("<table border=\"0\" >");
    echo("<form action=\"admin.prc\" method=\"POST\">\n"
	."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
	."<input type=\"hidden\" name=\"option\" value=\"reports_user_save\">\n"
	."<tr align=\"left\"><td>".$globalp->{_WFRESNAME}.":</td><td> <input type=\"text\""
	." name=\"rname\" size=\"50\" maxlength=\"100\"> <font color=\"red\">*</font></td></tr>\n"
	."<tr align=\"left\"><td>".$globalp->{_WFRESEXT}.":</td><td> <input type=\"text\""
	." name=\"rext\" size=\"25\" maxlength=\"50\"></td></tr>\n"
	."<tr align=\"left\"><td>".$globalp->{_WFRESMAIL}.":</td><td> <input type=\"text\""
	." name=\"rmail\" size=\"50\" maxlength=\"100\"> <font color=\"red\">*</font></td></tr>\n"
	."<tr align=\"left\"><td>".$globalp->{_WFRESLOGIN}.":</td><td> <input type=\"text\""
	." name=\"rlogin\" size=\"20\" maxlength=\"20\"> <font color=\"red\">*</font></td></tr>\n"
	."<tr align=\"left\"><td>".$globalp->{_WFREPSW}.":</td><td> <input type=\"password\""
	." name=\"rpsw\" size=\"20\" maxlength=\"50\"> <font color=\"red\">*</font></td></tr>\n"
	."<tr align=\"left\"><td>".$globalp->{_RETYPEPASSWD}.":</td><td> <input type=\"password\""
	." name=\"rtpsw\" size=\"20\" maxlength=\"50\"> <font color=\"red\">*</font></td></tr>\n"
	."<tr align=\"left\"><td><input name=\"submit\" value= \"Add User\" type=\"submit\""
	."></td><td><td>&nbsp;</td></tr></table>\n"
	."</form><br>\n");
	echo("<table border=\"0\" ><tr align=\"left\"><td>");
    echo("<form action=\"admin.prc\" method=\"POST\">\n"
	."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
	."".$globalp->{_WFRESID}.": <input type=\"text\" name=\"ID\" size=\"5\" maxlength=\"10\">\n"
	." <input name=\"option\" value= \"Reports Edit User\" type=\"submit\"> \n"
	." <input name=\"option\" value= \"Reports User Delete\" type=\"submit\">\n"
	."</form>\n ");
	echo("</td></tr></table>");

    echo("<p align=\"left\"><a href=\"#\" onClick=\"window.open('admin.prc?session=$globalp->{session}"
	."&amp;option=reports_show_persons','Migration Validation User','width=500,height=400"
	.", scrollbars=yes, fullscreen=-1');return;\" >".$globalp->{_SHOWUSERS}."</a></p>\n");

    $globalp->{CloseTable}();
    echo("<br>");

    $globalp->{OpenTable}();
    echo("<table border=\"0\" >");
    echo("<form action=\"admin.prc\" method=\"POST\">\n"
	."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
	."<input type=\"hidden\" name=\"option\" value=\"report_group_save\">\n"
	."<input type=\"hidden\" name=\"ReportGroupID\" value=\"\">\n"
	."<tr align=\"left\"><td>Report Group Description:</td><td> <input type=\"text\""
	." name=\"ReportGroupDescription\" size=\"50\" maxlength=\"100\"></td></tr>\n"
	."<tr align=\"left\"><td><input name=\"submit\" value= \"Add Report Group\" "
	."type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
	."</form><br>\n");
			 
	echo("<table border=\"0\" ><tr align=\"left\"><td>");
    echo("<form action=\"admin.prc\" method=\"POST\">\n"
	."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
	."<select name=\"ReportGroupID\">"
	."<option selected value=\"\">Select Report Group To Edit/Delete</option>\n");
			 
	$selectquery = "SELECT ReportGroupID, ReportGroupDescription FROM ";
	$selectquery .=$globalp->{table_prefix}."_report_groups";

	$resulti = $globalp->{dbh} -> prepare ($selectquery)  
	or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_report_groups: $selectquery";
	$resulti -> execute  or die "Cannot SELECT from offices and access tables";
	$resulti -> bind_columns(undef, \$ReportGroupID, \$ReportGroupDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref )
	{
		echo("<option value=\"$ReportGroupID\">$ReportGroupDescription</option>\n");
	}
	$resulti->finish();
		
	echo("</select>\n"
	." <input name=\"option\" value= \"Edit Report Group\" type=\"submit\">\n"
	." <input name=\"option\" value= \"Delete Report Group\" type=\"submit\">\n"
	."</form>\n ");
	echo("</td></tr></table>");

    $globalp->{CloseTable}();
    
    echo("<br>");

    $globalp->{OpenTable}();
    echo("<table border=\"0\" >");
    echo("<form action=\"admin.prc\" method=\"POST\">\n"
	."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
	."<input type=\"hidden\" name=\"option\" value=\"eplsite_report_save\">\n"
	."<input type=\"hidden\" name=\"ReportID\" value=\"\">\n"
	."<tr align=\"left\"><td>Report Group:</td>"
	."<td><select name=\"ReportGroupID\">"
	."<option selected value=\"\">Select Report Group</option>\n");
			 
	$selectquery = "SELECT ReportGroupID, ReportGroupDescription FROM ";
	$selectquery .= $globalp->{table_prefix}."_report_groups ORDER BY ReportGroupDescription";

	$resulti = $globalp->{dbh}-> prepare ($selectquery)  
	or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_report_groups: $selectquery";
	$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_report_groups";
	$resulti -> bind_columns(undef, \$ReportGroupID, \$ReportGroupDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref )
	{
		echo("<option value=\"$ReportGroupID\">$ReportGroupDescription</option>\n");
	}
	$resulti->finish();
	
	echo("</select></td></tr>\n"
	."<tr align=\"left\"><td>Report Name:</td><td> <input type=\"text\" "
	."name=\"rscript\" size=\"50\" maxlength=\"100\"></td></tr>\n"
	."<tr align=\"left\"><td>Report Description:</td><td> <input type=\"text\""
	." name=\"rdescription\" size=\"50\" maxlength=\"100\"></td></tr>\n"
	."<tr align=\"left\"><td><input name=\"submit\" value= \"Add Report\" "
	."type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
	."</form><br>\n");

	echo("<table border=\"0\" ><tr align=\"left\"><td>");
    echo("<form action=\"admin.prc\" method=\"POST\">\n"
	."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
	."<select name=\"ReportID\">"
	."<option selected value=\"\">Select Report To Edit/Delete</option>\n");
			 
	$selectquery = "SELECT ReportID, ReportDescription FROM ";
	$selectquery .= $globalp->{table_prefix}."_reports_definition";

	$resulti = $globalp->{dbh} -> prepare ($selectquery) 
	or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_reports_definition: $selectquery";
	$resulti -> execute  or die "Cannot SELECT from offices and access tables";
	$resulti -> bind_columns(undef, \$ReportID, \$ReportDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref )
	{
		echo("<option value=\"$ReportID\">$ReportDescription</option>\n");
	}
	$resulti->finish();
		
	echo("</select>\n"
	." <input name=\"option\" value= \"Edit Report Perl Script\" type=\"submit\">\n"
	." <input name=\"option\" value= \"EplSite Report Delete\" type=\"submit\">\n"
	."</form>\n ");
	echo("</td></tr></table>");

    $globalp->{CloseTable}();

    echo("<br>");

    $globalp->{OpenTable}();
    echo("<table border=\"0\" >");
    echo("<form action=\"admin.prc\" method=\"POST\">\n"
	."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
	."<input type=\"hidden\" name=\"option\" value=\"eplsite_javascript_save\">\n"
	."<input type=\"hidden\" name=\"JavaScriptID\" value=\"\">\n"
	."<tr align=\"left\"><td>JavaScript Name:</td><td> <input type=\"text\" "
	."name=\"JavaScriptName\" size=\"50\" maxlength=\"100\"></td></tr>\n"
	."<tr align=\"left\"><td>JavaScript Description:</td><td> <input type=\"text\""
	." name=\"JavaScriptDescription\" size=\"50\" maxlength=\"100\"></td></tr>\n"
	."<tr align=\"left\"><td><input name=\"submit\" value= \"Add JavaScript\" "
	."type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
	."</form><br>\n");

	echo("<table border=\"0\" ><tr align=\"left\"><td>");
    echo("<form action=\"admin.prc\" method=\"POST\">\n"
	."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
	."<select name=\"JavaScriptID\">"
	."<option selected value=\"\">Select JavaScript To Edit/Delete</option>\n");
			 
	$selectquery = "SELECT JavaScriptID, JavaScriptName, JavaScriptDescription FROM ";
	$selectquery .= $globalp->{table_prefix}."_etl_javascriptlibs";

	$resulti = $globalp->{dbh} -> prepare ($selectquery) 
	or die "Cannot prepare query: $selectquery";
	$resulti -> execute  or die "Cannot execute query:$selectquery";
	$resulti -> bind_columns(undef, \$JavaScriptID, \$JavaScriptName, \$JavaScriptDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref )
	{
		echo("<option value=\"$JavaScriptID\">$JavaScriptName - $JavaScriptDescription</option>\n");
	}
	$resulti->finish();
		
	echo("</select>\n"
	." <input name=\"option\" value= \"Edit JavaScript\" type=\"submit\">\n"
	." <input name=\"option\" value= \"Delete JavaScript\" type=\"submit\">\n"
	."</form>\n ");
	echo("</td></tr></table>");

    $globalp->{CloseTable}();

		
    $globalp->{sitefooter}();
    $globalp->{clean_exit}();
}



sub reports_user_edit()
{

    if( $fdat{ID} eq "" )
    {
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?option=EplSiteReportsManager&amp;session=$globalp->{session}");
    }
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
	echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite Reports Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

    $sthresult3 = $globalp->{dbh} -> prepare ("select ResourceName, Extension, Email, Login from ".$globalp->{table_prefix}."_reports_users where ResourceID=$fdat{ID}") 
	or die "Cannot SELECT from ".$globalp->{table_prefix}."_reports_users";
    $sthresult3 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_reports_users";
    $sthresult3 -> bind_columns(undef, \$ResourceName, \$Extension, \$Email, \$Login);
    $datresult3 = $sthresult3 -> fetchrow_arrayref;
    $sthresult3->finish();



    $globalp->{OpenTable}();
    echo("<center><b>Edit User</b></center><br><br>");
    echo("<table border=\"0\" >");
    echo("<form action=\"admin.prc\" method=\"POST\">\n"
	."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
	."<input type=\"hidden\" name=\"option\" value=\"reports_user_save\">\n"
	."<input type=\"hidden\" name=\"ID\" value=\"$fdat{ID}\">\n"
	."<tr align=\"left\"><td>".$globalp->{_WFRESNAME}.":</td><td> <input type=\"text\" name=\"rname\" value=\"$ResourceName\"size=\"50\" maxlength=\"100\"> </td></tr>\n"
	."<tr align=\"left\"><td>".$globalp->{_WFRESEXT}.":</td><td> <input type=\"text\" name=\"rext\" value=\"$Extension\" size=\"25\" maxlength=\"50\"></td></tr>\n"
	."<tr align=\"left\"><td>".$globalp->{_WFRESMAIL}.":</td><td> <input type=\"text\" name=\"rmail\" value=\"$Email\" size=\"50\" maxlength=\"100\"> </td></tr>\n"
	."<tr align=\"left\"><td>".$globalp->{_WFRESLOGIN}.":</td><td> <input type=\"text\" name=\"rlogin\" value=\"$Login\" size=\"20\" maxlength=\"20\"> </td></tr>\n"
	."<tr align=\"left\"><td>".$globalp->{_WFREPSW}.":</td><td> <input type=\"password\" name=\"rpsw\" size=\"20\" maxlength=\"50\"> </td></tr>\n"
	."<tr align=\"left\"><td>".$globalp->{_RETYPEPASSWD}.":</td><td> <input type=\"password\" name=\"rtpsw\" size=\"20\" maxlength=\"50\"> </td></tr>\n"
	."<tr align=\"left\"><td><input name=\"submit\" value= \"".$globalp->{_SAVECHANGES}."\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
	."</form><br>\n");

    $globalp->{CloseTable}();
    $globalp->{sitefooter}();
    $globalp->{clean_exit}();
}


sub reports_user_save()
{


    $error = "";
    if( $fdat{rname} eq "" )
    {
        $error .= "".$globalp->{_WFRESNAME}." ".$globalp->{_WFEMPTY}."<br>";
    }

    if( $fdat{rmail} eq "" )
    {
        $error .= "".$globalp->{_WFRESMAIL}." ".$globalp->{_WFEMPTY}."<br>";
    }

    if( $fdat{rlogin} eq "" )
    {
        $error .= "".$globalp->{_WFRESLOGIN}." ".$globalp->{_WFEMPTY}."<br>";
    }

    if( $fdat{rpsw} eq "" && $fdat{ID} eq "" )
    {
        $error .= "".$globalp->{_WFREPSW}." ".$globalp->{_WFEMPTY}."<br>";
    }

    if( $fdat{rpsw} ne $fdat{rtpsw} )
    {
        $error .= "".$globalp->{_WFREPSW}." & ".$globalp->{_RETYPEPASSWD}." ".$globalp->{_WFDIFF}."<br>";
    }

    if( $error ne "" )
    {
        $globalp->{siteheader}(); $globalp->{theheader}();

        echo("$error <br><br>".$globalp->{_GOBACK}."");
        delete $fdat{option};
        $globalp->{sitefooter}();
        $globalp->{clean_exit}();
    }

    $fdat_rname = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{rname}));
    $fdat_rext = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{rext}));
    $fdat_rmail = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{rmail}));
    #~ $fdat_rmail =~ s/@/\\@/;
    $fdat_rlogin = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{rlogin}));
    $fdat_rpsw = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{rpsw}));
    $pwd = md5_hex($fdat{rpsw});

    if( $fdat{ID} eq "" )
    {
        $globalp->{dbh}->do("insert into ".$globalp->{table_prefix}."_reports_users values (NULL,'$fdat_rname', '$fdat_rext', '$fdat_rmail', '$fdat_rlogin', '$pwd')");
        delete $fdat{rname};
    }
    else
    {
        $UpdateQuery = "UPDATE ".$globalp->{table_prefix}."_reports_users SET";
        $UpdateQuery .= " ResourceName='$fdat_rname', Extension='$fdat_rext'";
        $UpdateQuery .= " , Email='$fdat_rmail', Login='$fdat_rlogin'";

        if( $fdat{rpsw} ne "" )
        {
            $UpdateQuery .= " , Psw='$pwd'";
        }

        $UpdateQuery .= " WHERE ResourceID=$fdat{ID}";
        #~ echo($UpdateQuery); exit;
        $globalp->{dbh}->do($UpdateQuery)
         or die "Can Not Update ".$globalp->{table_prefix}."_reports_users";
    }
    delete $fdat{option};
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteReportsManager&amp;session=$globalp->{session}");
}





sub reports_show_users
{
    $globalp->{search_header}($globalp->{_PERSONSSC});
    $globalp->{OpenTable}();
    echo("<center>".$globalp->{_USERNAMEKEY}."</center><br>");
    echo("<table border=\"0\" >");
    echo("<form action=\"admin.prc\" method=\"POST\">\n"
             ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
             ."<input type=\"hidden\" name=\"option\" value=\"reports_show_persons\">\n"
             ."<tr align=\"left\"><td></td><td> <input type=\"text\" name=\"query\" value=\"$fdat{query}\" size=\"30\" maxlength=\"50\"></td>\n"
             ."<td><input name=\"submit\" value=\"".$globalp->{_SEARCH}." Users\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
             ."</form>\n");
    $globalp->{CloseTable}();

    echo("<br>");

    $globalp->{OpenTable}();
    echo("<center><b>- ".$globalp->{_WFSRESULTS}." -</b></center><hr noshade size=\"1\">\n");
    $offset = 10;
    $min = 0 if( !defined($fdat{min}) );
    $min = $fdat{min} if( defined($fdat{min}) );
    $max = ($min + $offset) if( !defined($max) );
    $fdat{query} = "%" if( $fdat{query} eq "" );
    $qc = "select ResourceID, ResourceName, Extension, Email, Login from ".$globalp->{table_prefix}."_reports_users";
    $qc_count = "select count(*) from ".$globalp->{table_prefix}."_reports_users";

    $qc .= " where (ResourceName like '%$fdat{query}%')";
    $qc_count .= " where (ResourceName like '%$fdat{query}%')";

    $qc .= " order by ResourceID limit $min,$offset";
    $qc_count .= " order by ResourceID";

    $sthsearch14 = $globalp->{dbh} -> prepare ($qc_count)  or die "Cannot SELECT from ".$globalp->{table_prefix}."_reports_users";
    $sthsearch14 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_reports_users";
    $sthsearch14 -> bind_columns(undef, \$nrows);
    $datsearch14 = $sthsearch14 -> fetchrow_arrayref;
    $sthsearch14->finish();

    $x = 0;

    if( $fdat{query} ne "" )
    {
        echo("<table width=\"99%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\">\n"
                 ."<tr bgcolor=\"$globalp->{bgcolor4}\"><td>ID</td><td>User Name</td><td>E-Mail</td><td>Login Name</td></tr>\n");
        if ( $nrows > 0 )
        {
                 $sthsearch15 = $globalp->{dbh} -> prepare ($qc)  or die "Cannot SELECT from ".$globalp->{table_prefix}."_reports_users";
                 $sthsearch15 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_wf_task";
                 $sthsearch15 -> bind_columns(undef, \$ResourceID, \$ResourceName, \$Extension, \$Email, \$Login);

            while($datsearch15 = $sthsearch15 -> fetchrow_arrayref)
            {
                echo("<tr bgcolor=\"$globalp->{bgcolor3}\"><td>$ResourceID</td><td>$ResourceName</td><td>$Email</td><td>$Login</td></tr>\n");
                $x++;
            }
            $sthsearch15->finish();

            echo("</table>");
        }
        else
        {
            echo("<tr align=\"left\"><td colspan=\"5\"><center><font class=\"option\"><br><b>".$globalp->{_NOMATCHES}."</b></font></center><br><br>"
                     ."</td></tr></table>");
        }

        $prev = $min - $offset;
        if( $prev >= 0 )
        {
            echo("<br><br><center><a href=\"admin.prc?session=$globalp->{session}&amp;option=reports_show_persons&amp;min=$prev&amp;query=$fdat{query}\">"
                     ."<b>$min ".$globalp->{_PREVMATCHES}."</b></a></center>");
        }

        $next = $min + $offset;

        if( $x >= 9 )
        {
            echo("<br><br><center><a href=\"admin.prc?session=$globalp->{session}&amp;option=reports_show_persons&amp;min=$max&amp;query=$fdat{query}\">"
                     ."<b>".$globalp->{_NEXTMATCHES}."</b></a></center>");
        }
    }
    $globalp->{CloseTable}();
    echo("<p><a href=\"JavaScript:window.close()\">".$globalp->{_WFCLOSEW}."</a></p></body></html>\n");
    $globalp->{clean_exit}();
}



sub reports_user_delete()
{

    if( $fdat{ID} eq "" )
    {
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?option=EplSiteReportsManager&session=$globalp->{session}");
    }

    if( $fdat{ok} == 1 )
    {
        $globalp->{dbh}->do("delete from ".$globalp->{table_prefix}."_reports_users where ResourceID=$fdat{ID}");
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?option=EplSiteReportsManager&session=$globalp->{session}");
    }
    else
    {
        $globalp->{siteheader}(); $globalp->{theheader}();
        $globalp->{GraphicAdmin}();
		echo("</div>");
        $globalp->{OpenTable}();
        echo("<center><font class=\"title\"><b>EplSite Reports Manager</b></font></center>");
        $globalp->{CloseTable}();
        echo("<br>");

        $sthresult3 = $globalp->{dbh} -> prepare ("select ResourceName from ".$globalp->{table_prefix}."_reports_users where ResourceID=$fdat{ID}") or die "Cannot SELECT from ".$globalp->{table_prefix}."_reports_users";
        $sthresult3 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_reports_users";
        $sthresult3 -> bind_columns(undef, \$name);
        $datresult3 = $sthresult3 -> fetchrow_arrayref;
        $sthresult3->finish();

		$globalp->{OpenTable}();
		echo("<center>"
				 ."<b>Do you want to delete user: $name ?</b><br>"
				 ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteReportsManager\">".$globalp->{_NO}."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;option=Reports User Delete&amp;ID=$fdat{ID}&amp;ok=1\">".$globalp->{_YES}."</a> ]</center><br>");
		$globalp->{CloseTable}();
        $globalp->{sitefooter}();
    }
}




sub report_group_save()
{
    $error = "";
    if( $fdat{ReportGroupDescription} eq "" )
    {
        $error .= "Enter Report Group Description.<br>";
    }

    
    if( $error ne "" )
    {
        $globalp->{siteheader}(); $globalp->{theheader}();

        echo("$error <br><br>".$globalp->{_GOBACK}."");
        delete $fdat{option};
        $globalp->{sitefooter}();
        $globalp->{clean_exit}();
    }

    $fdat_ReportGroupDescription = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{ReportGroupDescription}));
    
    if( $fdat{ReportGroupID} eq "" )
    {
		$insertquery = "INSERT INTO ".$globalp->{table_prefix}."_report_groups VALUES (NULL,'$fdat_ReportGroupDescription')";
		#~ echo($insertquery); exit;
        $globalp->{dbh}->do($insertquery);
        delete $fdat{rscript};
    }
    else
    {
        $globalp->{dbh}->do("UPDATE ".$globalp->{table_prefix}."_report_groups set ReportGroupDescription='$fdat_ReportGroupDescription'") or die "Can Not Update ".$globalp->{table_prefix}."_report_groups";
    }
    delete $fdat{option};
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteReportsManager&amp;session=$globalp->{session}");
}



sub report_group_edit()
{

    if( $fdat{ReportGroupID} eq "" )
    {
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?option=EplSiteReportsManager&amp;session=$globalp->{session}");
    }
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
	echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite Reports Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

	$selectquery = "SELECT ReportGroupDescription";
    $selectquery .= " FROM ".$globalp->{table_prefix}."_report_groups";
    $selectquery .= " WHERE ReportGroupID=$fdat{ReportGroupID}";
	
    $sthresult3 = $globalp->{dbh} -> prepare ($selectquery) 
    or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_report_groups";
    $sthresult3 -> execute  
    or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_report_groups";
    $sthresult3 -> bind_columns(undef, \$ReportGroupDescription);
    $datresult3 = $sthresult3 -> fetchrow_arrayref;
    $sthresult3->finish();



    $globalp->{OpenTable}();
    echo("<center><b>Edit Report Group</b></center><br><br>");
    echo("<table border=\"0\" >");
    echo("<form action=\"admin.prc\" method=\"POST\">\n"
             ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
             ."<input type=\"hidden\" name=\"option\" value=\"report_group_save\">\n"
             ."<input type=\"hidden\" name=\"ReportGroupID\" value=\"$fdat{ReportGroupID}\">\n"
             ."<tr align=\"left\"><td>Report Group Description:</td><td> <input type=\"text\""
             ." name=\"ReportGroupDescription\" size=\"50\" maxlength=\"100\""
             ." value=\"$ReportGroupDescription\"></td></tr>\n"
             ."<tr align=\"left\"><td><input name=\"submit\" value= \"".$globalp->{_SAVECHANGES}."\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
             ."</form><br>\n");

    $globalp->{CloseTable}();
    $globalp->{sitefooter}();
    $globalp->{clean_exit}();
}



sub report_group_delete()
{

    if( $fdat{ReportGroupID} eq "" )
    {
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?option=EplSiteReportsManager&session=$globalp->{session}");
    }

    if( $fdat{ok} == 1 )
    {
        $globalp->{dbh}->do("delete from ".$globalp->{table_prefix}."_report_groups WHERE ReportGroupID=$fdat{ReportGroupID}");
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?option=EplSiteReportsManager&session=$globalp->{session}");
    }
    else
    {
        $globalp->{siteheader}(); $globalp->{theheader}();
        $globalp->{GraphicAdmin}();
		echo("</div>");
        $globalp->{OpenTable}();
        echo("<center><font class=\"title\"><b>EplSite Reports Manager</b></font></center>");
        $globalp->{CloseTable}();
        echo("<br>");

        $sthresult3 = $globalp->{dbh} -> prepare ("SELECT ReportGroupDescription FROM ".$globalp->{table_prefix}."_report_groups WHERE ReportGroupID=$fdat{ReportGroupID}") or die "Cannot SELECT from ".$globalp->{table_prefix}."_report_groups";
        $sthresult3 -> execute  or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_report_groups";
        $sthresult3 -> bind_columns(undef, \$ReportGroupDescription);
        $datresult3 = $sthresult3 -> fetchrow_arrayref;
        $sthresult3->finish();

		$error = "";
        $MySelectQuery = "SELECT count(*) FROM ".$globalp->{table_prefix}."_reports_definition";
        $MySelectQuery .= " WHERE ReportGroupID=".$fdat{ReportGroupID};
        
        $sthresult3 = $globalp->{dbh} -> prepare ($MySelectQuery) or die 
        "Cannot prepare query:$MySelectQuery ";
        $sthresult3 -> execute  or die "Cannot execute query:$MySelectQuery";
        $sthresult3 -> bind_columns(undef, \$nrows);
        $datresult3 = $sthresult3 -> fetchrow_arrayref;
        $sthresult3->finish();

        if( $nrows > 0 )
        {
            $error .= "Report Group $ReportGroupDescription";
            $error .= " is in use by a report.<br>";
        }

		$globalp->{OpenTable}();
		if( $error ne "" )
		{
			echo($error ."<br><br>".$globalp->{_GOBACK});
		}
		else
		{        
            echo("<center>"
                     ."<b>Do you want to delete report group: $ReportGroupDescription ?</b><br>"
                     ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteReportsManager\">".$globalp->{_NO}."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;option=Delete Report Group&amp;ReportGroupID=$fdat{ReportGroupID}&amp;ok=1\">".$globalp->{_YES}."</a> ]</center><br>");
        }
		$globalp->{CloseTable}();
        $globalp->{sitefooter}();
    }
}



sub eplsite_report_save()
{
    $error = "";
	$globalp->{ScriptSaved} = "";
	$fdat{rscript} =~ s/'//g;
	$fdat{rscript}  =~ s/^\s+//; #remove leading spaces
	$fdat{rscript}  =~ s/\s+$//; #remove trailing spaces	
	
    if( $fdat{rscript} eq "" )
    {
        $error .= "Enter Correct Report Script Name.<br>";
    }

    if( $fdat{ReportGroupID} eq "" )
    {
        $error .= "Select Report Group.<br>";
    }

	$fdat{rdescription}  =~ s/^\s+//; #remove leading spaces
	$fdat{rdescription}  =~ s/\s+$//; #remove trailing spaces
	
    if( $fdat{rdescription} eq "" )
    {
        $error .= "Enter Report Description<br>";
    }
    
	$NumRows = 0;
	
    if( $fdat{ReportID} eq "" && $fdat{rscript} ne "" )
    {			
		$selectquery = "SELECT COUNT(*) FROM ";
		$selectquery .= $globalp->{table_prefix}."_reports_definition";
		$selectquery .= " WHERE ReportScript='".$fdat{rscript}."'";
	
		$sthresult3 = $globalp->{dbh} -> prepare ($selectquery) 
		or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_reports_definition";
		$sthresult3 -> execute  
		or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_reports_definition";
		$sthresult3 -> bind_columns(undef, \$NumRows);
		$datresult3 = $sthresult3 -> fetchrow_arrayref;
		$sthresult3->finish();
	}

    if( $fdat{ReportID} ne "" && $fdat{rscript} ne "" )
    {			
		$selectquery = "SELECT ReportID FROM ";
		$selectquery .= $globalp->{table_prefix}."_reports_definition";
		$selectquery .= " WHERE ReportScript='".$fdat{rscript}."'";
	
		$sthresult3 = $globalp->{dbh} -> prepare ($selectquery) 
		or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_reports_definition";
		$sthresult3 -> execute  
		or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_reports_definition";
		$sthresult3 -> bind_columns(undef, \$ReportIDSaved);
		while( $datresult3 = $sthresult3 -> fetchrow_arrayref())
		{
			if( $ReportIDSaved != $fdat{ReportID} )
			{
				$NumRows += 1;
			}
		}
		$sthresult3->finish();		
	}
	
	if( $NumRows > 0 )
	{
		$error .= "A Report With Name:<b>".$fdat{rscript}."</b> Already Exists.<br>";
	}
		
    if( $error ne "" )
    {
        $globalp->{siteheader}(); $globalp->{theheader}();

        echo("$error <br><br>".$globalp->{_GOBACK}."");
        delete $fdat{option};
        $globalp->{sitefooter}();
        $globalp->{clean_exit}();
    }

    $fdat_rscript = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{rscript}));
    $fdat_rdescription = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{rdescription}));
    
    if( $fdat{ReportID} eq "" )
    {
		$insertquery = "INSERT INTO ".$globalp->{table_prefix}."_reports_definition VALUES ";
		$insertquery .= "(NULL,'$fdat_rscript', $fdat{ReportGroupID}, '$fdat_rdescription','')";
		#~ echo($insertquery); exit;
        $globalp->{dbh}->do($insertquery);
        delete $fdat{rscript};
		$globalp->{cleanup}();
		&redirect_url_to("admin.prc?option=EplSiteReportsManager&amp;session=$globalp->{session}");				
    }
    else
    {
		$fdat_reportperlscript = $globalp->{FixScriptSlashesAndQuotes}($fdat{ReportPerlScript});
		$UpdateQuery = "UPDATE ".$globalp->{table_prefix}."_reports_definition SET";
		$UpdateQuery .= " ReportScript='$fdat_rscript', ReportGroupID=$fdat{ReportGroupID}";
		$UpdateQuery .= ", ReportDescription='$fdat_rdescription'";
		$UpdateQuery .= ", ReportPerlScript='$fdat_reportperlscript'";
		$UpdateQuery .= " WHERE ReportID=$fdat{ReportID}";
		
        $globalp->{dbh}->do($UpdateQuery) 
		or die "Can Not Update ".$globalp->{table_prefix}."_reports_definition";
		
		$ReportPerlScript = $fdat{ReportPerlScript};
		$ReportPerlScript  =~ s/^\s+//; #remove leading spaces
		$ReportPerlScript  =~ s/\s+$//; #remove trailing spaces	
		
		if( $ReportPerlScript ne "" )
		{
			$ReportPerlScriptError = $globalp->{EplSitePerlCheckSyntax}($fdat{ReportPerlScript},"ReportPerlScript");
			if( $ReportPerlScriptError ne "")
			{
				$error .= "<b>Report Perl Script Has Errors:</b><br> " . $ReportPerlScriptError ."<br><br>";
			}
		}
		
		if( $error ne "" )
		{
			$globalp->{siteheader}(); $globalp->{theheader}();
			echo("Script Saved But It Has Some Errors:<br><br>$error <br><br>");
			echo("[ <a href=\"admin.prc?session=$globalp->{session}&amp;option="
			."Edit Report Perl Script&amp;ReportID=$fdat{ReportID}\">Continue Editing Report Perl Script.</a> ]<br><br>");
			echo("[ <a href=\"admin.prc?session=$globalp->{session}&amp;option="
			."EplSiteReportsManager\">Go To EplSite Reports Control Panel Screen.</a> ]<br>");
			delete $fdat{option};
			$globalp->{sitefooter}();
			$globalp->{clean_exit}();
		}
		else
		{
			$globalp->{ScriptSaved} = "<font color=\"green\"><b>Report Perl Script "; 
			$globalp->{ScriptSaved} .= "Succesfully Saved And Compiled At:";
			$globalp->{ScriptSaved} .= $globalp->{get_localtime}(time)." - Syntax OK.</b></font>";
			&eplsite_report_edit();
		}		
    }
}





sub eplsite_report_edit()
{

    if( $fdat{ReportID} eq "" )
    {
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?option=EplSiteReportsManager&amp;session=$globalp->{session}");
    }
    $globalp->{siteheader}();
	&JavaScriptsForMenus();
	$globalp->{LoadPerlCodeEditorLibs}();	
	echo("<style>.CodeMirror {height: 620px;}</style>");	
	$globalp->{theheader}();
    $globalp->{GraphicAdmin}();
	echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite Reports Manager</b></font></font> - "
	."<b>Edit Report Perl Script</b>"
	." - Click the links below to hide/unhide sections.<br>"
	."<a href=\"javascript:HandlePerlScriptSections('ScriptDescription','');\">Report Description</a>"
	."&nbsp; <a href=\"javascript:HandlePerlScriptSections('PerlScriptSection','pseditor');\">Report Perl Script</a>"	
	."</center>");
    $globalp->{CloseTable}();
    echo("<br>");

	$selectquery = "SELECT ReportScript, ReportGroupID, ReportDescription, ReportPerlScript FROM ";
	$selectquery .= $globalp->{table_prefix}."_reports_definition WHERE ReportID=$fdat{ReportID}";
	
    $sthresult3 = $globalp->{dbh} -> prepare ($selectquery) 
	or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_reports_definition";
    $sthresult3 -> execute  
	or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_reports_definition";
    $sthresult3 -> bind_columns(undef, \$ReportScript, \$ReportGroupID, \$ReportDescription, \$ReportPerlScript);
    $datresult3 = $sthresult3 -> fetchrow_arrayref;
    $sthresult3->finish();


    $globalp->{OpenTable}();
	
	if($globalp->{ScriptSaved} ne "")
	{
		echo($globalp->{ScriptSaved});
	}
	echo("<form action=\"admin.prc\" method=\"POST\"><table border=\"0\">\n");    
	echo("<tr align=\"left\"><td><input type=\"submit\" name=\"submit\""
	." value= \"Save-Compile Continue Editing\">"
	."</td></tr></table>\n");
	
	echo("<div id=\"ScriptDescription\" class=\"hidden\"><table border=\"0\">"
	."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
	."<input type=\"hidden\" name=\"option\" value=\"eplsite_report_save\">\n"
	."<input type=\"hidden\" name=\"ReportID\" value=\"$fdat{ReportID}\">\n"             
	."<tr align=\"left\"><td>Report Group:</td>"
	."<td><select name=\"ReportGroupID\">");
			 
	if( $ReportGroupID eq "" )
	{
		echo("<option selected value=\"\">Select Report Group</option>\n");
	}
	else
	{
		echo("<option value=\"\">Select Report Group</option>\n");
	}
			 
	$selectquery = "SELECT ReportGroupID, ReportGroupDescription FROM "; 
	$selectquery .= $globalp->{table_prefix}."_report_groups ORDER BY ReportGroupDescription";
	
	$resulti = $globalp->{dbh} -> prepare ($selectquery)  
	or die "Cannot prepare query:$selectquery";
	$resulti -> execute  or die "Cannot execute query:$selectquery";
	$resulti -> bind_columns(undef, \$ReportGroupIDcat, \$ReportGroupDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref )
	{
		$sel = "";
		$sel= "selected" if( $ReportGroupID == $ReportGroupIDcat );
		print '<option '.$sel.' value="'.$ReportGroupIDcat.'">'.$ReportGroupDescription.'</option>'."\n";
	}
	$resulti->finish();
	
	
	echo("</select></td></tr>\n"	
	."<tr align=\"left\"><td>Report Name:</td><td> "
	."<input type=\"text\" name=\"rscript\" size=\"50\" maxlength=\"100\" "
	."value=\"$ReportScript\"></td></tr>\n"
	."<tr align=\"left\"><td>Report Description:</td><td> <input type=\"text\""
	." name=\"rdescription\" size=\"50\" maxlength=\"100\" value=\"$ReportDescription\"></td></tr>\n"
	."</table></div><div id=\"PerlScriptSection\" class=\"unhidden\"><table height=\"100%\" width=\"100%\" border=\"0\">\n"
	."<tr align=\"left\"><td> <b>Perl Script. </b>\n"
	."Write here your Report Perl Script, \n"
	."all functions in EplSite Web Portal \n"
	."and EplSite ETL module can be used.<br>\n"		
	."<textarea id=\"ReportPerlScript\" name=\"ReportPerlScript\">\n"
	.$ReportPerlScript."</textarea>\n");
	echo('    <script>' . "\n");
	echo('      var pseditor = CodeMirror.fromTextArea(document.getElementById("ReportPerlScript"), {' . "\n");
	echo(" width: '100%',");
	echo(" height: '100%',");
	echo('        mode: "text/x-perl",' . "\n");
	echo('        tabSize: 2,' . "\n");
	echo('        matchBrackets: true,' . "\n");
	echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		pseditor.on("blur", function(){ ' . "\n");
	echo('           pseditor.save();' . "\n");
	echo('      });' . "\n");
	echo('    </script>' . "\n");            
	echo("</td></tr></table></div><table width=\"100%\" border=\"0\">\n"			 					 
	."<tr align=\"left\"><td><input type=\"submit\" name=\"submit\" value= \"Save-Compile Continue Editing\">"
	."</td></tr>\n"
	."</table>\n"
	."</form><br>\n");

    $globalp->{CloseTable}();
    $globalp->{sitefooter}();
    $globalp->{clean_exit}();
}



sub eplsite_report_delete()
{

    if( $fdat{ReportID} eq "" )
    {
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?option=EplSiteReportsManager&session=$globalp->{session}");
    }

    if( $fdat{ok} == 1 )
    {
		my $DeleteQuery = "DELETE FROM ".$globalp->{table_prefix};
		$DeleteQuery .= "_reports_definition WHERE ReportID=$fdat{ReportID}";
		
        $globalp->{dbh}->do($DeleteQuery);
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?option=EplSiteReportsManager&session=$globalp->{session}");
    }
    else
    {
        $globalp->{siteheader}(); $globalp->{theheader}();
        $globalp->{GraphicAdmin}();
		echo("</div>");
        $globalp->{OpenTable}();
        echo("<center><font class=\"title\"><b>EplSite Reports Manager</b></font></center>");
        $globalp->{CloseTable}();
        echo("<br>");

		my $SelectQuery = "SELECT ReportDescription FROM ".$globalp->{table_prefix};
		$SelectQuery .="_reports_definition WHERE ReportID=$fdat{ReportID}";
		
        $sthresult3 = $globalp->{dbh} -> prepare ($SelectQuery) 
		or die "Cannot SELECT from ".$globalp->{table_prefix}."_reports_definition";
        $sthresult3 -> execute  
		or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_reports_definition";
        $sthresult3 -> bind_columns(undef, \$name);
        $datresult3 = $sthresult3 -> fetchrow_arrayref;
        $sthresult3->finish();

		$globalp->{OpenTable}();
		echo("<center>"
		."<b>Do you want to delete report: $name ?</b><br>"
		."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteReportsManager\">"
		.$globalp->{_NO}."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;option="
		."EplSite Report Delete&amp;ReportID=$fdat{ReportID}&amp;ok=1\">"
		.$globalp->{_YES}."</a> ]</center><br>");
		$globalp->{CloseTable}();
        $globalp->{sitefooter}();
    }
}





sub eplsite_javascript_save()
{
    $error = "";
	$globalp->{ScriptSaved} = "";
	$fdat{JavaScriptName} =~ s/'//g;
	$fdat{JavaScriptName}  =~ s/^\s+//; #remove leading spaces
	$fdat{JavaScriptName}  =~ s/\s+$//; #remove trailing spaces	
	
    if( $fdat{JavaScriptName} eq "" )
    {
        $error .= "Enter JavaScript Name.<br>";
    }

	$fdat{JavaScriptDescription}  =~ s/^\s+//; #remove leading spaces
	$fdat{JavaScriptDescription}  =~ s/\s+$//; #remove trailing spaces
	
    if( $fdat{JavaScriptDescription} eq "" )
    {
        $error .= "Enter JavaScript Description<br>";
    }
    
	$NumRows = 0;
	
    if( $fdat{JavaScriptID} eq "" && $fdat{JavaScriptName} ne ""  )
    {			
		$selectquery = "SELECT COUNT(*) FROM ";
		$selectquery .= $globalp->{table_prefix}."_etl_javascriptlibs";
		$selectquery .= " WHERE JavaScriptName='".$fdat{JavaScriptName}."'";
	
		$sthresult3 = $globalp->{dbh} -> prepare ($selectquery) 
		or die "Cannot prepare query: $selectquery";
		$sthresult3 -> execute  
		or die "Cannot execute query: $selectquery";
		$sthresult3 -> bind_columns(undef, \$NumRows);
		$datresult3 = $sthresult3 -> fetchrow_arrayref;
		$sthresult3->finish();
	}
	
    if( $fdat{JavaScriptID} ne "" && $fdat{JavaScriptName} ne ""  )
    {			
		$selectquery = "SELECT JavaScriptID FROM ";
		$selectquery .= $globalp->{table_prefix}."_etl_javascriptlibs";
		$selectquery .= " WHERE JavaScriptName='".$fdat{JavaScriptName}."'";
	
		$sthresult3 = $globalp->{dbh} -> prepare ($selectquery) 
		or die "Cannot prepare query: $selectquery";
		$sthresult3 -> execute  
		or die "Cannot execute query: $selectquery";
		$sthresult3 -> bind_columns(undef, \$JavaScriptIDSaved);
		
		while( $datresult3 = $sthresult3 -> fetchrow_arrayref())
		{
			if( $JavaScriptIDSaved != $fdat{JavaScriptID} )
			{
				$NumRows += 1;
			}
		}
		$sthresult3->finish();
	}
	
	if( $NumRows > 0 )
	{
		$error .= "A JavaScript With Name:<b>".$fdat{JavaScriptName}."</b> Already Exists.<br>";
	}
	
    if( $error ne "" )
    {
        $globalp->{siteheader}(); $globalp->{theheader}();

        echo("$error <br><br>".$globalp->{_GOBACK}."");
        delete $fdat{option};
        $globalp->{sitefooter}();
        $globalp->{clean_exit}();
    }

    $fdat_JavaScriptName = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{JavaScriptName}));
    $fdat_JavaScriptDescription = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{JavaScriptDescription}));
    
    if( $fdat{JavaScriptID} eq "" )
    {
		$insertquery = "INSERT INTO ".$globalp->{table_prefix}."_etl_javascriptlibs VALUES ";
		$insertquery .= "(NULL,'$fdat_JavaScriptName', '$fdat_JavaScriptDescription','')";
		#~ echo($insertquery); exit;
        $globalp->{dbh}->do($insertquery);
        delete $fdat{JavaScriptName};
		$globalp->{cleanup}();
		&redirect_url_to("admin.prc?option=EplSiteReportsManager&amp;session=$globalp->{session}");				
    }
    else
    {
		$fdat_JavaScriptCode = $globalp->{FixScriptSlashesAndQuotes}($fdat{JavaScriptCode});
		$UpdateQuery = "UPDATE ".$globalp->{table_prefix}."_etl_javascriptlibs SET";
		$UpdateQuery .= " JavaScriptName='$fdat_JavaScriptName'";
		$UpdateQuery .= ", JavaScriptDescription='$fdat_JavaScriptDescription'";
		$UpdateQuery .= ", JavaScriptCode='$fdat_JavaScriptCode'";
		$UpdateQuery .= " WHERE JavaScriptID=$fdat{JavaScriptID}";
		
        $globalp->{dbh}->do($UpdateQuery) 
		or die "Can Not Update ".$globalp->{table_prefix}."_etl_javascriptlibs";
		
		$globalp->{ScriptSaved} = "<font color=\"green\"><b>JavaScript "; 
		$globalp->{ScriptSaved} .= "Succesfully Saved At:";
		$globalp->{ScriptSaved} .= $globalp->{get_localtime}(time)."</b></font>";
		
		&eplsite_javascript_edit();
    }
}





sub eplsite_javascript_edit()
{
    if( $fdat{JavaScriptID} eq "" )
    {
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?option=EplSiteReportsManager&amp;session=$globalp->{session}");
    }
    $globalp->{siteheader}();
	&JavaScriptsForMenus();
	$globalp->{LoadJavaScriptEditorLibs}();	
	echo("<style>.CodeMirror {height: 620px;}</style>");	
	$globalp->{theheader}();
    $globalp->{GraphicAdmin}();
	echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite JavaScript Libraries Manager</b></font></font> - "
	."<b>Edit JavaScript Libraries</b>"
	." - Click the links below to hide/unhide sections.<br>"
	."<a href=\"javascript:HandleJavaScriptSections('ScriptDescription','');\">JavaScript Description</a>"
	."&nbsp; <a href=\"javascript:HandleJavaScriptSections('JavaScriptSection','jseditor');\">JavaScript Code</a>"	
	."</center>");
    $globalp->{CloseTable}();
    echo("<br>");

	$selectquery = "SELECT JavaScriptName, JavaScriptDescription, JavaScriptCode FROM ";
	$selectquery .= $globalp->{table_prefix}."_etl_javascriptlibs WHERE JavaScriptID=$fdat{JavaScriptID}";
	
    $sthresult3 = $globalp->{dbh} -> prepare ($selectquery) 
	or die "Cannot prepare query:$selectquery";
    $sthresult3 -> execute  
	or die "Cannot execute query:$selectquery";
    $sthresult3 -> bind_columns(undef, \$JavaScriptName, \$JavaScriptDescription, \$JavaScriptCode);
    $datresult3 = $sthresult3 -> fetchrow_arrayref;
    $sthresult3->finish();

    $globalp->{OpenTable}();
	
	if($globalp->{ScriptSaved} ne "")
	{
		echo($globalp->{ScriptSaved});
	}
	echo("<form action=\"admin.prc\" method=\"POST\"><table border=\"0\">\n");    
	echo("<tr align=\"left\"><td><input type=\"submit\" name=\"submit\""
	." value= \"Save And Continue Editing\">"
	."</td><td><td>&nbsp;</td></tr></table>\n");
	
	echo("<div id=\"ScriptDescription\" class=\"hidden\"><table border=\"0\">"
	."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
	."<input type=\"hidden\" name=\"option\" value=\"eplsite_javascript_save\">\n"
	."<input type=\"hidden\" name=\"JavaScriptID\" value=\"$fdat{JavaScriptID}\">\n"             
	."<tr align=\"left\"><td>JavaScript Name:</td><td> "
	."<input type=\"text\" name=\"JavaScriptName\" size=\"50\" maxlength=\"100\" "
	."value=\"$JavaScriptName\"></td></tr>\n"
	."<tr align=\"left\"><td>Report Description:</td><td> <input type=\"text\""
	." name=\"JavaScriptDescription\" size=\"50\" maxlength=\"100\" value=\"$JavaScriptDescription\"></td></tr>\n"
	."</table></div><div id=\"JavaScriptSection\" class=\"unhidden\"><table height=\"100%\" width=\"100%\" border=\"0\">\n"
	."<tr align=\"left\"><td> <b>Perl Script. </b>\n"
	."Write here your Report Perl Script, \n"
	."all functions in EplSite Web Portal \n"
	."and EplSite ETL module can be used.<br>\n"		
	."<textarea id=\"JavaScriptCode\" name=\"JavaScriptCode\">\n"
	.$JavaScriptCode."</textarea>\n");
	echo('    <script>' . "\n");
	echo('      var jseditor = CodeMirror.fromTextArea(document.getElementById("JavaScriptCode"), {' . "\n");
	echo(" width: '100%',");
	echo(" height: '100%',");
	echo('        tabSize: 2,' . "\n");
	echo('        matchBrackets: true,' . "\n");
	echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		jseditor.on("blur", function(){ ' . "\n");
	echo('           jseditor.save();' . "\n");
	echo('      });' . "\n");
	echo('    </script>' . "\n");            
	echo("</td></tr></table></div><table width=\"100%\" border=\"0\">\n"			 					 
	."<tr align=\"left\"><td><input type=\"submit\" name=\"submit\" value= \"Save And Continue Editing\">"
	."</td></tr>\n"
	."</table>\n"
	."</form><br>\n");

    $globalp->{CloseTable}();
    $globalp->{sitefooter}();
    $globalp->{clean_exit}();
}



sub eplsite_javascript_delete()
{

    if( $fdat{JavaScriptID} eq "" )
    {
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?option=EplSiteReportsManager&session=$globalp->{session}");
    }

    if( $fdat{ok} == 1 )
    {
		my $DeleteQuery = "DELETE FROM ".$globalp->{table_prefix};
		$DeleteQuery .= "_etl_javascriptlibs WHERE JavaScriptID=$fdat{JavaScriptID}";
		
        $globalp->{dbh}->do($DeleteQuery);
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?option=EplSiteReportsManager&session=$globalp->{session}");
    }
    else
    {
        $globalp->{siteheader}(); $globalp->{theheader}();
        $globalp->{GraphicAdmin}();
		echo("</div>");
        $globalp->{OpenTable}();
        echo("<center><font class=\"title\"><b>EplSite JavaScript Libraries Manager</b></font></center>");
        $globalp->{CloseTable}();
        echo("<br>");

		my $SelectQuery = "SELECT JavaScriptDescription FROM ".$globalp->{table_prefix};
		$SelectQuery .="_etl_javascriptlibs WHERE JavaScriptID=$fdat{JavaScriptID}";
		
        $sthresult3 = $globalp->{dbh} -> prepare ($SelectQuery) 
		or die "Cannot prepare query:$SelectQuery";
        $sthresult3 -> execute  
		or die "Cannot execute query:$SelectQuery";
        $sthresult3 -> bind_columns(undef, \$name);
        $datresult3 = $sthresult3 -> fetchrow_arrayref;
        $sthresult3->finish();

		$globalp->{OpenTable}();
		echo("<center>"
		."<b>Do you want to delete JavaScript library: $name ?</b><br>"
		."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteReportsManager\">"
		.$globalp->{_NO}."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;option="
		."Delete JavaScript&amp;JavaScriptID=$fdat{JavaScriptID}&amp;ok=1\">"
		.$globalp->{_YES}."</a> ]</center><br>");
		$globalp->{CloseTable}();
        $globalp->{sitefooter}();
    }
}





sub JavaScriptsForMenus
{

	echo("<script type=\"text/javascript\"> \n"
	.'function HandlePerlScriptSections(divID,EditorName)'."\n"
	.'{'."\n"
	.'	var item = document.getElementById(divID);'."\n"
	.'	if (item)'."\n"
	.'	{'."\n"
	."			document.getElementById('ScriptDescription').className='hidden';\n"
	."			document.getElementById('PerlScriptSection').className='hidden';\n"
	."			item.className='unhidden';\n"
	."	}\n"
	.'	switch ( EditorName )'."\n"
	.'	{'."\n"
	.'		case "pseditor":'."\n"
	."			pseditor.refresh();\n"
	."			break;\n"
	."	}\n"
	."}\n"
	."\n"
	.'function HandleJavaScriptSections(divID,EditorName)'."\n"
	.'{'."\n"
	.'	var item = document.getElementById(divID);'."\n"
	.'	if (item)'."\n"
	.'	{'."\n"
	."			document.getElementById('ScriptDescription').className='hidden';\n"
	."			document.getElementById('JavaScriptSection').className='hidden';\n"
	."			item.className='unhidden';\n"
	."	}\n"
	.'	switch ( EditorName )'."\n"
	.'	{'."\n"
	.'		case "jseditor":'."\n"
	."			jseditor.refresh();\n"
	."			break;\n"
	."	}\n"
	."}\n"
	."\n"
	."</script>\n");
}


if( $fdat{option} eq "EplSiteReportsManager" ) { EplSiteReportsManager(); }

if( $fdat{option} eq "reports_user_save" ) { &reports_user_save(); }
elsif( $fdat{option} eq "Reports Edit User" ) { &reports_user_edit(); }
elsif( $fdat{option} eq "Reports User Delete" ) { &reports_user_delete(); }

if( $fdat{option} eq "reports_show_persons" ) { &reports_show_users(); }

if( $fdat{option} eq "report_group_save" ) { &report_group_save(); }
elsif( $fdat{option} eq "Edit Report Group" ) { &report_group_edit(); }
elsif( $fdat{option} eq "Delete Report Group" ) { &report_group_delete(); }


if( $fdat{option} eq "eplsite_report_save" ) { &eplsite_report_save(); }
elsif( $fdat{option} eq "Edit Report Perl Script" ) { &eplsite_report_edit(); }
elsif( $fdat{option} eq "EplSite Report Delete" ) { &eplsite_report_delete(); }

if( $fdat{option} eq "eplsite_javascript_save" ) { &eplsite_javascript_save(); }
elsif( $fdat{option} eq "Edit JavaScript" ) { &eplsite_javascript_edit(); }
elsif( $fdat{option} eq "Delete JavaScript" ) { &eplsite_javascript_delete(); }





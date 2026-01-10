########################################################################
# Eplsite,Subroutines for EplSiteReports module
#Copyright (C) 2012 by Carlos Kassab (laran.ikal@gmail.com)
#
#This program is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 2 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
########################################################################



    if( $globalp->{loaded_from_index} != 1 ) {
        echo("Access denied!!!!");
        if( defined($ENV{MOD_PERL}) ) {
            Apache::exit;
        }else{  exit(); }
    }



Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteReports/language/lang-'.$globalp->{site_language}.'.prc');
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteReports/config_EplSiteReports.prc');

	$globalp->{loggedon_as} =
	sub
	{
		local $escmode = 0;
		$the_cvalues[3]=~ s/\+/ /g;
		echo("<br>");
		if( $fdat{option} ne "logout" ) {
			$globalp->{OpenTable}();
			echo("<b>".$globalp->{_WFLOGGEDAS}."</b> <u>$the_cvalues[0] - $the_cvalues[3]</u>\n"
			." &nbsp;<strong><big>&middot;</big></strong> <a href=\"index.prc?module=EplSiteReports\">".$globalp->{_WFHOME}."</a>\n"
			." &nbsp;&nbsp;<strong><big>&middot;</big></strong> <a href=\"index.prc?module=EplSiteReports&option=logout\">".$globalp->{_WFLOGOUT}."</a>\n");

			if( $globalp->{use_eplsite_password} == 0 ) {
				echo(" <strong><big>&middot;</big></strong> <a href=\"index.prc?module=EplSiteReports&chgpasswd=chgpassform\">".$globalp->{_WFCHGPASS}."</a>\n");
			}

			$globalp->{CloseTable}();
		}
		echo("<br>");
	};

	sub wflogout
	{
		@mypath = split('\/',$ENV{REQUEST_URI});
		$mypathnum = @mypath;
		$i = 0;$thepath = "";
		foreach $paths(@mypath) {
		   $thepath .= $mypath[$i] if( ( $i > 0 ) && ( $i < $mypathnum-1 ) );
		   $thepath .= "\/" if( $i < $mypathnum-2 );
		   $i++;
		}
		$globalp ->{set_the_cookie}(0, 1, 2, 3);
		&delete_cookie($globalp->{CookieName},$ENV{PATH_INFO});

		$globalp->{siteheader}();
		$globalp->{theheader}();
		$globalp->{OpenTable}();
		echo("<center><font class=\"title\"><b>".$globalp->{_WFLOGOUT}."</b></font></center>\n");
		echo("<center><font class=\"title\"><b>".$globalp->{_WFLOGOUT1}."</b></font></center>\n");
		$globalp->{CloseTable}();

		$globalp->{thefooter}();
		$globalp->{sitefooter}();
	}


	sub set_the_cookie
	{
		my $crid = shift; my $cuser = shift; my $cpass = shift;
		my $uname = shift;

		#~ use MIME::Base64;

		my @cvalues;
		my $info = "$crid:$cuser:$cpass:$uname: ";
		my $cpass1 = encode_base64($cpass);
		my $info1 = "$crid:$cuser:$cpass1:$uname: ";


	#    @mypath = split('\/',$ENV{REQUEST_URI});
	#    $mypathnum = @mypath;
	#    $i = 0;$thepath = "";
	#    foreach $paths(@mypath) {
	#       $thepath .= $mypath[$i] if( ( $i > 0 ) && ( $i < $mypathnum-1 ) );
	#       $thepath .= "\/" if( $i < $mypathnum-2 );
	#       $i++;
	#    }

		if( $globalp->{wfsession_expire_time} eq '0' ) {
			&set_cookie("ERUserData",$info1,"-1", "", "", 0);
		} else {
			&set_cookie("ERUserData",$info1,$globalp{wfsession_expire_time}, "", "", 0);
		}
		@cvalues = split(':',$info);

		return(@cvalues);
	}


	sub wflogin
	{
		local $escmode = 0;

		$globalp->{OpenTable}();
		echo("<center><font class=\"title\"><b>".$globalp->{_WFLOGIN}."</b></font></center>\n");
		$globalp->{CloseTable}();
		echo("<br>\n");
		$globalp->{OpenTable}();
		echo("<form action=\"index.prc\" method=\"post\">\n"
		."<table border=\"0\">\n"
		."<tr><td>".$globalp->{_NICKNAME}.":</td>\n"
		."<td><input type=\"text\" NAME=\"login\" value=\"$fdat{login}\" SIZE=\"20\" MAXLENGTH=\"100\">(eplsite)</td></tr>\n"
		."<tr><td>".$globalp->{_PASSWORD}.":</td>\n"
		."<td><input type=\"password\" NAME=\"pwd\" SIZE=\"20\" MAXLENGTH=\"18\">(eplsite)</td></tr>\n"
		."<tr><td>\n"
		."<input type=\"hidden\" NAME=\"option\" value=\"login\">\n"
		."<input type=\"hidden\" NAME=\"module\" value=\"EplSiteReports\">\n"
		."<input type=\"submit\" VALUE=\"".$globalp->{_LOGIN}."\">\n"
		."</td></tr></table>\n");
		if( defined($fdat{taskid}) ){ echo("<input type=\"hidden\" name=\"taskid\" value =\"$fdat{taskid}\">\n"); }
		echo("</form>\n");
		$globalp->{CloseTable}();
		delete $fdat{option};
	}


	sub Change_wf_Password_Form
	{
		$globalp->{siteheader}();
		$globalp->{theheader}();

		echo("$passmessage");
		$globalp->{OpenTable}();
		echo("<center><font class=\"title\"><b>".$globalp->{_WFCHGPASS1}."</b></font></center>\n");
		$globalp->{CloseTable}();
		echo("<br>\n");
		$globalp->{OpenTable}();
		echo("<form action=\"index.prc\" method=\"post\">\n"
		."<input type=\"hidden\" name=\"module\" value=\"EplSiteReports\">\n"
		."<table border=\"0\">\n"
		."<tr><td>".$globalp->{_NICKNAME}."</td>\n"
		."<td><input type=\"text\" NAME=\"login\" value=\"$fdat{login}\" SIZE=\"20\" MAXLENGTH=\"100\"></td></tr>\n"
		."<tr><td>".$globalp->{_WFACTUALPASS}."</td>\n"
		."<td><input type=\"password\" NAME=\"apwd\" SIZE=\"20\" MAXLENGTH=\"18\"></td></tr>\n"
		."<tr><td>".$globalp->{_WFENTERNEWPASS}."</td>\n"
		."<td><input type=\"password\" NAME=\"npwd\" SIZE=\"20\" MAXLENGTH=\"18\"></td></tr>\n"
		."<tr><td>".$globalp->{_WFRTYPNEWPASS}."</td>\n"
		."<td><input type=\"password\" NAME=\"rnpwd\" SIZE=\"20\" MAXLENGTH=\"18\"></td></tr>\n"
		."<tr><td>\n"
		."<input type=\"hidden\" NAME=\"chgpasswd\" value=\"chgpass\">\n"
		."<input type=\"submit\" VALUE=\"".$globalp->{_WFCHGPASSBTN}."\">\n"
		."</td></tr></table>\n");
		echo("</form>\n");
		$globalp->{CloseTable}();
		delete $fdat{option};
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
		$globalp->{clean_exit}();
	}


	sub Change_wf_Password
	{

		use Digest::MD5  qw(md5_hex);
		$nrows = 0;
		$sthresult = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_reports_users where Login ='$fdat{login}' ")  or die "Cannot SELECT from Resource ";
		$sthresult -> execute  or die "Cannot execute SELECT from Resource";
		$sthresult -> bind_columns(undef, \$nrows);
		$datresult = $sthresult -> fetchrow_arrayref;
		$sthresult -> finish();

		if( $nrows == 0 ) {
			$passmessage = "<font color=red><b>".$globalp->{_NORESOURCE}."</b></font><br><br>";
			&Change_wf_Password_Form;
			return;
		}

		if( $fdat{apwd} eq "" ) {
			$passmessage = "<font color=red><b>".$globalp->{_WFNOACTUALPASS}."</b></font><br><br>";
			&Change_wf_Password_Form;
			return;
		}

		if( $fdat{npwd} =~ /[^"$globalp->{permited_wf_pwdchars}"]/g ) {
			$passmessage = "<font color=red><b>".$globalp->{_WFNOCHARFORPASS}." $globalp->{permited_wf_pwdchars}</b></font><br><br>";
			&Change_wf_Password_Form;
			return;
		}

		$sthresult = $globalp->{dbh} -> prepare ("select ResourceID, ResourceName, Login, Psw from ".$globalp->{table_prefix}."_reports_users where Login ='$fdat{login}' ")  or die "Cannot SELECT from Resource ";
		$sthresult -> execute  or die "Cannot execute SELECT from Resource";
		$sthresult -> bind_columns(undef, \$Rid, \$Rname, \$Login, \$psw);
		$datresult = $sthresult -> fetchrow_arrayref;
		$sthresult -> finish();

		$pwd = md5_hex($fdat{apwd});

		if( $psw ne $pwd ) {
			$passmessage = "<font color= red>".$globalp->{_WFPASSINCORRECT}."</font>";
			&Change_wf_Password_Form;
		}

		if( $fdat{login} eq $fdat{npwd}) {
			$passmessage = "<font color=red><b>".$globalp->{_WFIDNOPASS}."</b></font><br><br>";
			&Change_wf_Password_Form;
			return;
		}

		if( length($fdat{npwd}) < $globalp->{min_wf_password_length} ) {
			$passmessage = "<font color= red>".$globalp->{_WFPASSLENTH}." $globalp->{min_wf_password_length} ".$globalp->{_WFPASSLENTH1}."</font>";
			&Change_wf_Password_Form;
		}

		if( $fdat{npwd} ne $fdat{rnpwd} ) {
			$passmessage = "<font color= red>".$globalp->{_WFNOTRETYPED}."</font>";
			&Change_wf_Password_Form;
		}

		$npwd = md5_hex($fdat{npwd});

		if( $psw eq $npwd ) {
			$passmessage = "<font color= red>".$globalp->{_WFSAMEPASS}."</font>";
			&Change_wf_Password_Form;
		}

		$globalp->{dbh}->do("update ".$globalp->{table_prefix}."_reports_users set Psw='$npwd' where Login ='$fdat{login}'") or die "Can Not Update Password";
		@the_cvalues = $globalp ->{set_the_cookie}($Rid, $Login, $psw, $Rname);
		$globalp->{siteheader}();
		$globalp->{theheader}();
		local $escmode = 0;
		echo("<br> ".$globalp->{_WFPASSCHANGED}." <a href=\"index.prc?module=EplSiteReports\">".$globalp->{_WFMAINMENU}."</a> &nbsp;");
		delete $fdat{option};
		$globalp->{thefooter}();
		$globalp->{sitefooter}();
		$globalp->{clean_exit}();
	}



	sub wflogin_in
	{
		my $nrows = 0;
		use Digest::MD5  qw(md5_hex);

		$sthresult = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_reports_users where Login ='$fdat{login}' ")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_reports_users ";
		$sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_reports_users";
		$sthresult -> bind_columns(undef, \$nrows);
		$datresult = $sthresult -> fetchrow_arrayref;
		$sthresult -> finish();

		if( $nrows == 0 ) {
			$globalp->{siteheader}();$globalp->{theheader}();

			echo("<font color=red><b>".$globalp->{_NORESOURCE}."</b></font><br><br>");
			&wflogin;$globalp->{thefooter}();$globalp->{sitefooter}();$globalp->{clean_exit}();
		}

		$sthresult = $globalp->{dbh} -> prepare ("select ResourceID, ResourceName, Login, Psw from ".$globalp->{table_prefix}."_reports_users where Login ='$fdat{login}'")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_reports_users";
		$sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_reports_users";
		$sthresult -> bind_columns(undef, \$Rid, \$Rname, \$Login, \$psw);
		$datresult = $sthresult -> fetchrow_arrayref;
		$sthresult -> finish();

		if( $globalp->{use_eplsite_password} == 1 ) {
			$sthresult1 = $globalp->{dbh} -> prepare ("select pass from ".$globalp->{table_prefix}."_users where uname='$fdat{login}'")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_users";
			$sthresult1 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_users";
			$sthresult1 -> bind_columns(undef, \$psw);
			$datresult1 = $sthresult1 -> fetchrow_arrayref;
			$sthresult1 -> finish();
		}

		$pwd = md5_hex($fdat{pwd});

		if( $psw ne $pwd ) {
			$globalp->{siteheader}();$globalp->{theheader}();

			echo("<font color=red><b>".$globalp->{_NORESOURCEPASS}."</b></font><br><br>");
			&wflogin;$globalp->{thefooter}();$globalp->{sitefooter}();$globalp->{clean_exit}();
		}

		@the_cvalues = $globalp ->{set_the_cookie}($Rid, $Login, $psw, $Rname);
		delete $fdat{option};
		return(@the_cvalues);
	}



	sub wfauth
	{
		local $nrows = 0;
		@the_cvalues = $globalp->{get_the_cookie}() if( scalar(@the_cvalues)==0 );
		$sthresult = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_reports_users where Login ='$the_cvalues[1]' ")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_reports_users ";
		$sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_reports_users";
		$sthresult -> bind_columns(undef, \$nrows);
		$datresult = $sthresult -> fetchrow_arrayref;
		$sthresult -> finish();

		if( $nrows == 0 ) {
			$globalp->{siteheader}();
			$globalp->{theheader}();
			&wflogin;
			$globalp->{thefooter}();
			$globalp->{sitefooter}();
			$globalp->{clean_exit}();
			@the_cvalues=("0","1","2");
			$disp_login = 1;
		}

		if( $disp_login != 1) {
			$sthresult = $globalp->{dbh} -> prepare ("select ResourceID, ResourceName, Login, Psw from ".$globalp->{table_prefix}."_reports_users where Login ='$the_cvalues[1]' ")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_reports_users";
			$sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_reports_users";
			$sthresult -> bind_columns(undef, \$Rid, \$Rname, \$Login, \$psw);
			$datresult = $sthresult -> fetchrow_arrayref;
			$sthresult -> finish();

			if( $globalp->{use_eplsite_password} == 1 ) {
				$sthresult1 = $globalp->{dbh} -> prepare ("select pass from ".$globalp->{table_prefix}."_users where uname='$the_cvalues[1]'")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_users";
				$sthresult1 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_users";
				$sthresult1 -> bind_columns(undef, \$psw);
				$datresult1 = $sthresult1 -> fetchrow_arrayref;
				$sthresult1 -> finish();
			}

			if( $psw ne $the_cvalues[2] ) {
				$globalp->{siteheader}();
				$globalp->{theheader}();
				&wflogin;
				$globalp->{thefooter}();
				$globalp->{sitefooter}();
				$globalp->{clean_exit}();
				$disp_login = 1;
				@the_cvalues=("0","1","2");
			}
			if( $disp_login != 1) {
				@the_cvalues = $globalp ->{set_the_cookie}($Rid, $Login, $psw, $Rname);
			}
		}


		return(@the_cvalues);
	}




	$globalp->{specialchars} =
	sub
	{
		local $thechars = shift;
		$thechars=~ s/-/zzzkkkzzz/g;
		$chr10 = chr(10);
		$thechars =~ s/$chr10/zzzzbrzzzz/g;

		$chr13 = chr(13);
		$thechars =~ s/$chr13/zzzzbrzzzz/g;

		if( $thechars =~ /[^"$globalp->{permitedchars}"]/g ) {
			return("stop");
		} else {
			return("");
		}
	};



	sub create_report_header
	{
		my $MyHeaderLine = shift; 
		my $ReportFileName = shift;
		my $ReportFileExtension = shift;

		print "Pragma:no-cache\n";
		print "Expires:0\n";
		print "Content-Disposition: attachment; filename=".$ReportFileName.".".$ReportFileExtension."\n";
		print "Content-Type: application/octetstream\n\n";
		print $MyHeaderLine."\n";		
	}



	sub set_parameters_to_export_report_no_header
	{
		my $ReportFileName = shift;
		my $ReportFileExtension = shift;

		print "Pragma:no-cache\n";
		print "Expires:0\n";
		print "Content-Disposition: attachment; filename=".$ReportFileName.".".$ReportFileExtension."\n";
		print "Content-Type: application/octetstream\n\n";
	}


	sub Clean_Special_Chars
	{
		my $DescToClean = shift;
		
		$DescToClean =~ s/�/-a-/g;
		$DescToClean =~ s/�/-e-/g;
		$DescToClean =~ s/�/-i-/g;
		$DescToClean =~ s/�/-o-/g;
		$DescToClean =~ s/�/-u-/g;
		$DescToClean =~ s/�/--A--/g;
		$DescToClean =~ s/�/--E--/g;
		$DescToClean =~ s/�/--I--/g;
		$DescToClean =~ s/�/--O--/g;
		$DescToClean =~ s/�/--U--/g;
		$DescToClean =~ s/�/---a/g;
		$DescToClean =~ s/�/---e/g;
		$DescToClean =~ s/�/---i/g;
		$DescToClean =~ s/�/---o/g;
		$DescToClean =~ s/�/---u/g;
		$DescToClean =~ s/�/---A/g;
		$DescToClean =~ s/�/---E/g;
		$DescToClean =~ s/�/---I/g;
		$DescToClean =~ s/�/---O/g;
		$DescToClean =~ s/�/---U/g;
		$DescToClean =~ s/�/--c--/g;
		$DescToClean =~ s/�/--n--/g;
		$DescToClean =~ s/�/--N--/g;

		$DescToClean =~ s/[^[:print:]]/_/g;

		$DescToClean =~ s/--c--/�/g;
		$DescToClean =~ s/--n--/�/g;
		$DescToClean =~ s/--N--/�/g;
		$DescToClean =~ s/-a-/�/g;
		$DescToClean =~ s/-e-/�/g;
		$DescToClean =~ s/-i-/�/g;
		$DescToClean =~ s/-o-/�/g;
		$DescToClean =~ s/-u-/�/g;
		$DescToClean =~ s/--A--/�/g;
		$DescToClean =~ s/--E--/�/g;
		$DescToClean =~ s/--I--/�/g;
		$DescToClean =~ s/--O--/�/g;
		$DescToClean =~ s/--U--/�/g;
		$DescToClean =~ s/---a/�/g;
		$DescToClean =~ s/---e/�/g;
		$DescToClean =~ s/---i/�/g;
		$DescToClean =~ s/---o/�/g;
		$DescToClean =~ s/---u/�/g;
		$DescToClean =~ s/---A/�/g;
		$DescToClean =~ s/---E/�/g;
		$DescToClean =~ s/---I/�/g;
		$DescToClean =~ s/---O/�/g;
		$DescToClean =~ s/---U/�/g;
		
		return ( $DescToClean );
	}





	sub CloseReportConnection
	{
		my $DBConnectionReport = shift;
		if( defined( $DBConnectionReport ))
		{
            eval {
			$DBConnectionReport->disconnect();};
            undef $DBConnectionReport if($@);
		}		
		$globalp{clean_exit};
	}



	sub get_xref_for_report
	{
		my $myxreftype = shift; my $myoldvalue = shift;
		
		$myoldvalue =~ s/'/''/g;
		my $my_new_value = "";
		
		@xrefvalues = split('\|',$myoldvalue);
		$myxrefsize = $#xrefvalues + 1;
		$XrefQuery = "SELECT to_value";
		$XrefQuery .= " FROM ".$globalp->{table_prefix}."_mf_xreftable";
		$XrefQuery .= " WHERE xreftype = '$myxreftype'";
		$XrefQuery .= " AND from_value='$xrefvalues[0]'";
		
		if( $myxrefsize > 1 )
		{
			$XrefQuery .= " AND from_value1='$xrefvalues[1]'";
		}
		
		$xrefsthresult = $globalp->{dbh} -> prepare ( $XrefQuery )  or die "Cannot prepare query: $XrefQuery";
		$xrefsthresult -> execute  or die "Cannot execute query: $XrefQuery";
		$xrefsthresult -> bind_columns( undef, \$to_value );

		if( $xrefdatresult = $xrefsthresult -> fetchrow_arrayref ) 
		{
			$my_new_value = $to_value;
		}
	
		return($my_new_value);
	}





	sub wfmenu
	{
		#~ echo("<!-- wfmenu -->");

		@the_cvalues = $globalp->{get_the_cookie}() if( scalar(@the_cvalues)==0 );

		#echo("mCookie es: $the_cvalues[0],$the_cvalues[1],$the_cvalues[2]; and the option is:$fdat{option}"; $globalp->{clean_exit}();
		$globalp->{siteheader}();
		$globalp->{theheader}();

		$globalp->{OpenTable}();
		echo("<center><font class=\"title\"><b>".$globalp->{_WFMAINMENU}."</b></font></center>\n");
		$globalp->{CloseTable}();
		echo("<br>");

		$globalp->{OpenTable}();
		echo("<table>");
        
		$SelectQuery = "SELECT ReportGroupID, ReportGroupDescription";
        $SelectQuery .= " FROM ".$globalp->{table_prefix}."_report_groups";
        $SelectQuery .= " ORDER BY ReportGroupDescription";
        
		$sthresult = $globalp->{dbh} -> prepare ($SelectQuery) 
        or die "Cannot prepare query:$SelectQuery";
		$sthresult -> execute  or die "Cannot execute query:$SelectQuery";
		$sthresult -> bind_columns(undef, \$ReportGroupID,\$ReportGroupDescription);
        
		while( $datresult = $sthresult -> fetchrow_arrayref ) 
        {
            echo("<form action=\"index.prc\" method=\"post\">\n"
			."<input type=\"hidden\" name=\"module\" value=\"EplSiteReports\">\n"
			."<input type=\"hidden\" name=\"option\" value=\"executereport\">\n"
			."<tr><th colspan=\"2\">"
			."<h3>Reports Group: $ReportGroupDescription</h3></th></tr>"
			."<tr><td><b>Report List:</b></td><td>\n"
			." <select name=\"ReportID\"><option value=\"\">Select Report</option>\n");
                    
                    
            $SelectQuery = "SELECT ReportID, ReportScript, ReportDescription"; 
            $SelectQuery .= " FROM ".$globalp->{table_prefix}."_reports_definition"; 
            $SelectQuery .= " WHERE ReportGroupID = ".$ReportGroupID;
            $SelectQuery .= " ORDER BY ReportDescription";
            
            $sthresultr = $globalp->{dbh} -> prepare ($SelectQuery)
            or die "Cannot prepare query: $SelectQuery";
            $sthresultr -> execute  or die "Cannot execute query: $SelectQuery";
            $sthresultr -> bind_columns(undef, \$ReportID,\$ReportScript,\$ReportDescription);
        

            while( $datresultr = $sthresultr -> fetchrow_arrayref ) 
            {
                echo("<option value=\"$ReportID\">$ReportDescription</option>\n");
            }
            $sthresultr -> finish();
            echo("</select>"
            ." &nbsp;<input type=\"submit\" VALUE=\"Execute\">\n"
            ."</form>\n"
            ."</td></tr><tr><td colspan=\"2\"</td><hr width=\"50%\"></td></tr>\n"
            ."<tr><td>&nbsp;</td><td>&nbsp;</td></tr>");
        }
		$sthresult -> finish();
        		
		echo("</table>\n");
				 
		$globalp->{CloseTable}();
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
	}




	sub Display_reports_Error	
	{
		my $MyErrorToDisplay = shift;
		my $MyDBConnection = shift;
		
		if( defined( $MyDBConnection ))
		{
			$MyDBConnection->disconnect();			
		}
		
		$globalp->{siteheader}();
		$globalp->{theheader}();
		$globalp->{OpenTable}();
		
		@the_cvalues = $globalp->{get_the_cookie}();		

		echo($MyErrorToDisplay."<br> $globalp->{_GOBACK} <br>");

		$globalp->{CloseTable}();
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
		$globalp->{clean_exit}();							
	}



	sub Display_reports_Error_Text	
	{
		my $MyErrorToDisplay = shift;
		my $MyDBConnection = shift;
		
		if( defined( $MyDBConnection ))
		{
			$MyDBConnection->disconnect();			
		}
				
		@the_cvalues = $globalp->{get_the_cookie}();		

		print $MyErrorToDisplay."\n";

		$globalp->{clean_exit}();							
	}




    @the_cvalues = &wflogin_in() if( $fdat{option} eq "login" );

    #echo("Cookie es: $the_cvalues[0],$the_cvalues[1],$the_cvalues[2],$the_cvalues[3]"); $globalp->{clean_exit}();
    @the_cvalues = $globalp->{get_the_cookie}() if( scalar(@the_cvalues)==0 );
	#echo("Cookie es: $the_cvalues[0],$the_cvalues[1],$the_cvalues[2],$the_cvalues[3]\n"); $globalp->{clean_exit}();
    if( ( ($the_cvalues[0] eq "0" ) && ( $the_cvalues[1] eq "1" ) && ( $the_cvalues[2] eq "2" ) )
        || ( ($the_cvalues[0] eq "" ) && ( $the_cvalues[1] eq "" ) && ( $the_cvalues[2] eq "" ) ) ) 
	{
       @the_cvalues = $globalp->{get_the_cookie}();
       #echo("1Cookie es: $the_cvalues[0],$the_cvalues[1],$the_cvalues[2]; and the option is:$fdat{option}"; $globalp->{clean_exit}();
       if( ($the_cvalues[0] eq "0" ) && ( $the_cvalues[1] eq "1" ) && ( $the_cvalues[2] eq "2" ) ) 
	   {
           $globalp->{siteheader}();
           $globalp->{theheader}();
           &wflogin;
           $globalp->{thefooter}();
           $globalp->{sitefooter}();
           $globalp->{clean_exit}();
           $disp_login = 1;
       }
    }

    if( $disp_login != 1) 
	{
			#echo("2Cookie es: $the_cvalues[0],$the_cvalues[1],$the_cvalues[2]; and the option is:$fdat{option}"; $globalp->{clean_exit}();
			#&wfauth if( $fdat{option} ne "" && $fdat{option} ne "login" );
			@the_cvalues = &wfauth;
			if( ( ($the_cvalues[0] eq "0" ) && ( $the_cvalues[1] eq "1" ) && ( $the_cvalues[2] eq "2" ) )
			|| ( ($the_cvalues[0] eq "" ) && ( $the_cvalues[1] eq "" ) && ( $the_cvalues[2] eq "" ) ) ) 
			{
					$a = 1;
			} 
			else 
			{
				#echo("3Cookie es: $the_cvalues[0],$the_cvalues[1],$the_cvalues[2]; and the option is:$fdat{option}"; $globalp->{clean_exit}();
				if( $fdat{chgpasswd} eq "chgpassform" ) { &Change_wf_Password_Form; }
				elsif( $fdat{chgpasswd} eq "chgpass" ) { &Change_wf_Password; }
			
				if( !defined($fdat{option}) ) { &wfmenu ;}
				elsif( $fdat{option} eq "executereport")
				{
					$error = "";
					
					if( defined($fdat{ReportID}) && $fdat{ReportID} ne "" )
					{					
						$SelectQuery = "SELECT a.ReportScript, b.ReportGroupDescription,";
						$SelectQuery .= " a.ReportDescription, a.ReportPerlScript";
						$SelectQuery .= " FROM ".$globalp->{table_prefix}."_reports_definition a";
						$SelectQuery .= " , eplsite_report_groups b";
						$SelectQuery .= " WHERE a.ReportGroupID = b.ReportGroupID";
						$SelectQuery .= " AND a.ReportID = ".$fdat{ReportID};
						
						$sthresult = $globalp->{dbh}-> prepare ($SelectQuery) 
						or die "Cannot prepare query:$SelectQuery";
						$sthresult -> execute  or die "Cannot execute query:$SelectQuery";
						$sthresult -> bind_columns(undef, \$ReportScript, \$ReportGroupDescription,
						\$ReportDescription, \$ReportPerlScript);
						$datresult = $sthresult -> fetchrow_arrayref ();
						$sthresult -> finish();	
						 
						$ReportScriptTemp = $ReportPerlScript;
						$ReportScriptTemp =~ s/^\s+//; #remove leading spaces
						$ReportScriptTemp =~ s/\s+$//; #remove trailing spaces
							
							
						if( $ReportScriptTemp eq "" )
						{
							$error = "Report Script:<b>".$ReportScript."</b> Has No Perl Code To Execute.<br><br>"
						}
						else
						{
							$ReportPerlScriptError = $globalp->{EplSitePerlCheckSyntax}($ReportPerlScript,"ReportPerlScript");
							if( $ReportPerlScriptError ne "")
							{
								$error = "<b>Report Perl Script <font color=\"red\"><i>".$ReportScript."</i></font> Has Errors:</b><br> " . $ReportPerlScriptError ."<br>";
								$error .= "Go to <a href=\"admin.prc?option=EplSiteETLManager\">EplSite Reports Manager control panel</a> to edit and fix this error.<br><br>";
							}
						}
					}
					else
					{
						$error .= "Report Not Selected.<br><br>";
					}
					
					if( $error eq "" )
					{
						#No error so far, execute report.
						eval $ReportPerlScript;
						
						if($@)
						{
							$globalp->{siteheader}();
							$globalp->{theheader}();
							$globalp->{OpenTable}();
							
							@the_cvalues = $globalp->{get_the_cookie}();		

							echo($@."<br><br>".$globalp->{_GOBACK}."<br>");

							$globalp->{CloseTable}();
							$globalp->{loggedon_as}();
							$globalp->{sitefooter}();
							$globalp->{clean_exit}();								
						}						
					}
					else
					{
						$globalp->{siteheader}();
						$globalp->{theheader}();
						$globalp->{OpenTable}();
						
						@the_cvalues = $globalp->{get_the_cookie}();		

						echo("$error <br> $globalp->{_GOBACK} <br>");			

						$globalp->{CloseTable}();
						$globalp->{loggedon_as}();
						$globalp->{sitefooter}();
						$globalp->{clean_exit}();	
					}					
				}
				elsif( $fdat{option} eq "logout" ){ &wflogout; }
				else { &wfmenu ;}
			}
	}

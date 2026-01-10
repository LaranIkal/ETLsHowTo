########################################################################
# Eplsite,Subroutines for ETL module
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



	$globalp->{loggedon_as} =
	sub
	{
		local $escmode = 0;
		$the_cvalues[3]=~ s/\+/ /g;
		echo("<br>");
		if( $fdat{option} ne "logout" ) {
			$globalp->{OpenTable}();
			echo("<b>".$globalp->{_WFLOGGEDAS}."</b> <u>$the_cvalues[0] - $the_cvalues[3]</u>\n"
					 ." &nbsp;<strong><big>&middot;</big></strong> <a href=\"index.prc?module=EplSiteETL\">".$globalp->{_WFHOME}."</a>\n"
					 ." &nbsp;&nbsp;<strong><big>&middot;</big></strong> <a href=\"index.prc?module=EplSiteETL&option=logout\">".$globalp->{_WFLOGOUT}."</a>\n");

			if( $globalp->{use_eplsite_password} == 0 ) {
				echo(" <strong><big>&middot;</big></strong> <a href=\"index.prc?module=EplSiteETL&chgpasswd=chgpassform\">".$globalp->{_WFCHGPASS}."</a>\n");
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
			&set_cookie("MVUserData",$info1,"-1", "", "", 0);
		} else {
			&set_cookie("MVUserData",$info1,$globalp{wfsession_expire_time}, "", "", 0);
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
				 ."<tr><td>".$globalp->{_NICKNAME}."(default:eplsite):</td>\n"
				 ."<td><input type=\"text\" NAME=\"login\" value=\"$fdat{login}\" SIZE=\"20\" MAXLENGTH=\"100\"></td></tr>\n"
				 ."<tr><td>".$globalp->{_PASSWORD}."(default:eplsite):</td>\n"
				 ."<td><input type=\"password\" NAME=\"pwd\" SIZE=\"20\" MAXLENGTH=\"18\"></td></tr>\n"
				 ."<tr><td>\n"
				 ."<input type=\"hidden\" NAME=\"option\" value=\"login\">\n"
				 ."<input type=\"hidden\" NAME=\"module\" value=\"EplSiteETL\">\n"
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
				 ."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
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
		$sthresult = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_etl_users where Login ='$fdat{login}' ")  or die "Cannot SELECT from Resource ";
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

		$sthresult = $globalp->{dbh} -> prepare ("select ResourceID, ResourceName, Login, Psw from ".$globalp->{table_prefix}."_etl_users where Login ='$fdat{login}' ")  or die "Cannot SELECT from Resource ";
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

		$globalp->{dbh}->do("update ".$globalp->{table_prefix}."_etl_users set Psw='$npwd' where Login ='$fdat{login}'") or die "Can Not Update Password";
		@the_cvalues = $globalp ->{set_the_cookie}($Rid, $Login, $psw, $Rname);
		$globalp->{siteheader}();
		$globalp->{theheader}();
		local $escmode = 0;
		echo("<br> ".$globalp->{_WFPASSCHANGED}." <a href=\"index.prc?module=EplSiteETL\">".$globalp->{_WFMAINMENU}."</a> &nbsp;");
		delete $fdat{option};
		$globalp->{thefooter}();
		$globalp->{sitefooter}();
		$globalp->{clean_exit}();
	}



	sub wflogin_in
	{
		my $nrows = 0;
		use Digest::MD5  qw(md5_hex);

		$sthresult = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_etl_users where Login ='$fdat{login}' ")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_etl_users ";
		$sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_etl_users";
		$sthresult -> bind_columns(undef, \$nrows);
		$datresult = $sthresult -> fetchrow_arrayref;
		$sthresult -> finish();

		if( $nrows == 0 ) {
			$globalp->{siteheader}();$globalp->{theheader}();

			echo("<font color=red><b>".$globalp->{_NORESOURCE}."</b></font><br><br>");
			&wflogin;$globalp->{thefooter}();$globalp->{sitefooter}();$globalp->{clean_exit}();
		}

		$sthresult = $globalp->{dbh} -> prepare ("select ResourceID, ResourceName, Login, Psw from ".$globalp->{table_prefix}."_etl_users where Login ='$fdat{login}'")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_etl_users";
		$sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_etl_users";
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
		@the_cvalues = $globalp->{get_the_cookie}() if( !(@the_cvalues) );
		$sthresult = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_etl_users where Login ='$the_cvalues[1]' ")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_etl_users ";
		$sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_etl_users";
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
			$sthresult = $globalp->{dbh} -> prepare ("select ResourceID, ResourceName, Login, Psw from ".$globalp->{table_prefix}."_etl_users where Login ='$the_cvalues[1]' ")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_etl_users";
			$sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_etl_users";
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
		print "Content-Disposition: attachment; filename=\"".$ReportFileName.".".$ReportFileExtension."\"\n";
		print "Content-Type: application/octetstream\n\n";
		if( $MyHeaderLine ne "" )
		{
			print $MyHeaderLine."\n";		
		}
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




	sub Clean_Non_Printable_Chars
	{
		my $FieldToClean = shift;
		
		$FieldToClean =~ s/[^[:print:]]//g;
		
		return ( $FieldToClean );
	}
	
	

	sub Clean_Special_Chars
	{
		my $DescToClean = shift;
		
		$DescToClean =~ s/\E4/-a-/g;
		$DescToClean =~ s/\EB/-e-/g;
		$DescToClean =~ s/\EF/-i-/g;
		$DescToClean =~ s/\F6/-o-/g;
		$DescToClean =~ s/\FC/-u-/g;
		#$DescToClean =~ s/\C4/--A--/g;
		#$DescToClean =~ s/\CB/--E--/g;
		#$DescToClean =~ s/\CF/--I--/g;
		$DescToClean =~ s/\D6/--O--/g;
		$DescToClean =~ s/\DC/--U--/g;
		$DescToClean =~ s/\E1/---a/g;
		$DescToClean =~ s/\E9/---e/g;
		$DescToClean =~ s/\ED/---i/g;
		$DescToClean =~ s/\F3/---o/g;
		$DescToClean =~ s/\FA/---u/g;
		#$DescToClean =~ s/\C1/---A/g;
		#$DescToClean =~ s/\C9/---E/g;
		#$DescToClean =~ s/\CD/---I/g;
		$DescToClean =~ s/\D3/---O/g;
		$DescToClean =~ s/\DA/---U/g;
		$DescToClean =~ s/\E7/--c--/g;
		$DescToClean =~ s/\F1/--n--/g;
		$DescToClean =~ s/\D1/--N--/g;

		$DescToClean =~ s/[^[:print:]]/_/g;

		$DescToClean =~ s/--c--/\E7/g;
		$DescToClean =~ s/--n--/\F1/g;
		$DescToClean =~ s/--N--/\D1/g;
		$DescToClean =~ s/-a-/\E4/g;
		$DescToClean =~ s/-e-/\EB/g;
		$DescToClean =~ s/-i-/\EF/g;
		$DescToClean =~ s/-o-/\F6/g;
		$DescToClean =~ s/-u-/\FC/g;
		$DescToClean =~ s/--A--/\C4/g;
		$DescToClean =~ s/--E--/\CB/g;
		$DescToClean =~ s/--I--/\CF/g;
		$DescToClean =~ s/--O--/\D6/g;
		$DescToClean =~ s/--U--/\DC/g;
		$DescToClean =~ s/---a/\E1/g;
		$DescToClean =~ s/---e/\E9/g;
		$DescToClean =~ s/---i/\ED/g;
		$DescToClean =~ s/---o/\F3/g;
		$DescToClean =~ s/---u/\FA/g;
		$DescToClean =~ s/---A/\C1/g;
		$DescToClean =~ s/---E/\C9/g;
		$DescToClean =~ s/---I/\CD/g;
		$DescToClean =~ s/---O/\D3/g;
		$DescToClean =~ s/---U/\DA/g;
		
		return ( $DescToClean );
	}





	sub CloseExtractScript
	{
		my $MyDBConnection = shift;
		if( defined( $MyDBConnection ))
		{
            eval { $MyDBConnection->disconnect(); };
            undef $MyDBConnection if($@);
		}		
		$globalp{clean_exit};
		delete $fdat{option};
		#~ &redirect_url_to("index.prc?module=EplSiteETL&amp;servertype=$fdat{servertype}&amp;option=$fdat{option}&amp;company=$fdat{company}&amp;ReportID=$fdat{ReportID}&amp;reportoption=");
	}




	sub EplSiteETLMainMenu
	{
		$globalp->{OpenTable}();
		echo("<center><font class=\"title\"><b>".$globalp->{_WFMAINMENU}."</b></font></center>\n");
		echo("<table Align=Center><tr>\n");
		
		echo("<td><strong><big>&middot;</big></strong>\n"
				."<a href=\"index.prc?module=EplSiteETL&option=generalpurposetable\" target=\"_blank\">\n"
				."Gen. Purpose Table.</a></td>\n");
		               
		echo("<td> <strong><big>&middot;</big></strong>\n"
				."<a href=\"index.prc?module=EplSiteETL&option=execquery\" target=\"_blank\">\n"
				."EplSite SQL Query Tool.</a></td>\n");
				
		echo("<td> <strong><big>&middot;</big></strong>\n"
				."<a href=\"index.prc?module=EplSiteETL&option=xrefs\" target=\"_blank\">\n"
				.$globalp->{_MFXREFFILES}."</a></td>\n");

		echo("<form action=\"index.prc\" method=\"post\">\n"
				."<td> <strong><big>&middot;</big></strong>"		
				."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
				."<input type=\"hidden\" name=\"option\" value=\"DisplaySchemeMenu\">\n"
				."<select id=\"ETLSchemeID\" name=\"ETLSchemeID\" onChange='JavaScript:xmlhttpPostData(\"index.prc\",this.form,\"ETLSchemeMenu\",this,\"ETLSchemeID\")'>"
				."<option selected value=\"\">Select EplSite ETL Scheme To Display Menu</option>\n");
			 
		$selectquery = "SELECT ETLSchemeID, ETLSchemeCode, ETLSchemeDescription";
        $selectquery .= " FROM ".$globalp->{table_prefix}."_etl_schemes";
        $selectquery .= " ORDER BY ETLSchemeCode";
		#~ echo($selectquery); exit;
		$resulti = $globalp->{dbh} -> prepare ($selectquery)  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_schemes: $selectquery";
		$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_etl_schemes";
		$resulti -> bind_columns(undef, \$ETLSchemeID, \$ETLSchemeCode, \$ETLSchemeDescription);

		while( $datresulti = $resulti -> fetchrow_arrayref )
		{
			echo("<option value=\"$ETLSchemeID\">$ETLSchemeID - $ETLSchemeCode - $ETLSchemeDescription</option>\n");
		}
		$resulti->finish();
		echo("</select></form></td>\n");

		echo("</tr></table>\n");
		$globalp->{CloseTable}();
		
	}


    
    

	sub Display_Extract_Error	
	{
		local $ErrorToDisplay = shift;
		my $DisplayTo = shift;        
        
        if( lc($globalp->{All_Trim}($DisplayForErrors)) eq "screen" )
        {
            echo("<p><b><font color=\"red\">Validation Errors Found</font></b>:"
            ."<br><br>$ErrorToDisplay</p>");
        }
        else
        {
            if( $ENV{BATCH_PROCESS} == 1 )
            {
                if( $globalp{OutputFileOpen} )
                {
                    print _ETLFILEHANDLER $ErrorToDisplay."\n";
                }
            }
            else
            {
                print $ErrorToDisplay."\n";
            }
        }
		$globalp->{clean_exit}();							
	}




sub ETL_ExitTransformationProcess {

  $globalp->{clean_exit}() if( $fdat{DBConnTargetID} == 3333 or $ENV{BATCH_PROCESS} == 1 );

  if( defined( $globalp->{ExitTransformationProcessWhenFinished} ) ) {
    if( $globalp->{ExitTransformationProcessWhenFinished} eq "No" ) { return(true); }
  }

  $globalp->{cleanup}();
  &redirect_url_to("http://");

  # if( $fdat{DBConnTargetID} == 3333 or $ENV{BATCH_PROCESS} == 1 ) {
  #   $globalp->{clean_exit}();
  # } else {
  #   $globalp->{cleanup}();
  #   &redirect_url_to("http://");
  # }
}




	sub ETLWriteTransformationLog
	{
		my $SchemeCode = shift;
		my $TransCode = shift;
		my $LogMessage = shift;
		my $RunNumber = 0;
		
		my @login_values = $globalp->{get_the_cookie}();
		
		if( $globalp->{isspace}($login_values[1]) or $login_values[1] == 1 )
		{
			$login_values[1] = "N/A";
		}
		
		if(not defined($fdat{runnumber}) or $fdat{runnumber} eq "" )
		{
			my $SelectQuery = "SELECT RunNumber";
			$SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_transformations_log";
			$SelectQuery .= " ORDER BY RunNumber DESC";
			my $sthresult = $globalp->{dbh} -> prepare ($SelectQuery)
			or die "Cannot prepare query:$SelectQuery";
			$sthresult -> execute or die "Cannot execute query:$SelectQuery";
			$sthresult -> bind_columns(undef, \$RunNumber );
			my $datresult = $sthresult -> fetchrow_arrayref ();
			$sthresult -> finish();
			$RunNumber +=1;
			$fdat{runnumber} = $RunNumber;
		}
		
		$LogMessage =~ s/'/''/g;
		
		my $InsertQuery = "INSERT INTO ".$globalp->{table_prefix};
		$InsertQuery .= "_etl_transformations_log VALUES (";
		$InsertQuery .= $fdat{runnumber}.",".$globalp->{GetLogDateTime}();
		$InsertQuery .= ",'".$login_values[1]."','".$SchemeCode."'";
		$InsertQuery .= ",'".$TransCode."','".$LogMessage."')";

		$globalp->{dbh}->do( $InsertQuery );		
	}
	






	sub prepare_check_xref_error_log
	{
		my $SelectQuery = "SELECT COUNT(*)";
		$SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_xreferror_log";
		$SelectQuery .= " WHERE RunNumber = ?";
		$SelectQuery .= " AND FieldDescription=?";
		$SelectQuery .= " AND ActualValue1=?";
		$SelectQuery .= " AND ActualValue2=?";
		        
		$globalp->{xreflogsthresultcount} = $globalp->{dbh} -> prepare ( $SelectQuery ) 
        or die "Cannot prepare query:$SelectQuery \n\n <br><br> $DBI::errstr";       
    }


	sub ETLWriteXRefErrorLog
	{
		my $SchemeCode = shift;
		my $TransCode = shift;
		my $FieldDesc = shift;
		my $FieldVal1 = shift;
		my $FieldVal2 = shift;
		my $LogMessage = shift;

		if( not $FieldVal2 )
		{
			$FieldVal2 = "  ";
		}
		
		my @login_values = $globalp->{get_the_cookie}();
		
		if( $globalp->{isspace}($login_values[1]) or $login_values[1] == 1 )
		{
			$login_values[1] = "N/A";
		}
		
		$FieldDesc =~ s/'/''/g;
		$FieldVal1 =~ s/'/''/g;
		$FieldVal2 =~ s/'/''/g;
		$LogMessage =~ s/'/''/g;

		$globalp->{xreflogsthresultcount}-> bind_param(1,$fdat{runnumber});
		$globalp->{xreflogsthresultcount}-> bind_param(2,$FieldDesc);
		$globalp->{xreflogsthresultcount}-> bind_param(3,$FieldVal1);
		$globalp->{xreflogsthresultcount}-> bind_param(4,$FieldVal2);
		
		$globalp->{xreflogsthresultcount}-> execute()
		or die "Cannot execute query. \n\n <br><br> $DBI::errstr";        
		$globalp->{xreflogsthresultcount} -> bind_columns( undef, \$NumOfLogRows );
		my $xreflogdatresult = $globalp->{xreflogsthresultcount}->fetchrow_arrayref();
		
		if( $NumOfLogRows == 0 )
		{
			my $InsertQuery = "INSERT INTO ".$globalp->{table_prefix};
			$InsertQuery .= "_etl_xreferror_log VALUES (";
			$InsertQuery .= $fdat{runnumber}.",".$globalp->{GetLogDateTime}();
			$InsertQuery .= ",'".$login_values[1]."','".$SchemeCode."'";
			$InsertQuery .= ",'".$TransCode."','".$FieldDesc."'";
			$InsertQuery .= ",'".$FieldVal1."','".$FieldVal2."'";
			$InsertQuery .= ",'".$LogMessage."')";

			$globalp->{dbh}->do( $InsertQuery );
		}
	}







	sub prepare_check_catalogs_error_log
	{
		my $SelectQuery = "SELECT COUNT(*)";
		$SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_catalogerror_log";
		$SelectQuery .= " WHERE RunNumber = ?";
		$SelectQuery .= " AND FieldDescription=?";
		$SelectQuery .= " AND CatalogValue1=?";
		$SelectQuery .= " AND CatalogValue2=?";
		        
		$globalp->{catalogslogsthresultcount} = $globalp->{dbh} -> prepare ( $SelectQuery ) 
        or die "Cannot prepare query:$SelectQuery \n\n <br><br> $DBI::errstr";       
    }


	sub ETLWriteCatalogErrorLog
	{
		my $SchemeCode = shift;
		my $TransCode = shift;
		my $FieldDesc = shift;
		my $FieldVal1 = shift;
		my $FieldVal2 = shift;
		my $LogMessage = shift;		
		
		if( not $FieldVal2 )
		{
			$FieldVal2 = "  ";
		}
		
		my @login_values = $globalp->{get_the_cookie}();
		
		if( $globalp->{isspace}($login_values[1]) or $login_values[1] == 1 )
		{
			$login_values[1] = "N/A";
		}
		
		$FieldDesc =~ s/'/''/g;
		$FieldVal1 =~ s/'/''/g;
		$FieldVal2 =~ s/'/''/g;
		$LogMessage =~ s/'/''/g;

		$globalp->{catalogslogsthresultcount}-> bind_param(1,$fdat{runnumber});
		$globalp->{catalogslogsthresultcount}-> bind_param(2,$FieldDesc);
		$globalp->{catalogslogsthresultcount}-> bind_param(3,$FieldVal1);
		$globalp->{catalogslogsthresultcount}-> bind_param(4,$FieldVal2);
		
		$globalp->{catalogslogsthresultcount}-> execute()
		or die "Cannot execute query. \n\n <br><br> $DBI::errstr";        
		$globalp->{catalogslogsthresultcount} -> bind_columns( undef, \$NumOfLogRows );
		my $catalogslogdatresult = $globalp->{catalogslogsthresultcount}->fetchrow_arrayref();
		
		if( $NumOfLogRows == 0 )
		{
			my $InsertQuery = "INSERT INTO ".$globalp->{table_prefix};
			$InsertQuery .= "_etl_catalogerror_log VALUES (";
			$InsertQuery .= $fdat{runnumber}.",".$globalp->{GetLogDateTime}();
			$InsertQuery .= ",'".$login_values[1]."','".$SchemeCode."'";
			$InsertQuery .= ",'".$TransCode."','".$FieldDesc."'";
			$InsertQuery .= ",'".$FieldVal1."','".$FieldVal2."'";
			$InsertQuery .= ",'".$LogMessage."')";

			$globalp->{dbh}->do( $InsertQuery );
		}
	}






	sub EplSiteETL_Create_Header
	{
		my $FileNameFromLayoutDescription = shift;
		my $MyETLSchemeCode = shift;
		my $ETL_TransformationCode = shift; 
		my $MyScriptBeforePrintHeader = shift; 
		my $HShowInMenu = shift;

		$HeaderQuery = "SELECT FieldSequence, FieldDescription";
		$HeaderQuery .= " FROM ".$globalp->{table_prefix}."_etl_export_layouts";
        $HeaderQuery .= " WHERE ETLSchemeCode = '".$MyETLSchemeCode."'";
        $HeaderQuery .= " AND TransformationCode= '".$ETL_TransformationCode."'";        
		$HeaderQuery .= " AND ExportField='Yes'";
        $HeaderQuery .= " ORDER BY FieldSequence";

		$headersthresult = $globalp->{dbh} -> prepare ( $HeaderQuery ) 
        or die "Cannot prepare query:$HeaderQuery";
		$headersthresult -> execute or die "Cannot execute query:$HeaderQuery";
		$headersthresult -> bind_columns(undef, \$TheFieldNumber, \$Transformation_FieldDescription);

		my $myline = "";
		my $MyFieldsLine = "";
		
		$counter = 0;
		$AddPipe = 0;
		while( $headerdatresult = $headersthresult -> fetchrow_arrayref ) 
		{
			$Transformation_FieldDescription = $globalp->{All_Trim}($Transformation_FieldDescription);
			
			if( $Transformation_FieldDescription eq "" )
			{
				$Transformation_FieldDescription = "FieldSequence".$TheFieldNumber;
			}		
				
			if( $counter == 0 )
			{
				$FileNameFromLayoutDescription =~ s/ //g;
				
				if( $fdat{xrefcondition} eq "cleanxrefonly" )
				{				
					$FileNameFromLayoutDescription .= "_Clean_XRef";
				}
				elsif( $fdat{xrefcondition} eq "recordsok" )
				{				
					$FileNameFromLayoutDescription .= "_Clean_XRef_Catalogs_Checked";
				}
				
				#~ if( $fdat{torecord} > 0 )
				#~ {
					#~ $FileNameFromLayoutDescription .= "_From_" . $fdat{fromrecord} . "_To_" . $fdat{torecord};
				#~ }
                            #my $FileName = $globalp->{mfdatadir}."/".$MyETLSchemeCode;
                            #$FileName .= "_".$ETL_TransformationCode."_".$FileNameFromLayoutDescription.".txt";
                           # print "Creating Output File: $FileName\n"; exit;				
				$counter = 1;
                if( not defined($globalp->{DBTargetConn}))
                {  
                    if( $HShowInMenu eq "Yes" )
                    {
                        
                        #print "\$ENV{BATCH_PROCESS}: $ENV{BATCH_PROCESS}, \$globalp{mfdatadir}: $globalp->{mfdatadir}, \$fdat{DBConnTargetID}: $fdat{DBConnTargetID}\n";
                        #exit;
                        if( $ENV{BATCH_PROCESS} == 1 ) {
                          if( $globalp->{mfdatadir} ne "" && $fdat{DBConnTargetID} == 3333 ) {
                            # If $fdat{DBConnTargetID} == 3333 in batch process create the file in the mfdatadir
                            my $FileName = $globalp->{mfdatadir}."/".$MyETLSchemeCode;
                            $FileName .= "_".$ETL_TransformationCode."_".$FileNameFromLayoutDescription.".txt";                            
                            $globalp{OutputFileOpen} = open ( _ETLFILEHANDLER, ">".$FileName)
                            or die "File \"$FileName\" Can Not be Created";
                            binmode _ETLFILEHANDLER;
                            if( $messagesOnScreen eq "Yes" ) {
                              print "Creating Output File For Batch Process: $FileName\n"; #exit;
                            }
                          }
                        } else { # Interactive web process
                          # Creating the headers to download the file, only used on web process
                          print "Pragma:no-cache\n";
                          print "Expires:0\n";
                          print "Content-Disposition: attachment; filename=\"";
                          print $MyETLSchemeCode."_".$ETL_TransformationCode."_".$FileNameFromLayoutDescription.".txt\"\n";
                          print "Content-Type: application/octetstream\n\n";							
                        }
                    }
                }
                
				$MyScriptBeforePrintHeader =~ s/^\s+//; #remove leading spaces
				$MyScriptBeforePrintHeader =~ s/\s+$//; #remove trailing spaces					
				
				if( $MyScriptBeforePrintHeader ne "" )
				{
					eval $MyScriptBeforePrintHeader;#To print something before the file header.
					if( $@)
					{
                        $Error = "There is an error in section BeforePrintHeader script:$@";
						$Error =~ s/\n/<br>/g;
						&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
						&ETL_ExitTransformationProcess();
					}                 
				}
				
			} # Just do this process once in the loop and only 
              #if there is data in the table for this layout.
			
			if( $AddPipe == 0 )
			{
				$AddPipe = 1;
				$myline .=  $TheFieldNumber;
				$MyFieldsLine .= $Transformation_FieldDescription;
			}
			else
			{
				$myline .= "\|" . $TheFieldNumber;
				$MyFieldsLine .= "\|" . $Transformation_FieldDescription;
			}									
		}
		$headersthresult -> finish();
        
		if( defined( $fdat{fileheader} ) 
        && not defined($globalp->{DBTargetConn})) #$fdat{DBConnTargetID} == 3333 
		{            
			if( $fdat{fileheader} eq "descriptive" )
			{
				if( $ENV{BATCH_PROCESS} == 1 && $globalp{OutputFileOpen} )
				{
					print _ETLFILEHANDLER $MyFieldsLine ."\n";
				}
				else
				{
					print $MyFieldsLine ."\n";
				}
			}
			elsif( $fdat{fileheader} eq "numeric" )
			{
				if( $ENV{BATCH_PROCESS} == 1 && $globalp{OutputFileOpen} )
				{
					print _ETLFILEHANDLER $myline."\n";
				}
				else
				{
					print $myline."\n";
				}
			}
			elsif( $fdat{fileheader} eq "both" )
			{
				if( $ENV{BATCH_PROCESS} == 1 && $globalp{OutputFileOpen} )
				{
					print _ETLFILEHANDLER $myline."\n";
					print _ETLFILEHANDLER $MyFieldsLine ."\n";					
				}
				else
				{
					print $myline."\n";
					print $MyFieldsLine ."\n";
				}
			}            
		}
		return( $TheFieldNumber ) ## Returns the last FieldNumber to be processed
	}




	sub Process_Layout_Data
	{		
		my $MyLayoutDescription = shift;
		my $MyETLSchemeCode = shift;
		my $MyLayoutCode = shift;
		my $MyShowInMenu = shift;
    my $MScriptBeforePrintHeader = shift;
        
		if( $CFGTableReady == 0 ) { # Flag to know if the layout setup was already loaded.
			$CFGTableReady = 1;
			
			$QueryCFGData = "SELECT a.FieldSequence, a.ValueType, a.ConstantValue, a.QueryField,";
			$QueryCFGData .= " a.QueryField1ForXRef, a.QueryField2ForXRef, a.xreftype,";
			$QueryCFGData .= " a.TransformationScriptID, a.TransformationScriptParameters,";
			$QueryCFGData .= " b.CatalogTableName, a.FieldDescription";
      $QueryCFGData .= ", a.FieldNumForValidation1, a.FieldNumForValidation2";
      $QueryCFGData .= ", b.Field1ForValidation, b.Field1Type, b.Field2ForValidation";
			$QueryCFGData .=", b.Field2Type, a.ExportField";
			$QueryCFGData .= " FROM ".$globalp->{table_prefix}."_etl_export_layouts a";
			$QueryCFGData .= " LEFT JOIN ".$globalp->{table_prefix}."_etl_catalogs b";
			$QueryCFGData .= " ON b.TableID = a.Catalog";
			$QueryCFGData .= " WHERE a.ETLSchemeCode = '".$MyETLSchemeCode."'";
			$QueryCFGData .= " AND a.TransformationCode= '".$MyLayoutCode."'";
			$QueryCFGData .= " ORDER BY a.FieldSequence";

			$cfgsthresult = $globalp->{dbh} -> prepare ( $QueryCFGData ) 
                      or die "Cannot prepare query:$QueryCFGData";
			$cfgsthresult -> execute  or die "Cannot execute query:$QueryCFGData";
			$cfgsthresult -> bind_columns( undef, \$FieldSequence, \$ValueType
                    , \$ConstantValue, \$QueryField, \$QueryField1ForXRef, \$QueryField2ForXRef
                    , \$xreftype, \$TransformationScriptID, \$TransformationScriptParameters
                    , \$Catalog, \$FieldDescription, \$QueryFieldNumForValidation1
                    , \$QueryFieldNumForValidation2,\$CatalogField1ForValidation
                    , \$CatalogField1Type, \$CatalogField2ForValidation, \$CatalogField2Type, \$ExportField);

			$header = 0;
			$count = 1;
		
			while( $cfgdatresult = $cfgsthresult -> fetchrow_arrayref ) {
				
				if( $header == 0 ) { 
          $header = 1;
          $max_FieldNumber_to_export = &EplSiteETL_Create_Header( $MyLayoutDescription
          , $MyETLSchemeCode, $MyLayoutCode,$ScriptBeforePrintHeader,$MyShowInMenu
          ,$MScriptBeforePrintHeader );
        }
				
				$ValueTypes[$count] = $ValueType;
				$ConstantValues[$count] = $ConstantValue;
				$QueryFields[$count] = $QueryField;
				$FieldMustBeExported[$count] = $ExportField;
				
        $xreftypes[$count] = $xreftype;                
				$QueryField1ForXRefs[$count] = $globalp->{All_Trim}($QueryField1ForXRef);				
				$QueryField2ForXRefs[$count] = $globalp->{All_Trim}($QueryField2ForXRef);				
				
				$Catalogs[$count] = $Catalog;
				$QueryFieldNumForValidations1[$count] = $globalp->{All_Trim}($QueryFieldNumForValidation1);
				$CatalogFieldName1ForValidation[$count] = $globalp->{All_Trim}($CatalogField1ForValidation);
        $CatalogFieldName1TypeForValidation[$count] = $globalp->{All_Trim}($CatalogField1Type);                
				$QueryFieldNumForValidations2[$count] = $globalp->{All_Trim}($QueryFieldNumForValidation2);                
        $CatalogFieldName2ForValidation[$count] = $globalp->{All_Trim}($CatalogField2ForValidation);
        $CatalogFieldName2TypeForValidation[$count] = $globalp->{All_Trim}($CatalogField2Type);
                                
				$FieldDescriptions[$count] = $globalp->{All_Trim}($FieldDescription);
				
				if( $FieldDescriptions[$count] eq "" ) {
					$FieldDescriptions[$count] = "FieldSequence".$count;
				}
				
				if( $ValueType eq "TransformationScript" ) {
					if( $ExportField eq "Yes" ) {
						$selectquery = "SELECT TransformationScriptName, TransformationScript";
						$selectquery .= " FROM ".$globalp->{table_prefix}."_etl_transformationscripts";
						$selectquery .= " WHERE TransformationScriptID = ".$TransformationScriptID;
						
						$resulti = $globalp->{dbh} -> prepare ($selectquery) 
						or die "Cannot prepare query:$selectquery";
						$resulti -> execute  or die "Cannot execute query:$selectquery";
						$resulti -> bind_columns(undef,  \$TransformationScriptName, \$TransformationScript);
						$datresulti = $resulti -> fetchrow_arrayref ;
						$resulti->finish();
						
						$TransformationScriptNames[$count] = $TransformationScriptName;
						$TransformationScriptNames[$count] .= $TransformationScriptParameters;
					

						# Just checking if transofrmation subroutin script has correct syntax.
						eval $TransformationScript;
						if($@) {
							$Error = "There is an error in the transformation script:";
							$Error .= " $TransformationScriptName\n\n:$@";
							$Error =~ s/\n/<br>/g;
							&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
							&ETL_ExitTransformationProcess();
						}
					} else {
						$TransformationScriptNames[$count] = "N/A";
						$TransformationScriptNames[$count] .= "N/A";						
					}
				}
				$count +=1;				
			}
			$cfgsthresult -> finish();
			
			$LastFieldSequence = $FieldSequence;
            
      &prepare_get_xrefnew_value(); #Execute prepare once for xrefs.
			&prepare_check_xref_error_log(); #Execute prepare once for xref error logs.
			&prepare_check_catalogs_error_log(); #Execute prepare once for catalog error logs.
		}

			
		$dataline = "";
		$DataLineWithXRefError = "No";
		
		for( $count = 1; $count <= $LastFieldSequence; $count++) {
			$RecordHasXRefError[$count] = 0;
			my $MyResultValue = 0;
			
			if( $FieldMustBeExported[$count] eq "Yes" ) {
				if( $ValueTypes[$count] eq "ConstantValue" ) {
					$MyResultValue = $ConstantValues[$count];
				} elsif( $ValueTypes[$count] eq "QueryField" ) {
					$MyResultValue =  $QueryFieldNames{$QueryFields[$count]};
				} elsif( $ValueTypes[$count] eq "CrossReference" ) {			
					$MyResultValue = &get_xrefnew_value( $xreftypes[$count]
                          , $QueryFieldNames{$QueryField1ForXRefs[$count]}
                          , $QueryFieldNames{$QueryField2ForXRefs[$count]}
                          , $FieldDescriptions[$count] );
					
					if( $MyResultValue =~ /XRef Not Found/ ) { 
						$RecordHasXRefError[$count] = 1;
						$DataLineWithXRefError = "Yes";
						&ETLWriteXRefErrorLog($fdat{ETLSchemeCode},$fdat{TransformationCode},
						$FieldDescriptions[$count],$QueryFieldNames{$QueryField1ForXRefs[$count]},
						$QueryFieldNames{$QueryField2ForXRefs[$count]},$MyResultValue);
					}
				} elsif( $ValueTypes[$count] eq "TransformationScript" ) {
					$MyResultValue = eval $TransformationScriptNames[$count];
					if($@) {
						$Error = "There is an error in the transformation script:";
						$Error .= "$TransformationScriptNames[$count] \n\n$@";
						$Error =~ s/\n/<br>/g;
						&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
						&ETL_ExitTransformationProcess();
					}
					
					if( $MyResultValue =~ /XRef Not Found/ ) {
						$RecordHasXRefError[$count] = 1;
						$DataLineWithXRefError = "Yes";
						&ETLWriteXRefErrorLog($fdat{ETLSchemeCode},$fdat{TransformationCode},
						$FieldDescriptions[$count],"N/A","N/A",$MyResultValue);					
					}
				}
				
				if( $RecordHasXRefError[$count] == 0 ) {
					#If no XRef errors, assign the new values.
					$dataline .= $MyResultValue;
					$TransformatedValues[$count] = $MyResultValue;
					$Proc_ResultValues{$FieldDescriptions[$count]} = $MyResultValue;
				} else {
					$dataline .= "0";
					$TransformatedValues[$count] = "0";
					$Proc_ResultValues{$FieldDescriptions[$count]} = "0";
				}
				
				if( $count < $max_FieldNumber_to_export ) { $dataline = $dataline . "\|"; }
			} else {
				$TransformatedValues[$count] = "0";
				$Proc_ResultValues{$FieldDescriptions[$count]} = "0";
			}
		}



		if( $fdat{xrefcondition} eq "recordsok" ) {
			for( $count = 1; $count <= $LastFieldSequence; $count++) {
				$MyTheFieldDescription = "";
				if( $Catalogs[$count] ne "" ) {
					if( $RecordHasXRefError[$count] == 0 ) {
						my $CatalogValidationResult = "";
						$CatalogValidationResult = &check_data_catalog($FieldDescriptions[$count]
                                    , $Catalogs[$count]
                                    , $CatalogFieldName1ForValidation[$count]
                                    , $CatalogFieldName1TypeForValidation[$count]
                                    , $CatalogFieldName2ForValidation[$count]
                                    , $CatalogFieldName2TypeForValidation[$count]
                                    , $TransformatedValues[$QueryFieldNumForValidations1[$count]]
                                    , $TransformatedValues[$QueryFieldNumForValidations2[$count]]);
						
						if( $CatalogValidationResult =~ /Catalog Entry Not Found/ ) {
							&ETLWriteCatalogErrorLog($fdat{ETLSchemeCode},$fdat{TransformationCode},
							$FieldDescriptions[$count],$TransformatedValues[$QueryFieldNumForValidations1[$count]],
							$TransformatedValues[$QueryFieldNumForValidations2[$count]],$CatalogValidationResult);							
						}
					}
				}
			}
		}




    if( not defined($globalp->{DBTargetConn}) ) { ## Then Print to file.
			if( $fdat{xrefcondition} eq "allrecords" ) {
				if( $ENV{BATCH_PROCESS} == 1 ) {
					print _ETLFILEHANDLER $dataline . "\n";
				} else {
					print $dataline . "\n";
				}
			} elsif( $fdat{xrefcondition} eq "cleanxrefonly" or $fdat{xrefcondition} eq "recordsok" ) {
                if( $DataLineWithXRefError eq "No" ) {						
                  if( $ENV{BATCH_PROCESS} == 1 ) {
                    print _ETLFILEHANDLER $dataline . "\n";
                  } else {
                    print $dataline . "\n";
                  }
                }
      } else {
				$Error = "No Choice Selected to Process\n"; 
				&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
				&ETL_ExitTransformationProcess();				
			}
    } else { ## Process Script After Record Transformation using the target Database connection.
			$ProcessScriptAfterRecordTransformation = "Yes";
			
			if( $fdat{xrefcondition} eq "allrecords" ) {
				$ProcessScriptAfterRecordTransformation = "Yes";
			} elsif( $fdat{xrefcondition} eq "cleanxrefonly" or $fdat{xrefcondition} eq "recordsok" ) {
        if( $DataLineWithXRefError eq "Yes" ) { $ProcessScriptAfterRecordTransformation = "No"; }
      } else {
				$Error = "No Choice Selected to Process\n"; 
				&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
				&ETL_ExitTransformationProcess();				
			}
			
      # Inserting the transformed data into target database
			if( $ProcessScriptAfterRecordTransformation eq "Yes" ) {
				eval $ScriptAfterRecordTransformation;
				if($@) { 
					$Error = "There is an error in the script after record transformation:";
					$Error .= "\n\n$@\n\n $ScriptAfterRecordTransformation \n\n"; 
					$Error =~ s/\n/<br>/g;
					&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
					&ETL_ExitTransformationProcess();
				}
			}			
		}
	}
    
    
    
  sub initialize_layout_processing_variables
    {
    $CFGTableReady = 0;
		@DataSourceRows = ();
		@ValueTypes = ();
		@ConstantValues = ();
		@QueryFields = ();
		@QueryField1ForXRefs = ();
		@QueryField2ForXRefs = ();
		@xreftypes = ();
		@TransformationScriptNames = ();
		@TransformatedValues = ();
		@Catalogs = ();
		@QueryFieldNumForValidations1 = ();
        @CatalogFieldName1ForValidation = ();
        @CatalogFieldName1TypeForValidation = ();
		@QueryFieldNumForValidations2 = ();
        @CatalogFieldName2ForValidation = ();
        @CatalogFieldName2TypeForValidation = ();
		@FieldDescriptions = ();
		@FieldMustBeExported = ();
		@RecordHasXRefError = ();
        %QueryFieldNames = ();
		%Proc_ResultValues = ();
		$layoutcounter = 0;        
    }
    
    
    
    
	sub prepare_get_xrefnew_value
	{
		my $XrefQuery = "SELECT to_value";
		$XrefQuery .= " FROM ".$globalp->{table_prefix}."_etl_xreftable";
		$XrefQuery .= " WHERE xreftype = ?";
		$XrefQuery .= " AND from_value = ?";
        
		$globalp->{xrefsthresultonevalue} = $globalp->{dbh} -> prepare ( $XrefQuery ) 
        or die "Cannot prepare query:$XrefQuery \n\n <br><br> $DBI::errstr";

        $XrefQuery .= " AND from_value1 = ?";
        
		$globalp->{xrefsthresulttwovalues} = $globalp->{dbh} -> prepare ( $XrefQuery ) 
        or die "Cannot prepare query:$XrefQuery \n\n <br><br> $DBI::errstr";        
    }
    



    
	sub get_xrefnew_value
	{
		my $myxreftype = shift; 
        my $myoldvalue = shift;
        my $myoldvalue1 = shift;
        my $XRefTheFieldDescription = shift;
		my $my_new_value = "";
        my $to_value = "";
        my $XRefValueFound = 0;

        if( $globalp->{isspace}($myoldvalue1) )
        {
            $globalp->{xrefsthresultonevalue}-> bind_param(1,$myxreftype);
            $globalp->{xrefsthresultonevalue}-> bind_param(2,$myoldvalue);
            
            $globalp->{xrefsthresultonevalue}-> execute()
            or die "Cannot execute xrefquery. \n\n <br><br> $DBI::errstr";        
            $globalp->{xrefsthresultonevalue} -> bind_columns( undef, \$to_value );
            if( my $xrefdatresult = $globalp->{xrefsthresultonevalue}->fetchrow_arrayref ) 
            {
                $my_new_value = $to_value;
                $XRefValueFound = 1;
            }            
        }
        else
        {
            $globalp->{xrefsthresulttwovalues}-> bind_param(1,$myxreftype);
            $globalp->{xrefsthresulttwovalues}-> bind_param(2,$myoldvalue);            
            $globalp->{xrefsthresulttwovalues}-> bind_param(3,$myoldvalue1);
            
            $globalp->{xrefsthresulttwovalues}-> execute()
            or die "Cannot execute query:$XrefQuery \n\n <br><br> $DBI::errstr";        
            $globalp->{xrefsthresulttwovalues} -> bind_columns( undef, \$to_value );
            
            if( my $xrefdatresult = $globalp->{xrefsthresulttwovalues}->fetchrow_arrayref ) 
            {
                $my_new_value = $to_value;
                $XRefValueFound = 1;
            }            
        }

		if( not $XRefValueFound ) 
		{
            $my_new_value = "XRef Not Found For:";
            $my_new_value .= $myoldvalue;
            
			$my_new_value .= " - " . $myoldvalue1 if( not $globalp->{isspace}($myoldvalue1) );
		}
	
		return($my_new_value);
	}





	sub check_data_catalog
	{
		my $myfieldDesc = shift;
		my $ETLCatalogTable = shift;
        my $ETLCatalogFieldName1 = shift;
        my $ETLCatalogFieldName1Type = shift;
        my $ETLCatalogFieldName2 = shift;
        my $ETLCatalogFieldName2Type = shift;        
		my $ETL_Value_To_Check = shift;
        my $ETL_Value_To_Check2 = shift;
		my $catmessage = "";
        my $numrows = 0;
        
		my $CatQuery = "SELECT count(*)";
		$CatQuery .= " FROM ".$ETLCatalogTable;
        
        if( $ETLCatalogFieldName1Type eq "Alphanumeric" )
        {
            $CatQuery .= " WHERE ".$ETLCatalogFieldName1." = '".$ETL_Value_To_Check."'";            
        }        
        elsif( $ETLCatalogFieldName1Type eq "Numeric" )
        {
            $CatQuery .= " WHERE ".$ETLCatalogFieldName1." = ".$ETL_Value_To_Check;
        }
        
        if( not $globalp->{isspace}($ETLCatalogFieldName2) )
        {
            if( $ETLCatalogFieldName2Type eq "Alphanumeric" )
            {
                $CatQuery .= " AND ".$ETLCatalogFieldName2." = '".$ETL_Value_To_Check2."'";            
            }        
            elsif( $ETLCatalogFieldName2Type eq "Numeric" )
            {
                $CatQuery .= " AND ".$ETLCatalogFieldName2." = ".$ETL_Value_To_Check2;
            }
        }
		#~ echo($CatQuery); exit;
		my $catsthresult = $globalp->{CataLogsDBConn}->prepare_cached( $CatQuery,\%attributes,2 )
        or die "Cannot prepare query:$CatQuery \n\n <br><br> $DBI::errstr";
                
		$catsthresult -> execute() 
        or die "Cannot execute query:$CatQuery \n\n <br><br> $DBI::errstr";
		$catsthresult -> bind_columns( undef, \$numrows );
		my $catdatresult = $catsthresult -> fetchrow_arrayref;
		
		if( $numrows == 0 ) 
		{
			$catmessage = " - Catalog Entry Not Found For:".$ETL_Value_To_Check;
            if( not $globalp->{isspace}($ETLCatalogFieldName2) )
            {
                $catmessage .= " - " . $ETL_Value_To_Check2;
            }            
		}

		return($catmessage);
	}





	sub Get_Oracle_Query_Fields
	{		
		my $TableName = shift;
		my $FieldPrefix = shift;
		my $InstanceName = shift;
		my $MyBaaNCompany = shift;
		my $MyOracleDBH = shift;
		
		my $MyQuery = "SELECT " . uc($TableName) . $MyBaaNCompany.".*";
			  $MyQuery .= " FROM baan." . $TableName . $MyBaaNCompany;
		
		my $GetMyQuery = $MyOracleDBH->prepare ($MyQuery)  or die "Cannot get data: $MyQuery";
		$GetMyQuery -> execute  or die "Cannot get data: $MyQuery";
		$GetMyQuery ->{RaiseError} = 1;
		my $NumberOfFields = $GetMyQuery->{NUM_OF_FIELDS};

		my $MyQueryRows = [];
		my $QueryFields = "";
		
		if ( my $MyQueryRow = (shift(@$MyQueryRows) || shift(@{$MyQueryRows=$GetMyQuery->fetchall_arrayref(undef,1)||[]})))
		{	
			for(  my $Count = 0; $Count < $NumberOfFields; $Count++ )
			{			
				$QueryFields .= $InstanceName."." . $GetMyQuery->{NAME}[$Count];
				$GetMyQuery->{NAME}[$Count] =~ s/T\$//g;
				$GetMyQuery->{NAME}[$Count] =~ s/\$//g;
				$QueryFields .= " AS \"" . $FieldPrefix . "." . $GetMyQuery->{NAME}[$Count] . "\"";
				if( $Count < $NumberOfFields - 1 ) { $QueryFields .= ", "; }
			}
		}
		$GetMyQuery ->finish();
				
		return($QueryFields);
	}




	sub Get_EplSite_Query_Fields
	{		
		my $TableName = shift;
		my $FieldPrefix = shift;
		my $InstanceName = shift;
		
		my $MyQuery = "SELECT " . $globalp->{table_prefix} . uc($TableName) .".*";
			  $MyQuery .= " FROM " . $globalp->{table_prefix} . $TableName ;
		
		my $GetMyQuery = $globalp->{dbh}->prepare ($MyQuery)  or die "Cannot get data: $MyQuery";
		$GetMyQuery -> execute  or die "Cannot get data: $MyQuery";
		$GetMyQuery ->{RaiseError} = 1;
		my $NumberOfFields = $GetMyQuery->{NUM_OF_FIELDS};

		my $MyQueryRows = [];
		my $QueryFields = "";
		
		if ( my $MyQueryRow = (shift(@$MyQueryRows) || shift(@{$MyQueryRows=$GetMyQuery->fetchall_arrayref(undef,1)||[]})))
		{	
			for(  my $Count = 0; $Count < $NumberOfFields; $Count++ )
			{			
				$QueryFields .= $InstanceName."." . $GetMyQuery->{NAME}[$Count];
				$GetMyQuery->{NAME}[$Count] =~ s/T\$//g;
				$GetMyQuery->{NAME}[$Count] =~ s/\$//g;
				$QueryFields .= " AS \"" . $FieldPrefix . "." . $GetMyQuery->{NAME}[$Count] . "\"";
				if( $Count < $NumberOfFields - 1 ) { $QueryFields .= ", "; }
			}
		}
		$GetMyQuery ->finish();
				
		return($QueryFields);
	}





	sub value_exists_in_xref_table
	{
		my $MyXRefType = shift; my $MyValueToCheck = shift;
		
		local $MyValueExists = 0;
		
		$MyValueToCheck =~ s/'/\\'/g;
		
		$XrefQuery = "SELECT from_value";
		$XrefQuery .= " FROM ".$globalp->{table_prefix}."_etl_xreftable";
		$XrefQuery .= " WHERE xreftype = '$MyXRefType'";
		$XrefQuery .= " AND from_value='$MyValueToCheck'";
		
		$xrefsthresult = $globalp->{dbh} -> prepare ( $XrefQuery ) 
        or die "Cannot prepare query:$XrefQuery";
		$xrefsthresult -> execute  or die "Cannot execute query:$XrefQuery";
		$xrefsthresult -> bind_columns( undef, \$from_value );

		if( $xrefdatresult = $xrefsthresult -> fetchrow_arrayref ) 
		{
			$MyValueExists = 1;
		}
			
		return($MyValueExists);
	}
		
		
		
	sub DataSourceExists
    {
        my $DataSourceToCheck = shift;
        my $NumRows = 0;
        
        my $SelectQuery = "SELECT count(*)";
        $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_data_sources";
        $SelectQuery .= " WHERE DataSourceID = ".$DataSourceToCheck;
        
        $sthresult = $globalp->{dbh} -> prepare ($SelectQuery) 
        or die "Cannot prepare query: $SelectQuery";
        $sthresult -> execute  or die "Cannot execute query:$SelectQuery";
        $sthresult -> bind_columns(undef, \$NumRows);
        $datresult = $sthresult -> fetchrow_arrayref;
        $sthresult -> finish();
        
        $NumRows = 1 if( $NumRows > 0 );
        
        return($NumRows);
    }




	sub CatalogsNeededInLayout
    {
        my $ETLSCode = shift;
        my $ETLSTransformation = shift;
        my $NumRows = 0;
        
        my $SelectQuery = "SELECT count(*)";
        $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_export_layouts";
        $SelectQuery .= " WHERE ETLSchemeCode = '".$ETLSCode."'";
        $SelectQuery .= " AND TransformationCode = '".$ETLSTransformation."'";
        $SelectQuery .= " AND Catalog <> 0";
        
        $sthresult = $globalp->{dbh} -> prepare ($SelectQuery) 
        or die "Cannot prepare query: $SelectQuery";
        $sthresult -> execute  or die "Cannot execute query:$SelectQuery";
        $sthresult -> bind_columns(undef, \$NumRows);
        $datresult = $sthresult -> fetchrow_arrayref;
        $sthresult -> finish();
        
        $NumRows = 1 if( $NumRows > 0 );
        
        return($NumRows);
    }
    


	sub XRefsNeededInLayout
    {
        my $ETLSCode = shift;
        my $ETLSTransformation = shift;
        my $NumRows = 0;
        
        my $SelectQuery = "SELECT count(*)";
        $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_export_layouts";
        $SelectQuery .= " WHERE ETLSchemeCode = '".$ETLSCode."'";
        $SelectQuery .= " AND TransformationCode = '".$ETLSTransformation."'";
        $SelectQuery .= " AND ValueType ='CrossReference'";
        
        $sthresult = $globalp->{dbh} -> prepare ($SelectQuery) 
        or die "Cannot prepare query: $SelectQuery";
        $sthresult -> execute  or die "Cannot execute query:$SelectQuery";
        $sthresult -> bind_columns(undef, \$NumRows);
        $datresult = $sthresult -> fetchrow_arrayref;
        $sthresult -> finish();
        
        $NumRows = 1 if( $NumRows > 0 );
        
        return($NumRows);
    }

    
    

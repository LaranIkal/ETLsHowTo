########################################################################
# Eplsite,main file
#
#This File has logic design from PHP-NUKE ported to Embperl.
#EplSite: Web Portal And WorkFlow System.
#Copyright (C) 2003 by Carlos Kassab (laran.ikal@gmail.com)
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



$globalp->{EplSitePerlCheckSyntax} = sub {

  local $PerlCodeToCheckSyntax = shift;
	local $VariableOrPerlFileName = shift;	
	local $KeepFilesCreated = shift;
	
	$thedocument = $globalp->{EplSite_Temp_Docs_Path}."/$$-".$VariableOrPerlFileName.".pl";
	$thedocument2 = $globalp->{EplSite_Temp_Docs_Path}."/$$-".$VariableOrPerlFileName.".log";	
	
	if( open (OUTFILE,">$thedocument") ) {
		print OUTFILE $PerlCodeToCheckSyntax;
		close(OUTFILE);
		open (STDERR,">$thedocument2");
		
		$EplSiteCompileResult = `$globalp->{EplSite_Perl_Path} -c $thedocument`;

		close(STDERR);
		open (ERRORFILE,"$thedocument2");
		@compileresult = <ERRORFILE>;
		close(ERRORFILE);
		
		$EplSiteCompileResult = "";
		foreach(@compileresult) {
			if( $_ =~ /syntax OK/ ) {
				$EplSiteCompileResult = "";
			} else{
				$EplSiteCompileResult .= $_."<br>";
			}
		}

		if( $EplSiteCompileResult ne "" ) {
			@PerlCodeWithError = split('\n',$PerlCodeToCheckSyntax);
			$EplSiteCompileResult .= "<br><b>Here the code</b>:<br>";
			$MyLineCount = 0;
			foreach(@PerlCodeWithError) {
				$MyLineCount +=1;
				$EplSiteCompileResult .= '<font color="RED">'.$MyLineCount . "</font> " . $_ . "<br>";
			}
		}

	}	else{

		echo("file $thedocument to test perl script $VariableOrPerlFileName can not be created, check rights in target directory"); 
		$globalp->{clean_exit}();
	}

	if( $KeepFilesCreated eq "Yes" ) {
		$a=1;
	}	else {
		$globalp->{EplSiteDeleteFile}($thedocument);
		$globalp->{EplSiteDeleteFile}($thedocument2);
	}
	
	return($EplSiteCompileResult);
};



$globalp->{render_blocks} = sub {

  local $title = shift;
  local $content = shift;
  local $escmode = 0;
  $globalp->{content} = $content;
  $globalp->{content} = $globalp->{_BLOCKPROBLEM2} if( $globalp->{content} eq "" );
  $globalp->{title} = $title;
  Execute_htpl ($globalp->{eplsite_path}.'skins/'.$globalp->{skin}.'/blocksdef.htpl');
};



$globalp->{display_blocks} = sub {

  $blockpos = shift;
  local $escmode = 0;
  $sth = $globalp->{dbh} -> prepare ("select bid, bkey, title, content, url, blockfile, view from ".$globalp->{table_prefix}."_blocks where position='$blockpos' AND active=1 ORDER BY weight ASC")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_blocks";
  $sth -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_blocks";
  $sth -> bind_columns(undef, \$bid, \$bkey, \$title, \$content, \$url, \$blockfile, \$view);

  while( $dat = $sth -> fetchrow_arrayref ) {
    if( $blockfile ne "" ) {
      do $globalp->{eplsite_path}."blocks/".$blockfile;
    }

    local $escmode = 0;
    $globalp->{content} = $globalp->{headlines}($bid) if( $url ne "" );
    $content = $globalp->{headlines}($bid) if( $url ne "" );
    $optRawInput = 1;
    local $escmode = 0;
    $globalp->{render_blocks}($title,$content);
  }
  $sth->finish();
};



$globalp->{thefooter} = sub {

  Execute_htpl ($ENV{THE_CALLED_DOCUMENT_PATH}.'skins/'.$globalp->{skin}.'/left_center.html');
  Execute ($globalp->{eplsite_path}.'skins/'.$globalp->{skin}.'/skin_footer.prc');
};



$globalp->{message_box} = sub {

  $sthmsg = $globalp->{dbh} -> prepare ("select mid, title, content, date, expire, view  from ".$globalp->{table_prefix}."_message where active='1' order by mid asc")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_message";
  $sthmsg -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_message";
  $sthmsg -> bind_columns(undef, \$mid, \$title, \$content, \$mdate, \$expire, \$view);

  while ( $datmsg = $sthmsg -> fetchrow_arrayref ) {
    if( $expire != 0 ) {
      $past = time() - $expire;
      if( $mdate < $past ) {
        $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_message set active='0' where mid='$mid'");
      }
    }

    $globalp->{OpenTable}();
    echo("<center><font class=\"option\" color=\"$textcolor2\"><b>$title</b></font></center><font class=\"content\">$content</font>");
    $globalp->{CloseTable}();
    echo("<br>");
  }
  $sthmsg -> finish();
};



$globalp->{get_epls_cookie} = sub {

  my ( $eplscvalues, @eplsckvalues, %cookies);
	my (@cvalues, $mycvalues);
	%cookies = &get_cookie;

  if( defined($cookies{'EplSiteUserData'}) ) {
    $eplscvalues = $cookies{EplSiteUserData};
    @eplsckvalues = split(':',$eplscvalues);
  } else {
    @eplsckvalues = ("0","1","2","3");
  }

  return(@eplsckvalues);
};



$globalp->{theheader} = sub {

	echo("</head>");
  local $escmode = 0;
  @user_values = $globalp->{get_epls_cookie}();
  $username = $user_values[1];
  $username = $globalp->{_ANONYMOUS} if( $username eq "");
	$username = $globalp->{_ANONYMOUS} if( $username eq "0");

  if( $username eq $globalp->{_ANONYMOUS} || $username == 1 ) {
    $globalp->{theuser} = "&nbsp;&nbsp;<a href=\"index.prc?module=Your_Account&option=new_user\">".$globalp->{_CREATEACOUNT}."</a>";
    $globalp->{theuser} .= "&nbsp;&middot;&nbsp;<a href=\"index.prc?module=Your_Account\">".$globalp->{_LOGIN}."</a>";
  } else {
    $globalp->{theuser} = "&nbsp;&nbsp;".$globalp->{_WELCOME}." $username!";
    $globalp->{theuser} .= "&nbsp;&middot;&nbsp;<a href=\"index.prc?module=Your_Account&amp;option=logout\">".$globalp->{_LOGOUT}."</a>";
  }

  Execute_htpl ($globalp->{eplsite_path}.'skins/'.$globalp->{skin}.'/header.htpl');
  Execute_htpl ($ENV{THE_CALLED_DOCUMENT_PATH}.'skins/'.$globalp->{skin}.'/left_center.html');

  if( ( !defined($fdat{module}) ) && ( $globalp->{loaded_from_index} == 1 ) ) {
    $globalp->{message_box}() if( $globalp->{messagebox} == 1 );
  }

  if( ( defined($fdat{module}) )
      && ( $globalp->{loaded_from_index} == 1 )
      && ( $globalp->{main_module} eq $fdat{module} )
      && ( !defined($fdat{option}) ) ) {
    $globalp->{message_box}() if( $messagebox == 1 );
  }
};



$globalp->{siteheader} = sub {

  local $escmode = 0;
  echo("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">\n"
            ."<html><head><title>$globalp->{_HTITLE}</title>\n");
  Execute ($globalp->{eplsite_path}.'includes/meta.prc');
  echo("<LINK REL=\"StyleSheet\" HREF=\"skins/$globalp->{skin}/style/style.css\" TYPE=\"text/css\">\n");
  Execute ($globalp->{eplsite_path}.'includes/my_header.prc');
};



$globalp->{sitefooter} = sub {

  local $escmode = 0;
  Execute ($globalp->{eplsite_path}.'skins/'.$globalp->{skin}.'/footer.prc');
  echo("</body></html>");
  $globalp->{clean_exit}();
};



# Get an URL and explode de xml content to a hash
$globalp->{get_page} = sub {

  local $content;  local $ref_xml; local $ref; local $url = shift;
  if( $content = get($url) ) {
    $ref_xml = XMLin($content);
  } else { $ref_xml = ""; }

  return($ref_xml);
};



$globalp->{headlines} = sub {

  local $bid = shift;
  $sthhdlns = $globalp->{dbh} -> prepare ("select title, content, url, refresh, time from ".$globalp->{table_prefix}."_blocks where bid='$bid'")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_blocks";
  $sthhdlns -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_blocks";
  $sthhdlns -> bind_columns(undef, \$title, \$content, \$url, \$refresh, \$otime);
  $dathdlns = $sthhdlns -> fetchrow_arrayref;
  $sthhdlns -> finish();

  local $past = time - $refresh;

  if($otime < $past) {
    $btime = time;
    $rdf = $globalp->{get_page}($url);

    if( $rdf eq "" ) {
      $content = "";
      $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_blocks set content='$content', time='$btime' where bid='$bid'");
      $cont = 0;
      return($content);

    } else {

      $content = "<font class=\"content\">";
      if( $rdf->{version} == 0.91 ) {
        $i=0;
        for( $i = 0; $i <= 9; $i++ ) {
          eval { $content .= "<strong><big>&middot;</big></strong>&nbsp;<a href=\"$rdf->{channel}->{item}->[$i]->{link}\" target=\"new\">$rdf->{channel}->{item}->[$i]->{title}</a><br>\n" if( $rdf->{channel}->{item}->[$i]->{link} ne "" )};
          if($@) {
            $content ="";
            $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_blocks set content='$content', time='$btime' where bid='$bid'");
            $cont = 0;
            return($content);
          }
        }
      }

      if( $rdf->{xmlns} eq 'http://my.netscape.com/rdf/simple/0.9/' ) {
        $i=0;
        for( $i = 0; $i <= 9; $i++ ) {
          eval { $content .= "<strong><big>&middot;</big></strong>&nbsp;<a href=\"$rdf->{item}->[$i]->{link}\" target=\"new\">$rdf->{item}->[$i]->{title}</a><br>\n" if( $rdf->{item}->[$i]->{link} ne "" )};
          if($@) {
            $content ="";
            $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_blocks set content='$content', time='$btime' where bid='$bid'");
            $cont = 0;
            return($content);
          }
        }
      }

    }

    $content = $globalp->{FixQuotes}($content);
    $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_blocks set content='$content', time='$btime' where bid='$bid'");
  }

  $siteurl = $url;
  $siteurl =~ s/http:\/\///;
  @siteurl1 = split('/',$siteurl);
  $optRawInput = 1; local $escmode = 0;
  if( ( $cont == 1 ) || ( $content ne "" ) ) {
    $content .= "<br><a href=\"http://$siteurl1[0]\" target=\"blank\"><b>".$globalp->{_HREADMORE}."</b></a></font>";
  } elsif( ( $cont == 0 ) || ( $content eq "" ) ) {
    $content = "<font class=\"content\">".$globalp->{_RSSPROBLEM}."</font>";
  }

  return($content);
};



$globalp->{set_epls_cookie} = sub {

  my $setuid = shift; my $setuname = shift; my $setpass = shift; my $setumode = shift;
	my @cvalues;
	my $info = "$setuid:$setuname:$setpass:$setumode:";
	my $cpass1 = encode_base64($setpass);
  my $info1 = "$setuid:$setuname:$cpass1:$setumode:";
	&set_cookie("EplSiteUserData",$info,360000, "", "", 0);

  @cvalues = split(':',$info);

  return(@cvalues);
};



$globalp->{is_user} = sub {

  local( $the_uid="", $the_uname="", $the_pwd="" );
  @user_cook_values = $globalp->{get_epls_cookie}();
  $globalp->{user_cook_values} = \@user_cook_values;
  $the_uid = "$user_cook_values[0]";
  $the_uname = "$user_cook_values[1]";
  $the_pwd = "$user_cook_values[2]";

  if( $the_uid > 0 ) {
    $sthuid = $globalp->{dbh} -> prepare ("select pass,uname from ".$globalp->{table_prefix}."_users where uid='$the_uid'")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_users";
    $sthuid -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_users";
    $sthuid -> bind_columns(undef, \$isuser_upass, \$isuser_uname);
    $datuid = $sthuid -> fetchrow_arrayref;
    $sthuid -> finish();

    if( $isuser_upass eq $the_pwd && $isuser_upass ne "" && $isuser_uname eq $the_uname ) {
      return 1;
    }
  }
  return 0;

};



$globalp->{getusrinfo} = sub {

  local( $the_uid="", $the_uname="", $the_pwd="" );
  @user_cook_values = $globalp->{get_epls_cookie}();
  $the_uid = "$user_cook_values[0]";
  $the_uname = "$user_cook_values[1]";
  $the_pwd = "$user_cook_values[2]";

  $sthguinfo = $globalp->{dbh} -> prepare ("select uid, name, uname, email, femail, url, user_avatar, user_icq, user_occ, user_from, user_intrest, user_sig, user_viewemail, user_theme, user_aim, user_yim, user_msnm, pass, storynum, umode, uorder, thold, noscore, bio, ublockon, ublock, theme, commentmax, newsletter from ".$globalp->{table_prefix}."_users where uname='$the_uname' and pass='$the_pwd'")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_users";
  $sthguinfo -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_users";
  $datguinfo = $sthguinfo -> fetchrow_hashref();
  $sthguinfo -> finish();

  return $datguinfo;
};



$globalp->{usr_limited_by_task} = sub {

  local $wfuserid = shift;
  $nurows = 0;
  $sthresult = $globalp->{dbh} -> prepare ("SELECT count(*)  FROM ".$globalp->{table_prefix}."_wf_task_by_user WHERE ResourceID=$wfuserid")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_wf_task_by_user";
  $sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_wf_task_by_user";
  $sthresult -> bind_columns(undef, \$nurows);
  $datresult = $sthresult -> fetchrow_hashref();
  $sthresult -> finish();

  $nurows = 1 if( $nurows > 0 );

  return $nurows;
};



$globalp->{usr_can_see_task} = sub {

  local $wfuserid = shift;
  local $wftaskID = shift;
  $nurows = 0;
  $sthresult = $globalp->{dbh} -> prepare ("SELECT count(*)  FROM ".$globalp->{table_prefix}."_wf_task_by_user WHERE ResourceID=$wfuserid AND TaskID=$wftaskID ")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_wf_task_by_user";
  $sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_wf_task_by_user";
  $sthresult -> bind_columns(undef, \$nurows);
  $datresult = $sthresult -> fetchrow_hashref();
  $sthresult -> finish();

  $nurows = 1 if( $nurows > 0 );

  return $nurows;
};



$globalp->{get_the_wf_cookie} = sub {

	my ( $eplscvalues, @eplsckvalues, %cookies);
  my @cvalues = (); my $mycvalues = ();
  %cookies = &get_cookie;

	use MIME::Base64;

  if( defined($cookies{'WFUserData'}) ) {
    $mycvalues = $cookies{WFUserData};
    @cvalues = split(':',$mycvalues);
    $cvalues[2] = decode_base64($cvalues[2]);
  } else {
    @cvalues = ("0","1","2","3");
  }

  return(@cvalues);
};



$globalp ->{set_the_cookie} = sub {

  my $crid = shift; my $cuser = shift; my $cpass = shift;
  my $uname = shift;
  my @cvalues;
  my $info = "$crid:$cuser:$cpass:$uname: ";
  my $cpass1 = encode_base64($cpass);
  my $info1 = "$crid:$cuser:$cpass1:$uname: ";

  if( $globalp->{wfsession_expire_time} eq '0' ) {
    &set_cookie($globalp->{CookieName},$info1,"-1", "", $ENV{PATH_INFO}, 0);
  } else {
    &set_cookie($globalp->{CookieName},$info1,$globalp{wfsession_expire_time}, "", $ENV{PATH_INFO}, 0);
  }
  @cvalues = split(':',$info);

  return(@cvalues);
};



$globalp->{get_the_cookie} = sub {

	my ( $eplscvalues, @eplsckvalues, %cookies);
  my @cvalues = (); my $mycvalues = ();
  %cookies = &get_cookie;

  if( defined($cookies{$globalp->{CookieName}}) ) {
    $mycvalues = $cookies{$globalp->{CookieName}};
    @cvalues = split(':',$mycvalues);
    $cvalues[2] = decode_base64($cvalues[2]);
  } else {
    @cvalues = ("0","1","2","3");
  }

  return(@cvalues);
};

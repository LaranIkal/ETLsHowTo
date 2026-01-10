########################################################################
# Eplsite,subroutines file for admin module
#
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

if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else{ echo("Access denied,".$ENV{'REQUEST_URI'}); 
if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }


#*********************************************************
#* Login Function                                         *
#*********************************************************#



$globalp->{admlogin} = sub {

  $globalp->{siteheader}(); $globalp->{theheader}();

  $globalp->{OpenTable}();
  echo("<center><font class=\"title\"><b>".$globalp->{_ADMINLOGIN}."</b></font></center>\n");
  $globalp->{CloseTable}();
  echo("<br>");
  $globalp->{OpenTable}();
  echo("<form action=\"admin.prc\" method=\"post\">\n"
    ."<table border=\"0\">\n"
    ."<tr><td>".$globalp->{_ADMINID}."</td>\n"
    ."<td><input type=\"text\" NAME=\"aid\" SIZE=\"20\" MAXLENGTH=\"20\">Default:admin\n"
    ."</td></tr><tr><td>".$globalp->{_PASSWORD}."</td>\n"
    ."<td><input type=\"password\" NAME=\"pwd\" SIZE=\"20\" MAXLENGTH=\"18\">Default:eplsite\n"
    ."</td></tr><tr><td>\n"
    ."<input type=\"hidden\" NAME=\"option\" value=\"login\">\n"
    ."<input type=\"submit\" VALUE=\"".$globalp->{_LOGIN}."\">\n"
    ."</td></tr></table>\n"
    ."</form>\n"
  );
  
  $globalp->{CloseTable}(); $globalp->{sitefooter}();
};



$globalp->{create_first} = sub {

  use Digest::MD5  qw(md5 md5_hex md5_base64);
  $first = 0;
	my $AdminSelect = "SELECT COUNT(*) FROM ".$globalp->{table_prefix}."_authors";
  $sthcfirst = $globalp->{dbh} -> prepare ($AdminSelect) 
	or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
  $sthcfirst -> execute  
	or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
  $sthcfirst -> bind_columns(undef, \$first);
  $datcfirst = $sthcfirst -> fetchrow_arrayref;
  $sthcfirst->finish();

  if( $first == 0 ) {
    $pwd = md5_hex($fdat{pwd});
    delete $fdat{pwd};
    $the_adm = "root";

    my $AdminInsert = "INSERT INTO ".$globalp->{table_prefix}."_authors VALUES";
    $AdminInsert .= " ('$fdat{name}', '$the_adm', '$fdat{url}', '$fdat{email}'";
    $AdminInsert .= ", '$pwd', 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1, '')";
    $globalp->{dbh}->do($AdminInsert);
    if( $fdat{user} == 1 ) {
      $user_regdate = $globalp->{now}("BOTH");
      $user_avatar = "blank.gif";
      $commentlimit = 4096;
      $AdminInsert = "INSERT INTO ".$globalp->{table_prefix}."_users VALUES"; 
      $AdminInsert .= " (NULL,'','$fdat{name}','$fdat{email}','','$fdat{url}'";
      $AdminInsert .= ",'$user_avatar','$user_regdate','','','','','','0',''";
      $AdminInsert .= ",'','','','$pwd',10,'','0','0','0','','0','','',";
      $AdminInsert .= "'$commentlimit','0','0','0','0','0','1')";
      $globalp->{dbh}->do($AdminInsert);
    }
    $globalp->{admlogin}();
  }
};



$globalp->{check_if_first} = sub {

  $the_first = 0;
	my $AdminSelect = "SELECT COUNT(*) FROM ".$globalp->{table_prefix}."_authors";	
  $sthfirst = $globalp->{dbh} -> prepare ($AdminSelect)  
	or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
  $sthfirst -> execute  
	or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
  $sthfirst -> bind_columns(undef, \$the_first);
  $datfirst = $sthfirst -> fetchrow_arrayref;
  $sthfirst->finish();

  if( $the_first == 0 ) {

    if( !defined($fdat{name}) ) {
      $globalp->{siteheader}(); $globalp->{theheader}();
      $globalp->{print_title}($globalp->{sitename}.": ".$globalp->{_ADMINISTRATION}."");
      $globalp->{OpenTable}();

      echo("<center><b>".$globalp->{_NOADMINYET}."</b></center><br><br>\n"
        ."<form action=\"admin.prc\" method=\"post\">\n"
        ."<table border=\"0\">\n"
        ."<tr><td><b>".$globalp->{_NICKNAME}.":</b></td><td><input type=\"text\""
        ." name=\"name\" size=\"30\" maxlength=\"25\"></td></tr>\n"
        ."<tr><td><b>".$globalp->{_HOMEPAGE}.":</b></td><td><input type=\"text\""
        ." name=\"url\" size=\"30\" maxlength=\"255\" value=\"http://\"></td></tr>\n"
        ."<tr><td><b>".$globalp->{_EMAIL}.":</b></td><td><input type=\"text\""
        ." name=\"email\" size=\"30\" maxlength=\"255\"></td></tr>\n"
        ."<tr><td><b>".$globalp->{_PASSWORD}.":</b></td><td><input type=\"password\""
        ." name=\"pwd\" size=\"11\" maxlength=\"10\"></td></tr>\n"
        ."<tr><td><b>".$globalp->{_RETYPEPASSWD}.":</b></td><td><input type=\"password\""
        ." name=\"pwd1\" size=\"11\" maxlength=\"10\"></td></tr>\n"
        ."<tr><td colspan=\"2\">".$globalp->{_CREATEUSERDATA}."  <input type=\"radio\""
        ." name=\"user\" value=\"1\" checked>".$globalp->{_YES}
        ."&nbsp;&nbsp;<input type=\"radio\" name=\"user\" value=\"0\">"
        .$globalp->{_NO}."</td></tr>\n"
        ."<tr><td><input type=\"hidden\" name=\"fop\" value=\"create_first\">\n"
        ."<input type=\"submit\" value=\"".$globalp->{_SUBMIT}."\">\n"
        ."</td></tr></table></form>\n"
      );

      $globalp->{CloseTable}();
      $globalp->{sitefooter}();
      return 1;
    }

    if( $fdat{fop} eq "create_first" ) {
			if ( $fdat{pwd} eq $fdat{pwd1} ) {
       	$globalp->{create_first}();
			} else {
				$globalp->{siteheader}(); $globalp->{theheader}();
				$globalp->{print_title}($globalp->{sitename}.": ".$globalp->{_ADMINISTRATION}."");
				$globalp->{OpenTable}();
				echo("<center>$globalp->{_PASSERROR} $globalp->{_GOBACK}</center>");
				$globalp->{CloseTable}();
				$globalp->{sitefooter}();
				return 1;
			}
    }

    $globalp->{clean_exit}();
    return 1;
  }

  return 0;
};




#*********************************************************
#* Administration Menu Function                          *
#*********************************************************#

$globalp->{adminmenu} = sub {

  local $url = shift; local $title = shift; local $image = shift;

  if( $globalp->{admingraphic} == 1 ) {
    $img = "<img src=\"images/admin/$image\" border=\"0\" alt=\"\"></a><br>";
    $close = "";
  } else {
    $img = "";
    $close = "</a>";
  }

  echo("<td align=\"center\"><font class=\"content\"><a href=\"$url\">$img<b>$title</b>$close</font></td>");
  if( $counter == 5 ) {
    echo("</tr><tr>");
    $counter = 0;
  } else {
    $counter++;
  }
};



$globalp->{GraphicAdmin} = sub {

	echo("<script type=\"text/javascript\"> \n"
    .'function HideUnhideControlPanel(divID)'."\n"
    .'{'."\n"
    .'	var item = document.getElementById(divID);'."\n"
    .'	if (item)'."\n"
    .'	{'."\n"
    ."			item.className=(item.className=='hidden')?'unhidden':'hidden';\n"
    ."	}\n"
    ."}\n"	
    ."</script>\n"
  );
	
	
	my $AdminSelect = "SELECT radminarticle,radmintopic,radminuser,radminsurvey,";
	$AdminSelect .= "radminsection,radminlink,radminephem,radminfaq,radmindownload,";
	$AdminSelect .= "radminreviews,radminnewsletter,radminforum,radmincontent,radminency,";
	$AdminSelect .= "radminworkflow, radminsuper FROM ";
	$AdminSelect .= $globalp->{table_prefix}."_authors WHERE aid='$globalp->{aid}'";
	
  $sthgadm1 = $globalp->{dbh} -> prepare ($AdminSelect)
	or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
  $sthgadm1 -> execute
	or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
  $sthgadm1 -> bind_columns(undef, \$globalp->{radminarticle},\$globalp->{radmintopic},
	\$globalp->{radminuser},\$globalp->{radminsurvey},\$globalp->{radminsection},
	\$globalp->{radminlink},\$globalp->{radminephem},\$globalp->{radminfaq},
	\$globalp->{radmindownload},\$globalp->{radminreviews},\$globalp->{radminnewsletter},
	\$globalp->{radminforum},\$globalp->{radmincontent},\$globalp->{radminency},
	\$globalp->{radminworkflow},\$globalp->{radminsuper});
  $datgadm1 = $sthgadm1 -> fetchrow_arrayref;
  $sthgadm1->finish();

  echo("<center><b><a class=\"storycat\" href=\"admin.prc?session=$globalp->{session}\">"
		.$globalp->{_ADMINMENU}."</a></b>"
		."&nbsp;&nbsp;&nbsp;<a href=\"javascript:HideUnhideControlPanel('EplSiteControlPanel');\">"
		."Hide/Unhide</a>"
		."<br><br><div id=\"EplSiteControlPanel\" class=\"unhidden\">"
  );

	$globalp->{OpenTable}();

  echo("<table border=\"0\" width=\"100%\" cellspacing=\"1\"><tr>");

  opendir (LINKS,$globalp->{eplsite_path}."admin/links") || die "can't opendir links dir: $!";
  rewinddir(LINKS);
  @links = grep { /(links.)*.prc/ } readdir(LINKS);
  foreach (@links) { $menulist .= "$_ "; }
  closedir(LINKS);

  @menulist = split(' ', $menulist);
  @linksfiles = sort @menulist;
  $i = 0;
  foreach (@linksfiles) {
    if($linksfiles[$i] ne "") { Execute ($globalp->{eplsite_path}."admin/links/".$linksfiles[$i]); }
    $i++;
  }

  $globalp->{adminmenu}("admin.prc?option=logout&session=$globalp->{session}","".$globalp->{_ADMINLOGOUT}."", "exit.png");

  echo("</tr></table></center>");
  $globalp->{CloseTable}();
  echo("<br>");
  $globalp->{sitefooter }() if( $fdat{option} eq "GraphicAdmin" );
};



#*********************************************************
#* Administration Main Function                          *
#*********************************************************#

$globalp->{adminMain} = sub {

  $dummy = 0;
  $globalp->{siteheader}(); $globalp->{theheader}();
  $globalp->{GraphicAdmin}();

	my $AdminSelect = "SELECT radminarticle, radminsuper, admlanguage FROM ";
	$AdminSelect .= $globalp->{table_prefix}."_authors WHERE aid='$globalp->{aid}'";
	
  $sthadmmain = $globalp->{dbh} -> prepare ($AdminSelect)  
	or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
  $sthadmmain -> execute  
	or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_authors";
  $sthadmmain -> bind_columns(undef, \$radminarticle, \$radminsuper, \$admlanguage);
  $datadmmain = $sthadmmain -> fetchrow_arrayref;
  $sthadmmain->finish();

  if ($admlanguage ne "" ) {
    $queryalang = "WHERE alanguage='$admlanguage' ";
  } else {
    $queryalang = "";
  }
  $optRawInput = 1;
  $globalp->{OpenTable}();

  echo("<center><b>$globalp->{sitename}: ".$globalp->{_DEFHOMEMODULE}."</b><br><br>"
    ."".$globalp->{_MODULEINHOME}." <b>$globalp->{main_module}</b><br>"
    ."[ <a href=\"admin.prc?option=modules&session=$globalp->{session}\">"
    .$globalp->{_CHANGE}."</a> ]</center>"
  );
  
  $globalp->{CloseTable}();
  echo("<br>");
  $globalp->{OpenTable}();
  echo("<center><b>".$globalp->{_SPECIALNOTE}."</b></center>");
  $globalp->{CloseTable}();
  echo("<br></div>");

  if( $globalp->{setautonews} == 1 ) {
    $globalp->{OpenTable}();
    echo("<center><b>".$globalp->{_AUTOMATEDARTICLES}."</b></center><br>");
    $count = 0;

    $AdminSelect = "SELECT anid, aid, title, time, alanguage FROM ";
    $AdminSelect .= $globalp->{table_prefix}."_autonews order by time ASC";
    
    $sthresult2 = $globalp->{dbh} -> prepare ($AdminSelect)  
  	or die "Cannot SELECT from ".$globalp->{table_prefix}."_autonews";
    $sthresult2 -> execute  
	  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_autonews";
    $sthresult2 -> bind_columns(undef, \$anid, \$said, \$title, \$time, \$alanguage);

    while( $datresult2 = $sthresult2 -> fetchrow_arrayref ) {
      if ($alanguage == "") { $alanguage = "".$globalp->{_ALL}.""; }

      if( $anid ne "" ) {
        if( $count == 0 ) {
          echo("<table border=\"1\" width=\"100%\">");
          $count = 1;
        }
        $time =~ s/ /@/;

        if( ( $radminarticle == 1 ) || ( $radminsuper == 1 ) ) {
          if( ( $radminarticle == 1 ) && ( $globalp->{aid} == $said ) || ( $radminsuper == 1 ) ) {
            echo("<tr><td nowrap>&nbsp;(<a href=\"admin.prc?option=autoEdit"
              ."&amp;anid=$anid&session=$globalp->{session}\">".$globalp->{_EDIT}
              ."</a>-<a href=\"admin.prc?option=autoDelete&amp;anid=$anid"
              ."&session=$globalp->{session}\">".$globalp->{_DELETE}
              ."</a>)&nbsp;</td><td width=\"100%\">&nbsp;$title&nbsp;</td>"
              ."<td align=\"center\">&nbsp;$alanguage&nbsp;</td>"
              ."<td nowrap>&nbsp;$time&nbsp;</td></tr>"
            );
          } else {
            echo("<tr><td>&nbsp;(".$globalp->{_NOFUNCTIONS}.")&nbsp;</td>"
              ."<td width=\"100%\">&nbsp;$title&nbsp;</td><td align=\"center\">"
              ."&nbsp;$alanguage&nbsp;</td><td nowrap>&nbsp;$time&nbsp;</td></tr>"
            );
          }
        } else {
          echo("<tr><td width=\"100%\">&nbsp;$title&nbsp;</td>"
            ."<td align=\"center\">&nbsp;$alanguage&nbsp;</td>"
            ."<td nowrap>&nbsp;$time&nbsp;</td></tr>"
          );
        }

      }
    }
    $sthresult2->finish();

    if( ( $anid == "" ) && ( $count == 0 ) ) { echo("<center><i>".$globalp->{_NOAUTOARTICLES}."</i></center>"); }
    if( $count == 1 ) { echo("</table>"); }

    $globalp->{CloseTable}();
    echo("<br>");
  }

  $globalp->{sitefooter}();
};



$globalp->{read_eplsite_config} = sub {

  #Set the config varables to temporary variables

  # Database params
  $globalp->{dbusernamecc} = $globalp->{dbusername};
  $globalp->{dbpasswordcc} = $globalp->{dbpassword};
  $globalp->{mydbdatacc} = $globalp->{mydbdata};
  $globalp->{table_prefixcc} = $globalp->{table_prefix};

  # General site params
  $globalp->{eplsite_urlcc} = $globalp->{eplsite_url};
  $globalp->{skincc} = $globalp->{skin};
  $globalp->{messageboxcc} = $globalp->{messagebox};
  $globalp->{smtpservercc} = $globalp->{smtpserver};
	$globalp->{smtpserverauthenticationcc} = $globalp->{smtpserverauthentication};
	$globalp->{smtpusercc} = $globalp->{smtpuser};
	$globalp->{smtppasswordcc} = $globalp->{smtppassword};
  $globalp->{pagetitlecc} = $globalp->{pagetitle};
  $globalp->{sitenamecc} = $globalp->{sitename};
  $globalp->{adminmailcc} = $globalp->{adminmail};
  $globalp->{adminmailcc} =~ s/@/\\@/;
  $globalp->{main_modulecc} =$globalp->{main_module};
  $globalp->{site_logocc} = $globalp->{site_logo};
  $globalp->{site_languagecc} = $globalp->{site_language};
  $globalp->{expire_timecc} = $globalp->{expire_time};
  $globalp->{admingraphiccc} = $globalp->{admingraphic};

  # XML/RDF Backend Configuration

  $globalp->{backend_titlecc} = $globalp->{backend_title};
  $globalp->{backend_languagecc} = $globalp->{backend_language};

  # HTTP Referers
  $globalp->{httprefcc} = $globalp->{httpref};
  $globalp->{httprefmaxcc} = $globalp->{httprefmax};
  $globalp->{minpasscc} = $globalp->{minpass}; # Minimum length for user passwords
  $globalp->{commentmaxsizecc} = $globalp->{commentmaxsize}; #Set max size in bytes for comments

};



$globalp->{update_eplsite_config} = sub {

  #Read the config file into an array
  open (CFILE, "$globalp->{eplsite_path}"."config.prc");
  @cfile = <CFILE>;
  close(CFILE);

  open (CFILE, ">$globalp->{eplsite_path}"."config.prc~");
  print CFILE @cfile;
  close(CFILE);

  open (CFILE, ">$globalp->{eplsite_path}"."config.prc");
  print CFILE "########################################################################\n";
  print CFILE "# Eplsite,config file\n";
  print CFILE "#\n";
  print CFILE "#EplSite: Web Portal And WorkFlow System.\n";
  print CFILE "#Copyright (C) 2003 by Carlos Kassab (ckassab\@eplsite.org)\n";
  print CFILE "#\n";
  print CFILE "#This program is free software; you can redistribute it and/or modify\n";
  print CFILE "#it under the terms of the GNU General Public License as published by\n";
  print CFILE "#the Free Software Foundation; either version 2 of the License, or\n";
  print CFILE "#(at your option) any later version.\n";
  print CFILE "#\n";
  print CFILE "#This program is distributed in the hope that it will be useful,\n";
  print CFILE "#but WITHOUT ANY WARRANTY; without even the implied warranty of\n";
  print CFILE "#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n";
  print CFILE "#GNU General Public License for more details.\n";
  print CFILE "#\n";
  print CFILE "#You should have received a copy of the GNU General Public License\n";
  print CFILE "#along with this program; if not, write to the Free Software\n";
  print CFILE "#Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA\n";
  print CFILE "# \n";
  print CFILE "########################################################################\n\n";

  print CFILE 'if(substr($ENV{\'REQUEST_URI\'},-10) eq "config.prc") {'."\n";
  print CFILE "	\&redirect_url_to(\"index.prc\"); \n";
  print CFILE '}'."\n\n";
  print CFILE "use DBI;\n";
  print CFILE "\n\n";

  print CFILE '# Database params'."\n";
  print CFILE '$globalp->{dbusername} = "'.$globalp->{dbusernamecc}.'";'."\n";
  print CFILE '$globalp->{dbpassword} = "'.$globalp->{dbpasswordcc}.'";'."\n";
  print CFILE '$globalp->{mydbdata} = "'.$globalp->{mydbdatacc}.'";'."\n";
  print CFILE '$globalp->{table_prefix} = "'.$globalp->{table_prefixcc}.'";'."\n";
  print CFILE '$globalp->{dbh} = DBI->connect($globalp->{mydbdata},$globalp->{dbusername},$globalp->{dbpassword}) or die "Cannot connect to $globalp->{mydbdata}";'."\n\n";
  print CFILE '# General site params'."\n";
  print CFILE '$globalp->{eplsite_url} = "'.$globalp->{eplsite_urlcc}.'";'."\n";
  print CFILE '$globalp->{skin} = "'.$globalp->{skincc} .'";'."\n";
  print CFILE '$globalp->{messagebox} = '.$globalp->{messageboxcc}.';'."\n";
  print CFILE '$globalp->{smtpserver} = "'.$globalp->{smtpservercc}.'";'."\n";
  print CFILE '$globalp->{smtpserverauthentication} = "'.$globalp->{smtpserverauthenticationcc}.'";'." # 0=No, 1 =Yes\n";
  print CFILE '$globalp->{smtpuser} = "'.$globalp->{smtpusercc}.'";'."\n";
  print CFILE '$globalp->{smtppassword} = "'.$globalp->{smtppasswordcc}.'";'."\n";
  print CFILE '$globalp->{pagetitle} = "'.$globalp->{pagetitlecc}.'";'."\n";
  print CFILE '$globalp->{sitename} = "'.$globalp->{sitenamecc}.'";'."\n";
  print CFILE '$globalp->{adminmail} = "'.$globalp->{adminmailcc}.'";'."\n";
  print CFILE '$globalp->{main_module} = "'.$globalp->{main_modulecc}.'";'."\n";
  print CFILE '$globalp->{site_logo} = "'.$globalp->{site_logocc}.'";'."\n";
  print CFILE '$globalp->{site_language} = "'.$globalp->{site_languagecc}.'";'."\n";
  print CFILE '$globalp->{expire_time} = '.$globalp->{expire_timecc}.'; # inactive time in seconds before ask the admin password again.'."\n";
  print CFILE '$globalp->{admingraphic} = '.$globalp->{admingraphiccc}.'; # Activate graphic menu for Administration Menu? (1=Yes 0=No).'."\n\n";

  print CFILE '######################################################################'."\n";
  print CFILE '# XML/RDF Backend Configuration'."\n";
  print CFILE '#'."\n";
  print CFILE '# $backend_title:    Backend title, can be your site\'s name and slogan'."\n";
  print CFILE '# $backend_language: Language format of your site'."\n";
  print CFILE '######################################################################'."\n\n";

  print CFILE '$globalp->{backend_title} = "'.$globalp->{backend_titlecc}.'";'."\n";
  print CFILE '$globalp->{backend_language} = "'.$globalp->{backend_languagecc}.'";'."\n\n";

  print CFILE '######################################################################'."\n";
  print CFILE '# HTTP Referers Options'."\n";
  print CFILE '#'."\n";
  print CFILE '# $httpref:    Activate HTTP referer logs to know who is linking to our site? (1=Yes 0=No)'."\n";
  print CFILE '# $httprefmax: Maximum number of HTTP referers to store in the Database (Try to not set this to a high number, 500 ~ 1000 is Ok)'."\n";
  print CFILE '######################################################################'."\n\n";

  print CFILE '$globalp->{httpref} = "'.$globalp->{httprefcc}.'";'."\n";
  print CFILE '$globalp->{httprefmax} = "'.$globalp->{httprefmaxcc}.'";'."\n\n";

  print CFILE '$globalp->{minpass} = "'.$globalp->{minpasscc}.'"; # Minimum length for user passwords'."\n\n";
  print CFILE '$globalp->{commentmaxsize} = "'.$globalp->{commentmaxsizecc}.'"; #Set max size in bytes for comments'."\n\n";


  close (CFILE);
};



$globalp->{search_header} = sub {

  $search_title = shift;

  echo("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n"
    ."<html>\n"
    ."<head>\n"
    ."<title> $search_title  </title>\n"
    ."<meta HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=$globalp->{_CHARSET}\">\n"
    ."<meta HTTP-EQUIV=\"EXPIRES\" CONTENT=\"0\">\n"
    ."<meta NAME=\"RESOURCE-TYPE\" CONTENT=\"DOCUMENT\">\n"
    ."<meta NAME=\"DISTRIBUTION\" CONTENT=\"GLOBAL\">\n"
    ."<link REL=\"StyleSheet\" HREF=\"skins/$globalp->{skin}/style/style.css\" TYPE=\"text/css\">\n"
    ."</head>\n"
    ."<body bgcolor=\"#FFFFFF\" text=\"#000000\" link=\"#363636\" vlink=\"#363636\" alink=\"#d5ae83\">\n"
  );
};

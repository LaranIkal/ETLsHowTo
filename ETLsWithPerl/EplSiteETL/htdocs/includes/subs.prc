########################################################################
# EplsiteETL,general subs file 
#EplSite: Web Portal And WorkFlow System.
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




$globalp->{GetLogDateTime} = sub {

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$ydat,$isdst,$ActualDateTime) = localtime(time);
	my $mymonth = int($mon)+1;
	$mymonth = "0".$mymonth if( $mymonth < 10 );
	$mday = "0".$mday if( $mday < 10 );
	$hour = "0".$hour if( $hour < 10 );
	$min = "0".$min if( $min < 10 );
	$sec = "0".$sec if( $sec < 10 );
	$year += 1900;
	my $ActualLogDateTime = $year.$mymonth.$mday.$hour.$min.$sec;
	
	return( $ActualLogDateTime );
};



$globalp->{get_localtime} = sub {

  local $thetime = shift;

  local ($sec,$min,$hour,$mday,$mon,$year,$wday,$ydat,$isdst) = localtime($thetime);
  $mymonth = int($mon)+1;
  $mymonth = "0".$mymonth if( $mymonth < 10 );
  $mday = "0".$mday if( $mday < 10 );
  $year += 1900;
  $my_now = $year."-".$mymonth."-".$mday." ".$hour.":".$min.":".$sec;

  return($my_now);
};



$globalp->{today} = sub {

  local ($sec,$min,$hour,$mday,$mon,$year,$wday,$ydat,$isdst) = localtime();
  $mymonth = int($mon)+1;
  $mymonth = "0".$mymonth if( $mymonth < 10 );
	$mday = "0".$mday if( $mday < 10 );
  $year += 1900;
  local $my_today = $year.$mymonth.$mday;

  return($my_today);
};



$globalp->{get_local_date_time} = sub {

	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$ydat,$isdst,$ActualDateTime) = localtime(time);
  my $mymonth = int($mon)+1;
  $mymonth = "0".$mymonth if( $mymonth < 10 );
  $mday = "0".$mday if( $mday < 10 );
  $hour = "0".$hour if( $hour < 10 );
  $min = "0".$min if( $min < 10 );
  $sec = "0".$sec if( $sec < 10 );
  $year += 1900;
  my $ActualDateTime = $year.":".$mymonth.":".$mday.":".$hour.":".$min.":".$sec;
  
  return( $ActualDateTime );
};



$globalp->{get_file_uploaded} = sub {

  my $PathToSaveFiles = shift;
    
  my $thedocument = "";
    
  if( open (UPFILE, $cgi_sfn{'attachthis'}) ) {
    my $tempf = $ffunc{'attachthis'};
    $tempf =~ s/ //g;
    if( $tempf ne "" ) {
      $file = $ffunc{'attachthis'};
      my @thefile = split(/\\/,$file);
      $elements = @thefile;
      $thedocument = "$$-@thefile[$elements-1]";
      $thedocument =~ s/\s/_/g;
      $thedocument = $PathToSaveFiles . "/" . $thedocument;
      if( open (OUTFILE,">".$thedocument) ) {
        my($buffer) = "";
        while (read (UPFILE, $buffer, 32768)) { print OUTFILE $buffer; }
        close(OUTFILE);                            
        undef $buffer;                                                    
      } else { echo("file $thedocument can not be open, check rights in target directory"); $globalp->{clean_exit}(); }
      undef @thefile;
    }
    undef $tempf;
  }

  my $cgi_file_deleted = $globalp->{EplSiteDeleteFile}($cgi_sfn{'attachthis'});

  return($thedocument);
};



$globalp->{insert_into_into_general_data_table} = sub {

  my $GeneralPurposeTableData = [];		

  for $data (0 .. 100) { $GeneralPurposeTableData[$data] = ""; }
  #~ print "$globalp->{Temp_Docs_Path}/$thedocument"; exit;
  
  open ("datafile", "$globalp->{Temp_Docs_Path}/$thedocument");
    @filedata=<datafile>;
  close ("datafile");	
  
  $LineNumber = 0;
  
  foreach (@filedata) {	
    $LineNumber += 1;
    chop;
    $_ =~ s/'/''/g;
    $_ =~ s/\\/\\\\/g;
    
    if( $fdat{delimiterchar} eq "" ||  $fdat{delimiterchar} eq "\|") {
      @mydata = split('\|',$_);
    } else {
      @mydata = split($fdat{delimiterchar},$_);
    }
        
    $mydata[0] =~ s/^\s+//; #remove leading spaces
    $mydata[0] =~ s/\s+$//; #remove trailing spaces
    $mylinedatasize = $#mydata;

    if( $LineNumber == 2 ) {
      #Delete all records taking the first column of the second record as reference.
      #~ $mydata[0] =~ s/'/''/g;
      $delete_xref_data = "DELETE FROM ".$globalp->{table_prefix}."_etl_general_purpose_table";
      if( $fdat{takekindofdatafromfile} eq "Yes" ) {
        $delete_xref_data .= " WHERE kindofdata = '$mydata[0]'";
      } else {
        $delete_xref_data .= " WHERE kindofdata = '$fdat{kindofdata}'";
      }
      $globalp->{dbh}->do( $delete_xref_data ) or die "Can Not execute Query: $delete_xref_data";
    }
        
    if( $LineNumber >1 ) {
      if( $mydata[0] ne "" ) {
        if( $fdat{takekindofdatafromfile} eq "Yes" ) {
          for $data (0 .. $#mydata) { $GeneralPurposeTableData[$data] = $mydata[$data]; }
        } else {
          $GeneralPurposeTableData[0] = $fdat{kindofdata};
          for $data (0 .. $#mydata) { $GeneralPurposeTableData[$data + 1] = $mydata[$data]; }
        }
          
        $InsertFields = "";
        foreach $TableField ( @GeneralPurposeTableData ) {
          $TableField =~ s/'/''/g;
          $InsertFields .= "'" . $TableField . "',";
        }
                    
        $InsertFields = substr($InsertFields,0,length($InsertFields)-1);
          
        $insertquery = "INSERT INTO ".$globalp->{table_prefix}."_etl_general_purpose_table values ( ";
        $insertquery .= $InsertFields;
        $insertquery .= ")";

        $globalp->{dbh}->do($insertquery) or die "Can Not execute INSERT: $insertquery";	
      }
    } ## If to start Loading data to table.
  } ## End foreach (@filedata)
};



$globalp->{get_description_for_enumerated} = sub {

	local $MyEnumName = shift;
	local $MyEnumValue = shift;
	local $EnumDescription = "";
	
	if( $MyEnumName ne "" &&  $MyEnumValue ne "" ) {
		local $MySQLQuery = "SELECT EnumDescription";
    $MySQLQuery .= " FROM ".$globalp->{table_prefix}."_etl_enumerated";
		$MySQLQuery .= " WHERE EnumName = ?";
		$MySQLQuery .= " AND EnumValue = ?";
		
		local $sthresult = $globalp->{dbh}->prepare_cached( $MySQLQuery )
    or die "Cannot prepare query:$MySQLQuery";
		$sthresult -> execute($MyEnumName,$MyEnumValue)
    or die "Cannot execute query:$MySQLQuery";	
		$sthresult -> bind_columns(undef, \$EnumDescription);
		local $datresult = $sthresult -> fetchrow_arrayref;
		$sthresult -> finish();
	}
    
	return( $EnumDescription );
};



$globalp->{Get_BaaNV_Text} = sub {

	local $TextOracleConnection = shift;
	local $MyCompanyForTexts = shift;
	local $MyTextNum = shift;
	local $MyTextLanguage = shift;	
	
	my $OutputText = "";
	
	if( $MyTextNum > 0 ) {
		my $SqlQuery = "SELECT T\$SEQE as \"LineNumber\" ,T\$TEXT as \"TextLine\"";
		$SqlQuery .= " FROM baan.ttttxt010".$MyCompanyForTexts;
		$SqlQuery .= " WHERE T\$CTXT = $MyTextNum";
		$SqlQuery .= " AND T\$CLAN = $MyTextLanguage";
		$SqlQuery .= " ORDER BY T\$SEQE";
			
		my $GetMyQuery = $TextOracleConnection->prepare ($SqlQuery)  or die "Cannot get data: $SqlQuery";
		$GetMyQuery -> execute  or die "Cannot get data: $SqlQuery";
		$GetMyQuery ->{RaiseError} = 1;
		my $NumberOfFields = $GetMyQuery->{NUM_OF_FIELDS};
		
		my $MyOraQueryRows = [];
		my %TextQueryValues = ();
		
		while ( my $MyQueryRow = (shift(@$MyOraQueryRows) || shift(@{$MyOraQueryRows=$GetMyQuery->fetchall_arrayref(undef,1)||[]}))) {	
			$DataFound = 1;
      my $TheOraQueryRow = join("\~", @{$MyQueryRow});
      my @OraQueryArray = split("\~", $TheOraQueryRow);

			for( my $Count = 0; $Count < $NumberOfFields; $Count++ ) { $TextQueryValues{$GetMyQuery->{NAME}[$Count]} = @{$MyQueryRow}[$Count]; }
			
			$OutputText .= $TextQueryValues{'TextLine'};
		}
		$GetMyQuery ->finish();
	}

	return( $OutputText );
};



$globalp->{print_title} = sub {

  local $text_for_title = shift;
  local $escmode = 0;
  $globalp->{OpenTable}();
  echo("<center><font class=\"title\"><b>$text_for_title</b></font></center>\n");
  $globalp->{CloseTable}();

  echo("<br>");
};



$globalp->{themepreview} = sub {

  local $escmode = 0;
  $titlep = shift;
  $hometextp = shift;
  $bodytextp = shift;
  $notesp = shift;

  echo("<b>$titlep</b><br><br>$hometextp\n");

  if( $bodytextp != 1 ) { echo("<br><br>$bodytextp\n"); }

  if( $notesp != 1 ) { echo("<br><br><b>".$globalp->{_NOTE}."</b> <i>$notesp</i>\n"); }
};



$globalp->{now} = sub {

  local $the_type = shift; 
  
  local $my_now;
  local ($sec,$min,$hour,$mday,$mon,$year,$wday,$ydat,$isdst) = localtime(time);
  $mymonth = int($mon)+1;
  $mymonth = "0".$mymonth if( $mymonth < 10 );
  $mday = "0".$mday if( $mday < 10 );
  $year += 1900;
  if( $the_type eq "DATE" ){ $my_now=$year."-".$mymonth."-".$mday; }
  elsif( $the_type eq "TIME" ){ $my_now=$hour.":".$min.":".$sec; }
  elsif( $the_type eq "BOTH" ){ $my_now=$year."-".$mymonth."-".$mday." ".$hour.":".$min.":".$sec; }
  elsif( $the_type eq "BACKUP" ){ $my_now=$year."-".$mymonth."-".$mday." ".$hour.$min; }

  return($my_now);
};



$globalp->{sendnotify} = sub {

  local $send_notify_from = shift;
  local $send_notify_to = shift;
  local $send_notify_subject = shift;
  local $send_notify_message = shift;
			
	%mail = (SMTP    => $globalp->{smtpserver},
		from => $send_notify_from,
		to => $send_notify_to,
		subject => $send_notify_subject,
		Message => $send_notify_message,
	);

	if($globalp->{smtpserverauthentication} eq "1") {
    $mail{auth} = {user=>$globalp->{smtpuser},
    password=>$globalp->{smtppassword}, method=>"LOGIN", required=>0 };
  }

	sendmail(%mail) || &sendmailerror();
			
  return($error);
};



$globalp->{sendmailerror} = sub {

	$BadFrom = "Bad or missing From address";
	if($Mail::Sendmail::error =~ /$BadFrom/) { $error = $globalp->{_EMAIL}." ".$globalp->{_FROM}." ".$send_notify_from." ".$globalp->{_INVALID}."<br>\n";	}
  
  $BadTo="No recipient";
  if($Mail::Sendmail::error =~ /$BadTo/){ $error .= $globalp->{_EMAIL}." ".$globalp->{_TO}." ".$send_notify_to." ".$globalp->{_INVALID}; }
};



$globalp->{file_exists_ant} = sub {

  local $mypath = shift;
  local $myfile = shift;
  local @myfiles;
  local $fexists;

  if( opendir (MYPATH,$mypath) ) {
    rewinddir(MYPATH);
    @myfiles = grep { /$myfile/ } readdir(MYPATH);
  } else { @myfiles = 0; }

  if($myfile eq @myfiles[0] ) {
    $fexists = 1;
  } else { $fexists = 0; }

  return($fexists);
};



$globalp->{file_exists} = sub {

  local $myfile = shift; local $fexists;

  if( open(TFILE, $myfile) ) {
    close(TFILE);
    $fexists = 1;
  } else {
    $fexists = 0;
  }

  return($fexists);
};



$globalp->{is_active} = sub {

  local $mymodule = shift;
  local $isactive;
  local $numactive;

  $sthma = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_modules where title='$mymodule' and active=1") 
  or die "Cannot SELECT from ".$globalp->{table_prefix}."_modules";
  $sthma -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_modules";
  $sthma -> bind_columns(undef, \$num_active);
  $datma = $sthma -> fetchrow_arrayref;
  $sthma -> finish();

  if($num_active >= 1 ) {
    $isactive = 1;
  } else { $isactive = 0; }

  return($isactive);
};



$globalp->{CloseDBConnection} = sub {

  my $MyDBConnection = shift;
  if( defined( $MyDBConnection )) {
    eval { $MyDBConnection->disconnect(); };
    undef $MyDBConnection if($@);
  }
};



$globalp->{cleanup} = sub {

	open STDERR, '>&STDOUT';
  if( defined( $globalp->{dbh} )) {
    #eval { $globalp->{dbh}->disconnect(); };
		#delete $globalp->{dbh};
    undef $globalp->{dbh}; # if($@);
  }
    
  if( defined( $globalp->{DBSourceConn} )) {
    #eval { $globalp->{DBSourceConn}->disconnect(); };
    #delete $globalp->{DBSourceConn};
    undef $globalp->{DBSourceConn};
  }
  

  if( defined( $globalp->{DBTargetConn} )) {
    #eval { $globalp->{DBTargetConn}->disconnect(); };
    #delete $globalp->{DBTargetConn};
    undef $globalp->{DBTargetConn};
  }
    
  if( defined( $globalp->{CataLogsDBConn} )) {
    eval { $globalp->{CataLogsDBConn}->disconnect(); };
    delete $globalp->{CataLogsDBConn};
  }
    
  # if( defined(%ffunc) )
  if( %ffunc ) {
    delete $ffunc{'attachthis'};
    undef %ffunc;
  }

  if( %cgi_sfn ) {
    delete $cgi_sfn{'attachthis'};
    undef %cgi_sfn;
  }

  undef @thefile if( @thefile );
  undef $buf if( defined($buf) );
  #~ undef %globalp;
    	
	close STDERR;
};



$globalp->{clean_exit} = sub {

  $globalp->{cleanup}();
  undef %fdat;  
  undef %content_type;    
  close(_ETLFILEHANDLER) if( $ENV{BATCH_PROCESS} && $globalp{OutputFileOpen} );
  
  if( exists($ENV{MOD_PERL}) ) {
    #Apache::exit(1);
    ModPerl::Util::exit(1);
  } else {
    exit(1);
  }
};



$globalp->{htmlspecialchars} = sub {

  local $line = shift;
  $line =~ s/&/&amp;/g;
  $line =~ s/<(([^>]|\n)*)>/&lt;$1&gt;/g;
  $line =~ s/"/&quot;/g;
  $line =~ s/'/&#039;/g;

  return($line);
};



$globalp->{contentbox} = sub {

  local $title = shift ;local  $content = shift;
  $globalp->{OpenTable}();
  echo("<center><fon class=\"option\"><b>$title</b></font></center><br>".$content);
  $globalp->{CloseTable}();
  echo("<br>");
};



$globalp->{blockfileinc} = sub {

  local $title = shift; local $blockfile = shift; local $side = shift;

  $blockfiletitle = $title;
  if( $globalp->{file_exists}($globalp->{eplsite_path}.'blocks', $blockfile ) ) {
    do $globalp->{eplsite_path}.'blocks/'.$blockfile;
  } else {
    $content = $globalp->{_BLOCKPROBLEM};
  }

  if( $content eq "") {
    $content = $globalp->{_BLOCKPROBLEM2};
  }

  $globalp->{render_blocks}($blockfiletitle,$content);
};



$globalp->{filebox} = sub {

  local $title = shift; local $content = shift;
  Execute_htpl($globalp->{eplsite_path}.'skins/'.$globalp->{skin}.'/blocksdef.htpl');
};



$globalp->{FixQuotes} = sub {

  local $what = shift;
  $what =~ s/'/''/g;
  $what =~ s/\\\\'/'/g;
  return($what);
};



$globalp->{FixQuotesScript} = sub {

  local $what = shift;
  $what =~ s/'/''/g;
  return($what);
};



$globalp->{ReplaceQuotes} = sub {

  local $what = shift;
  $what =~ s/'/"/g;
  return($what);
};



$globalp->{stripslashes} = sub {

  local $the_field = shift;

  $the_field =~ s/\\\\/-kkk-/g;
  $the_field =~ s/\\//g;
  $the_field =~ s/-kkk-/\\/g;
  return($the_field);
};



$globalp->{FixSlashesAndQuotes} = sub {

  local $MyScriptToFix = shift;
	$MyScriptToFix =~ s/\\/\\\\/g;
	$MyScriptToFix =~ s/'/''/g;
  return($MyScriptToFix);
};



$globalp->{Clean_Non_Printable_Chars} = sub {

  my $FieldToClean = shift;
  $FieldToClean =~ s/[^[:print:]]//g;
  return ( $FieldToClean );
};



$globalp->{FixScriptSlashesAndQuotes} = sub {

  local $MyScriptToFix = shift;
	#~ $MyScriptToFix =~ s/\\/\\\\/g;
	$MyScriptToFix =~ s/'/''/g;
  return($MyScriptToFix);
};



$globalp->{wfdate} = sub {

  local $escmode = 0;
  local $wftime = shift;

  local ($sec,$min,$hour,$mday,$mon,$year,$wday,$ydat,$isdst) = localtime($wftime);
  $mymonth = int($mon)+1;
  $mymonth = "0".$mymonth if( $mymonth < 10 );
  $year += 1900;
  $my_wfnow = $year."-".$mymonth."-".$mday." ".$hour.":".$min.":".$sec;

  return($my_wfnow);
};



$globalp->{Get_Oracle_Query_Fields} = sub {

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
  
  if ( my $MyQueryRow = (shift(@$MyQueryRows) || shift(@{$MyQueryRows=$GetMyQuery->fetchall_arrayref(undef,1)||[]}))) {	
    for(  my $Count = 0; $Count < $NumberOfFields; $Count++ ) {
      $QueryFields .= $InstanceName."." . $GetMyQuery->{NAME}[$Count];
      $GetMyQuery->{NAME}[$Count] =~ s/T\$//g;
      $GetMyQuery->{NAME}[$Count] =~ s/\$//g;
      $QueryFields .= " AS \"" . $FieldPrefix . "." . $GetMyQuery->{NAME}[$Count] . "\"";
      if( $Count < $NumberOfFields - 1 ) { $QueryFields .= ", "; }
    }
  }
  $GetMyQuery ->finish();
            
  return($QueryFields);
};



$globalp->{connect_data_source} = sub {

  my $MyDataSourceScriptID = shift;
  my $DisplayForErrors = shift;
  
  my $DataSourceName = "";
  my $DataSourceScript = "";
  my $ErrorMessage = "";
  
  my $datasourcequery = "SELECT DataSourceName, DataSourceScript";
  $datasourcequery .= " FROM ".$globalp->{table_prefix}."_etl_data_sources";
  $datasourcequery .= " WHERE DataSourceID=".$MyDataSourceScriptID;
  #~ echo($datasourcequery); exit;
  my $sthresult3 = $globalp->{dbh} -> prepare ($datasourcequery); 
  $sthresult3 -> execute; 
  $sthresult3 -> bind_columns(undef, \$DataSourceName, \$DataSourceScript);
    
    
  if( my $datresult3 = $sthresult3 -> fetchrow_arrayref ) {
    eval $DataSourceScript;
    if( $@ ) {
      $ErrorMessage .= "<p>$@</p>";
    } else {
      $MyDataSourceName = eval( $DataSourceName );
            
      if( $@ ) { $ErrorMessage .= "<b>Error Connecting To Database: $@ </b>"; }
            
      if( not defined($MyDataSourceName) or $MyDataSourceName eq $DataSourceName ) {
        my $ErrorMessage = "<b>Error Connectig To Database: Check the data source definition subroutine<br>";
        $ErrorMessage .= " has the same name than in the data source name field and this is correct.</b>";
      }                
            
      if( $DBI::errstr ne "" ) {
				if( $DBI::errstr =~ /ODBC SQL Server Driver/ && $DBI::errstr =~ /(SQL-01000)/ ) {
					#not raise error, it could be part of the connection message
				}	else {
					$ErrorMessage .= "<b>Error Connectig To Database: $DBI::errstr </b>";
				}
      }          
    }
  } else {
    $ErrorMessage .= "<b>Data Source Not Found.</b>";
  }		
  $sthresult3->finish();
    
  if( $ErrorMessage ne "" ) {
    if( lc($globalp->{All_Trim}($DisplayForErrors)) eq "ajax" ) {
      $globalp->{Display_SQLQuery_Error_For_Ajax_Routines}($ErrorMessage);
    } else {
      $globalp->{General_EplSite_Error_Display}($ErrorMessage);
    }
  }    
    
  return($MyDataSourceName);
};



$globalp->{All_Trim} = sub {

  my $MyStringToTrim = shift;
    
  $MyStringToTrim =~ s/^\s+//; #remove leading spaces
  $MyStringToTrim =~ s/\s+$//; #remove trailing spaces			
  return($MyStringToTrim);
};
	
	
	
$globalp->{isspace} = sub {

  my $MyStringToTrim = shift;
  local $isspace = 0;
    
  $MyStringToTrim =~ s/^\s+//; #remove leading spaces
  $MyStringToTrim =~ s/\s+$//; #remove trailing spaces			

  if( $MyStringToTrim eq "" ){ $isspace =1; }
    
  return($isspace);		
};
	
	
	
$globalp->{General_EplSite_Error_Display} = sub {

  my $ErrorToDisplay = shift;
    
  $globalp->{siteheader}();
  $globalp->{theheader}();
  $globalp->{OpenTable}();

  echo("<p><b><font color=\"red\">Errors Found</font></b>:<br><br>$ErrorToDisplay</p><br>$globalp->{_GOBACK}");
    
  $globalp->{CloseTable}();
  $globalp->{loggedon_as}();
  $globalp->{sitefooter}();
  $globalp->{clean_exit}();	
};	
	


$globalp->{Display_SQLQuery_Error_For_Ajax_Routines} = sub {

  my $SQLQueryErrorToDisplay = shift;

  echo("<p><b><font color=\"red\">$SQLQueryErrorToDisplay</font></b></p>");
  $globalp->{clean_exit}();	
};	


	
$globalp->{LoadJavaScriptEditorLibs} = sub {

  echo("<LINK REL=\"StyleSheet\" HREF=\"includes/CodeMirror/lib/codemirror.css\" TYPE=\"text/css\">\n");
  echo("<script type=\"text/javascript\" src=\"includes/CodeMirror/lib/codemirror.js\"></script>\n");
  echo("<script type=\"text/javascript\" src=\"includes/CodeMirror/mode/javascript/javascript.js\"></script>\n");
	echo('<style>.CodeMirror {border-top: 1px solid black;border-left: 1px solid black;border-right: 1px solid black; border-bottom: 1px solid black;}</style>' . "\n");
  echo('<style>.CodeMirror-gutters { background: #3366CC; border-right: 3px solid #3E7087; min-width:1em; }</style>' . "\n");
  echo('<style>.CodeMirror-linenumber { color: white; }</style>');
};



$globalp->{LoadJavaScriptLibrary} = sub {

	my $JavaScriptLibraryName = shift;
	my $JavaScriptLibraryCode = "";
	
  echo("<script type=\"text/javascript\">");
	
	my	$selectquery = "SELECT JavaScriptCode FROM ";
	$selectquery .= $globalp->{table_prefix}."_etl_javascriptlibs";
	$selectquery .= " WHERE JavaScriptName='".$JavaScriptLibraryName."'";
	
	my $sthresult3 = $globalp->{dbh} -> prepare ($selectquery) 
	or die "Cannot prepare query: $selectquery";
	$sthresult3 -> execute  
	or die "Cannot execute query: $selectquery";
	$sthresult3 -> bind_columns(undef, \$JavaScriptLibraryCode);
	my $datresult3 = $sthresult3 -> fetchrow_arrayref();
	$sthresult3->finish();	

	echo($JavaScriptLibraryCode);

	echo("</script>\n");
};



$globalp->{LoadPerlCodeEditorLibs} = sub {

  echo("<LINK REL=\"StyleSheet\" HREF=\"includes/CodeMirror/lib/codemirror.css\" TYPE=\"text/css\">\n");
  echo("<script type=\"text/javascript\" src=\"includes/CodeMirror/lib/codemirror.js\"></script>\n");
  echo("<script type=\"text/javascript\" src=\"includes/CodeMirror/mode/perl/perl.js\"></script>\n");
	echo('<style>.CodeMirror {border-top: 1px solid black;border-left: 1px solid black;border-right: 1px solid black; border-bottom: 1px solid black;}</style>' . "\n");
  echo('<style>.CodeMirror-gutters { background: #3366CC; border-right: 3px solid #3E7087; min-width:1em; }</style>' . "\n");
  echo('<style>.CodeMirror-linenumber { color: white; }</style>');
};



$globalp->{GetNumberOfRecordsInQuery} = sub {

	my $DataSourceForCounting = shift;
	my $QueryForCounting = shift;
	my $AlternateDataSourceIDForCounting = shift;
	my $MyNumberOfRecords = 0;
		
	$SelectQueryCount = uc($fdat{sqlscript});
		
	my $SelectQueryCount = "SELECT COUNT(*) ";
	$SelectQueryCount .= " FROM ( " . $QueryForCounting . " ) QueryForCounting";
	
	eval {
		my $Countresulti = $DataSourceForCounting -> prepare ($SelectQueryCount)
		or die "Cannot prepare Query:$SelectQueryCount";
		$Countresulti -> execute  or die "Cannot Execute Query:$SelectQueryCount";
		$Countresulti -> bind_columns(undef,  \$MyNumberOfRecords);
		my $Countdatresulti = $Countresulti -> fetchrow_arrayref ;
		$Countresulti->finish();
	};
	
	if( $@ ) {
		my $CountDataSource2;
		eval {
			$CountDataSource2 = $globalp->{connect_data_source}($AlternateDataSourceIDForCounting,"Ajax");
			my $Countresulti = $CountDataSource2 -> prepare($selectquery)
			or die "Cannot prepare Query:$selectquery";
			$Countresulti -> execute or die "Cannot Execute Query:$selectquery";
			$Countresulti -> bind_columns(undef,  \$MyNumberOfRecords);
			my $Countdatresulti = $Countresulti -> fetchrow_arrayref ;
			$Countresulti->finish();                
			$CountDataSource2->disconnect();
		};
		
		if( $@ ) { $MyNumberOfRecords = "Error counting records."; }

		undef $CountDataSource2 if( defined( $CountDataSource2 ));
	}		
	
	return($MyNumberOfRecords);
};

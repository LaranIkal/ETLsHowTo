########################################################################
# Eplsite, Subroutines for ETL module EPLSite SQL Query Tool
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
  } else { exit(); }
}
	
our( @the_cvalues );
@the_cvalues = $globalp->{get_the_cookie}();
# echo($fdat{queryoption}); exit;
$SaveQueryMessage = "";

if( $fdat{queryoption} eq "" or not defined($fdat{queryoption}) ) {
  &query_main_screen();
}	elsif( $fdat{queryoption} eq "Save Query" ) {
  if( $fdat{ValidationResult} eq "ValidationOk" ) {
    ## If the process was not stopped before, the query is created.
    &query_saveandmaintain();
    
    # $globalp->{Display_SQLQuery_Error_For_Ajax_Routines}("Query:\"$fdat{SQLQueryName}\" Saved At:".$globalp->{get_localtime}(time).".");
    $SaveQueryMessage = "<p><b><font color=\"red\">Query:\"";
    $SaveQueryMessage .= $fdat{SQLQueryName}."\" Saved At:";
    $SaveQueryMessage .= $globalp->{get_localtime}(time).".</font></b></p>";
    # echo($SaveQueryMessage);
    # exit;
    &query_main_screen();
  } else {
    $ValidationResult = &ValidatePostedFormData(); 
    if( $ValidationResult eq "ValidationOk" ) {
      echo("ValidationOk"); 
    } else {
      $globalp->{Display_SQLQuery_Error_For_Ajax_Routines}($ValidationResult);
    }
  }
} elsif( $fdat{queryoption} eq "RefreshQueryList" ) {
  &UpdateQueryList();
} elsif( $fdat{queryoption} eq "Display" ) {
  &query_main_screen();
}	elsif( $fdat{queryoption} eq "Delete" )	{
  &query_delete();
}	else { ## Execute SQL query/command
  $fdat{QueryInstruction} =~ s/^\s+//; #remove leading spaces
  $fdat{QueryInstruction} =~ s/\s+$//; #remove trailing spaces
      
  if( $fdat{QueryInstruction} eq "" ) {
    $globalp->{Display_SQLQuery_Error_For_Ajax_Routines}("<b>Select how to execute SQL Instruction.</b>");
  }

  $fdat{sqlscript} =~ s/^\s+//; #remove leading spaces
  $fdat{sqlscript} =~ s/\s+$//; #remove trailing spaces
      
  if( $fdat{sqlscript} eq "" ) {
    $globalp->{Display_SQLQuery_Error_For_Ajax_Routines}("<b>Enter SQL Instruction To Execute.</b>");
  }

  if( $fdat{DataSourceID} eq "" ) {
    $globalp->{Display_SQLQuery_Error_For_Ajax_Routines}("<b>Select Data Source.</b>");
  }

  if( $fdat{QueryInstruction} ==  1 or $fdat{QueryInstruction} == 2 ) {
    my $TheSQLInstructionToExecute = uc($fdat{sqlscript});
    
    if( $fdat{QueryInstruction} ==  1 # "Execute Query"
        or $fdat{queryoption} eq "Export Query Results"
        or $fdat{queryoption} eq "Results As Excel File" ) {		
      &Process_Data_Search();
    } elsif( $fdat{QueryInstruction} ==  2 ) { # "Execute Script"
      &Process_Execute_Query();
    }
  }
}



########################################################################
############################# Sub Routines #############################
########################################################################



sub ValidatePostedFormData {
  $ValidationMessage = "";
  
  $fdat{SQLQueryName} =~ s/^\s+//; #remove leading spaces
  $fdat{SQLQueryName} =~ s/\s+$//; #remove trailing spaces
  $fdat{SQLQueryName} =~ s/'//g;

  $fdat{SQLQueryName} =~ s/ /_/g;
		
  if( $fdat{SQLQueryName} eq "" or not defined($fdat{SQLQueryName}) ) {
    $ValidationMessage .= "Enter SQL Query Name.<br>";
  } else {
    $SQLQueryName = "";
    $SQLQueryID = 0;
    $SelectQuery = "SELECT SQLQueryID, SQLQueryName";
    $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_sqlqueries";
    $SelectQuery .= " WHERE SQLQueryName = '".$fdat{SQLQueryName}."'" ;
    $sthresult = $globalp->{dbh} -> prepare($SelectQuery)
                  or die "Cannot prepare query:$SelectQuery";
    $sthresult -> execute or die "Cannot execute query:$SelectQuery";
    $sthresult -> bind_columns(undef, \$SQLQueryID, \$SQLQueryName);
    $datresult = $sthresult -> fetchrow_arrayref ;
    $sthresult -> finish();
    
    if( $SQLQueryName ne "" ) {
      if( $fdat{SQLQueryID} != $SQLQueryID ) {
        $ValidationMessage .= "A Data SQL Query With The Name \"$fdat{SQLQueryName}\" Already Exists.<br>";
      }
    }
  }
		
  if( $ValidationMessage eq "" ) { $ValidationMessage = "ValidationOk"; }
		
  return( $ValidationMessage );
}
	


sub query_main_screen {
  $globalp->{siteheader}();
  echo("<script type=\"text/javascript\" charset=\"ISO-8859-1\" src=\"includes/PostAjaxLibrary.js\"></script>\n"
      ."<script type=\"text/javascript\" charset=\"ISO-8859-1\" src=\"modules/EplSiteETL/ExecQuery.js\"></script>\n");       
  echo("<LINK REL=\"StyleSheet\" HREF=\"includes/CodeMirror/lib/codemirror.css\" TYPE=\"text/css\">\n");
  echo("<script type=\"text/javascript\" src=\"includes/CodeMirror/lib/codemirror.js\"></script>\n");
  echo("<script type=\"text/javascript\" src=\"includes/CodeMirror/mode/sql/sql.js\"></script>\n");
  echo('<style>.CodeMirror {height: auto; border-top: 1px solid black;border-left: 1px solid black;'
      .'border-right: 1px solid black; border-bottom: 1px solid black;</style>' . "\n");
  echo('<style>.CodeMirror-gutters { background: #3366CC; border-right: 3px solid #3E7087; min-width:1em; }</style>' . "\n");
  echo('<style>.CodeMirror-linenumber { color: white; }</style>');
  echo('</head><body bgcolor="'.$globalp->{bodybgcolor}.'">');

  $globalp->{OpenTable}();		
  echo(""
      ."<table align=\"left\"><tr>"
      ."<td><b><big>EplSite Query Tool.&nbsp;&nbsp; - &nbsp;&nbsp;</big></b></td>"
      ."<td><form name=\"MaintainQuery\" action=\"index.prc\" method=\"post\">"
      ."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
      ."<input type=\"hidden\" name=\"option\" value=\"execquery\">\n"
      ."<div id=\"QueryList\"><select id=\"SQLQueryID\" name=\"SQLQueryID\">");

  if( $fdat{SQLQueryID} eq "" ) {
    echo("<option selected value=\"\">Select SQL Query</option>\n");
	} else {
		echo("<option value=\"\">Select SQL Query</option>\n");
	}

  $SelectQuery = "SELECT SQLQueryID, DefaultDataSource, SQLQueryName";
  $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_sqlqueries";
  $SelectQuery .= " ORDER BY SQLQueryName";
  $sthresult = $globalp->{dbh} -> prepare($SelectQuery)
                or die "Cannot prepare query:$SelectQuery";
  $sthresult -> execute  or die "Cannot execute query:$SelectQuery";
  $sthresult -> bind_columns(undef, \$SQLQueryID, \$DefaultDataSource, \$SQLQueryName);
		
  while( $datresult = $sthresult -> fetchrow_arrayref ) {
    $sel = " ";
    if( $fdat{SQLQueryID} eq $SQLQueryID ) { $sel= " selected "; }
    echo("<option" . $sel . "value=\"$SQLQueryID\">$SQLQueryName</option>\n");
  }
  $sthresult -> finish();

  echo("</select>\n"			
      ."<input type=\"submit\" name=\"queryoption\" VALUE=\"Display\">\n"
      ."&nbsp;<input type=\"button\" VALUE=\"Delete\"\n"
      ." onclick='JavaScript:xmlhttpPostScriptData(\"index.prc\",this.form,\"ResultsPane\",\"Delete\")'><br>\n"
      ."</form></div></td><td>");
				
  $SQLQueryName ="";
  $SQLQuery = "\n\n\n";
  $DefaultDataSource = 0;
		
  if( defined($fdat{SQLQueryID}) && $fdat{SQLQueryID} ne "" ) {
    $SelectQuery = "SELECT DefaultDataSource, SQLQueryName,SQLQuery";
    $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_sqlqueries";
    $SelectQuery .= " WHERE SQLQueryID= ".$fdat{SQLQueryID};
    $SelectQuery .= " ORDER BY SQLQueryName";
          
    $sthresult = $globalp->{dbh} -> prepare ($SelectQuery)
                  or die "Cannot prepare query:$SelectQuery";
    $sthresult -> execute  or die "Cannot execute query:$SelectQuery";
    $sthresult -> bind_columns(undef, \$DefaultDataSource, \$SQLQueryName, \$SQLQuery);
    $datresult = $sthresult -> fetchrow_arrayref ;
    $sthresult -> finish();
  }

  if( $fdat{DataSourceID} eq "" || !defined($fdat{DataSourceID} ) ) { $fdat{DataSourceID} = $DefaultDataSource; }
		
  echo("<form id=\"MainQuery\" name=\"EditQuery\" action=\"index.prc\" method=\"post\">"
      ."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
      ."<input type=\"hidden\" name=\"option\" value=\"execquery\">\n"
      ."<input type=\"hidden\" id=\"ValidationResult\" name=\"ValidationResult\" value=\"\">\n"
      ."<input type=\"hidden\" id=\"queryoption\" name=\"queryoption\" value=\"Export Query Results\">\n"
      ."<input type=\"hidden\" id=\"SQLQueryIDex\" name=\"SQLQueryID\" value=\"$fdat{SQLQueryID}\">\n"
      ."Query Name: <input type=\"text\" id=\"SQLQueryName\" name=\"SQLQueryName\" value=\"$SQLQueryName\" size=\"50\">\n"
    # ."&nbsp;&nbsp;<input type=\"submit\" name=\"queryoption\" VALUE=\"Save Query\"><br>\n"
    # ."&nbsp;&nbsp;<input type=\"button\" VALUE=\"Save Query\"\n"
    # ." onclick='JavaScript:SubtmitSaveData(this.form)'><br>\n"

      ."&nbsp;&nbsp;<input type=\"button\" VALUE=\"Save Query\"\n"
      ." onclick='JavaScript:xmlhttpPostScriptData(\"index.prc\",this.form,\"ResultsPane\",\"Save Query\")'><br>\n"
      ."</td></tr></table><br><br><br>\n");
		
  echo("<table width=\"100%\"><tr><td>Data Source:"
      ."<select id=\"DataSourceID\" name=\"DataSourceID\">");
					
  if( $fdat{DataSourceID} == 0 ) { 
    echo("<option selected value=\"0\"> - Select Data Source</option>\n");
  }	else {
    echo("<option value=\"0\"> - Select Data Source</option>\n");
  }
		
  $selectquery = "SELECT DataSourceID, DataSourceName";
  $selectquery .= " FROM ".$globalp->{table_prefix}."_etl_data_sources";
  $selectquery .= "	WHERE 1";
  $selectquery .= " ORDER BY DataSourceName";
        
  $resulti = $globalp->{dbh} -> prepare($selectquery) 
  or die echo("Cannot prepare Query $selectquery");
  $resulti -> execute  or die echo("Cannot Execute Query $selectquery");
  $resulti -> bind_columns(undef, \$DataSourceID, \$DataSourceName);

  while( $datresulti = $resulti -> fetchrow_arrayref ) {
    $sel= " ";
    if( $fdat{DataSourceID} eq $DataSourceID ) { $sel= " selected "; }
    
    echo("<option" . $sel ."value=\"$DataSourceID\">$DataSourceID - $DataSourceName</option>\n");
  }
  $resulti->finish();

  echo("</select>"
      ."<div class=\"tooltip\">?<span class=\"tooltiptext\">"
      ."To create and manage data sources go to <a href=\"admin.prc\" target=_blank>admin</a> -> EplSte ETL -> Database Connections."
      ."</span></div>"
      ."<b><big><big>||</big></big></b> ");
  echo("<input type=\"checkbox\" id=\"numofrecords\" name=\"numofrecords\" value=\"Yes\" >Show Records Count.");
  echo("<select id=\"QueryInstruction\" name=\"QueryInstruction\">"				
      ."<option selected value=\"1\">Execute Query</option>\n"
      ."<option value=\"2\">Execute Script</option>\n"
      ."</select>\n"
      ."<input type=\"button\" VALUE=\"Go\"\n"
      ." onclick='JavaScript:xmlhttpPostScriptData(\"index.prc\",this.form,\"ResultsPane\",\"Execute Query\")'>\n");
          
  echo(" <b><big><big>||</big></big></b> Fields Separator: <input type=\"text\" id=\"fseparator\" name=\"fseparator\" value=\"");
        
  if(defined($fdat{fseparator})) {
    echo( $fdat{fseparator});
  } else {
    echo("\|");
  }
  echo("\" size=\"1\">\n");
    
  echo("Fields Enclosed By: <input type=\"text\" id=\"fenclosed\" name=\"fenclosed\" value=\"");
    
  if(defined($fdat{fenclosed})) { echo($fdat{fenclosed}); }
		
  # if( $SQLQuery eq "" )
  # {
    # $SQLQuery = "\n\n\n";
  # }
		
  echo("\" size=\"1\">\n"
      ."<input type=\"checkbox\" id=\"headerline\" name=\"headerline\" value=\"Yes\" checked >Header Line.\n"
      ."<input type=\"button\" value=\"Export Query Results\"\n"
      ." onclick='JavaScript:xmlhttpPostScriptData(\"index.prc\",this.form,\"ResultsPane\",\"Export Query Results\")'>\n"
      ."<input type=\"button\" value=\"Results As Excel File\"\n"
      ." onclick='JavaScript:xmlhttpPostScriptData(\"index.prc\",this.form,\"ResultsPane\",\"Results As Excel File\")'>\n"		
      ."</td></tr></table>"
      ."<div style=\"max-height:420px;overflow:auto;\">"
      ."<table width=\"100%\"><tr><td>"        
      ."<textarea id=\"sqlscript\" name=\"sqlscript\">".$SQLQuery."</textarea>");
  echo('    <script>' . "\n");
  echo('      var sqleditor = CodeMirror.fromTextArea(document.getElementById("sqlscript"), {' . "\n");
  echo("		width: '100%',\n");
  echo("		height: '100%',\n");
  echo('		mode: "text/x-mysql",' . "\n");
  echo('		tabSize: 2,' . "\n");
  echo('		matchBrackets: true,' . "\n");
  echo('		lineNumbers: true,' . "\n");
  echo(' 		textWrapping: true,});' . "\n");
  echo('		sqleditor.on("blur", function(){ ' . "\n");
  echo('           sqleditor.save();' . "\n");
  echo('      });' . "\n");
  echo('    </script>' . "\n");                
  echo("</td></tr></table></div></form>\n");
            
  $globalp->{CloseTable}();					

    echo("<br>");
    $globalp->{OpenTable}();
    echo("<fieldset><legend>Results Pane</legend><div id=\"ResultsPane\">".$SaveQueryMessage."</div></fieldset>\n");	
    $globalp->{CloseTable}();

		
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
		$globalp->{clean_exit}();
}

	

sub query_delete {
  if( $fdat{SQLQueryID} eq "" ) { $globalp->{Display_SQLQuery_Error_For_Ajax_Routines}("Select SQL Query."); }
		
  if( $fdat{deletequery} eq "1" ) {
    $delete_dts_data = "DELETE FROM ".$globalp->{table_prefix}."_etl_sqlqueries WHERE SQLQueryID = $fdat{SQLQueryID}";
    $globalp->{dbh}->do( $delete_dts_data );
      
    delete $fdat{SQLQueryID};
    &redirect_url_to("index.prc?module=EplSiteETL&option=execquery");
  }	else {
    $SelectQuery = "SELECT SQLQueryName";
    $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_sqlqueries";
    $SelectQuery .= " WHERE SQLQueryID = $fdat{SQLQueryID}";
          
    $sthresult = $globalp->{dbh} -> prepare ( $SelectQuery ) 
                  or die "Cannot prepare query:$SelectQuery";
    $sthresult -> execute  or die "Cannot execute query:$SelectQuery";
    $sthresult -> bind_columns(undef, \$SQLQueryName);
    $datresult = $sthresult -> fetchrow_arrayref ;
    $sthresult -> finish();
    
    echo("<b><font color=\"red\">Do you want to delete query <b>$SQLQueryName?</b>\n"
        ." <a href=\"index.prc?\module=EplSiteETL&amp;option=execquery&amp;deletequery=1&amp;"
        ."SQLQueryID=$fdat{SQLQueryID}&amp;queryoption=Delete&amp;SQLQueryName=$SQLQueryName&amp;DivField=ResultsPane\">Yes</a>"
        ."&nbsp;&nbsp;<a href=\"javascript:ClearResultsPane('ResultsPane');\">No</a></font></b>");			
  }
}



sub query_saveandmaintain {
  $fdat{SQLQueryName} =~ s/'//g;
  $fdat{sqlscript} = $globalp->{FixScriptSlashesAndQuotes}($fdat{sqlscript});
  
  if ( $fdat{SQLQueryID} eq "" ) {
    $insert_script_data = "INSERT INTO ".$globalp->{table_prefix}."_etl_sqlqueries VALUES ( ";
    $insert_script_data .= "NULL,'$fdat{SQLQueryName}','$fdat{sqlscript}',$fdat{DataSourceID}";
    $insert_script_data .= ")";

    $globalp->{dbh}->do( $insert_script_data );
    
    $sthresult = $globalp->{dbh} -> prepare ("SELECT SQLQueryID, SQLQueryName FROM ".$globalp->{table_prefix}."_etl_sqlqueries WHERE SQLQueryName = \"$fdat{SQLQueryName}\"" )  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_sqlqueries";
    $sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_etl_sqlqueries ";
    $sthresult -> bind_columns(undef, \$SQLQueryID, \$SQLQueryName);
    $datresult = $sthresult -> fetchrow_arrayref ;
    $sthresult -> finish();
          $fdat{SQLQueryID} = $SQLQueryID;
    # &redirect_url_to("index.prc?module=EplSiteETL&option=execquery&SQLQueryID=".$SQLQueryID."&queryoption=Display");
  } else{
    $sqlqueriestable = "UPDATE ".$globalp->{table_prefix}."_etl_sqlqueries SET";
    $sqlqueriestable .= " DefaultDataSource = $fdat{DataSourceID},";
    $sqlqueriestable .= " SQLQueryName = '$fdat{SQLQueryName}',";
    $sqlqueriestable .= " SQLQuery='$fdat{sqlscript}' WHERE SQLQueryID=$fdat{SQLQueryID}";
    $globalp->{dbh}->do( $sqlqueriestable );
  }
}



sub Process_Execute_Query {	
  $database_connection = &connect_eplsite_sql_query_tool_data_source($fdat{DataSourceID});
  eval {
    $AffectedRows = $database_connection->do($fdat{sqlscript}) or die "Can not execute query:$fdat{sqlscript}";
  };
  if($@) {
    $QueryError = "<p><b>Error Executing SQL Query:$fdat{sqlscript}</b></p>";
    $database_connection->disconnect();
    $globalp->{Display_SQLQuery_Error_For_Ajax_Routines}($QueryError);			
  } else {
    echo("Query Execute Succesfully.<br> Affected Rows:" . $AffectedRows . ".");
  }
} # Process Execute Query



sub Process_Data_Search {
  my $StartTime = time;
  $database_connection = &connect_eplsite_sql_query_tool_data_source($fdat{DataSourceID});
 # $database_connection->{RowCacheSize} = 100;
  #$database_connection->{ora_check_sql} = 0;
    
  $offset = $globalp->{RecordsByScreenInQueryTool};
  $min = 0;
  if( defined($fdat{min}) ){ $min = $fdat{min}; }
  
  $max = ($min + $offset) ;
  if( defined($fdat{max})){ $max = $fdat{max}; }
        
  $RecordsDisplayedCounter = 1;
  my $HeaderPrinted = 0;
  
  $RecordCounter = 0;
  my $QueryError = "";
  $sqlerr = "";
      
  eval {
    $STHGetMySearchQuery = $database_connection->prepare($fdat{sqlscript});
    $sqlerr = $DBI::errstr;
  };
  if( $@ or $sqlerr ne "") {
    $QueryError = "<p><b>";
    if( $@ ) { $QueryError .= "Program Error:$@\n"; }
    if( $sqlerr ) { $QueryError .= "Query Error:$sqlerr\n"; }
    $QueryError .= "</b></p> ";
    undef $database_connection if( defined($database_connection));
    
    $QueryError =~ s/\n/<br>/g; 
    if( $fdat{queryoption} eq "Execute Query" ) {
      $globalp->{Display_SQLQuery_Error_For_Ajax_Routines}($QueryError);
    } else {
      $globalp->{General_EplSite_Error_Display}($QueryError);
    }
  }
      
  my $DataFound = 0;
  $sqlerr = "";
  
  eval {
    $STHGetMySearchQuery -> execute(); # or die "Cannot execute Query: $fdat{sqlscript}";
    # Printing rows to screen for debugging
    #while (my @row = $STHGetMySearchQuery->fetchrow_array) { print join(", ", @row), "\n"; }

    $STHGetMySearchQuery->{RaiseError} = 0;
    $sqlerr = $STHGetMySearchQuery->errstr();

    my $NumberOfFields = $STHGetMySearchQuery->{NUM_OF_FIELDS};
    my $queryColumns = $STHGetMySearchQuery->{NAME};  # Array ref of column names in order
    #my $NumberOfRecordsFound = $STHGetMySearchQuery->rows;
    my $NumberOfRecordsFound = 0;
    my $MyDataBaseName = $database_connection->get_info(17);

    my $MaxRecordsInTheArray = 120;
    if ( $NumberOfRecordsFound > 0 && $NumberOfRecordsFound < 120 ) { $MaxRecordsInTheArray = 1; }
    my $MyOraQueryRows = [];
    my %QueryValues = ();
  
#    while ( (my $MyQueryRow = (shift(@$MyOraQueryRows) 
#              || shift(@{$MyOraQueryRows=$STHGetMySearchQuery->fetchall_arrayref(undef,$MaxRecordsInTheArray)||[]})
#              || $STHGetMySearchQuery->fetchrow_array
#              ))
#              && $RecordsDisplayedCounter <= $max ) 
#    {

    while ( (my $MyQueryRow = $STHGetMySearchQuery->fetchrow_hashref) && $RecordsDisplayedCounter <= $max ) {

      $DataFound = 1;

      if( $HeaderPrinted == 0 ) {
        my $ReportHeaderLineSequence = "<th class =\"sqlresults\">Seq.</th>";
        my $ReportHeaderLine = "";
        
        if( $fdat{queryoption} eq "Results As Excel File" )	{ $ReportHeaderLine = "<table border=\"1\"><tr>"; }
        
        my $MyFirstField = $STHGetMySearchQuery->{NAME}[0];
        $MyFirstField =~ s/^\s+//; #remove leading spaces
        $MyFirstField =~ s/\s+$//; #remove trailing spaces
              
        if( $fdat{queryoption} eq "Export Query Results" or $fdat{queryoption} eq "Results As Excel File" ) {

          for(  my $Count = 0; $Count < $NumberOfFields; $Count++ ) {
            if( $fdat{queryoption} eq "Results As Excel File" ) {
              $ReportHeaderLine .= "<th>".$STHGetMySearchQuery->{NAME}[$Count]."</th>";
            }	else {						
              $ReportHeaderLine .= $fdat{fenclosed}.$STHGetMySearchQuery->{NAME}[$Count].$fdat{fenclosed};
              if( $Count < $NumberOfFields - 1 ) { $ReportHeaderLine .= $fdat{fseparator}; }
            }
          }
                      
          $fdat{SQLQueryName} =~ s/^\s+//; #remove leading spaces
          $fdat{SQLQueryName} =~ s/\s+$//; #remove trailing spaces
          
          if( $fdat{SQLQueryName} eq "" ){ $fdat{SQLQueryName} = "ExportQueryFile"; }

          if( $fdat{queryoption} eq "Results As Excel File" ) {
            $ReportHeaderLine .= "</tr>";
            &create_report_header($ReportHeaderLine,$fdat{SQLQueryName},"xls");
          } else {
            if( $fdat{headerline} eq "Yes" ) {
              &create_report_header($ReportHeaderLine,$fdat{SQLQueryName},"txt"); ## Set Report Header, File Name,Extension
            } else {
              &set_parameters_to_export_report_no_header($fdat{SQLQueryName},"txt"); ## Set Report File Name,Extension
            }
          }
        } else {
          for(  my $Count = 0; $Count < $NumberOfFields; $Count++ ) {
            $ReportHeaderLine .= "<th class =\"sqlresults\">" . $STHGetMySearchQuery->{NAME}[$Count] . "</th>\n";
          }
              
          echo("<table class =\"sqlresults\">\n"
              ."<tr class =\"sqlresults\">".$ReportHeaderLineSequence.$ReportHeaderLine."</tr>\n");	
        }
        $HeaderPrinted = 1;								 
      }
              
      $RecordCounter += 1;
      #$TheQueryRow = join("\~", @{$MyQueryRow});
      #@TheQueryArray = split("\~", $TheQueryRow);                
      @TheQueryArray = @$MyQueryRow{@$queryColumns}; # Since @TheQueryArray was used, entering the field values from the hashref to array

      if( $fdat{queryoption} eq "Export Query Results" or $fdat{queryoption} eq "Results As Excel File" ) {
      
        for(  my $Count = 0; $Count < $NumberOfFields; $Count++ ) {
          if( $fdat{queryoption} eq "Results As Excel File" ) {
            if( $Count == 0 ) { print "<tr>"; }
            $TheQueryArray[$Count] =~ s/\n/<br>/g;							
            print "<td>".$TheQueryArray[$Count]."</td>";
          } else {
            print $fdat{fenclosed}.$TheQueryArray[$Count].$fdat{fenclosed};
            if( $Count < $NumberOfFields - 1 ) { print $fdat{fseparator}; }
          }
        }
        
        if( $fdat{queryoption} eq "Results As Excel File" ) { print "</tr>"; }
        print "\n";
      } else {
        if( $RecordsDisplayedCounter > $min  ) {
          if( $RecordsDisplayedCounter % 2 == 0 ) {
            print "<tr class=\"evensqlresults\"><td class=\"evensqlresults\">";
          } else {
            print "<tr class=\"oddsqlresults\"><td class=\"oddsqlresults\">";
          }                           
                
          print $RecordsDisplayedCounter."</td>\n";
                                
          for(  my $Count = 0; $Count < $NumberOfFields; $Count++ ) {
            $TheQueryArray[$Count] =~ s/\s/&nbsp;/g;
            if( $RecordsDisplayedCounter % 2 == 0 ) {
              print "<td class =\"evensqlresults\">";
            } else {
              print "<td class =\"oddsqlresults\">";
            }

            print $TheQueryArray[$Count] . "</td>";
          }
          print "</tr>\n";
        }
        $RecordsDisplayedCounter++;
      }
    }
    $STHGetMySearchQuery->finish(); #### End Search Query
                
    if( $fdat{queryoption} eq "Results As Excel File" ) { print "</table>"; }
    
    if( $fdat{queryoption} eq "Execute Query" ) {

      echo("</table></div>");
      $prev = $RecordsDisplayedCounter - ( $offset * 2 ) -1;
      $prev = 0 if( $prev < 0 );
      echo("<tr><td colspan=\"5\"><table align=\"left\" border=\"0\"><tr>");
      if( ( $RecordsDisplayedCounter - 1 ) > $offset ) {
        echo("<td><left><form name=\"FormPreviousMatches\" action=\"index.prc\" method=\"post\">\n"
            ."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
            ."<input type=\"hidden\" name=\"min\" value=\"$prev\">\n"
            ."<input type=\"hidden\" name=\"option\" value=\"$fdat{option}\">\n"
            ."<input type=\"hidden\" name=\"DataSourceID\" value=\"$fdat{DataSourceID}\">\n"
            ."<input type=\"hidden\" name=\"QueryInstruction\" value=\"$fdat{QueryInstruction}\">\n"
            ."<input type=\"hidden\" name=\"numofrecords\" value=\"$fdat{numofrecords}\">\n"
            ."<input type=\"button\" Name=\"process\" VALUE=\"Previous $min Matches.\""
            ." OnClick='JavaScript:xmlhttpPostNavigation(\"index.prc\",this.form,\"ResultsPane\")'></form>"
            ."</left></td>");
      }

      $next = $RecordsDisplayedCounter + $offset;

      if( $RecordsDisplayedCounter > ( $min + $offset ) ) {

        echo("<td><left><form name=\"FormNextMatches\" action=\"index.prc\" method=\"post\">\n"
            ."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
            ."<input type=\"hidden\" name=\"min\" value=\"$max\">\n"
            ."<input type=\"hidden\" name=\"option\" value=\"$fdat{option}\">\n"
            ."<input type=\"hidden\" name=\"DataSourceID\" value=\"$fdat{DataSourceID}\">\n"
            ."<input type=\"hidden\" name=\"QueryInstruction\" value=\"$fdat{QueryInstruction}\">\n"
            ."<input type=\"hidden\" name=\"numofrecords\" value=\"$fdat{numofrecords}\">\n"
            ."<input type=\"button\" Name=\"process\" VALUE=\"Next Matches.\""						
            ." OnClick='JavaScript:xmlhttpPostNavigation(\"index.prc\",this.form,\"ResultsPane\")'></form>"
            ."</left></td>");							
      }
      echo("</tr></table><br><br>");
              
      if( $fdat{numofrecords} eq "Yes" && $DataFound ) {
        if( defined($NumberOfRecordsFound) && $NumberOfRecordsFound > 0 ) {
          echo("<p><b>Records found:</b>$NumberOfRecordsFound</p>");
        } else {
          $NumberOfRecordsFound = &GetNumberOfRecords($database_connection);
          echo("<p><b>Records found:</b>$NumberOfRecordsFound</p>");
        }                
      }
              
      if( $DataFound ) {
        $QueryTime = time - $StartTime;
        
        echo("<p><b>DataBase:$MyDataBaseName - Time To Execute Query:</b>$QueryTime ");
        if( $QueryTime == 1 ) {
          echo("Second.</p>");
        } else {
          echo("Seconds.</p>");
        }
      }
    }
  };
  if( $@ or $sqlerr ne "") {
    $QueryError = "<p><b>";
    if( $@ ){ $QueryError .= "Program Error:$@\n"; }
    if( $sqlerr ){ $QueryError .= "Query Error:$sqlerr\n"; }
    $QueryError .= "</b></p> ";
    undef $database_connection if( defined($database_connection) );
    
    $QueryError =~ s/\n/<br>/g; 
    if( $fdat{queryoption} eq "Execute Query" ) {
      $globalp->{Display_SQLQuery_Error_For_Ajax_Routines}($QueryError);
    } else {
      $globalp->{General_EplSite_Error_Display}($QueryError);
    }
  }
      
  if( not $DataFound && $QueryError eq "" ) {
    undef $database_connection if( defined($database_connection) );
    if( $fdat{queryoption} eq "Execute Query" ) {
      $globalp->{Display_SQLQuery_Error_For_Ajax_Routines}("<b>Not Data Found.</b>");
    } else {
      $globalp->{General_EplSite_Error_Display}("<b>Not Data Found.</b>");
    }
  }
      
  &CloseExtractScript($database_connection);
}


	
sub GetNumberOfRecords {
  my $CountDataSource = shift;
  my $MyNumberOfRecords = 0;        
  
  my $selectquery = "SELECT COUNT(*) ";
  $selectquery .= " FROM ( " . $fdat{sqlscript} . " ) QueryForCounting";
  
  eval {
    my $Countresulti = $CountDataSource -> prepare_cached ($selectquery)
                        or die "Cannot prepare Query:$selectquery";
    $Countresulti -> execute  or die "Cannot Execute Query:$selectquery";
    $Countresulti -> bind_columns(undef,  \$MyNumberOfRecords);
    my $Countdatresulti = $Countresulti -> fetchrow_arrayref ;
    $Countresulti->finish();
  };
  if( $@ ) {
    my $CountDataSource2;
    eval {
      $CountDataSource2 = &connect_eplsite_sql_query_tool_data_source($fdat{DataSourceID});
      $Countresulti = $CountDataSource2 -> prepare_cached($selectquery)
				              or die "Cannot prepare Query:$selectquery";
      my $Countresulti -> execute or die "Cannot Execute Query:$selectquery";
      $Countresulti -> bind_columns(undef,  \$MyNumberOfRecords);
      my $Countdatresulti = $Countresulti -> fetchrow_arrayref ;
      $Countresulti->finish();                
      $CountDataSource2->disconnect();
    };
		if( $@ ) {
      $MyNumberOfRecords = "Error counting records.";                
		}
		undef $CountDataSource2 if( defined( $CountDataSource2 ));
	}			
		
	return($MyNumberOfRecords);
}



sub connect_eplsite_sql_query_tool_data_source {        
  my $MyDataSourceScriptID = shift;
  my $DataSourceName = "";

  if( $fdat{queryoption} eq "Execute Query" ) {
    $DataSourceName = $globalp->{connect_data_source}($MyDataSourceScriptID,"Ajax");
  } else {
    $DataSourceName = $globalp->{connect_data_source}($MyDataSourceScriptID,"Submit");
  }            
  return($MyDataSourceName);
}



sub UpdateQueryList {
  echo("<select id=\"SQLQueryID\" name=\"SQLQueryID\">");
      
  if( $fdat{SQLQueryName} eq "" ) {
    echo("<option selected value=\"\">Select SQL Query</option>\n");
  } else {
    echo("<option value=\"\">Select SQL Query</option>\n");
  }
		
  $SelectQuery = "SELECT SQLQueryID,SQLQueryName";
  $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_sqlqueries";
  $SelectQuery .= " ORDER BY SQLQueryName";
      
  $sthresult = $globalp->{dbh} -> prepare($SelectQuery)
                or die "Cannot prepare query:$SelectQuery";
  $sthresult -> execute  or die "Cannot execute query:$SelectQuery";
  $sthresult -> bind_columns(undef, \$SQLQueryID, \$SQLQueryName);
  
  while( $datresult = $sthresult -> fetchrow_arrayref ) {
    $sel = " ";
    $sel = " selected " if( $fdat{SQLQueryName} eq $SQLQueryName );
    echo("<option" . $sel . "value=\"".$SQLQueryID."\">".$SQLQueryName."</option>\n");
  }
  $sthresult -> finish();

  echo("</select>\n"			
      ."<input type=\"submit\" name=\"queryoption\" VALUE=\"Display\">\n"
      ."&nbsp;<input type=\"button\" value=\"Delete\"\n"
      ." onclick='JavaScript:xmlhttpPostScriptData(\"index.prc\",this.form,\"ResultsPane\",\"Delete\")'><br>\n"
      ."</form>");
  $globalp->{clean_exit}();
}

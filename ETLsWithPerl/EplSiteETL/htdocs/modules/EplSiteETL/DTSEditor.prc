########################################################################
# Eplsite ETL, Maintain transformation scripts
# Copyright (C) 2012 by Carlos Kassab (laran.ikal@gmail.com)
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
	
	our( $oracle_connection, @the_cvalues );
	@the_cvalues = $globalp->{get_the_cookie}();
	
	if( $fdat{scriptoption} eq "" or not defined($fdat{scriptoption}) )
	{
		&Display_DTS_Editor_Menu();
	}
	elsif( $fdat{scriptoption} eq "create" )
	{
		$ValidationResult = &ValidatePostedFormData();
		
		if( $ValidationResult eq "ValidationOk" )
		{
			## If the process was not stopped before, the script is created.
			$fdat{DTSName} =~ s/ /_/g;
			
			$insert_script_data = "INSERT INTO ".$globalp->{table_prefix}."_etl_transformationscripts VALUES ( ";
			$insert_script_data .= "NULL,'".$fdat{DTSName}."',''";
			$insert_script_data .= ")";
			#~ echo($insert_script_data); exit;
			$globalp->{dbh}->do( $insert_script_data );

			&Display_DTS_Editor_Menu();
		}
		else
		{
			&Display_DTS_Error($ValidationResult);
		}		
	}
	elsif( $fdat{Maintain} eq "Maintain" )
	{
		if($fdat{DTSID} eq "" ) { &Display_DTS_Editor_Menu(); }
		&dts_edit();
	}
	elsif( $fdat{Maintain} eq "Delete" )
	{
		if($fdat{DTSID} eq "" ) { &Display_DTS_Editor_Menu(); }
		&dts_delete();
	}
	elsif( $fdat{Maintain} eq "SaveAndCheck" )
	{
		&dts_saveandcheck();
	}	



############################# Sub Routines #######################################

	sub ValidatePostedFormData
	{
		$ValidationMessage = "";

		if( $fdat{DTSName} eq "" or not defined($fdat{DTSName}) )
		{
			$ValidationMessage .= "Enter Data Transformation Script Name.<br>";
		}
		$TransformationScriptName = "";
        $SelectDTS = "SELECT TransformationScriptName";
        $SelectDTS .= " FROM ".$globalp->{table_prefix}."_etl_transformationscripts";
        $SelectDTS .= " WHERE TransformationScriptName = '".$fdat{DTSName}."'" ;
        
		$sthresult = $globalp->{dbh} -> prepare ($SelectDTS)
        or die "Cannot prepare query:$SelectDTS";
		$sthresult -> execute or die "Cannot execute query:$SelectDTS";
		$sthresult -> bind_columns(undef, \$TransformationScriptName);
		$datresult = $sthresult -> fetchrow_arrayref ;
		$sthresult -> finish();
		
		if( $TransformationScriptName ne "" )
		{
			$ValidationMessage .= "A Data Transformation Script With The Name \"$fdat{DTSName}\" Already Exists.<br>";
		}
		
		if( $ValidationMessage eq "" )
		{
			$ValidationMessage = "ValidationOk";
		}
		
		return( $ValidationMessage );
	}



	sub DTSEditor_Menu
	{
		
		echo("<b><big><center>Maintain Data Transformation Scripts ( DTS ).</center></big></b><br>"
				."<table align=\"center\"><tr><td><form name=\"MaintainDTS\" action=\"index.prc\" method=\"post\">"
				."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
				."<input type=\"hidden\" name=\"option\" value=\"setupxportlayouts\">\n"
				."<input type=\"hidden\" name=\"scriptoption\" value=\"maintain\">\n"
				."<input type=\"hidden\" name=\"MaintainDTS\" value=\"1\">\n"
				."<select name=\"DTSID\"><option value=\"\">Select Data Transformation Script</option>\n");
			
		$sthresult = $globalp->{dbh} -> prepare ("SELECT TransformationScriptID,TransformationScriptName FROM ".$globalp->{table_prefix}."_etl_transformationscripts ORDER BY TransformationScriptName")  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_transformationscripts";
		$sthresult -> execute  or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_etl_transformationscripts";
		$sthresult -> bind_columns(undef, \$TransformationScriptID, \$TransformationScriptName);
		
		while( $datresult = $sthresult -> fetchrow_arrayref ) {
			echo("<option value=\"$TransformationScriptID\">$TransformationScriptName</option>\n");
		}
		$sthresult -> finish();

		echo("</select>\n"			
			."<input type=\"submit\" name=\"Maintain\" VALUE=\"Maintain\">\n"
				."<input type=\"submit\" name=\"Maintain\" VALUE=\"Delete\">\n"
				."</form></td><td>\n");
				
		echo("<form name=\"CreateDTS\" action=\"index.prc\" method=\"post\">"
				."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
				."<input type=\"hidden\" name=\"option\" value=\"setupxportlayouts\">\n"
				."<input type=\"hidden\" name=\"scriptoption\" value=\"create\">\n"
				."<input type=\"hidden\" name=\"MaintainDTS\" value=\"1\">\n"
				."Enter DTS Name: <input type=\"text\" name=\"DTSName\" value=\"\" size=\"50\">\n"
				."<input type=\"submit\" VALUE=\"Create\">\n"
				."</form></td></tr></table><br>\n");

		#~ echo("<fieldset><legend>Results Pane</legend><div id=\"ResultsPane\"></div></fieldset>\n");	
	}
	
	

	sub dts_edit
	{		
		$globalp->{siteheader}();
		echo("<script type=\"text/javascript\" src=\"includes/PostAjaxLibrary.js\"></script>\n"
            ."<script type=\"text/javascript\" src=\"modules/EplSiteETL/DTSEditor.js\"></script>\n");
        echo('<style>.CodeMirror {border-top: 1px solid black;border-left: 1px solid black;border-right: 1px solid black; border-bottom: 1px solid black;}</style>' . "\n");
        
		echo("<LINK REL=\"StyleSheet\" HREF=\"includes/CodeMirror/lib/codemirror.css\" TYPE=\"text/css\">\n");
		echo("<script type=\"text/javascript\" src=\"includes/CodeMirror/lib/codemirror.js\"></script>\n");
		echo("<script type=\"text/javascript\" src=\"includes/CodeMirror/mode/perl/perl.js\"></script>\n");
        echo('<style>.CodeMirror {height: 550px;}</style>');
        echo('<style>.CodeMirror-gutters { background: #3366CC; border-right: 3px solid #3E7087; min-width:1em; }</style>' . "\n");
        echo('<style>.CodeMirror-linenumber { color: white; }</style>');
            
		$globalp->{theheader}();
		$globalp->{OpenTable}();		
		echo("<b><big><center>Maintain Data Transformation Scripts ( DTS ).</center></big></b><br>"
				."<table align=\"center\"><tr><td><form name=\"MaintainDTS\" action=\"index.prc\" method=\"post\">"
				."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
				."<input type=\"hidden\" name=\"option\" value=\"setupxportlayouts\">\n"
				."<input type=\"hidden\" name=\"scriptoption\" value=\"maintain\">\n"
				."<input type=\"hidden\" name=\"MaintainDTS\" value=\"1\">\n"
				."<select name=\"DTSID\"><option value=\"\">Select Data Transformation Script</option>\n");

        $SelectQuery = "SELECT TransformationScriptID,TransformationScriptName";
        $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_transformationscripts";
        $SelectQuery .= " ORDER BY TransformationScriptName";
		$sthresult = $globalp->{dbh} -> prepare ($SelectQuery)
        or die "Cannot prepare query:$SelectQuery";
		$sthresult -> execute  or die "Cannot execute query:$SelectQuery";
		$sthresult -> bind_columns(undef, \$TransformationScriptID, \$TransformationScriptName);
		
		while( $datresult = $sthresult -> fetchrow_arrayref ) {
			echo("<option value=\"$TransformationScriptID\">$TransformationScriptName</option>\n");
		}
		$sthresult -> finish();

		echo("</select>\n"			
			."<input type=\"submit\" name=\"Maintain\" VALUE=\"Maintain\">\n"
				."<input type=\"submit\" name=\"Maintain\" VALUE=\"Delete\">\n"
				."</form></td><td>\n");
				
		echo("<form name=\"CreateDTS\" action=\"index.prc\" method=\"post\">"
				."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
				."<input type=\"hidden\" name=\"option\" value=\"setupxportlayouts\">\n"
				."<input type=\"hidden\" name=\"scriptoption\" value=\"create\">\n"
				."<input type=\"hidden\" name=\"MaintainDTS\" value=\"1\">\n"
				."Enter DTS Name: <input type=\"text\" name=\"DTSName\" value=\"\" size=\"50\">\n"
				."<input type=\"submit\" VALUE=\"Create\">\n"
				."</form></td></tr></table>\n");

        $SelectQuery = "SELECT TransformationScriptName,TransformationScript";
        $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_transformationscripts";
        $SelectQuery .= " WHERE TransformationScriptID= ".$fdat{DTSID};
        $SelectQuery .= " ORDER BY TransformationScriptName";
		$sthresult = $globalp->{dbh} -> prepare ($SelectQuery)
        or die "Cannot prepare query:$SelectQuery";
		$sthresult -> execute  or die "Cannot execute query:$SelectQuery";
		$sthresult -> bind_columns(undef, \$TransformationScriptName, \$TransformationScript);
		
		if( $datresult = $sthresult -> fetchrow_arrayref ) 
        {
            if( $globalp->{All_Trim}($TransformationScript) eq "" )
            {
                $TransformationScript = "sub ".$TransformationScriptName ."\n";
                $TransformationScript .= "{\n   \$ReturnValue = 'TBD';\n\n\n";
                $TransformationScript .= "  return(\$ReturnValue);\n}";
            }
            
			echo("<table width = \"100%\"><tr><td><form name=\"EditDTS\" action=\"index.prc\" method=\"post\">"
					."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
					."<input type=\"hidden\" name=\"option\" value=\"setupxportlayouts\">\n"
					."<input type=\"hidden\" name=\"scriptoption\" value=\"saveandcheck\">\n"
					."<input type=\"hidden\" name=\"Maintain\" value=\"SaveAndCheck\">\n"
					."<input type=\"hidden\" name=\"DTSID\" value=\"$fdat{DTSID}\">\n"
					."<input type=\"hidden\" name=\"MaintainDTS\" value=\"1\">\n"
					."<big><b>Editing dts</b>:<font color=\"blue\"><big>$TransformationScriptName</big>"
                    ."</font> - The subroutine name must be:<u>".$TransformationScriptName."</u>"
					." and must return a value ej: return(\$returnvalue);</big>"
					."<textarea id=\"myperlscript\" name=\"perlscript\">"
                    .$TransformationScript."</textarea>\n");
            echo('    <script>' . "\n");
            echo('      var editor = CodeMirror.fromTextArea(document.getElementById("myperlscript"), {' . "\n");
            echo(" width: '100%',");
            echo(" height: '100%',");
            echo('        mode: "text/x-perl",' . "\n");
            echo('        tabSize: 2,' . "\n");
            echo('        matchBrackets: true,' . "\n");
            echo('        lineNumbers: true,' . "\n");
			echo(' 		textWrapping: true,});' . "\n");
			echo('		editor.on("blur", function(){ ' . "\n");
			echo('           editor.save();' . "\n");
            echo('      });' . "\n");
            echo('    </script>' . "\n");                
                    
            echo("<br><input type=\"button\" VALUE=\"Save And Check Script Syntax\"\n"
					." onclick='JavaScript:xmlhttpPostScriptData(\"index.prc\",this.form,\"ResultsPane\")'>\n"					
					."</form></td></tr></table><br>\n");

			echo("<fieldset><legend>Check Syntax Results Pane</legend><div id=\"ResultsPane\"></div></fieldset>\n");	
		}
		$sthresult -> finish();

		$globalp->{CloseTable}();
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
		$globalp->{clean_exit}();
	}

	


	sub Display_DTS_Error	
	{
		my $DTSErrorToDisplay = shift;
		
		$globalp->{siteheader}();
		$globalp->{theheader}();
		$globalp->{OpenTable}();

		echo("<p><b><font color=\"red\">Validation Errors Found</font></b>:<br><br>$DTSErrorToDisplay</p>"
				."<br>$globalp->{_GOBACK}");
		
		$globalp->{CloseTable}();
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
		$globalp->{clean_exit}();	
	}
	


	sub dts_delete
	{
		if( $fdat{DTSID} eq "" ) 
		{
			&Display_DTS_Error("Select Transformation Script.");
		}
		
		if( $fdat{deletedts} eq "1" )
		{
			$delete_dts_data = "DELETE FROM ".$globalp->{table_prefix}."_etl_transformationscripts";
            $delete_dts_data .= " WHERE TransformationScriptID = $fdat{DTSID}";
			$globalp->{dbh}->do( $delete_dts_data );
				
			delete $fdat{DTSID};
			&Display_DTS_Editor_Menu();			
		}
		else
		{
			$globalp->{siteheader}();
			$globalp->{theheader}();

			@the_cvalues = $globalp->{get_the_cookie}();		

			$deletequery = "SELECT TransformationScriptName FROM ".$globalp->{table_prefix};
			$deletequery .= "_etl_transformationscripts WHERE TransformationScriptID = $fdat{DTSID}" ;
			
			$sthresult = $globalp->{dbh} -> prepare ($deletequery)  or die echo("Cannot execute Query $deletequery");
			$sthresult -> execute  or die echo("Cannot execute Query $deletequery");
			$sthresult -> bind_columns(undef, \$TransformationScriptName);
			$datresult = $sthresult -> fetchrow_arrayref ;
			$sthresult -> finish();
			
			echo("Do you want to delete script <b>$TransformationScriptName?</b>\n"
					." <a href=\"index.prc?\module=EplSiteETL&amp;option=setupxportlayouts&amp;deletedts=1&amp;"
					."DTSID=$fdat{DTSID}&amp;Maintain=Delete&amp;MaintainDTS=1&amp;scriptoption=maintain\">Yes</a>"
					."&nbsp;&nbsp;$globalp->{_GOBACK}");			

			$globalp->{CloseTable}();
			$globalp->{loggedon_as}();
			$globalp->{sitefooter}();
			$globalp->{clean_exit}();
		}
	}


	
	sub Display_DTS_Editor_Menu
	{
		$globalp->{siteheader}();
		$globalp->{theheader}();
		$globalp->{OpenTable}();

		&DTSEditor_Menu();	
		
		$globalp->{CloseTable}();
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
		$globalp->{clean_exit}();			
	}
	
	
	
	sub dts_saveandcheck
	{
		$PerlScriptToEval = $fdat{perlscript};
		$fdat{perlscript} = $globalp->{FixScriptSlashesAndQuotes}($fdat{perlscript});

		$update_script_data = "UPDATE ".$globalp->{table_prefix}."_etl_transformationscripts";
		$update_script_data .= " SET TransformationScript='".$fdat{perlscript}."'"; 
        $update_script_data .= " WHERE TransformationScriptID=".$fdat{DTSID};

		echo("Script saved at ".$globalp->{get_localtime}(time));
		eval $PerlScriptToEval;
		if( $@ )
		{
			echo("<br><p>$@</p>");
		}
		else
		{
			echo("<br><p>No Syntax Error Found.</p>");
		}
		
		$globalp->{dbh}->do( $update_script_data );				
		$globalp->{clean_exit}();
	}
	
	
	

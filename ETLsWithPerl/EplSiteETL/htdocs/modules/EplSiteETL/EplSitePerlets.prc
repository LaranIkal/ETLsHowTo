########################################################################
# Eplsite,Addresses script to execute Perlets
#EplSite: Web Portal And MigrationFramework System.
#Copyright (C) 2011 by Carlos Alberto Kassab (laran.ikal@gmail.com)
########################################################################



    if( $globalp->{loaded_from_index} != 1 ) {
        echo("Access denied!!!!");
        if( defined($ENV{MOD_PERL}) ) {
            Apache::exit;
        }else{  exit(); }
    }
	
	our( $oracle_connection, @the_cvalues );
	@the_cvalues = $globalp->{get_the_cookie}();
	
	if( $fdat{perletoption} eq "" or not defined($fdat{perletoption}) )
	{
		$fdat{PerletID} = "";
		&perlets_main_screen();
	}
	elsif( $fdat{perletoption} eq "Save And Check Perlet" )
	{
		$ValidationResult = &ValidatePostedFormData();
		
		if( $ValidationResult eq "ValidationOk" )
		{
			## If the process was not stopped before, the query is created.

			&perlet_saveandmaintain();
			
			$PerletCheckingResult = $globalp->{EplSitePerlCheckSyntax}($fdat{perletscript},"Perlet");
			#~ $PerletCheckingResult = $globalp->{EplSitePerlCheckSyntax}($fdat{perletscript},"Perlet","Yes"); #To Keep Temporary Files Created.
			
			if( $PerletCheckingResult ne "")
			{
				$PerletCheckingError .= "<b>Perlet saved but, it has errors:</b><br> " . $PerletCheckingResult ."<br><br>";
				&Display_PerletScript_Error($PerletCheckingError);
			}
			else
			{
				&perlets_main_screen();
			}
		}
		else
		{
			&Display_PerletScript_Error($ValidationResult);
		}		
	}
	elsif( $fdat{perletoption} eq "Display" )
	{
		&perlets_main_screen();
	}
	elsif( $fdat{perletoption} eq "Delete" )
	{
		&perlet_delete();
	}
	elsif( $fdat{perletoption} eq "Output To File" or $fdat{perletoption} eq "Output To Screen" )	
	{
		$PerletScrtipToExecute = $fdat{perletscript};
		
		$fdat{perletscript} =~ s/^\s+//; #remove leading spaces
		$fdat{perletscript} =~ s/\s+$//; #remove trailing spaces

		if( $fdat{perletscript} eq "" )
		{
			&Display_PerletScript_Error("<b>Enter Perl Script To Execute.</b>");
		}
		else
		{
			$PerletCheckingResult = $globalp->{EplSitePerlCheckSyntax}($fdat{perletscript},"Perlet");
			#~ $PerletCheckingResult = $globalp->{EplSitePerlCheckSyntax}($fdat{perletscript},"Perlet","Yes"); #To Keep Temporary Files Created.
			
			if( $PerletCheckingResult ne "")
			{
				$PerletCheckingError .= "<b>Perlet saved but, it has errors:</b><br> " . $PerletCheckingResult ."<br><br>";
				&Display_PerletScript_Error($PerletCheckingError);
			}
			else
			{			
				if( $fdat{perletoption} eq "Output To File" )
				{
					&set_parameters_to_export_report_no_header($fdat{PerletName},"txt"); ## Set Report File Name,Extension
					eval $fdat{perletscript};
				}
				elsif( $fdat{perletoption} eq "Output To Screen" )
				{
					$globalp->{siteheader}();
					$globalp->{OpenTable}();						
					echo("<form><textarea cols=\"130\" rows=\"50\">");
					eval $fdat{perletscript};
                    echo("</textarea></form>");
					$globalp->{CloseTable}();					
					echo("<br>");
					$globalp->{sitefooter}();
					$globalp->{clean_exit}();					
				}
			}			
		}		
	}



############################# Sub Routines #######################################

	sub ValidatePostedFormData
	{
		@the_cvalues = $globalp->{get_the_cookie}();
		$ValidationMessage = "";
		
		$fdat{PerletName} =~ s/^\s+//; #remove leading spaces
		$fdat{PerletName} =~ s/\s+$//; #remove trailing spaces
		$fdat{PerletName} =~ s/'//g;

		$fdat{PerletName} =~ s/ /_/g;
		
		if( $fdat{PerletName} eq "" or not defined($fdat{PerletName}) )
		{
			$ValidationMessage .= "Enter Perlet Name.<br>";
		}
		else
		{
			$PerletName = "";
			$PerletID = 0;
			$PerletValidationQuery = "SELECT PerletID, PerletName";
			$PerletValidationQuery .= " FROM ".$globalp->{table_prefix}."_mf_perlets";
			$PerletValidationQuery .= " WHERE MFUser = '". $the_cvalues[1] ."'";
			$PerletValidationQuery .= "  AND PerletName = '" . $fdat{PerletName} . "'";
			
			$sthresult = $globalp->{dbh} -> prepare( $PerletValidationQuery)  or die "Cannot prepare query: $PerletValidationQuery";
			$sthresult -> execute  or die "Cannot execute query: $PerletValidationQuery";
			$sthresult -> bind_columns(undef, \$PerletID, \$PerletName);
			$datresult = $sthresult -> fetchrow_arrayref ;
			#~ $sthresult -> finish();
			
			if( $PerletName ne "" )
			{
				if( $fdat{PerletID} != $PerletID )
				{
					$ValidationMessage .= "A Perlet With The Name";
					$ValidationMessage .= " \"$fdat{PerletName}\" Already Exists";
					$ValidationMessage .= " For User $the_cvalues[1].<br>";
				}				
			}			
		}
			
		
		if( $ValidationMessage eq "" )
		{
			$ValidationMessage = "ValidationOk";
		}
		
		return( $ValidationMessage );
	}



	

	sub perlets_main_screen
	{		
		@the_cvalues = $globalp->{get_the_cookie}();
		$globalp->{siteheader}();
		echo("<LINK REL=\"StyleSheet\" HREF=\"".$globalp->{eplsite_url}."includes/perleditorlib/codemirror.css\" TYPE=\"text/css\">\n");
		echo("<script type=\"text/javascript\" src=\"".$globalp->{eplsite_url}."includes/perleditorlib/codemirror.js\"></script>\n");
		echo("<script type=\"text/javascript\" src=\"".$globalp->{eplsite_url}."includes/perleditorlib/perl.js\"></script>\n");
		echo('<style type="text/css">.CodeMirror {border-top: 1px solid black; border-bottom: 1px solid black;}</style>');
		
		#~ echo("<script type=\"text/javascript\" charset=\"ISO-8859-1\" src=\"".$globalp->{eplsite_url}."includes/PostAjaxLibrary.js\"></script>\n"
				#~ ."<script type=\"text/javascript\" charset=\"ISO-8859-1\" src=\"".$globalp->{eplsite_url}."modules/DataExtract/EplSitePerlets.js\"></script>\n");
		#~ $globalp->{theheader}();
		$globalp->{OpenTable}();	
	
		echo("<table align=\"left\"><tr><td><form name=\"MaintainPerlet\" action=\"index.prc\" method=\"post\">"
				."<input type=\"hidden\" name=\"module\" value=\"DataExtract\">\n"
				."<input type=\"hidden\" name=\"option\" value=\"perlets\">\n"
				."<table align=\"left\"><tr><td>"
				."<b><big><big><left><u>EplSite Perl Scripts.</u></left></big></big></b></td><td>"
				."&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name=\"PerletID\">");
				
		if( $fdat{PerletID} eq "" or $fdat{PerletID} eq "0" )
		{
			echo("<option selected value=\"\">Select Perlet</option>\n");
		}
		else
		{
			echo("<option value=\"\">Select Perlet</option>\n");
		}
		
		$PerletQuery = "SELECT PerletID, PerletName FROM ".$globalp->{table_prefix}."_mf_perlets";
		$PerletQuery .= " WHERE MFUser = '$the_cvalues[1]'";
		$PerletQuery .= " ORDER BY PerletName";
		#~ echo("PerletQuery:".$PerletQuery); exit;	
		$sthresult = $globalp->{dbh} -> prepare($PerletQuery)  or die "Cannot prepare query: $PerletQuery";
		$sthresult -> execute  or die "Cannot execute query: $PerletQuery";
		$sthresult -> bind_columns(undef, \$PerletID, \$PerletName);
		
		while( $datresult = $sthresult -> fetchrow_arrayref ) 
		{
			$sel = " ";
			if( $fdat{PerletID} eq $PerletID ) { $sel= " selected "; }
			echo("<option" . $sel . "value=\"$PerletID\">$PerletName</option>\n");
		}
		$sthresult -> finish();

		echo("</select>\n"			
				."<input type=\"submit\" name=\"perletoption\" VALUE=\"Display\">\n"
				."<input type=\"submit\" name=\"perletoption\" VALUE=\"Delete\">\n"
				."</form></td>"
				."</tr></table></td></tr>\n");
		
		$PerletName ="";
		$PerletScript = "";
		#~ echo($fdat{PerletID}); exit;
		if( defined($fdat{PerletID})  && $fdat{PerletID} ne "" )
		{
			$PerletSelect = "SELECT PerletName,PerletScript FROM ".$globalp->{table_prefix}."_mf_perlets";
			$PerletSelect .= " WHERE PerletID= $fdat{PerletID}";
			
			$sthresult = $globalp->{dbh} -> prepare ($PerletSelect)  or die "Cannot prepare query:$PerletSelect";
			$sthresult -> execute  or die "Cannot execute query: $PerletSelect";
			$sthresult -> bind_columns(undef, \$PerletName, \$PerletScript);
			$datresult = $sthresult -> fetchrow_arrayref ;
			#~ $sthresult -> finish();
		}
		
			echo("<tr><td><table align=\"left\"><tr><td><form name=\"EditPerlet\" action=\"index.prc\" method=\"post\">"
					."<input type=\"hidden\" name=\"module\" value=\"DataExtract\">\n"
					."<input type=\"hidden\" name=\"option\" value=\"perlets\">\n"
					."<input type=\"hidden\" name=\"\" value=\"saveandmaintain\">\n"
					."<input type=\"hidden\" name=\"PerletID\" value=\"$fdat{PerletID}\">\n"
					."<big><b>Perlet Name:</b></big><input type=\"text\" name=\"PerletName\" value=\"$PerletName\" size=\"50\">\n"
					."&nbsp;&nbsp;&nbsp;<input type=\"submit\" name=\"perletoption\" VALUE=\"Save And Check Perlet\">\n"
					."&nbsp;&nbsp;&nbsp;<input type=\"submit\" name=\"perletoption\" VALUE=\"Output To Screen\">\n"
					."&nbsp;&nbsp;&nbsp;<input type=\"submit\" name=\"perletoption\" VALUE=\"Output To File\">\n"					
					."<br>\n"
					."<div><textarea id=\"code\" name=\"perletscript\">\n"
					."$PerletScript</textarea></div>"
					."<script>"
					.'var editor = CodeMirror.fromTextArea(document.getElementById("code"), {'
					.'		lineNumbers: true,'
					.'		matchBrackets: true'
					.'});'
					.'</script>'
					."\n"
					#~ ."</td></tr><tr><td>"
					."</td></tr></table></form></td></tr></table>\n");
					
			$globalp->{CloseTable}();					

			#~ echo("<br>");
			#~ $globalp->{OpenTable}();
			#~ echo("<fieldset><legend>Results Pane</legend><div id=\"ResultsPane\"></div></fieldset>\n");	
			#~ $globalp->{CloseTable}();

		
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
		$globalp->{clean_exit}();
	}




	sub Display_PerletScript_Error	
	{
		my $PerletScriptErrorToDisplay = shift;
		
		$globalp->{siteheader}();
		$globalp->{theheader}();
		$globalp->{OpenTable}();

		echo("<p><b><font color=\"red\">Errors Found</font></b>:<br><br>$PerletScriptErrorToDisplay</p>"
				."<br>$globalp->{_GOBACK}");
				#~ ."<br><a href=\"index.prc?\module=DataExtract&amp;option=perlets&amp;perletoption=Display&amp;"
					#~ ."PerletID=$fdat{PerletID}\">Edit Perlet</a>");
		
		$globalp->{CloseTable}();
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
		$globalp->{clean_exit}();	
	}




	sub Display_PerletScript_Error2
	{
		my $PerletScriptErrorToDisplay = shift;
		
		$globalp->{siteheader}();
		$globalp->{theheader}();
		$globalp->{OpenTable}();

		echo("<p><b><font color=\"red\">Errors Found</font></b>:<br><br>$PerletScriptErrorToDisplay</p>"
				."<br>$globalp->{_GOBACK}");
				
		$globalp->{CloseTable}();
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
		$globalp->{clean_exit}();	
	}
	
	


	sub perlet_delete
	{
		if( $fdat{PerletID} eq "" or $fdat{PerletID} eq "0" ) 
		{
			&Display_PerletScript_Error("Select Perlet.");
		}
		
		if( $fdat{deleteperlet} eq "1" )
		{
			$delete_dts_data = "DELETE FROM ".$globalp->{table_prefix}."_mf_perlets WHERE PerletID = $fdat{PerletID}";
			$globalp->{dbh}->do( $delete_dts_data );
				
			delete $fdat{PerletID};
			&perlets_main_screen();			
		}
		else
		{
			$globalp->{siteheader}();
			$globalp->{theheader}();

			@the_cvalues = $globalp->{get_the_cookie}();		

			$sthresult = $globalp->{dbh} -> prepare ("SELECT PerletName FROM ".$globalp->{table_prefix}."_mf_perlets WHERE PerletID = $fdat{PerletID}" )  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_mf_perlets";
			$sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_mf_perlets ";
			$sthresult -> bind_columns(undef, \$PerletName);
			$datresult = $sthresult -> fetchrow_arrayref ;
			#~ $sthresult -> finish();
			
			echo("Do you want to delete the Perlet <b>$PerletName?</b>\n"
					." <a href=\"index.prc?\module=DataExtract&amp;option=perlets&amp;deleteperlet=1&amp;"
					."PerletID=$fdat{PerletID}&amp;perletoption=Delete\">Yes</a>"
					."&nbsp;&nbsp;$globalp->{_GOBACK}");			

			$globalp->{CloseTable}();
			$globalp->{loggedon_as}();
			$globalp->{sitefooter}();
			$globalp->{clean_exit}();
		}
	}


	

	
	
	sub perlet_saveandmaintain
	{		
		@the_cvalues = $globalp->{get_the_cookie}();
		#~ echo($fdat{PerletID}); exit;
		$fdat{PerletName} =~ s/'//g;
		$fdat{perletscript} = $globalp->{FixScriptSlashesAndQuotes}($fdat{perletscript});
		
		if ( $fdat{PerletID} eq "" or $fdat{PerletID} eq "0")
		{
			#~ echo("Guardando"); exit;
			$insert_script_data = "INSERT INTO ".$globalp->{table_prefix}."_mf_perlets VALUES ( ";
			$insert_script_data .= "NULL,'$the_cvalues[1]','$fdat{PerletName}','$fdat{perletscript}'";
			$insert_script_data .= ")";
			#~ echo($insert_script_data); exit;
			$globalp->{dbh}->do( $insert_script_data );
			
			$sthresult = $globalp->{dbh} -> prepare ("SELECT PerletID, PerletName FROM ".$globalp->{table_prefix}."_mf_perlets WHERE PerletName = \"$fdat{PerletName}\"" )  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_mf_perlets";
			$sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_mf_perlets ";
			$sthresult -> bind_columns(undef, \$PerletID, \$PerletName);
			$datresult = $sthresult -> fetchrow_arrayref ;
			#~ $sthresult -> finish();
			
			$fdat{PerletID} = $PerletID;
		}
		else
		{
			$sqlqueriestable = "UPDATE ".$globalp->{table_prefix}."_mf_perlets SET";
			$sqlqueriestable .= " PerletName = '$fdat{PerletName}',";
			$sqlqueriestable .= " PerletScript='$fdat{perletscript}' WHERE PerletID=$fdat{PerletID}";
			#~ echo($update_script_data); exit;
			$globalp->{dbh}->do( $sqlqueriestable );
		}
	}
	
	
	
	
	
	

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


# echo("$ENV{THE_CALLED_DOCUMENT_PATH}"); exit;
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/language/lang-'.$globalp->{site_language}.'.prc');
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/config_EplSiteETL.prc');
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/EplSiteETL_subs.prc');
	
	
	if( $ENV{BATCH_PROCESS} == 0 )
	{
		@the_cvalues = &wflogin_in() if( $fdat{option} eq "login" );

		#echo("Cookie es: $the_cvalues[0],$the_cvalues[1],$the_cvalues[2],$the_cvalues[3]"); $globalp->{clean_exit}();
		@the_cvalues = $globalp->{get_the_cookie}() if( !(@the_cvalues) );
		#echo("Cookie es: $the_cvalues[0],$the_cvalues[1],$the_cvalues[2],$the_cvalues[3]\n"); $globalp->{clean_exit}();
		if( ( ($the_cvalues[0] eq "0" ) && ( $the_cvalues[1] eq "1" ) && ( $the_cvalues[2] eq "2" ) )
			|| ( ($the_cvalues[0] eq "" ) && ( $the_cvalues[1] eq "" ) && ( $the_cvalues[2] eq "" ) )) 
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
	}



  if( $disp_login != 1) 
	{
			#echo("2Cookie es: $the_cvalues[0],$the_cvalues[1],$the_cvalues[2]; and the option is:$fdat{option}"; $globalp->{clean_exit}();
			#&wfauth if( $fdat{option} ne "" && $fdat{option} ne "login" );
			if( $ENV{BATCH_PROCESS} == 0 )
			{			
				@the_cvalues = &wfauth;
			}
			
			if( ( ($the_cvalues[0] eq "0" ) && ( $the_cvalues[1] eq "1" ) && ( $the_cvalues[2] eq "2" ) )
			|| ( ($the_cvalues[0] eq "" ) && ( $the_cvalues[1] eq "" ) && ( $the_cvalues[2] eq "" ) )
			&& $ENV{BATCH_PROCESS} == 0 ) 
			{
				$a = 1;
			} 
			else 
			{
				#echo("3Cookie es: $the_cvalues[0],$the_cvalues[1],$the_cvalues[2]; and the option is:$fdat{option}"; $globalp->{clean_exit}();
				if( $fdat{chgpasswd} eq "chgpassform" ) { &Change_wf_Password_Form; }
				elsif( $fdat{chgpasswd} eq "chgpass" ) { &Change_wf_Password; }
			
				if(  ( $fdat{option} eq "setupxportlayouts" ) ) {
					Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/setupxportlayouts.prc');
				}			
			
				if(  ( $fdat{option} eq "DisplaySchemeMenu" ) and $fdat{ETLSchemeID} ne "" ) {
                    #~ echo("desplegar menu"); exit;
					Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/EplSiteETLSchemes.prc');
				}		
				
				if( !defined($fdat{option}) ) 
				{ 
					$globalp->{siteheader}();
					echo("<script type=\"text/javascript\" src=\"includes/PostAjaxLibrary.js\"></script>\n"
							."<script type=\"text/javascript\" src=\"modules/EplSiteETL/EplSiteETL.js\"></script>\n");		
							
					$globalp->{theheader}();
					
					&EplSiteETLMainMenu ;

					echo("<br>");
					$globalp->{OpenTable}();
					echo("<fieldset><div id=\"ETLSchemeMenu\"></div></fieldset>");
					$globalp->{CloseTable}();
		
					@the_cvalues = $globalp->{get_the_cookie}() if( !(@the_cvalues) );
					$globalp->{loggedon_as}();
					$globalp->{sitefooter}();		
				}
				elsif(  ( $fdat{option} eq "GetRunNumber" ) ) {
					Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/GetRunNumber.prc');
				}
				elsif(  ( $fdat{option} eq "ShowRunNumberLog" ) ) {
					Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/ShowRunNumberLog.prc');
				}
				elsif(  ( $fdat{option} eq "ShowXRefErrorLog" ) ) {
					Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/ShowXRefErrorLog.prc');
				}
				elsif(  ( $fdat{option} eq "ShowCatalogsErrorLog" ) ) {
					Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/ShowCatalogsErrorLog.prc');
				}				
				elsif(  ( $fdat{option} eq "generalpurposetable" ) ) {
					Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/generalpurposetable.prc');
				}
				elsif(  ( $fdat{option} eq "xrefs" ) ) {
					Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/xrefs.prc');
				}
				elsif(  ( $fdat{option} eq "execquery" ) ) {
					Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/ExecQuery.prc');
				}	
				elsif(  ( $fdat{option} eq "perlets" ) ) {
					Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/EplSiteETL/EplSitePerlets.prc');
				}					
				elsif( $fdat{option} eq "extractdata")
				{

          # print "Starting ETL Execution...\n"; exit; # Debug message when running batch process
					$error = "";
					
					if( ( not defined($fdat{ScriptID}) or $fdat{ScriptID} eq "" ) && ( not defined($fdat{TransformationCode}) or $fdat{TransformationCode} eq "" ) )
					{
						$error .= "Independent Script Or Layout Setup Not Selected.<br>";
					}

					if( $fdat{ScriptID} ne "" && $fdat{TransformationCode} ne "" )
					{
						$error .= "Select Only Independent Script Or Layout To Execute.<br>";
					}

					if( not defined($fdat{ETLSchemeID}) or $fdat{ETLSchemeID} eq "" )
					{
						$error .= "ETL Scheme Not Defined.<br>";
					}
					else
					{
            $SelectQuery = "SELECT ScriptForAdditionalValidation";
            $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_schemes";
            $SelectQuery .= " WHERE ETLSchemeID = ".$fdat{ETLSchemeID};
						$sthresult = $globalp->{dbh} -> prepare ($SelectQuery)
                        or die "Cannot prepare query:$SelectQuery";
						$sthresult -> execute or die "Cannot execute query:$SelectQuery";
						$sthresult -> bind_columns(undef, \$ScriptForAdditionalValidation );
						$datresult = $sthresult -> fetchrow_arrayref ();
						$sthresult -> finish();
						
						$ScriptForAdditionalValidation  =~ s/^\s+//; #remove leading spaces
						$ScriptForAdditionalValidation  =~ s/\s+$//; #remove trailing spaces				
						if( $ScriptForAdditionalValidation ne "" )
						{
							eval $ScriptForAdditionalValidation;
							if($@)
							{
								echo($@);
								$globalp->{clean_exit}();
							}
						}						
					}
					
                    
					if( $error ne "" )
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

					if( $fdat{ScriptID} ne "" )
					{
            $SelectQuery = "SELECT ScriptName, ETLSchemeCode, ScriptDescription, PerlScriptLet";
            $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_independent_scripts";
            $SelectQuery .= " WHERE ScriptID =". $fdat{ScriptID};
                        
						$sthresult = $globalp->{dbh} -> prepare ($SelectQuery)
                        or die "Cannot preare query:$SelectQuery";
						$sthresult -> execute or die "Cannot execute query:$SelectQuery";
						$sthresult -> bind_columns(undef, \$ScriptName, \$ETLSchemeCode, \$ScriptDescription, \$PerlScriptLet);
						$datresult = $sthresult -> fetchrow_arrayref ();
						$sthresult -> finish();	
						 
						$PerlScriptLetTemp = $PerlScriptLet;
						$PerlScriptLetTemp =~ s/^\s+//; #remove leading spaces
						$PerlScriptLetTemp =~ s/\s+$//; #remove trailing spaces
						
						$ETLSchemeCode =~ s/^\s+//; #remove leading spaces
						$ETLSchemeCode =~ s/\s+$//; #remove trailing spaces
						
						if( $PerlScriptLetTemp eq "" )
						{
							$error = "Perl Scriptlet:<b>".$ScriptName."</b> Has No Perl Code To Execute.<br><br>"
						}
						else
						{
							$PerlScriptLetError = $globalp->{EplSitePerlCheckSyntax}($PerlScriptLet,"PerlScriptLet");
							if( $PerlScriptLetError ne "")
							{
								$error = "<b>Perl Scriptlet<font color=\"red\"><i> $ScriptName </i></font>Has Errors:</b><br> " . $PerlScriptLetError ."<br>";
								$error .= "Go to <a href=\"admin.prc?option=EplSiteETLManager\">EplSite ETL control panel</a> to edit and fix this error.";
							}
						}
						
						if( $error eq "" )
						{
							#No error so far, execute script
							eval $PerlScriptLet;
							
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

							echo($error."<br><br>".$globalp->{_GOBACK}."<br>");

							$globalp->{CloseTable}();
							$globalp->{loggedon_as}();
							$globalp->{sitefooter}();
							$globalp->{clean_exit}();							
						}
					}
					elsif( $fdat{TransformationCode} ne "" )
					{
            # Debug message when running batch process
            #print "\nStarting Layout Transformation Execution...Transformation Code:$fdat{TransformationCode}\n"; exit;

						$globalp->{WriteTransformationQueryInExecutionToLog} = 0;
						
                        $error = "";
                        if( not defined($fdat{DBConnSourceID}) or $fdat{DBConnSourceID} eq "" )
                        {
                            $error .= "Source DataBase Connection Not Defined, It Is Needed For Layout Processing.<br>";
                        }

                        if( not defined($fdat{DBConnTargetID}) or $fdat{DBConnTargetID} eq "" )
                        {
                            $error .= "Target DataBase Connection Not Defined, It Is Needed For Layout Processing.<br>";
                        }

                        if( $error eq "" )
                        {
                            $SelectQuery = "SELECT ETLScriptName, Description";
                            $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_transformation_definitions";
                            $SelectQuery .= " WHERE TransformationCode = '".$fdat{TransformationCode}."'";
                            
                            $sthresult = $globalp->{dbh} -> prepare ($SelectQuery)
                            or die "Cannot prepare query:$SelectQuery";
                            $sthresult -> execute  or die "Cannot execute query:$SelectQuery";
                            $sthresult -> bind_columns(undef, \$ETLScriptName, \$Description);
                            $datresult = $sthresult -> fetchrow_arrayref ();
                            $sthresult -> finish();	
                             
                            $ETLScriptName =~ s/^\s+//; #remove leading spaces
                            $ETLScriptName =~ s/\s+$//; #remove trailing spaces
                                                
                            my $ExtractScriptFile = $ENV{THE_CALLED_DOCUMENT_PATH};
                            $ExtractScriptFile .= 'modules/EplSiteETL/' . $ETLScriptName;

                            if( open(REPORTSCRIPT, $ExtractScriptFile) )
                            {
                                close(REPORTSCRIPT);
                                #~ &Connect_To_Oracle();
                                # Executing Script to Extract Data According To Layout(Transformation Code Selected or provided in the batch process)
                                Execute ($ExtractScriptFile);

                                # EXIT PROCESS AFTER TRANSFORMATION SCRIPT EXECUTION WHEN USING DBConnTarget, not file target
                                $globalp->{siteheader}();
                                echo('</head><body bgcolor="'.$globalp->{bodybgcolor}.'">');
                                echo("<b>Transformation Done.</b><br><br>");
                                $globalp->{OpenTable}();
                                echo("Transformation Done. Check your target database.<br>");
                                $globalp->{CloseTable}();
                                $globalp->{OpenTable}();
                                echo("<a href=\"#\" onclick=\"window.open('index.prc?module=EplSiteETL&amp;option=ShowRunNumberLog"
                                    ."&amp;runnumber=".$fdat{runnumber}."','Log File For Run Number','width=650,height=450, scrollbars=yes, fullscreen=-1');return;\">"
                                    ."See Log For Transformation Run Number:".$fdat{runnumber}."</a>");
                                $globalp->{CloseTable}();                                
                                echo("<br> $globalp->{_GOBACK} <br>");
                                $globalp->{sitefooter}();
                                $globalp->{cleanup}();
                                #$globalp->{clean_exit}();                                
                            }
                            else
                            {
                                $error .= "Extract Script $ExtractScriptFile To Execute";
                                $error .= " Layout $fdat{TransformationCode} - ";
                                $error .= $Description." Can not Be Open.<br>";
                            }
                        }
                        
                        if( $error ne "" )
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
					else
					{
						echo("Nothing to execute.");
					}
				}
				elsif( $fdat{option} eq "logout" ){ &wflogout; }
				else 
				{ 
					$globalp->{siteheader}();
					echo("<script type=\"text/javascript\" src=\"includes/PostAjaxLibrary.js\"></script>\n"
							."<script type=\"text/javascript\" src=\"modules/EplSiteETL/EplSiteETL.js\"></script>\n");		
					$globalp->{theheader}();
					
					&EplSiteETLMainMenu ;

					echo("<br>");
					$globalp->{OpenTable}();
					echo("<fieldset><div id=\"ETLSchemeMenu\"></div></fieldset>");
					$globalp->{CloseTable}();
		
					@the_cvalues = $globalp->{get_the_cookie}() if( !(@the_cvalues) );
					$globalp->{loggedon_as}();
					$globalp->{sitefooter}();							
				}
			}
	}

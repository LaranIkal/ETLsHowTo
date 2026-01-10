########################################################################
# General Data Table Management for EplSiteETL
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

    if( $globalp->{loaded_from_index} != 1 )
    {
        echo("Access denied!!!!");
        if( defined($ENV{MOD_PERL}) )
        {
            Apache::exit;
        }else{  exit(); }
    }

	our ( $thedocument, $GenDataConn );
	
    
    
	sub general_data_delete
	{
		if( $fdat{k} eq "1" )
		{
			$delete_xref_data = "DELETE FROM GENERAL_DATA WHERE kindofdata = '".$fdat{kindofdatatodelete}."'";
			$GenDataConn->do( $delete_xref_data );

			if( $fdat{deletedefinitely} eq "Yes")
			{
				$a= 1;
			}
			else
			{
				## Keeping a record

				my $GeneralPurposeTableData = [];		

				for $data (0 .. 50)
				{
					$GeneralPurposeTableData[$data] = "";
				}
				$GeneralPurposeTableData[0] = "$fdat{kindofdatatodelete}";
				$GeneralPurposeTableData[1] = "Just To keep Record";
		
				#~ $InsertFields = "";
				#~ foreach $TableField ( @GeneralPurposeTableData )
				#~ {
					 #~ $TableField =~ s/'/''/g;								 
					 #~ $InsertFields .= "'" . $TableField . "',";
				#~ }
						 
				$InsertFields = substr($InsertFields,0,length($InsertFields)-1);
				
				$insertquery = "INSERT INTO GENERAL_DATA";
				$insertquery .= " (kindofdata,DataField1)";
				$insertquery .= " values ( '" . $GeneralPurposeTableData[0] . "'";
				$insertquery .= ",'" . $GeneralPurposeTableData[1] . "'";
				$insertquery .= ")";

				#~ echo($insertquery."<br>");

				$GenDataConn->do($insertquery) or die "Can Not execute INSERT: $insertquery";			
			}
			delete $fdat{xreftodelete};
            $globalp->{CloseDBConnection}($GenDataConn);
            $globalp->{cleanup}();
			&redirect_url_to("index.prc?module=EplSiteETL&amp;option=generalpurposetable&amp;DataSourceID=$fdat{DataSourceID}");
		}
		else
		{
			$globalp->{siteheader}();
			$globalp->{theheader}();

			@the_cvalues = $globalp->{get_the_cookie}();		
		
			echo("Do you want to delete kind of data <b>$fdat{kindofdatatodelete}</b> from general purpose table?"
					."<a href=\"index.prc?\module=EplSiteETL&amp;option=generalpurposetable&amp;k=1&amp;"
					."kindofdatatodelete=$fdat{kindofdatatodelete}&amp;generalpurposetableoption=Delete"
					."&amp;deletedefinitely=$fdat{deletedefinitely}&amp;DataSourceID=$fdat{DataSourceID}\""
					.">Yes</a>"
					."&nbsp;&nbsp;$globalp->{_GOBACK}");			

			$globalp->{CloseTable}();
			$globalp->{loggedon_as}();
			$globalp->{sitefooter}();
            $globalp->{CloseDBConnection}($GenDataConn);
			$globalp->{clean_exit}();
		}
	}


	#~ sub xref_display
	#~ {
		#~ @the_cvalues = $globalp->{get_the_cookie}();	
		#~ $globalp->{siteheader}();
		#~ $globalp->{theheader}();

		#~ echo("<br>");
		#~ $globalp->{OpenTable}();
		
		#~ echo("<table border =\"1\">"
				#~ ."<tr><td>Sequence</td>"
				#~ ."<td><b>XRef Type</b></td><td><b>From Value</b></td><td><b>From Value1</b></td>"
				#~ ."<td><b>To Value</b></td>"
				#~ ."</tr>");
				
		#~ $MyQuery = "SELECT from_value, from_value1, to_value";
		#~ $MyQuery .= " FROM ".$globalp->{table_prefix}."_mf_xreftable";
		#~ $MyQuery .= " WHERE xreftype = '$fdat{xreftodelete}'";
		#~ $MyQuery .= " ORDER BY from_value, from_value1 limit 1000";	

		#~ $QueryResult = $GenDataConn->prepare ($MyQuery)  or die "Cannot get inventory from ".$globalp->{table_prefix}."_mf_xreftable table";
		#~ $QueryResult -> execute  or die "Cannot get inventory from ".$globalp->{table_prefix}."_mf_xreftable table";
		#~ $QueryResult ->{RaiseError} = 1;

		#~ $QueryRows = [];
		#~ $datafound = 0;
		#~ $XRefSequence = 0;
		#~ while( $QueryRow = (shift(@$BaaNInventoryRows) || shift(@{$QueryRows=$QueryResult->fetchall_arrayref(undef,1)||[]})))
		#~ {
			#~ $TheQueryRow = join("\~", @{$QueryRow});
			#~ @TheQueryArray = split("\~", $TheQueryRow);
			
			#~ $XRefSequence +=1;
			#~ echo("<tr><td>$XRefSequence</td>"
				#~ ."<td>$fdat{xreftodelete}</td><td>$TheQueryArray[0]</td><td>$TheQueryArray[1]</td>"
				#~ ."<td>$TheQueryArray[2]</td>"
				#~ ."</tr>");
			
			#~ $datafound = 1;
		#~ }
		#~ $QueryResult ->finish();

		#~ echo("</table>");
		
		#~ if( $datafound == 0 )
		#~ {
			#~ echo("No data found, load he file before running export.");
		#~ }

		#~ $globalp->{CloseTable}();
		#~ $globalp->{loggedon_as}();
		#~ $globalp->{sitefooter}();
		#~ $globalp->{clean_exit}();
		#~ delete $fdat{option};
		#~ exit;
	#~ }




	sub data_import_file
	{
		my $thedocument = "";
		my $LineFeed = chr(10);
		my $CarriageReturn = chr(13);
        
		if( $fdat{takekindofdatafromfile} eq "Yes" )
		{
            $thedocument = $globalp->{get_file_uploaded}($globalp->{Temp_Docs_Path});
            		
			open ("datafile", $thedocument);
					my @filedata=<datafile>;
			close ("datafile");

			my $linecounter = 0;
			foreach my $DataLine (@filedata)
			{		
                $DataLine =~ s/$LineFeed//g;
                $DataLine =~ s/$CarriageReturn//g; 
				
				$linecounter +=1;
				
				if( $fdat{delimiterchar} eq "" ||  $fdat{delimiterchar} eq "\|")
				{
					@mydata = split('\|',$DataLine);			
				}
				else
				{
					@mydata = split($fdat{delimiterchar},$DataLine);
				}			
				
				$mydata[0] =~ s/^\s+//; #remove leading spaces
				$mydata[0] =~ s/\s+$//; #remove trailing spaces
				
				if( $linecounter == 10 )
				{
					$dataline10 = $mydata[0];
				}
				
				if( $linecounter == 17 )
				{
					$dataline17 = $mydata[0];				
				}
				
				if( $linecounter == 19 )
				{
					$dataline19 = $mydata[0];				
				}
				
				last if $linecounter eq "19";
			}
			
			if( $dataline10 eq $dataline17 &&  $dataline10 eq $dataline19 )
			{
                my $ImportStartTime = time;
				&import_data_file($thedocument);
                my $ImportTime = time - $ImportStartTime;
                $globalp->{CloseDBConnection}($GenDataConn);
                $globalp->{cleanup}();
                
				&redirect_url_to("index.prc?module=EplSiteETL&amp;option=generalpurposetable&amp;DataSourceID=$fdat{DataSourceID}&amp;ImportTime=$ImportTime");
			}
			else
			{
                $globalp->{CloseDBConnection}($GenDataConn);
				$globalp->{General_EplSite_Error_Display}("Data File Wrong, the first column is the identifier for the kind of data and must have the same value in all records.");	
			}
		} ##if( $fdat{takekindofdatafromfile} eq "Yes" )
		else
		{
			$fdat{kindofdata} =~ s/^\s+//; #remove leading spaces
			$fdat{kindofdata} =~ s/\s+$//; #remove trailing spaces
			$fdat{kindofdata} =~ s/'//g;
			$fdat{kindofdata} =~ s/"//g;

			$fdat{kindofdata} = $globalp->{Clean_Non_Printable_Chars}($fdat{kindofdata});

			if( $fdat{kindofdata} eq "" )
			{
				$globalp->{General_EplSite_Error_Display}("Kind Of Data Field Value Incorrect.");			
			}
			else
			{                
                my $ImportStartTime = time;
                &import_data_file($globalp->{get_file_uploaded}($globalp->{Temp_Docs_Path}));
                my $ImportTime = time - $ImportStartTime;
                $globalp->{CloseDBConnection}($GenDataConn);
                $globalp->{cleanup}();                        
                &redirect_url_to("index.prc?module=EplSiteETL&amp;option=generalpurposetable&amp;DataSourceID=$fdat{DataSourceID}&amp;ImportTime=$ImportTime");
			} ## End if( $fdat{kindofdata} eq "" )			
		} ## End if( $fdat{takekindofdatafromfile} eq "Yes" )
	}
	
	
	
	
	sub import_data_file
	{
		my $TheDataFile = shift;
		my $GeneralPurposeTableData = [];
		my $LineFeed = chr(10);
		my $CarriageReturn = chr(13);
		my $DataLine = "";        
        
		for $data (0 .. 100)
		{
			$GeneralPurposeTableData[$data] = "";
		}
		
		open ("datafile", $TheDataFile );
				my @filedata=<datafile>;
		close ("datafile");	
		
		$file_deleted = $globalp->{DeleteMyFile}($TheDataFile);
		
		$LineNumber = 0;
		$PreviousDataDeleted = "No";
		
		$GenDataConn->{AutoCommit} = 0;
		my $sth = $GenDataConn->prepare(q{
		  INSERT INTO GENERAL_DATA VALUES (?,
		  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
		  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
		  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
		  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
		  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
		  )
		}) or die $GenDataConn->errstr;
		
		my $RecordCounter = 0;
		foreach $DataLine (@filedata)
		{	
			$LineNumber += 1;
			$DataLine =~ s/$LineFeed//g;
			$DataLine =~ s/$CarriageReturn//g;  			
			#~ chop;
			#~ $_ =~ s/'/''/g;
			$DataLine =~ s/\\/\\\\/g;
			
			if( $fdat{delimiterchar} eq "" ||  $fdat{delimiterchar} eq "\|")
			{
				@mydata = split('\|',$DataLine);			
			}
			else
			{
				@mydata = split($fdat{delimiterchar},$DataLine);
			}
			
			if( $fdat{takekindofdatafromfile} eq "Yes" )
			{			
				$mydata[0] =~ s/^\s+//; #remove leading spaces
				$mydata[0] =~ s/\s+$//; #remove trailing spaces
			}
			$mylinedatasize = $#mydata;			
			
			if( $LineNumber >$fdat{headerlines} )
			{
				if( $PreviousDataDeleted eq "No" )
				{
					#Delete all records taking the first column of the second record as reference.
					$delete_xref_data = "DELETE FROM GENERAL_DATA";
					if( $fdat{takekindofdatafromfile} eq "Yes" )
					{
						$delete_xref_data .= " WHERE kindofdata = '$mydata[0]'";
					}
					else
					{
						$delete_xref_data .= " WHERE kindofdata = '$fdat{kindofdata}'";
					}
					$GenDataConn->do( $delete_xref_data );
					$rc = $GenDataConn->commit() or die $GenDataConn->errstr;
					$PreviousDataDeleted = "Yes";
				}
				
				for $data (0 .. 100)
				{
					$GeneralPurposeTableData[$data] = "";
				}
				
				if( $#mydata > 0 )
				{
					if( $fdat{takekindofdatafromfile} eq "Yes" )
					{
						for $data (0 .. $#mydata)
						{
							$mydata[$data] =~ s/\s+$//; #remove trailing spaces
							$GeneralPurposeTableData[$data] = $mydata[$data];
						}
					}
					else
					{
						$GeneralPurposeTableData[0] = $fdat{kindofdata};
						
						for $data (0 .. $#mydata)
						{
                            $mydata[$data] =~ s/\s+$//; #remove trailing spaces
							$GeneralPurposeTableData[$data + 1] = $mydata[$data];
						}						
					}
					
					$sth->execute(@GeneralPurposeTableData) or die $GenDataConn->errstr;
					$RecordCounter +=1;
					if( $RecordCounter > 100 )
					{
						$rc = $GenDataConn->commit() or die $GenDataConn->errstr;
						$RecordCounter = 0;
					}
				}
			} ## If to start Loading data to table.
		} ## End foreach (@filedata)
        undef @GeneralPurposeTableData;
        undef @filedata;
        undef @mydata;
        $sth->finish();
		$rc = $GenDataConn->commit() or die $GenDataConn->errstr;
		$GenDataConn->{AutoCommit} = 1;
		
	}





	sub data_import_main_menu
	{
		@the_cvalues = $globalp->{get_the_cookie}();
		
        $globalp->{siteheader}();
        $globalp->{theheader}();        
        echo("<p><big><big><b>General Purpose Data Table</b></big></big></p>");
        
        if( $fdat{DataSourceID} eq "" )
        {            
            echo("<br><form name=\"general_data\" action=\"index.prc\" method=\"post\">\n"
                ."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
                ."<input type=\"hidden\" name=\"option\" value=\"generalpurposetable\">\n"
                ."Data Base Connection For Data Import:<select id=\"DataSourceID\" name=\"DataSourceID\">");
                        
            if( $fdat{DataSourceID} eq "" )
            {
                echo("<option selected value=\"\">Select DB Connection</option>\n");
            }
            else
            {
                echo("<option value=\"\">Select DB Connection</option>\n");
            }
                    
            $selectquery = "SELECT DataSourceID, DataSourceName";
            $selectquery .= " FROM ".$globalp->{table_prefix}."_etl_data_sources";
            $selectquery .= "	WHERE 1";
            $selectquery .= " ORDER BY DataSourceName";
            
            $resulti = $globalp->{dbh} -> prepare($selectquery)  or die echo("Cannot Execute Query $selectquery");
            $resulti -> execute  or die echo("Cannot Execute Query $selectquery");
            $resulti -> bind_columns(undef, \$DataSourceID, \$DataSourceName);

            while( $datresulti = $resulti -> fetchrow_arrayref )
            {
                $sel= " ";
                if( $fdat{DataSourceID} eq $DataSourceID ) { $sel= " selected "; }
                
                echo("<option" . $sel ."value=\"$DataSourceID\">$DataSourceID - $DataSourceName</option>\n");
            }
            #~ $resulti->finish();
            echo("</select>"            
                ."<input type=\"submit\" name=\"setdbconn\" value=\"Set DB Connection\"></form>\n");
                
        }
        else
        {
            #~ echo($fdat{DataSourceID}); exit;
            if( not defined($GenDataConn) )
            {
                $GenDataConn = $globalp->{connect_data_source}($fdat{DataSourceID},"Submit");
            }

            $selectquery = "SELECT DataSourceName";
            $selectquery .= " FROM ".$globalp->{table_prefix}."_etl_data_sources";
            $selectquery .= "	WHERE DataSourceID =".$fdat{DataSourceID};
            $selectquery .= " ORDER BY DataSourceName";
            
            $resulti = $globalp->{dbh} -> prepare($selectquery)
            or die echo("Cannot Execute Query $selectquery");
            $resulti -> execute or die echo("Cannot Execute Query $selectquery");
            $resulti -> bind_columns(undef, \$DataSourceName);
            $datresulti = $resulti -> fetchrow_arrayref();
            $resulti->finish();
            
            echo("<br><form name=\"general_data\" action=\"index.prc\" method=\"post\" ENCTYPE=\"multipart/form-data\">\n"
                ."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
                ."<input type=\"hidden\" name=\"option\" value=\"generalpurposetable\">\n"
                ."<input type=\"hidden\" name=\"DataSourceID\" value=\"$fdat{DataSourceID}\">\n"
                ."<fieldset><legend>Data Import Using Data Base Connection:"
                ."<b>" . $fdat{DataSourceID} . " - " . $DataSourceName . "</b>"
                ." <strong><big>&middot;</big></strong>\n"
				."<a href=\"index.prc?module=EplSiteETL&option=generalpurposetable\">\n"
				."Change.</a></legend>"
                ."<p>Kind Of Data To Load:&nbsp;<input type=\"text\" name=\"kindofdata\" size=\"50\" maxlength=\"100\">&nbsp;&nbsp; or \n"
                ."<input type=\"checkbox\" name=\"takekindofdatafromfile\" value=\"Yes\">Take Kind Of Data From File.</p>\n"			
                ."<p>".$globalp->{_MFDELIMITERCHAR}."&nbsp;<input type=\"text\" name=\"delimiterchar\" size=\"1\" maxlength=\"1\"> &nbsp;\n"	
                ."Number Of Header Lines In File:&nbsp;<input type=\"text\" name=\"headerlines\" size=\"1\" maxlength=\"1\"></p>\n"			
                ."Input File Name:<INPUT TYPE=\"FILE\" NAME=\"attachthis\" value=\"\" size=\"100\"> &nbsp;<br><br>\n"
                ."<input type=\"submit\" name=\"fileimport\" value=\"Import Data\">");
                echo("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Last Import Time: $fdat{ImportTime} Seconds.") if( defined($fdat{ImportTime}) );
                echo("</form> </fieldset> \n");
            
            $sthresult = $GenDataConn -> prepare ("SELECT DISTINCT kindofdata FROM GENERAL_DATA")
            or die "Cannot SELECT from GENERAL_DATA $DBI::errstr";
            $sthresult -> execute  or die "Cannot execute SELECT from GENERAL_DATA $DBI::errstr";
            $sthresult -> bind_columns(undef, \$KindOfData);
            
            echo("<p><form action=\"index.prc\" method=\"post\">\n"
                ."<fieldset><legend>Data Operations Using Data Base Connection:"
                ."<b>" . $fdat{DataSourceID} . " - " . $DataSourceName . "</b>"
                ." <strong><big>&middot;</big></strong>\n"
                ."<a href=\"index.prc?module=EplSiteETL&option=generalpurposetable\">\n"
                ."Change.</a></legend>"
                ."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
                ."<input type=\"hidden\" name=\"option\" value=\"generalpurposetable\">\n"
                ."<input type=\"hidden\" name=\"DataSourceID\" value=\"$fdat{DataSourceID}\">\n"
                ."<strong><big>&middot;</big></strong> Select Kind Of Data:\n"
                ." <select name=\"kindofdatatodelete\"><option value=\"\">-----------</option>\n");

            while( $datresult = $sthresult -> fetchrow_arrayref ) {
                echo("<option value=\"$KindOfData\">$KindOfData</option>\n");
            }
            $sthresult -> finish();

            echo("</select><br>\n"
                #~ ."<input name=\"generalpurposetableoption\" type=\"submit\" VALUE=\"Display\"><br>"
                ."<br><input name=\"generalpurposetableoption\" type=\"submit\" VALUE=\"Delete\">"
                ."<input type=\"checkbox\" name=\"deletedefinitely\" value=\"Yes\">Not insert keeping record when deleting.\n"				
                ."</form></fieldset></p>\n");
            $globalp->{CloseDBConnection}($GenDataConn);
        }
		$globalp->{CloseTable}();
		$globalp->{loggedon_as}();        
		$globalp->{sitefooter}();
	}







    if( $fdat{fileimport} eq  "Import Data" )
	{ 		
		$fdat{headerlines} =~ s/^\s+//; #remove leading spaces
		$fdat{headerlines} =~ s/\s+$//; #remove trailing spaces
		
		if( defined($fdat{headerlines}) and $fdat{headerlines} >= 0 and $fdat{headerlines} ne "" )
		{
            $GenDataConn = $globalp->{connect_data_source}($fdat{DataSourceID},"Submit");
			&data_import_file;
		}
		else
		{
			$globalp->{General_EplSite_Error_Display}("Enter Number Of Header Lines In File( 0 - 9 ).<br>");				
		}
	}
    elsif( $fdat{generalpurposetableoption} eq "Delete" && $fdat{kindofdatatodelete} ne "" )
    { 
        $GenDataConn = $globalp->{connect_data_source}($fdat{DataSourceID},"Submit");
        &general_data_delete;         
    }
	#~ elsif( $fdat{xrefoption} eq "Display"  && $fdat{xreftodelete} ne "" ){ &xref_display; }
	else { &data_import_main_menu; }




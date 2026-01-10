########################################################################
# EplsiteETL,Xref Files Subroutines
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

	our ( $thedocument  );
    
    
    

	sub xref_delete
	{
		if( $fdat{k} eq "1" )
		{
			$delete_xref_data = "DELETE FROM ".$globalp->{table_prefix};
			$delete_xref_data .= "_etl_xreftable WHERE xreftype = '".$fdat{xreftodelete}."'";
			$globalp->{dbh}->do( $delete_xref_data );

			if( $fdat{deletedefinitely} eq "Yes")
			{
				$a= 1;
			}
			else
			{
				## Keeping a record			
				$insert_xref_data = "INSERT INTO ".$globalp->{table_prefix}."_etl_xreftable VALUES (";
				$insert_xref_data .= "'".$fdat{xreftodelete}."','Just To keep Record.','From1','To')";
				$globalp->{dbh}->do( $insert_xref_data );
			}
			delete $fdat{xreftodelete};
            $globalp->{cleanup}();
			&redirect_url_to("index.prc?module=EplSiteETL&amp;option=xrefs");
		}
		else
		{
			$globalp->{siteheader}();
			$globalp->{theheader}();

			@the_cvalues = $globalp->{get_the_cookie}();		
		
			echo("$globalp->{_MFDELXREF} <b>$fdat{xreftodelete}?</b>"
					."<a href=\"index.prc?\module=EplSiteETL&amp;option=xrefs&amp;k=1&amp;"
					."xreftodelete=$fdat{xreftodelete}&amp;xrefoption=$globalp->{_DELETE}"
					."&amp;deletedefinitely=$fdat{deletedefinitely}\""
					.">Yes</a>"
					."&nbsp;&nbsp;$globalp->{_GOBACK}");

			$globalp->{CloseTable}();
			$globalp->{loggedon_as}();
			$globalp->{sitefooter}();
			$globalp->{clean_exit}();
		}
	}




	sub xref_display
	{
		@the_cvalues = $globalp->{get_the_cookie}();	
		$globalp->{siteheader}();
		$globalp->{theheader}();

		echo("<br>");
		$globalp->{OpenTable}();
		
				
        $NumberOfRecordsFound = 0;                
		$MyQuery = "SELECT count(*)";
		$MyQuery .= " FROM ".$globalp->{table_prefix}."_etl_xreftable";
		$MyQuery .= " WHERE xreftype = '".$fdat{xreftodelete}."'";
        $xrQueryResult = $globalp->{dbh}->prepare($MyQuery)
        or die "Cannot prepare query:$MyQuery";
        $xrQueryResult -> execute or die "Cannot execute query:$MyQuery";
		$xrQueryResult -> bind_columns(undef, \$NumberOfRecordsFound);
        $datresult = $xrQueryResult -> fetchrow_arrayref();
        $xrQueryResult ->finish();


        if( $NumberOfRecordsFound > 0 )
        {
            echo("<table border =\"1\">"
                    ."<tr><td>Sequence</td>"
                    ."<td><b>XRef Type</b></td><td><b>From Value</b></td><td><b>From Value1</b></td>"
                    ."<td><b>To Value</b></td>"
                    ."</tr>");

            $MyQuery = "SELECT from_value, from_value1, to_value";
            $MyQuery .= " FROM ".$globalp->{table_prefix}."_etl_xreftable";
            $MyQuery .= " WHERE xreftype = '".$fdat{xreftodelete}."'";
            $MyQuery .= " ORDER BY from_value, from_value1";	

            $xrQueryResult = $globalp->{dbh}->prepare($MyQuery)
            or die "Cannot prepare query:$MyQuery";
            $xrQueryResult -> execute or die "Cannot execute query:$MyQuery";

            $QueryRows = [];

            $XRefSequence = 0;
            echo($globalp->{_GOBACK}."<H1> ".$NumberOfRecordsFound." Records in "
            ."\"$fdat{xreftodelete}\" XRef");
            
            echo(", Displaying 1000") if( $NumberOfRecordsFound > 1000 );
            echo(".</H1><br><br>");
            
            while( $QueryRow = (shift(@$BaaNInventoryRows) || shift(@{$QueryRows=$xrQueryResult->fetchall_arrayref(undef,1)||[]})))
            {
                $TheQueryRow = join("\~", @{$QueryRow});
                @TheQueryArray = split("\~", $TheQueryRow);
                
                $XRefSequence +=1;
                echo("<tr><td>$XRefSequence</td>"
                    ."<td>$fdat{xreftodelete}</td><td>$TheQueryArray[0]</td><td>$TheQueryArray[1]</td>"
                    ."<td>$TheQueryArray[2]</td>"
                    ."</tr>");			
            }
            $xrQueryResult ->finish();

            echo("</table>");
        }
        else
        {
			echo("No data found.");
		}

		$globalp->{CloseTable}();
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
		$globalp->{clean_exit}();
	}




	sub xref_import_file
	{
		my $thedocument = "";
		
		my $LineFeed = chr(10);
		my $CarriageReturn = chr(13);
        
    $thedocument = $globalp->{get_file_uploaded}($globalp->{Temp_Docs_Path});
        		
		open ("datafile", $thedocument);
    my @filedata=<datafile>;
		close ("datafile");
		
		my $linecounter = 0;
		my $XRefErrorMessage ="";
        
		foreach my $XRefLine (@filedata)
		{		
      $XRefLine =~ s/$LineFeed//g;
      $XRefLine =~ s/$CarriageReturn//g; 
			
			$linecounter +=1;
			
			if( $fdat{delimiterchar} eq "" ||  $fdat{delimiterchar} eq "\|")
			{
				@mydata = split('\|',$XRefLine);			
			}
			else
			{
				@mydata = split($fdat{delimiterchar},$XRefLine);
			}
						
			$mydata[0] =~ s/^\s+//; #remove leading spaces
			$mydata[0] =~ s/\s+$//; #remove trailing spaces
			
			if( $linecounter == 2 )
			{				
				$string1 = $XRefLine;
				my $num1 = $string1 =~ tr/|//;
                
				$xreftypeline2 = $mydata[0];

				if( $num1 == 2 )
				{
					$mylinedatasize = 3;
				}
				elsif($num1 == 3)
				{
					$mylinedatasize = 4;
				}
				#~ echo("line data size $mylinedatasize");exit;
			}
			
			if( $linecounter > 2 )
			{
				if( $mydata[0] ne $xreftypeline2 )
				{
					$XRefErrorMessage = "XRef File error in line $linecounter, the first column is the xreftype identifier and must have the same value in all records.";
					last;
				}
			}

		}
		undef @filedata;
        undef @mydata;
		if( $XRefErrorMessage eq "" )
		{
            my $ImportStartTime = time;
			&import_xref_file($thedocument,$mylinedatasize);
            my $ImportTime = time - $ImportStartTime;
            $globalp->{cleanup}();                           
			&redirect_url_to("index.prc?module=EplSiteETL&amp;option=xrefs&amp;ImportTime=$ImportTime");
		}
		else
		{
			$globalp->{General_EplSite_Error_Display}($XRefErrorMessage);	
		}
	}
	
    
    
	
	sub import_xref_file
	{
        my $XRefFileToLoad = shift;
		my $Thelinedatasize = shift;
		my $LineFeed = chr(10);
		my $CarriageReturn = chr(13);
        
		#~ echo("Line Size: $Thelinedatasize"); exit;
		open ("datafile", $XRefFileToLoad);
			my	@filedata=<datafile>;
		close ("datafile");	
		
		$file_deleted = $globalp->{DeleteMyFile}($XRefFileToLoad);
		
		$LineNumber = 0;
		$PreviousDataDeleted = "No";
		$globalp->{dbh}->{AutoCommit} = 0;
		my $sth = $globalp->{dbh}->prepare_cached(q{
		  INSERT INTO eplsite_etl_xreftable VALUES (?,
		  ?, ?, ?)}) or die $globalp->{dbh}->errstr;
        
        my $RecordCounter = 0;
		foreach my $XRefDataLine (@filedata)
		{	
			$LineNumber += 1;
            
			$XRefDataLine =~ s/$LineFeed//g;
			$XRefDataLine =~ s/$CarriageReturn//g;  			

			if( $fdat{delimiterchar} eq "" ||  $fdat{delimiterchar} eq "\|")
			{
				@mydata = split('\|',$XRefDataLine);			
			}
			else
			{
				@mydata = split($fdat{delimiterchar},$XRefDataLine);
			}
			
            $mydata[0] =~ s/^\s+//; #remove leading spaces
            $mydata[0] =~ s/\s+$//; #remove trailing spaces
            
			foreach my $XRefDataField (@mydata)
			{
				#~ $_ =~ s/'/''/g;
                $XRefDataField =~ s/\s+$//; #remove trailing spaces
				$XRefDataField =~ s/\\/\\\\/g;
			}
			
			if( $LineNumber == 2 )
			{
				if( $PreviousDataDeleted eq "No" )
				{                
                    #Delete all records taking the first column of the second record as reference.
                    $delete_xref_data = "DELETE FROM ".$globalp->{table_prefix}."_etl_xreftable WHERE xreftype = '$mydata[0]'";
                    $globalp->{dbh}->do( $delete_xref_data );
                    $rc = $globalp->{dbh}->commit() or die $globalp->{dbh}->errstr;
                    $PreviousDataDeleted = "Yes";
                }
			}
			
			if( $LineNumber >1 )
			{
				if( $mydata[0] ne "" )
				{
					if( $Thelinedatasize == 4 )
					{
						$sth->execute($mydata[0], $mydata[1],$mydata[2],$mydata[3]);
					}
					elsif( $Thelinedatasize == 3 )
					{
                        $emptyvalue = ' ';
                        $sth->execute($mydata[0], $mydata[1],$emptyvalue,$mydata[2]);
					}
					$RecordCounter +=1;
					if( $RecordCounter > 1000 )
					{
						$rc = $globalp->{dbh}->commit() or die $globalp->{dbh}->errstr;
						$RecordCounter = 0;
					}
                    
				}
			}
		}
        undef @filedata;
        undef @mydata;        
		$rc = $globalp->{dbh}->commit() or die $globalp->{dbh}->errstr;
		$globalp->{dbh}->{AutoCommit} = 1;
	}




	sub xref_main_menu
	{
		$globalp->{siteheader}();
		$globalp->{theheader}();

		@the_cvalues = $globalp->{get_the_cookie}();
		echo("<b> XREF Maintenance.  </b><br>\n");
		echo("<br><form name=\"xrefs\" action=\"index.prc\" method=\"post\" ENCTYPE=\"multipart/form-data\">\n"
			."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
			."<input type=\"hidden\" name=\"option\" value=\"xrefs\">\n"
      ."<fieldset><legend> <b>XRef File Import.</b> - Import file into table: eplsite_etl_xreftable</legend>\n"
			.$globalp->{_MFDELIMITERCHAR}."&nbsp;<input type=\"name\" name=\"delimiterchar\" value=\"|\" size=\"1\">\n"
			."Input File Name:<INPUT TYPE=\"FILE\" NAME=\"attachthis\" value=\"\" size=\"50\"> &nbsp; \n"
			."<input type=\"submit\" name=\"fileimport\" value=\"".$globalp->{_MFIMPORTXREF}."\">");
        echo("<p align=\"center\"><b>Last XRef Import Time: $fdat{ImportTime} Seconds.</b></p>") if( defined($fdat{ImportTime}) );

    echo("<p>The file fields structure must be:xreftype|from_value|from_value1|to_value<br><br>\n");
    echo("<b>Sample values for an xref file:</b>"
        ."<table border=\"1\">"
        ."<tr><th>XRef Type</th><th>From Value</th><th>From Value1</th><th>To Value</th></tr>"
        ."<tr><td>PageTitleXRef</td><td>EplSite ETL Overview</td><td></td><td>OverView</td></tr>"
        ."<tr><td>PageTitleXRef</td><td>EplSite Query Tool</td><td></td><td>Query Tool</td></tr>"
        ."</table>"
        ."* There are two possible from values because in my experience, some xrefs require it, ex: from_values: Warehouse|Location ~> to_value: New Warehouse</p>\n"
    );

    echo("</form></fieldset> <br> \n");

		$sthresult = $globalp->{dbh} -> prepare ("SELECT DISTINCT xreftype FROM ".$globalp->{table_prefix}."_etl_xreftable")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_etl_xreftable";
		$sthresult -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_etl_xreftable ";
		$sthresult -> bind_columns(undef, \$XRefType);
		
		echo("<form action=\"index.prc\" method=\"post\">\n"
				  ."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
				  ."<input type=\"hidden\" name=\"option\" value=\"xrefs\">\n"
          ."<fieldset><legend> <b>XRef Operations. </b></legend>\n"
				  ."<strong><big>&middot;</big></strong> Select XRef:\n"
				  ." <select name=\"xreftodelete\"><option value=\"\">-----------</option>\n");

		while( $datresult = $sthresult -> fetchrow_arrayref ) {
			echo("<option value=\"$XRefType\">$XRefType</option>\n");
		}
		$sthresult -> finish();

		echo("</select>&nbsp;&nbsp;&nbsp;\n"
			."<input name=\"xrefoption\" type=\"submit\" VALUE=\"Display\">&nbsp;&nbsp;&nbsp;"			
			."<input type=\"hidden\" name=\"deletedefinitely\" value=\"Yes\">"
            #."Not insert keeping record when deleting.\n"
            ."<input name=\"xrefoption\" type=\"submit\" VALUE=\"".$globalp->{_DELETE}."\">"
			."</form></fieldset><br>\n");

		$globalp->{CloseTable}();
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
	}

    if( $fdat{fileimport} eq  $globalp->{_MFIMPORTXREF} )
	{ 
		&xref_import_file;
		#~ &xref_main_menu;
	}
    elsif( $fdat{xrefoption} eq $globalp->{_DELETE} && $fdat{xreftodelete} ne "" ){ &xref_delete; }
	elsif( $fdat{xrefoption} eq "Display"  && $fdat{xreftodelete} ne "" ){ &xref_display; }
	else { &xref_main_menu; }

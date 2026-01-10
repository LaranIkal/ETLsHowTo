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
	
	our( $oracle_connection, @the_cvalues );
	@the_cvalues = $globalp->{get_the_cookie}();

	$globalp->{siteheader}();
	echo("<script type=\"text/javascript\" src=\"includes/PostAjaxLibrary.js\"></script>\n"
			."<script type=\"text/javascript\" src=\"modules/EplSiteETL/EplSiteETL.js\"></script>\n");		
	$globalp->{theheader}();

	&EplSiteETLMainMenu ;
		
	if( defined($fdat{ETLSchemeID}) )
	{
		if( $fdat{ETLSchemeID} ne "" )
		{
			$selectquery = "SELECT ETLSchemeCode, ETLSchemeDescription";
            $selectquery .= ", CatalogsDataSourceID, AdditionalScriptMenu";
            $selectquery .= " FROM ".$globalp->{table_prefix}."_etl_schemes";
            $selectquery .= " WHERE ETLSchemeID = ".$fdat{ETLSchemeID};		
			$resulti = $globalp->{dbh} -> prepare ($selectquery)
            or die "Cannot prepare query:$selectquery";
			$resulti -> execute or die "Cannot execute query:$selectquery";
			$resulti -> bind_columns(undef, \$ETLSchemeCode, \$ETLSchemeDescription, \$CatalogsDataSourceID, \$AdditionalScriptMenu);
			if( $datresulti = $resulti -> fetchrow_arrayref )
			{
				echo("<br>");
				$globalp->{OpenTable}();
				echo( "<fieldset><legend><big><b><div style=\"color:blue;\">"
            ."This Screen is Mainly For Developing and Testing ETL Transformations.<br>"
            ."For Production Use, Please run a Batch Process. See samples under Directory: EplSiteETL/BatchProcess</div><br>"
            ."Menu For EplSite ETL Scheme(ETLSchemeID - ETLSchemeCode - ETLSchemeDescription):$fdat{ETLSchemeID} - $ETLSchemeCode - "
            ." $ETLSchemeDescription.</b></big></legend><div id=\"ETLSchemeMenu\">"
        );
				
				&DisplayGeneralETLSchemeMenu($ETLSchemeCode);
				
				$AdditionalScriptMenu  =~ s/^\s+//; #remove leading spaces
				$AdditionalScriptMenu  =~ s/\s+$//; #remove trailing spaces				
				if( $AdditionalScriptMenu ne "" )
				{
					eval $AdditionalScriptMenu;
					if($@)
					{
						echo($@);
						$globalp->{clean_exit}();
					}
				}
				
				echo("<table><tr><td>"
                ."&nbsp;<input type=\"button\" VALUE=\"Execute\"\n"
                ." onclick='JavaScript:xmlhttpPostTransformation(\"index.prc\",this.form,\"TLogID\",\"Execute\")'><br>\n"
				."</td></tr>\n"
				."</table></form>"
				."</div></fieldset><br><fieldset><div id=\"TLogID\"></div></fieldset>");
				$globalp->{CloseTable}();	
			}
			else
			{
				echo("<br>");
				$globalp->{OpenTable}();
				echo("<fieldset><div id=\"ETLSchemeMenu\">ETL Scheme Not Found.</div></fieldset>");
				$globalp->{CloseTable}();			

			}
		$resulti->finish();			
		}
		else
		{
			echo("<br>");
			$globalp->{OpenTable}();
			echo("<fieldset><div id=\"ETLSchemeMenu\">No ETL Scheme Selected.</div></fieldset>");
			$globalp->{CloseTable}();			
		}
	}
	else
	{
		echo("<br>");
		$globalp->{OpenTable}();
		echo("<fieldset><div id=\"ETLSchemeMenu\">No ETL Scheme Selected.</div></fieldset>");
		$globalp->{CloseTable}();
	}
		
	@the_cvalues = $globalp->{get_the_cookie}() if( scalar(@the_cvalues)==0 );
	$globalp->{loggedon_as}();
	$globalp->{sitefooter}();
	$globalp->{clean_exit}();
	
		
	
	sub DisplayGeneralETLSchemeMenu
	{
        my $MyETLSchemeCode = shift;
		echo("<table><tr><td><strong><big>&middot;</big></strong>\n"
				."<a href=\"index.prc?module=EplSiteETL&amp;"
                ."option=setupxportlayouts&amp;ETLSchemeID=$fdat{ETLSchemeID}\""
                ." target=\"_blank\">\n"
				.$globalp->{_MFXPORTFILES}."</a><br></td></tr></table>");
		
		
		echo("<form action=\"index.prc\" method=\"post\"><table><tr><td>"
				."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
				."<input type=\"hidden\" id=\"runnumber\" name=\"runnumber\" value=\"\">\n"
				."<input type=\"hidden\" name=\"option\" value=\"extractdata\">\n"
				."<input type=\"hidden\" id=\"ETLSchemeCode\" name=\"ETLSchemeCode\" value=\"$MyETLSchemeCode\">\n"
        ."<input type=\"hidden\" name=\"ETLSchemeID\" value=\"$fdat{ETLSchemeID}\">\n"
				."<strong><big>&middot;</big></strong> <b><big>Source DataBase Connection(DataSourceID - DataSourceName):</big> </b>"
				."<select id=\"DBConnSourceID\" name=\"DBConnSourceID\">"
				."<option selected value=\"\">Select Source DataBase Connection</option>\n");
			 
		$selectquery = "SELECT DataSourceID, DataSourceName";
		$selectquery .= " FROM ".$globalp->{table_prefix}."_etl_data_sources";
		$selectquery .= " ORDER BY DataSourceName";
		
		$resulti = $globalp->{dbh} -> prepare ($selectquery) 
        or die "Cannot prepare query:$selectquery";
		$resulti -> execute  or die "Cannot execute query:$selectquery";
		$resulti -> bind_columns(undef, \$DataSourceID, \$DataSourceName);

		while( $datresulti = $resulti -> fetchrow_arrayref )
		{
			echo("<option value=\"$DataSourceID\">$DataSourceID - $DataSourceName</option>\n");
		}
		$resulti->finish();        
		echo("</select>&nbsp;&nbsp;<br>"
				."<strong><big>&middot;</big></strong> <b><big>Target DataBase Connection(DataSourceID - DataSourceName):</big> </b>"
				."<select id=\"DBConnTargetID\" name=\"DBConnTargetID\">"
				."<option selected value=\"\">Select Target DataBase Connection</option>\n"
                ."<option value=\"3333\">3333 - Pipe Delimited File</option>\n"
                );
			 
		$selectquery = "SELECT DataSourceID, DataSourceName";
		$selectquery .= " FROM ".$globalp->{table_prefix}."_etl_data_sources";
		$selectquery .= " ORDER BY DataSourceName";
		
		$resulti = $globalp->{dbh} -> prepare ($selectquery) 
        or die "Cannot prepare query:$selectquery";
		$resulti -> execute  or die "Cannot execute query:$selectquery";
		$resulti -> bind_columns(undef, \$DataSourceID, \$DataSourceName);

		while( $datresulti = $resulti -> fetchrow_arrayref )
		{
			echo("<option value=\"$DataSourceID\">$DataSourceID - $DataSourceName</option>\n");
		}
		$resulti->finish();
        
        echo("</select><br><br>\n"
				."<strong><big>&middot;</big></strong> <b><big>Layout To Process(TransformationCode - ETLSchemeCode - Description):</big></b>\n"
				." <select id=\"TransformationCode\" name=\"TransformationCode\"><option value=\"\">Select Layout To Process</option>\n");

        $SelectQuery = "SELECT TransformationCode,Description";
        $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_transformation_definitions";
        $SelectQuery .= " WHERE ETLSchemeID = ".$fdat{ETLSchemeID};
        $SelectQuery .= " AND ShowInMenu = 'Yes'";
        $SelectQuery .= " ORDER BY TransformationCode";
        
		$sthresult = $globalp->{dbh} -> prepare ($SelectQuery)
        or die "Cannot prepare query:$SelectQuery";
		$sthresult -> execute  or die "Cannot execute query:$SelectQuery";
		$sthresult -> bind_columns(undef, \$TransformationCode, \$Description);

		while( $datresult = $sthresult -> fetchrow_arrayref ) {
			echo("<option value=\"$TransformationCode\">$TransformationCode - $MyETLSchemeCode - $Description</option>\n");
		}
		$sthresult -> finish();
		
		echo("</select>&nbsp;&nbsp;or&nbsp;&nbsp;\n"
				."<strong><big>&middot;</big></strong> <b><big>Independent Perl Script:</big></b>\n"
				." <select id=\"ScriptID\" name=\"ScriptID\"><option value=\"\">Select Script To Execute</option>\n");

    $SelectQuery = "SELECT ScriptID,ScriptName,ScriptDescription";
    $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_independent_scripts";
    $SelectQuery .= " WHERE ETLSchemeCode = '".$MyETLSchemeCode."'";
    $SelectQuery .= " ORDER BY ScriptDescription";
        
		$sthresult = $globalp->{dbh} -> prepare ($SelectQuery)
        or die "Cannot prepare:$SelectQuery";
		$sthresult -> execute or die "Cannot execute query:$SelectQuery";
		$sthresult -> bind_columns(undef, \$ScriptID,\$ScriptName,\$ScriptDescription);

		while( $datresult = $sthresult -> fetchrow_arrayref ) {
			echo("<option value=\"$ScriptID\">$ScriptID - $ScriptDescription</option>\n");
		}
		$sthresult -> finish();
		
		echo("</select></td></tr></table>");
        echo("<fieldset><legend><b>Options For Data Export.</b></legend>");
        echo('<table><tr><td><input type="radio" name="xrefcondition" value="allrecords"'
        .' checked>'.$globalp->{_MFALLRECORDS}.' ( Section <b><u>Script After Record</u></b> is always processed. )</td>'
		.'<td>&nbsp;</td></tr>'
        .'<tr><td><input type="radio" name="xrefcondition" value="cleanxrefonly">'
        .$globalp->{_MFCLEANXREFONLY}.'<sup><font color="blue"><b>X</b></font></sup>'
		.'<td>&nbsp;</td></tr>'
        .'<tr><td><input type="radio" name="xrefcondition" value="recordsok">'
        .'Only Records With Correct XRef, Check Catalogs.<sup><font color="blue"><b>X</b></font></sup>'
		.'<br>Choosing this option, catalogs are checked and,<br> if errors,'
		.' these will be in Catalog error log. Records will be exported.</td>'		
		.'<td>&nbsp;</td></tr>'
        .'<tr><td><br><u>*XRef is always checked, records with xref error will'
		.' have zero(0) value and inserted in xref error log.</u>'
		.'<br><sup><font color="blue"><b>X</b></font></sup>( For records with XRef error, section <b><u>Script After Record</u> is <font color ="red">NOT</font> processed.</b> )</td><td>&nbsp;</td></tr>'
		.'</table>'
        .'<table><tr><td colspan="4"><hr align="left" width="30%25"></td></tr>'
        .'<tr><td colspan="4">Include File Header(When exporting to pipe delimited file db target connection)?</td></tr>'
        .'<tr><td><input type="radio" name="fileheader" value="numeric"> Numeric</td>'
        .'<td><input type="radio" name="fileheader" value="descriptive"> Descriptive  </td>'
        .'<td><input type="radio" name="fileheader" value="both" checked> Both  </td>'
        .'<td><input type="radio" name="fileheader" value="No"> No Header </td></tr></table></fieldset>'
        .'<table><tr><td colspan="2">Preview Query?</td>'
        .'<tr><td><input type="radio" name="previewquery" value="Yes"> Yes</td>'
        .'<td><input type="radio" name="previewquery" value="No" checked> No</td></tr></table>');
        
	}

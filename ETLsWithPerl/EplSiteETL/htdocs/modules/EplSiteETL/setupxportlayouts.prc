########################################################################
# Eplsite,Setup Export Layouts Subroutines For ETL
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



	
	
	sub EditLayout
	{
		$globalp->{siteheader}();
		echo("<script type=\"text/javascript\" src=\"".$globalp->{eplsite_url}."includes/PostAjaxLibrary.js\"></script>\n"
		."<script type=\"text/javascript\" src=\"".$globalp->{eplsite_url}."modules/EplSiteETL/setupxportlayouts.js\"></script>\n");		

		$globalp->{theheader}();
		@the_cvalues = $globalp->{get_the_cookie}();
        
		$TransformationCode = "";
        
        $SelectQuery = "SELECT a.ETLSchemeID, a.ETLSchemeCode, b.TransformationCode, b.Description";
        $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_schemes a";
        $SelectQuery .= " , ".$globalp->{table_prefix}."_etl_transformation_definitions b";
        $SelectQuery .= " WHERE a.ETLSchemeID=b.ETLSchemeID";
        $SelectQuery .= " AND b.TransformationID = ".$fdat{TransformationID};
                    
		$sthresult = $globalp->{dbh}-> prepare ($SelectQuery)
        or die "Cannot prepare query:$SelectQuery";
		$sthresult -> execute or die "Cannot execute query:$SelectQuery";
		$sthresult -> bind_columns(undef, \$ETLSchemeID, \$ETLSchemeCode, \$TransformationCode, \$Description);
		$datresult = $sthresult -> fetchrow_arrayref();
		$sthresult -> finish();
        
        $fdat{ETLSchemeID} = $ETLSchemeID;
        
		&MaintainLayoutsMainMenu;
        
        $selectquery = "SELECT count(*) FROM ";
        $selectquery .= $globalp->{table_prefix}."_etl_export_layouts a";
        $selectquery .= " WHERE a.ETLSchemeCode = '".$ETLSchemeCode."'";
        $selectquery .= " AND a.TransformationCode='".$TransformationCode."'";

        $sthsearch14 = $globalp->{dbh}->prepare ($selectquery)
        or die "Cannot prepare query:$selectquery";
        $sthsearch14 -> execute  or die "Cannot execute query:$selectquery";
        $sthsearch14 -> bind_columns(undef, \$FieldSequenceCount);
        $datsearch14 = $sthsearch14 -> fetchrow_arrayref;
        $sthsearch14->finish();

		if( $TransformationCode ne "" )
		{
			$globalp->{OpenTable}();
			echo("<form action=\"index.prc\" method=\"post\">\n"
			."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
			."<input type=\"hidden\" name=\"option\" value=\"setupxportlayouts\">\n"
			."<input type=\"hidden\" name=\"ETLSchemeID\" value=\"$fdat{ETLSchemeID}\">\n"
			."<input type=\"hidden\" name=\"ETLSchemeCode\" value=\"$ETLSchemeCode\">\n"
			."<input type=\"hidden\" name=\"maintaincfg\" value=\"Save\">\n"
			."<input type=\"hidden\" name=\"TransformationID\" value=\"$fdat{TransformationID}\">\n"
			."<b>Layout Code: $TransformationCode &nbsp;- &nbsp;<input type=\"hidden\" name=\"TransformationCode\" value=\"$TransformationCode\">\n"
			.$globalp->{_LAYOUTDESCRIPTION}.":$Description<input type=\"hidden\" name=\"Description\" value=\"$Description\">\n"
			."&nbsp;<input type=\"hidden\" name=\"fieldsnumber\" value=\"$RecordsInCFG\"></b><br><br>\n");

			echo( "<table border=0><tr>"
			."<td><b>".$globalp->{_MFSEQN}."</b></td>"
			."<td><b>Field Description</b></td>\n"
			."<td colspan=2><b>Catalog And \n"
			."<b>Flds Sq. <br>For Validation</b></td>\n"
			."<td><b>".$globalp->{_MFVALUETYPE}."</b></td><td><b>".$globalp->{_MFVALUEORFN}."</b></td>\n"
			."<td><b>Export<br>Field</b></td></tr>" );
		}

		$LastSequenceNumber = 0;

        if( $FieldSequenceCount > 0 )
        {
            $selectquery = "SELECT a.FieldSequence, a.FieldDescription, a.ValueType, ";
			$selectquery .=  "a.ConstantValue, a.QueryField, a.QueryField1ForXRef, a.QueryField2ForXRef,";
			$selectquery .=  "a.xreftype, a.ExportField, a.Catalog,";
			$selectquery .=  " a.TransformationScriptID, a.TransformationScriptParameters,";
			$selectquery .=  " a.FieldNumForValidation1, a.FieldNumForValidation2 FROM ";
            $selectquery .= $globalp->{table_prefix}."_etl_export_layouts a";
            $selectquery .=  " WHERE a.ETLSchemeCode = '".$ETLSchemeCode."'";
            $selectquery .=  " AND a.TransformationCode='".$TransformationCode."'";
            $selectquery .= " ORDER BY a.FieldSequence";
            
            $resulti = $globalp->{dbh} -> prepare ($selectquery ) 
            or die "Cannot prepare query:$selectquery";
            $resulti -> execute  or die "Cannot execute query:$selectquery";
            $resulti -> bind_columns(undef, \$FieldSequence, \$FieldDescription, \$ValueType, \$ConstantValue, \$QueryField, \$QueryField1ForXRef, \$QueryField2ForXRef, \$xreftype, \$ExportField, \$Catalog, \$TransformationScriptID, \$TransformationScriptParameters, \$FieldNumForValidation1, \$FieldNumForValidation2);

            while( $datresulti = $resulti -> fetchrow_arrayref )
            {
                $LastSequenceNumber = $FieldSequence;
				 echo("<tr>\n"
						."<td>"
						."<input type=\"checkbox\" name=\"DelSeq$FieldSequence\" value=\"Yes\">"
						."<input type=\"hidden\" name=\"Sequence$FieldSequence\""
                        ." value=\"$FieldSequence\">$FieldSequence"
						."</td>\n"
						."<td><input type=\"text\" name=\"FieldDescription$FieldSequence\" size=\"25\""
                        ." value=\"$FieldDescription\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n");
						
				echo("<td><select name=\"catalog$FieldSequence\">\n");
						
				if( $Catalog == 0 )
				{
					echo("<option selected value=\"0\">-----------</option>\n");
				}
				else
				{
					echo("<option value=\"0\">-----------</option>\n");					
				}
				
                my $CatalogsSelect = "SELECT TableID, CatalogTableName";
                $CatalogsSelect .= " FROM ".$globalp->{table_prefix}."_etl_catalogs";
                $CatalogsSelect .= " WHERE ETLSchemeID = ".$ETLSchemeID;
                $CatalogsSelect .= " ORDER BY CatalogTableName";

				$sthresultxref = $globalp->{dbh} -> prepare ($CatalogsSelect)
                or die echo("Cannot prepare query:$CatalogsSelect");
				$sthresultxref -> execute or die echo("Cannot execute query:$CatalogsSelect");
				$sthresultxref -> bind_columns(undef, \$TableID, \$CatalogTableName);

				while( $datresultxref = $sthresultxref -> fetchrow_arrayref ) {
					$selected = " " ;
					if( $Catalog eq $TableID ){ $selected = " selected "; }
					
					echo("<option".$selected."value=\"$TableID\">$CatalogTableName</option>\n");
				}
				$sthresultxref -> finish();

				echo("</select></td>\n");				
				
				if( $FieldNumForValidation1 == 0 )
				{
					$FieldNumForValidation1 = $FieldSequence;
				}
				
				echo("<td><table border=\"0\"><tr><td><input type=\"text\" "
                ."name=\"FieldNumForValidation1$FieldSequence\" size=\"2\" "
                ."value=\"$FieldNumForValidation1\" maxlength=\"3\" "
                ."onkeydown='testForEnter();'></td><td>"
                ."<input type=\"text\" name=\"FieldNumForValidation2$FieldSequence\""
                ." size=\"2\" value=\"$FieldNumForValidation2\" maxlength=\"3\""
                ." onkeydown='testForEnter();'></td></tr></table></td>\n");

				echo("<td><select id=\"valuetype$FieldSequence\" name=\"valuetype$FieldSequence\""
                ." onChange='JavaScript:xmlhttpPostValueType(\"index.prc\",this.form,\"$FieldSequence\","
                ."\"valuetype$FieldSequence\",\"Expresion$FieldSequence\",this)'>\n");
				
				if( $ValueType eq "" )
				{
					echo("<option selected value=\"\">-----------</option>\n");
				}
				else
				{
					echo("<option value=\"\">-----------</option>\n");					
				}
				
				if( $ValueType eq "ConstantValue" )
				{
					echo("<option selected value=\"$ValueType\">Constant Value</option>\n");
				}
				else
				{
					echo("<option value=\"ConstantValue\">Constant Value</option>\n");					
				}				
				
				if( $ValueType eq "QueryField" )
				{
					echo("<option selected value=\"$ValueType\">Query Field</option>\n");
				}
				else
				{
					echo("<option value=\"QueryField\">Query Field</option>\n");					
				}				

				if( $ValueType eq "CrossReference" )
				{
					echo("<option selected value=\"$ValueType\">Cross Reference</option>\n");
				}
				else
				{
					echo("<option value=\"CrossReference\">Cross Reference</option>\n");					
				}				

				if( $ValueType eq "TransformationScript" )
				{
					echo("<option selected value=\"$ValueType\">Transformation Script</option>\n");
				}
				else
				{
					echo("<option value=\"TransformationScript\">Transformation Script</option>\n");					
				}

				echo("</select></td>\n");

				echo("<td><div id=\"Expresion$FieldSequence\"><table><tr>");
				
				if( $ValueType eq "ConstantValue" )
				{
					#~ $ConstantValue =~ s/"/\\"/g;
					$ConstantValue =~ s/"/&quot;/g;
					echo("<td><input type=\"text\" name=\"ConstantValue$FieldSequence\""
                    ." size=\"20\" value=\"$ConstantValue\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n");
				}								
				elsif( $ValueType eq "QueryField" )
				{
					#~ $QueryField=~ s/"/\\"/g;
					$QueryField =~ s/"/&quot;/g;
					echo("<td><input type=\"text\" name=\"QueryField$FieldSequence\""
                    ." size=\"40\" value=\"$QueryField\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n");
				}
				elsif( $ValueType eq "CrossReference" )
				{
					$QueryField1ForXRef =~ s/"/&quot;/g;
					$QueryField2ForXRef =~ s/"/&quot;/g;
					echo("<td>Field1:</td><td><input type=\"text\" name=\"QueryField1ForXRef$FieldSequence\""
                    ." size=\"20\" value=\"$QueryField1ForXRef\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n"
                    ."<td>Field2:</td><td><input type=\"text\" name=\"QueryField2ForXRef$FieldSequence\""
                    ." size=\"20\" value=\"$QueryField2ForXRef\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n");
                    
					echo("<td><select name=\"xreftype$FieldSequence\"><option value=\"\">-----------</option>\n");			
					
                    my $SelectXRef = "SELECT DISTINCT xreftype";
                    $SelectXRef .= " FROM ".$globalp->{table_prefix}."_etl_xreftable";
                    
					$sthresultxref = $globalp->{dbh} -> prepare ($SelectXRef)
                    or die "Cannot prepare query:$SelectXRef";
					$sthresultxref -> execute or die "Cannot execute query:$SelectXRef";
					$sthresultxref -> bind_columns(undef, \$XRefTypeCat);

					while( $datresultxref = $sthresultxref -> fetchrow_arrayref ) 
					{
						$selected = " " ;
						if( $xreftype eq $XRefTypeCat ){ $selected = " selected "; }
						
						echo("<option".$selected."value=\"$XRefTypeCat\">$XRefTypeCat</option>\n");
					}
					$sthresultxref -> finish();
					echo("</select></td>\n");
				}				
				elsif( $ValueType eq "TransformationScript" )
				{
					$TransformationScriptParameters =~ s/"/&quot;/g;
					echo("<td>Params:</td><td><input type=\"text\" name=\"TSParameters$FieldSequence\""
                    ." size=\"40\" value=\"$TransformationScriptParameters\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n"
							."<td><select name=\"tsid$FieldSequence\"><option value=\"0\">-----------</option>\n");

                    my $SelectQuery = "SELECT TransformationScriptID, TransformationScriptName";
                    $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_transformationscripts";
                    
					$sthresultxref = $globalp->{dbh} -> prepare ($SelectQuery)
                    or die "Cannot prepare query:$SelectQuery";
					$sthresultxref -> execute  or die "Cannot execute query:$SelectQuery";
					$sthresultxref -> bind_columns(undef, \$TransformationScriptIDCat, \$TransformationScriptName);

					while( $datresultxref = $sthresultxref -> fetchrow_arrayref ) 
					{
						$selected = " " ;
						if( $TransformationScriptID eq $TransformationScriptIDCat ){ $selected = " selected "; }
						
						echo("<option".$selected."value=\"$TransformationScriptIDCat\">$TransformationScriptName</option>\n");
					}
					$sthresultxref -> finish();
					echo("</select></td>\n");
				}

				echo("</tr></table></td>");
				
				echo("<td><select name=\"exportfield$FieldSequence\">\n");
				
				if( $ExportField eq "Yes" )
				{
					echo( "<option selected value=\"Yes\">Yes</option>\n"
							."<option value=\"No\">No</option></select></td></tr>\n");
				}
				else
				{
					echo( "<option value=\"Yes\">Yes</option>\n"
							."<option selected value=\"No\">No</option></select></td></tr>\n");					
				}
			}
			$resulti -> finish();
		}

        $LastSequenceNumber += 1;
        
        for ( $count = $LastSequenceNumber; $count <= $LastSequenceNumber + 4 ; $count++ ) 
		{		
				$FieldSequence = $count;
                echo("<tr>\n"
                ."<td><input type=\"hidden\" name=\"Sequence$FieldSequence\""
                ." value=\"$FieldSequence\">$FieldSequence</td>\n"
                ."<td><input type=\"text\" name=\"FieldDescription$FieldSequence\""
                ." size=\"25\" value=\"\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n");
						
				echo("<td><select name=\"catalog$FieldSequence\">\n"
						."<option selected value=\"0\">-----------</option>\n");
				
                $SelectQuery = "SELECT TableID, CatalogTableName";
                $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_catalogs";
                $SelectQuery .= " WHERE ETLSchemeID = ".$ETLSchemeID;
                $SelectQuery .= " ORDER BY CatalogTableName";

				$sthresultxref = $globalp->{dbh} -> prepare ($SelectQuery)
                or die "Cannot prepare query:$SelectQuery";
				$sthresultxref -> execute  or die "Cannot execute query:$SelectQuery";
				$sthresultxref -> bind_columns(undef, \$TableID, \$CatalogTableName);

				while( $datresultxref = $sthresultxref -> fetchrow_arrayref ) 
				{
					echo("<option value=\"$TableID\">$CatalogTableName</option>\n");
				}
				$sthresultxref -> finish();

				echo("</select></td>\n");

				echo("<td><table border=\"0\"><tr><td><input type=\"text\""
                ." name=\"FieldNumForValidation1$FieldSequence\" size=\"2\""
                ." value=\"$FieldSequence\" maxlength=\"3\" onkeydown='testForEnter();'></td><td>"
				."<input type=\"text\" name=\"FieldNumForValidation2$FieldSequence\""
                ." size=\"2\" value=\"0\" maxlength=\"3\" onkeydown='testForEnter();'></td></tr></table></td>\n");

				echo("<td><select id=\"valuetype$FieldSequence\" name=\"valuetype$FieldSequence\""
                ." onChange='JavaScript:xmlhttpPostValueType(\"index.prc\",this.form,\"$FieldSequence\""
                .",\"valuetype$FieldSequence\",\"Expresion$FieldSequence\",this)'>\n"
                ."<option selected value=\"\">-----------</option>\n"
                ."<option value=\"ConstantValue\">Constant Value</option>\n"
                ."<option value=\"QueryField\">Query Field</option>\n"
                ."<option value=\"CrossReference\">Cross Reference</option>\n"
                ."<option value=\"TransformationScript\">Transformation Script</option>\n"
                ."</select></td>\n");

				echo("<td><div id=\"Expresion$FieldSequence\"> </div></td>");

				echo("<td><select name=\"exportfield$FieldSequence\"><option value=\"\">----</option>\n");
				

				echo( "<option value=\"Yes\">Yes</option>\n"
						."<option selected value=\"No\">No</option></select></td></tr>\n");					
		}

        
		echo("<tr>\n"
        ."<td><input name=\"submit\" value=\"Save\" type=\"submit\"></td>\n"
        ."<td><input name=\"deletecfglines\" value=\"". $globalp->{_SAVEANDDELSEQS} . "\" type=\"submit\""
        ."onClick='return ConfirmSubmit(\"Do you want to delete selected sequences?\")'"
        ."></td>\n"
        #~ ."<td><input name=\"renumberseqs\" value=\"". $globalp->{_RENUMBERSEQS} . "\" type=\"submit\""
        #~ ."onClick='return ConfirmSubmit(\"Do you want to renumber sequences?\")'"
        #~ ."></td>\n"
        ."<td colspan=\"3\">Seq.:<input type=\"text\" name=\"BeforeSequence\""
        ." size=\"2\" value=\"\" maxlength=\"3\" onkeydown='testForEnter();'>"
        ." <input name=\"insertseq\" value=\"Insert One Field Before Sequence\" type=\"submit\""
        ."onClick='return ConfirmSubmit(\"Please, Confirm Field Insertion\")'"
        ."></td>\n"				
        ."</tr>\n"
        .'</table>'."\n"
        .'<input type="hidden" name="lastsequence" value="'.$FieldSequence.'">'
        .'</form> '."\n");
				
		$globalp->{CloseTable}();		
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();
	}




	sub UpdateValueInLayout
	{
		$FieldSequence = $fdat{sequencenum};
		
		$selectquery =  "SELECT a.ConstantValue, a.QueryField, a.QueryField1ForXRef, a.QueryField2ForXRef,";
		$selectquery .=  "a.xreftype, a.TransformationScriptID, a.TransformationScriptParameters";
		$selectquery .= " FROM ".$globalp->{table_prefix}."_etl_export_layouts a";
        $selectquery .= " WHERE a.ETLSchemeCode = '$fdat{ETLSchemeCode}'";
        $selectquery .= " AND a.TransformationCode='$fdat{TransformationCode}'";
		$selectquery .= " AND a.FieldSequence = $fdat{sequencenum}";
            
		$resulti = $globalp->{dbh} -> prepare ( $selectquery )
        or die "Cannot prepare query:$selectquery";
		$resulti -> execute  or die "Cannot execute query:$selectquery";
		$resulti -> bind_columns(undef,  \$ConstantValue, \$QueryField, \$QueryField1ForXRef, \$QueryField2ForXRef, \$xreftype, \$TransformationScriptID, \$TransformationScriptParameters);

		$LayoutExists = 0;
		echo("<table><tr>");
		
		while( $datresulti = $resulti -> fetchrow_arrayref )
		{
			$LayoutExists = 1;
			if( $fdat{valuetype} eq "ConstantValue" )
			{
				$ConstantValue =~ s/"/&quot;/g;
				echo("<td><input type=\"text\" name=\"ConstantValue$FieldSequence\" size=\"20\""
                ." value=\"$ConstantValue\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n");
			}							
			elsif( $fdat{valuetype} eq "QueryField" )
			{
				$QueryField=~ s/"/&quot;/g;
				echo("<td><input type=\"text\" name=\"QueryField$FieldSequence\" size=\"40\""
                ." value=\"$QueryField\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n");
			}
			elsif( $fdat{valuetype} eq "CrossReference" )
			{
					$QueryField1ForXRef =~ s/"/&quot;/g;
					$QueryField2ForXRef =~ s/"/&quot;/g;				
				echo("<td>Field1:</td><td><input type=\"text\" name=\"QueryField1ForXRef$FieldSequence\""
                ." size=\"20\" value=\"$QueryField1ForXRef\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n"
				."<td>Field2:</td><td><input type=\"text\" name=\"QueryField2ForXRef$FieldSequence\""
                ." size=\"20\" value=\"$QueryField2ForXRef\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n");
				echo("<td><select name=\"xreftype$FieldSequence\"><option value=\"\">-----------</option>\n");			

                $SelectQuery = "SELECT DISTINCT xreftype";
                $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_xreftable";

				$sthresultxref = $globalp->{dbh} -> prepare ($SelectQuery)
                or die "Cannot prepare query:$SelectQuery";
				$sthresultxref -> execute or die "Cannot execute query:$SelectQuery";
				$sthresultxref -> bind_columns(undef, \$XRefTypeCat);

				while( $datresultxref = $sthresultxref -> fetchrow_arrayref ) 
				{
					$selected = " " ;
					if( $xreftype eq $XRefTypeCat ){ $selected = " selected "; }
					
					echo("<option".$selected."value=\"$XRefTypeCat\">$XRefTypeCat</option>\n");
				}
				$sthresultxref -> finish();
				echo("</select></td>\n");
			}			
			elsif( $fdat{valuetype} eq "TransformationScript" )
			{
				$TransformationScriptParameters =~ s/"/&quot;/g;
				echo("<td>Params:</td><td><input type=\"text\" name=\"TSParameters$FieldSequence\""
                ." size=\"40\" value=\"$TransformationScriptParameters\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n"
						."<td><select name=\"tsid$FieldSequence\"><option value=\"0\">-----------</option>\n");

                $SelectQuery = "SELECT TransformationScriptID, TransformationScriptName";
                $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_transformationscripts";
                
				$sthresultxref = $globalp->{dbh} -> prepare ($SelectQuery)
                or die "Cannot prepare query:$SelectQuery";
				$sthresultxref -> execute  or die "Cannot execute query:$SelectQuery";
				$sthresultxref -> bind_columns(undef, \$TransformationScriptIDCat, \$TransformationScriptName);

				while( $datresultxref = $sthresultxref -> fetchrow_arrayref ) 
				{
					$selected = " " ;
					if( $TransformationScriptID eq $TransformationScriptIDCat ){ $selected = " selected "; }
					
					echo("<option".$selected."value=\"$TransformationScriptIDCat\">$TransformationScriptName</option>\n");
				}
				$sthresultxref -> finish();
				echo("</select></td>\n");
			}			
		}
		$resulti -> finish();
		
		if ( $LayoutExists == 0 )
		{				
			if( $fdat{valuetype} eq "ConstantValue" )
			{
				echo("<td><input type=\"text\" name=\"ConstantValue$FieldSequence\""
                ." size=\"20\" value=\"\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n");
			}							
			elsif( $fdat{valuetype} eq "QueryField" )
			{
				echo("<td><input type=\"text\" name=\"QueryField$FieldSequence\""
                ." size=\"40\" value=\"\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n");
			}
			elsif( $fdat{valuetype} eq "CrossReference" )
			{
				echo("<td>Field1:</td><td><input type=\"text\" name=\"QueryField1ForXRef$FieldSequence\""
                ." size=\"20\" value=\"\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n"
                ."<td>Field2:</td><td><input type=\"text\" name=\"QueryField2ForXRef$FieldSequence\""
                ." size=\"20\" value=\"\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n");
				echo("<td><select name=\"xreftype$FieldSequence\"><option value=\"\">-----------</option>\n");

                $SelectQuery = "SELECT DISTINCT xreftype";
                $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_xreftable";
				$sthresultxref = $globalp->{dbh} -> prepare ($SelectQuery) 
                or die "Cannot prepare query:$SelectQuery";
				$sthresultxref -> execute  or die "Cannot execute query:$SelectQuery";
				$sthresultxref -> bind_columns(undef, \$XRefTypeCat);

				while( $datresultxref = $sthresultxref -> fetchrow_arrayref ) 
				{
					$selected = " " ;
					if( $xreftype eq $XRefTypeCat ){ $selected = " selected "; }
					
					echo("<option".$selected."value=\"$XRefTypeCat\">$XRefTypeCat</option>\n");
				}
				$sthresultxref -> finish();
				echo("</select></td>\n");
			}			
			elsif( $fdat{valuetype} eq "TransformationScript" )
			{
				echo("<td>Params:</td><td><input type=\"text\" name=\"TSParameters$FieldSequence\""
                ." size=\"40\" value=\"\" maxlength=\"100\" onkeydown='testForEnter();'></td>\n"
				."<td><select name=\"tsid$FieldSequence\"><option value=\"0\">-----------</option>\n");

                $SelectQuery = "SELECT TransformationScriptID, TransformationScriptName";
                $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_transformationscripts";
                
				$sthresultxref = $globalp->{dbh} -> prepare ($SelectQuery)
                or die "Cannot prepare query:$SelectQuery";
				$sthresultxref -> execute  or die "Cannot execute query:$SelectQuery";
				$sthresultxref -> bind_columns(undef, \$TransformationScriptIDCat, \$TransformationScriptName);

				while( $datresultxref = $sthresultxref -> fetchrow_arrayref ) 
				{
					$selected = " " ;
					if( $TransformationScriptID eq $TransformationScriptIDCat ){ $selected = " selected "; }
					
					echo("<option".$selected."value=\"$TransformationScriptIDCat\">$TransformationScriptName</option>\n");
				}
				$sthresultxref -> finish();
				echo("</select></td>\n");
			}			
		}
		echo("</tr></table>");
		$globalp->{clean_exit}();
	}






	sub SaveLayout
	{
		$fdat{runnumber} = 0;
		&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Saving layout.");
		
        for ( $SequenceCounter = 1; $SequenceCounter <= $fdat{lastsequence}; $SequenceCounter++ ) 
		{
            $fdat{"catalog".$SequenceCounter} = 0 if( $fdat{"catalog".$SequenceCounter} eq "" );
            
            if( defined($fdat{"Sequence".$SequenceCounter}) )
            {
				$fdat{"FieldDescription".$SequenceCounter} = &Clean_Special_Chars($globalp->{All_Trim}($fdat{"FieldDescription".$SequenceCounter}));
				
				if( $fdat{"Sequence".$SequenceCounter} > 0 
                and ( $fdat{"FieldDescription".$SequenceCounter} ne "" or $fdat{"valuetype".$SequenceCounter} ne "" ) )
				{
					$SequenceExists = 0;
					
					$SelectQuery = "SELECT count(*)";
                    $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_export_layouts";
					$SelectQuery .= " WHERE ETLSchemeCode = '".$fdat{ETLSchemeCode}."'";
					$SelectQuery .= " AND TransformationCode = '".$fdat{TransformationCode}."'";
                    $SelectQuery .= " AND FieldSequence = ".$SequenceCounter;
					
					$sthresult = $globalp->{dbh} -> prepare ($SelectQuery) 
                    or die "Cannot prepare query:$SelectQuery";
					$sthresult -> execute  or die "Cannot execute query:$SelectQuery";
					$sthresult -> bind_columns(undef, \$SequenceExists);
					$datresult = $sthresult -> fetchrow_arrayref ;
					$sthresult -> finish();

					if( $SequenceExists > 0 )
					{
						$updaterecord = 1;
						if( defined($fdat{deletecfglines}) )
						{
							if( $fdat{deletecfglines} eq $globalp->{_SAVEANDDELSEQS} )
							{
								if( $fdat{"DelSeq".$SequenceCounter} eq "Yes" )
								{
									&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Deleting line $SequenceCounter.");

									$delete_sequence_data = "DELETE FROM ".$globalp->{table_prefix}."_etl_export_layouts";
									$delete_sequence_data .= " WHERE ETLSchemeCode = '".$fdat{ETLSchemeCode}."'"; 
									$delete_sequence_data .= " AND TransformationCode = '".$fdat{TransformationCode}."'";
									$delete_sequence_data .= " AND FieldSequence = ".$SequenceCounter;

									$globalp->{dbh}->do( $delete_sequence_data );
									$updaterecord = 0;
								}
							}
						}
						
						if( $updaterecord == 1 )
						{							
							$fdat{"FieldDescription".$SequenceCounter}=~ s/'/''/g;
                            $fdat{"FieldNumForValidation1".$SequenceCounter}=~ s/'/''/g;
                            $fdat{"FieldNumForValidation2".$SequenceCounter}=~ s/'/''/g;
							$update_layout_data = "UPDATE ".$globalp->{table_prefix}."_etl_export_layouts ";
							$update_layout_data .= " SET FieldDescription='".$fdat{"FieldDescription".$SequenceCounter}."'";
							$update_layout_data .= ", ValueType='".$fdat{"valuetype".$SequenceCounter}."'";
							$update_layout_data .= ", ExportField='".$fdat{"exportfield".$SequenceCounter}."'";
							$update_layout_data .= ", Catalog=".$fdat{"catalog".$SequenceCounter};
							$update_layout_data .= ", FieldNumForValidation1=".$fdat{"FieldNumForValidation1".$SequenceCounter};
							$update_layout_data .= ", FieldNumForValidation2=".$fdat{"FieldNumForValidation2".$SequenceCounter};
								
							if( $fdat{"valuetype".$SequenceCounter} eq "ConstantValue" )
							{
								$fdat{"ConstantValue".$SequenceCounter} =~ s/'/''/g;
								$update_layout_data .= ", ConstantValue= '".$fdat{"ConstantValue".$SequenceCounter}."'";
							}								
							elsif( $fdat{"valuetype".$SequenceCounter} eq "QueryField" )
							{
								$fdat{"QueryField".$SequenceCounter} =~ s/'/''/g;
								$update_layout_data .= ", QueryField='".$fdat{"QueryField".$SequenceCounter}."'";
							}
							elsif( $fdat{"valuetype".$SequenceCounter} eq "CrossReference" )
							{
								$fdat{"QueryField1ForXRef".$SequenceCounter} =~ s/'/''/g;
								$update_layout_data .= ", QueryField1ForXRef= '".$fdat{"QueryField1ForXRef".$SequenceCounter}."'";
								$fdat{"QueryField2ForXRef".$SequenceCounter} =~ s/'/''/g;
								$update_layout_data .= ", QueryField2ForXRef='".$fdat{"QueryField2ForXRef".$SequenceCounter}."'";
								$update_layout_data .= ", xreftype='".$fdat{"xreftype".$SequenceCounter}."'";
							}						
							elsif( $fdat{"valuetype".$SequenceCounter} eq "TransformationScript" )
							{
								$fdat{"TSParameters".$SequenceCounter} =~ s/'/''/g;
								$update_layout_data .= ", TransformationScriptParameters='".$fdat{"TSParameters".$SequenceCounter}."'";
								$update_layout_data .= ", TransformationScriptID=".$fdat{"tsid".$SequenceCounter};
							}
								
							$update_layout_data .= " WHERE ETLSchemeCode = '".$fdat{ETLSchemeCode}."'";
							$update_layout_data .= " AND TransformationCode='".$fdat{TransformationCode}."'";
                            $update_layout_data .= " AND FieldSequence = ".$SequenceCounter;
													
							$globalp->{dbh}->do( $update_layout_data );
						}
					}
					else 
					{	
                        #It means sequence does not exist, we need to insert the record.
                        
						$fdat{"FieldDescription".$SequenceCounter}=~ s/'/''/g;
						$insert_layout_data = "INSERT INTO ";
                        $insert_layout_data .= $globalp->{table_prefix}."_etl_export_layouts VALUES (";
						$insert_layout_data .= " '".$fdat{ETLSchemeCode}."', '";
                        $insert_layout_data .= $fdat{TransformationCode}."'";
						$insert_layout_data .= ", ".$SequenceCounter;
						$insert_layout_data .= ", '".$fdat{"FieldDescription".$SequenceCounter}."'";
						$insert_layout_data .= ", '".$fdat{"valuetype".$SequenceCounter}."'";
							
						if( $fdat{"valuetype".$SequenceCounter} eq "ConstantValue" )
						{
							$fdat{"ConstantValue".$SequenceCounter} =~ s/'/''/g;
							$insert_layout_data .= ", '".$fdat{"ConstantValue".$SequenceCounter}."'";
							$insert_layout_data .= ", '', '', '', '', 0, ''";
						}								
						elsif( $fdat{"valuetype".$SequenceCounter} eq "QueryField" )
						{
							$fdat{"QueryField".$SequenceCounter} =~ s/'/''/g;
							$insert_layout_data .= ", '','".$fdat{"QueryField".$SequenceCounter}."'";
							$insert_layout_data .= ", '', '', '', 0, ''";
						}
						elsif( $fdat{"valuetype".$SequenceCounter} eq "CrossReference" )
						{
							$fdat{"QueryField1ForXRef".$SequenceCounter} =~ s/'/''/g;
                            $fdat{"QueryField2ForXRef".$SequenceCounter} =~ s/'/''/g;
							$insert_layout_data .= ", '','','".$fdat{"QueryField1ForXRef".$SequenceCounter}."'";
							$insert_layout_data .= ", '".$fdat{"QueryField2ForXRef".$SequenceCounter}."'";
							$insert_layout_data .= ", '".$fdat{"xreftype".$SequenceCounter}."'";
							$insert_layout_data .= ", 0, ''";
						}						
						elsif( $fdat{"valuetype".$SequenceCounter} eq "TransformationScript" )
						{
							$fdat{"TSParameters".$SequenceCounter} =~ s/'/''/g;
							$insert_layout_data .= ", '', '', '', '', ''";
							$insert_layout_data .= ", ".$fdat{"tsid".$SequenceCounter};
							$insert_layout_data .= ", '".$fdat{"TSParameters".$SequenceCounter}."'";							
						}
						else
						{
							$insert_layout_data .= ",'','', '', '', '', 0, ''";
						}
						$insert_layout_data .= ", '".$fdat{"exportfield".$SequenceCounter}."'";
						$insert_layout_data .= ", ".$fdat{"catalog".$SequenceCounter};
						$insert_layout_data .= ", ".$fdat{"FieldNumForValidation1".$SequenceCounter};
						$insert_layout_data .= ", ".$fdat{"FieldNumForValidation2".$SequenceCounter};
						$insert_layout_data .= " )";
								#~ echo($insert_layout_data); exit;
						$globalp->{dbh}->do( $insert_layout_data );
					}
				}					
			}
		}
		
		
		####Renumbering layout sequences.
		if( defined(deletecfglines) ) 
		{
			if( $fdat{deletecfglines} eq $globalp->{_SAVEANDDELSEQS} )
			{
				&Renumber_Layout_Seqs();
			}
		}

		####Adding new layout sequence.
		if( defined($fdat{insertseq}) && defined($fdat{BeforeSequence}) )
		{
			$fdat{BeforeSequence} = $globalp->{All_Trim}($fdat{BeforeSequence});
			if( $fdat{BeforeSequence} ne "" 
            && $fdat{insertseq} eq "Insert One Field Before Sequence" )
			{
				&Insert_Layout_Seq();
			}
		}

		&EditLayout;
	}
	



	sub Insert_Layout_Seq
	{
		$LayoutQuery = "SELECT FieldSequence,FieldNumForValidation1";
        $LayoutQuery .= " FROM ".$globalp->{table_prefix}."_etl_export_layouts";
		$LayoutQuery .= " WHERE ETLSchemeCode = '".$fdat{ETLSchemeCode}."'";
		$LayoutQuery .= " AND TransformationCode = '".$fdat{TransformationCode}."'";
		$LayoutQuery .= " AND FieldSequence >= " . $fdat{BeforeSequence};
		$LayoutQuery .= " ORDER BY FieldSequence desc";
		
		$sthresult = $globalp->{dbh} -> prepare ( $LayoutQuery )
        or die "Cannot prepare query: $LayoutQuery";
		$sthresult -> execute  or die "Cannot execute query: $LayoutQuery";
		$sthresult -> bind_columns(undef, \$FieldSequence, \$FieldNumForValidation1);
		
		$NewFieldSequence = 0;
		while( $datresult = $sthresult -> fetchrow_arrayref )
		{
			$NewFieldSequence = $FieldSequence + 1;
			$update_layout_data = "UPDATE ".$globalp->{table_prefix}."_etl_export_layouts";
			$update_layout_data .= " SET FieldSequence=" . $NewFieldSequence;
			if( $FieldNumForValidation1 ==  $FieldSequence )
			{
				$update_layout_data .= ", FieldNumForValidation1 = " . $NewFieldSequence;
			}			
			$update_layout_data .= " WHERE ETLSchemeCode = '".$fdat{ETLSchemeCode}."'";
			$update_layout_data .= " AND TransformationCode='".$fdat{TransformationCode}."'";
            $update_layout_data .= " AND FieldSequence = ".$FieldSequence;
			$globalp->{dbh}->do( $update_layout_data );
		}
		$sthresult -> finish();
		
		$insert_layout_data = "INSERT INTO ";
        $insert_layout_data .= $globalp->{table_prefix}."_etl_export_layouts VALUES (";
		$insert_layout_data .= " '".$fdat{ETLSchemeCode}."', '".$fdat{TransformationCode}."'";
		$insert_layout_data .= ", " . $fdat{BeforeSequence} . ",'New Field', '','','', '', ''";
		$insert_layout_data .= ", '', 0, '', 'No', '', ". $fdat{BeforeSequence} . ", 0 )"; 
		$globalp->{dbh}->do( $insert_layout_data );
	}





	sub Renumber_Layout_Seqs
	{
		$LayoutQuery = "SELECT FieldSequence, FieldNumForValidation1";
        $LayoutQuery .= " FROM ".$globalp->{table_prefix}."_etl_export_layouts";
		$LayoutQuery .= " WHERE ETLSchemeCode = '".$fdat{ETLSchemeCode}."'";
		$LayoutQuery .= " AND TransformationCode = '".$fdat{TransformationCode}."'";
		$LayoutQuery .= " ORDER BY FieldSequence";
		
		$sthresult = $globalp->{dbh} -> prepare ( $LayoutQuery ) 
        or die "Cannot prepare query:$LayoutQuery";
		$sthresult -> execute  or die "Cannot execute query:$LayoutQuery";
		$sthresult -> bind_columns(undef, \$FieldSequence, \$FieldNumForValidation1);
		
		$NewFieldSequence = 0;
		while( $datresult = $sthresult -> fetchrow_arrayref )
		{
			$NewFieldSequence +=1;
			$update_layout_data = "UPDATE ".$globalp->{table_prefix}."_etl_export_layouts";
			$update_layout_data .= " SET FieldSequence=" . $NewFieldSequence;
			if( $FieldNumForValidation1 ==  $FieldSequence )
			{
				$update_layout_data .= ", FieldNumForValidation1 = " . $NewFieldSequence;
			}
			$update_layout_data .= " WHERE ETLSchemeCode = '".$fdat{ETLSchemeCode}."'";
			$update_layout_data .= " AND TransformationCode='".$fdat{TransformationCode}."'";
            $update_layout_data .= " AND FieldSequence = ".$FieldSequence;
			$globalp->{dbh}->do( $update_layout_data );
		}
		$sthresult -> finish();				
	}
	
	
    
    
	
	sub ExportLayout
	{        
        $SelectQuery = "SELECT a.ETLSchemeID, a.ETLSchemeCode, b.TransformationCode, b.Description";
        $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_schemes a";
        $SelectQuery .= " , ".$globalp->{table_prefix}."_etl_transformation_definitions b";
        $SelectQuery .= " WHERE a.ETLSchemeID=b.ETLSchemeID";
        $SelectQuery .= " AND b.TransformationID = ".$fdat{TransformationID};
        #~ echo($SelectQuery); exit;
		$sthresult = $globalp->{dbh} -> prepare ($SelectQuery) 
        or die "Cannot prepare query:$SelectQuery";
		$sthresult -> execute  or die "Cannot execute query:$SelectQuery";
		$sthresult -> bind_columns(undef, \$ETLSchemeID, \$ETLSchemeCode, \$TransformationCode, \$Description);
		$datresult = $sthresult -> fetchrow_arrayref ;
		$sthresult -> finish();			
		
		$QueryCFGData = "SELECT FieldSequence, FieldDescription, ValueType,";
		$QueryCFGData .= " ConstantValue, QueryField, QueryField1ForXRef, QueryField2ForXRef,";
		$QueryCFGData .= " xreftype, TransformationScriptID, TransformationScriptParameters,";
		$QueryCFGData .= " ExportField, Catalog, FieldNumForValidation1,FieldNumForValidation2";
		$QueryCFGData .= " FROM ".$globalp->{table_prefix}."_etl_export_layouts";
		$QueryCFGData .= " WHERE ETLSchemeCode = '".$ETLSchemeCode."'";
		$QueryCFGData .= " AND TransformationCode='".$TransformationCode."'";
		$QueryCFGData .= " ORDER BY FieldSequence";

		$sthresult = $globalp->{dbh} -> prepare ( $QueryCFGData ) 
        or die echo("Cannot prepare query:$QueryCFGData");
		$sthresult -> execute or die echo("Cannot execute query:$QueryCFGData");
		$sthresult -> bind_columns(undef, \$FieldSequence, \$FieldDescription, \$ValueType, \$ConstantValue, \$QueryField, \$QueryField1ForXRef, \$QueryField2ForXRef, \$xreftype, \$TransformationScriptID, \$TransformationScriptParameters, \$ExportField, \$Catalog, \$FieldNumForValidation1, \$FieldNumForValidation2);

		$count = 0;
		$header = 0;
		$DataFound = 0;
		while( $datresult = $sthresult -> fetchrow_arrayref ) 
		{
			$DataFound = 1;
			if( $header == 0 )
			{
				$header = 1;
				print "Pragma:no-cache\n";
				print "Expires:0\n";
				print "Content-Disposition: attachment;";
                print " filename=\"Layout_Setup_".$ETLSchemeCode."_".$TransformationCode."_".$Description.".txt\"\n";
				print "Content-Type: application/octetstream\n\n";				
				print "ETLSchemeID\|ETLSchemeCode\|TransformationCode\|FieldSequence\|";
                print "FieldDescription\|ValueType\|ConstantValue\|QueryField\|";
				print "QueryField1ForXRef\|QueryField2ForXRef\|xreftype\|";
				print "TransformationScriptID\|TransformationScriptParameters\|ExportField\|Catalog\|";
				print "FieldNumForValidation1\|FieldNumForValidation2\n";
			}	

			print $ETLSchemeID.'|'.$ETLSchemeCode.'|'.$TransformationCode.'|';
            print $FieldSequence.'|'.$FieldDescription.'|'.$ValueType.'|';
			print $ConstantValue.'|'.$QueryField.'|'.$QueryField1ForXRef.'|';
            print $QueryField2ForXRef.'|'.$xreftype.'|'.$TransformationScriptID.'|';
			print $TransformationScriptParameters.'|'.$ExportField.'|'.$Catalog.'|';
			print $FieldNumForValidation1.'|'.$FieldNumForValidation2;
			print "\n";
		}
		$sthresult -> finish();
		
		if( $DataFound == 0 )
		{
			$globalp->{siteheader}();
			$globalp->{theheader}();
			@the_cvalues = $globalp->{get_the_cookie}();		
			$globalp->{OpenTable}();
			echo("There is no layout data setup to be exported"
					." for ETL scheme $ETLSchemeCode "
					."and layout: $TransformationCode - $Description.<br><br>$globalp->{_GOBACK}<br>");
			$globalp->{CloseTable}();
			$globalp->{loggedon_as}();
			$globalp->{sitefooter}();			
		}
		$globalp{clean_exit};
		exit;
	}
	
    
    
	

	sub DeleteLayout
	{
		if( $fdat{deletecfg} eq "1" )
		{
			$fdat{runnumber} = 0;
			&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Delete layout.");

			$delete_cfg_data = "DELETE FROM ".$globalp->{table_prefix}."_etl_export_layouts";
			$delete_cfg_data .= " WHERE ETLSchemeCode = '".$fdat{ETLSchemeCode}."'";
			$delete_cfg_data .= " AND TransformationCode='".$fdat{TransformationCode}."'";

			$globalp->{dbh}->do( $delete_cfg_data );
			
			delete $fdat{xreftodelete};
			$globalp->{siteheader}();
			$globalp->{theheader}();
			@the_cvalues = $globalp->{get_the_cookie}();		
			&MaintainLayoutsMainMenu;
			$globalp->{CloseTable}();
			$globalp->{loggedon_as}();
			$globalp->{sitefooter}();
			$globalp->{clean_exit}();
		}
		else
		{
			$globalp->{siteheader}();
			$globalp->{theheader}();

			@the_cvalues = $globalp->{get_the_cookie}();		
			
            $SelectQuery = "SELECT a.ETLSchemeID, a.ETLSchemeCode, b.TransformationCode, b.Description";
            $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_schemes a";
            $SelectQuery .= " , ".$globalp->{table_prefix}."_etl_transformation_definitions b";
            $SelectQuery .= " WHERE a.ETLSchemeID=b.ETLSchemeID";
            $SelectQuery .= " AND b.TransformationID = ".$fdat{TransformationID};
                        
			$sthresult = $globalp->{dbh} -> prepare ($SelectQuery)
            or die "Cannot prepare query:$SelectQuery";
			$sthresult -> execute  or die "Cannot execute query:$SelectQuery";
			$sthresult -> bind_columns(undef, \$ETLSchemeID, \$ETLSchemeCode, \$TransformationCode, \$Description);
			$datresult = $sthresult -> fetchrow_arrayref ;
			$sthresult -> finish();			
			
			echo("$globalp->{_MFDELCFG} <b>$ETLSchemeCode - $TransformationCode - $Description?.</b> " 
            ."<br>This only will delete the layout, not the transformation defined in EplSite ETL control panel."
            ."<br><br><a href=\"index.prc?\module=EplSiteETL&amp;option=setupxportlayouts&amp;deletecfg=1"
            ."&amp;ETLSchemeCode=$ETLSchemeCode"
            ."&amp;ETLSchemeID=$ETLSchemeID"
            ."&amp;TransformationID=$fdat{TransformationID}"
            ."&amp;TransformationCode=$TransformationCode\">Yes</a>"
            ."&nbsp;&nbsp;$globalp->{_GOBACK}");			

			$globalp->{CloseTable}();
			$globalp->{loggedon_as}();
			$globalp->{sitefooter}();
			$globalp->{clean_exit}();
		}
	}





	sub ImportLayoutFromFile
	{
		our $thedocument = "";

		my $LineFeed = chr(10);
		my $CarriageReturn = chr(13);
        
        $thedocument = $globalp->{get_file_uploaded}($globalp->{Temp_Docs_Path});
        		
		open ("datafile", $thedocument);
				@filedata=<datafile>;
		close ("datafile");	
		
		$file_deleted = $globalp->{DeleteMyFile}($thedocument);
		
		$header = 0;
		$line = 0;
		
		foreach my $LayoutLine (@filedata)
		{	
            $LayoutLine =~ s/$LineFeed//g;
            $LayoutLine =~ s/$CarriageReturn//g; 
            
			$line +=1;
			
			if( $fdat{delimiterchar} eq "" ||  $fdat{delimiterchar} eq "\|")
			{
				@mydata = split('\|',$LayoutLine);			
			}
			else
			{
				@mydata = split($fdat{delimiterchar},$LayoutLine);
			}
			
			foreach(@mydata)
			{
				$LayoutLine=~ s/'/''/;				
			}
			
			if( $header == 0 && $line > 1 )
			{
				$header = 1;
				$error = "";

				$RecordsInCFG = 0;
                $SelectQuery = "SELECT count(*)";
                $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_transformation_definitions";
                $SelectQuery .= " WHERE ETLSchemeID = '".$mydata[0]."'";
				$sthresult = $globalp->{dbh} -> prepare ($SelectQuery)                
                or die "Cannot prepare query:$SelectQuery";
				$sthresult -> execute  or die "Cannot execute query:$SelectQuery";
				$sthresult -> bind_columns(undef, \$RecordsInCFG);
				$datresult = $sthresult -> fetchrow_arrayref ;
				$sthresult -> finish();
				
				if( $RecordsInCFG == 0 )
				{	
					$error .= "ETL Scheme<b> $mydata[1] </b>Does Not Exists.<br>";
					$error .= "You Must Create It First In Control Panel Before Importing Layout.<br>";
				}


				if( $error eq "" )
				{
                    $RecordsInCFG = 0;
                    $SelectQuery = "SELECT count(*)";
                    $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_transformation_definitions";
                    $SelectQuery .= " WHERE ETLSchemeID = '".$mydata[0]."'";
                    $SelectQuery .= " AND TransformationCode = '".$mydata[2]."'";
                    $sthresult = $globalp->{dbh} -> prepare ($SelectQuery)                
                    or die "Cannot prepare query:$SelectQuery";
                    $sthresult -> execute  or die "Cannot execute query:$SelectQuery";
                    $sthresult -> bind_columns(undef, \$RecordsInCFG);
                    $datresult = $sthresult -> fetchrow_arrayref ;
                    $sthresult -> finish();
                    
                    if( $RecordsInCFG == 0 )
                    {	
                        $error .= "Transformation Code<b> $mydata[2] </b>Does Not Exists";
                        $error .= " For ETL Scheme<b> $mydata[1] </b>.<br>";
                        $error .= "You Must Create It First In Control Panel Before Importing Layout.<br>";
                    }
                }
                
				if( $error eq "" )
				{
					$fdat{runnumber} = 0;
					&ETLWriteTransformationLog($mydata[1],$mydata[2],"Importing layout, this process deletes before import.");
					
					$delete_cfg_data = "DELETE FROM ".$globalp->{table_prefix}."_etl_export_layouts";
					$delete_cfg_data .= " WHERE ETLSchemeCode = '".$mydata[1]."'";
					$delete_cfg_data .= " AND TransformationCode='".$mydata[2]."'";				
					$globalp->{dbh}->do( $delete_cfg_data );					
				}
				else
				{
					$globalp->{siteheader}(); $globalp->{theheader}();

					echo("$error <br><br>".$globalp->{_GOBACK}."");
					delete $fdat{option};
					$globalp->{sitefooter}();
					$globalp->{clean_exit}();
				}			
			}
			
			$mydata[0] =~ s/^\s+//; #remove leading spaces
			$mydata[0] =~ s/\s+$//; #remove trailing spaces
			if( $mydata[0] ne "" && $line > 1 )
			{
				$insert_cfg_data = "INSERT INTO ";
                $insert_cfg_data .= $globalp->{table_prefix}."_etl_export_layouts VALUES ( ";
				$insert_cfg_data .= "'$mydata[1]','$mydata[2]','$mydata[3]','$mydata[4]'";
				$insert_cfg_data .= ",'$mydata[5]','$mydata[6]'";
				$insert_cfg_data .= ",'$mydata[7]','$mydata[8]'";
				$insert_cfg_data .= ",'$mydata[9]','$mydata[10]'";
				$insert_cfg_data .= ",'$mydata[11]','$mydata[12]'";
				$insert_cfg_data .= ",'$mydata[13]','$mydata[14]'";
				$insert_cfg_data .= ",'$mydata[15]','$mydata[16]'";
				$insert_cfg_data .= ")";
				
				$globalp->{dbh}->do( $insert_cfg_data );
				#echo($insert_xref_data."<br>");				
			}
		}
        $globalp->{cleanup}(); 
		&redirect_url_to("index.prc?module=EplSiteETL&amp;option=setupxportlayouts&amp;ETLSchemeID=$mydata[0]");
	}






	sub MaintainLayoutsMainMenu
	{	
        $SelectQuery = "SELECT a.ETLSchemeCode, a.ETLSchemeDescription";
        $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_schemes a";
        $SelectQuery .= " WHERE a.ETLSchemeID=".$fdat{ETLSchemeID};
        
		$sthresult = $globalp->{dbh}-> prepare ($SelectQuery)
        or die "Cannot prepare query:$SelectQuery";
		$sthresult -> execute or die "Cannot execute query:$SelectQuery";
		$sthresult -> bind_columns(undef, \$ETLSchemeCode,\$ETLSchemeDescription);
		$datresult = $sthresult -> fetchrow_arrayref();
		$sthresult -> finish();
        
		echo("<table align=\"left\"><tr><th><big>Layouts Setup For Scheme:"
            .$ETLSchemeDescription."</big></th>");			
                
		echo("<td><form name=\"ImportLayout\" action=\"index.prc\""
            ." method=\"post\" ENCTYPE=\"multipart/form-data\">\n"
			."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
			."<input type=\"hidden\" name=\"option\" value=\"setupxportlayouts\">\n"
			."<input type=\"hidden\" name=\"ETLSchemeID\" value=\"$fdat{ETLSchemeID}\">\n"
            ." &nbsp;&nbsp;<strong><big>&middot;</big></strong> "
			.$globalp->{_MFDELIMITERCHAR}."&nbsp;<input type=\"name\" name=\"delimiterchar\" size=\"1\">\n"
			."<INPUT TYPE=\"FILE\" NAME=\"attachthis\" value=\"\" size=\"50\"> &nbsp; \n"
			."<input type=\"submit\" name=\"fileimport\" value=\""
            .$globalp->{_MFIMPORTCFG}."\"></form></td></tr></table>\n");


		echo("<br><br><table align=\"left\"><tr><td> &nbsp;&nbsp;<strong><big>&middot;</big></strong> "
            ."<a href=\"index.prc?\module=EplSiteETL&option=setupxportlayouts&amp;MaintainDTS=1&amp;"
			."DTSID=\" target=\"_blank\">Maintain Data Transformation Scripts ( DTS )</a>"					
			."</td>");

		echo("<td><form action=\"index.prc\" method=\"post\">\n"
				 ."<input type=\"hidden\" name=\"module\" value=\"EplSiteETL\">\n"
				 ."<input type=\"hidden\" name=\"option\" value=\"setupxportlayouts\">\n"
				 ."<input type=\"hidden\" name=\"ETLSchemeID\" value=\"$fdat{ETLSchemeID}\">\n"
				 ." &nbsp;&nbsp;<strong><big>&middot;</big></strong> ".$globalp->{_MFVIEWS}.":\n"
				 ." <select name=\"TransformationID\"><option value=\"\">$globalp->{_MFCFGTODELETE}</option>\n");

        $SelectQuery = "SELECT TransformationID,TransformationCode,Description";
        $SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_transformation_definitions";
        $SelectQuery .= " WHERE ETLSchemeID = ".$fdat{ETLSchemeID};
        $SelectQuery .= " ORDER BY TransformationCode";
        
		$sthresult = $globalp->{dbh} -> prepare ($SelectQuery) 
        or die "Cannot prepare query:$SelectQuery";
		$sthresult -> execute  or die "Cannot execute query:$SelectQuery";
		$sthresult -> bind_columns(undef, \$TransformationID, \$SelTransformationCode,\$SelDescription);

		while( $datresult = $sthresult -> fetchrow_arrayref ) {
			echo("<option value=\"$TransformationID\">$SelTransformationCode - $SelDescription</option>\n");
		}
		$sthresult -> finish();

		echo("</select>\n"			
			."<input type=\"submit\" name=\"maintaincfg\" VALUE=\"".$globalp->{_MFMAINTAINCFG}."\">\n"
			."<input type=\"submit\" name=\"maintaincfg\" VALUE=\"".$globalp->{_MFEXPORTFILE}."\">\n"
			."<input type=\"submit\" name=\"deletecfg\" VALUE=\"".$globalp->{_DELETEVIEWSETUP}."\">&nbsp;&nbsp;\n"			
			."</form></td></tr></table>\n");
	}





    if( $fdat{fileimport} eq  $globalp->{_MFIMPORTCFG} )
	{ 
		&ImportLayoutFromFile;		
	}
    elsif( $fdat{TransformationID} ne "" and $fdat{deletecfg} eq $globalp->{_DELETEVIEWSETUP} ){ &DeleteLayout; }
	elsif( $fdat{TransformationID} ne "" and $fdat{deletecfg} eq "1" ){ &DeleteLayout; }
	elsif( $fdat{TransformationID} ne "" and $fdat{maintaincfg} eq $globalp->{_MFMAINTAINCFG} ){ &EditLayout; }
	elsif( $fdat{TransformationID} ne "" and $fdat{maintaincfg} eq $globalp->{_MFEXPORTFILE} ){ &ExportLayout; }
	elsif( $fdat{TransformationID} ne "" and $fdat{maintaincfg} eq "UpdateValueAssigned" ){ &UpdateValueInLayout; }
	elsif( $fdat{maintaincfg} eq "Add"){ &AddLinesToLayout; }
	elsif( $fdat{maintaincfg} eq "Save"){ &SaveLayout; }	
	elsif( $fdat{MaintainDTS} == 1 )
	{ 
		my $DTSEditor = $ENV{THE_CALLED_DOCUMENT_PATH} . 'modules/EplSiteETL/DTSEditor.prc';
		Execute ($DTSEditor);
	}
	else 
	{ 
		$globalp->{siteheader}();
		$globalp->{theheader}();
		@the_cvalues = $globalp->{get_the_cookie}();		
		&MaintainLayoutsMainMenu; 
		$globalp->{CloseTable}();
		$globalp->{loggedon_as}();
		$globalp->{sitefooter}();				
	}


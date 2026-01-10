if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing = 0; }
else{ echo("Access denied"); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }

$sthadmauth = $globalp->{dbh} -> prepare ("select radminworkflow, radminsuper from ".$globalp->{table_prefix}."_authors where aid='$globalp->{aid}'") 
or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
$sthadmauth -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
$sthadmauth -> bind_columns(undef, \$radminworkflow,\$radminsuper);
$datadmauth = $sthadmauth -> fetchrow_arrayref;
$sthadmauth->finish();

if( $radminsuper != 1 ) { echo("Access denied!!!!"); $globalp->{clean_exit}(); }

use Digest::MD5 qw(md5_hex);

#*********************************************************
#* EplSiteETL Manager Functions
#*********************************************************

sub EplSiteETLManager() {

  $globalp->{siteheader}(); 
  $globalp->{LoadPerlCodeEditorLibs}();
	echo("<style>.CodeMirror {height: 620px;}</style>");
	$globalp->{theheader}();
	&JavaScriptsForMenus();
  $globalp->{GraphicAdmin}();
	echo("<br></div>");

  $globalp->{OpenTable}();
  echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font> - Click the links below to hide/unhide sections.<br>"
    ."<a href=\"javascript:HandleMenuSections('EplSiteETLLogs','');\">Logs Admin</a>"
    ."&nbsp;<a href=\"javascript:HandleMenuSections('EplSiteETLUsers','');\">ETL Users</a>"
    ."&nbsp;<a href=\"javascript:HandleMenuSections('EplSiteETLDBConn','dseditor');\">Database Connections</a>"
    ."&nbsp;<a href=\"javascript:HandleMenuSections('EplSiteETLSchemes','asmeditor');\">ETL Schemes</a>"
    ."&nbsp;<a href=\"javascript:HandleMenuSections('EplSiteETLScripts','');\">Independent Scripts</a>"
    ."&nbsp;<a href=\"javascript:HandleMenuSections('EplSiteETLCatalogs','');\">Catalog Tables</a>"
    ."&nbsp;<a href=\"javascript:HandleMenuSections('EplSiteETLTDefinitions','');\">Transformation Definition.</a></center>"
  );
  $globalp->{CloseTable}();
	
	echo("<div id=\"EplSiteETLLogs\" class=\"hidden\">");
  echo("<br>");

  $globalp->{OpenTable}();	
  echo("<b><center><big>EplSite ETL Delete Transformation And Layout Maintenance Logs</big></center></b><br>");
	echo('<table border="1" align="center"><tr align="center">');
  echo("<td><table border=\"0\" ><form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"ETL_delete_logs\">\n"
    ."<tr><td>DateTime(YYYYMMDDHHMISS) From:</td><td> <input type=\"text\" name=\"datetimefrom\" size=\"14\" maxlength=\"14\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr><td>DateTime(YYYYMMDDHHMISS) To:</td><td> <input type=\"text\" name=\"datetimeto\" size=\"14\" maxlength=\"14\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr><td>* HH in 24 Hours Format.</td><td>&nbsp;</td></tr>\n"
    ."<tr><td><input name=\"submit\" value= \"Delete\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n</td>"
  );

  echo("<td><table border=\"0\" ><form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"ETL_delete_logsByRunNumber\">\n"
    ."<tr><td>Run Number From:</td><td> <input type=\"text\" name=\"runnumberfrom\" size=\"9\" maxlength=\"14\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr><td>Run Number To:</td><td> <input type=\"text\" name=\"runnumberto\" size=\"9\" maxlength=\"14\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr><td><input name=\"submit\" value= \"Delete\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n</td>"
  );
	echo("</tr></table>");			 
  $globalp->{CloseTable}();

  echo("<br>");
  $globalp->{OpenTable}();
  echo("<b><center><big>EplSite ETL Delete XRef Error Logs</big></center></b><br>");
	echo('<table border="1" align="center"><tr align="center">');
  echo("<td><table border=\"0\" ><form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"ETL_delete_xreflogs\">\n"
    ."<tr><td>DateTime(YYYYMMDDHHMISS) From:</td><td> <input type=\"text\" name=\"datetimefrom\" size=\"14\" maxlength=\"14\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr><td>DateTime(YYYYMMDDHHMISS) To:</td><td> <input type=\"text\" name=\"datetimeto\" size=\"14\" maxlength=\"14\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr><td>* HH in 24 Hours Format.</td><td>&nbsp;</td></tr>\n"
    ."<tr><td><input name=\"submit\" value= \"Delete\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n</td>"
  );

  echo("<td><table border=\"0\" ><form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"ETL_delete_xreflogsByRunNumber\">\n"
    ."<tr><td>Run Number From:</td><td> <input type=\"text\" name=\"runnumberfrom\" size=\"9\" maxlength=\"14\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr><td>Run Number To:</td><td> <input type=\"text\" name=\"runnumberto\" size=\"9\" maxlength=\"14\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr><td><input name=\"submit\" value= \"Delete\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n</td>"
  );
	echo("</tr></table>");			 
  $globalp->{CloseTable}();

  echo("<br>");
  $globalp->{OpenTable}();
  echo("<b><center><big>EplSite ETL Delete Catalog Error Logs</big></center></b><br>");
	echo('<table border="1" align="center"><tr align="center">');
  echo("<td><table border=\"0\" ><form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"ETL_delete_catlogs\">\n"
    ."<tr><td>DateTime(YYYYMMDDHHMISS) From:</td><td> <input type=\"text\" name=\"datetimefrom\" size=\"14\" maxlength=\"14\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr><td>DateTime(YYYYMMDDHHMISS) To:</td><td> <input type=\"text\" name=\"datetimeto\" size=\"14\" maxlength=\"14\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr><td>* HH in 24 Hours Format.</td><td>&nbsp;</td></tr>\n"
    ."<tr><td><input name=\"submit\" value= \"Delete\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n</td>"
  );

  echo("<td><table border=\"0\" ><form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"ETL_delete_catlogsByRunNumber\">\n"
    ."<tr><td>Run Number From:</td><td> <input type=\"text\" name=\"runnumberfrom\" size=\"9\" maxlength=\"14\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr><td>Run Number To:</td><td> <input type=\"text\" name=\"runnumberto\" size=\"9\" maxlength=\"14\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr><td><input name=\"submit\" value= \"Delete\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n</td>"
  );
	echo("</tr></table>");			 
  $globalp->{CloseTable}();

	echo("</div><div id=\"EplSiteETLUsers\" class=\"hidden\">");
  echo("<br>");

  $globalp->{OpenTable}();
  echo("<b><center><big>EplSite ETL Users Maintenance</big></center></b><br><table border=\"0\">");
  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"resour_save\">\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFRESNAME}.":</td><td> <input type=\"text\" name=\"rname\" size=\"50\" maxlength=\"100\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFRESEXT}.":</td><td> <input type=\"text\" name=\"rext\" size=\"25\" maxlength=\"50\"></td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFRESMAIL}.":</td><td> <input type=\"text\" name=\"rmail\" size=\"50\" maxlength=\"100\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFRESLOGIN}.":</td><td> <input type=\"text\" name=\"rlogin\" size=\"20\" maxlength=\"20\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFREPSW}.":</td><td> <input type=\"password\" name=\"rpsw\" size=\"20\" maxlength=\"50\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_RETYPEPASSWD}.":</td><td> <input type=\"password\" name=\"rtpsw\" size=\"20\" maxlength=\"50\"> <font color=\"red\">*</font></td></tr>\n"
    ."<tr align=\"left\"><td><input name=\"submit\" value= \"".$globalp->{_ADDUSERBUT}."\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n"
  );

  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<table border=\"0\"><tr align=\"left\"><td>\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."".$globalp->{_WFRESID}.": <input type=\"text\" name=\"ID\" size=\"5\" maxlength=\"10\">\n"
    ." <input name=\"option\" value= \"".$globalp->{_EDITUSER}."\" type=\"submit\"> \n"
    ." <input name=\"option\" value= \"".$globalp->{_DELETEUSER}."\" type=\"submit\">\n"
    ."</form></td></tr></table>\n "
  );

  echo("<p align=\"left\"><a href=\"#\" onClick=\"window.open('admin.prc?session="
  	."$globalp->{session}&amp;option=show_etl_users','Persons','width=500,height=400"
	  .", scrollbars=yes, fullscreen=-1');return;\" >".$globalp->{_SHOWUSERS}."</a></p>\n"
  );

  $globalp->{CloseTable}();
	
	echo("</div><div id=\"EplSiteETLDBConn\" class=\"hidden\">");
  echo("<br>");

  $globalp->{OpenTable}();
  echo("<b><center><big>" . $globalp->{_DATASOURCESM} . "</big></center></b><br><table width=\"100%\" border=\"0\">");
  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"DBConnection_save\">\n"
    ."<input type=\"hidden\" name=\"DataSourceID\" value=\"\">\n"
    ."<tr align=\"left\"><td>" . $globalp->{_CONNECTIONNAME} . "</td><td align=\"left\"> <input type=\"text\""
    ." name=\"DataSourceName\" size=\"50\" maxlength=\"100\">*Must be the same than the script sub</td></tr>\n"
    ."</table><table width=\"100%\" border=\"0\"><tr align=\"left\">"
    ."<td><b>" . $globalp->{_CONNECTIONSCRIPT} . "<br></b>"
    ."<textarea id=\"DataSourceScript\" name=\"DataSourceScript\">sub <Connection Name>\n"
    ."{\n    my \$DSNUserName = \"\";\n"
    ."    my \$DSNPassword = \"\";\n\n"
    ."    #Oracle Sample\n"
    ."    #my \$DSNDBData = \"DBI:Oracle:host=11.11.22.33;sid=MYDBSID;port=1521\";\n"
    ."    #local \$SIG{ALRM} = sub { die \"Connection timeout.\" }; # NB: timeout required for all connections\n"
    ."    #alarm 9;# timeout required for all connections\n"
    ."    #my \$DSNConnection = DBI->connect(\$DSNDBData,\$DSNUserName,\$DSNPassword);\n"
    ."    #alarm 0;# timeout required for all connections\n\n"
    ."    #MySQL Sample with cached connection.\n"			 
    ."    #my \$DSNDBData = \"DBI:mysql:database=eplsite;host=localhost:3306\";\n"
    ."    #local \$SIG{ALRM} = sub { die \"Connection timeout.\" }; # NB: timeout required for all connections\n"
    ."    #alarm 3;# timeout required for all connections\n"
    ."    #my \$DSNConnection = DBI->connect(\$DSNDBData,\$DSNUserName,\$DSNPassword);\n"
    ."    #alarm 0;# timeout required for all connections\n\n"
    ."    \$DSNConnection->{'LongReadLen'} = 60000;\n\n"
    ."    return(\$DSNConnection);\n}</textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var dseditor = CodeMirror.fromTextArea(document.getElementById("DataSourceScript"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		dseditor.on("blur", function(){ ' . "\n");
	echo('           dseditor.save();' . "\n");
	echo('      });' . "\n");
  echo('    </script>' . "\n");                
        
  echo("</td></tr></table><table width=\"100%\" border=\"0\">\n"			 
  	."<tr align=\"left\"><td><input name=\"submit\" value=\"".$globalp->{_ADDCONNECTION}."\" type=\"submit\">"
	  ."</td><td><td>&nbsp;</td></tr></table>\n"
	  ."</form><br>\n"
  );

  echo("<form action=\"admin.prc\" method=\"POST\"><table width=\"100%\" border=\"0\">\n"
    ."<tr align=\"left\"><td>"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<select name=\"DataSourceID\">"
    ."<option selected value=\"\">Select Data Connection To Edit/Delete/Test</option>\n"
  );
			 
	$selectquery = "SELECT DataSourceID, DataSourceName FROM ".$globalp->{table_prefix}."_etl_data_sources ORDER BY DataSourceName";
	
  $resulti = $globalp->{dbh} -> prepare ($selectquery)  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_data_sources: $selectquery";
	$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_etl_data_sources";
	$resulti -> bind_columns(undef, \$DataSourceID, \$DataSourceName);

	while( $datresulti = $resulti -> fetchrow_arrayref ) { echo("<option value=\"$DataSourceID\">$DataSourceID - $DataSourceName</option>\n"); }
	$resulti->finish();

	echo("</select>\n"
    ." <input name=\"option\" value= \"Edit DB Connection\" type=\"submit\">\n"
    ." <input name=\"option\" value= \"Delete DB Connection\" type=\"submit\">\n"
    ." Enter Table Name To Test DB Connection: <input type=\"text\" name=\"TableName\" size=\"30\" maxlength=\"100\">\n"			 
    ." <input name=\"option\" value= \"Test DB Connection\" type=\"submit\" target=\"_blank\">\n"
    ."</form></td></tr></table>\n "
  );

  $globalp->{CloseTable}();
	echo("</div><div id=\"EplSiteETLSchemes\" class=\"hidden\">");

  echo("<br>");
  $globalp->{OpenTable}();
	
  echo("<b><center><big>ETL Schemes Maintenance</big></center></b><br>\n"
    ."An ETL scheme contains a menu of all the transformations created.<br>\n"
    ."Here you can add fields to the scheme menu.\n"
    ."<table width=\"100%\" border=\"0\" >"
  );
	
  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"ETLS_save\">\n"
    ."<input type=\"hidden\" name=\"ETLSchemeID\" value=\"\">\n"
    ."<tr align=\"left\"><td>ETL Scheme Code:</td><td> <input type=\"text\" name=\"ETLSchemeCode\" size=\"25\" maxlength=\"100\"></td></tr>\n"			 
    ."<tr align=\"left\"><td>ETL Scheme Description:</td><td> <input type=\"text\" name=\"ETLSchemeDescription\" size=\"50\" maxlength=\"100\"></td></tr>\n"
    ."<tr align=\"left\"><td>Data Base Connection For Catalogs:</td>"
    ."<td><select name=\"CatalogsDataSourceID\">"
    ."<option selected value=\"\">".$globalp->{_CATATLOGDATASRC}."</option>\n"
  );
			 
	$selectquery = "SELECT DataSourceID, DataSourceName FROM ".$globalp->{table_prefix}."_etl_data_sources ORDER BY DataSourceName";
	
  $resulti = $globalp->{dbh}-> prepare ($selectquery)  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_schemes: $selectquery";
	$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_etl_schemes";
	$resulti -> bind_columns(undef, \$DataSourceID, \$DataSourceName);

	while( $datresulti = $resulti -> fetchrow_arrayref ) { echo("<option value=\"$DataSourceID\">$DataSourceName</option>\n"); }
	$resulti->finish();

	echo("</select></td></tr>\n"
    ."</table><table width=\"100%\" border=\"0\"><tr align=\"left\">"
    ."<td><b>Script For Additional Menu Options:<br></b>"
    ."<textarea id=\"AdditionalScriptMenu\" name=\"AdditionalScriptMenu\">\n"
    ."echo('<table border=\"1\">');\n"
    ."echo('<tr><td> <strong><big>�</big></strong> <b>Sample Field:</b>'\n"
    .".'<input type=\"text\" name=\"samplefield\" value=\"\" size=\"3\">"
    ."</td></tr>');\n"
    ."echo('</table>');\n"
    ."</textarea>\n"
  );

	echo('    <script>' . "\n");
	echo('      var asmeditor = CodeMirror.fromTextArea(document.getElementById("AdditionalScriptMenu"), {' . "\n");
	echo(" width: '100%',");
	echo(" height: '100%',");
	echo('        mode: "text/x-perl",' . "\n");
	echo('        tabSize: 2,' . "\n");
	echo('        matchBrackets: true,' . "\n");
	echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		asmeditor.on("blur", function(){ ' . "\n");
	echo('           asmeditor.save();' . "\n");
	echo('      });' . "\n");
	echo('    </script>' . "\n");                
            
	echo("</td></tr></table><table width=\"100%\" border=\"0\">\n"			 			
    ."<tr align=\"left\">"
    ."<td><b>Script For Additional Menu Validation When Executing Layouts,"
    ." you must add text to the error variable in this way \$error .= \"my error\";:</b><br>"
    ."<textarea id=\"ScriptForAdditionalValidation\" name=\"ScriptForAdditionalValidation\"></textarea>\n"
  );

	echo('    <script>' . "\n");
	echo('      var saveditor = CodeMirror.fromTextArea(document.getElementById("ScriptForAdditionalValidation"), {' . "\n");
	echo(" width: '100%',");
	echo(" height: '100%',");
	echo('        mode: "text/x-perl",' . "\n");
	echo('        tabSize: 2,' . "\n");
	echo('        matchBrackets: true,' . "\n");
	echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		saveditor.on("blur", function(){ ' . "\n");
	echo('           saveditor.save();' . "\n");
	echo('      });' . "\n");
	echo('    </script>' . "\n");                            
		
	echo("</td></tr></table><table width=\"100%\" border=\"0\">\n"
    ."<tr align=\"left\"><td><input name=\"submit\" value= \"Add ETL Scheme\" type=\"submit\"></td>"
    ."<td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n"
  );

  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<table width=\"100%\" border=\"0\">\n"
    ."<tr align=\"left\"><td>"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<select name=\"ETLSchemeID\">"
    ."<option selected value=\"\">Select ETL Scheme To Edit/Delete</option>\n"
  );

	$selectquery = "SELECT ETLSchemeID, ETLSchemeCode, ETLSchemeDescription FROM ".$globalp->{table_prefix}."_etl_schemes ORDER BY ETLSchemeCode";
	
  $resulti = $globalp->{dbh} -> prepare ($selectquery)  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_schemes: $selectquery";
	$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_etl_schemes";
	$resulti -> bind_columns(undef, \$ETLSchemeID, \$ETLSchemeCode, \$ETLSchemeDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref ) { echo("<option value=\"$ETLSchemeID\">$ETLSchemeCode - $ETLSchemeDescription</option>\n"); }
	$resulti->finish();

	echo("</select>\n"
    ." <input name=\"option\" value= \"Edit ETLS\" type=\"submit\">\n"
    ." <input name=\"option\" value= \"Delete ETLS\" type=\"submit\">\n"
    ."</form></td></tr></table>\n "
  );

  $globalp->{CloseTable}();

	echo("</div><div id=\"EplSiteETLScripts\" class=\"hidden\">");

  echo("<br>");
  $globalp->{OpenTable}();
	
  echo("<b><center><big>Independent Export Scripts Maintenance</big></center></b><br><table border=\"0\" >");
  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"ETL_ExtractScript_save\">\n"
    ."<input type=\"hidden\" name=\"ScriptID\" value=\"\">\n"
    ."<tr align=\"left\"><td>ETL Scheme:</td>"
    ."<td><select name=\"ETLSchemeCode\">"
    ."<option selected value=\"\">Select ETL Scheme</option>\n"
  );
			 
	$selectquery = "SELECT ETLSchemeID, ETLSchemeCode, ETLSchemeDescription FROM ".$globalp->{table_prefix}."_etl_schemes ORDER BY ETLSchemeCode";
	
  $resulti = $globalp->{dbh} -> prepare ($selectquery)  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_schemes: $selectquery";
	$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_etl_schemes";
	$resulti -> bind_columns(undef, \$ETLSchemeID, \$ETLSchemeCode, \$ETLSchemeDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref ) { echo("<option value=\"$ETLSchemeCode\">$ETLSchemeCode - $ETLSchemeDescription</option>\n"); }
	$resulti->finish();

	echo("</select></td></tr>\n"
    ."<tr align=\"left\"><td>Export Script Name:</td><td> <input type=\"text\" name=\"scriptname\" size=\"50\" maxlength=\"100\"></td></tr>\n"			 
    ."<tr align=\"left\"><td>Export Script Description:</td><td> <input type=\"text\" name=\"scriptdesc\" size=\"50\" maxlength=\"100\"></td></tr>\n"			     
    ."<tr align=\"left\"><td><input name=\"submit\" value= \"Add Script\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n"
  );

  echo("<form action=\"admin.prc\" method=\"POST\"><table border=\"0\" >\n"
    ."<tr align=\"left\"><td>"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<select name=\"ScriptID\">"
    ."<option selected value=\"\">Select Export Script To Edit/Delete</option>\n"
  );
			 
	$selectquery = "SELECT ScriptID, ETLSchemeCode, ScriptDescription FROM ".$globalp->{table_prefix}."_etl_independent_scripts ORDER BY ETLSchemeCode,ScriptDescription";
	
	$resulti = $globalp->{dbh} -> prepare ($selectquery)  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_independent_scripts: $selectquery";
	$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_etl_independent_scripts";
	$resulti -> bind_columns(undef, \$ScriptID, \$ETLSchemeCode, \$ScriptDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref ) { echo("<option value=\"$ScriptID\">$ETLSchemeCode - $ScriptDescription</option>\n"); }
	$resulti->finish();

	echo("</select>\n"
    ." <input name=\"option\" value= \"Edit Perl ScriptLet\" type=\"submit\">\n"
    ." <input name=\"option\" value= \"Delete Extract Script\" type=\"submit\">\n"
    ."</form></td></tr></table>\n "
  );


  $globalp->{CloseTable}();

	echo("</div><div id=\"EplSiteETLCatalogs\" class=\"hidden\">");
  
  echo("<br>");
  $globalp->{OpenTable}();
  echo("<b><center><big>".$globalp->{_CATALOGSMAINT}."</big></center></b><br>"
    ."<p align=\"center\">In this section, you define the tables needed to do the validation in the layouts.<br>"
    ."It is suggested you to create the catalog tables and then,<br>"
    ."create the database connection from EplSiteETL in the form above before doing this step.</p>"
  );
    
  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"Catalog_save\">\n"
    ."<input type=\"hidden\" name=\"TableID\" value=\"\">\n"
    ."<table border=\"0\"><tr align=\"left\"><td>Scheme Code:</td>"
    ."<td><select name=\"ETLSchemeID\">"
    ."<option selected value=\"\">Select ETL Scheme</option>\n"
  );
			 
	$selectquery = "SELECT ETLSchemeID, ETLSchemeCode, ETLSchemeDescription FROM ".$globalp->{table_prefix}."_etl_schemes ORDER BY ETLSchemeCode";
	
  $resulti = $globalp->{dbh} -> prepare ($selectquery)  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_schemes: $selectquery";
	$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_etl_schemes";
	$resulti -> bind_columns(undef, \$ETLSchemeID, \$ETLSchemeCode, \$ETLSchemeDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref ) { echo("<option value=\"$ETLSchemeID\">$ETLSchemeCode - $ETLSchemeDescription</option>\n"); }
	$resulti->finish();

	echo("</select></td></tr>\n"
    ."<tr align=\"left\"><td>Catalog Table Name:</td><td> <input type=\"text\" name=\"CatalogTableName\" size=\"50\" maxlength=\"100\"></td></tr>\n"
    ."<tr align=\"left\"><td>Catalog Table Field 1 To Be Used For Validation:</td><td> <input type=\"text\" name=\"Field1ForValidation\" size=\"50\" maxlength=\"100\"></td></tr>\n"
    ."<tr align=\"left\"><td>Field Type For Field1:</td><td> <input type=\"radio\" name=\"Field1Type\" value=\"Alphanumeric\" checked> Alphanumeric &nbsp;&nbsp;"
    ."<input type=\"radio\" name=\"Field1Type\" value=\"Numeric\"> Numeric</td></tr>\n"            
    ."<tr align=\"left\"><td>Catalog Table Field 2 To Be Used For Validation:</td><td> <input type=\"text\" name=\"Field2ForValidation\" size=\"50\" maxlength=\"100\"></td></tr>\n"
    ."<tr align=\"left\"><td>Field Type For Field2:</td><td> <input type=\"radio\" name=\"Field2Type\" value=\"Alphanumeric\" checked> Alphanumeric &nbsp;&nbsp;"
    ."<input type=\"radio\" name=\"Field2Type\" value=\"Numeric\"> Numeric</td></tr>\n"                        
    ."<tr align=\"left\"><td><input name=\"submit\" value= \"Add Catalog\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n"
  );

  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<table border=\"0\"><tr align=\"left\"><td>"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<select name=\"TableID\">"
    ."<option selected value=\"\">Select Catalog To Edit/Delete</option>\n"
  );
			 
	$selectquery = "SELECT a.TableID, c.ETLSchemeCode, a.CatalogTableName";
	$selectquery .= " FROM  ".$globalp->{table_prefix}."_etl_catalogs a,";
	$selectquery .= $globalp->{table_prefix}."_etl_schemes c";
	$selectquery .= " WHERE a.ETLSchemeID = c.ETLSchemeID";
	$selectquery .= " ORDER BY c.ETLSchemeCode, a.CatalogTableName";
		
	$resulti = $globalp->{dbh} -> prepare ($selectquery)  
	or die "Cannot prepare query: $selectquery";
	$resulti -> execute or die "Cannot execute query:$selectquery";
	$resulti -> bind_columns(undef, \$TableID, \$ETLSchemeCode, \$CatalogTableName);

	while( $datresulti = $resulti -> fetchrow_arrayref ) { echo("<option value=\"$TableID\">$ETLSchemeCode - $CatalogTableName</option>\n"); }
	$resulti->finish();

	echo("</select>\n"
    ." <input name=\"option\" value= \"Edit Catalog\" type=\"submit\">\n"
    ." <input name=\"option\" value= \"Delete Catalog\" type=\"submit\">\n"
    ."</form></td></tr></table>\n "
  );

  $globalp->{CloseTable}();

	echo("</div><div id=\"EplSiteETLTDefinitions\" class=\"hidden\">");
  
  echo("<br>");
  $globalp->{OpenTable}();
  echo("<b><center><big>".$globalp->{_DTSLAYOUTSMAINT}."</big></b> "
    ."- Click the links below to hide/unhide sections.<br>"
    ."<b>Mandatory Options For Data Transformation Definition</b>:"
    ."<a href=\"javascript:HandleDTSMenuSections('DescriptionTransformationData','');\">Transformation Description</a>"
    ."&nbsp;<a href=\"javascript:HandleDTSMenuSections('BeforeQuery','sbqeditor');\">Perl Script Before Query</a>"
    ."&nbsp;<a href=\"javascript:HandleDTSMenuSections('BuildTheQuery','lpqseditor');\">Perl Script To Build The Query</a>"
    ."&nbsp;<a href=\"javascript:HandleDTSMenuSections('AfterRecord','sartdeditor');\">Perl Script After Record</a>"
    
    ."<p>AVOID CHANGING THE FOLLOWING ETL SECTIONS, UNLESS YOU KNOW WHAT YOU ARE DOING!<br>"
    ."&nbsp;<a href=\"javascript:HandleDTSMenuSections('BeforeHeader','sbpeditor');\">Perl Script Before Header</a>"
    ."&nbsp;<a href=\"javascript:HandleDTSMenuSections('BeforeRecord','sbltdeditor');\">Perl Script Before Record</a>"
    ."&nbsp;<a href=\"javascript:HandleDTSMenuSections('AfterQuery','saltdeditor');\">Perl Script After Query</a>"
    ."</center> <br>"
    ."<div id=\"DescriptionTransformationData\" class=\"hidden\"><table width=\"100%\" border=\"0\" >"
  );

  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"Transformation_save\">\n"
    ."<input type=\"hidden\" name=\"TransformationID\" value=\"\">\n"
    ."<tr align=\"left\"><td>Scheme Code:</td>"
    ."<td><select name=\"ETLSchemeID\">"
    ."<option selected value=\"\">Select ETL Scheme</option>\n"
  );
			 
	$selectquery = "SELECT ETLSchemeID, ETLSchemeCode, ETLSchemeDescription FROM ";
	$selectquery .=$globalp->{table_prefix}."_etl_schemes ORDER BY ETLSchemeCode";
	
	$resulti = $globalp->{dbh} -> prepare ($selectquery)  
	or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_schemes: $selectquery";
	$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_etl_schemes";
	$resulti -> bind_columns(undef, \$ETLSchemeID, \$ETLSchemeCode, \$ETLSchemeDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref ) { echo("<option value=\"$ETLSchemeID\">$ETLSchemeCode - $ETLSchemeDescription</option>\n"); }
	$resulti->finish();

	echo("</select></td></tr>\n"
    ."<tr align=\"left\"><td>Transformation Code:</td><td> <input type=\"text\" name=\"TransformationCode\" size=\"5\" maxlength=\"5\"></td></tr>\n"
    ."<tr align=\"left\"><td>Description:</td><td> <input type=\"text\" name=\"Description\" size=\"50\" maxlength=\"100\"></td></tr>\n"
    ."<tr align=\"left\"><td>Show In Menu:</td><td> <input type=\"radio\" name=\"ShowInMenu\" value=\"Yes\" checked> Yes &nbsp;&nbsp;"
    ."<input type=\"radio\" name=\"ShowInMenu\" value=\"No\"> No"
    ." &nbsp;&nbsp; - Very Useful for multi header pipe delimited files when running chained layouts.</td></tr>\n"
    ."<tr align=\"left\"><td>Perl Script Name And Extension<br>To Process This Transformation.:</td>"
    ."<td> <input type=\"text\" name=\"ETLScriptName\" size=\"50\" maxlength=\"100\" value=\"ProcessLayoutDefinition.prc\">"
    ." *If you do not have your own script, leave this field as it is now.</td></tr>\n"
    .'</table></div><div id="BeforeHeader" class="hidden">'
    .'<table width="100%" border="0" >'
    ."<tr align=\"left\">"			 
    ."<td><b><u><big>Perl Script Before Header</big></u>(This adds some columns to your file header or creates a different header),"
    ."<br> obviously it only applies when exporting directly to a file:</b><br>"
    ."<textarea id=\"ScriptBeforePrintHeader\" name=\"ScriptBeforePrintHeader\"></textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var sbpeditor = CodeMirror.fromTextArea(document.getElementById("ScriptBeforePrintHeader"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		sbpeditor.on("blur", function(){ ' . "\n");
	echo('           sbpeditor.save();' . "\n");
	echo('      });' . "\n");
  echo('    </script>' . "\n");                            
             
  echo("</td></tr>\n"
    .'</table></div>'
    .'<div id="BeforeQuery" class="hidden"><table width="100%" border="0" >'
    ."<tr align=\"left\">"
    ."<td><b><u><big>Perl Script Before Query</big></u>, this section can be used to execute any preprocessing before getting data from query script below<br>"
    ."( This can be used for validation or deleting data before executing the main query.)"
    ." There are 2 global variables:<br>\$globalp->{DBSourceConn}, \$globalp->{DBTargetConn}<br>"
    ."\$globalp->{DBSourceConn} is where the data are read from.<br>"
    ."\$globalp->{DBTargetConn} is where the data are going to be after "
    ."transformation.:</b><br>"
    ."<textarea id=\"ScriptBeforeQuery\" name=\"ScriptBeforeQuery\">");
    
  echo("\n\n## Query to delete previous data in the target database table."
      ." ~>For easier transformation creation, you only need to change this line for data delete <~\n"
      ."#my \$DeleteQuery = \"DELETE FROM CAT_ProductionLine WHERE LineCode!='' \";\n"
      ."\n\n"
      ."#if( defined(\$globalp->{DBTargetConn}) ) {\n\n"
      ."  ## Running the delete query. This is the same for all transformations, avoid changing it unless you know what you are doing\n"
      ."#  \$globalp->{DBTargetConn}->do(\$DeleteQuery) or die \"Can not execute delete query:DeleteQuery\";\n"
      ."\n"
      ."  ## Creating the query to insert data.   ~>For easier transformation creation, you only need to change this line for data insert <~\n"
      ."#  my \$InsertQuery = \"INSERT INTO CAT_ProductionLine (LineCode, LineDescription) VALUES (?,?)\";\n"
      ."\n"
      ."  ## Preparing the insert query, this is the same for all transformations, avoid changing it unless you know what you are doing\n"
      ."#  our \$PagesInsert = \$globalp->{DBTargetConn}->prepare(\$InsertQuery);\n"
      ."\n"
      ."#}"
  );
  echo("</textarea>\n");

  echo('    <script>' . "\n");
  echo('      var sbqeditor = CodeMirror.fromTextArea(document.getElementById("ScriptBeforeQuery"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		sbqeditor.on("blur", function(){ ' . "\n");
	echo('           sbqeditor.save();' . "\n");
	echo('      });' . "\n");
  echo('    </script>' . "\n");                            
             
  echo("</td></tr>\n"
    .'</table></div>'
    .'<div id="BuildTheQuery" class="hidden"><table width="100%" border="0" >'	
    ."<tr align=\"left\">"
    ."<td><font color=\"blue\"><H2>Perl Script To Build The Query For The Layout, this is the query to get the data:</H2></font><br>"
    ."<textarea id=\"LayoutPerlQueryScript\" name=\"LayoutPerlQueryScript\">\n"
    ."#This is a Perl script sample to filter addresses data, you must changed to fit your needs\n"
    ."#\$MyQuery = \"SELECT tccom130.cadr as \"TCCOM130.CADR\"\n"
    ."#\$MyQuery .= \", tccom130.nama as \"TCCOM130.NAMA\"\";\n"
    ."#\$MyQuery .= \" FROM baan.ttccom130\".\$fdat{company}.\" a\";\n"
    ."\n"
    ."# At this point you could call the function \"get_data_from_main_query(\$MyQuery)\"\n"
    ."#to get the data:\n"
    ."#\$QueryDataFound = &get_data_from_main_query(\$MyQuery);\n"
    ."#get_data_from_main_query returns 0 or 1 after processing\n"
    ."# 0=Not Data Found, 1= Data Found.\n"            
    ."\n"
    ."# If you need some additional filter, you could use the Perl code below.\n"			
    ."\n"
    ."#\$PerlScriptFilterQuery = \"SELECT from_value\";\n"
    ."#\$PerlScriptFilterQuery .= \" FROM \".\$globalp->{table_prefix}.\"_etl_xreftable\";\n"
    ."#\$PerlScriptFilterQuery .= \" WHERE xreftype ='AddrtoExtract'\";\n"
    ."#\$PerlScriptFilterQuery .= \" ORDER BY from_value\";\n"
    ."\n"
    ."##~ echo(\$PerlScriptFilterQuery); exit;\n"
    ."\n"
    ."#\$PerlScriptFilterResult = \$globalp->{dbh} -> prepare ( \$PerlScriptFilterQuery )\n"
    ."#or die \"Cannot prepare query:\".\$PerlScriptFilterQuery;\n"
    ."#\$PerlScriptFilterResult -> execute  or die \"Cannot execute query:\".\$PerlScriptFilterQuery;\n"
    ."#\$PerlScriptFilterResult -> bind_columns(undef, \\\$FieldValueToFilter);\n"
    ."\n"
    ."#while( \$DatPerlScriptFilterResult = \$PerlScriptFilterResult -> fetchrow_arrayref ) \n"
    ."#{\n"
    ."#    \$MainQueryWithAdditions = \$MyQuery . \" WHERE a.T\\\$CADR = '\$FieldValueToFilter'\";\n"
    ."\n"
    ."# Now you could call the function \"get_data_from_main_query(\$MainQueryWithAdditions)\"\n"
    ."#to get the data:\n"
    ."#\$QueryDataFound = &get_data_from_main_query(\$MainQueryWithAdditions);\n"
    ."\n"
    ."#}\n"
    ."#\$PerlScriptFilterResult -> finish();\n"
    ."</textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var lpqseditor = CodeMirror.fromTextArea(document.getElementById("LayoutPerlQueryScript"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		lpqseditor.on("blur", function(){ ' . "\n");
	echo('           lpqseditor.save();' . "\n");
	echo('      });' . "\n");
  echo('    </script>' . "\n");                            
             
  echo("</td></tr>\n"	
    .'</table></div>'
    .'<div id="BeforeRecord" class="hidden"><table width="100%" border="0" >'
    ."<tr align=\"left\">"
    ."<td><b><h3><u>Perl Script Before Record</u>, is executed before process transformations to the data from"
    ." query, this is in case you want to do something with<br>"
    ."the data before processing the layout.<br>"
    ."In order to process the layout you must set value to variable"
    ." \$ContinueProcessingData to 0 or 1 (0=No Process,1=Process )"
    ." <br> This variable is used as a condition to process the layout"
    ." for actual record or continue with next record from query.</h3></b>"
    ."<textarea id=\"ScriptBeforeLayoutTransformationDefinition\""
    ." name=\"ScriptBeforeLayoutTransformationDefinition\">"
    ."\$ContinueProcessingData=1;</textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var sbltdeditor = CodeMirror.fromTextArea(document.getElementById("ScriptBeforeLayoutTransformationDefinition"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		sbltdeditor.on("blur", function(){ ' . "\n");
	echo('           sbltdeditor.save();' . "\n");
	echo('      });' . "\n");
  echo('    </script>' . "\n");                                        
  echo("</td></tr>\n"
    .'</table></div>'
    .'<div id="AfterRecord" class="hidden"><table width="100%" border="0" >'
  );
    
  echo("<tr align=\"left\">"
    ."<td><b><h3><u>Script After Record.</u><br>Perl Script Executed After Transformations On All Fields Of Each Record From Query.<br>"
    ."Here an additional transformation can be done or the insert to a"
    ." table in a target database connection, the target database connection<br>"
    ." selected at the moment of executing the transformation"
    ." can be used, it is stored in \$globalp->{DBTargetConn}:</h3></b><br>"
    ."<textarea id=\"ScriptAfterRecordTransformation\""
    ." name=\"ScriptAfterRecordTransformation\"></textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var sartdeditor = CodeMirror.fromTextArea(document.getElementById("ScriptAfterRecordTransformation"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		sartdeditor.on("blur", function(){ ' . "\n");
	echo('           sartdeditor.save();' . "\n");
	echo('      });' . "\n");
  echo('    </script>' . "\n");                                         
  echo("</td></tr>\n"
  	.'</table></div>'
	  .'<div id="AfterQuery" class="hidden"><table width="100%" border="0" >'
  );

  echo("<tr align=\"left\">"
    ."<td><b><h3><u>Script After Query.</u><br>Perl Script Executed After Process Transformation To All Records From Query.<br>"
    ."Here you could close your queries and disconnect any database.:</h3></b><br>"
    ."<textarea id=\"ScriptAfterLayoutTransformationDefinition\""
    ." name=\"ScriptAfterLayoutTransformationDefinition\"></textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var saltdeditor = CodeMirror.fromTextArea(document.getElementById("ScriptAfterLayoutTransformationDefinition"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		saltdeditor.on("blur", function(){ ' . "\n");
	echo('           saltdeditor.save();' . "\n");
  echo('      });' . "\n");
  echo('    </script>' . "\n");                                         
  echo("</td></tr></table></div><table width=\"100%\" border=\"0\" >\n");
    
	echo("<tr align=\"left\"><td><input name=\"submit\" value= \"Create Data Transformation Definition\""
  	." type=\"submit\"> Before clicking this button, click and set the mandatory options above<br>Tip: Edit one of the transformation samples to see how they are created.  </td><td><td>&nbsp;</td></tr></table>\n"
	  ."</form><br>\n"
  );

  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<table width=\"100%\" border=\"0\" ><tr align=\"left\"><td>"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" id=\"TSectionActive\" name=\"TSectionActive\" value=\"\">\n"
    ."<select name=\"TransformationID\">"
    ."<option selected value=\"\">Select Data Transformation Definition To Edit/Delete</option>\n"
  );
		 
	$selectquery = "SELECT a.TransformationID, b.ETLSchemeCode, a.TransformationCode,";
	$selectquery .= " a.Description";
	$selectquery .= " FROM ".$globalp->{table_prefix}."_etl_transformation_definitions a";
	$selectquery .= ", ".$globalp->{table_prefix}."_etl_schemes b";
	$selectquery .= " WHERE a.ETLSchemeID=b.ETLSchemeID";
	$selectquery .= " ORDER BY b.ETLSchemeCode, a.TransformationCode";

	$resulti = $globalp->{dbh} -> prepare ($selectquery)
	or die "Cannot prepare query:$selectquery";
	$resulti -> execute  or die "Cannot execute query:$selectquery";
	$resulti -> bind_columns(undef, \$TransformationID, \$ETLSchemeCode, \$TransformationCode, \$Description);

	while( $datresulti = $resulti -> fetchrow_arrayref ) { echo("<option value=\"$TransformationID\">$ETLSchemeCode - $TransformationCode - $Description</option>\n"); }
	$resulti->finish();

	echo("</select>\n"
    ." <input name=\"option\" value= \"Edit Transformation\" type=\"submit\">\n"
    ." <input name=\"option\" value= \"Delete Transformation\" type=\"submit\">\n"
    ."</form></td></tr></table>\n "
  );

  $globalp->{CloseTable}();
	echo("</div>");	
  $globalp->{sitefooter}();
}



sub resour_edit() {

  if( $fdat{ID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}");
  }

  $globalp->{siteheader}(); $globalp->{theheader}();
  $globalp->{GraphicAdmin}();
	echo("</div>");
  $globalp->{OpenTable}();
  echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
  $globalp->{CloseTable}();
  echo("<br>");

  $sthresult3 = $globalp->{dbh} -> prepare ("select ResourceName, Extension, Email, Login, ParentResource, LocationID, DeptID from ".$globalp->{table_prefix}."_etl_users where ResourceID=$fdat{ID}") or die "Cannot SELECT from ".$globalp->{table_prefix}."_etl_users";
  $sthresult3 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_etl_users";
  $sthresult3 -> bind_columns(undef, \$ResourceName, \$Extension, \$Email, \$Login, \$ParentResource, \$LocationID, \$DeptID);
  $datresult3 = $sthresult3 -> fetchrow_arrayref;
  $sthresult3->finish();

  $globalp->{OpenTable}();
  echo("<center><b>".$globalp->{_WFPERSONS}."</b></center><br><br>");
  echo("<table border=\"0\" >");
  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"resour_save\">\n"
    ."<input type=\"hidden\" name=\"ID\" value=\"$fdat{ID}\">\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFRESNAME}.":</td><td> <input type=\"text\" name=\"rname\" value=\"$ResourceName\"size=\"50\" maxlength=\"100\"> </td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFRESEXT}.":</td><td> <input type=\"text\" name=\"rext\" value=\"$Extension\" size=\"25\" maxlength=\"50\"></td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFRESMAIL}.":</td><td> <input type=\"text\" name=\"rmail\" value=\"$Email\" size=\"50\" maxlength=\"100\"> </td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFRESLOGIN}.":</td><td> <input type=\"text\" name=\"rlogin\" value=\"$Login\" size=\"20\" maxlength=\"20\"> </td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFREPSW}.":</td><td> <input type=\"password\" name=\"rpsw\" size=\"20\" maxlength=\"50\"> </td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_RETYPEPASSWD}.":</td><td> <input type=\"password\" name=\"rtpsw\" size=\"20\" maxlength=\"50\"> </td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFRESPARENT}.":</td><td> <input type=\"text\" name=\"rparent\" value=\"$ParentResource\" size=\"10\" maxlength=\"10\"></td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFRESLOC}.":</td><td> <input type=\"text\" name=\"rloc\" value=\"$LocationID\" size=\"10\" maxlength=\"10\"></td></tr>\n"
    ."<tr align=\"left\"><td>".$globalp->{_WFRESDEP}.":</td><td> <input type=\"text\" name=\"rdept\" value=\"$DeptID\" size=\"10\" maxlength=\"10\"></td></tr>\n"
    ."<tr align=\"left\"><td><input name=\"submit\" value= \"".$globalp->{_SAVECHANGES}."\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n"
  );

  $globalp->{CloseTable}();
  $globalp->{sitefooter}();
  $globalp->{clean_exit}();
}



sub resour_save() {

  $error = "";
  if( $fdat{rname} eq "" ) { $error .= "".$globalp->{_WFRESNAME}." ".$globalp->{_WFEMPTY}."<br>";}

  if( $fdat{rmail} eq "" ) { $error .= "".$globalp->{_WFRESMAIL}." ".$globalp->{_WFEMPTY}."<br>"; }

  if( $fdat{rlogin} eq "" ) { $error .= "".$globalp->{_WFRESLOGIN}." ".$globalp->{_WFEMPTY}."<br>"; }

  if( $fdat{rpsw} eq "" && $fdat{ID} eq "" ) { $error .= "".$globalp->{_WFREPSW}." ".$globalp->{_WFEMPTY}."<br>";}

  if( $fdat{rpsw} ne $fdat{rtpsw} ) { $error .= "".$globalp->{_WFREPSW}." & ".$globalp->{_RETYPEPASSWD}." ".$globalp->{_WFDIFF}."<br>"; }

  if( $error ne "" ) {
    $globalp->{siteheader}(); $globalp->{theheader}();

    echo("$error <br><br>".$globalp->{_GOBACK}."");
    delete $fdat{option};
    $globalp->{sitefooter}();
    $globalp->{clean_exit}();
  }

  $fdat_rname = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{rname}));
  $fdat_rext = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{rext}));
  $fdat_rmail = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{rmail}));
  #~ $fdat_rmail =~ s/@/\\@/;
  $fdat_rlogin = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{rlogin}));
  $fdat_rpsw = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{rpsw}));
  $pwd = md5_hex($fdat{rpsw});

  $fdat{rloc} = 0 if( $fdat{rloc} eq "");
  $fdat{rdept} = 0 if( $fdat{rdept} eq "");
    
  if( $fdat{ID} eq "" ) {
    $globalp->{dbh}->do("insert into ".$globalp->{table_prefix}."_etl_users values (NULL,'$fdat_rname', '$fdat_rext', '$fdat_rmail', '$fdat_rlogin', '$pwd', 0, 0, 0,0,0, 0)");
    delete $fdat{rname};
  } else {
    $UpdateQuery = "UPDATE ".$globalp->{table_prefix}."_etl_users SET";
    $UpdateQuery .= " ResourceName='$fdat_rname', Extension='$fdat_rext'";
    $UpdateQuery .= " , Email='$fdat_rmail', Login='$fdat_rlogin'";
    
    if( $fdat{rpsw} ne "" ) { $UpdateQuery .= " , Psw='$pwd'"; }
    
    $UpdateQuery .= " WHERE ResourceID=$fdat{ID}";
    #~ echo($UpdateQuery); exit;
    $globalp->{dbh}->do($UpdateQuery)
    or die "Can Not Update ".$globalp->{table_prefix}."_etl_users";
  }

  delete $fdat{option};
  $globalp->{cleanup}();
  &redirect_url_to("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}");
}



sub show_persons {

  $globalp->{search_header}($globalp->{_PERSONSSC});
  $globalp->{OpenTable}();
  echo("<center>".$globalp->{_USERNAMEKEY}."</center><br>");
  echo("<table border=\"0\" >");
  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"show_persons\">\n"
    ."<tr align=\"left\"><td></td><td> <input type=\"text\" name=\"query\""
    ." value=\"$fdat{query}\" size=\"30\" maxlength=\"50\"></td>\n"
    ."<td><input name=\"submit\" value=\"".$globalp->{_SEARCH}." "
    .$globalp->{_WFPERSONS}."\" type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
    ."</form>\n"
  );
  $globalp->{CloseTable}();

  echo("<br>");
  $globalp->{OpenTable}();
  echo("<center><b>- ".$globalp->{_WFSRESULTS}." -</b></center><hr noshade size=\"1\">\n");
  $offset = 10;
  $min = 0 if( !defined($fdat{min}) );
  $min = $fdat{min} if( defined($fdat{min}) );
  $max = ($min + $offset) if( !defined($max) );
  $fdat{query} = "%" if( $fdat{query} eq "" );
  $qc = "select ResourceID, ResourceName, Extension, Email, Login from ".$globalp->{table_prefix}."_etl_users";
  $qc_count = "select count(*) from ".$globalp->{table_prefix}."_etl_users";

  $qc .= " where (ResourceName like '%$fdat{query}%')";
  $qc_count .= " where (ResourceName like '%$fdat{query}%')";

  $qc .= " order by ResourceID limit $min,$offset";
  $qc_count .= " order by ResourceID";

  $sthsearch14 = $globalp->{dbh} -> prepare ($qc_count)  
	or die "Cannot SELECT from ".$globalp->{table_prefix}."_etl_users";
  $sthsearch14 -> execute  
	or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_etl_users";
  $sthsearch14 -> bind_columns(undef, \$nrows);
  $datsearch14 = $sthsearch14 -> fetchrow_arrayref;
  $sthsearch14->finish();

  $x = 0;

  if( $fdat{query} ne "" ) {
    echo("<table width=\"99%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\">\n"
      ."<tr bgcolor=\"$globalp->{bgcolor4}\" align=\"left\"><td>ID</td><td>".$globalp->{_WFRESNAME}
      ."</td><td>".$globalp->{_WFRESMAIL}."</td><td>".$globalp->{_WFRESLOGIN}."</td></tr>\n"
    );

    if ( $nrows > 0 ) {
			$sthsearch15 = $globalp->{dbh} -> prepare ($qc)  
			or die "Cannot SELECT from ".$globalp->{table_prefix}."_wf_task";
			$sthsearch15 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_wf_task";
			$sthsearch15 -> bind_columns(undef, \$ResourceID, \$ResourceName, \$Extension, \$Email, \$Login);

      while($datsearch15 = $sthsearch15 -> fetchrow_arrayref) {
        echo("<tr bgcolor=\"$globalp->{bgcolor3}\" align=\"left\"><td>$ResourceID</td><td>$ResourceName</td><td>$Email</td><td>$Login</td></tr>\n");
        $x++;
      }
      $sthsearch15->finish();

      echo("</table>");
    } else {
      echo("<tr align=\"left\"><td colspan=\"5\"><center><font class=\"option\"><br><b>"
			  .$globalp->{_NOMATCHES}."</b></font></center><br><br>"
			  ."</td></tr></table>"
      );
    }

    $prev = $min - $offset;
    if( $prev >= 0 ) {
      echo("<br><br><center><a href=\"admin.prc?session=$globalp->{session}"
        ."&amp;option=show_persons&amp;min=$prev&amp;query=$fdat{query}\">"
        ."<b>$min ".$globalp->{_PREVMATCHES}."</b></a></center>"
      );
    }

    $next = $min + $offset;

    if( $x >= 9 ) {
      echo("<br><br><center><a href=\"admin.prc?session=$globalp->{session}"
        ."&amp;option=show_persons&amp;min=$max&amp;query=$fdat{query}\">"
        ."<b>".$globalp->{_NEXTMATCHES}."</b></a></center>"
      );
    }

  }

  $globalp->{CloseTable}();
  echo("<p><a href=\"JavaScript:window.close()\">".$globalp->{_WFCLOSEW}."</a></p></body></html>\n");
  $globalp->{clean_exit}();
}



sub resour_delete() {

  if( $fdat{ID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

  if( $fdat{ok} == 1 ) {
    $globalp->{dbh}->do("delete from ".$globalp->{table_prefix}."_etl_users where ResourceID=$fdat{ID}");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  } else {
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
		echo("</div>");

    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

    $sthresult3 = $globalp->{dbh} -> prepare ("select ResourceName from ".$globalp->{table_prefix}."_etl_users where ResourceID=$fdat{ID}") or die "Cannot SELECT from ".$globalp->{table_prefix}."_etl_users";
    $sthresult3 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_etl_users";
    $sthresult3 -> bind_columns(undef, \$name);
    $datresult3 = $sthresult3 -> fetchrow_arrayref;
    $sthresult3->finish();

    if( $pnrows > 0 || $cnrows > 0 ) {
      $globalp->{OpenTable}();
      echo("<center>$name <br><br>"
			  ."<b>".$globalp->{_WFCANNOT}."<br><br>"
			  ."".$globalp->{_WFBECAUSE}." </b>"
			  .$globalp->{_GOBACK}
      );
      
      $globalp->{CloseTable}();
    } else {
      $globalp->{OpenTable}();
      echo("<center>"
        ."<b>".$globalp->{_WFDELRESRC}.": $name ?</b><br>"
        ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteETLManager\">"
        .$globalp->{_NO}."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;option="
        .$globalp->{_DELETEUSER}."&amp;ID=$fdat{ID}&amp;ok=1\">"
        .$globalp->{_YES}."</a> ]</center><br>"
      );
      $globalp->{CloseTable}();
    }
    $globalp->{sitefooter}();
  }
}



sub Transformation_save() {

  $error = "";

	$fdat{ETLSchemeID}  =~ s/^\s+//; #remove leading spaces
	$fdat{ETLSchemeID}  =~ s/\s+$//; #remove trailing spaces		
	
  if( $fdat{ETLSchemeID} eq "" or not defined($fdat{ETLSchemeID}) ) { $error .= "Select ETL Scheme From The Combo Box.<br>"; }	
	
	$fdat{TransformationCode}  =~ s/^\s+//; #remove leading spaces
	$fdat{TransformationCode}  =~ s/\s+$//; #remove trailing spaces	
	$fdat{TransformationCode} =~ s/'//g;
  if( $fdat{TransformationCode} eq "" ) { $error .= "Enter Correct Data Transformation Code.<br>"; }

	$fdat{Description}  =~ s/^\s+//; #remove leading spaces
	$fdat{Description}  =~ s/\s+$//; #remove trailing spaces	
	
  if( $fdat{Description} eq "" ) { $error .= "Enter Data Transformation Description.<br>"; }

	$NumRows = 0;
  if( $fdat{TransformationID} eq "" && $fdat{ETLSchemeID} ne "" && $fdat{TransformationCode} ne "") {
		$NumRows = 0;
    $CheckIfExists = "SELECT COUNT(*)";
    $CheckIfExists .= " FROM ".$globalp->{table_prefix}."_etl_transformation_definitions";
    $CheckIfExists .= " WHERE ETLSchemeID = ".$fdat{ETLSchemeID};
    $CheckIfExists .= " AND TransformationCode = '".$fdat{TransformationCode}."'";
        
		$sthresult = $globalp->{dbh} -> prepare ($CheckIfExists)
    or die "Cannot prepare query:$CheckIfExists";
		$sthresult -> execute  or die "Cannot execute query:$CheckIfExists";
		$sthresult -> bind_columns(undef, \$NumRows);
		$datresult = $sthresult -> fetchrow_arrayref ;
		$sthresult -> finish();
	}
	
  if( $fdat{TransformationID} ne "" && $fdat{ETLSchemeID} ne "" && $fdat{TransformationCode} ne "") {		
    $NumRows = 0;
    $CheckIfExists = "SELECT TransformationID";
    $CheckIfExists .= " FROM ".$globalp->{table_prefix}."_etl_transformation_definitions";
    $CheckIfExists .= " WHERE ETLSchemeID = ".$fdat{ETLSchemeID};
    $CheckIfExists .= " AND TransformationCode = '".$fdat{TransformationCode}."'";
      
    $sthresult = $globalp->{dbh} -> prepare ($CheckIfExists)
    or die "Cannot prepare query:$CheckIfExists";
    $sthresult -> execute  or die "Cannot execute query:$CheckIfExists";
    $sthresult -> bind_columns(undef, \$TransformationIDSaved);
  
    while($datresult = $sthresult -> fetchrow_arrayref()) {
      if( $TransformationIDSaved != $fdat{TransformationID} ) { $NumRows += 1; }
    }
    $sthresult -> finish();
  }
	
	if( $NumRows > 0 ) {	
		$error .= "Data Transformation <b> $fdat{TransformationCode} </b>"; 
		$error .= "Already Exists For ETL Scheme Selected<br>";
	}
		
  if( $fdat{ShowInMenu} eq "" or not defined($fdat{ShowInMenu}) ) { $error .= "Select If This Data Transformation Must Be In The Export List Menu.<br>"; }

	$fdat{ETLScriptName}  =~ s/^\s+//; #remove leading spaces
	$fdat{ETLScriptName}  =~ s/\s+$//; #remove trailing spaces	
	
  if( $fdat{ETLScriptName} eq "" ) { $error .= "Enter Data Transformation Script Name And Extension.<br>"; }


  if( $error ne "" ) {
    $globalp->{siteheader}(); $globalp->{theheader}();

    echo("$error <br><br>".$globalp->{_GOBACK}."");
    delete $fdat{option};
    $globalp->{sitefooter}();
    $globalp->{clean_exit}();
  }
	
	if( not defined($fdat{UsePerlScriptToFilter}) ) { $fdat{UsePerlScriptToFilter} = "No"; }

  $fdat_TransformationCode = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{TransformationCode}));
  $fdat_Description = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{Description}));
  $fdat_ETLScriptName= $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{ETLScriptName}));
	$fdat_ScriptBeforePrintHeader= $globalp->{FixScriptSlashesAndQuotes}($fdat{ScriptBeforePrintHeader});
	$fdat_ScriptBeforeQuery= $globalp->{FixScriptSlashesAndQuotes}($fdat{ScriptBeforeQuery});
	$fdat_LayoutPerlQueryScript= $globalp->{FixScriptSlashesAndQuotes}($fdat{LayoutPerlQueryScript});
	$fdat_ScriptBeforeLayoutTransformationDefinition= $globalp->{FixScriptSlashesAndQuotes}($fdat{ScriptBeforeLayoutTransformationDefinition});
  $fdat_ScriptAfterRecordTransformation= $globalp->{FixScriptSlashesAndQuotes}($fdat{ScriptAfterRecordTransformation});
	$fdat_ScriptAfterLayoutTransformationDefinition= $globalp->{FixScriptSlashesAndQuotes}($fdat{ScriptAfterLayoutTransformationDefinition});
	
    
  if( $fdat{TransformationID} eq "" ) {
		$insertquery = "INSERT INTO ".$globalp->{table_prefix}."_etl_transformation_definitions values ( ";
    $insertquery .= "NULL,$fdat{ETLSchemeID},'$fdat_TransformationCode', '$fdat_Description'";
    $insertquery .= ", '$fdat{ShowInMenu}', '$fdat_ETLScriptName','$fdat_ScriptBeforePrintHeader',";
    $insertquery .= "'$fdat_ScriptBeforeQuery','$fdat_LayoutPerlQueryScript',";
    $insertquery .= "'$fdat_ScriptBeforeLayoutTransformationDefinition',";
    $insertquery .= "'$fdat_ScriptAfterLayoutTransformationDefinition',";
    $insertquery .= "'$fdat_ScriptAfterRecordTransformation')";
		
		#~ echo($insertquery); exit;
    $globalp->{dbh}->do($insertquery);

		$TransformationID = 0;
    $SelectTID = "SELECT TransformationID";
    $SelectTID .= " FROM ".$globalp->{table_prefix}."_etl_transformation_definitions";
    $SelectTID .= " WHERE ETLSchemeID = ".$fdat{ETLSchemeID};
    $SelectTID .= " AND TransformationCode = '".$fdat{TransformationCode}."'";
        
		$sthresult = $globalp->{dbh} -> prepare ($SelectTID)
    or die "Cannot prepare query:$SelectTID";
		$sthresult -> execute  or die "Cannot execute query:$SelectTID";
		$sthresult -> bind_columns(undef, \$TransformationID);
		$datresult = $sthresult -> fetchrow_arrayref ;
		$sthresult -> finish();		
  } else {
		$UpdateQuery = "UPDATE ".$globalp->{table_prefix}."_etl_transformation_definitions SET";
		$UpdateQuery .= " TransformationCode='$fdat_TransformationCode', Description='$fdat_Description',";
		$UpdateQuery .= " ShowInMenu='$fdat{ShowInMenu}', ETLScriptName='$fdat_ETLScriptName',";
		$UpdateQuery .= " ETLSchemeID='$fdat{ETLSchemeID}',";
		$UpdateQuery .= " ScriptBeforePrintHeader = '$fdat_ScriptBeforePrintHeader',";
		$UpdateQuery .= " ScriptBeforeQuery = '$fdat_ScriptBeforeQuery',";
		$UpdateQuery .= " LayoutPerlQueryScript = '$fdat_LayoutPerlQueryScript',";
		$UpdateQuery .= " ScriptBeforeTransformationDefinition = '$fdat_ScriptBeforeLayoutTransformationDefinition',";
		$UpdateQuery .= " ScriptAfterTransformationDefinition = '$fdat_ScriptAfterLayoutTransformationDefinition'";
    $UpdateQuery .= ", ScriptAfterRecordTransformation = '$fdat_ScriptAfterRecordTransformation'";
		$UpdateQuery .= " WHERE TransformationID=$fdat{TransformationID}";
		#~ echo($UpdateQuery); exit;
    $globalp->{dbh}->do($UpdateQuery) or die "Can Not Update ".$globalp->{table_prefix}."_etl_transformation_definitions";
		$TransformationID = $fdat{TransformationID};
  }


	#####################################
	#Checking Scripts Syntax.############
	#####################################
	$error = "";
	$ScriptBeforePrintHeader = $fdat{ScriptBeforePrintHeader};
	$ScriptBeforePrintHeader  =~ s/^\s+//; #remove leading spaces
	$ScriptBeforePrintHeader  =~ s/\s+$//; #remove trailing spaces	
	
  if( $ScriptBeforePrintHeader ne "" ) {
		$ScriptBeforePrintHeaderError = $globalp->{EplSitePerlCheckSyntax}($fdat{ScriptBeforePrintHeader},"ScriptBeforePrintHeader");
		if( $ScriptBeforePrintHeaderError ne "") {
			$error .= "<b>The Script Before print header has errors:</b><br> " . $ScriptBeforePrintHeaderError ."<br><br>";
		}
  }
	
	$ScriptBeforeQuery = $fdat{ScriptBeforeQuery};
	$ScriptBeforeQuery  =~ s/^\s+//; #remove leading spaces
	$ScriptBeforeQuery  =~ s/\s+$//; #remove trailing spaces	
	
  if( $ScriptBeforeQuery ne "" ) {
		$ScriptBeforeQueryError = $globalp->{EplSitePerlCheckSyntax}($fdat{ScriptBeforeQuery},"ScriptBeforeQuery");
		if( $ScriptBeforeQueryError ne ""){
			$error .= "<b>The Script Before Query has errors:</b><br> " . $ScriptBeforeQueryError ."<br><br>";
		}
  }


	$LayoutQueryScript = $fdat{LayoutPerlQueryScript};
	$LayoutQueryScript  =~ s/^\s+//; #remove leading spaces
	$LayoutQueryScript  =~ s/\s+$//; #remove trailing spaces	
	
  if( $LayoutQueryScript ne "" ) {
		$LayoutQueryScriptError = $globalp->{EplSitePerlCheckSyntax}($fdat{LayoutPerlQueryScript},"LayoutQueryScript");
		if( $LayoutQueryScriptError ne "") {
			$error .= "<b>Perl Script To Build The Query has errors:</b><br> " . $LayoutQueryScriptError ."<br><br>";
		}
  }

	$ScriptBeforeLayoutTransformationDefinition = $fdat{ScriptBeforeLayoutTransformationDefinition};
	$ScriptBeforeLayoutTransformationDefinition  =~ s/^\s+//; #remove leading spaces
	$ScriptBeforeLayoutTransformationDefinition  =~ s/\s+$//; #remove trailing spaces	
	
  if( $ScriptBeforeLayoutTransformationDefinition ne "" ) {
		$SBLTDError = $globalp->{EplSitePerlCheckSyntax}($fdat{ScriptBeforeLayoutTransformationDefinition},"ScriptBeforeLayoutTransformationDefinition");
		if( $SBLTDError ne "") {
			$error .= "<b>The Script Before Transformation has errors:</b><br> " . $SBLTDError ."<br><br>";
		}
  }


	$ScriptAfterRecordTransformation = $fdat{ScriptAfterRecordTransformation};
	$ScriptAfterRecordTransformation =~ s/^\s+//; #remove leading spaces
	$ScriptAfterRecordTransformation =~ s/\s+$//; #remove trailing spaces	

  if( $ScriptAfterRecordTransformation ne "" ) {
		$SALTDError = $globalp->{EplSitePerlCheckSyntax}($fdat{ScriptAfterRecordTransformation},"ScriptAfterRecordTransformation");
		if( $SALTDError ne "") {
			$error .= "<b>The Script After Record Transformation has errors:</b><br> " . $SALTDError ."<br><br>";
		}
  }

	$ScriptAfterLayoutTransformationDefinition = $fdat{ScriptAfterLayoutTransformationDefinition};
	$ScriptAfterLayoutTransformationDefinition  =~ s/^\s+//; #remove leading spaces
	$ScriptAfterLayoutTransformationDefinition  =~ s/\s+$//; #remove trailing spaces	
	
  if( $ScriptAfterLayoutTransformationDefinition ne "" ) {
		$SALTDError = $globalp->{EplSitePerlCheckSyntax}($fdat{ScriptAfterLayoutTransformationDefinition},"ScriptAfterLayoutTransformationDefinition");
		if( $SALTDError ne "") {
			$error .= "<b>The Script After Transformation has errors:</b><br> " . $SALTDError ."<br><br>";
		}
  }

  if( $error ne "" ) {
    $globalp->{siteheader}(); $globalp->{theheader}();

    echo("Transformation Saved But, it Has Some Errors In Scripts:<br><br>$error <br><br>");
		echo("[ <a href=\"admin.prc?session=$globalp->{session}&amp;option="
      ."Edit Transformation&amp;TransformationID=$TransformationID&amp;"
      ."TSectionActive=$fdat{TSectionActive}\">Continue Editing Transformation.</a> ]<br><br>"
    );
		echo("[ <a href=\"admin.prc?session=$globalp->{session}&amp;option="
		  ."EplSiteETLManager\">Go To EplSite ETL Control Panel Screen.</a> ]<br>"
    );
    delete $fdat{option};
    $globalp->{sitefooter}();
    $globalp->{clean_exit}();
  } else { 
	  if( $fdat{TransformationID} eq "" ) {
			delete $fdat{option};
			$globalp->{cleanup}();
			&redirect_url_to("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}");			
		}	else {
			$globalp->{TransformationSaved} = "<font color=\"green\"><b>Transformation";
			$globalp->{TransformationSaved} .= " Succesfully Saved And Compiled At:";
			$globalp->{TransformationSaved} .= $globalp->{get_localtime}(time)." - Syntax OK.</b></font>";
			&Transformation_edit();			
		}
	}
}



sub Transformation_edit() {

  if( $fdat{TransformationID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}");
  }
    
  $globalp->{siteheader}();
	&JavaScriptsForMenus();
  $globalp->{LoadPerlCodeEditorLibs}();
	echo("<style>.CodeMirror {height: 620px;}</style>");
  $globalp->{theheader}();
  $globalp->{GraphicAdmin}();
	echo("</div>");
  $globalp->{OpenTable}();
  echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
	if($globalp->{TransformationSaved} ne "") {	echo($globalp->{TransformationSaved}); }
  $globalp->{CloseTable}();
  echo("<br>");

	$selectquery = "SELECT ETLSchemeID, TransformationCode, Description, ShowInMenu, ETLScriptName,";
	$selectquery .= " ScriptBeforePrintHeader, ScriptBeforeQuery, LayoutPerlQueryScript,";
	$selectquery .= " ScriptBeforeTransformationDefinition, ScriptAfterTransformationDefinition";
  $selectquery .= ", ScriptAfterRecordTransformation";
	$selectquery .= " FROM ".$globalp->{table_prefix}."_etl_transformation_definitions";
	$selectquery .= " WHERE TransformationID=$fdat{TransformationID}";
	
  $sthresult3 = $globalp->{dbh}-> prepare ($selectquery) 
  or die "Cannot prepare query:$selectquery";
  $sthresult3 -> execute  or die "Cannot execute query:$selectquery";
  $sthresult3 -> bind_columns(undef, \$ETLSchemeID, \$TransformationCode, \$Description
  , \$ShowInMenu, \$ETLScriptName, \$ScriptBeforePrintHeader,  \$ScriptBeforeQuery
  , \$LayoutPerlQueryScript, \$ScriptBeforeLayoutTransformationDefinition
  , \$ScriptAfterLayoutTransformationDefinition
  , \$ScriptAfterRecordTransformation);
  $datresult3 = $sthresult3 -> fetchrow_arrayref;
  $sthresult3->finish();

  $globalp->{OpenTable}();
  echo("<center><b>Edit Data Transformation Definition</b>"
    ."- Click the links below to hide/unhide sections.<br>"
    ."<b>Mandatory Options For Data Transformation Definition</b>:"
    ."<a href=\"javascript:HandleDTSMenuSections('DescriptionTransformationData','');\">Transformation Description</a>"
    
    ."&nbsp;<a href=\"javascript:HandleDTSMenuSections('BeforeQuery','sbqeditor');\">Perl Script Before Query</a>"
    ."&nbsp;<a href=\"javascript:HandleDTSMenuSections('BuildTheQuery','lpqseditor');\">Perl Script To Build The Query</a>"
    
    ."&nbsp;<a href=\"javascript:HandleDTSMenuSections('AfterRecord','sartdeditor');\">Perl Script After Record</a>"
    
    ."<p>AVOID CHANGING THE FOLLOWING ETL SECTIONS, UNLESS YOU KNOW WHAT YOU ARE DOING!<br>"
    ."&nbsp;<a href=\"javascript:HandleDTSMenuSections('BeforeHeader','sbpeditor');\">Perl Script Before Header</a>"
    ."&nbsp;<a href=\"javascript:HandleDTSMenuSections('BeforeRecord','sbltdeditor');\">Perl Script Before Record</a>"
    ."&nbsp;<a href=\"javascript:HandleDTSMenuSections('AfterQuery','saltdeditor');\">Perl Script After Query</a>"
    ."</p>"
    ."</center> <br>"
  );	
	
  echo("<form action=\"admin.prc\" method=\"POST\">\n");
  echo("<table width=\"100%\" border=\"0\" ><tr align=\"left\">"
	  ."<td><input name=\"submit\" value= \"Save Changes-Compile Keep Editing\""
	  ." type=\"submit\"> Before clicking this button, click and set the mandatory options above</td></tr></table>\n"
  );
	
  echo("<div id=\"DescriptionTransformationData\" class=\"hidden\"><table width=\"100%\" border=\"0\" >");
    
	echo("<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" id=\"TSectionActive\" name=\"TSectionActive\" value=\"$fdat{TSectionActive}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"Transformation_save\">\n"
    ."<input type=\"hidden\" name=\"TransformationID\" value=\"$fdat{TransformationID}\">\n"
    ."<tr align=\"left\"><td>ETL Scheme Code :</td><td><select name=\"ETLSchemeID\">"
  );
			 
	if( $ETLSchemeID eq "" ) {
		echo("<option selected value=\"\">Select ETL Scheme</option>\n");
	}	else {
		echo("<option value=\"\">Select ETL Scheme</option>\n");
	}
	
	$selectquery = "SELECT ETLSchemeID, ETLSchemeCode, ETLSchemeDescription FROM ".$globalp->{table_prefix}."_etl_schemes ORDER BY ETLSchemeCode";
	
	$resulti = $globalp->{dbh} -> prepare ($selectquery)  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_schemes: $selectquery";
	$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_etl_schemes";
	$resulti -> bind_columns(undef, \$ETLSchemeIDcat, \$ETLSchemeCode, \$ETLSchemeDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref ) {
		$sel = "";
		$sel = "selected" if( $ETLSchemeID eq $ETLSchemeIDcat );
		echo("<option ".$sel." value=\"".$ETLSchemeIDcat."\">".$ETLSchemeCode." - ".$ETLSchemeDescription."</option>\n");
	}
	$resulti->finish();
			
	echo("</select></td></tr>\n"	 
    ."<tr align=\"left\"><td>Transformation Code:</td><td> <input type=\"text\""
    ." name=\"TransformationCode\" size=\"5\" maxlength=\"5\""
    ." value=\"$TransformationCode\"></td></tr>\n"
    ."<tr align=\"left\"><td>Description:</td><td> <input type=\"text\" name=\"Description\""
    ." size=\"50\" maxlength=\"100\" value=\"$Description\"></td></tr>\n"
    ."<tr align=\"left\"><td>Show In Menu:</td><td> <input type=\"radio\" name=\"ShowInMenu\" value=\"Yes\""
  );
	
	if( $ShowInMenu eq "Yes" ) { echo(" checked"); }
	
  echo("> Yes &nbsp;&nbsp;<input type=\"radio\" name=\"ShowInMenu\" value=\"No\"");
	 
  if( $ShowInMenu eq "No" ) { echo(" checked"); }
	 
  echo("> No &nbsp;&nbsp; - Very Useful for multi header pipe delimited files when running chained layouts.</td></tr>\n"
    ."<tr align=\"left\"><td>Perl Script Name And Extension<br>To Process This Transformation.:"
    ."</td><td> <input type=\"text\" name=\"ETLScriptName\" size=\"50\""
    ." maxlength=\"100\" value=\"$ETLScriptName\"></td></tr>\n"
    .'</table></div><div id="BeforeHeader" '
  );
	
  if( $fdat{TSectionActive} eq "BeforeHeader" ) {
		echo('class="unhidden">');
	} else {
		echo('class="hidden">');
	}

	echo('<table width="100%" border="0" >'
    ."<tr align=\"left\">"
    ."<td><b><u><big>Perl Script Before Header</big></u>(This adds some columns to your"
    ." file header or creates a different header),"
    ."<br> obviously it only applies when exporting directly to a file:</b><br>"
    ."<textarea id=\"ScriptBeforePrintHeader\" name=\"ScriptBeforePrintHeader\">"
    .$ScriptBeforePrintHeader."</textarea>\n"
  );
  
  echo('    <script>' . "\n");
  echo('      var sbpeditor = CodeMirror.fromTextArea(document.getElementById("ScriptBeforePrintHeader"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		sbpeditor.on("blur", function(){ ' . "\n");
	echo('           sbpeditor.save();' . "\n");
  echo('      });' . "\n");
  echo('    </script>' . "\n");              
  echo("</td></tr>\n"
	  .'</table></div>'
	  .'<div id="BeforeQuery" '
  );
	
  if( $fdat{TSectionActive} eq "BeforeQuery" ) {
		echo('class="unhidden">');
	}	else{
		echo('class="hidden">');
	}

	echo('<table width="100%" border="0" >'	
    ."<tr align=\"left\">"
    ."<td><b><u><big>Perl Script Before Query</big></u>, this section can be used to execute any preprocessing before getting data from query script below<br>"
    ."( This can be used for validation or deleting data before executing the main query.)"
    ." There are 2 global variables:<br>\$globalp->{DBSourceConn}, \$globalp->{DBTargetConn}<br>"
    ."\$globalp->{DBSourceConn} is where the data are read from.<br>"
    ."\$globalp->{DBTargetConn} is where the data are going to be after "
    ."transformation.:</b><br>"
    ."<textarea id=\"ScriptBeforeQuery\" name=\"ScriptBeforeQuery\">"
    .$ScriptBeforeQuery."</textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var sbqeditor = CodeMirror.fromTextArea(document.getElementById("ScriptBeforeQuery"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		sbqeditor.on("blur", function(){ ' . "\n");
	echo('           sbqeditor.save();' . "\n");
  echo('      });' . "\n");
  echo('    </script>' . "\n");              
        
  echo("</td></tr>\n"
  	.'</table></div>'
	  .'<div id="BuildTheQuery" '
  );
	
  if( $fdat{TSectionActive} eq "BuildTheQuery" ) {
		echo('class="unhidden">');
	}	else {
		echo('class="hidden">');
	}

	echo('<table width="100%" border="0" >'
    ."<tr align=\"left\">"
    ."<td><b><h2>Perl Script To Build The Query For The Layout, this is the query"
    ." to get the data:</h2></b>"
    ."<textarea id=\"LayoutPerlQueryScript\" name=\"LayoutPerlQueryScript\">"
    .$LayoutPerlQueryScript."</textarea>\n"
  );
  
  echo('    <script>' . "\n");
  echo('      var lpqseditor = CodeMirror.fromTextArea(document.getElementById("LayoutPerlQueryScript"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		lpqseditor.on("blur", function(){ ' . "\n");
	echo('           lpqseditor.save();' . "\n");
  echo('      });' . "\n");
  echo('    </script>' . "\n");              

        
  echo("</td></tr>\n"
  	.'</table></div>'
	  .'<div id="BeforeRecord" '
  );

	if( $fdat{TSectionActive} eq "BeforeRecord" ) {
		echo('class="unhidden">');
	}	else {
		echo('class="hidden">');
	}

	echo('<table width="100%" border="0" >'
    ."<tr align=\"left\">"
    ."<td><b><h3>Perl Script Before Process Transformation To The Data From Query"
    ." above, this is in case you want do something with<br>"
    ."the data before processing the layout.<br>"
    ."In order to process the layout you must set value to variable "
    ."\$ContinueProcessingData to 0 or 1 (0=No Process,1=Process )"
    ." <br> This variable is used as a condition to process the layout for "
    ."actual record or continue with next record from query.</h3></b>"
    ."<textarea id=\"ScriptBeforeLayoutTransformationDefinition\""
    ." name=\"ScriptBeforeLayoutTransformationDefinition\">"
    .$ScriptBeforeLayoutTransformationDefinition."</textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var sbltdeditor = CodeMirror.fromTextArea(document.getElementById("ScriptBeforeLayoutTransformationDefinition"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		sbltdeditor.on("blur", function(){ ' . "\n");
	echo('           sbltdeditor.save();' . "\n");
  echo('      });' . "\n");
  echo('    </script>' . "\n");        
  echo("</td></tr>\n"
  	.'</table></div>'
	  .'<div id="AfterRecord" '
  );

	if( $fdat{TSectionActive} eq "AfterRecord" ) {
		echo('class="unhidden">');
	}	else{
		echo('class="hidden">');
	}

	echo('<table width="100%" border="0" >'    
    ."<tr align=\"left\">"
	  ."<td><b><h3><u>Script After Record.</u><br>Perl Script Executed After Transformations On All Fields Of Each Record From Query.<br>"
    ."Here an additional transformation can be done or the insert to a"
    ." table in a target database connection, the target database connection<br>"
    ." selected at the moment of executing the transformation"
    ." can be used, it is stored in \$globalp->{DBTargetConn}:</h3></b><br>"
    ."<textarea id=\"ScriptAfterRecordTransformation\""
    ." name=\"ScriptAfterRecordTransformation\">"
    .$ScriptAfterRecordTransformation."</textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var sartdeditor = CodeMirror.fromTextArea(document.getElementById("ScriptAfterRecordTransformation"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		sartdeditor.on("blur", function(){ ' . "\n");
	echo('           sartdeditor.save();' . "\n");
  echo('      });' . "\n");
  echo('    </script>' . "\n");                                         
  echo("</td></tr>\n"
  	.'</table></div>'
	  .'<div id="AfterQuery" '
  );
	
  if( $fdat{TSectionActive} eq "AfterQuery" ) {
		echo('class="unhidden">');
	}	else {
		echo('class="hidden">');
	}

	echo('<table width="100%" border="0" >'
    ."<tr align=\"left\">"
    ."<td><b><h3><u>Script After Query.</u><br>Perl Script Executed After Process Transformation To All Records From Query.<br>"
    ."Here you could close your queries and disconnect any database.:</h3></b><br>"
    ."<textarea id=\"ScriptAfterLayoutTransformationDefinition\""
    ."name=\"ScriptAfterLayoutTransformationDefinition\">"
    .$ScriptAfterLayoutTransformationDefinition."</textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var saltdeditor = CodeMirror.fromTextArea(document.getElementById("ScriptAfterLayoutTransformationDefinition"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		saltdeditor.on("blur", function(){ ' . "\n");
	echo('           saltdeditor.save();' . "\n");
  echo('      });' . "\n");
  echo('    </script>' . "\n");        
  echo("</td></tr></table></div>\n");
    
  echo("<table width=\"100%\" border=\"0\" ><tr align=\"left\">"
    ."<td><input name=\"submit\" value= \"Save Changes-Compile Keep Editing\""
    ." type=\"submit\"></td></tr></table>\n"
  );
		
	echo("</form><br>\n");

  $globalp->{CloseTable}();
  $globalp->{sitefooter}();
  $globalp->{clean_exit}();
}



sub Transformation_delete() {

  if( $fdat{TransformationID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

  if( $fdat{ok} == 1 ) {
    $DeleteQuery = "DELETE FROM ".$globalp->{table_prefix};
    $DeleteQuery .= "_etl_transformation_definitions";
    $DeleteQuery .= " WHERE TransformationID=".$fdat{TransformationID};
    $globalp->{dbh}->do($DeleteQuery);
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  } else {
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
		echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

    $selectquery = "SELECT a.TransformationCode, a.Description, b.ETLSchemeCode";
    $selectquery .= " FROM ".$globalp->{table_prefix}."_etl_transformation_definitions a";
    $selectquery .= " , ".$globalp->{table_prefix}."_etl_schemes b";
    $selectquery .= " WHERE a.TransformationID=".$fdat{TransformationID};
    $selectquery .= " AND a.ETLSchemeID=b.ETLSchemeID";
    
    $sthresult3 = $globalp->{dbh} -> prepare ($selectquery)
    or die "Cannot prepare query:$selectquery";
    $sthresult3 -> execute  or die "Cannot execute query:$selectquery";
    $sthresult3 -> bind_columns(undef, \$TransformationCode, \$Description, \$ETLSchemeCode);
    $datresult3 = $sthresult3 -> fetchrow_arrayref;
    $sthresult3->finish();

    my $NRows =0;
    $selectquery = "SELECT COUNT(*)";
    $selectquery .= " FROM ".$globalp->{table_prefix}."_etl_export_layouts";
    $selectquery .= " WHERE ETLSchemeCode='".$ETLSchemeCode."'";
    $selectquery .= " AND TransformationCode='".$TransformationCode."'";
    
    $sthresult3 = $globalp->{dbh} -> prepare ($selectquery)
    or die "Cannot prepare query:$selectquery";
    $sthresult3 -> execute  or die "Cannot execute query:$selectquery";
    $sthresult3 -> bind_columns(undef, \$NRows);
    $datresult3 = $sthresult3 -> fetchrow_arrayref;
    $sthresult3->finish();
    
    if( $NRows > 0 ) {
      $error .= "Transformation <b>\"$TransformationCode - $Description</b>";
      $error .= " from scheme <b>$ETLSchemeCode\"</b>";
      $error .= " is in use in layouts table and can not be deleted.<br>";
    }

		$globalp->{OpenTable}();
		
		if( $error ne "" ) {
			echo($error ."<br><br>".$globalp->{_GOBACK});
		} else {
      echo("<center>"
        ."<b>Do you want to delete transformation: "
        ."$TransformationCode - $Description from scheme $ETLSchemeCode?</b><br>"
        ."[ <a href=\"admin.prc?session=$globalp->{session}"
        ."&option=EplSiteETLManager\">".$globalp->{_NO}."</a> | "
        ."<a href=\"admin.prc?session=$globalp->{session}"
        ."&amp;option=Delete Transformation"
        ."&amp;TransformationID=$fdat{TransformationID}&amp;ok=1\">"
        .$globalp->{_YES}."</a> ]</center><br>"
      );
    }
		$globalp->{CloseTable}();
    $globalp->{sitefooter}();
  }
}



sub ETL_ExtractScript_edit() {

  if( $fdat{ScriptID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}");
  }

  $globalp->{siteheader}();
	&JavaScriptsForMenus();
	$globalp->{LoadPerlCodeEditorLibs}();	
	echo("<style>.CodeMirror {height: 620px;}</style>");
	$globalp->{theheader}();
  $globalp->{GraphicAdmin}();
	echo("</div>");
  $globalp->{OpenTable}();
  echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font> - "
    ."<b>Edit Independent Extract Script</b>"
    ." - Click the links below to hide/unhide sections.<br>"
    ."<a href=\"javascript:HandlePerlScriptSections('ScriptDescription','');\">Perl Scriptlet Description</a>"
    ."&nbsp; <a href=\"javascript:HandlePerlScriptSections('PerlScriptLetSection','perlscriptleteditor');\">Perl Scriptlet </a>"	
    ."</center>"
  );
  $globalp->{CloseTable}();
  echo("<br>");

	$selectquery = "SELECT ScriptDescription, ScriptName, ETLSchemeCode, PerlScriptLet FROM ";
	$selectquery .= $globalp->{table_prefix}."_etl_independent_scripts WHERE ScriptID=$fdat{ScriptID}";
	
  $sthresult3 = $globalp->{dbh} -> prepare ($selectquery) 
	or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_independent_scripts";
  $sthresult3 -> execute  
	or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_etl_independent_scripts";
  $sthresult3 -> bind_columns(undef, \$ScriptDescription, \$ScriptName,
	\$ETLSchemeCode, \$PerlScriptLet);
  $datresult3 = $sthresult3 -> fetchrow_arrayref;
  $sthresult3->finish();

  $globalp->{OpenTable}();
	
	if($globalp->{ScriptSaved} ne "") { echo($globalp->{ScriptSaved}); }

	echo("<form action=\"admin.prc\" method=\"POST\"><table border=\"0\">\n");
	echo("<tr align=\"left\"><td><input type=\"submit\" name=\"submit\" value= \"Save-Compile Continue Editing\"></td><td><td>&nbsp;</td></tr></table>\n");
  echo("<div id=\"ScriptDescription\" class=\"hidden\"><table border=\"0\">"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"ETL_ExtractScript_save\">\n"
    ."<input type=\"hidden\" name=\"ScriptID\" value=\"$fdat{ScriptID}\">\n"
    ."<tr align=\"left\"><td>ETL Scheme:</td><td><select name=\"ETLSchemeCode\">"
  );
			 
	if( $SourceSystem eq "" ) {
		echo("<option selected value=\"\">Select ETL Scheme</option>\n");
	}	else {
		echo("<option value=\"\">Select ETL Scheme</option>\n");
	}
	
	$selectquery = "SELECT ETLSchemeID, ETLSchemeCode, ETLSchemeDescription FROM ";
	$selectquery .= $globalp->{table_prefix}."_etl_schemes ORDER BY ETLSchemeCode";
	
	$resulti = $globalp->{dbh} -> prepare ($selectquery)  
	or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_schemes: $selectquery";
	$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_etl_schemes";
	$resulti -> bind_columns(undef, \$ETLSchemeID, \$ETLSchemeCodeCat, \$ETLSchemeDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref ) {
		$sel="";
		if( $ETLSchemeCode eq $ETLSchemeCodeCat ) { $sel ="selected"; }
		echo("<option $sel value=\"$ETLSchemeCodeCat\">$ETLSchemeCodeCat - $ETLSchemeDescription</option>\n");
	}
	$resulti->finish();
	
	echo("</select></td></tr>\n"
    ."<tr align=\"left\"><td>Script Name:</td><td> <input type=\"text\" name=\"scriptname\""
    ." size=\"50\" maxlength=\"100\" value=\"$ScriptName\"></td></tr>\n"			 
    ."<tr><td>Script Description:</td><td> <input type=\"text\""
    ." name=\"scriptdesc\" size=\"50\" maxlength=\"100\" value=\"$ScriptDescription\"></td></tr>\n"
    ."</table></div><div id=\"PerlScriptLetSection\" class=\"unhidden\"><table height=\"100%\" width=\"100%\" border=\"0\">\n"
    ."<tr align=\"left\"><td> <b>Perl ScriptLet. </b>\n"
    ."Write here your Perl ScriptLet, \n"
    ."all functions in EplSite Web Portal \n"
    ."and EplSite ETL module can be used.<br>\n"		
    ."<textarea id=\"PerlScriptLet\" name=\"PerlScriptLet\">\n"
    ."$PerlScriptLet</textarea>\n"
  );

	echo('    <script>' . "\n");
	echo('      var perlscriptleteditor = CodeMirror.fromTextArea(document.getElementById("PerlScriptLet"), {' . "\n");
	echo(" width: '100%',");
	echo(" height: '100%',");
	echo('        mode: "text/x-perl",' . "\n");
	echo('        tabSize: 2,' . "\n");
	echo('        matchBrackets: true,' . "\n");
	echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		perlscriptleteditor.on("blur", function(){ ' . "\n");
	echo('           perlscriptleteditor.save();' . "\n");
	echo('      });' . "\n");
	echo('    </script>' . "\n");            
	echo("</td></tr></table></div><table width=\"100%\" border=\"0\">\n"			 					 
    ."<tr align=\"left\"><td><input type=\"submit\" name=\"submit\" value= \"Save-Compile Continue Editing\">"
    ."</td></tr>\n"
    ."</table>\n"
    ."</form><br>\n"
  );

  $globalp->{CloseTable}();
  $globalp->{sitefooter}();
  $globalp->{clean_exit}();
}



sub ETL_ExtractScript_save() {

  $error = "";
	$globalp->{ScriptSaved} = "";
	
	$fdat{scriptname}  =~ s/^\s+//; #remove leading spaces
	$fdat{scriptname}  =~ s/\s+$//; #remove trailing spaces	
	$fdat{scriptname} =~ s/'//g;
  if( $fdat{scriptname} eq "" ) { $error .= "Enter Correct Export Script Name.<br>"; }

	$fdat{scriptdesc}  =~ s/^\s+//; #remove leading spaces
	$fdat{scriptdesc}  =~ s/\s+$//; #remove trailing spaces	
	
  if( $fdat{scriptdesc} eq "" ) { $error .= "Enter Export Script Description.<br>"; }

  if( $fdat{ETLSchemeCode} eq "" or not defined($fdat{ETLSchemeCode}) ) { $error .= "Select ETL Scheme.<br>"; }


	$NumRows = 0;
  if( $fdat{ScriptID} eq "" && $fdat{ETLSchemeCode} ne "" && $fdat{scriptname} ne "" ) {
		$SelectQuery = "SELECT COUNT(*) FROM ".$globalp->{table_prefix}."_etl_independent_scripts";
		$SelectQuery .= " WHERE ETLSchemeCode = '$fdat{ETLSchemeCode}'";
		$SelectQuery .= " AND ScriptName = '$fdat{scriptname}'";
		
		$sthresult = $globalp->{dbh} -> prepare ( $SelectQuery )  or die "Cannot prepare query:$SelectQuery";
		$sthresult -> execute  or die "Cannot execute Query:$SelectQuery";
		$sthresult -> bind_columns(undef, \$NumRows);
		$datresult = $sthresult -> fetchrow_arrayref ;
		$sthresult -> finish();
	}
	
  if( $fdat{ScriptID} ne "" && $fdat{ETLSchemeCode} ne "" && $fdat{scriptname} ne "" ) {
		$SelectQuery = "SELECT ScriptID FROM ".$globalp->{table_prefix}."_etl_independent_scripts";
		$SelectQuery .= " WHERE ETLSchemeCode = '$fdat{ETLSchemeCode}'";
		$SelectQuery .= " AND ScriptName = '$fdat{scriptname}'";
		
		$sthresult = $globalp->{dbh} -> prepare ( $SelectQuery )  
		or die "Cannot prepare query:$SelectQuery";
		$sthresult -> execute  or die "Cannot execute Query:$SelectQuery";
		$sthresult -> bind_columns(undef, \$ScriptIDSaved);
		
		while($datresult = $sthresult -> fetchrow_arrayref()){
			if( $ScriptIDSaved != $fdat{ScriptID} ) {	$NumRows += 1; }			
		}
		$sthresult -> finish();
	}

	if( $NumRows > 0 ){	
		$error .= "An Export Script With Name:$fdat{scriptname},";
		$error .= " Already Exists In Scheme Code:$fdat{ETLSchemeCode}.<br>";
	}	

  if( $error ne "" ) {
    $globalp->{siteheader}(); $globalp->{theheader}();

    echo("$error <br><br>".$globalp->{_GOBACK}."");
    delete $fdat{option};
    $globalp->{sitefooter}();
    $globalp->{clean_exit}();
  }

  $fdat_scriptname = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{scriptname}));
  $fdat_scriptdesc = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{scriptdesc}));
  $fdat_ETLSchemeCode= $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{ETLSchemeCode}));
  
  if( $fdat{ScriptID} eq "" ) {
		$insertquery = "INSERT INTO ".$globalp->{table_prefix}."_etl_independent_scripts";
		$insertquery .= " VALUES (NULL,'$fdat_scriptdesc', '$fdat_scriptname', '$fdat_ETLSchemeCode','')";
		
		#~ echo($insertquery); exit;
    $globalp->{dbh}->do($insertquery);
    delete $fdat{scriptname};
		delete $fdat{option};
		$globalp->{cleanup}();
		&redirect_url_to("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}");		
  } else {
		$fdat_PerlScriptLet = $globalp->{FixScriptSlashesAndQuotes}($fdat{PerlScriptLet});
		$UpdateQuery = "UPDATE ".$globalp->{table_prefix}."_etl_independent_scripts";
		$UpdateQuery .= " SET ScriptDescription='$fdat_scriptdesc', ScriptName='$fdat_scriptname'";
		$UpdateQuery .= ", ETLSchemeCode='$fdat_ETLSchemeCode'";
		$UpdateQuery .= ", PerlScriptLet='$fdat_PerlScriptLet'";
		$UpdateQuery .= " WHERE ScriptID=$fdat{ScriptID}";
		
    $globalp->{dbh}->do($UpdateQuery) 
		or die "Can Not Update ".$globalp->{table_prefix}."_etl_independent_scripts";
		
		$PerlScriptLet = $fdat{PerlScriptLet};
		$PerlScriptLet  =~ s/^\s+//; #remove leading spaces
		$PerlScriptLet  =~ s/\s+$//; #remove trailing spaces	
		
		if( $PerlScriptLet ne "" ) {
			$PerlScriptLetError = $globalp->{EplSitePerlCheckSyntax}($fdat{PerlScriptLet},"PerlScriptLet");
			if( $PerlScriptLetError ne "") { $error .= "<b>Perl Scriptlet Has Errors:</b><br> " . $PerlScriptLetError ."<br><br>"; }
		}
		
		if( $error ne "" ) {
			$globalp->{siteheader}(); $globalp->{theheader}();
			echo("Script Saved But It Has Some Errors:<br><br>$error <br><br>");
			echo("[ <a href=\"admin.prc?session=$globalp->{session}&amp;option=Edit Perl ScriptLet&amp;ScriptID=$fdat{ScriptID}\">Continue Editing Script.</a> ]<br><br>");
			echo("[ <a href=\"admin.prc?session=$globalp->{session}&amp;option=EplSiteETLManager\">Go To EplSite ETL Control Panel Screen.</a> ]<br>");
			delete $fdat{option};
			$globalp->{sitefooter}();
			$globalp->{clean_exit}();
		}	else {
			$globalp->{ScriptSaved} = "<font color=\"green\"><b>Perl ScriptLet "; 
			$globalp->{ScriptSaved} .= "Succesfully Saved And Compiled At:";
			$globalp->{ScriptSaved} .= $globalp->{get_localtime}(time)." - Syntax OK.</b></font>";
			
			&ETL_ExtractScript_edit();
		}
  }
}



sub ETL_ExtractScript_delete() {

  if( $fdat{ScriptID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

  if( $fdat{ok} == 1 ) {
    $globalp->{dbh}->do("DELETE FROM ".$globalp->{table_prefix}."_etl_independent_scripts WHERE ScriptID=$fdat{ScriptID}");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  } else {
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
		echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

    $sthresult3 = $globalp->{dbh} -> prepare ("SELECT ETLSchemeCode, ScriptDescription FROM ".$globalp->{table_prefix}."_etl_independent_scripts WHERE ScriptID=$fdat{ScriptID}") or die "Cannot SELECT from ".$globalp->{table_prefix}."_etl_independent_scripts";
    $sthresult3 -> execute  or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_etl_independent_scripts";
    $sthresult3 -> bind_columns(undef, \$ETLSchemeCode, \$ScriptDescription);
    $datresult3 = $sthresult3 -> fetchrow_arrayref;
    $sthresult3->finish();

		$globalp->{OpenTable}();
		echo("<center>"
  		."<b>Do you want to delete export script( It only will delete "
	  	."the Script Reference in table Not The Script ): $ETLSchemeCode"
		  ." - $ScriptDescription ?</b><br>"
		  ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteETLManager\">"
		  .$globalp->{_NO}."</a> | <a href=\"admin.prc?session="
		  ."$globalp->{session}&amp;option=Delete Extract Script&amp;"
		  ."ScriptID=$fdat{ScriptID}&amp;ok=1\">".$globalp->{_YES}."</a> ]</center><br>"
    );

		$globalp->{CloseTable}();
    $globalp->{sitefooter}();
  }
}



sub ETLS_save() {

  $error = "";
	
	$fdat{ETLSchemeCode}  =~ s/^\s+//; #remove leading spaces
	$fdat{ETLSchemeCode}  =~ s/\s+$//; #remove trailing spaces	
	
  if( $fdat{ETLSchemeID} eq "" ) {	
		if( $fdat{ETLSchemeCode} eq "" ) { $error .= "Enter ETL Scheme Code.<br>"; }
	}
	
	$fdat{ETLSchemeDescription}  =~ s/^\s+//; #remove leading spaces
	$fdat{ETLSchemeDescription}  =~ s/\s+$//; #remove trailing spaces	
	
  if( $fdat{ETLSchemeDescription} eq "" ) { $error .= "Enter ETL Scheme Description.<br>"; }

	$fdat{CatalogsDataSourceID}  =~ s/^\s+//; #remove leading spaces
	$fdat{CatalogsDataSourceID}  =~ s/\s+$//; #remove trailing spaces	
	
  if( $fdat{CatalogsDataSourceID} eq "" ) {
    $fdat{CatalogsDataSourceID} = 0;
    #~ $error .= "Select Data Base Connection For Catalogs.<br>";
  }

  if( $fdat{ETLSchemeID} eq "" ) {
		$RecordsInCFG = 0;
		$SelectQuery = "SELECT count(*) FROM ".$globalp->{table_prefix}."_etl_schemes";
		$SelectQuery .= " WHERE ETLSchemeCode = '".$fdat{ETLSchemeCode}."'";
		
		$sthresult = $globalp->{dbh} -> prepare ($SelectQuery)  
		or die "Cannot SELECT from ".$globalp->{table_prefix}."_etl_schemes";
		$sthresult -> execute  
		or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_etl_schemes ";
		$sthresult -> bind_columns(undef, \$NumRows);
		$datresult = $sthresult -> fetchrow_arrayref ;
		$sthresult -> finish();
		
		if( $NumRows > 0 ) { $error .= "ETL Scheme Code Already Exists.<br>"; }
	}
	
	$AdditionalScriptMenu = $fdat{AdditionalScriptMenu};
	$AdditionalScriptMenu  =~ s/^\s+//; #remove leading spaces
	$AdditionalScriptMenu  =~ s/\s+$//; #remove trailing spaces	
	
  if( $AdditionalScriptMenu ne "" ) {
		$AdditionalScriptMenuError = $globalp->{EplSitePerlCheckSyntax}($fdat{AdditionalScriptMenu},"AdditionalScriptMenu");
		if( $AdditionalScriptMenuError ne "") {
			$error .= "<b>The Script For Additional Menu Options has errors:</b><br> " . $AdditionalScriptMenuError ."<br><br>";
		}
  }
	

	$ScriptForAdditionalValidation = $fdat{ScriptForAdditionalValidation};
	$ScriptForAdditionalValidation  =~ s/^\s+//; #remove leading spaces
	$ScriptForAdditionalValidation  =~ s/\s+$//; #remove trailing spaces	
	
  if( $ScriptForAdditionalValidation ne "" ) {
		$ScriptForAdditionalValidationError = $globalp->{EplSitePerlCheckSyntax}($fdat{ScriptForAdditionalValidation},"ScriptForAdditionalValidation");
		if( $ScriptForAdditionalValidationError ne "") {
			$error .= "<b>The Script For Additional Menu Options has errors:</b><br> " . $ScriptForAdditionalValidationError ."<br><br>";
		}
  }

  if( $error ne "" ) {
    $globalp->{siteheader}(); $globalp->{theheader}();

    echo("$error <br><br>".$globalp->{_GOBACK}."");
    delete $fdat{option};
    $globalp->{sitefooter}();
    $globalp->{clean_exit}();
  }

  $fdat_ETLSchemeCode = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{ETLSchemeCode}));
  $fdat_ETLSchemeDescription = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{ETLSchemeDescription}));
	$fdat_AdditionalScriptMenu = $globalp->{FixScriptSlashesAndQuotes}($fdat{AdditionalScriptMenu});
	$fdat_ScriptForAdditionalValidation = $globalp->{FixScriptSlashesAndQuotes}($fdat{ScriptForAdditionalValidation});
    
  if( $fdat{ETLSchemeID} eq "" ) {
		$insertquery = "INSERT INTO ".$globalp->{table_prefix}."_etl_schemes values (";
    $insertquery .= "NULL,'$fdat_ETLSchemeCode', '$fdat_ETLSchemeDescription'";
    $insertquery .= ",$fdat{CatalogsDataSourceID},'$fdat_AdditionalScriptMenu'";
    $insertquery .= ", '$fdat_ScriptForAdditionalValidation')";
		
		#~ echo($insertquery); exit;
    $globalp->{dbh}->do($insertquery);
    delete $fdat{scriptname};
  } else {
		$updatequery = "UPDATE ".$globalp->{table_prefix}."_etl_schemes SET";
		$updatequery .= " ETLSchemeDescription='$fdat_ETLSchemeDescription',";
		$updatequery .= " CatalogsDataSourceID = $fdat{CatalogsDataSourceID},";
		$updatequery .= " AdditionalScriptMenu = '$fdat_AdditionalScriptMenu',";
		$updatequery .= " ScriptForAdditionalValidation = '$fdat_ScriptForAdditionalValidation'";
		$updatequery .= " WHERE ETLSchemeID=$fdat{ETLSchemeID}";
		#~ echo($updatequery); exit;
    $globalp->{dbh}->do($updatequery) or die "Can Not Update ".$globalp->{table_prefix}."_etl_schemes";
  }
  delete $fdat{option};
  $globalp->{cleanup}();
  &redirect_url_to("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}");
}



sub ETLS_edit() {

  if( $fdat{ETLSchemeID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}");
  }

  $globalp->{siteheader}();
  $globalp->{LoadPerlCodeEditorLibs}();
	echo("<style>.CodeMirror {height: 620px;}</style>");
  $globalp->{theheader}();
  $globalp->{GraphicAdmin}();
	echo("</div>");
  $globalp->{OpenTable}();
  echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
  $globalp->{CloseTable}();
  echo("<br>");

	$selectquery = "SELECT ETLSchemeCode, ETLSchemeDescription, CatalogsDataSourceID, AdditionalScriptMenu, ScriptForAdditionalValidation";
  $selectquery .= " FROM ".$globalp->{table_prefix}."_etl_schemes WHERE ETLSchemeID=$fdat{ETLSchemeID}";
	
  $sthresult3 = $globalp->{dbh} -> prepare ($selectquery) or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_schemes";
  $sthresult3 -> execute  or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_etl_schemes";
  $sthresult3 -> bind_columns(undef, \$ETLSchemeCode, \$ETLSchemeDescription, \$CatalogsDataSourceID, \$AdditionalScriptMenu, \$ScriptForAdditionalValidation);
  $datresult3 = $sthresult3 -> fetchrow_arrayref;
  $sthresult3->finish();


  $globalp->{OpenTable}();
  echo("<center><b>Edit ETL Scheme</b></center><br><br>");
  echo("<table width=\"100%\" border=\"0\" >");
  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"ETLS_save\">\n"
    ."<input type=\"hidden\" name=\"ETLSchemeID\" value=\"$fdat{ETLSchemeID}\">\n"
    ."<tr align=\"left\"><td>ETL Scheme Code:</td><td> $ETLSchemeCode</td></tr>\n"			 
    ."<tr align=\"left\"><td>ETL Scheme Description:</td><td> "
    ."<input type=\"text\" name=\"ETLSchemeDescription\""
    ." size=\"50\" maxlength=\"100\" value=\"$ETLSchemeDescription\"></td></tr>\n"
    ."<tr align=\"left\"><td>Data Base Connection For Catalogs:</td>"
    ."<td><select name=\"CatalogsDataSourceID\">"
  );
			 
	if( $CatalogsDataSourceID eq "" ) {
		echo("<option selected value=\"\">".$globalp->{_CATATLOGDATASRC}."</option>\n");
	} else {
		echo("<option value=\"\">".$globalp->{_CATATLOGDATASRC}."</option>\n");
	}

	$selectquery = "SELECT DataSourceID, DataSourceName FROM ".$globalp->{table_prefix}."_etl_data_sources ORDER BY DataSourceName";
	
	$resulti = $globalp->{dbh} -> prepare ($selectquery)  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_data_sources: $selectquery";
	$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_etl_data_sources";
	$resulti -> bind_columns(undef, \$DataSourceID, \$DataSourceName);

	while( $datresulti = $resulti -> fetchrow_arrayref ) {
		$sel = "";
		if( $DataSourceID eq  $CatalogsDataSourceID ){ $sel= "selected"; }
		echo("<option $sel value=\"$DataSourceID\">$DataSourceName</option>\n");
	}
	$resulti->finish();

	echo("</select></td></tr>\n"	
    ."</table><table width=\"100%\" border=\"0\"><tr align=\"left\">"
    ."<td><b>Script For Additional Menu Options:</b><br>"
    ."<textarea id=\"AdditionalScriptMenu\" name=\"AdditionalScriptMenu\">"
    .$AdditionalScriptMenu."</textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var asmeditor = CodeMirror.fromTextArea(document.getElementById("AdditionalScriptMenu"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		asmeditor.on("blur", function(){ ' . "\n");
	echo('           asmeditor.save();' . "\n");
	echo('      });' . "\n");
  echo('    </script>' . "\n");                            
        
  echo("</td></tr>\n"
    ."</table><table width=\"100%\" border=\"0\"><tr align=\"left\">"
    ."<td><b>Script For Additional Menu Validation When Executing Layouts, you"
    ." must add text to the error variable in this way \$error .= \"my error\";:</b><br>"
    ."<textarea id=\"ScriptForAdditionalValidation\" name=\"ScriptForAdditionalValidation\">"
    .$ScriptForAdditionalValidation."</textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var sfaveditor = CodeMirror.fromTextArea(document.getElementById("ScriptForAdditionalValidation"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		sfaveditor.on("blur", function(){ ' . "\n");
	echo('           sfaveditor.save();' . "\n");
  echo('      });' . "\n");
  echo('    </script>' . "\n");                                    
  echo("</td></tr></table><table width=\"100%\" border=\"0\">\n"
    ."<tr align=\"left\"><td><input name=\"submit\" value= \"".$globalp->{_SAVECHANGES}."\" type=\"submit\">"
    ."</td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n"
  );

  $globalp->{CloseTable}();
  $globalp->{sitefooter}();
  $globalp->{clean_exit}();
}



sub ETLS_delete() {

  if( $fdat{ETLSchemeID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

  if( $fdat{ok} == 1 ) {
    $globalp->{dbh}->do("DELETE FROM ".$globalp->{table_prefix}."_etl_schemes WHERE ETLSchemeID=$fdat{ETLSchemeID}");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  } else {
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
		echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

    $sthresult3 = $globalp->{dbh} -> prepare ("SELECT ETLSchemeCode, ETLSchemeDescription FROM ".$globalp->{table_prefix}."_etl_schemes WHERE ETLSchemeID=$fdat{ETLSchemeID}") or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_schemes";
    $sthresult3 -> execute  or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_etl_schemes";
    $sthresult3 -> bind_columns(undef, \$ETLSchemeCode, \$ETLSchemeDescription);
    $datresult3 = $sthresult3 -> fetchrow_arrayref;
    $sthresult3->finish();

		$error = "";
    $MySelectQuery = "SELECT count(*) FROM ".$globalp->{table_prefix}."_etl_transformation_definitions";
    $MySelectQuery .= " WHERE ETLSchemeID=".$fdat{ETLSchemeID};
    
    $sthresult3 = $globalp->{dbh} -> prepare ($MySelectQuery) or die 
    "Cannot prepare query:$MySelectQuery ";
    $sthresult3 -> execute  or die "Cannot execute query:$MySelectQuery";
    $sthresult3 -> bind_columns(undef, \$nrows);
    $datresult3 = $sthresult3 -> fetchrow_arrayref;
    $sthresult3->finish();
    
    if( $nrows > 0 ) {
      $error .= "The ETL Scheme $ETLSchemeCode - $ETLSchemeDescription";
      $error .= " is in use in layouts table:".$globalp->{table_prefix}."_etl_transformation_definitions<br>";
    } 
  
  }
        
  $MySelectQuery = "SELECT count(*) FROM ".$globalp->{table_prefix}."_etl_independent_scripts";
  $MySelectQuery .= " WHERE ETLSchemeCode='$ETLSchemeCode'";
  
  $sthresult3 = $globalp->{dbh} -> prepare ($MySelectQuery) or die 
  "Cannot prepare query:$MySelectQuery ";
  $sthresult3 -> execute  or die "Cannot execute query:$MySelectQuery";
  $sthresult3 -> bind_columns(undef, \$nrows);
  $datresult3 = $sthresult3 -> fetchrow_arrayref;
  $sthresult3->finish();
  
  if( $nrows > 0 ) {
    $error .= "The ETL Scheme $ETLSchemeCode - $ETLSchemeDescription";
    $error .= " is in use in scripts table:".$globalp->{table_prefix}."_etl_independent_scripts<br>";
  } 

  $MySelectQuery = "SELECT count(*) FROM ".$globalp->{table_prefix}."_etl_catalogs";
  $MySelectQuery .= " WHERE ETLSchemeID=".$fdat{ETLSchemeID};
  
  $sthresult3 = $globalp->{dbh} -> prepare ($MySelectQuery) or die 
  "Cannot prepare query:$MySelectQuery ";
  $sthresult3 -> execute  or die "Cannot execute query:$MySelectQuery";
  $sthresult3 -> bind_columns(undef, \$nrows);
  $datresult3 = $sthresult3 -> fetchrow_arrayref;
  $sthresult3->finish();
  
  if( $nrows > 0 ) {
    $error .= "The ETL Scheme $ETLSchemeCode - $ETLSchemeDescription";
    $error .= " is in use in catalogs table:".$globalp->{table_prefix}."_etl_catalogs<br>";
  }

	$globalp->{OpenTable}();
		
  if( $error ne "" ) {
    echo($error ."<br><br>".$globalp->{_GOBACK});
	} else {
		echo("<center>"
      ."<b>Do you want to delete ETL scheme: $ETLSchemeCode - $ETLSchemeDescription ?</b><br>"
      ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteETLManager\">".$globalp->{_NO}
      ."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;option=Delete ETLS&amp;ETLSchemeID=$fdat{ETLSchemeID}&amp;ok=1\">".$globalp->{_YES}
      ."</a> ]</center><br>"
    );
	}
				 
  $globalp->{CloseTable}();
  $globalp->{sitefooter}();

}



sub Catalog_save() {

  $error = "";
	
  if( $fdat{ETLSchemeID} eq "" or not defined($fdat{ETLSchemeID}) ) { $error .= "Select ETL Scheme From The Combo Box.<br>"; }

	$fdat{CatalogTableName}  =~ s/^\s+//; #remove leading spaces
	$fdat{CatalogTableName}  =~ s/\s+$//; #remove trailing spaces	
	
  if( $fdat{CatalogTableName} eq "" ) { $error .= "Enter Catalog Table Name.<br>"; }

  if( $globalp->{isspace}($fdat{Field1ForValidation}) ) { $error .= "Enter Catalog Field To Use For Validation.<br>"; }
    
  if( $fdat{Field1ForValidation} eq $fdat{Field2ForValidation} ) { $error .= "Field 1 For Validation And Field 2 For Validation Must be Different.<br>"; }

  if( $error ne "" ) {
    $globalp->{siteheader}(); $globalp->{theheader}();

    echo("$error <br><br>".$globalp->{_GOBACK}."");
    delete $fdat{option};
    $globalp->{sitefooter}();
    $globalp->{clean_exit}();
  }

	$fdat_CatalogTableName = $globalp->{FixScriptSlashesAndQuotes}($fdat{CatalogTableName});

  if( $fdat{TableID} eq "" ) {
		$insertquery = "INSERT INTO ".$globalp->{table_prefix}."_etl_catalogs";
    $insertquery .= " values (NULL,$fdat{ETLSchemeID}";
    $insertquery .= ",'$fdat_CatalogTableName'";
    $insertquery .= ",'$fdat{Field1ForValidation}','$fdat{Field2ForValidation}'";
    $insertquery .= ",'$fdat{Field1Type}','$fdat{Field2Type}')";        
		
		#~ echo($insertquery); exit;
    $globalp->{dbh}->do($insertquery);
    delete $fdat{scriptname};
  } else {
		$updatequery = "UPDATE ".$globalp->{table_prefix}."_etl_catalogs SET";
    $updatequery .= " ETLSchemeID=$fdat{ETLSchemeID}";
		$updatequery .= ", CatalogTableName = '$fdat_CatalogTableName'";
		$updatequery .= ", Field1ForValidation = '$fdat{Field1ForValidation}'";
		$updatequery .= ", Field1Type = '$fdat{Field1Type}'";
		$updatequery .= ", Field2ForValidation = '$fdat{Field2ForValidation}'";
		$updatequery .= ", Field2Type = '$fdat{Field2Type}'";
    $updatequery .= " WHERE TableID=$fdat{TableID}";
		#~ echo($updatequery); exit;
    $globalp->{dbh}->do($updatequery) or die "Can Not Update ".$globalp->{table_prefix}."_etl_catalogs";
  }

  delete $fdat{option};
  $globalp->{cleanup}();
  &redirect_url_to("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}");
}



sub Catalog_edit() {

  if( $fdat{TableID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}");
  }
    
  $globalp->{siteheader}(); $globalp->{theheader}();
  $globalp->{GraphicAdmin}();
	echo("</div>");
  $globalp->{OpenTable}();
  echo("<center><font class=\"title\"><b>EplSite ETL Manager - Catalog Tables Maintenance</b></font></center>");
  $globalp->{CloseTable}();
  echo("<br>");

	$selectquery = "SELECT ETLSchemeID, CatalogTableName,";
	$selectquery .= " Field1ForValidation, Field2ForValidation,Field1Type,Field2Type";
	$selectquery .= " FROM ".$globalp->{table_prefix}."_etl_catalogs WHERE TableID=$fdat{TableID}";
	
  $sthresult3 = $globalp->{dbh} -> prepare ($selectquery) or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_catalogs";
  $sthresult3 -> execute  or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_etl_catalogs";
  $sthresult3 -> bind_columns(undef, \$ETLSchemeID, \$CatalogTableName, \$Field1ForValidation, \$Field2ForValidation, \$Field1Type, \$Field2Type);
  $datresult3 = $sthresult3 -> fetchrow_arrayref;
  $sthresult3->finish();

  $globalp->{OpenTable}();
  echo("<center><b>Edit Catalog Table To Copy</b></center><br><br>");
  echo("<table border=\"0\" >");
  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"Catalog_save\">\n"
    ."<input type=\"hidden\" name=\"TableID\" value=\"$fdat{TableID}\">\n"
    ."<tr align=\"left\"><td>ETL Scheme:</td><td><select name=\"ETLSchemeID\">"
  );
			 
	if( $ETLSchemeID eq "" ) {
		echo("<option selected value=\"\">Select ETL Scheme</option>\n");
	}	else {
		echo("<option value=\"\">Select ETL Scheme</option>\n");
	}
	
	$selectquery = "SELECT ETLSchemeID, ETLSchemeCode, ETLSchemeDescription FROM ".$globalp->{table_prefix}."_etl_schemes ORDER BY ETLSchemeCode";
	
	$resulti = $globalp->{dbh} -> prepare ($selectquery)  or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_schemes: $selectquery";
	$resulti -> execute  or die "Cannot SELECT FORM ".$globalp->{table_prefix}."_etl_schemes";
	$resulti -> bind_columns(undef, \$ETLSchemeIDCat, \$ETLSchemeCodeCat, \$ETLSchemeDescription);

	while( $datresulti = $resulti -> fetchrow_arrayref ) {
		$sel="";
		if( $ETLSchemeID eq $ETLSchemeIDCat ) { $sel ="selected"; }
		echo("<option $sel value=\"$ETLSchemeIDCat\">$ETLSchemeCodeCat - $ETLSchemeDescription</option>\n");
	}
	$resulti->finish();
			
	echo("</select></td></tr>\n"
    ."<tr align=\"left\"><td>Catalog Table Name:	</td><td> <input type=\"text\""
    ." name=\"CatalogTableName\" size=\"50\" maxlength=\"100\" value=\"$CatalogTableName\"></td></tr>\n"
    ."<tr align=\"left\"><td>Catalog Table Field 1 To Be Used For Validation:"
    ."</td><td> <input type=\"text\" name=\"Field1ForValidation\" value=\"$Field1ForValidation\""
    ." size=\"50\" maxlength=\"100\"></td></tr>\n"
    ."<tr align=\"left\"><td>Field Type For Field1:</td><td> <input type=\"radio\""
    ." name=\"Field1Type\" value=\"Alphanumeric\""
  );
	
	if( $Field1Type eq "Alphanumeric" ) {	echo(" checked"); }

	echo("> Alphanumeric &nbsp;&nbsp;<input type=\"radio\" name=\"Field1Type\" value=\"Numeric\"");
	if( $Field1Type eq "Numeric" ) { echo(" checked"); }
	echo("> Numeric</td></tr>\n"
		."<tr align=\"left\"><td>Catalog Table Field 2 To Be Used For Validation:"
	  ."</td><td> <input type=\"text\" name=\"Field2ForValidation\" value=\""
	  ."$Field2ForValidation\" size=\"50\" maxlength=\"100\"></td></tr>\n"
	  ."<tr align=\"left\"><td>Field Type For Field2:</td><td> <input type=\"radio\""
	  ." name=\"Field2Type\" value=\"Alphanumeric\""
  );

	if( $Field2Type eq "Alphanumeric" ){ echo(" checked"); }

	echo("> Alphanumeric &nbsp;&nbsp;<input type=\"radio\" name=\"Field2Type\" value=\"Numeric\"");
	if( $Field2Type eq "Numeric" ) { echo(" checked"); }
	echo("> Numeric</td></tr>\n"        
    ."<tr align=\"left\"><td><input name=\"submit\" value= \"".$globalp->{_SAVECHANGES}."\""
    ." type=\"submit\"></td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n"
  );

  $globalp->{CloseTable}();
  $globalp->{sitefooter}();
  $globalp->{clean_exit}();
}



sub Catalog_delete() {

  if( $fdat{TableID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

  if( $fdat{ok} == 1 ) {
    $globalp->{dbh}->do("DELETE FROM ".$globalp->{table_prefix}."_etl_catalogs WHERE TableID=$fdat{TableID}");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  } else {
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
		echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite ETL Manager - Catalog Tables - Delete</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

		$selectquery = "SELECT CatalogTableName FROM ".$globalp->{table_prefix}."_etl_catalogs WHERE TableID=$fdat{TableID}";
		
		$sthresult3 = $globalp->{dbh} -> prepare ($selectquery) or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_catalogs";
		$sthresult3 -> execute  or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_etl_catalogs";
		$sthresult3 -> bind_columns(undef, \$CatalogTableName);
		$datresult3 = $sthresult3 -> fetchrow_arrayref;
		$sthresult3->finish();

		$error = "";
    $selectquery = "SELECT count(*) FROM ".$globalp->{table_prefix}."_etl_export_layouts WHERE Catalog=$fdat{TableID}";
    $sthresult3 = $globalp->{dbh} -> prepare ($selectquery) or die 
    "Cannot prepare query: $selectquery";
    $sthresult3 -> execute  or die "Cannot execute query:$selectquery";
    $sthresult3 -> bind_columns(undef, \$nrows);
    $datresult3 = $sthresult3 -> fetchrow_arrayref;
    $sthresult3->finish();

		if( $nrows > 0 ) { $error .= "The catalog:$CatalogTableName - is in use in export layouts table.<br>"; }
		
		$globalp->{OpenTable}();
		
		echo("<center>" . $error
      ."<b>Do you want to delete catalog:". $CatalogTableName." ?</b><br>"
      ."This process will only delete the reference in ETL catalogs table not "
      ."the catalog table in your database.<br>"
      ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteETLManager\">"
      .$globalp->{_NO}."</a> | <a href=\"admin.prc?session="
      ."$globalp->{session}&amp;option=Delete Catalog&amp;TableID=$fdat{TableID}&amp;ok=1\">"
      .$globalp->{_YES}."</a> ]</center><br>"
    );
				 
		$globalp->{CloseTable}();
    $globalp->{sitefooter}();
  }
}



sub DBConnection_save() {

  $error = "";
	
	$fdat{DataSourceName}  =~ s/^\s+//; #remove leading spaces
	$fdat{DataSourceName}  =~ s/\s+$//; #remove trailing spaces	
	
  if( $fdat{DataSourceID} eq "" ) {
		if( $fdat{DataSourceName} eq "" ){
			$error .= "Enter Data Source Name.<br>";
		}
	}

  if( $fdat{DataSourceID} eq "" && $error eq "" ) {
		$RecordsInCFG = 0;
    $MyQuery = "SELECT count(*) FROM ".$globalp->{table_prefix}."_etl_data_sources";
    $MyQuery .= " WHERE DataSourceName = '$fdat{DataSourceName}'";
		$sthresult = $globalp->{dbh} -> prepare ($MyQuery)  or die 
    echo( "Cannot SELECT from ".$globalp->{table_prefix}."_etl_data_sources");
		$sthresult -> execute  or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_etl_data_sources ";
		$sthresult -> bind_columns(undef, \$NumRows);
		$datresult = $sthresult -> fetchrow_arrayref ;
		$sthresult -> finish();
		
		if( $NumRows > 0 ) { $error .= "Data Source Name Already Exists, Please Enter a Different Name.<br>"; }
	}

  $My_DataSourceScript = $fdat{DataSourceScript};
	$My_DataSourceScript =~ s/^\s+//; #remove leading spaces
	$My_DataSourceScript =~ s/\s+$//; #remove trailing spaces	
	
  if( $fdat{DataSourceScript} eq "" ) { $error .= "Enter Connection Perl Script For Data Source.<br>"; }

  if( $error eq "" ) {
    eval $My_DataSourceScript;
    if( $@ ) { $error .= "<br><b>Data Source Script With Syntax Errors:</b><p>$@</p>"; }
  }
    
	if( $error ne "" ) {
    $globalp->{siteheader}(); $globalp->{theheader}();

    echo("$error <br><br>".$globalp->{_GOBACK});
    delete $fdat{option};
    $globalp->{sitefooter}();
    $globalp->{clean_exit}();
  }

  $fdat_DataSourceName = $globalp->{stripslashes}($globalp->{FixQuotes}($fdat{DataSourceName}));
  $fdat_DataSourceScript = $globalp->{FixScriptSlashesAndQuotes}($fdat{DataSourceScript});
    
  if( $fdat{DataSourceID} eq "" ) {
    $insertquery = "INSERT INTO ".$globalp->{table_prefix}."_etl_data_sources values (NULL,'$fdat_DataSourceName', '$fdat_DataSourceScript')";
		
		#~ echo($insertquery); exit;
    $globalp->{dbh}->do($insertquery);
    delete $fdat{DataSourceName};
  } else {
    $globalp->{dbh}->do("UPDATE ".$globalp->{table_prefix}."_etl_data_sources set DataSourceName='$fdat_DataSourceName', DataSourceScript='$fdat_DataSourceScript' WHERE DataSourceID=$fdat{DataSourceID}") or die "Can Not Update ".$globalp->{table_prefix}."_etl_data_sources";
  }

  delete $fdat{option};
  $globalp->{cleanup}();
  &redirect_url_to("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}");
}



sub DBConnection_edit() {

  if( $fdat{DataSourceID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&amp;session=$globalp->{session}");
  }

  $globalp->{siteheader}();
  $globalp->{LoadPerlCodeEditorLibs}();
	echo("<style>.CodeMirror {height: 620px;}</style>");
  $globalp->{theheader}();
  $globalp->{GraphicAdmin}();
	echo("</div>");
  $globalp->{OpenTable}();
  echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
  $globalp->{CloseTable}();
  echo("<br>");

	$selectquery = "SELECT DataSourceID, DataSourceName, DataSourceScript";
  $selectquery .= " FROM ".$globalp->{table_prefix}."_etl_data_sources";
  $selectquery .= " WHERE DataSourceID=$fdat{DataSourceID}";

  $sthresult3 = $globalp->{dbh} -> prepare ($selectquery) or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_data_sources";
  $sthresult3 -> execute  or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_etl_data_sources";
  $sthresult3 -> bind_columns(undef, \$DataSourceID, \$DataSourceName, \$DataSourceScript);
  $datresult3 = $sthresult3 -> fetchrow_arrayref;
  $sthresult3->finish();


  $globalp->{OpenTable}();
  echo("<center><b>Edit Data Source</b></center><br><br>");
  echo("<table width=\"100%\" border=\"0\" >");
  echo("<form action=\"admin.prc\" method=\"POST\">\n"
    ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">\n"
    ."<input type=\"hidden\" name=\"option\" value=\"DBConnection_save\">\n"
    ."<input type=\"hidden\" name=\"DataSourceID\" value=\"$fdat{DataSourceID}\">\n"
    ."<tr><td>Data Source ID:$DataSourceID, Name:</td><td> <input type=\"text\" name=\"DataSourceName\""
    ." size=\"50\" maxlength=\"100\" value=\"$DataSourceName\"></td></tr>\n"
    ."</table><table width=\"100%\" border=\"0\"><tr align=\"left\"><td><b>Database Connection Script:</b><br>"
    ."<textarea id=\"DataSourceScript\" name=\"DataSourceScript\">\n"
    .$DataSourceScript."</textarea>\n"
  );

  echo('    <script>' . "\n");
  echo('      var dsseditor = CodeMirror.fromTextArea(document.getElementById("DataSourceScript"), {' . "\n");
  echo(" width: '100%',");
  echo(" height: '100%',");
  echo('        mode: "text/x-perl",' . "\n");
  echo('        tabSize: 2,' . "\n");
  echo('        matchBrackets: true,' . "\n");
  echo('        lineNumbers: true,' . "\n");
	echo(' 		textWrapping: true,});' . "\n");
	echo('		dsseditor.on("blur", function(){ ' . "\n");
	echo('           dsseditor.save();' . "\n");
  echo('      });' . "\n");
  echo('    </script>' . "\n");                            
            
  echo("</td></tr></table><table width=\"100%\" border=\"0\"><tr align=\"left\"><td>"
    ."<input name=\"submit\" value= \"".$globalp->{_SAVECHANGES}."\" type=\"submit\">"
    ."</td><td><td>&nbsp;</td></tr></table>\n"
    ."</form><br>\n"
  );

  $globalp->{CloseTable}();
  $globalp->{sitefooter}();
  $globalp->{clean_exit}();
}



sub DBConnection_delete() {

  if( $fdat{DataSourceID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

  if( $fdat{ok} == 1 ) {
    $globalp->{dbh}->do("DELETE FROM ".$globalp->{table_prefix}."_etl_data_sources WHERE DataSourceID=$fdat{DataSourceID}");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  } else {
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
		echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

    $sthresult3 = $globalp->{dbh} -> prepare ("SELECT DataSourceName FROM ".$globalp->{table_prefix}."_etl_data_sources WHERE DataSourceID=$fdat{DataSourceID}") or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_data_sources";
    $sthresult3 -> execute  or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_etl_data_sources";
    $sthresult3 -> bind_columns(undef, \$DataSourceName);
    $datresult3 = $sthresult3 -> fetchrow_arrayref;
    $sthresult3->finish();

		$globalp->{OpenTable}();
		echo("<center>"
      ."<b>Do you want to delete database connection: $DataSourceName ?</b><br>"
      ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteETLManager\">"
      .$globalp->{_NO}."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;"
      ."option=Delete DB Connection&amp;DataSourceID=$fdat{DataSourceID}&amp;ok=1\">"
      .$globalp->{_YES}."</a> ]</center><br>"
    );
				 
		$globalp->{CloseTable}();
    $globalp->{sitefooter}();
  }
}



sub DBConnection_test() {

  if( $fdat{DataSourceID} eq "" ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

	$globalp->{siteheader}(); $globalp->{theheader}();
	$globalp->{GraphicAdmin}();
	echo("</div>");
	$globalp->{OpenTable}();
	echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
	$globalp->{CloseTable}();
	echo("<br>");

	$sthresult3 = $globalp->{dbh} -> prepare ("SELECT DataSourceName, DataSourceScript FROM ".$globalp->{table_prefix}."_etl_data_sources WHERE DataSourceID=$fdat{DataSourceID}") or die "Cannot SELECT FROM ".$globalp->{table_prefix}."_etl_data_sources";
	$sthresult3 -> execute  or die "Cannot execute SELECT FROM ".$globalp->{table_prefix}."_etl_data_sources";
	$sthresult3 -> bind_columns(undef, \$DataSourceName, \$DataSourceScript);
	$datresult3 = $sthresult3 -> fetchrow_arrayref;
	$sthresult3->finish();

	$globalp->{OpenTable}();
	eval $DataSourceScript;
	if( $@ ) {
		echo("<br><p>$@</p><br><br>[ <a href=\"javascript:history.go(-1)\">Go Back</a> ]");
	} else {
		my $globalp->{$DataSourceName} = eval( $DataSourceName );
		
    if( $@ ) {
        echo("<br><p>$@</p><br><br>[ <a href=\"javascript:history.go(-1)\">Go Back</a> ]");
    } else {
      $testquery = "SELECT COUNT(*) FROM ".$fdat{TableName};
      $TestDS = $globalp->{$DataSourceName}->prepare ($testquery)  or die echo("Cannot get query ( $testquery ) ");
      $TestDS -> execute  or die echo("Cannot get query ( $testquery ) ");
      $TestDS ->{RaiseError} = 1;

      if( my @TheTestDSArray = $TestDS->fetchrow_array) {
        echo("<p>Connection Working Fine, number of rows found in table <b>".$fdat{TableName}."</b>: "
        . $TheTestDSArray[0] . "</p><br>[ <a href=\"javascript:history.go(-1)\">Go Back</a> ]");
      } else {
        echo("<p>Cannot Count Records."
            .".</p><br>[ <a href=\"javascript:history.go(-1)\">Go Back</a> ]");
      }

      $TestDS->finish();					
    }
	}

	$globalp->{CloseTable}();
	$globalp->{sitefooter}();
}



sub ETL_delete_logs() {

  if( $globalp->{isspace}($fdat{datetimefrom}) or $globalp->{isspace}($fdat{datetimeto}) ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

	$fdat{datetimefrom} = $globalp->{All_Trim}($fdat{datetimefrom});
	$fdat{datetimeto} = $globalp->{All_Trim}($fdat{datetimeto});
		
  if( $globalp->{isspace}($fdat{datetimefrom}) > $globalp->{isspace}($fdat{datetimeto}) ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }
	
  if( $fdat{ok} == 1 ) {
		my $DeleteQuery = "DELETE FROM ".$globalp->{table_prefix}."_etl_transformations_log";
		$DeleteQuery .= " WHERE DateTime BETWEEN ".$fdat{datetimefrom};
		$DeleteQuery .= " AND ".$fdat{datetimeto};
    $globalp->{dbh}->do($DeleteQuery);
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  } else {
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
		echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

		$globalp->{OpenTable}();
  	echo("<center>"
      ."<b>Do you want to delete ETL Transformation And Layout Maintenance Logs From:"
      ." $fdat{datetimefrom} To $fdat{datetimeto} ?</b><br>"
      ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteETLManager\">".$globalp->{_NO}
      ."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;option=ETL_delete_logs"
      ."&amp;datetimefrom=$fdat{datetimefrom}&amp;datetimeto=$fdat{datetimeto}"
      ."&amp;ok=1\">".$globalp->{_YES}."</a> ]</center><br>"
    );
				 
		$globalp->{CloseTable}();
    $globalp->{sitefooter}();
  }
}



sub ETL_delete_logsByRunNumber() {

  if( $globalp->{isspace}($fdat{runnumberfrom}) or $globalp->{isspace}($fdat{runnumberto}) ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

	$fdat{runnumberfrom} = $globalp->{All_Trim}($fdat{runnumberfrom});
	$fdat{runnumberto} = $globalp->{All_Trim}($fdat{runnumberto});
		
  if( $globalp->{isspace}($fdat{runnumberfrom}) > $globalp->{isspace}($fdat{runnumberto}) ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }
	
  if( $fdat{ok} == 1 ) {
		my $DeleteQuery = "DELETE FROM ".$globalp->{table_prefix}."_etl_transformations_log";
		$DeleteQuery .= " WHERE RunNumber BETWEEN ".$fdat{runnumberfrom};
		$DeleteQuery .= " AND ".$fdat{runnumberto};
    $globalp->{dbh}->do($DeleteQuery);
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  } else {
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
		echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

		$globalp->{OpenTable}();
		
		echo("<center>"
      ."<b>Do you want to delete ETL Transformation And Layout Maintenance Logs From:"
      ." Run Number $fdat{runnumberfrom} To $fdat{runnumberto} ?</b><br>"
      ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteETLManager\">".$globalp->{_NO}
      ."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;option=ETL_delete_logsByRunNumber"
      ."&amp;runnumberfrom=$fdat{runnumberfrom}&amp;runnumberto=$fdat{runnumberto}"
      ."&amp;ok=1\">".$globalp->{_YES}."</a> ]</center><br>"
    );
				 
		$globalp->{CloseTable}();
    $globalp->{sitefooter}();
  }
}



sub ETL_delete_xreflogs() {

  if( $globalp->{isspace}($fdat{datetimefrom}) or $globalp->{isspace}($fdat{datetimeto}) ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

	$fdat{datetimefrom} = $globalp->{All_Trim}($fdat{datetimefrom});
	$fdat{datetimeto} = $globalp->{All_Trim}($fdat{datetimeto});
		
  if( $globalp->{isspace}($fdat{datetimefrom}) > $globalp->{isspace}($fdat{datetimeto}) ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }
	
  if( $fdat{ok} == 1 ) {
		my $DeleteQuery = "DELETE FROM ".$globalp->{table_prefix}."_etl_xreferror_log";
		$DeleteQuery .= " WHERE DateTime BETWEEN ".$fdat{datetimefrom};
		$DeleteQuery .= " AND ".$fdat{datetimeto};
    $globalp->{dbh}->do($DeleteQuery);
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  } else {
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
		echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

		$globalp->{OpenTable}();
		echo("<center>"
      ."<b>Do you want to delete XRefs error Log From:"
      ." $fdat{datetimefrom} To $fdat{datetimeto} ?</b><br>"
      ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteETLManager\">".$globalp->{_NO}
      ."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;option=ETL_delete_xreflogs"
      ."&amp;datetimefrom=$fdat{datetimefrom}&amp;datetimeto=$fdat{datetimeto}"
      ."&amp;ok=1\">".$globalp->{_YES}."</a> ]</center><br>"
    );
				 
		$globalp->{CloseTable}();
    $globalp->{sitefooter}();
  }
}



sub ETL_delete_xreflogsByRunNumber(){

  if( $globalp->{isspace}($fdat{runnumberfrom}) or $globalp->{isspace}($fdat{runnumberto}) ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

	$fdat{runnumberfrom} = $globalp->{All_Trim}($fdat{runnumberfrom});
	$fdat{runnumberto} = $globalp->{All_Trim}($fdat{runnumberto});
		
  if( $globalp->{isspace}($fdat{runnumberfrom}) > $globalp->{isspace}($fdat{runnumberto}) ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }
	
  if( $fdat{ok} == 1 ) {
		my $DeleteQuery = "DELETE FROM ".$globalp->{table_prefix}."_etl_xreferror_log";
		$DeleteQuery .= " WHERE RunNumber BETWEEN ".$fdat{runnumberfrom};
		$DeleteQuery .= " AND ".$fdat{runnumberto};
    $globalp->{dbh}->do($DeleteQuery);
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  } else {
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
		echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

		$globalp->{OpenTable}();
		
		echo("<center>"
      ."<b>Do you want to delete XRefs error Log From:"
      ." Run Number $fdat{runnumberfrom} To $fdat{runnumberto} ?</b><br>"
      ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteETLManager\">".$globalp->{_NO}
      ."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;option=ETL_delete_xreflogsByRunNumber"
      ."&amp;runnumberfrom=$fdat{runnumberfrom}&amp;runnumberto=$fdat{runnumberto}"
      ."&amp;ok=1\">".$globalp->{_YES}."</a> ]</center><br>"
    );
				 
		$globalp->{CloseTable}();
    $globalp->{sitefooter}();
  }
}



sub ETL_delete_catlogs() {

  if( $globalp->{isspace}($fdat{datetimefrom}) or $globalp->{isspace}($fdat{datetimeto}) ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

	$fdat{datetimefrom} = $globalp->{All_Trim}($fdat{datetimefrom});
	$fdat{datetimeto} = $globalp->{All_Trim}($fdat{datetimeto});
		
  if( $globalp->{isspace}($fdat{datetimefrom}) > $globalp->{isspace}($fdat{datetimeto}) ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }
	
  if( $fdat{ok} == 1 ) {
		my $DeleteQuery = "DELETE FROM ".$globalp->{table_prefix}."_etl_catalogerror_log";
		$DeleteQuery .= " WHERE DateTime BETWEEN ".$fdat{datetimefrom};
		$DeleteQuery .= " AND ".$fdat{datetimeto};
    $globalp->{dbh}->do($DeleteQuery);
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  } else {
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
		echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

		$globalp->{OpenTable}();
		echo("<center>"
      ."<b>Do you want to delete Catalogs error Log From:"
      ." $fdat{datetimefrom} To $fdat{datetimeto} ?</b><br>"
      ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteETLManager\">".$globalp->{_NO}
      ."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;option=ETL_delete_catlogs"
      ."&amp;datetimefrom=$fdat{datetimefrom}&amp;datetimeto=$fdat{datetimeto}"
      ."&amp;ok=1\">".$globalp->{_YES}."</a> ]</center><br>"
    );
				 
		$globalp->{CloseTable}();
    $globalp->{sitefooter}();
  }
}



sub ETL_delete_catlogsByRunNumber() {

  if( $globalp->{isspace}($fdat{runnumberfrom}) or $globalp->{isspace}($fdat{runnumberto}) ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }

	$fdat{runnumberfrom} = $globalp->{All_Trim}($fdat{runnumberfrom});
	$fdat{runnumberto} = $globalp->{All_Trim}($fdat{runnumberto});
		
  if( $globalp->{isspace}($fdat{runnumberfrom}) > $globalp->{isspace}($fdat{runnumberto}) ) {
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  }
	
  if( $fdat{ok} == 1 ) {
		my $DeleteQuery = "DELETE FROM ".$globalp->{table_prefix}."_etl_catalogerror_log";
		$DeleteQuery .= " WHERE RunNumber BETWEEN ".$fdat{runnumberfrom};
		$DeleteQuery .= " AND ".$fdat{runnumberto};
    $globalp->{dbh}->do($DeleteQuery);
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?option=EplSiteETLManager&session=$globalp->{session}");
  } else {
    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
		echo("</div>");
    $globalp->{OpenTable}();
    echo("<center><font class=\"title\"><b>EplSite ETL Manager</b></font></center>");
    $globalp->{CloseTable}();
    echo("<br>");

		$globalp->{OpenTable}();
		echo("<center>"
      ."<b>Do you want to delete Catalogs error Logs From:"
      ." Run Number $fdat{runnumberfrom} To $fdat{runnumberto} ?</b><br>"
      ."[ <a href=\"admin.prc?session=$globalp->{session}&option=EplSiteETLManager\">".$globalp->{_NO}
      ."</a> | <a href=\"admin.prc?session=$globalp->{session}&amp;option=ETL_delete_catlogsByRunNumber"
      ."&amp;runnumberfrom=$fdat{runnumberfrom}&amp;runnumberto=$fdat{runnumberto}"
      ."&amp;ok=1\">".$globalp->{_YES}."</a> ]</center><br>"
    );
				 
		$globalp->{CloseTable}();
    $globalp->{sitefooter}();
  }
}



sub JavaScriptsForMenus {

	echo("<script type=\"text/javascript\"> \n"
    .'function HandlePerlScriptSections(divID,EditorName)'."\n"
    .'{'."\n"
    .'	var item = document.getElementById(divID);'."\n"
    .'	if (item)'."\n"
    .'	{'."\n"
    ."			document.getElementById('ScriptDescription').className='hidden';\n"
    ."			document.getElementById('PerlScriptLetSection').className='hidden';\n"
    ."			item.className='unhidden';\n"
    ."	}\n"
    .'	switch ( EditorName )'."\n"
    .'	{'."\n"
    .'		case "perlscriptleteditor":'."\n"
    ."			perlscriptleteditor.refresh();\n"
    ."			break;\n"
    ."	}\n"
    ."}\n"
    ."\n"	
    .'function HandleMenuSections(divID,EditorName)'."\n"
    .'{'."\n"
    .'	var item = document.getElementById(divID);'."\n"
    .'	if (item)'."\n"
    .'	{'."\n"
    ."			document.getElementById('EplSiteETLLogs').className='hidden';\n"
    ."			document.getElementById('EplSiteETLUsers').className='hidden';\n"
    ."			document.getElementById('EplSiteETLDBConn').className='hidden';\n"
    ."			document.getElementById('EplSiteETLSchemes').className='hidden';\n"
    ."			document.getElementById('EplSiteETLScripts').className='hidden';\n"
    ."			document.getElementById('EplSiteETLCatalogs').className='hidden';\n"
    ."			document.getElementById('EplSiteETLTDefinitions').className='hidden';\n"
    ."			item.className='unhidden';\n"
    ."	}\n"
    .'	switch ( EditorName )'."\n"
    .'	{'."\n"
    .'		case "dseditor":'."\n"
    ."			dseditor.refresh();\n"
    ."			break;\n"
    .'		case "asmeditor":'."\n"
    ."			asmeditor.refresh();\n"
    ."			saveditor.refresh();\n"
    ."			break;\n"
    ."	}\n"
    ."}\n"
    ."\n"
    .'function HandleDTSMenuSections(divID,EditorName)'."\n"
    .'{'."\n"
    .'	var item = document.getElementById(divID);'."\n"
    .'	if (item)'."\n"
    .'	{'."\n"	
    ."			document.getElementById('TSectionActive').value=divID;\n"	
    ."			document.getElementById('DescriptionTransformationData').className='hidden';\n"
    ."			document.getElementById('BeforeHeader').className='hidden';\n"
    ."			document.getElementById('BeforeQuery').className='hidden';\n"
    ."			document.getElementById('BuildTheQuery').className='hidden';\n"
    ."			document.getElementById('BeforeRecord').className='hidden';\n"
    ."			document.getElementById('AfterRecord').className='hidden';\n"
    ."			document.getElementById('AfterQuery').className='hidden';\n"
    ."			item.className='unhidden';\n"
    ."	}\n"
    ."\n"
    .'	switch ( EditorName )'."\n"
    .'	{'."\n"
    .'		case "sbpeditor":'."\n"
    ."			sbpeditor.refresh();\n"
    ."			break;\n"
    .'		case "sbqeditor":'."\n"	
    ."			sbqeditor.refresh();\n"
    ."			break;\n"
    .'		case "lpqseditor":'."\n"	
    ."			lpqseditor.refresh();\n"
    ."			break;\n"
    .'		case "sbltdeditor":'."\n"	
    ."			sbltdeditor.refresh();\n"
    ."			break;\n"
    .'		case "sartdeditor":'."\n"	
    ."			sartdeditor.refresh();\n"
    ."			break;\n"
    .'		case "saltdeditor":'."\n"	
    ."			saltdeditor.refresh();\n"
    ."			break;\n"
    .'		case "perlscriptleteditor":'."\n"	
    ."			perlscriptleteditor.refresh();\n"
    ."			break;\n"	
    ."	}\n"	
    ."}\n"	
    ."</script>\n"
  );
}



if( $fdat{option} eq "EplSiteETLManager" ) { &EplSiteETLManager(); }

if( $fdat{option} eq "resour_save" ) { &resour_save(); }
elsif( $fdat{option} eq $globalp->{_EDITUSER} ) { &resour_edit(); }
elsif( $fdat{option} eq $globalp->{_DELETEUSER} ) { &resour_delete(); }

if( $fdat{option} eq "show_etl_users" ) { &show_persons(); }

if( $fdat{option} eq "ETL_ExtractScript_save" ) { &ETL_ExtractScript_save(); }
elsif( $fdat{option} eq "Edit Perl ScriptLet" ) { &ETL_ExtractScript_edit(); }
elsif( $fdat{option} eq "Delete Extract Script" ) { &ETL_ExtractScript_delete(); }

if( $fdat{option} eq "Transformation_save" ) { &Transformation_save(); }
elsif( $fdat{option} eq "Edit Transformation" ) { &Transformation_edit(); }
elsif( $fdat{option} eq "Delete Transformation" ) { &Transformation_delete(); }

if( $fdat{option} eq "ETLS_save" ) { &ETLS_save(); }
elsif( $fdat{option} eq "Edit ETLS" ) { &ETLS_edit(); }
elsif( $fdat{option} eq "Delete ETLS" ) { &ETLS_delete(); }

if( $fdat{option} eq "Catalog_save" ) { &Catalog_save(); }
elsif( $fdat{option} eq "Edit Catalog" ) { &Catalog_edit(); }
elsif( $fdat{option} eq "Delete Catalog" ) { &Catalog_delete(); }

if( $fdat{option} eq "DBConnection_save" ) { &DBConnection_save(); }
elsif( $fdat{option} eq "Edit DB Connection" ) { &DBConnection_edit(); }
elsif( $fdat{option} eq "Delete DB Connection" ) { &DBConnection_delete(); }
elsif( $fdat{option} eq "Test DB Connection" ) { &DBConnection_test(); }

if( $fdat{option} eq "ETL_delete_logs" ) { &ETL_delete_logs(); }
elsif( $fdat{option} eq "ETL_delete_logsByRunNumber" ) { &ETL_delete_logsByRunNumber(); }

if( $fdat{option} eq "ETL_delete_xreflogs" ) { &ETL_delete_xreflogs(); }
elsif( $fdat{option} eq "ETL_delete_xreflogsByRunNumber" ) { &ETL_delete_xreflogsByRunNumber(); }

if( $fdat{option} eq "ETL_delete_catlogs" ) { &ETL_delete_catlogs(); }
elsif( $fdat{option} eq "ETL_delete_catlogsByRunNumber" ) { &ETL_delete_catlogsByRunNumber(); }




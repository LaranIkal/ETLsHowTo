########################################################################
# Eplsite ETL,Process Layout Denifition script 
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
	
# Set initial variables and values 

our @externalscriptloaded;
our ($ScriptBeforeTransformationDefinition,$ScriptAfterTransformationDefinition);
our ($MainQueryDataFound, $ScriptAfterRecordTransformation);
our ( $LayoutDescription, $CFGTableReady, $ShowInMenu, $TransformationQueryInExecution );
our ( $ScriptBeforePrintHeader );
        
$CFGTableReady = 0; #Flag to know if the layout setup was already loaded.
our $DataSourceRows = [];    
our $ValueTypes = [];
our $ConstantValues = [];
our $QueryFields = [];
our $QueryField1ForXRefs = [];
our $QueryField2ForXRefs = [];
our $xreftypes = [];
our $TransformationScriptNames = [];
our $TransformatedValues = [];    
our $Catalogs = [];
our $QueryFieldNumForValidations1 = [];
our $CatalogFieldName1ForValidation = [];
our $CatalogFieldName1TypeForValidation = [];
our $QueryFieldNumForValidations2 = [];
our $CatalogFieldName2ForValidation = [];
our $CatalogFieldName2TypeForValidation = [];
our $FieldDescriptions = []; 
our $FieldMustBeExported = [];
our $RecordHasXRefError = [];
our %QueryFieldNames = ();
our %Proc_ResultValues = ();
our $layoutcounter = 0;
$MainQueryDataFound = 0;

if(not defined($fdat{runnumber}) or $fdat{runnumber} eq "" ) {
  &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Run Number Creation");
}

&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Pre-transformation checking.");	

$selectquery = "SELECT a.CatalogsDataSourceID, b.Description, b.ETLScriptName,";
$selectquery .= " b.ScriptBeforePrintHeader, b.ScriptBeforeQuery, b.LayoutPerlQueryScript,";
$selectquery .= " b.ScriptBeforeTransformationDefinition,";
$selectquery .= " b.ScriptAfterTransformationDefinition, b.ShowInMenu";
$selectquery .= ", b.ScriptAfterRecordTransformation";
$selectquery .= " FROM ".$globalp->{table_prefix}."_etl_schemes a";
$selectquery .= ", ".$globalp->{table_prefix}."_etl_transformation_definitions b";
$selectquery .= " WHERE a.ETLSchemeID=b.ETLSchemeID";
$selectquery .= " AND a.ETLSchemeID=".$fdat{ETLSchemeID};
$selectquery .= " AND b.TransformationCode = '".$fdat{TransformationCode}."'";
$globalp->{dbh}->{RaiseError} = 0;
$sthresult = $globalp->{dbh} -> prepare ($selectquery) 
              or die "Cannot prepare query: $selectquery \n\n <br><br> $DBI::errstr";
$sthresult -> execute  or die "Cannot execute query:$selectquery";
$sthresult -> bind_columns(undef, \$CatalogsDataSourceID, \$LayoutDescription
              , \$ETLScriptName, \$ScriptBeforePrintHeader, \$ScriptBeforeQuery, \$LayoutPerlQueryScript
              , \$ScriptBeforeTransformationDefinition, \$ScriptAfterTransformationDefinition
              , \$ShowInMenu, \$ScriptAfterRecordTransformation);
$datresult = $sthresult -> fetchrow_arrayref;
$sthresult -> finish();		
    
    
if( $fdat{xrefcondition} eq "noxrefonly" ) {
  if( not &XRefsNeededInLayout($fdat{ETLSchemeCode},$fdat{TransformationCode}) ) {
    &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"No xref defined in layout.");	
    &ETL_ExitTransformationProcess();
  }
}

    
if( $fdat{xrefcondition} eq "recordsok" ) {
  if( &CatalogsNeededInLayout($fdat{ETLSchemeCode},$fdat{TransformationCode}) ) {
    if( &DataSourceExists($CatalogsDataSourceID) ) {
      $globalp->{CataLogsDBConn} = $globalp->{connect_data_source}($CatalogsDataSourceID);
    } else {
      $Error = "There are catalogs defined in layout:$fdat{ETLSchemeCode} - ";
      $Error .= $fdat{TransformationCode}." but the data source defined";
      $Error .= " for ETL scheme:$fdat{ETLSchemeCode} does not exist.";
      &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);	
      &ETL_ExitTransformationProcess();
    }            
  } else {
    $Error = "No catalogs defined in layout:$fdat{ETLSchemeCode} - ";
    $Error .= $fdat{TransformationCode};
    &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);	
  }
}
    

&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Connecting data sources.");	
##Connecting to data sources
$globalp->{DBSourceConn} = $globalp->{connect_data_source}($fdat{DBConnSourceID});
    
if( $fdat{DBConnTargetID} != 3333 ) {
  # Connecting to target data source only if not output to file option.
  $globalp->{DBTargetConn} = $globalp->{connect_data_source}($fdat{DBConnTargetID});
}

if( $fdat{DBConnTargetID} == 3333 ) {
  #Ensuring Target DB Connection is deleted if output to file option.
  delete $globalp->{DBTargetConn} if(defined($globalp->{DBTargetConn}));
}

$ScriptBeforeQuery  =~ s/^\s+//; #remove leading spaces
$ScriptBeforeQuery  =~ s/\s+$//; #remove trailing spaces	
	
if( $ScriptBeforeQuery ne "" ) {
  &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Executing script before query.");
  eval $ScriptBeforeQuery;
  if($@) {
    $Error = "Script Before Query Has Errors:";
    $Error .= "\n\n$@\n\n $ScriptBeforeQuery \n\n";
    $Error =~ s/\n/<br>/g;
    
    &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
    &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Exiting Abnormally From Transformation.");
    
    if( $ENV{BATCH_PROCESS} == 0 ) {
      $globalp->{siteheader}();				
      echo('</head><body bgcolor="'.$globalp->{bodybgcolor}.'">');
      $globalp->{OpenTable}();			
      echo($Error);
      $globalp->{CloseTable}();
      echo("<br><br>Exiting Abnormally From Transformation.");				
      echo("<br> $globalp->{_GOBACK} <br>");
      $globalp->{sitefooter}();						
    }
    &ETL_ExitTransformationProcess();
  }
}



###############################################################################
## Here, in the $LayoutPerlQueryScript we are calling the logic to start  #####
## getting the data and process it, it happens when we call               #####
## $QueryDataFound = &get_data_from_main_query($MainQuery);               #####
## Inside $LayoutPerlQueryScript                                          #####
###############################################################################

#Perl Script To Build The Query that gets data For The Layout, this is the query to get the data from sourcedb
if( $LayoutPerlQueryScript ne "" ) {
  &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Executing layout script.");
  eval $LayoutPerlQueryScript;
  if($@) {
    $Error = "Layout Perl Script Has Errors:";
    $Error .= "\n\n$@\n\n $LayoutPerlQueryScript \n\n";
    $Error =~ s/\n/<br>/g;

    &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
    &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Exiting Abnormally From Transformation.");

    if( $ENV{BATCH_PROCESS} == 0 ) {
      $globalp->{siteheader}();				
      echo('</head><body bgcolor="'.$globalp->{bodybgcolor}.'">');
      $globalp->{OpenTable}();			
      echo($Error);
      $globalp->{CloseTable}();
      echo("<br><br>Exiting Abnormally From Transformation.");				
      echo("<br> $globalp->{_GOBACK} <br>");
      $globalp->{sitefooter}();						
    }				

    &ETL_ExitTransformationProcess();
  }
}
			
if( $MainQueryDataFound == 0 ) {
  $ScriptBeforeTransformationDefinition =~ s/\n/<br>/g;		
  $Error = "According To Script Before Process Transformation To The Data From Query:<br>$ScriptBeforeTransformationDefinition";
  $Error .= "<br>Data From Query:<br>$TransformationQueryInExecution <br>Does Not Have Any Information To Process.";	
  &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
} else {
  eval {
    #Closing xref query.
    $globalp->{xrefsthresultonevalue}->finish();
    $globalp->{xrefsthresulttwovalues}->finish();
  };
}	
	
&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Transformation Running End.");
$globalp->{clean_exit}() if( $fdat{DBConnTargetID} == 3333 || $ENV{BATCH_PROCESS} == 1 );
&ETL_ExitTransformationProcess() if( not defined($globalp->{DBTargetConn}) && BATCH_PROCESS == 0 );


###############################################################################
########################## Functions ##########################
###############################################################################

sub get_data_from_main_query {
  local $QueryFromLayoutPerlQueryScript = shift;
  
  $TransformationQueryInExecution = $QueryFromLayoutPerlQueryScript;
  $TransformationQueryInExecution =~ s/\n/<br>/g;
  
  if( $globalp->{WriteTransformationQueryInExecutionToLog} == 1 ) {
    &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},			
    "Executing Query:<br>".$TransformationQueryInExecution);
  }
  
  if( defined( $fdat{previewquery} ) ) {
    if( $fdat{previewquery} eq "Yes" ) {		
      $globalp->{siteheader}();
      echo('</head><body bgcolor="'.$globalp->{bodybgcolor}.'">');
      echo("<b>Previewing query:</b><br><br>");
      $globalp->{OpenTable}();
      echo($TransformationQueryInExecution);				
      $globalp->{CloseTable}();
      echo("<br> $globalp->{_GOBACK} <br>");
      $globalp->{sitefooter}();
      $globalp->{clean_exit}();
    }
  }

  $globalp->{DBSourceConn}->{RaiseError} = 1;
  eval { $DataSourceQuery = $globalp->{DBSourceConn}->prepare($QueryFromLayoutPerlQueryScript); };
  #~ echo($DataSourceQuery); exit;
  if($@) {
    $Error = "Cannot prepare query: ".$QueryFromLayoutPerlQueryScript;
    $Error .= "\n\nSQL ERROR:".$DBI::errstr."\n";
    $Error =~ s/\n/<br>/g;
    
    &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
    &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Exiting Abnormally From Transformation.");
    
    if( $ENV{BATCH_PROCESS} == 0 ) {
      echo('</head><body bgcolor="'.$globalp->{bodybgcolor}.'">');
      $globalp->{OpenTable}();
      echo($Error);
      $globalp->{CloseTable}();
      echo("<br><br>Exiting Abnormally From Transformation.");
      echo("<br> $globalp->{_GOBACK} <br>");
      $globalp->{sitefooter}();
    }
    
    &ETL_ExitTransformationProcess();
  }
		
  eval { $DataSourceQuery->execute(); };
  if($@) {
    $Error = "Cannot execute query: ".$QueryFromLayoutPerlQueryScript;
    $Error .= "\n\nSQL ERROR:".$DBI::errstr."\n";
    $Error =~ s/\n/<br>/g;

    &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
    &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Exiting Abnormally From Transformation.");

    if( $ENV{BATCH_PROCESS} == 0 ) {
      echo('</head><body bgcolor="'.$globalp->{bodybgcolor}.'">');
      $globalp->{OpenTable}();				
      echo($Error);
      $globalp->{CloseTable}();
      echo("<br><br>Exiting Abnormally From Transformation.");
      echo("<br> $globalp->{_GOBACK} <br>");
      $globalp->{sitefooter}();				
    }

    &ETL_ExitTransformationProcess();
  }
		
  $DataSourceQuery->{RaiseError} = 1;

  &initialize_layout_processing_variables();
        
	my $datafound = 0;

  ###############################################################################
  # Processing each row from main query	
  ###############################################################################
	#while( $DataSourceRow = (shift(@$DataSourceRows) || shift(@{$DataSourceRows=$DataSourceQuery->fetchall_arrayref(undef,1)||[]}))) {

  my $columns = $DataSourceQuery->{NAME};
  while ( $DataSourceRow = $DataSourceQuery->fetchrow_hashref ) {

    %QueryFieldNames = ();
    $layoutcounter +=1;
    #for(  my $Count = 0; $Count < $DataSourceQuery->{NUM_OF_FIELDS}; $Count++ ) {
    #  $QueryFieldNames{$DataSourceQuery->{NAME}[$Count]} = @{$DataSourceRow}[$Count];
    #}
			
    for my $col (@$columns) {
      $QueryFieldNames{$col} = $DataSourceRow->{$col};
    }

    $ContinueProcessingData = 0;
    eval $ScriptBeforeTransformationDefinition; #For each record we can run a script before transformation.
    if($@) { 
      $Error = "There is an error in the script before layout transformation:";
      $Error .= "\n\n$@\n\n $ScriptBeforeTransformationDefinition \n\n";
      $Error =~ s/\n/<br>/g;
      &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
      &ETL_ExitTransformationProcess();
    }		
			
    if( $ContinueProcessingData == 1 ) {  # This variable must be defined 
                                          # in the Script Before Layout, 
                                          # this is used if there is a 
                                          # condition to process data.
                                          # This is defined in $ScriptBeforeTransformationDefinition
      &Process_Layout_Data($LayoutDescription, $fdat{ETLSchemeCode}
                          ,$fdat{TransformationCode},$ShowInMenu,$ScriptBeforePrintHeader);
      $datafound = 1;
      $MainQueryDataFound = 1;
    }            
  }
  $DataSourceQuery ->finish();
		
  if( $datafound ) {
    $ScriptAfterTransformationDefinition  =~ s/^\s+//; #remove leading spaces
    $ScriptAfterTransformationDefinition  =~ s/\s+$//; #remove trailing spaces	
    if( $ScriptAfterTransformationDefinition ne "" ) {
      &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Running script after transformation definiton.");
      eval $ScriptAfterTransformationDefinition;
      if($@) { 
        $Error = "There is an error in the script after transformation:";
        $Error .= "\n\n$@\n\n $ScriptAfterTransformationDefinition \n\n";
        $Error =~ s/\n/<br>/g;
        &ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},$Error);
        &ETL_ExitTransformationProcess();
      }
    }
  }

  return($datafound);
}
	
	
	
	

	
	

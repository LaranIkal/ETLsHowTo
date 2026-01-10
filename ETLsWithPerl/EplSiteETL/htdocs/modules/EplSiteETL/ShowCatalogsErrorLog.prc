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

	$globalp->{siteheader}();
    echo("<p><a href=\"JavaScript:window.close()\">Close Window.</a>&nbsp;&nbsp;&nbsp;"
	.'<input type="button" value="Reload" onClick="location.reload()">'
	."</p>\n");
	$globalp->{OpenTable}();
	my $MyQuery = "SELECT RunNumber, DateTime, ETLUser, ETLSchemeCode";
	$MyQuery .= ", TransformationCode,FieldDescription, CatalogValue1";
	$MyQuery .= ", CatalogValue2, LogMessage";
	$MyQuery .= " FROM ".$globalp->{table_prefix}."_etl_catalogerror_log";
	$MyQuery .= " WHERE Runnumber = ".$fdat{runnumber};
	$MyQuery .= " ORDER BY DateTime";
	
	my $GetMyQuery = $globalp->{dbh}->prepare ($MyQuery)  
	or die "Cannot prepare: $MyQuery";
	$GetMyQuery -> execute  or die "Cannot execute: $MyQuery";
	$GetMyQuery ->{RaiseError} = 1;
	my $NumberOfFields = $GetMyQuery->{NUM_OF_FIELDS};

	my $MyQueryRows = [];
	my $QueryFields = "";
	my $HeaderPrinted = 0;
	echo("<table border=\"1\">");
	while( my $MyQueryRow = (shift(@$MyQueryRows) || shift(@{$MyQueryRows=$GetMyQuery->fetchall_arrayref(undef,1)||[]})))
	{			
		if( not $HeaderPrinted )
		{
			$HeaderPrinted = 1;
			echo("<tr>");
			for(  my $Count = 0; $Count < $GetMyQuery->{NUM_OF_FIELDS}; $Count++ )
			{
				echo("<th>".$GetMyQuery->{NAME}[$Count]."</th>");
			}			
			echo("</tr>");
		}
		
		echo("<tr>");
	
		foreach my $RowInQuery (@{$MyQueryRow})
		{
			echo("<td>".$RowInQuery."</td>");
		}
		echo("</tr>");		
	}
	$GetMyQuery ->finish();
	if( $HeaderPrinted == 0)
	{
		echo("No Data Found In this log.");
	}
	echo("</table>");
    $globalp->{CloseTable}();
	$globalp->{sitefooter}();
	$globalp->{clean_exit}();
	
	
	
	
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

	&ETLWriteTransformationLog($fdat{ETLSchemeCode},$fdat{TransformationCode},"Run Number Creation");
	my $SelectQuery = "SELECT COUNT(*)";
	$SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_export_layouts";
	$SelectQuery .= " WHERE ETLSchemeCode = '".$fdat{ETLSchemeCode}."'";
	$SelectQuery .= " AND TransformationCode='".$fdat{TransformationCode}."'";
	$SelectQuery .= " AND ValueType = 'CrossReference'";
	
	$sthresult = $globalp->{dbh} -> prepare ($SelectQuery) 
	or die "Cannot prepare query: $SelectQuery";
	$sthresult -> execute  or die "Cannot execute query:$SelectQuery";
	$sthresult -> bind_columns(undef, \$NumXrefs);
	$datresult = $sthresult -> fetchrow_arrayref;
	$sthresult -> finish();
	
	my $SelectQuery = "SELECT COUNT(*)";
	$SelectQuery .= " FROM ".$globalp->{table_prefix}."_etl_export_layouts";
	$SelectQuery .= " WHERE ETLSchemeCode = '".$fdat{ETLSchemeCode}."'";
	$SelectQuery .= " AND TransformationCode='".$fdat{TransformationCode}."'";
	$SelectQuery .= " AND Catalog > 0";
	
	$sthresult = $globalp->{dbh} -> prepare ($SelectQuery) 
	or die "Cannot prepare query: $SelectQuery";
	$sthresult -> execute  or die "Cannot execute query:$SelectQuery";
	$sthresult -> bind_columns(undef, \$NumCatalogs);
	$datresult = $sthresult -> fetchrow_arrayref;
	$sthresult -> finish();
	
	echo($fdat{runnumber}."\|".$NumXrefs."\|".$NumCatalogs);
	
	$globalp->{clean_exit}();
	

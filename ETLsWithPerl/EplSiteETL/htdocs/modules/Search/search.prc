########################################################################
# Eplsite,Subroutines for Search module
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

Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/Search/language/lang-'.$globalp->{site_language}.'.prc');
#~ Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/WorkFlow/config_workflow.prc');

sub display_search_form
{
echo("<!-- display_search_form -->");

    $globalp->{print_title}("EplSite ETL Documentation Search");


    echo("<table width=\"100%\" border=\"0\"><TR><TD>");

    if( ($fdat{type} eq "content")) {
        echo("<img src=\"".$alltop."\" align=\"right\" border=\"0\" alt=\"\">");
    } else {
        echo("<img src=\"".$topicimage."\" align=\"right\" border=\"0\" alt=\"".$topictext."\">");
    }

    echo("<form action=\"index.prc\" method=\"POST\">\n"
        ."<input type=\"hidden\" name=\"module\" value=\"Search\">\n"
		 ."<input type=\"hidden\" name=\"Search\" value=\"Search\">\n"
        ."Enter Keyword: <input size=\"25\" type=\"text\" name=\"query\" value=\"".$fdat{query}."\">&nbsp;&nbsp;\n"
        ."<input type=\"submit\" value=\"".$globalp->{_SEARCH}."\"><br><br>\n");

    if( defined($fdat{sid}) ) {
        echo("<input type=\"hidden\" name=\"sid\" value=\"$fdat{sid}\">");
    }

    echo("</form></td></tr></table>\n");
}




sub search_content
{
    local $escmode = 0;
    $qc = "select pid,title,date from ".$globalp->{table_prefix}."_pages";
    $qc_count = "select count(*) from ".$globalp->{table_prefix}."_pages";

    $qc .= " where (subtitle like '%$fdat{query}%' OR page_header like '%$fdat{query}%' OR text like '%$fdat{query}%' OR page_footer like '%$fdat{query}%') AND active=1";
    $qc_count .= " where (subtitle like '%$fdat{query}%' OR page_header like '%$fdat{query}%' OR text like '%$fdat{query}%' OR page_footer like '%$fdat{query}%' AND active=1) AND active=1";

    $qc .= " order by date DESC limit $min,$offset";
    $qc_count .= " order by date DESC";

    $sthsearch12 = $globalp->{dbh} -> prepare ($qc_count)  or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
    $sthsearch12 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
    $sthsearch12 -> bind_columns(undef, \$nrows);
    $datsearch12 = $sthsearch12 -> fetchrow_arrayref;
    $sthsearch12->finish();

    $x = 0;

    if( $fdat{query} ne "" ) {
        echo("<br><hr noshade size=\"1\"><center><b>".$globalp->{_SEARCHRESULTS}."</b></center><br><br>"
            ."<table width=\"99%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\">\n");
        if ( $nrows > 0 ) {
            $sthsearch13 = $globalp->{dbh} -> prepare ($qc)  or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
            $sthsearch13 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
            $sthsearch13 -> bind_columns(undef, \$pid,\$title,\$date);

            while($datsearch13 = $sthsearch13 -> fetchrow_arrayref) {

                $furl = "index.prc?module=Content&amp;pa=showpage&amp;pid=$pid";

                echo("<tr><td><img src=\"images/folders.gif\" border=\"0\" alt=\"\">&nbsp;<font class=\"option\"><a href=\"$furl\">$title</a></font><font class=\"content\"><br>"
                    ."<br><br><br></td></tr>\n");
                $x++;
            }
            $sthsearch13->finish();

            echo("</table>");
        } else {
            echo("<tr><td><center><font class=\"option\"><b>".$globalp->{_NOMATCHES}."</b></font></center><br><br>"
                ."</td></tr></table>");
        }

        $prev = $min - $offset;
        if( $prev >= 0 ) {
            echo("<br><br><center><a href=\"index.prc?module=Search&amp;author=$fdat{author}&amp;topic=$topic&amp;min=$prev&amp;query=$fdat{query}&amp;type=$fdat{type}\">"
                ."<b>$min ".$globalp->{_PREVMATCHES}."</b></a></center>");
        }

        $next = $min + $offset;

        if( $x >= 9 ) {
            echo("<br><br><center><a href=\"index.prc?module=Search&amp;author=$fdat{author}&amp;topic=$topic&amp;min=$max&amp;query=$fdat{query}&amp;type=$fdat{type}\">"
                ."<b>".$globalp->{_NEXTMATCHES}."</b></a></center>");
        }
    }
}



$globalp->{siteheader}(); $globalp->{theheader}();

$offset = 10;
$min = 0 if( !defined($fdat{min}) );
$min = $fdat{min} if( defined($fdat{min}) );
$max = ($min + $offset) if( !defined($max) );

if( !defined($fdat{Search}) || $fdat{Search} eq "")
{
    &display_search_form;
} 
elsif( defined($fdat{Search}) && $fdat{Search} ne "" ) 
{
    &display_search_form;
    &search_content;
}

$globalp->{CloseTable}();
if( defined($fdat{query}) && $fdat{query} ne "" && ( defined($fdat{type}) && $fdat{type} ne "" ) ) 
{
    echo("<br>");
    $globalp->{OpenTable}();
    echo("<font class=\"title\">".$globalp->{_FINDMORE}."<br><br>"
        ."".$globalp->{_DIDNOTFIND}."</font><br><br>"
        ."".$globalp->{_SEARCH}." \"<b>$fdat{query}</b>\" ".$globalp->{_ON}.":<br><br>"
        ."<ul>"
        ."$mod1"
        ."<li> <a href=\"http://www.google.com/search?q=$fdat{query}\" target=\"new\">Google</a>"
        ."<li> <a href=\"http://groups.google.com/groups?q=$fdat{query}\" target=\"new\">Google Groups</a>"
        ."</ul>");
    $globalp->{CloseTable}();
}

$globalp->{sitefooter}();

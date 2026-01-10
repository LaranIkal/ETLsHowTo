########################################################################
# Eplsite,Subroutines for Content module
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

 Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/Content/language/lang-'.$globalp->{site_language}.'.prc');


sub showpage
{

    $globalp->{OpenTable}();
    $sthshowpage = $globalp->{dbh} -> prepare ("SELECT title,subtitle,active,page_header,text,page_footer,date, counter, signature from ".$globalp->{table_prefix}."_pages where pid='$fdat{pid}'")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
    $sthshowpage -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
    $sthshowpage -> bind_columns(undef, \$title, \$subtitle, \$active, \$page_header, \$text, \$page_footer, \$date, \$counter, \$signature);
    $datshowpage = $sthshowpage -> fetchrow_arrayref;
    $sthshowpage -> finish();

    if( $active == 0 ) {
        echo("Sorry... This page doesn't exist.");
    } else {
        $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_pages set counter=counter+1 where pid='$fdat{pid}'");
        ($just_date,$just_time) = split(' ',$date);
        echo("<font class=\"title\">$title</font>\n"
            ."<p><font class=\"boxtitle\">$subtitle</font></p>\n");

        @contentpages = split( /<!--pagebreak-->/, $text );
        $pageno = @contentpages;

        if( $fdat{page} eq "" || $fdat{page} < 1 ){ $fdat{page} = 1; }

        if( $fdat{page} > $pageno ) { $fdat{page} = $pageno; }

        $arrayelement = int($fdat{page});
        $arrayelement --;
        if( $pageno > 1 ) {
            echo("".$globalp->{_PAGE}.": $fdat{page}/$pageno<br>\n");
        }
    }

    if ( $fdat{page} == 1 ) {
        $chr10 = chr(10);
        $page_header =~ s/$chr10/<br>/g;
        echo("<p align=\"justify\">$page_header</p>\n");
    }

    echo("<p align=\"justify\"> @contentpages[$arrayelement]</p>\n");

    if( $fdat{page} >= $pageno ) {
        $next_page = "";
    } else {
        $next_pagenumber = $fdat{page} + 1;
        if( $fdat{page} != 1 ) { $next_page .= "- "; }
        $next_page .= '<a href="index.prc?module=Content&pa=showpage&pid='.$fdat{pid}.'&page='.$next_pagenumber.'">'.$globalp->{_NEXT}.' ('.$next_pagenumber.'/'.$pageno.')</a> <a href="index.prc?module=Content&pa=showpage&pid='.$fdat{pid}.'&page='.$next_pagenumber.'"><img src="images/download/right.gif" border="0" alt=""'.$globalp->{_NEXT}.'"></a>';
    }

    if( $fdat{page} == $pageno ) {
        $chr10 = chr(10);
        $page_footer =~ s/$chr10/<br>/g;

        echo("<br><p align=\"justify\">$page_footer</p><br><br>\n");
    }

    if( $fdat{page} <= 1 ) {
        $previous_page = "";
    } else {
        $previous_pagenumber = $fdat{page} - 1;
        $previous_page = "<a href=\"index.prc?module=Content&pa=showpage&pid=".$fdat{pid}."&page=".$previous_pagenumber."\"><img src=\"images/download/left.gif\" border=\"0\" alt=\"".$globalp->{_PREVIOUS}."\"></a> <a href=\"index.prc?module=Content&pa=showpage&pid=".$fdat{pid}."&page=".$previous_pagenumber."\">".$globalp->{_PREVIOUS}." (".$previous_pagenumber."/".$pageno.")</a>";
    }

    echo("<center>$previous_page $next_page</center>\n");

    if( $fdat{page} == $pageno ) {
        echo("<p align=\"right\"><font class=\"tiny\">".$globalp->{_PUBLISHEDON}.": $just_date ($counter ".$globalp->{_READS}.")<br>");
		echo($globalp->{_PUBLISHEDBY}.": $signature </font></p>");
        echo("<center>".$globalp->{_GOBACK}."</center>");
    }

    $globalp->{CloseTable}();
}




sub list_pages
{

    $globalp->{print_title}($globalp->{sitename}.": ".$globalp->{_PAGESLIST});
    $globalp->{OpenTable}();

    echo("<center><font class=\"content\">".$globalp->{_LISTOFCONTENT}." $globalp->{sitename}:</center><br><br>\n");

    $sthlp = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_pages_categories")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages_categories";
    $sthlp -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages_categories";
    $sthlp -> bind_columns(undef, \$num_categories);
    $datlp = $sthlp -> fetchrow_arrayref;
    $sthlp -> finish();

    $sthlp1 = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_pages WHERE cid!='0'")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
    $sthlp1 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
    $sthlp1 -> bind_columns(undef, \$num_pages);
    $datlp1 = $sthlp1 -> fetchrow_arrayref;
    $sthlp1 -> finish();

    if( $num_categories > 0 && $num_pages > 0 )
    {
        echo("<center>".$globalp->{_CONTENTCATEGORIES}."</center><br><br>\n"
            ."<table border=\"1\" align=\"center\" width=\"95%\">\n");

        $sthlp2 = $globalp->{dbh} -> prepare ("select cid, title, description from ".$globalp->{table_prefix}."_pages_categories")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages_categories";
        $sthlp2 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages_categories";
        $sthlp2 -> bind_columns(undef, \$cid, \$title, \$description);

        while ($datlp2 = $sthlp2 -> fetchrow_arrayref) {
            $sthlp3 = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_pages WHERE cid='$cid'")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
            $sthlp3 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
            $sthlp3 -> bind_columns(undef, \$num_pages_in_cid);
            $datlp3 = $sthlp3 -> fetchrow_arrayref;
            $sthlp3 -> finish();

            if( $num_pages_in_cid > 0 ) {
                echo("<tr><td valign=\"top\">&nbsp;<a href=\"index.prc?module=Content&amp;pa=list_pages_categories&amp;cid=$cid\">$title</a>&nbsp;</td><td align=\"left\">$description</td></tr>\n");
            }
        }
        $sthlp2 -> finish();

        echo("</table><br><br>\n"
            ."<center>".$globalp->{_NONCLASSCONT}."</center><br><br>\n");

    }

    $sthlp4 = $globalp->{dbh} -> prepare ("SELECT pid, title, subtitle, clanguage from ".$globalp->{table_prefix}."_pages WHERE active='1' AND cid='0' order by date")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
    $sthlp4 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
    $sthlp4 -> bind_columns(undef, \$pid, \$title, \$subtitle, \$clanguage);

    echo("<blockquote>");

    while ( $datlp4 = $sthlp4 -> fetchrow_arrayref ) {
        if ($subtitle ne "") {
            $subtitle = " ($subtitle)";
        } else {
            $subtitle = "";
        }

        echo("<strong><big>&middot;</big></strong>$the_lang <a href=\"index.prc?module=Content&amp;pa=showpage&amp;pid=$pid\">$title</a>$subtitle<br>\n");
    }
    $sthlp4 -> finish();

    echo("</blockquote>");

    $globalp->{CloseTable}();
}




sub list_pages_categories
{

    $globalp->{print_title}($globalp->{sitename}.": ".$globalp->{_PAGESLIST});
    $globalp->{OpenTable}();

    echo("<center><font class=\"content\">".$globalp->{_LISTOFCONTENT}." $sitename:</center><br><br>\n");

    $sthlpc = $globalp->{dbh} -> prepare ("SELECT pid, title, subtitle, clanguage from ".$globalp->{table_prefix}."_pages WHERE active='1' AND cid='$fdat{cid}' order by date")  or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
    $sthlpc -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
    $sthlpc -> bind_columns(undef, \$pid, \$title, \$subtitle, \$clanguage);

    echo("<blockquote>");

    while ( $datlpc = $sthlpc -> fetchrow_arrayref ) {
        if ($subtitle != "") {
            $subtitle = " ($subtitle)";
        } else {
            $subtitle = "";
        }

        echo("<strong><big>&middot;</big></strong> $the_lang \n"
            ."<a href=\"index.prc?module=Content&amp;pa=showpage&amp;pid=$pid\">$title\n"
            ."</a>$subtitle<br>\n");
    }
    $sthlpc -> finish();

    echo("</blockquote>"
        ."<center>".$globalp->{_GOBACK}."</center>");
    $globalp->{CloseTable}();

}


    $globalp->{siteheader}();
    $globalp->{theheader}();
    if( $fdat{pa} eq "showpage" ){&showpage($pid, $page);}
    elsif( $fdat{pa} eq "list_pages_categories" ){&list_pages_categories;}
    else { &list_pages();}
    $globalp->{sitefooter}();


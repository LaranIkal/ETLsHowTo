if( $ENV{'REQUEST_URI'} =~ /admin.prc/ ){ $nothing=0; }
else{ echo("Access denied"); if( exists($ENV{MOD_PERL}) ){Apache::exit;}else{exit();} }

    $sthadmauth = $globalp->{dbh} -> prepare ("select radmincontent, radminsuper from ".$globalp->{table_prefix}."_authors where aid='$globalp->{aid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
    $sthadmauth -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
    $sthadmauth -> bind_columns(undef, \$radmincontent, \$radminsuper);
    $datadmauth = $sthadmauth -> fetchrow_arrayref;
    $sthadmauth -> finish();

    if( $radminsuper != 1 )
    {
        if( ( $radmincontent != 1 ) )
        {
            echo("Access denied!!!!"); $globalp->{clean_exit}();
        }
    }



#*********************************************************
#* Sections Manager Functions                            *
#*********************************************************

sub content()
{

    $globalp->{siteheader}(); 
	echo("<link rel=\"stylesheet\" href=\"".$globalp->{eplsite_url}."/includes/tinyeditorstyle.css\" />");
	echo("<script type=\"text/javascript\" src=\"".$globalp->{eplsite_url}."/includes/tinyeditor.js\"></script>");
	$globalp->{theheader}();
    $globalp->{GraphicAdmin}();
	echo("</div>");
    $globalp->{print_title}("".$globalp->{_CONTENTMANAGER}."");
    $globalp->{OpenTable}();
    echo("<br><center><b> [ ".$globalp->{_FMUPLOADIMG}." <a href=\"admin.prc?session=$globalp->{session}&amp;option=AdminImagesDir&amp;directory=images/content\">images/content</a> ]</b></center><br><table border=\"0\" width=\"100%\"><tr>"
             ."<td bgcolor=\"$bgcolor2\"><b>".$globalp->{_TITLE}."</b></td><td align=\"center\" bgcolor=\"$bgcolor2\"><b>".$globalp->{_CURRENTSTATUS}."</b></td><td align=\"center\" bgcolor=\"$bgcolor2\"><b>".$globalp->{_CATEGORY}."</b></td><td align=\"center\" bgcolor=\"$bgcolor2\"><b>".$globalp->{_FUNCTIONS}."</b></td></tr>");

    $sthcontadm = $globalp->{dbh} -> prepare ("select pid,cid,active,title from ".$globalp->{table_prefix}."_pages order by pid") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
    $sthcontadm -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
    $sthcontadm -> bind_columns(undef, \$ppid, \$ccid, \$aactive, \$ttitle);

    while( $datcontadm = $sthcontadm -> fetchrow_arrayref )
    {
        if( $ccid eq "0" || $ccid eq "" )
        {
            $cat_title = $globalp->{_NONE};
        }
        else
        {
            $sthcontadm1 = $globalp->{dbh} -> prepare ("select title from ".$globalp->{table_prefix}."_pages_categories where cid='$ccid'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages_categories";
            $sthcontadm1 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages_categories";
            $sthcontadm1 -> bind_columns(undef, \$cat_title);
            $datcontadm1 = $sthcontadm1 -> fetchrow_arrayref;
            $sthcontadm1 -> finish();
        }

        if( $aactive == 1 )
        {
            $status = $globalp->{_ACTIVE};
            $status_chng = $globalp->{_DEACTIVATE};
            $active = 1;
        }
        else
        {
            $status = "<i>".$globalp->{_INACTIVE}."</i>";
            $status_chng = $globalp->{_ACTIVATE};
            $active = 0;
        }

        echo("<tr><td><a href=\"index.prc?module=Content&pa=showpage&pid=$ppid\">$ttitle</a></td><td align=\"center\">$status</td><td align=\"center\">$cat_title</td><td align=\"center\">[ <a href=\"admin.prc?session=$globalp->{session}&option=content_edit&pid=$ppid\">".$globalp->{_EDIT}."</a> | <a href=\"admin.prc?session=$globalp->{session}&option=content_change_status&pid=$ppid&active=$active\">$status_chng</a> | <a href=\"admin.prc?session=$globalp->{session}&option=content_delete&pid=$ppid\">".$globalp->{_DELETE}."</a> ]</td></tr>");
    }
    $sthcontadm -> finish();

    echo("</table>");
    $globalp->{CloseTable}();
    echo("<br>");

    $globalp->{OpenTable}();
    echo("<center><b>".$globalp->{_ADDCATEGORY}."</b></center><br><br>"
             ."<form action=\"admin.prc\" method=\"post\">"
             ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">"
             ."<b>".$globalp->{_TITLE}.":</b><br><input type=\"text\" name=\"cat_title\" size=\"50\"><br><br>"
             ."<b>".$globalp->{_DESCRIPTION}.":</b><br><textarea name=\"description\" rows=\"10\" cols=\"50\"></textarea><br><br>"
             ."<input type=\"hidden\" name=\"option\" value=\"add_category\">"
             ."<input type=\"submit\" value=\"".$globalp->{_ADD}."\">"
             ."</form>");
    $globalp->{CloseTable}();

    $sthcontadm2 = $globalp->{dbh} -> prepare ("select count(*)from ".$globalp->{table_prefix}."_pages_categories order by title") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages_categories";
    $sthcontadm2 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages_categories";
    $sthcontadm2 -> bind_columns(undef, \$num_rescat);
    $datcontadm2 = $sthcontadm2 -> fetchrow_arrayref;
    $sthcontadm2 -> finish();

    if( $num_rescat > 0 )
    {
        echo("<br>");
        $globalp->{OpenTable}();
        echo("<center><b>".$globalp->{_EDITCATEGORY}."</b></center><br><br>"
                 ."<form action=\"admin.prc\" method=\"post\">"
                 ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">"
                 ."<b>".$globalp->{_CATEGORY}.":</b> "
                 ."<select name=\"cid\">");

        $sthcontadm3 = $globalp->{dbh} -> prepare ("select cid, title from ".$globalp->{table_prefix}."_pages_categories order by title") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages_categories";
        $sthcontadm3 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages_categories";
        $sthcontadm3 -> bind_columns(undef, \$cid, \$cat_title);

        while( $datcontadm3 = $sthcontadm3 -> fetchrow_arrayref )
        {
            echo("<option value=\"$cid\">$cat_title</option>");
        }
        $sthcontadm3 -> finish();

        echo("</select>&nbsp;&nbsp;"
                 ."<input type=\"hidden\" name=\"option\" value=\"edit_category\">"
                 ."<input type=\"submit\" value=\"".$globalp->{_EDIT}."\">"
                 ."</form>");
        $globalp->{CloseTable}();
    }

    echo("<br>");
    $globalp->{OpenTable}();

    $sthcontadm4 = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_pages_categories order by title") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages_categories";
    $sthcontadm4 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages_categories";
    $sthcontadm4 -> bind_columns(undef, \$counted);
    $datcontadm4 = $sthcontadm4 -> fetchrow_arrayref;
    $sthcontadm4 -> finish();

    echo("<center><b>".$globalp->{_ADDANEWPAGE}."</b></center><br><br>"
             ."<form action=\"admin.prc\" method=\"post\" onsubmit='editor.post();'>"
             ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">"
             ."<b>".$globalp->{_TITLE}.":</b><br>"
             ."<input type=\"text\" name=\"title\" size=\"50\"><br><br>");

    if( $counted > 0 )
    {
        echo("<b>".$globalp->{_CATEGORY}.":</b>&nbsp;&nbsp;"
                 ."<select name=\"cid\">"
                 ."<option value=\"0\" selected>".$globalp->{_NONE}."</option>");
        $sthcontadm5 = $globalp->{dbh} -> prepare ("select cid, title from ".$globalp->{table_prefix}."_pages_categories order by title") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages_categories";
        $sthcontadm5 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages_categories";
        $sthcontadm5 -> bind_columns(undef, \$cid, \$cat_title);

        while( $datcontadm5 = $sthcontadm5 -> fetchrow_arrayref )
        {
            echo("<option value=\"$cid\">$cat_title</option>");
        }
        $sthcontadm5 -> finish();

        echo("</select><br><br>");
    }
    else
    {
        echo("<input type=\"hidden\" name=\"cid\" value=\"0\">");
    }

    echo("<b>".$globalp->{_CSUBTITLE}.":</b><br>"
             ."<input type=\"text\" name=\"subtitle\" size=\"50\"><br><br>"
             ."<b>".$globalp->{_HEADERTEXT}.":</b><br>"
             ."<textarea name=\"page_header\" cols=\"60\" rows=\"10\"></textarea><br><br>"
             ."<b>".$globalp->{_PAGETEXT}.":</b><br>"
             ."<font class=\"tiny\">".$globalp->{_PAGEBREAK}."</font><br>"
             ."<textarea id=\"input\" name=\"text\" style=\"width:400px; height:200px\"></textarea>");
			echo("	<script type=\"text/javascript\">\n"
				."new TINY.editor.edit('editor',{ \n"
				."	id:'input',\n"
				."	width:900,\n"
				."	height:400,\n"
				."	cssclass:'te',\n"
				."	controlclass:'tecontrol',\n"
				."	rowclass:'teheader',\n"
				."	dividerclass:'tedivider',\n"
				."	controls:['bold','italic','underline','strikethrough','|','subscript','superscript','|',\n"
				."			  'orderedlist','unorderedlist','|','outdent','indent','|','leftalign',\n"
				."			  'centeralign','rightalign','blockjustify','|','unformat','|','undo','redo','n',\n"
				."			  'font','size','style','|','image','hr','link','unlink','|','cut','copy','paste','print'],\n"
				."	footer:true,\n"
				."	fonts:['Verdana','Arial','Georgia','Trebuchet MS'],\n"
				."	xhtml:true,\n"
				."	cssfile:'style.css',\n"
				."	bodyid:'editor',\n"
				."	footerclass:'tefooter',\n"
				."	toggle:{text:'source',activetext:'wysiwyg',cssclass:'toggle'},\n"
				."	resize:{cssclass:'resize'}\n"
				."});\n"
				."</script>\n");
			 
			 
			 
			 echo("<br><br>"
             ."<b>".$globalp->{_FOOTERTEXT}.":</b><br>"
             ."<textarea name=\"page_footer\" cols=\"60\" rows=\"10\"></textarea><br><br>"
             ."<b>".$globalp->{_SIGNATURE}.":</b><br>"
             ."<textarea name=\"signature\" cols=\"60\" rows=\"5\"></textarea><br><br>"
             ."<input type=\"hidden\" name=\"clanguage\" value=\"$language\">");

    echo("<b>".$globalp->{_ACTIVATEPAGE}."</b><br>"
             ."<input type=\"radio\" name=\"active\" value=\"1\" checked>&nbsp;".$globalp->{_YES}."&nbsp&nbsp;<input type=\"radio\" name=\"active\" value=\"0\">&nbsp;".$globalp->{_NO}."<br><br>"
             ."<input type=\"hidden\" name=\"option\" value=\"content_save\">"
             ."<input type=\"submit\" value=\"".$globalp->{_SEND}."\">"
             ."</form>");
    $globalp->{CloseTable}();
    $globalp->{sitefooter}();
}



sub add_category
{
    $globalp->{dbh}->do("insert into ".$globalp->{table_prefix}."_pages_categories values (NULL, '$fdat{cat_title}', '$fdat{description}')");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?session=$globalp->{session}&option=content");
}



sub edit_category
{

    $globalp->{siteheader}(); $globalp->{theheader}();
    $globalp->{GraphicAdmin}();
	echo("</div>");
    $globalp->{print_title}("".$globalp->{_CONTENTMANAGER}."");
    $globalp->{OpenTable}();
    $stheditcat = $globalp->{dbh} -> prepare ("select title, description from ".$globalp->{table_prefix}."_pages_categories where cid='$fdat{cid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages_categories";
    $stheditcat -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages_categories";
    $stheditcat -> bind_columns(undef, \$title, \$description);
    $dateditcat = $stheditcat -> fetchrow_arrayref;
    $stheditcat -> finish();

    echo("<center><b>".$globalp->{_EDITCATEGORY}."</b></center><br><br>"
             ."<form action=\"admin.prc\" method=\"post\">"
             ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">"
             ."<b>".$globalp->{_TITLE}."</b><br>"
             ."<input type=\"text\" name=\"cat_title\" value=\"$title\" size=\"50\"><br><br>"
             ."<b>".$globalp->{_DESCRIPTION}."</b>:<br>"
             ."<textarea cols=\"50\" rows=\"10\" name=\"description\">$description</textarea><br><br>"
             ."<input type=\"hidden\" name=\"cid\" value=\"$fdat{cid}\">"
             ."<input type=\"hidden\" name=\"option\" value=\"save_category\">"
             ."<input type=\"submit\" value=\"".$globalp->{_SAVECHANGES}."\">&nbsp;&nbsp;"
             ."[ <a href=\"admin.prc?session=$globalp->{session}&option=del_content_cat&amp;cid=$fdat{cid}\">".$globalp->{_DELETE}."</a> ]"
             ."</form>");
    $globalp->{CloseTable}();
    $globalp->{sitefooter}();
}



sub save_category
{
    $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_pages_categories set title='$fdat{cat_title}', description='$fdat{description}' where cid='$fdat{cid}'");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?session=$globalp->{session}&option=content");
}



sub del_content_cat
{

    if( $fdat{ok} == 1 )
    {
        $globalp->{dbh}->do("delete from ".$globalp->{table_prefix}."_pages_categories where cid='$fdat{cid}'");
        $sthdelcat = $globalp->{dbh} -> prepare ("select pid from ".$globalp->{table_prefix}."_pages where cid='$fdat{cid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
        $sthdelcat -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
        $sthdelcat -> bind_columns(undef, \$pid);

        while( $datdelcat = $sthdelcat -> fetchrow_arrayref )
        {
            $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_pages set cid='0' where pid='$pid'");
        }
        $sthdelcat -> finish();
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?session=$globalp->{session}&option=content");
    }
    else
    {
        $globalp->{siteheader}(); $globalp->{theheader}();
        $globalp->{GraphicAdmin}();
		echo("</div>");
        $globalp->{print_title}("".$globalp->{_CONTENTMANAGER}."");
        $sthdelcat1 = $globalp->{dbh} -> prepare ("select title from ".$globalp->{table_prefix}."_pages_categories where cid='$fdat{cid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
        $sthdelcat1 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
        $sthdelcat1 -> bind_columns(undef, \$title);
        $datdelcat1 = $sthdelcat1 -> fetchrow_arrayref;
        $sthdelcat1 -> finish();

        $globalp->{OpenTable}();
        echo("<center><b>".$globalp->{_DELCATEGORY}.": $title</b><br><br>"
                 ."".$globalp->{_DELCONTENTCAT}."<br><br>"
                 ."[ <a href=\"admin.prc?session=$globalp->{session}&option=content\">".$globalp->{_NO}."</a> | <a href=\"admin.prc?session=$globalp->{session}&option=del_content_cat&amp;cid=$fdat{cid}&amp;ok=1\">".$globalp->{_YES}."</a> ]</center>");
        $globalp->{CloseTable}();
        $globalp->{sitefooter}();
    }
}



sub content_edit
{

    $globalp->{siteheader}();
	echo("<link rel=\"stylesheet\" href=\"".$globalp->{eplsite_url}."/includes/tinyeditorstyle.css\" />");
	echo("<script type=\"text/javascript\" src=\"".$globalp->{eplsite_url}."/includes/tinyeditor.js\"></script>");	
	$globalp->{theheader}();
    $globalp->{GraphicAdmin}();
	echo("</div>");
    $globalp->{print_title}("".$globalp->{_CONTENTMANAGER}."");
    $sthedcnt1 = $globalp->{dbh} -> prepare ("select cid,title,active, subtitle, page_header, text, page_footer, signature, clanguage from ".$globalp->{table_prefix}."_pages WHERE pid='$fdat{pid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
    $sthedcnt1 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
    $sthedcnt1 -> bind_columns(undef, \$ccid,\$ttitle,\$aactive, \$ssubtitle, \$ppage_header, \$ttext, \$ppage_footer, \$ssignature, \$cclanguage);
    $datedcnt1 = $sthedcnt1 -> fetchrow_arrayref;
    $sthedcnt1 -> finish();

    if( $aactive == 1 )
    {
       $sel1 = "checked";
       $sel2 = "";
    }
    else
    {
        $sel1 = "";
        $sel2 = "checked";
    }
    $globalp->{OpenTable}();
    echo("<center><b>".$globalp->{_EDITPAGECONTENT}."</b></center><br><br>"
             ."<form action=\"admin.prc\" method=\"post\" onsubmit='editor.post();'>"
             ."<input type=\"hidden\" name=\"session\" value=\"$globalp->{session}\">"
             ."<b>".$globalp->{_TITLE}.":</b><br>"
             ."<input type=\"text\" name=\"title\" size=\"50\" value=\"$ttitle\"><br><br>");

    $sthedcnt2 = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_pages_categories") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages_categories";
    $sthedcnt2 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages_categories";
    $sthedcnt2 -> bind_columns(undef, \$counted);
    $datedcnt2 = $sthedcnt2 -> fetchrow_arrayref;
    $sthedcnt2 -> finish();

    if( $counted > 0 )
    {
        echo("<b>".$globalp->{_CATEGORY}.":</b>&nbsp;&nbsp;"
                 ."<select name=\"cid\">");
        if( $ccid == 0 ) {
            $sel = "selected";
        } else {
            $sel = "";
        }

        echo("<option value=\"0\" $sel>".$globalp->{_NONE}."</option>");
        $sthedcnt3 = $globalp->{dbh} -> prepare ("select cid, title from ".$globalp->{table_prefix}."_pages_categories") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages_categories";
        $sthedcnt3 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages_categories";
        $sthedcnt3 -> bind_columns(undef, \$cid,\$cat_title);

        while( $datedcnt3 = $sthedcnt3 -> fetchrow_arrayref )
        {
            if( $ccid == $cid ) {
                $sel = "selected";
            } else {
                $sel = "";
            }
            echo("<option value=\"$cid\" $sel>$cat_title</option>");
        }
        $sthedcnt3 -> finish();

        echo("</select><br><br>");
    }
    else
    {
        echo("<input type=\"hidden\" name=\"cid\" value=\"0\">");
    }
    echo("<b>".$globalp->{_CSUBTITLE}.":</b><br>"
             ."<input type=\"text\" name=\"subtitle\" size=\"50\" value=\"$ssubtitle\"><br><br>"
             ."<b>".$globalp->{_HEADERTEXT}.":</b><br>"
             ."<textarea name=\"page_header\" cols=\"60\" rows=\"10\">$ppage_header</textarea><br><br>"
             ."<b>".$globalp->{_PAGETEXT}.":</b><br>"
             ."<font class=\"tiny\">".$globalp->{_PAGEBREAK}."</font><br>"
			 ."<textarea id=\"input\" name=\"text\" style=\"width:400px; height:200px\">$ttext</textarea>");
		echo("	<script type=\"text/javascript\">\n"
			."new TINY.editor.edit('editor',{ \n"
			."	id:'input',\n"
			."	width:900,\n"
			."	height:400,\n"
			."	cssclass:'te',\n"
			."	controlclass:'tecontrol',\n"
			."	rowclass:'teheader',\n"
			."	dividerclass:'tedivider',\n"
			."	controls:['bold','italic','underline','strikethrough','|','subscript','superscript','|',\n"
			."			  'orderedlist','unorderedlist','|','outdent','indent','|','leftalign',\n"
			."			  'centeralign','rightalign','blockjustify','|','unformat','|','undo','redo','n',\n"
			."			  'font','size','style','|','image','hr','link','unlink','|','cut','copy','paste','print'],\n"
			."	footer:true,\n"
			."	fonts:['Verdana','Arial','Georgia','Trebuchet MS'],\n"
			."	xhtml:true,\n"
			."	cssfile:'style.css',\n"
			."	bodyid:'editor',\n"
			."	footerclass:'tefooter',\n"
			."	toggle:{text:'source',activetext:'wysiwyg',cssclass:'toggle'},\n"
			."	resize:{cssclass:'resize'}\n"
			."});\n"
			."</script>\n");

			 echo("<br><br>"
             ."<b>".$globalp->{_FOOTERTEXT}.":</b><br>"
             ."<textarea name=\"page_footer\" cols=\"60\" rows=\"10\">$ppage_footer</textarea><br><br>"
             ."<b>".$globalp->{_SIGNATURE}.":</b><br>"
             ."<textarea name=\"signature\" cols=\"60\" rows=\"5\">$ssignature</textarea><br><br>"
             ."<input type=\"hidden\" name=\"clanguage\" value=\"$cclanguage\">"
             ."<b>".$globalp->{_ACTIVATEPAGE}."</b><br>"
             ."<input type=\"radio\" name=\"active\" value=\"1\" $sel1>&nbsp;".$globalp->{_YES}."&nbsp&nbsp;<input type=\"radio\" name=\"active\" value=\"0\" $sel2>&nbsp;".$globalp->{_NO}."<br><br>"
             ."<input type=\"hidden\" name=\"pid\" value=\"$fdat{pid}\">"
             ."<input type=\"hidden\" name=\"option\" value=\"content_save_edit\">"
             ."<input type=\"submit\" value=\"".$globalp->{_SAVECHANGES}."\">"
             ."</form>");
    $globalp->{CloseTable}();
    $globalp->{sitefooter}();
}



sub content_save
{
    #~ echo("El texto:".$fdat{text});exit;
	
	$fdat{text} = $globalp->{FixSlashesAndQuotes}($fdat{text});
	
	$globalp->{dbh}->do("insert into ".$globalp->{table_prefix}."_pages values (NULL, '$fdat{cid}', '$fdat{title}', '$fdat{subtitle}', '$fdat{active}', '$fdat{page_header}', '$fdat{text}', '$fdat{page_footer}', '$fdat{signature}', now(), '0', '$fdat{clanguage}')");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?session=$globalp->{session}&option=content");
}



sub content_save_edit
{
	#~ echo("El texto:".$fdat{text});exit;
	$fdat{text} = $globalp->{FixSlashesAndQuotes}($fdat{text});
	$updatequery = "UPDATE ".$globalp->{table_prefix}."_pages SET cid='$fdat{cid}', title='$fdat{title}',";
	$updatequery .= " subtitle='$fdat{subtitle}', active='$fdat{active}', page_header='$fdat{page_header}',";
	$updatequery .= " text='$fdat{text}', page_footer='$fdat{page_footer}', signature='$fdat{signature}', ";
	$updatequery .= " clanguage='$fdat{clanguage}' WHERE pid='$fdat{pid}'";
	#~ echo($updatequery); exit;
    $globalp->{dbh}->do($updatequery);
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?session=$globalp->{session}&option=content");
}



sub content_change_status
{
    if( $fdat{active} == 1 ) {
        $new_active = 0;
    } elsif( $fdat{active} == 0 ) {
        $new_active = 1;
    }
    $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_pages set active='$new_active' WHERE pid='$fdat{pid}'");
    $globalp->{cleanup}();
    &redirect_url_to("admin.prc?session=$globalp->{session}&option=content");
}



sub content_delete
{

    if( $fdat{ok} == 1 )
    {
        $globalp->{dbh}->do("delete from ".$globalp->{table_prefix}."_pages where pid='$fdat{pid}'");
        $globalp->{cleanup}();
        &redirect_url_to("admin.prc?session=$globalp->{session}&option=content");
    }
    else
    {
        $globalp->{siteheader}(); $globalp->{theheader}();
        $globalp->{GraphicAdmin}();
		echo("</div>");
        $globalp->{print_title}("".$globalp->{_CONTENTMANAGER}."");
        $sthdelcnt1 = $globalp->{dbh} -> prepare ("select title from ".$globalp->{table_prefix}."_pages where pid='$fdat{pid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_pages";
        $sthdelcnt1 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_pages";
        $sthdelcnt1 -> bind_columns(undef, \$title);
        $datdelcnt1 = $sthdelcnt1 -> fetchrow_arrayref;
        $sthdelcnt1 -> finish();

        $globalp->{OpenTable}();
        echo("<center><b>".$globalp->{_DELCONTENT}.": $title</b><br><br>"
                 ."".$globalp->{_DELCONTWARNING}." $title?<br><br>"
                 ."[ <a href=\"admin.prc?session=$globalp->{session}&option=content\">".$globalp->{_NO}."</a> | <a href=\"admin.prc?session=$globalp->{session}&option=content_delete&amp;pid=$fdat{pid}&amp;ok=1\">".$globalp->{_YES}."</a> ]</center>");
        $globalp->{CloseTable}();
        $globalp->{sitefooter}();
    }
}

    if( $fdat{option} eq "content" ){ &content(); }
    elsif( $fdat{option} eq "content_edit" ){ &content_edit;}
    elsif( $fdat{option} eq "content_delete" ){ &content_delete;}
    elsif( $fdat{option} eq "content_review" ){ &content_review;}
    elsif( $fdat{option} eq "content_save" ){ &content_save;}
    elsif( $fdat{option} eq "content_save_edit" ){ &content_save_edit;}
    elsif( $fdat{option} eq "content_change_status" ){ &content_change_status;}
    elsif( $fdat{option} eq "add_category" ){ &add_category;}
    elsif( $fdat{option} eq "edit_category" ){ &edit_category;}
    elsif( $fdat{option} eq "save_category" ){ &save_category;}
    elsif( $fdat{option} eq "del_content_cat" ){ &del_content_cat;}


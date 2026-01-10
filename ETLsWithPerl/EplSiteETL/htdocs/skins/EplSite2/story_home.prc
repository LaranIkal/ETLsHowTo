
    echo("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" bgcolor=\"#ffffff\" width=\"100%\"><tr><td>\n"
             ."<table border=\"0\" cellpadding=\"1\" cellspacing=\"0\" bgcolor=\"$globalp->{bgcolor1}\" width=\"100%\"><tr><td>\n"
             ."<table border=\"0\" cellpadding=\"3\" cellspacing=\"0\" bgcolor=\"$globalp->{bgcolor2}\" width=\"100%\"><tr><td align=\"left\">\n");

    echo("<font color=\"#ffffff\"><b>$globalp->{title}</b></font>\n"
             ."</td></tr></table></td></tr></table>\n"
             ."<a href=\"index.prc?module=News;new_topic=$globalp->{topicid}\">\n"
             ."<img src=\"images/topics/$globalp->{topicimage}\" border=\"0\" Alt=\"$globalp->{topictext}\"\n"
             ." align=\"right\" hspace=\"10\" vspace=\"10\"></a>\n"
             ."<font class=\"content\">\n"
             ."$globalp->{content}\n");

    echo("</font>\n"
             ."</td></tr></table>\n"
             ."<table border=\"0\" cellpadding=\"1\" cellspacing=\"0\" bgcolor=\"$globalp->{bgcolor1}\" width=\"100%\"><tr><td>\n"
             ."<table border=\"0\" cellpadding=\"3\" cellspacing=\"0\" bgcolor=\"$globalp->{bgcolor1}\" width=\"100%\"><tr><td align=\"center\">\n"
             ."<hr style=\"height: 2px; width: 60%;\">\n"
             ."<font class=\"content\">\n");

    echo("$globalp->{posted}</font><br><font class=\"content\"> $globalp->{morelink}</font>\n");

    echo("</td></tr></table></td></tr></table>"
             ."<br><br><br>");


    echo("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" bgcolor=\"#ffffff\" width=\"100%\"><tr><td>\n"
             ."<table border=\"0\" cellpadding=\"1\" cellspacing=\"0\" bgcolor=\"$globalp->{bgcolor1}\" width=\"100%\"><tr><td>\n"
             ."<table border=\"0\" cellpadding=\"3\" cellspacing=\"0\" bgcolor=\"$globalp->{bgcolor2}\" width=\"100%\"><tr><td align=\"left\">\n"
             . "<font class=\"option\" color=\"#ffffff\"><b>$globalp->{title}</b></font><br>\n"
             ."<font class=\"content\">$globalp->{posted}</font>\n"
             ."</td></tr></table></td></tr></table><br>\n"
             ."<a href=\"index.epl?module=News;new_topic=$globalp->{topicid}\">\n"
             ."<img src=\"images/topics/$globalp->{topicimage}\" border=\"0\" \n"
             ."Alt=\"$globalp->{topictext}\" align=\"right\" hspace=\"10\" vspace=\"10\"></a>\n"
             ."<font class=\"content\">$globalp->{content}</font>\n"
             ."</td></tr></table><br>\n");


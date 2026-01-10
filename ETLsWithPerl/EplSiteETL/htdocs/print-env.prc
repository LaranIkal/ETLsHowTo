#!/home/laran/eplsite/Perl64/bin/perl -X


#~ print "200 ok\n";
echo("<HTML>\n"
  ."<HEAD>\n"
  ."<TITLE>echo cgi env. vars.</TITLE>\n"
  ."<H2>Echo CGI Environment Variables</H2>\n"
  ."</HEAD>\n"
  ."<BODY>\n"
  ."<HR>\n"
  ."<H3>Environment Variables</H3>\n"
  ."<UL>\n"
);
    
foreach $key (keys %ENV) {
  echo("<LI>$key = $ENV{$key}\n");
}

echo("</UL>\n"
  ."</BODY>\n"
  ."</HTML>\n"
);

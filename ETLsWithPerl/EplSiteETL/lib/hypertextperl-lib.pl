###################################################################################
#
#   perlparser - Copyright (c) March 2004 Carlos Kassab
#
#	This is cgi useful to parse perl code or embeded perl code in html files.
#	You can keep your files under your htdocs directory and perlparser.pl
#	Executes them from there
#
#	Perl Parser is not adding extra load to the programs, it is only parsing the files.
#	AND in the case of htpl files it is only translating to perl code and the evaluating it.
#
#	The file perparserlib.pl is using cgi-lib.pl( To read forms and upload files)
#   and a modified version cookielib.pl ( to manage cookies )
#   and these libraries are copyrighted from their own authors.
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#   For use with Apache httpd and mod_perl, see also Apache copyright.
#
#   THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
###################################################################################



# Perl Routines to Manipulate CGI input
# cgi-lib@pobox.com
# $Id: cgi-lib.pl,v 2.18 1999/02/23 08:16:43 brenner Exp $
#
# Copyright (c) 1993-1999 Steven E. Brenner
# Unpublished work.
# Permission granted to use and modify this library so long as the
# copyright above is maintained, modifications are documented, and
# credit is given for any use of the library.
#
# Thanks are due to many people for reporting bugs and suggestions

# For more information, see:
#     http://cgi-lib.stanford.edu/cgi-lib/

$cgi_lib'version = sprintf("%d.%02d", q$Revision: 2.18 $ =~ /(\d+)\.(\d+)/);

# Parameters affecting cgi-lib behavior
# User-configurable parameters affecting file upload.
#$cgi_lib'maxdata    = 131072;    # maximum bytes to accept via POST - 2^17
$cgi_lib'maxdata    = 204800000;    # maximum bytes to accept via POST
$cgi_lib'writefiles =      0;    # directory to which to write files, or
                                 # 0 if files should not be written
$cgi_lib'filepre    = "hypertextperlb"; # Prefix of file names, in directory above

# Do not change the following parameters unless you have special reasons
$cgi_lib'bufsize  =  8192;    # default buffer size when reading multipart
$cgi_lib'maxbound =   100;    # maximum boundary length to be encounterd
$cgi_lib'headerout =    0;    # indicates whether the header has been printed


# ReadParse
# Reads in GET or POST data, converts it to unescaped text, and puts
# key/value pairs in %in, using "\0" to separate multiple selections

# Returns >0 if there was input, 0 if there was no input
# undef indicates some failure.

# Now that cgi scripts can be put in the normal file space, it is useful
# to combine both the form and the script in one place.  If no parameters
# are given (i.e., ReadParse returns FALSE), then a form could be output.

# If a reference to a hash is given, then the data will be stored in that
# hash, but the data from $in and @in will become inaccessable.
# If a variable-glob (e.g., *cgi_input) is the first parameter to ReadParse,
# information is stored there, rather than in $in, @in, and %in.
# Second, third, and fourth parameters fill associative arrays analagous to
# %in with data relevant to file uploads.

# If no method is given, the script will process both command-line arguments
# of the form: name=value and any text that is in $ENV{'QUERY_STRING'}
# This is intended to aid debugging and may be changed in future releases

sub ReadParse
{
	# Disable warnings as this code deliberately uses local and environment
	# variables which are preset to undef (i.e., not explicitly initialized)
	my ($perlwarn);
	$perlwarn = $^W;
	$^W = 0;

	local (*in) = shift if @_;    # CGI input
	local (*incfn,                # Client's filename (may not be provided)
		*inct,                 # Client's content-type (may not be provided)
		*insfn) = @_;          # Server's filename (for spooled files)
	local ($len, $type, $meth, $errflag, $cmdflag, $got, $name);

	binmode(STDIN);   # we need these for DOS-based systems
	binmode(STDOUT);  # and they shouldn't hurt anything else
	binmode(STDERR);

	# Get several useful env variables
	$type = $ENV{'CONTENT_TYPE'};
	$len  = $ENV{'CONTENT_LENGTH'};
	$meth = $ENV{'REQUEST_METHOD'};

	$EplSiteFormType = "";
	if($ENV{'CONTENT_TYPE'} =~ m#^multipart/form-data#)
	{
		$EplSiteFormType = "MultipartForm";
	}

	if ($len > $cgi_lib'maxdata) { #'
		&CgiDie("hypertextperl: Request to receive too much data: $len bytes\n");
	}

	if ( (!defined $meth || $meth eq '' || $meth eq 'GET' ||
      $meth eq 'HEAD' ||
      $type eq 'application/x-www-form-urlencoded' || 
	  $meth eq 'POST' ) && $EplSiteFormType eq "" ) 
	{
			#~ echo($EplSiteFormType); exit;
		local ($key, $val, $i);

		# Read in text
		if (!defined $meth || $meth eq '')	{
			$in = $ENV{'QUERY_STRING'};
			$cmdflag = 1;  # also use command-line options
		}
		elsif($meth eq 'GET' || $meth eq 'HEAD') {
			$in = $ENV{'QUERY_STRING'};
		}
		elsif ($meth eq 'POST') {
			if (($got = read(STDIN, $in, $len) != $len)){$errflag="Short Read: wanted $len, got $got\n";}
		} else { &CgiDie("hypertextperl: Unknown request method: $meth\n"); }

		@in = split(/[&;]/,$in);
		push(@in, @ARGV) if $cmdflag; # add command-line parameters

		foreach $i (0 .. $#in) {
			# Convert plus to space			
			$in[$i] =~ s/\+/ /g;

			#~ $in[$i] =~ s/%2B/\+/g;
			# Split into key and value.
			($key, $val) = split(/=/,$in[$i],2); # splits on the first =.

			# Convert %XX from hex numbers to alphanumeric
			$val =~ s/%5C/\\/g;
			$val =~ s/%5E/\^/g;
			$val =~ s/%5B/[/g;
			$val =~ s/%5D/]/g;
			$val =~ s/unsignomas/\+/g;
			
			$key =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;
			$val =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;

			# Associate key and value
			$in{$key} .= "\0" if (defined($in{$key})); # \0 is the multiple separator
			$in{$key} .= $val;
			#~ echo($val);
		}

	}
	elsif ($ENV{'CONTENT_TYPE'} =~ m#^multipart/form-data#) {
		# for efficiency, compile multipart code only if needed
        
		$errflag = !(eval <<'END_MULTIPART');

		local ($buf, $boundary, $head, @heads, $cd, $ct, $fname, $ctype, $blen);
		local ($bpos, $lpos, $left, $amt, $fn, $ser);
		local ($bufsize, $maxbound, $writefiles) =
		($cgi_lib'bufsize, $cgi_lib'maxbound, $cgi_lib'writefiles);


		# The following lines exist solely to eliminate spurious warning messages
		$buf = '';

		($boundary) = $type =~ /boundary="([^"]+)"/; #";   # find boundary
		($boundary) = $type =~ /boundary=(\S+)/ unless $boundary;
		&CgiDie ("Boundary not provided: probably a bug in your server")
		unless $boundary;
		$boundary =  "--" . $boundary;
		$blen = length ($boundary);

		if ($ENV{'REQUEST_METHOD'} ne 'POST') { &CgiDie("Invalid request method for  multipart/form-data: $meth\n"); }

		if ($writefiles) {
			local($me);
			stat ($writefiles);
			$writefiles = "/tmp" unless  -d _ && -w _;
			# ($me) = $0 =~ m#([^/]*)$#;
			$writefiles .= "/$cgi_lib'filepre";
		}

		# read in the data and split into parts:
		# put headers in @in and data in %in
		# General algorithm:
		#   There are two dividers: the border and the '\r\n\r\n' between
		# header and body.  Iterate between searching for these
		#   Retain a buffer of size(bufsize+maxbound); the latter part is
		# to ensure that dividers don't get lost by wrapping between two bufs
		#   Look for a divider in the current batch.  If not found, then
		# save all of bufsize, move the maxbound extra buffer to the front of
		# the buffer, and read in a new bufsize bytes.  If a divider is found,
		# save everything up to the divider.  Then empty the buffer of everything
		# up to the end of the divider.  Refill buffer to bufsize+maxbound
		#   Note slightly odd organization.  Code before BODY: really goes with
		# code following HEAD:, but is put first to 'pre-fill' buffers.  BODY:
		# is placed before HEAD: because we first need to discard any 'preface,'
		# which would be analagous to a body without a preceeding head.

		$left = $len;
		PART: # find each part of the multi-part while reading data
		while (1)
		{
			die $@ if $errflag;

			$amt = ($left > $bufsize+$maxbound-length($buf)
			?  $bufsize+$maxbound-length($buf): $left);
			$errflag = (($got = read(STDIN, $buf, $amt, length($buf))) != $amt);
			die "Short Read: wanted $amt, got $got\n" if $errflag;
			$left -= $amt;

			$in{$name} .= "\0" if defined $in{$name};
			$in{$name} .= $fn if $fn;

			$name=~/([-\w]+)/;  # This allows $insfn{$name} to be untainted
			if (defined $1) {
				$insfn{$1} .= "\0" if defined $insfn{$1};
				$insfn{$1} .= $fn if $fn;
			}

			BODY:
			while (($bpos = index($buf, $boundary)) == -1)
			{
				if ($left == 0 && $buf eq '') {
					foreach $value (values %insfn) { unlink(split("\0",$value)); }
					&CgiDie("hypertextperl: reached end of input while seeking boundary " .
					"of multipart. Format of CGI input is wrong.\n");
				}
				die $@ if $errflag;
				if ($name)
				{  # if no $name, then it's the prologue -- discard
					if ($fn) { print FILE substr($buf, 0, $bufsize); }
					else{ $in{$name} .= substr($buf, 0, $bufsize); }
				}
				$buf = substr($buf, $bufsize);
				$amt = ($left > $bufsize ? $bufsize : $left); #$maxbound==length($buf);
				$errflag = (($got = read(STDIN, $buf, $amt, length($buf))) != $amt);
				die "Short Read: wanted $amt, got $got\n" if $errflag;
				$left -= $amt;
			}

			if (defined $name)
			{  # if no $name, then it's the prologue -- discard
				if ($fn) { print FILE substr($buf, 0, $bpos-2); }
				else { $in {$name} .= substr($buf, 0, $bpos-2); } # kill last \r\n
			}

			close (FILE);
			last PART if substr($buf, $bpos + $blen, 2) eq "--";

			substr($buf, 0, $bpos+$blen+2) = '';
			$amt = ($left > $bufsize+$maxbound-length($buf)
				? $bufsize+$maxbound-length($buf) : $left);
			$errflag = (($got = read(STDIN, $buf, $amt, length($buf))) != $amt);
			die "Short Read: wanted $amt, got $got\n" if $errflag;
			$left -= $amt;


			undef $head;  undef $fn;
			HEAD:
			while (($lpos = index($buf, "\r\n\r\n")) == -1)
			{
				if ($left == 0  && $buf eq '') {
					foreach $value (values %insfn) { unlink(split("\0",$value)); }
					&CgiDie("hypertextperl: reached end of input while seeking end of " .
					"headers. Format of CGI input is wrong.\n$buf");
				}
				die $@ if $errflag;
				$head .= substr($buf, 0, $bufsize);
				$buf = substr($buf, $bufsize);
				$amt = ($left > $bufsize ? $bufsize : $left); #$maxbound==length($buf);
				$errflag = (($got = read(STDIN, $buf, $amt, length($buf))) != $amt);
				die "Short Read: wanted $amt, got $got\n" if $errflag;
				$left -= $amt;
			}

			$head .= substr($buf, 0, $lpos+2);
			push (@in, $head);
			@heads = split("\r\n", $head);
			($cd) = grep (/^\s*Content-Disposition:/i, @heads);
			($ct) = grep (/^\s*Content-Type:/i, @heads);

			($name) = $cd =~ /\bname="([^"]+)"/i; #";
			($name) = $cd =~ /\bname=([^\s:;]+)/i unless defined $name;

			($fname) = $cd =~ /\bfilename="([^"]*)"/i; #"; # filename can be null-str
			($fname) = $cd =~ /\bfilename=([^\s:;]+)/i unless defined $fname;
			$incfn{$name} .= (defined $in{$name} ? "\0" : "") .
				(defined $fname ? $fname : "");

			($ctype) = $ct =~ /^\s*Content-type:\s*"([^"]+)"/i;  #";
			($ctype) = $ct =~ /^\s*Content-Type:\s*([^\s:;]+)/i unless defined $ctype;
			$inct{$name} .= (defined $in{$name} ? "\0" : "") . $ctype;

			if ($writefiles && defined $fname) {
				$ser++;
				$fn = $writefiles . ".$$.$ser";
				open (FILE, ">$fn") || &CgiDie("Couldn't open $fn\n");
				binmode (FILE);  # write files accurately
			}
			substr($buf, 0, $lpos+4) = '';
			undef $fname;
			undef $ctype;
		} #end while (1)

1;
END_MULTIPART
		if ($errflag) {
			local ($errmsg, $value);
			$errmsg = $@ || $errflag;
			foreach $value (values %insfn) { unlink(split("\0",$value)); 	}
			&CgiDie($errmsg);
		} else { # everything's ok.
			}
	} else { &CgiDie("hypertextperl: Unknown Content-type: $ENV{'CONTENT_TYPE'}\n"); }

	# no-ops to avoid warnings
	$insfn = $insfn;
	$incfn = $incfn;
	$inct  = $inct;

	$^W = $perlwarn;

	return ($errflag ? undef :  scalar(@in));
}


# PrintHeader
# Returns the magic line which tells WWW that we're an HTML document

sub PrintHeader { $PrintHeader = 1; return "Content-type: text/html; charset=iso-8859-1\n\n"; }


# SplitParam
# Splits a multi-valued parameter into a list of the constituent parameters

sub SplitParam
{
	local ($param) = @_;
	local (@params) = split ("\0", $param);
	return (wantarray ? @params : $params[0]);
}


# MethGet
# Return true if this cgi call was using the GET request, false otherwise

sub MethGet { return (defined $ENV{'REQUEST_METHOD'} && $ENV{'REQUEST_METHOD'} eq "GET"); }


# MethPost
# Return true if this cgi call was using the POST request, false otherwise

sub MethPost { return (defined $ENV{'REQUEST_METHOD'} && $ENV{'REQUEST_METHOD'} eq "POST"); }


# MyBaseUrl
# Returns the base URL to the script (i.e., no extra path or query string)
sub MyBaseUrl
{
	local ($ret, $perlwarn);
	$perlwarn = $^W; $^W = 0;
	$ret = 'http://' . $ENV{'SERVER_NAME'} .
	($ENV{'SERVER_PORT'} != 80 ? ":$ENV{'SERVER_PORT'}" : '') .
	$ENV{'SCRIPT_NAME'};
	$^W = $perlwarn;

	return $ret;
}


# MyFullUrl
# Returns the full URL to the script (i.e., with extra path or query string)
sub MyFullUrl
{
	local ($ret, $perlwarn);
	$perlwarn = $^W; $^W = 0;
	$ret = 'http://' . $ENV{'SERVER_NAME'} .
	($ENV{'SERVER_PORT'} != 80 ? ":$ENV{'SERVER_PORT'}" : '') .
	$ENV{'SCRIPT_NAME'} . $ENV{'PATH_INFO'};
	#(length ($ENV{'QUERY_STRING'}) ? "?$ENV{'QUERY_STRING'}" : '');
	$^W = $perlwarn;

	return $ret;
}


# MyURL
# Returns the base URL to the script (i.e., no extra path or query string)
# This is obsolete and will be removed in later versions
sub MyURL {	return &MyBaseUrl; }


# CgiError
# Prints out an error message which which containes appropriate headers,
# markup, etcetera.
# Parameters:
#  If no parameters, gives a generic error message
#  Otherwise, the first parameter will be the title and the rest will
#  be given as different paragraphs of the body

sub CgiError
{
	local (@msg) = @_;
	local ($i,$name);

	if (!@msg) {
		$name = &MyFullUrl;
		@msg = ("Error: script $name encountered fatal error\n");
	};

	if (!$cgi_lib'headerout) { #')
		print &PrintHeader if( defined($NoPpDH) );
		print "<html>\n<head>\n<title>$msg[0]</title>\n</head>\n<body>\n";
	}

	print "<h1>$msg[0]</h1>\n";
	foreach $i (1 .. $#msg){ print "<p>$msg[$i]</p>\n"; }

	$cgi_lib'headerout++;
}


# CgiDie
# Identical to CgiError, but also quits with the passed error message.

sub CgiDie {	local (@msg) = @_;	&CgiError (@msg);	die @msg; }


# PrintVariables
# Nicely formats variables.  Three calling options:
# A non-null associative array - prints the items in that array
# A type-glob - prints the items in the associated assoc array
# nothing - defaults to use %in
# Typical use: &PrintVariables()

sub PrintVariables
{
	local (*in) = @_ if @_ == 1;
	local (%in) = @_ if @_ > 1;
	local ($out, $key, $output);

	$output =  "\n<dl compact>\n";
	foreach $key (sort keys(%in)) {
		foreach (split("\0", $in{$key})) {
			($out = $_) =~ s/\n/<br>\n/g;
			$output .=  "<dt><b>$key</b>\n <dd>:<i>$out</i>:<br>\n";
		}
	}

	$output .=  "</dl>\n";

	return $output;
}

# PrintEnv
# Nicely formats all environment variables and returns HTML string
sub PrintEnv { &PrintVariables(*ENV); }


#redirecting printing a header, faster than redirect_url_to_old
#&redirect_url_to("http://www.eplsite.org?firstparam=value1&secondparam=value2");
#&redirect_url_to("index.prc?sesion=$sesion&option=mttopaises");
sub redirect_url_to { my $Redirect_To_Target_URL = shift; print "Location: $Redirect_To_Target_URL\n\n"; }


#Sys_Actual_Date
# Sys_Actual_Date("DATE") Return Date
# Sys_Actual_Date("TIME") Return Time
# Sys_Actual_Date("BOTH") Return Date And Time
sub Sys_Actual_Date
{
    my $the_type = shift; my $my_now;

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$ydat,$isdst) = localtime(time);
    $mymonth = int($mon)+1;
	$mday = "0".$mday if( $mday < 10 );
    $mymonth = "0".$mymonth if( $mymonth < 10 );
    $year += 1900;
    if( $the_type eq "DATE" ){ $my_now=$year."-".$mymonth."-".$mday; }
    elsif( $the_type eq "TIME" ){ $my_now=$hour.":".$min.":".$sec; }
    elsif( $the_type eq "BOTH" ){ $my_now=$year."-".$mymonth."-".$mday." ".$hour.":".$min.":".$sec; }
    return($my_now);
}

# The following lines exist only to avoid warning messages
$cgi_lib'writefiles =  $cgi_lib'writefiles;
$cgi_lib'bufsize    =  $cgi_lib'bufsize ;
$cgi_lib'maxbound   =  $cgi_lib'maxbound;
$cgi_lib'version    =  $cgi_lib'version;
$cgi_lib'filepre    =  $cgi_lib'filepre;



#################################################################################################################
############################################# COOKIE LIBS #######################################################
#################################################################################################################
##
# The Perl Routines to Manipulate Web Browser Cookies are based on cookie-lib.pl, i did some changes.
# kovacsp@egr.uri.edu
# $Id: cookie-lib.txt,v 0.913 1998/11/20 19:45:36 kovacsp Exp $
#
# Copyright (c) 1998 Peter D. Kovacs
# Unpublished work.
#
#
#
#$cookie{MyCookie} = "MyValue";
#&set_cookie($expiration, $domain, $path, $secure);
#&get_cookie();
#&delete_cookie("MyCookie");
#
#
#    &get_cookie();
#
#This reads in information from the HTTP_COOKIE environmental variable, splits it up into name=value pairs
#and stuffs those into the %cookie hash.  If for some reason you need the cookie-raw data, it's available
#inside a script as $ENV{HTTP_COOKIE} or $ENV{COOKIE}.

sub get_cookie {
  my($chip, $val);

  $raw_cookie = $ENV{HTTP_COOKIE} || $ENV{COOKIE};

  foreach (split(/; /, $raw_cookie)) {
    	# split cookie at each ; (cookie format is name=value; name=value; etc...)
    	# Convert plus to space (in case of encoding (not necessary, but recommended)
		s/\+/ /g;
    	# Split into key and value.
    ($chip, $val) = split(/=/,$_,2); # splits on the first =.
    	# Convert %XX from hex numbers to alphanumeric
    $chip =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;
    $val =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;
    	# Associate key and value
    $cookie{$chip} .= "\1" if (defined($cookie{$chip})); # \1 is the multiple separator
    $cookie{$chip} .= $val;
  }

  return(%cookie);
}



sub set_cookie
{
  # $expires must be in seconds from now, if defined.  If not defined it sets the expiration "".
  # If you want no expiration date set, set $expires = -1 (this causes the cookie to be deleted when user closes
  # his/her browser).
  # I could not set expiration to Encripted cookies.
  #Cookies not encripted need to check how to delete.

	my ($cookiename, $cookievalue, $expires, $domain, $path, $secu) = @_;

	my($sec,$min,$hour,$mday,$mon,$year,$wday);

	$path=~ s/ //g;
	$domain=~ s/ //g;

	$cookie{$cookiename} = $cookievalue;

    my (@days) = ("Sun","Mon","Tue","Wed","Thu","Fri","Sat");
    my (@months) = ("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
	if( defined($expires) ) {
		if( $expires > 0 ) {
			my $exp_t = time+$expires;
			($sec,$min,$hour,$mday,$mon,$year,$wday) = gmtime($exp_t) if($expires>0); #get date info if expiration set.
    		$year += 1900;
		}
	}
	local(@secure) = ("","secure"); # add security to the cookie if defined.  I'm not too sure how this works.

	if( !defined $expires ) { $expires = ""; } # if expiration not set, expire at end of session
	elsif( $expires == -1 ) { $expires = ""; } # if expiration set to -1, then eliminate expiration of cookie(expire at end of session).
	else {
		$sc = '-';
		$expires = sprintf("%s, %02d$sc%s$sc%04d %02d:%02d:%02d GMT",$days[$wday],$mday,$months[$mon],$year,$hour,$min,$sec);
	}

	if ( (!defined $path) || $path eq "") { $path = "\/"; } #set default path = "/"
	if (! defined $secure) { $secure = "0"; }
	my($key);
	$cookievalue =~ s/\+/ /g; #convert plus to space.
    my $MyEplSiteCookie = $cookiename . "\=" . $cookievalue . ";";
    #~ $MyEplSiteCookie .= " expires\=".$expires . ";";
    $MyEplSiteCookie .= " path\=".$path . ";"; 
    #~ $MyEplSiteCookie .= " domain\=".$domain . ";";
    $MyEplSiteCookie .= " " . $secure;
    $MyEplSiteCookie =~ s/\n//g;
    #~ echo("Set-Cookie: ".$MyEplSiteCookie); exit;
    #~ #print cookie to browser,
    #~ #this must be done *before*	you print any content type headers.    
    print "Set-Cookie: " . $MyEplSiteCookie ."\n";
	
	#~ foreach $key (keys %cookie) {
		#~ $cookie{$key} =~ s/\+/ /g; #convert plus to space.
		#~ print "Set-Cookie: $key\=$cookie{$key};";
		#~ if( $expires ne "" ) { print " expires\=$expires;"; }
		#~ if( $path ne "" ) { print " path\=$path;"; }
		#~ if( $domain ne "" ) { print " domain\=$domain;";	}
		#~ print " 0\n";
		#print cookie to browser,
		#this must be done *before*	you print any content type headers.
	#~ }
}


sub delete_cookie
{
  # to delete a cookie, simply pass delete_cookie the name of the cookie to delete.
  # you may pass delete_cookie more than 1 name at a time.

	my ($to_delete, $path) = @_;

	if ( (!defined $path) || $path eq "") { $path = "/"; } #set default path = "/"

	undef $cookie{$to_delete}; #undefines cookie so if you call set_cookie, it doesn't reset the cookie.
	print "Set-Cookie: $to_delete\=deleted; expires\=Thu, 11-Mar-1999 00:00:00 GMT; path\=$path;\n";#domain\=;\n";
	#this also must be done before you print any content type headers.

}

sub split_cookie
{
# split_cookie
# Splits a multi-valued parameter into a list of the constituent parameters

	local ($param) = @_;
	local (@params) = split ("\1", $param);
	return (wantarray ? @params : $params[0]);
}


sub Execute
{
	my ($perl_parser_file) = $_[0];
	if( $ENV{CHECK_IF_FILE_EXISTS} == 1 ) {
		if( open(perl_parser_arch,"$perl_parser_file") ){ close(perl_parser_arch);	} else {
			#print &PrintHeader;
			echo("<big><b>File:</b> $perl_parser_file <b>does not exists</b> </big>");
			exit(1);
		}
	}
	do $perl_parser_file; if($@) { &perl_parser_error_handling(0,""); }
}

sub Execute_htpl
{
	$perl_parser_file = $_[0];
	if( $ENV{CHECK_IF_FILE_EXISTS} == 1 ) {
		if( !open(perl_parser_arch,"$perl_parser_file") ){
			print &PrintHeader if( defined($NoPpDH) );
			print "<big><b>File:</b> $perl_parser_file <b>does not exists</b> </big>";
			exit(1);
		}
	} else { open(perl_parser_arch,"$perl_parser_file"); }

	my $perl_parser_line_number = 0;
	my $perl_parser_status = 0;
	my $perl_parser_temp = "";
	$perl_parser_text = "";
	my $perl_parser_first_cero = 1;
	my $perl_parser_first_three = 1;
	my $blank_spaces = "";

	while( <perl_parser_arch>)
	{
		$perl_parser_line_number++;
		next if( $_ eq "\n");
		chop();
		$perl_parser_length = length($_);
		for ($perl_parser_k=0;$perl_parser_k<$perl_parser_length;$perl_parser_k++)
		{
			$perl_parser_temp = $perl_parser_letter;
			$perl_parser_letter = substr($_,$perl_parser_k,1);
			if( $perl_parser_letter eq " "){ $perl_parser_text .= $perl_parser_letter; next;}

			if ($perl_parser_status == 0) {
				if ($perl_parser_letter eq '<') {
					$perl_parser_status = 1;
				} else {
					if ($perl_parser_first_cero == 1) {
						$perl_parser_text .= "echo(\"";
						$perl_parser_first_cero = 0;
					}
					if ($perl_parser_letter eq '"' || $perl_parser_letter eq '@' || $perl_parser_letter eq '\\' || $perl_parser_letter eq '$') {
						$perl_parser_text .= "\\" .$perl_parser_letter;
					} else { $perl_parser_text .= $perl_parser_letter; }
				}
			}
			elsif ($perl_parser_status == 1) {
				if ($perl_parser_letter eq '%') {
					$perl_parser_status = 2;
					if ($perl_parser_first_cero == 0) {
						$perl_parser_text .= "\");\n"
					}
				}
				else {
					$perl_parser_status = 0;
					if ($perl_parser_first_cero == 1) {
						$perl_parser_text .= "echo(\"";
						$perl_parser_first_cero = 0;
					}
					$perl_parser_text .= "<".$perl_parser_letter;
				}
			}
			elsif ($perl_parser_status == 2) {
				if ($perl_parser_letter eq '%') {
					$perl_parser_status = 6;
				}
				elsif($perl_parser_letter eq '=') {
					$perl_parser_status = 3;
					$perl_parser_first_cero = 1;
				} else {
					$perl_parser_status = 7;
					$perl_parser_text .= $perl_parser_letter;
				}
			}
			elsif ($perl_parser_status == 3) {
				if ($perl_parser_letter eq '%') {
					if ($perl_parser_first_three == 0) {
						$perl_parser_text .= "\");\n";
					}
					$perl_parser_status = 4;
				} else {
					if ($perl_parser_first_three == 1) {
						$perl_parser_text .= "echo(\"";
						$perl_parser_first_three = 0;
					}
					$perl_parser_text .= $perl_parser_letter;
				}
			}
			elsif ($perl_parser_status == 4) {
				if ($perl_parser_letter eq '>') {
					$perl_parser_status = 0;
					$perl_parser_first_three = 1;
				} else {
					$perl_parser_letter_error = $perl_parser_letter;
					$perl_parser_status = 5;
				}
			}
			elsif ($perl_parser_status == 5) {
				&perl_parser_error_handling(1,"found <font color=\"#FF0000\">".$perl_parser_letter_error."</font> expected <font color=\"#006600\"> <big><b> > </b></big> </font> in line $perl_parser_line_number");
				die "Translation aborted";
			}
			elsif ($perl_parser_status == 6) {
				if ($perl_parser_letter eq '>'){
					$perl_parser_status = 0;
					$perl_parser_first_cero = 1;
				} else {
					if( $perl_parser_temp eq '%' ) {
						$perl_parser_text .= $perl_parser_temp;
					}
					$perl_parser_status = 2;
					$perl_parser_text .= $perl_parser_letter;
				}
			}
			elsif ($perl_parser_status == 7) {
				if ($perl_parser_letter eq '%') {
					$perl_parser_status = 6;

				} else { $perl_parser_text .= $perl_parser_letter; }
			}
		} #end foreach $perl_parser_letter (split(//,$_))
		$perl_parser_text .= "\n";
	} #end while(<perl_parser_arch>)
	close(perl_parser_arch);

	if ($perl_parser_status == 0 && $perl_parser_first_cero == 0) { $perl_parser_text .= "\");\n";}

	eval($perl_parser_text); if($@) { &perl_parser_error_handling(1,"Note: It could be a perl code error or HyperTextPerl code closing error %>"); }
}



sub get_parser_log_date
{
	my %themonth= (	'01' => 'Jan',
					'02' => 'Feb',
					'03' => 'Mar',
					'04' => 'Apr',
					'05' => 'May',
					'06' => 'Jun',
					'07' => 'Jul',
					'08' => 'Aug',
					'09' => 'Sep',
					'10' => 'Oct',
					'11' => 'Nov',
					'12' => 'Dec');
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$ydat,$isdst) = localtime(time);
	my $mymonth = int($mon)+1;
	$mymonth = "0".$mymonth if( $mymonth < 10 );

	$year += 1900;
	my $my_now = $year."-".$themonth{$mymonth}."-".$mday." ".$hour.":".$min.":".$sec;

	return($my_now);
}

# This subroutine is to convert the html form variables from hash to scalar
# with the same name as in the html form and you can read the variable as $variable
# and not $fdat{variable}
sub Get_Form_Variables
{
	my $var;

	foreach $var (keys(%fdat))
	{
		${"$var"} = $fdat{$var};
	}
}

sub perl_parser_error_handling()
{
	my($perl_parser_debug_file,$perl_parser_translator_error) = @_;

	print &PrintHeader;
	if( $ENV{PERL_PARSER_ERROR_LOG} == 1 )
	{
		my $my_now = &get_parser_log_date;
		if ( open( ERRLOG,">>perlparser_error_log.txt") )
		{
			print ERRLOG "[ $my_now ]:$@" if $@;
			print ERRLOG "[ $my_now ]:$perl_parser_translator_error" if $perl_parser_translator_error ne '';
			close(ERRLOG);
		}
		if ($perl_parser_debug_file == 1)
		{
			if ( open( ERRLOG,">$perl_parser_file"."_debug"))
			{
				print ERRLOG "$perl_parser_text";
				close(ERRLOG)
			}
		}
	}
	print "<html><head><title>Error In Program $perl_parser_file</title></head><body>";
	print "<p>Error In Program $perl_parser_file</p>";
	print "<big>$@</big>" if $@;
	print "<br><br><big>$perl_parser_translator_error</big>" if $perl_parser_translator_error ne '';
	print "</body></html>";
}

# This subroutine is to convert the html form variables from has to scalar
# with the same name as in the html form and you can read the variable as $variable
# and not $fdat{variable}
sub echo
{
	my ($data_to_print) = $_[0];

	print &PrintHeader if( $PrintHeader != 1 );

	if( print $data_to_print ) {
		return(1);
	} else {
		return(0);
	}
}

1; #return true

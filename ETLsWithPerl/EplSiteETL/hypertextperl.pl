#!/usr/bin/perl -X
##!d:\Utils\wamp\bin\Perl\bin\perl -X
##!c:\perl\bin\perl -X
#
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
#	The file hypertextperl.pl is using cgi-lib.pl( To read forms and upload files)
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

# For Installation see below the documentation
use DBI;
use MIME::Base64;
use Cwd;

BEGIN
{   
  my $eplsiteetl_script_dir = getcwd;
  push(@INC, $eplsiteetl_script_dir);
    #Add the library directories to @INC 
	my $DirectoryForLibraries = $eplsiteetl_script_dir . '/lib';	
	push(@INC, $DirectoryForLibraries); #after this we can do use to our own perl modules

	$DirectoryForLibraries = $eplsiteetl_script_dir . '/cgi-bin/lib';	
	push(@INC, $DirectoryForLibraries); #after this we can do use to our own perl modules

	$File_Extension_To_Parse = "htpl";  #This say the parser to translate and html
									                    #file with perl code embeded to pure perl code.
	$File_Extension_Pure_Perl = "prc";  #This say the parser to process a pure perl program, it is faster.

	require "hypertextperl-lib.pl";

	#You can set some flags here
	$ENV{PERL_PARSER_ERROR_LOG} = 1;
	$ENV{CHECK_IF_FILE_EXISTS} = 0;
	$ENV{APACHE_PERL_PARSER} = 1;
	$ENV{PERL_PARSER_DEBUG} = 1;
}


if( $ARGV[0] eq "" ) {
  $ENV{EXECUTING_LOCAL_PROCESS} = 0;
  $ENV{BATCH_PROCESS} = 0;
  
  my $PATH_INFO = $ENV{PATH_INFO};
  $PATH_INFO =~ s/\s+$//; #remove trailing spaces
  if( substr($PATH_INFO,-1) ne "/" && lc(substr($PATH_INFO,-3)) ne "prc" ) { &redirect_url_to($ENV{PATH_INFO}."/"); }
  
  $ENV{EPLSITE_URL} = "http://".$ENV{HTTP_HOST}."/";

  #  if( $ENV{PATH_INFO} ne "" ) {
  #    my @EplSiteHTTP = split('\/',$ENV{PATH_INFO});	
  #  
  #    if( $#EplSiteHTTP > 0 ) {
  #      $ENV{EPLSITE_URL} = "http://".$ENV{HTTP_HOST}."/".$EplSiteHTTP[1]."/";
  #    } else {
  #      $ENV{EPLSITE_URL} = "http://".$ENV{HTTP_HOST}."/";
  #    }
  #    $ENV{EPLSITE_URL} = "http://".$ENV{HTTP_HOST}."/";
  #  }
		
  # echo("EPLSITE_URL: $ENV{HTTP_HOST} "); exit;  
  #~ echo("$ENV{EPLSITE_URL}"); exit;	
  #Get the path to the document
  $PATH_INFO_TEMP = $ENV{PATH_INFO};
  $PATH_INFO_TEMP =~ s/^\s+//; #remove leading spaces
  $PATH_INFO_TEMP =~ s/\s+$//; #remove trailing spaces

  $PATH_INFO_TEMP =~ s/\///; #remove slashes

  if( $PATH_INFO_TEMP =~ /(.prc)/ ) { }else { $ENV{'PATH_INFO'} = $ENV{PATH_INFO}."/index.prc" }

	if( defined($ENV{PATH_TRANSLATED}) ) { $ENV{THE_CALLED_DOCUMENT} = $ENV{PATH_TRANSLATED}; }
	else { $ENV{THE_CALLED_DOCUMENT} = $ENV{'PWD'}."\/htdocs\/".$ENV{'PATH_INFO'}; }

	$ENV{THE_CALLED_DOCUMENT} =~ s/\/\//\//g;
				
	if( $ENV{SERVER_SOFTWARE}=~ /Win32/ || $ENV{SERVER_SOFTWARE}=~ /Win64/ ) { $ENV{THE_CALLED_DOCUMENT}=~ s/\\/\//g; }
		
		
	#~ $ENV{PERL_64_OR_32_BIT} = "32"; #Here you can tell hypertextperl if your are nunning perl 32 or 64 bits.	Just uncomment one line.	
	$ENV{PERL_64_OR_32_BIT} = "64";

	@perlparserdata = split('\/', $ENV{THE_CALLED_DOCUMENT});

  $perlparserdatacount = @perlparserdata;
  $ENV{CALLED_DOCUMENT_NAME} = $perlparserdata[$perlparserdatacount-1];
  @called_document_data = split('\.',$ENV{CALLED_DOCUMENT_NAME});
  $ENV{THE_CALLED_DOCUMENT_PATH} = substr($ENV{THE_CALLED_DOCUMENT},0,length($ENV{THE_CALLED_DOCUMENT})-length($ENV{CALLED_DOCUMENT_NAME}));

  $PERLPARSER{SELF} = $ENV{PATH_INFO};
  $PERLPARSER{SELF} =~ s/\/\//\//g;

  $ENV{THEPATH} = substr($ENV{REDIRECT_URL},0,$ENV{REDIRECT_URL}-9);
  $ENV{THEPATH} = "/" if( $ENV{THEPATH} eq "");
      
  # When writing files, several options can be set..
  # Spool the files to the /tmp directory
  $cgi_lib::writefiles = "tmp";

  #%fdat			-> The form data
  #%ffunc 		-> The uploaded file(s) client-provided name(s)
  #%content_type	-> The uploaded file(s) content-type(s).  These are set by the user's browser and may be unreliable
  #%cgi_sfn 	-> The uploaded file(s) name(s) on the server (this machine)

  &Get_Form_Variables if( &ReadParse(\%fdat,\%ffunc,\%content_type, \%cgi_sfn) );
        
	#print &PrintHeader if( !defined($NoPpDH) ); #NoPpDH=No Perl Parser Default Header
        
	if( !defined($ENV{PATH_INFO}) ) {
		echo("<html><head><title>No program to process</title></head><body><b>No program to process</b></body></html>");
	}

	#~ print "content-type: text/html\n\n";
  #~ print "no file $ENV{PATH_INFO}";
	#Parse file
	if( $called_document_data[1] eq $File_Extension_Pure_Perl ) { Execute($ENV{THE_CALLED_DOCUMENT});  }
	elsif( $called_document_data[1] eq $File_Extension_To_Parse ) { Execute_htpl($ENV{THE_CALLED_DOCUMENT}); }
} else {
  $ENV{EXECUTING_LOCAL_PROCESS} = 1;
  $ENV{BATCH_PROCESS} = 1;
  $ENV{MyHomeWorkingDirectory} = getcwd;
  $ENV{THE_CALLED_DOCUMENT} = $ENV{MyHomeWorkingDirectory} . "/" . $ARGV[0];
  Execute($ENV{THE_CALLED_DOCUMENT});
}
#~ echo("Argument:$ARGV[0]");exit;
1; #return true

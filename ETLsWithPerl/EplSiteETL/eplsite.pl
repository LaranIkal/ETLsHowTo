#!/usr/bin/perl -X

use Plack::App::WrapCGI;
use Plack::Builder;
use Cwd;

my $PATH_INFO_TEMP = $ENV{PATH_INFO};
$PATH_INFO_TEMP =~ s/^\s+//; #remove leading spaces
$PATH_INFO_TEMP =~ s/\s+$//; #remove trailing spaces

$PATH_INFO_TEMP =~ s/\///; #remove slashes

if( $PATH_INFO_TEMP eq "" ) { $ENV{'PATH_INFO'} = "index.prc"; }

my $AppProgram = getcwd . '/hypertextperl.pl';
my $AppDocs = getcwd . '/htdocs';

my $app = Plack::App::WrapCGI->new(script => $AppProgram, execute => 1)->to_app;

builder {
  enable "Plack::Middleware::Static",
  path => qr{/(images|includes|skins|modules|Docs)/}, root => $AppDocs;
  $app;
};


#~ my $app = Plack::App::WrapCGI->new(script => "./cgi-bin/hypertextperl.pl", execute => 1)->to_app;

 #~ builder {
      #~ enable "Plack::Middleware::Static",
          #~ path => qr{/(images|includes|skins|modules|Docs)/}, root => './htdocs';
      #~ $app;
  #~ };
  


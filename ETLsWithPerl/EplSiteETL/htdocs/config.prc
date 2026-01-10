########################################################################
# Eplsite,config file
#
#EplSite: Web ETL and reporting tool.
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
# 
########################################################################

if(substr($ENV{'REQUEST_URI'},-10) eq "config.prc") {
	&redirect_url_to("index.prc"); 
}

#~ use DBI;


# Database params

#~ $globalp->{dbusername} = "root";
#~ $globalp->{dbpassword} = "Mypassword";
#~ $globalp->{mydbdata} = "DBI:mysql:database=eplsite;host=127.0.0.1:3306";
#~ $globalp->{dbh} = DBI->connect_cached($globalp->{mydbdata},$globalp->{dbusername},$globalp->{dbpassword}) 
#~ or die "Cannot connect to $globalp->{mydbdata}";
# $globalp->{eplsite_path} is set in index.prc or admin.prc

$globalp->{dbusername} = "";
$globalp->{dbpassword} = "";
$globalp->{mydbdata} = "DBI:SQLite:dbname=".$globalp->{eplsite_path}."/Storage/EplSite.sqlite";

$globalp->{dbh} = DBI->connect_cached($globalp->{mydbdata},
$globalp->{dbusername},$globalp->{dbpassword},
{ RaiseError => 1, AutoCommit => 1,
sqlite_use_immediate_transaction => 1}) 
or die "Cannot connect to $globalp->{mydbdata}";

$globalp->{table_prefix} = "eplsite";

# General site params
$globalp->{eplsite_url} = $ENV{EPLSITE_URL};
#$globalp->{eplsite_url} = "http://localhost:3333/"; #If the url can not be guessed it can be set.
$globalp->{skin} = "EplSite2";
$globalp->{messagebox} = 1;
$globalp->{smtpserver} = "mail.mydomain.com";
$globalp->{smtpserverauthentication} = "1"; # 0=No, 1 =Yes
$globalp->{smtpuser} = "";
$globalp->{smtppassword} = "";
$globalp->{pagetitle} = "Web ETL and reporting tool Based On HyperTextPerl";
$globalp->{sitename} = "EplSite ETL";
$globalp->{adminmail} = "laran.ikal\@gmail.com";
$globalp->{main_module} = "Content";
$globalp->{site_logo} = "logo.gif";
$globalp->{site_language} = "english";
$globalp->{expire_time} = 7200; # inactive time in seconds before ask the admin password again.
$globalp->{admingraphic} = 1; # Activate graphic menu for Administration Menu? (1=Yes 0=No).
$globalp->{EplSite_Temp_Docs_Path} = $globalp->{eplsite_path}."tmp"; # enter full path to temporary documents folder
$globalp->{EplSite_Perl_Path} = '/usr/bin/perl'; #To evaluate perl syntax

######################################################################
# XML/RDF Backend Configuration
#
# $backend_title:    Backend title, can be your site's name and slogan
# $backend_language: Language format of your site
######################################################################

$globalp->{backend_title} = "EplSite Powered Site";
$globalp->{backend_language} = "en-us";

######################################################################
# HTTP Referers Options
#
# $httpref:    Activate HTTP referer logs to know who is linking to our site? (1=Yes 0=No)
# $httprefmax: Maximum number of HTTP referers to store in the Database (Try to not set this to a high number, 500 ~ 1000 is Ok)
######################################################################

$globalp->{httpref} = "0";
$globalp->{httprefmax} = "1000";

$globalp->{minpass} = "5"; # Minimum length for user passwords

$globalp->{commentmaxsize} = "2048"; #Set max size in bytes for comments


# IT is important you set the delete command for the Operating System
#where EplSite Work Flow is installed and comment the instructions for
#other operating systems.
$globalp->{EplSiteDeleteFile} =
sub {	 

  local $Document_to_delete = shift; # Full path and document name to delete.
	local $del_return = ""; # Return Value
		
	#~ $Document_to_delete =~ s/\//\\/g;
	#~ $Document_to_delete = $Document_to_delete;
	#~ echo($Document_to_delete); exit;
	eval{ system("rm ".$Document_to_delete) };
	if( $@ ){
		$del_return = "Error when trying to delete document $Document_to_delete:$@";
	}

  return($del_return);
};

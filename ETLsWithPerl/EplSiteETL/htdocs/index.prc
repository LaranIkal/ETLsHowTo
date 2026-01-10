########################################################################
# Eplsite,index file
#
#This File has logic design from PHP-NUKE ported to Embperl.
#EplSite: Web Portal And WorkFlow System.
#Copyright (C) 2003 by Carlos Kassab (laran.ikal@gmail.com)
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


if( defined($ENV{MOD_PERL}) ) {
	$theeplsitepath = substr($ENV{'SCRIPT_FILENAME'},0,length($ENV{'SCRIPT_FILENAME'})-9);
} else {
	$theeplsitepath = substr($ENV{'DOCUMENT_ROOT'}.$ENV{'PATH_INFO'},0,length($ENV{'DOCUMENT_ROOT'}.$ENV{'PATH_INFO'})-9);
}

$theeplsitepath = $ENV{THE_CALLED_DOCUMENT_PATH};
$globalp->{eplsite_path} = $theeplsitepath;
$globalp->{loaded_from_index} = 1;

Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'config.prc');

#~ echo("EPLSITE_URL:$globalp->{eplsite_url},eplsite_path:$globalp->{eplsite_path},"); 
#~ echo("http://".$ENV{HTTP_HOST}."/".$EplSiteHTTP[1]."/,".$ENV{PATH_INFO});
#~ exit;
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'skins/'.$globalp->{skin}.'/colors.prc');
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'skins/'.$globalp->{skin}.'/subs.prc');
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'language/lang-'.$globalp->{site_language}.'.prc');

Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'mainprogram.prc');
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'includes/subs.prc');

# Displaying modules #

if( defined($fdat{module}) ) {

  #local $modfile = lc($fdat{module}).'.prc';
  #It has been commented to do eplsite faster
  #but you could uncomment it if you want additional checking
  #if( &file_exists($theeplsitepath.'modules/'.$fdat{module}."/".$modfile ) )
  #{
  #Loading the module
  Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/'.$fdat{module}.'/'.lc($fdat{module}).'.prc');
  #}
  #else
  #{
      #&siteheader;
      #&theheader;
      #print OUT "File $theeplsitepath"."/modules/$fdat{module}/$modfile for module $fdat{module} does not exists";
      #sitefooter;
  #}
} else {
	if( $globalp->{main_module} eq "" ) {
    print "There is not a default module...run program admin.prc or <br>set the value to $globalp->{main_module} in config.prc";
	} else {
		Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'modules/'.$globalp->{main_module}.'/'.lc($globalp->{main_module}).'.prc');
	}
}

#&redirect_url_to("$PERLPARSER{SELF}?ltp=$fdat{ltp}&option=admusrs&site=$fdat{site}");

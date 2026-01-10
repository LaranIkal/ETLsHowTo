########################################################################
# Eplsite,admin file
#
#EplSite: Web Portal And WorkFlow System.
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


if( defined($ENV{MOD_PERL}) ) {
	$globalp->{eplsite_path} = substr($ENV{'SCRIPT_FILENAME'},0,length($ENV{'SCRIPT_FILENAME'})-9);
} else {
	$globalp->{eplsite_path} = substr($ENV{'DOCUMENT_ROOT'}.$ENV{'PATH_INFO'},0,length($ENV{'DOCUMENT_ROOT'}.$ENV{'PATH_INFO'})-9);
}

$globalp->{eplsite_path} = $ENV{THE_CALLED_DOCUMENT_PATH};
$ENV{'REQUEST_URI'} = "admin.prc";

Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'config.prc');
Execute ($globalp->{eplsite_path}.'includes/subs_admin.prc');
Execute ($globalp->{eplsite_path}."language/lang-".$globalp->{site_language}.".prc");
Execute ($globalp->{eplsite_path}."admin/language/lang-".$globalp->{site_language}.".prc");
Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'skins/'.$globalp->{skin}.'/subs.prc');
Execute ($globalp->{eplsite_path}.'mainprogram.prc');
Execute ($globalp->{eplsite_path}.'skins/'.$globalp->{skin}.'/colors.prc');
Execute ($globalp->{eplsite_path}.'includes/subs.prc');

$is_first = $globalp->{check_if_first}();
if( $is_first == 0 ) {
  $globalp->{session} = $fdat{session} if(defined($fdat{session}));
  Execute ($ENV{THE_CALLED_DOCUMENT_PATH}.'auth.prc');
  if( !defined($fdat{option}) ) { $fdat{option} = "adminMain"; }
}

if( $is_first == 0 ) {
	if( $globalp->{admintest} == 1 ) {
		if( $fdat{option} eq "deleteNotice" ) { &deleteNotice($id, $table, $op_back); }
		elsif( $fdat{option} eq "GraphicAdmin" ) { $globalp->{GraphicAdmin}(); }
		elsif( $fdat{option} eq "adminMain" ) { $globalp->{adminMain}(); }
		elsif( $fdat{option} eq "logout" ) {
			$globalp->{dbh}->do("delete from ".$globalp->{table_prefix}."_sessions where code='$globalp->{session}'");
			$globalp->{siteheader}(); $globalp->{theheader}();
			$globalp->{OpenTable}();

			echo("<center><font class=\"title\"><b>".$globalp->{_YOUARELOGGEDOUT}."</b></font></center>");
			$globalp->{CloseTable}();
			$globalp->{sitefooter}();
		}

		opendir (CASES,$globalp->{eplsite_path}."admin/case") || die "can't opendir cases dir: $!";
		rewinddir(CASES);
		@cases = grep { /(case.)*.prc/ } readdir(CASES);
		foreach (@cases) {
			$caselist .= "$_ ";
		}
		closedir(CASES);

		@caselist = split(' ', $caselist);
		@casesfiles = sort @caselist;
		$i = 0;
		foreach (@casesfiles) {
			if($casesfiles[$i] ne "") {
				Execute ($globalp->{eplsite_path}.'admin/case/'.$casesfiles[$i]);
			}
			$i++;
		}
	} else { $globalp->{admlogin}(); }
}


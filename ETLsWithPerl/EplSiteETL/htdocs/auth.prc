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

if (substr($ENV{'REQUEST_URI'},-8) eq "auth.prc") {
	&redirect_url_to("index.prc");
}

if( (defined($fdat{aid})) && (defined($fdat{pwd})) && ($fdat{option} eq "login") ) {
  use Digest::MD5  qw(md5_hex);

  if( $fdat{aid} ne "" && $fdat{pwd} ne "" ) {
    $sthauth = $globalp->{dbh} -> prepare ("select count(*) from ".$globalp->{table_prefix}."_sessions where user='$fdat{aid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_sessions";
    $sthauth -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_sessions";
    $sthauth -> bind_columns(undef, \$num_session);
    $datauth = $sthauth -> fetchrow_arrayref;
    $sthauth -> finish();

    $sthauth1 = $globalp->{dbh} -> prepare ("select pwd, admlanguage from ".$globalp->{table_prefix}."_authors where aid='$fdat{aid}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_authors";
    $sthauth1 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_authors";
    $sthauth1 -> bind_columns(undef, \$pass, \$admlanguage);
    $datauth1 = $sthauth1 -> fetchrow_arrayref;
    $sthauth1 -> finish();

    $pwd = md5_hex($fdat{pwd});

    if( $pass eq $pwd ) {
      $now_fractions = time*1000;
      srand ($now_fractions ^ $$);
      $session = md5_hex(rand($now_fractions));
      $globalp->{session} = $session;
      ($sec,$min,$hour,$mday,$mon,$year,$wday,$ydat,$isdst) = localtime(time);
      $time_in_seconds = ($hour*3600)+($min*60)+$sec;
      if( $num_session == 1 ) {
        eval { $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_sessions set code='$session', time=$time_in_seconds where user='$fdat{aid}'")};
        if($@) {
          #Disconnect from the database.
          echo("Imposible to update session table: $@\n");
          $globalp->{clean_exit}();
        }
      } else {
        eval { $globalp->{dbh}->do("insert into ".$globalp->{table_prefix}."_sessions values ('$fdat{aid}','$session',$time_in_seconds)" )};
        if($@) {
          #Disconnect from the database.
          echo("Imposible to create session : $@\n");
          delete $fdat{option};
          $globalp->{clean_exit}();
        }
      }
      delete $fdat{option};
    }
  }
}

$globalp->{admintest} = 0;

if( $globalp->{session} ne "" ) {
  $sthauth2 = $globalp->{dbh} -> prepare ("select user, time from ".$globalp->{table_prefix}."_sessions where code='$globalp->{session}'") or die "Cannot SELECT from ".$globalp->{table_prefix}."_sessions";
  $sthauth2 -> execute  or die "Cannot execute SELECT from ".$globalp->{table_prefix}."_sessions";
  $sthauth2 -> bind_columns(undef, \$user, \$mytime);
  $datauth2 = $sthauth2 -> fetchrow_arrayref;
  $sthauth2 -> finish();

  ($sec,$min,$hour,$mday,$mon,$year,$wday,$ydat,$isdst) = localtime(time);
  $time_in_seconds = ($hour*3600)+($min*60)+$sec;

  if( abs($time_in_seconds - $mytime) < $globalp->{expire_time} ) {
    eval{ $globalp->{dbh}->do("update ".$globalp->{table_prefix}."_sessions set time=$time_in_seconds where code='$globalp->{session}'")};
    if($@) {
      echo("Imposible to update session table: $@\n");
      $globalp->{clean_exit}();
    }
    $globalp->{admintest} = 1;
    $globalp->{aid} = $user;
  }
}

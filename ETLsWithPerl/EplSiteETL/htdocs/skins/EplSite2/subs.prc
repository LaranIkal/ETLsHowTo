########################################################################
# Eplsite,general subs file
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


$globalp->{OpenTable} =
sub
{
    echo("<table width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"0\" bgcolor=\"$globalp->{bgcolor2}\"><tr><td>\n"
             ."<table width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"8\" bgcolor=\"$globalp->{bgcolor1}\"><tr><td>\n");
};


$globalp->{CloseTable} =
sub
{
    echo("</td></tr></table></td></tr></table>\n");
};


$globalp->{OpenTable2} =
sub
{
    echo("<table border=\"0\" cellspacing=\"1\" cellpadding=\"0\" bgcolor=\"$globalp->{bgcolor2}\" align=\"center\"><tr><td>\n"
             ."<table border=\"0\" cellspacing=\"1\" cellpadding=\"8\" bgcolor=\"$globalp->{bgcolor1}\"><tr><td>\n");
};


$globalp->{CloseTable2} =
sub
{
    echo("</td></tr></table></td></tr></table>\n");
};


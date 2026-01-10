########################################################################
# EplPortal,metacharacters file
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
########################################################################

##################################################
# Include for Meta Tags generation               #
##################################################

echo("<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=$globalp->{_CHARSET}\">\n");
echo("<META HTTP-EQUIV=\"EXPIRES\" CONTENT=\"0\">\n");
echo("<META NAME=\"RESOURCE-TYPE\" CONTENT=\"DOCUMENT\">\n");
echo("<META NAME=\"DISTRIBUTION\" CONTENT=\"GLOBAL\">\n");
echo("<META NAME=\"COPYRIGHT\" CONTENT=\"Copyright (C) 2026 Carlos Kassab\">\n");
echo("<META NAME=\"KEYWORDS\" CONTENT=\"Perl,hypertextperl,HYPERTEXTPERL\">\n");
echo("<META NAME=\"ROBOTS\" CONTENT=\"INDEX, FOLLOW\">\n");
echo("<META NAME=\"REVISIT-AFTER\" CONTENT=\"1 DAYS\">\n");
echo("<META NAME=\"RATING\" CONTENT=\"GENERAL\">\n");
echo("<META NAME=\"TITLE\" CONTENT=\"EplSite ETL\">\n");
echo("<META NAME=\"DESCRIPTION\" CONTENT=\"EplSite ETL\">\n");
echo("<link rel=\"icon\" href=\"" . $globalp->{eplsite_url} . "images/icefox_blue1.png\">");


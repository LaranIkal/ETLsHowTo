########################################################################
# EplPortal,Configuraci�n
##This File has logic design from PHP-NUKE ported to Embperl.
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

#This file is to customize whatever stuff you need to include in your site
#   when the header loads. This can be used for third party banners, custom
#   javascript, popup windows, etc. With this file you don't need to edit
#   system code each time you upgrade to a new version. Just remember, in case
#   you add code here to not overwrite this file when updating!
#   Whatever you put here will be between <head> and </head> tags.

echo("<style>\n"
	.".hidden {display:none;}\n"
	.".unhidden {display:block;}\n"
	."</style>\n"
);

echo("<script type=\"text/javascript\"> \n"
	.'function PrintReport()'."\n"
	.'{ '."\n"
	.'	document.reportform.device.value="Printer"'."\n"
	.'	document.reportform.target="_blank"'."\n"
	.'	document.reportform.submit()'."\n"
	.'}'."\n\n\n"

	.'function DisplayReport()'."\n"
	.'{'."\n"
	.'	document.reportform.device.value="Display"'."\n"
	.'	document.reportform.target=""'."\n"
	.'	document.reportform.submit()'."\n"
	.'}'."\n\n"
	
	."</script>\n"
);



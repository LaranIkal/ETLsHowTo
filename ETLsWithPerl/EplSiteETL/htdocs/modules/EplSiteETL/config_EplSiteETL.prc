if (substr($ENV{'REQUEST_URI'},-19) eq "config_DataExtract.prc") {
	&redirect_url_to("index.html");
}

$globalp->{wftitlecellcolor} = "#3399FF";
$globalp->{wftaskstatuscolor} = "#3366ff";
$globalp->{wfsteppendingcolor} = "#acccec";
$globalp->{celldoccolor1} = "#acccec";
$globalp->{celldoccolor2} = "#FFFFeC";
$globalp->{celltaskcolor1} = "#bcccec";
$globalp->{celltaskcolor2} = "#ffffeC";
$globalp->{CookieName} = "EplSiteETL";
$globalp->{min_wf_password_length} = 5;
$globalp->{permited_wf_pwdchars} = "0-9a-zA-Z";
$globalp->{wfadminmail} = "carlos.alberto\@kassabconsulting.com";
$globalp->{use_eplsite_password} = 0; # 1=Yes, 0=No-> use ValidationReports Module Passwords table
$globalp->{WorkFlowTopicID} = 2;
$globalp->{Temp_Docs_Path} = $globalp->{eplsite_path}."modules/EplSiteETL/tmp"; # enter full path to temporary documents folder
$globalp->{RecordsByScreenInQueryTool} = 50;
#The next value $wfsession_expire_time is the time before the
# browser cookie expire, values are:
# +30	30 Seconds
# +10m	10 Minutes
# +1h	1 hour
# +3M	3 Months
# +10y	10 Years
# You can set the expire time to '0' and the cookie will expire when the
# browser is closed
#$wfsession_expire_time = '+10m';
$globalp->{wfsession_expire_time} = '0';
$globalp->{permitedchars} = "0-9a-zA-Z_ ñ Ñ àèìòùáéíóú .:!?¿¡*+,;=()$%#@&\/";

# IT is important you set the delete command for the Operating System
#where EplSite Work Flow is installed and comment the instructions for
#other operating systems.
$globalp->{DeleteMyFile} =
sub
{
    local $Document_to_delete = shift; # Full path and document name to delete.
	local $del_return = ""; # Return Value
		
#For Windows type O.S.
    #~ if( $ENV{SERVER_SOFTWARE}=~ /Win32/ )
    #~ {
		#~ $Document_to_delete =~ s/\//\\/g;

        #~ eval{ system("del ".$Document_to_delete) };
        #~ if( $@ )
        #~ {
            #~ $del_return = "Error when trying to delete document $Document_to_delete:$@";
        #~ }
    #~ }

#For O.S. Type Linux.
    #~ if( ( $ENV{SERVER_SOFTWARE}=~ /Linux/ ) || ( $ENV{SERVER_SOFTWARE}=~ /Unix/ ) || ( $ENV{SERVER_SOFTWARE}=~ /linux/ ))
    #~ {
    #~ echo( "Filed to delete:".$Document_to_delete); exit;
        eval{system("rm ".$Document_to_delete)};
        if( $@ )
        {
            $del_return = "Error when trying to delete document $delete_this_file:$@";
        }
    #~ }

    return($del_return);
}

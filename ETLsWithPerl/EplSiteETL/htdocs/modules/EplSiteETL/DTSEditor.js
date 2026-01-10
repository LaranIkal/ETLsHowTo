	function xmlhttpPostScriptData(strURL,EplSiteform,DivField) 
	{
		var xmlHttpReq = false;
		var self = this;
		var qstr = "";
		// Getting form data
		var FormEplSite = EplSiteform;
		var module = FormEplSite.module.value;
		var option = FormEplSite.option.value;
		var scriptoption = FormEplSite.scriptoption.value;
		var DTSID = FormEplSite.DTSID.value;
		var MaintainDTS = FormEplSite.MaintainDTS.value;
		var Maintain = FormEplSite.Maintain.value;
		var myplus = /\+/g;
		//~ var perlscript = FormEplSite.perlscript.value;
		var perlscript = document.getElementById('myperlscript').value.replace(myplus,"unsignomas");
		
		TheTimeOut = setTimeout("document.body.style.cursor='wait'", 1);
		try
		{		
			document.getElementById(DivField).innerHTML = "Saving And Checking Script, please wait...";
			// Mozilla/Safari/Chrome
			if (window.XMLHttpRequest) 
			{
				self.xmlHttpReq = new XMLHttpRequest();
			}
			// IE
			else if (window.ActiveXObject) 
			{
				self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
			}
			
			self.xmlHttpReq.open('POST', strURL, true);
			self.xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			self.xmlHttpReq.onreadystatechange = function() 
			{
				if (self.xmlHttpReq.readyState == 4) 
				{				
					updatepage(self.xmlHttpReq.responseText,DivField);
					clearTimeout(TheTimeOut); 
					document.body.style.cursor='default';					
				}
			}
		
			qstr = 'module=' + escape(module);  // NOTE: no '?' before querystring
			qstr += '&option=' + escape(option); 
			qstr += '&scriptoption=' + escape(scriptoption); 
			qstr += '&DTSID=' + escape(DTSID); 
			qstr += '&MaintainDTS=' + escape(MaintainDTS); 
			qstr += '&Maintain=' + escape(Maintain); 
			qstr += '&perlscript=' + escape(perlscript); 
			
			self.xmlHttpReq.send(qstr);
		}
		catch(err){clearTimeout(TheTimeOut); document.body.style.cursor='default';}
	}
	


	function getquerystring(QueryEplSiteform5) 
	{
		var FormEplSite = QueryEplSiteform5;
		//~ alert(formEplSite.module.value);
		var module = FormEplSite.module.value;
		var option = FormEplSite.option.value;
		var servertype = FormEplSite.servertype.value;
		var company = FormEplSite.company.value;
		var reportoption = FormEplSite.reportoption.value;
		var ReportID = FormEplSite.ReportID.value;
		var searchfield = FormEplSite.searchfield.value;	
		var min = FormEplSite.min.value;
		var reportindisplay = FormEplSite.reportindisplay.value;
		
		qstr = 'module=' + escape(module);  // NOTE: no '?' before querystring
		qstr += '&option=' + escape(option); 
		qstr += '&servertype=' + escape(servertype); 
		qstr += '&company=' + escape(company); 
		qstr += '&reportoption=' + escape(reportoption); 
		qstr += '&ReportID=' + escape(ReportID); 
		qstr += '&searchfield=' + escape(searchfield);
		qstr += '&min=' + escape(min);	
		qstr += '&reportindisplay=' + escape(reportindisplay);
		
		return qstr;
	}
	
	
	
	
	
	
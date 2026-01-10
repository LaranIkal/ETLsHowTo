	function xmlhttpPostScriptData(strURL,EplSiteform,DivField) 
	{
		var xmlHttpReq = false;
		var self = this;
		var qstr = "";
		// Getting form data
		var FormEplSite = EplSiteform;
		var module = FormEplSite.module.value;
		var option = FormEplSite.option.value;
		var queryoption = "Execute Query";
		var myplus = /\+/g;
		var sqlscript = FormEplSite.sqlscript.value;
		//~ var DataSourceID = FormEplSite.DataSourceID.value;
		var DataSourceID = document.getElementById("DataSourceID").options[document.getElementById("DataSourceID").selectedIndex].value;
		//~ alert(DataSourceID);
		sqlscript = document.getElementById('sqlscript').value.replace(myplus,"unsignomas");
		//~ alert(sqlscript);
		var numofrecords = "No";
		if( FormEplSite.numofrecords.checked )
		{
			numofrecords = "Yes";
		}
		//~ alert(numofrecords);
		
		TheTimeOut = setTimeout("document.body.style.cursor='wait'", 1);
		try
		{		
			document.getElementById(DivField).innerHTML = "Executing Query, please wait...";
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
			//~ self.xmlHttpReq.setRequestHeader("Content-Type", "text/html; charset=iso-8859-1");
			self.xmlHttpReq.onreadystatechange = function() 
			{
				if (self.xmlHttpReq.readyState == 4) 
				{				
					updatepage(self.xmlHttpReq.responseText,DivField);
					//~ updatepage(self.xmlHttpReq.getAllResponseHeaders(),DivField);
					clearTimeout(TheTimeOut); 
					document.body.style.cursor='default';					
				}
			}
		
			qstr = 'module=' + escape(module);  // NOTE: no '?' before querystring
			qstr += '&option=' + escape(option); 
			qstr += '&queryoption=' + escape(queryoption); 
			qstr += '&DataSourceID=' + escape(DataSourceID); 
			qstr += '&sqlscript=' + escape(sqlscript); 
			qstr += '&numofrecords=' + escape(numofrecords);
			
			self.xmlHttpReq.send(qstr);
		}
		catch(err){clearTimeout(TheTimeOut); document.body.style.cursor='default';}
	}
	

	function xmlhttpPostNavigation(strURL,EplSiteform,DivField) 
	{
		var xmlHttpReq = false;
		var self = this;
		var qstr = "";
		// Getting form data
		var FormEplSite = EplSiteform;
		var module = FormEplSite.module.value;
		var option = FormEplSite.option.value;
		var queryoption = "Execute Query";
		var myplus = /\+/g;
		var sqlscript = document.forms[1].sqlscript.value;
		sqlscript = document.getElementById('sqlscript').value.replace(myplus,"unsignomas");
		var DataSourceID = FormEplSite.DataSourceID.value;		
		var min = FormEplSite.min.value;
		var numofrecords = FormEplSite.numofrecords.value;
		//~ var numofrecords = FormEplSite.numofrecords.value;
		//~ alert(numofrecords);
		TheTimeOut = setTimeout("document.body.style.cursor='wait'", 1);
		try
		{		
			document.getElementById(DivField).innerHTML = "Processing, please wait...";
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
			//~ self.xmlHttpReq.setRequestHeader("Content-Type", "text/html; charset=ISO-8859-1");
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
			qstr += '&queryoption=' + escape(queryoption); 
			qstr += '&sqlscript=' + escape(sqlscript); 
			qstr += '&DataSourceID=' + escape(DataSourceID);
			qstr += '&min=' + escape(min);	
			qstr += '&numofrecords=' + escape(numofrecords);
			
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
	
	
	
	
	
	
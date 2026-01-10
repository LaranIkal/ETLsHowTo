
    function xmlhttpPostScriptData(strURL,EplSiteform,DivField,TheQueryOption) 
	{
		var xmlHttpReq = false;
		var self = this;
		var qstr = "";
        var qstr1 = "";
		// Getting form data
		var FormEplSite = EplSiteform;
		var module = FormEplSite.module.value;
		var option = FormEplSite.option.value;
		var queryoption = TheQueryOption; //"Execute Query";
		var myplus = /\+/g;
        var ThereIsError = "";
		var ValidationResult = "";

        var sqlscript = document.getElementById('sqlscript').value;
		var valsqlscript = document.getElementById('sqlscript').value.replace(/^\s+|\s+$/g,'');
        var SQLQueryName = document.getElementById('SQLQueryName').value.replace(/^\s+|\s+$/g,'');
		SQLQueryName = SQLQueryName.replace(/ /g,'_');

		if( queryoption == "Save Query" )
		{
			if( SQLQueryName == "" )
			{
				ThereIsError += "Enter SQL Query Name.";
			}
			
			if( valsqlscript == "" )
			{
				ThereIsError += "<br>Enter SQL Script.";
			}			
		}
		
		var DataSourceID = document.getElementById("DataSourceID").options[document.getElementById("DataSourceID").selectedIndex].value;
        var SQLQueryID = document.getElementById("SQLQueryID").options[document.getElementById("SQLQueryID").selectedIndex].value;

        document.getElementById('SQLQueryIDex').value = SQLQueryID;
		var QueryInstruction = document.getElementById("QueryInstruction").options[document.getElementById("QueryInstruction").selectedIndex].value;
		
		sqlscript = document.getElementById('sqlscript').value.replace(myplus,"unsignomas");
       
        var numofrecords = "No";
		if( document.forms[1].numofrecords.checked )
		{
			numofrecords = "Yes";
		}
        
        if( queryoption == "Export Query Results" || queryoption == "Execute Query" || queryoption == "Results As Excel File" )
        {
            if( sqlscript == "" )
            {
                ThereIsError += "<br>Enter a SQL Command.";
            }
            
            if( DataSourceID == "0" )
            {
                ThereIsError += "<br>Select Data Source.";
            }
        }

        if( ThereIsError != "" )
        {
            document.getElementById(DivField).innerHTML = "<p><b><font color=\"red\">"+ThereIsError+"</font></b></p>";
        }
        else
        {
            if( queryoption == "Export Query Results" || queryoption == "Results As Excel File" )
            {
                document.getElementById(DivField).innerHTML = "Executing Query, please wait...";
				document.getElementById("queryoption").value = queryoption;
                EplSiteform.submit();
				document.getElementById(DivField).innerHTML = "Query To Export Data Executed.";
            }
            else
            {
                TheTimeOut = setTimeout("document.body.style.cursor='wait'", 1);
                try
                {		
                    if( queryoption == "Execute Query" )
                    {
                        document.getElementById(DivField).innerHTML = "Executing Query, please wait...";
                    }
                    else
                    {
                        document.getElementById(DivField).innerHTML = "Processing, please wait...";
                    }
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
                        if( self.xmlHttpReq.readyState == 4 ) 
                        {				
							if( self.xmlHttpReq.responseText == "ValidationOk" )
							{
								document.getElementById('queryoption').value = "Save Query";
								document.getElementById('ValidationResult').value = "ValidationOk";
								EplSiteform.submit();
								// document.forms["MainQuery"].submit();
							}
							else
							{
								updatepage(self.xmlHttpReq.responseText,DivField);
								//~ updatepage(self.xmlHttpReq.getAllResponseHeaders(),DivField);
								clearTimeout(TheTimeOut); 
								document.body.style.cursor='default';
								if( DivField == "ResultsPane" && queryoption == "Save Query" )
								{
									xmlhttpPostScriptData(strURL,EplSiteform,"QueryList","RefreshQueryList");
								}
							}
                        }
                    }
                
                    qstr = 'module=' + escape(module);  // NOTE: no '?' before querystring
                    qstr += '&option=' + escape(option); 
                    qstr += '&queryoption=' + escape(queryoption); 
                    qstr += '&DataSourceID=' + escape(DataSourceID); 
                    qstr += '&sqlscript=' + escape(sqlscript); 
                    qstr += '&numofrecords=' + escape(numofrecords);
                    qstr += '&QueryInstruction=' + escape(QueryInstruction);
                    qstr += '&SQLQueryName=' + escape(SQLQueryName);
                    qstr += '&SQLQueryID=' + escape(SQLQueryID);
					qstr += '&ValidationResult=' + escape(ValidationResult);
                    
                    self.xmlHttpReq.send(qstr);
                }
                catch(err){clearTimeout(TheTimeOut); document.body.style.cursor='default';}
            }
        }
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
		var QueryInstruction = FormEplSite.QueryInstruction.value;
		var min = FormEplSite.min.value;
		var numofrecords = FormEplSite.numofrecords.value;
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
			qstr += '&QueryInstruction=' + escape(QueryInstruction);
			
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
	
	
	

    function ClearResultsPane(DivField)
    {
        document.getElementById(DivField).innerHTML = "";
    }
	
	

    function SubtmitSaveData(EplSiteform)
    {
	Alert("Entering function");
        var FormEplSite = EplSiteform;
		document.getElementById('queryoption').value = "Save Query";
		Alert(document.getElementById('SQLQueryName').value);
		// document.getElementById('SQLQueryName').value = document.getElementById('SQLQueryName').value.replace(/^\s+|\s+$/g,'')
		// Alert(document.getElementById('SQLQueryName').value);
		
		// "Enter SQL Query Name.<br>";
		
		// document.forms["MainQuery"].submit();
    }    
    
    

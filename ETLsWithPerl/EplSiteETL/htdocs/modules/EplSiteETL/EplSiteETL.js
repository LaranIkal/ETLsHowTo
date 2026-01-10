	function xmlhttpPostData(strURL,EplSiteform,DivFieldToUpdate,SelectBox, SelectBoxID)
	{
		var xmlHttpReq = false;
		var self = this;
		var qstr = "";
		// Getting form data
		var FormEplSite = EplSiteform;
		var module = FormEplSite.module.value;
		var option = FormEplSite.option.value;
		var etlscheme = document.getElementById(SelectBoxID).options[document.getElementById(SelectBoxID).selectedIndex].value;
		var etlschemetext = document.getElementById(SelectBoxID).options[document.getElementById(SelectBoxID).selectedIndex].text;
		//~ alert(etlscheme);	
		
		TheTimeOut = setTimeout("document.body.style.cursor='wait'", 1);
		try
		{	
			document.getElementById(DivFieldToUpdate).innerHTML = "Getting ETL scheme menu: " + etlschemetext + ", please wait...";
			EplSiteform.submit();
			clearTimeout(TheTimeOut); document.body.style.cursor='default';			
		}
		catch(err){clearTimeout(TheTimeOut); document.body.style.cursor='default';}
	}
	


    function xmlhttpPostTransformation(strURL,EplSiteform,DivField,Action) 
	{
		var xmlHttpReq = false;
		var self = this;
		var qstr = "";
        var qstr1 = "";
		// Getting form data
		var FormEplSite = EplSiteform;
		var module = FormEplSite.module.value;
		var option = "GetRunNumber";
		var myplus = /\+/g;
        var ThereIsError = "";

		var DBConnSourceID = document.getElementById("DBConnSourceID").options[document.getElementById("DBConnSourceID").selectedIndex].value;
        var DBConnTargetID = document.getElementById("DBConnTargetID").options[document.getElementById("DBConnTargetID").selectedIndex].value;
		var ETLSchemeCode = document.getElementById('ETLSchemeCode').value;
		var TransformationCode = document.getElementById("TransformationCode").options[document.getElementById("TransformationCode").selectedIndex].value;
		var ScriptID = document.getElementById("DBConnTargetID").options[document.getElementById("ScriptID").selectedIndex].value;
		
        
		if( DBConnSourceID == "" )
		{
			ThereIsError += "<br>Select Source DataBase Connection.";
		}
		
		if( DBConnTargetID == "" )
		{
			ThereIsError += "<br>Select Target DataBase Connection.";
		}

		if( TransformationCode == "" && ScriptID=="" )
		{
			ThereIsError += "<br>Select a Layout or an Independent Script To Process.";
		}
		
        if( ThereIsError != "" )
        {
            document.getElementById(DivField).innerHTML = "<p><b><font color=\"red\">"+ThereIsError+"</font></b></p>";
        }
        else
        {
			TheTimeOut = setTimeout("document.body.style.cursor='wait'", 1);
			try
			{		
				document.getElementById(DivField).innerHTML = "Getting Run number, please wait...";

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
						var StartProcessResponse = self.xmlHttpReq.responseText;
						var StartProcessResponseValues=StartProcessResponse.split("|");
						document.getElementById('runnumber').value = StartProcessResponseValues[0];
						var SeeLog = "<a href=\"#\" onClick=\"window.open('index.prc?";
						SeeLog += "module=EplSiteETL&amp;option=ShowRunNumberLog";
						SeeLog += "&amp;runnumber=" + StartProcessResponseValues[0];
						SeeLog +="','Log File For Run Number'";
						SeeLog += ",'width=650,height=450, scrollbars=yes, fullscreen=-1');return;\" >";
						SeeLog += "See Log For Transformation Run Number:";
						SeeLog += StartProcessResponseValues[0];
						SeeLog += "</a><br>";
						
						if( StartProcessResponseValues[1] >= 1 )
						{
							SeeLog += "<br><a href=\"#\" onClick=\"window.open('index.prc?";
							SeeLog += "module=EplSiteETL&amp;option=ShowXRefErrorLog";
							SeeLog += "&amp;runnumber=" + StartProcessResponseValues[0];
							SeeLog +="','XRef Error Log File'";
							SeeLog += ",'width=650,height=450, scrollbars=yes, fullscreen=-1');return;\" >";
							SeeLog += "See XRef Error Log For Transformation Run Number:";
							SeeLog += StartProcessResponseValues[0];
							SeeLog += "</a><br>";
						}
						
						if( StartProcessResponseValues[2] >= 1 )
						{
							SeeLog += "<br><a href=\"#\" onClick=\"window.open('index.prc?";
							SeeLog += "module=EplSiteETL&amp;option=ShowCatalogsErrorLog";
							SeeLog += "&amp;runnumber=" + StartProcessResponseValues[0];
							SeeLog +="','Catalogs Error Log File'";
							SeeLog += ",'width=650,height=450, scrollbars=yes, fullscreen=-1');return;\" >";
							SeeLog += "See Catalogs Error Log For Transformation Run Number:";
							SeeLog += StartProcessResponseValues[0];
							SeeLog += "</a><br>";
						}

						document.getElementById(DivField).innerHTML = SeeLog;
						clearTimeout(TheTimeOut); 
						document.body.style.cursor='default';
						EplSiteform.submit();
					}
				}
			
				qstr = 'module=' + escape(module);  // NOTE: no '?' before querystring
				qstr += '&option=' + escape(option); 
				qstr += '&ETLSchemeCode=' + escape(ETLSchemeCode); 
				qstr += '&TransformationCode=' + escape(TransformationCode); 
				
				self.xmlHttpReq.send(qstr);
			}
			catch(err){clearTimeout(TheTimeOut); document.body.style.cursor='default';}
        }
	}

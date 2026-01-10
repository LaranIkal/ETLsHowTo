	function xmlhttpPostValueType(strURL,EplSiteform, SequenceNum,ValueType,DivFieldToUpdate,SelectBox)
	{
		var xmlHttpReq = false;
		var self = this;
		var qstr = "";
		// Getting form data
		var FormEplSite = EplSiteform;
		var module = FormEplSite.module.value;
		var option = FormEplSite.option.value;
		var ETLSchemeCode = FormEplSite.ETLSchemeCode.value;
        var ETLSchemeID = FormEplSite.ETLSchemeID.value;
		var maintaincfg = "UpdateValueAssigned";
		var TransformationCode = FormEplSite.TransformationCode.value;
		var TransformationID = FormEplSite.TransformationID.value;
		var sequencenum = SequenceNum;
		//~ var valuetype = document.getElementById(ValueType).value;
		var SelectedItem = SelectBox[SelectBox.selectedIndex];
		var valuetype = "";
		var valuetypeselected = document.getElementById(ValueType).selectedIndex;

		if( valuetypeselected == 1 )
		{
			valuetype = "ConstantValue";
		}
		else if( valuetypeselected == 2 )
		{
			valuetype = "QueryField";
		}
		else if( valuetypeselected == 3 )
		{
			valuetype = "CrossReference";
		}
		else if( valuetypeselected == 4 )
		{
			valuetype = "TransformationScript";
		}
		
		SelectedItem.value = valuetype;
		//~ alert(document.getElementById(ValueType).value + " " + valuetype );
		TheTimeOut = setTimeout("document.body.style.cursor='wait'", 1);
		try
		{	
			document.getElementById(DivFieldToUpdate).innerHTML = "Processing, please wait...";
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
					updatepage(self.xmlHttpReq.responseText,DivFieldToUpdate);
					clearTimeout(TheTimeOut); 
					document.body.style.cursor='default';					
				}
			}
		
			qstr = 'module=' + escape(module);  // NOTE: no '?' before querystring
			qstr += '&option=' + escape(option); 
			qstr += '&ETLSchemeCode=' + escape(ETLSchemeCode); 
			qstr += '&maintaincfg=' + escape(maintaincfg); 
			qstr += '&TransformationCode=' + escape(TransformationCode); 
            qstr += '&ETLSchemeID=' + escape(ETLSchemeID);
			qstr += '&sequencenum=' + escape(sequencenum); 
			qstr += '&valuetype=' + escape(valuetype);
			qstr += '&TransformationID=' + escape(TransformationID);
			qstr += '&valuetypeselected=' + escape(valuetypeselected);
						
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
	
	
	
	

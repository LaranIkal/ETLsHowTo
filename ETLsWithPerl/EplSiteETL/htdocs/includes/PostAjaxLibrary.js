function xmlhttpPost(strURL,EplSiteform,DivField) {		

  var UseAjax = EplSiteform.UseAjax.value;
  
  if(EplSiteform.reportindisplay.checked==1) {
    TheTimeOut = setTimeout("document.body.style.cursor='wait'", 1);
    try {
      updatepage("Processing, please wait...",DivField);
      xmlhttpPost2(strURL,EplSiteform,DivField);
      //~ document.body.style.cursor='default';
    }	catch(err){ clearTimeout(TheTimeOut); document.body.style.cursor='default'; }
    //~ setTimeout("document.body.style.cursor='default'", 1);
    //~ try
    //~ {
      //~ document.body.style.cursor='default';
    //~ }
    //~ catch(err1){document.body.style.cursor='default';}
    //~ clearTimeout(TheTimeOut);
    //~ document.body.style.cursor='default';
  }	else{
    EplSiteform.submit();
  }
}



function xmlhttpPost2(strURL,EplSiteform,DivField) {

  var xmlHttpReq = false;
  var self = this;

  // Mozilla/Safari/Chrome
  if (window.XMLHttpRequest) {
    self.xmlHttpReq = new XMLHttpRequest();
  }
  // IE
  else if (window.ActiveXObject) {
    self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
  }
  
  self.xmlHttpReq.open('POST', strURL, true);
  self.xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
  //~ self.xmlHttpReq.setRequestHeader("Content-Type", "text/html; charset=ISO-8859-1");
  self.xmlHttpReq.onreadystatechange = function() {
    if (self.xmlHttpReq.readyState == 4) {				
      updatepage(self.xmlHttpReq.responseText,DivField);
      clearTimeout(TheTimeOut);
      document.body.style.cursor='default';
    }
  }

  self.xmlHttpReq.send(getquerystring(EplSiteform));
}


		
function updatepage(str,DivFieldToUpdate) {		
	document.getElementById(DivFieldToUpdate).innerHTML = str;
}



function testForEnter() {    
  if (event.keyCode == 13) {
    event.cancelBubble = true;
    event.returnValue = false;
  }
}


	
function ConfirmSubmit(Question) {
  var answer = confirm(Question);
  if (answer)
    return true;
  else
    return false;
}



function xmlhttpValidateAndSubmit(strURL,EplSiteform,DivFieldToUpdate,EplSiteformID,EplSiteOption) {

  var xmlHttpReq = false;
  var self = this;
  // Getting form data
  var FormEplSite = EplSiteform;
  var module = FormEplSite.module.value;
  var task_name = FormEplSite.task_name.value;
  var actstep = FormEplSite.actstep.value;
  //~ var option = FormEplSite.option.value;
  
  FormEplSite.option.value = EplSiteOption;
  //~ var option = FormEplSite.option.value;
  var SentFromAjax = 1;
  
  //~ var qstr = 'option=' + escape(option); // NOTE: no '?' before querystring
  var qstr = 'SentFromAjax=' + escape(SentFromAjax); // NOTE: no '?' before querystring
  var str = "";
  var elem = document.getElementById(EplSiteformID).elements;
  for(var i = 0; i < elem.length; i++) {
    str += "<b>Type:</b>" + elem[i].type + "&nbsp&nbsp";
    str += "<b>Name:</b>" + elem[i].name + "&nbsp;&nbsp;";
    str += "<b>Value:</b><i>" + elem[i].value + "</i>&nbsp;&nbsp;";
    str += "<BR>";		
    qstr += '&' + elem[i].name + '=' + escape(elem[i].value);
  } 		
  
  //~ alert(sourcesystem);	
  
  TheTimeOut = setTimeout("document.body.style.cursor='wait'", 1);
  try {	
    //~ document.getElementById(DivFieldToUpdate).innerHTML = str + "<br>Validating Form Data, please wait...";
    document.getElementById(DivFieldToUpdate).innerHTML = "Validating Form Data, please wait...";
    
    if (window.XMLHttpRequest) {
      self.xmlHttpReq = new XMLHttpRequest();
    }
    // IE
    else if (window.ActiveXObject) {
      self.xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
    }
    
    self.xmlHttpReq.open('POST', strURL, true);
    self.xmlHttpReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    //~ self.xmlHttpReq.setRequestHeader("Content-Type", "text/html; charset=ISO-8859-1");
    self.xmlHttpReq.onreadystatechange = function() {
      if (self.xmlHttpReq.readyState == 4) {
        updatepage(self.xmlHttpReq.responseText,DivFieldToUpdate);
        clearTimeout(TheTimeOut); 
        document.body.style.cursor='default';
        
        if( self.xmlHttpReq.responseText == "Validation OK, Data Saved, Submiting Form." ) {
          FormEplSite.debugoption.value = 1;
          //~ alert(FormEplSite.option.value);
          EplSiteform.submit();
        }
      }
    }
      
    self.xmlHttpReq.send(qstr);			
  
  } catch(err){clearTimeout(TheTimeOut); document.body.style.cursor='default';}
}

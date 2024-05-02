<%@LANGUAGE=JSCRIPT%>
<%
	var winTitle = "Possible Values";
	var winLevels = 3;
	var winTarget = "";
	var winDB = "";
	var winDir = "ltr";
	var allowSearch = false;
	var multiTarget = false;
	var firstValue = "";
	var firstPath = "";
	if(Request.QueryString("FirstPath").Count > 0)
		firstPath = Request.QueryString("FirstPath").Item;
	if(Request.QueryString("Title").Count > 0)
		winTitle = Request.QueryString("Title").Item;
	if(Request.QueryString("FirstValue").Count > 0)
		firstValue = Request.QueryString("FirstValue").Item;
	if(Request.QueryString("Dir").Count > 0)
		winDir = Request.QueryString("Dir").Item;
	if(Request.QueryString("Levels").Count > 0)
		winLevels = parseInt(Request.QueryString("Levels").Item,10);
	if(Request.QueryString("Target").Count > 0)
		winTarget = Request.QueryString("Target").Item;
	if(Request.QueryString("DB").Count > 0)
		winDB = Request.QueryString("DB").Item;
	else
		retError("Error: No Database.");
	if(Request.QueryString("MultiTarget").Count > 0)
		multiTarget = true;
	else if (winLevels == 1)
		allowSearch = false;
	if(Request.QueryString("NoSearch").Count > 0)
		allowSearch = false;
	else if (winLevels == 1)
		allowSearch = false;
	var nodenamesNum = Request.QueryString("Nodename").Count;
	var levelNodenames = new Array(winLevels);
	for(var c=1; c <= winLevels; c++)
	{
		if(c <= nodenamesNum)
			levelNodenames[c] = Request.QueryString("Nodename").Item(c);
		else
			levelNodenames[c] = "L"+c;
	}
%>
<HTML>
<HEAD>
<LINK rel="stylesheet"id="textButtonCss" href="../Styles/textButtons.css" type="text/css" title="style">
<LINK rel="stylesheet"id="popUpCss" href="../Styles/popUpMenu.css" type="text/css" title="style">
<STYLE type="text/css">
	DIV.levels {overflow:auto;border:3px inset light-green;width:expression(levelWidth);height:expression(levelHeight);font-family:'Arial';background-color:'#D7EaFb'}
	SPAN {height:8;background-color:'white';font-family:'Arial';}
	INPUT.levels {behavior: url('level.htc');border:1px solid #8C98A4;width:expression(levelWidth-40);height:expression(textHeight+1);font-size:11;font-family:'Arial';}
	BUTTON.levels {width:40;height:expression(textHeight+1);font-size:textHight-6;}
</STYLE>
<XML id="keyWords" src></XML>
<XML id="keysXsl" src></XML>
<XML id="sortXsl" src></XML>
<!--#include FILE="..\Lib\AddressBuilder.inc"-->
<SCRIPT language="JavaScript">
<!--
	var SEPARATOR = "/"
	var firstPath = "<%= firstPath %>";
	var targetName = "<%= winTarget  %>";
	var firstValue = "<%= firstValue  %>";
	var multiTarget = <%= multiTarget?"true":"false" %>;
	var levels = <%= winLevels %>;
	var searchEnabled = <%= allowSearch?"true":"false" %>;
	var saveValuesRef = "/Director/Keywords/saveValues.asp"
	var firstLevel;
	keyWords.src = "<%= winDB  %>";
	keysXsl.src = "../../OliveStyles/Keywords/keysXsl.xsl";
	sortXsl.src = "../../OliveStyles/Keywords/searcher.xsl";
	
	var locale = null;
	if(window.opener && window.opener.locale)
		locale = window.opener.locale;
	if(window.opener && window.opener.topWin && window.opener.topWin.locale)
		locale = window.opener.topWin.locale;

	var levelHeight = 300;
	var levelWidth  = 150;
	var textHeight  = 18;
	var bgOrgColor = "#D7EaFb";
	var bgColor	 = "red";
	var orgColor     =  "BLACK";
	var bgOver	 = "#FFFFF0";

	var offHight;
	var popLevel;
	var popElement;		

	function init()
	{
		var c;

		keyWords.async = false;
		keyWords.load(keyWords.src);
		if(!keyWords.load(keyWords.src))
		{
			retError("Internal Error: Cannot open database: " + keyWords.parseError.reason);
			return;
		}
		keysXsl.async = false;
		if(!keysXsl.load(keysXsl.src))
		{
			retError("Internal Error: Cannot open Key's XSL: " + keysXsl.parseError.reason);
			return;
		}
			
		sortXsl.async = false;
		sortXsl.load(sortXsl.src);
		if(!sortXsl.load(sortXsl.src))
		{
			retError("Internal Error: Cannot open Sorter XSL: " + sortXsl.parseError.reason);
			return;
		}

		firstLevel = text_1;
		firstLevel.prevLevel = null;
		if(multiTarget)
			firstLevel.readOnly = true;
		else
			firstLevel.readOnly = false;
		firstLevel.initLevel();
		firstLevel.value = "";
		var	prevLev = firstLevel;
		curLev = firstLevel;
		for(c=2; c<=levels; c++)
		{
			curLev = document.all["text_"+c]
			if(!curLev)
				retError("Internal Error: Cannot obtain Level Text Box - level " + c);
			else
			{
				prevLev.nextLevel = curLev;
				curLev.prevLevel = prevLev;
				curLev.initLevel();
				curLev.value = "";
				prevLev = curLev;
			}				
		}
		curLev.nextLevel = null;
		if(firstPath)
			firstLevel.initDiv(keyWords.selectSingleNode(firstPath));
		else
			firstLevel.initDiv(keyWords.documentElement);

		offHight = firstLevel.list.all["lev_0"].offsetHeight;
		window.opener.status = locale.getLocaleText("VALUES_READY");	
		window.attachEvent("onresize",resizeLevels);			
		window.focusDialog(firstValue)
	}				

	function retError(msg)
	{
		alert(msg);
		window.close();
	}
	
	function resizeLevels()
	{				
		levelWidth = ((document.body.clientWidth-30)/levels)
		if(searchEnabled && !searchResultsTr.disabled)
			levelHeight=(document.body.clientHeight-searchResults.clientHeight-80);
		else
			levelHeight=(document.body.clientHeight-80);
		document.recalc();
	}

	function search()
	{
		keyWords.documentElement.setAttribute("SEARCH_STRING",searchText.value);
		searchResults.innerHTML ="";
		searchResults.innerHTML =keyWords.documentElement.transformNode(sortXsl.XMLDocument);
		openSearch(true);
	}
	

	function openSearch(force)
	{		
		if(searchResultsTr.disabled || force )			
		{	// Open search results.				
			openSearchButton.all["buttonText"].innerText = "<<";				
			searchResultsTr.style.display = "block";
			searchResultsTr.style.visibility = "visible";			
			if(searchResultsTr.disabled)
				window.resizeBy(0,200);
			searchResultsTr.disabled = false;
		}
		else
		{	// close search results.
			searchResultsTr.disabled = true;
			openSearchButton.all["buttonText"].innerText = ">>";
			searchResultsTr.style.display = "none";
			searchResultsTr.style.visibility = "hidden";
			window.resizeBy(0,-200);
		}		
	}
	
	function focusDialog(fValue)
	{		
		window.resizeTo(keysTable.clientWidth + 50,keysTable.clientHeight+65);			
		window.moveTo(0,300);
		window.focus();
		if(fValue)
		{
			firstLevel.value = fValue;
			firstLevel.keyPressed();
			firstLevel.getCurrentLine(false,true,false);
			if(firstLevel && firstLevel.nextLevel)
				firstLevel.nextLevel.focus();
		}	
		else
		{
			try // Focus might fail if control is disabled
			{
				firstLevel.focus();
			}
			catch(x) {}
		}
	}		

	function sendRequest(asp,s)
	{
		var xmlReq = new ActiveXObject("microsoft.xmlhttp");
		xmlReq.open("GET",addressBuild(asp+"?"+s),false);
		xmlReq.send("");
		return xmlReq;
	}
	
	function responseValid(xmlReq)
	{
		if(xmlReq.responseXml && 
			xmlReq.responseXml.documentElement && 
			 xmlReq.responseXml.documentElement.nodeName != "Error")
		{
			ourAlert(locale.getLocaleText("TITLE_EXTERNAL"),locale.getLocaleText("!VALUES_MODIFIED"));
			return true;
		}
		else
		{
			ourAlert(locale.getLocaleText("TITLE_EXTERNAL"),locale.getLocaleText("!VALUES_NOT_MODIFIED"));
			return false;
		}
	}
	
	function ourAlert(title, txt)
	{
		window.showModalDialog("../yesNoDialog.htm",new Array(0,title,txt,new Array("Ok")),"help:no;resizable:no;status:no;dialogHeight:100px;dialogWidth:320px;");
	}
	
	function ourConfirm(title, txt)
	{
		return window.showModalDialog("../yesNoDialog.htm",
									  new Array(1,title,txt,new Array("Yes","No")),
									  "help:no;resizable:no;status:no;dialogHeight:100px;dialogWidth:320px;");
	}

	
	function getLevel(n)
	{
		if(n<1 || n> levels)
			return;
		curLev = firstLevel;
		while(n!=1)
		{
			curLev = curLev.nextLevel;
			n--;
		}
		return curLev;
	}
		
	
	function showPopup(x,y,lvl,spnElm)
	{
		popUp.style.display = "block";
		popUp.style.visibility = "visible";
		popUp.style.left=x;
		popUp.style.top=y;
		keysTable.attachEvent("onclick",hidePopup);
		popLevel = lvl;
		popElement = spnElm;
	}

	function hidePopup()
	{			
		keysTable.detachEvent("onclick",hidePopup);			
		popUp.style.display = "none";
		popUp.style.visibility = "hidden";
	}
	
	function actCurLine(bool1,bool2,bool3)
	{	
		popLevel.getCurrentLine(bool1,bool2,bool3);			
	}

	function addAsNew(level)
	{
		var levelObj = getLevel(level);
		var newLevel = false;
		var reqStr = "";

		if(!levelObj.value)
			return;						
		if(levelObj.addButton.Enabled == false)
			return;
		levelObj.enableNew(false);

		if(levelObj.list.innerHTML=="")
		{
			newLevel = true;
		}
		reqStr = saveValuesString("ADD",levelObj,newLevel);
		reqStr += "&Text="+stringToHexEscape(levelObj.value);
		var xmlReq = sendRequest(saveValuesRef,reqStr);

		if(responseValid(xmlReq))
		{
			window.location = window.location;
			return;
			var newPar = xmlReq.responseXml.firstChild;
			var curNode = levelObj.levelNodes[levelObj.curIndex];
			if(!newLevel)
				curNode.parentNode.parentNode.replaceChild(xmlReq.responseXml.firstChild,curNode.parentNode);
			else 								
				curNode.parentNode.replaceChild(xmlReq.responseXml.firstChild,curNode);
		}
	}

	function saveValuesString(action, levelObj, newLevel)
	{
		var reqStr = "DB="+ keyWords.src + "&Action=" + action + "&Level="+levelObj.level + "&Nodename="+levelObj.lnodename;

		var searchPath = firstPath;
		if(newLevel)
		{
			reqStr += "&NewLevel=True";
			levelObj = levelObj.prevLevel;
		}
		for(var l=firstLevel; l && l.level<=levelObj.level; l=l.nextLevel)			
			searchPath += "/"+l.lnodename + "[index()=" +l.curIndex + "]";
		reqStr += "&DBPath="+searchPath;
		return reqStr;
	}

	function modifyCurLine()
	{		
		popLevel.enableNew(false);
		var newTxt=window.showModalDialog("../yesNoDialog.htm",new Array(2,locale.getLocaleText("TITLE_EXTERNAL"),locale.getLocaleText("ENTER_NEW_VALUE"),new Array("Modify","Cancel",popLevel.curLine.innerText)),"help:no;resizable:no;status:no;dialogHeight:125px;dialogWidth:320px;");
		if(!newTxt || newTxt=="") 
			return;

		var reqStr = saveValuesString("MODIFY",popLevel);
		reqStr += "&Text=" + stringToHexEscape(newTxt);
		
		var xmlReq = sendRequest(saveValuesRef,reqStr);
		if(responseValid(xmlReq))
		{
			window.location = window.location;
		}
	}

	function deleteCurLine()
	{
		if(!ourConfirm(locale.getLocaleText("TITLE_EXTERNAL"),locale.getLocaleText("?DELETE_VALUE")))
			return;
		popLevel.enableNew(false);
		
		var reqStr = saveValuesString("DELETE",popLevel);
		var xmlReq = sendRequest(saveValuesRef,reqStr);
		if(responseValid(xmlReq))
		{
			window.location = window.location;
		}
	}
	
	function submitValue(value)
	{
		if(multiTarget)
		{
			if(value.indexOf(SEPARATOR)== -1)
				return;
			window.opener.addValue(value.substr(0,value.indexOf(SEPARATOR)),
									value.substr(value.indexOf(SEPARATOR)+1));
		}
		else
			window.opener.addValue(value, targetName);
	}
		

function mouseOverSearch()
{
	if(event.srcElement.tagName=="TD");
	event.srcElement.style.color=bgOver;
}
function mouseOutSearch()
{
	if(event.srcElement.tagName=="TD");
	event.srcElement.style.color=orgColor;;
}	
function getSearchLine()
{
	if(event.srcElement.tagName=="TD")
	{
		submitValue(event.srcElement.innerText);
	}
}
function stringToHexEscape(str)
{
	var retVal = "";
	var c,tmp;
	for(var i=0;i<str.length;i++)
	{
		c = str.charCodeAt(i);
		tmp = c.toString(16);
		if(c<=127)
			retVal += "%"+tmp
		else if(tmp.length == 3)
			retVal += "%u0"+tmp;
		else
			retVal += "%u"+tmp;
	}
	return retVal;
}

-->
</SCRIPT>
<TITLE>
<%= winTitle %>
</TITLE>
</HEAD>
<BODY dir="<%= winDir %>" onload="init()" bgcolor="#C4D5E5">
<TABLE id="keysTable" cellspacing="0" cellpadding="1">
  <TR>
	<% 
		for (var c=1; c<=winLevels; c++)
		{
	%>
	<TD nowrap>
      <DIV id="list_<%= c %>" onkeydown="return text_<%= c %>.keyDown();" class="levels" level="<%= c %>"></DIV>
      <INPUT id="text_<%= c %>" class="levels" type="text" level="<%= c %>" lnodename="<%= levelNodenames[c] %>" size="50">
      <SPAN dir="ltr" id="new_<%= c %>" onclick="addAsNew(<%= c %>)" style="background-color:#C4D5E5;behavior:url('../Behaviors/TextButton.htc');cursor:hand;" onload="new_<%= c %>.Disable()"><IMG align="middle" height="19" src="../Images/buttons/sml_but1_d.gif" border=0><SPAN id=buttonText class="smlButtonText" style="BACKGROUND-IMAGE: url(../Images/buttons/sml_but2_d.gif);background-color:#C4D5E5;">Add</SPAN><IMG align="middle" height="19" src="../Images/buttons/sml_but3_d.gif" border=0></SPAN></TD>
    <%
		}
	%>
  </TR>
	<% 
		if (allowSearch)
		{ 
	%>
  <TR>
    <TD colspan="<%= winLevels-1 %>" align="right" nowrap>
      <INPUT id="searchText" type="text" style="width:100%">
    </TD>
    <TD align="right" nowrap><SPAN dir="ltr" id="searchButton" title="Search for Keywords" onClick="search()" style="background-color:#C4D5E5;behavior:url('../Behaviors/TextButton.htc');cursor:hand;" Enabled=true><IMG align="middle" src="../Images/buttons/main_but1_n.gif" border=0><SPAN id="buttonText" style="width:60" class="bigButtonText">Search</SPAN><IMG align="middle" src="../Images/buttons/main_but3_n.gif" border=0></SPAN><SPAN dir="ltr" id="openSearchButton" title="Open Keywords Search" onClick="openSearch()" style="background-color:#C4D5E5;behavior:url('../Behaviors/TextButton.htc');cursor:hand;" Enabled=true><IMG align="middle" src="../Images/buttons/main_but1_n.gif" border=0><SPAN id="buttonText" class="bigButtonText"><<</SPAN><IMG align="middle" src="../Images/buttons/main_but3_n.gif" border=0></SPAN></TD>
  </TR>
  <TR id=searchResultsTr style="visibility:hidden;display:none" disabled=false>
    <TD colspan="<%= winLevels %>">
      <DIV id="searchResults" ondblclick="getSearchLine()" onmouseover="mouseOverSearch()" onmouseout="mouseOutSearch()" style="overflow:auto;border:3px inset light-grey;width:expression(levelWidth*<%= winLevels %>);height:expression(levelHeight/2);"></DIV>
    </TD>
  </TR>
  <%
  	}
  %>
</TABLE>
<DIV id="popUp" onclick="hidePopup()" style="width:100;position:absolute;top:0;left:0;visibility:hidden;display:none;" class="popUpMenu">
  <TABLE align="center" width="100%" height="95%" cellpadding="1" cellspacing="1" onmouseover="mouseOverSearch()" onmouseout="mouseOutSearch()" style="margintop:10">
    <TR>
      <TD class="popUpAction" onclick="actCurLine(false,true,false)">Open</TD>
    </TR>
    <TR>
      <TD nowrap class="popUpAction"onclick="modifyCurLine()">Rename</TD>
    </TR>
    <TR>
      <TD nowrap class="popUpAction"onclick="deleteCurLine()">Delete</TD>
    </TR>
    <TR>
      <TD>
        <HR width='100%' height='1' />
      </TD>
    <TR>
    <TR>
      <TD nowrap class="popUpAction" onclick="actCurLine(true,false,false)">Get Word</TD>
    </TR>
    <TR>
      <TD nowrap class="popUpAction"onclick="actCurLine(false,false,true)">Get Path</TD>
    </TR>
  </TABLE>
</DIV>
</BODY>
</HTML>

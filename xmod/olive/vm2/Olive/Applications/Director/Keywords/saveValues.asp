<!-- #INCLUDE virtual="/OliveCommon/ASP-Lib/AspDeclaration.inc" -->
<!--#include virtual="/OliveCommon/ASP-Lib/ApplicationError.inc"-->
<!--#include virtual="/OliveCommon/ASP-Lib/XMLError.inc"-->
<%	
	Response.Expires = -1; 
	try
	{	
		var dbFile = Request.QueryString("DB").Item;
		var dbPath = Request.QueryString("DBPath").Item;
		var dbXMLSrc = Server.MapPath(dbFile);
		var dbXML  = Server.CreateObject("Microsoft.FreeThreadedXMLDOM");
		dbXML.async = false;
		dbXML.validateOnParse = false;		
		if(!dbXML.load(dbXMLSrc))
			RetError("Error openning database file: " + dbXML.parseError.reason);
		
		var curNode = dbXML.documentElement.selectSingleNode("/" + dbPath);
		if(!curNode)
			RetError("Unable to get specified node, searched for: " + dbPath);
		var action = Request.QueryString("Action").Item;
	
		switch (action)
		{
			case "ADD":
						var nname = Request.QueryString("Nodename").Item;
						var newNode = dbXML.createElement(nname);
						var newTxtNode = dbXML.createTextNode((Request.QueryString("Text").Item).toUpperCase());
						newNode.appendChild(newTxtNode);
						if(Request.QueryString("NewLevel").Item)
						{
							addNodeInPlace(curNode, newNode);
						}			
						else
						{
							addNodeInPlace(curNode.parentNode, newNode);
						}
						dbXML.save(dbXMLSrc);
						Response.ContentType = "text/xml";
						writeXmlHeader(newNode.ownerDocument);
						Response.Write(newNode.parentNode.xml);
						break;
	
			case "DELETE":
						var par = curNode.parentNode;
						par.removeChild(curNode);
						dbXML.save(dbXMLSrc);
						Response.ContentType = "text/xml";
						writeXmlHeader(par.ownerDocument);
						Response.Write(par.xml);
						break;
	
			case "MODIFY":
						// 1. deleting the node.
						var par = curNode.parentNode;
						par.removeChild(curNode);
						// 2. creating the new text node
						var newTxt = (Request.QueryString("Text").Item).toUpperCase()
						var textNode = curNode.selectSingleNode("textnode()");
						if(textNode)
							textNode.text = newTxt;
						else
						{
							textNode = dbXML.createTextNode(newTxt);
							curNode.appendChild(textNode);
						}
						
						addNodeInPlace(par, curNode);
						
						// 5. sending the new parent.
						dbXML.save(dbXMLSrc);
						Response.ContentType = "text/xml";
						writeXmlHeader(par.ownerDocument);
						Response.Write(par.xml);
						break;
			default:
						RetError("Unknown action: " + action);
						break;
		}
	}
	catch(x)
	{
		RetError(x);
	}
	
	function addNodeInPlace(par, newNode)
	{
		var i = 0;
		var curText;
		var allNodes = par.selectNodes("*");
		var newText = newNode.selectSingleNode("textnode()").text;

		
		while(i < allNodes.length)
		{ 
			curText = allNodes[i].selectSingleNode("textnode()");
			if(!curText)
				break;
			if(biggerStr(newText, curText.text))
				i++;
			else break;
		}

		if(allNodes.length==0 || i==allNodes.length)
			par.appendChild(newNode);
		else 
			par.insertBefore(newNode,allNodes[i]);
	}	
	
	
	function biggerStr(str1,str2)
	{// check if str2<str1
		var s1 = str1.toLowerCase();
		var s2 = str2.toLowerCase();
		for(var i=0;i<s2.length;i++)
		{
			if(i==s1.length || s2.charCodeAt(i)<s1.charCodeAt(i))
				return true;
			else if(s2.charCodeAt(i)>s1.charCodeAt(i)) 
				return false;
		}
		return false;
	}	

	function writeXmlHeader(xml)
	{
		Response.Write("<?xml " + xml.selectSingleNode("pi()").text + "?>");
	}
%>

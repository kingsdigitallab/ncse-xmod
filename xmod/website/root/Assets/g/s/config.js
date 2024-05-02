// xMod 1.3 JS Library: Configuration
// This file can be edited 

// Define invoking class for type 1 HTML Popup 
var htmlPopup1Class = "x89";
// Define javascript window:open parameters for type 1 HTML Popup 
// All options: "toolbar=yes,location=yes,directories=yes,status=yes,menubar=yes,resizable=yes,scrollbars=yes,width={px},height={px}";
var htmlPopup1Params = "width=300,height=300";
// Define invoking class for type 2 HTML Popup 
var htmlPopup2Class = "x88";
// Define javascript window:open parameters for type 2 HTML Popup 
var htmlPopup2Params = "width=600,height=600";
// Define invoking class for auto-sizing image popup 
var imgPopupClass = "x87";

function collapseContent () {
// EXAMPLE: addShowHide ('content element class/content element type no. class','trigger class','target class','target open class ','target closed class','trigger open class','trigger closed class');
//addShowHide('unorderedList/t03','x70','x71','z01','z02','z03','z04');
}

function tabContent (){
// EXAMPLE: var T=new tabs('content element class/content element type no. class','trigger class','trigger parent class','tab JS active class','tab content div class','trigger active class','trigger inactive class','target open class','target closed class');
var T=new tabs('tabContent/t01','x30','x31','x32','x33','s03','','z03','z04');
//Not mandatory, but makes things faster.  Default is *            
T.tElem="A";
//Also optional.  Useful from a speed perspective, and to keep multiple scripts straight
T.cElem="DIV";
//T.container=getElementsByClassName(document.body,'div','container1')[0];
T.init();
}
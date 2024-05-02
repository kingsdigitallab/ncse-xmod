/**
* Opens a thesaurus window according to the given type.
*/
function openThesaurus(type, url) {
  if (type == "image-key") {
    open("image-thesaurus-" + url + ".html", "thesaurus", 'resizable=yes,scrollbars=yes,width=450,height=500');
  } else {
    open("subject-thesaurus-" + url + ".html", "thesaurus", 'resizable=yes,scrollbars=yes,width=450,height=500');
  }
}

/**
* Adds terms from the thesaurus to the key and text elements that were passed  to the openThesaurus.
*/
function addTerms(key, txt) {
  var termKey = "";
  var termTxt = "";
      
  key.value = "";
  txt.value = "";
  
  for (var idx = 0; idx < document.frmThesaurus.thesChk.length; idx++) {
    if (document.frmThesaurus.thesChk[idx].checked == true) {
      var id = document.frmThesaurus.thesChk[idx].value;
      termKey += id + " ";
      termTxt += document.getElementById(id) .getAttribute("title") + " ";
    }
  }
  
  key.value = termKey;
  txt.value = termTxt;
  txt.readOnly = true;
  txt.className = "f01 s01";
}

/**
* Updates the value of the hidden support field for the publication select.
*/
function updatePublication() {
  var text = document.frmSearch.publicationTxt;
  text.value = "";
  
  var start = document.frmSearch.publicationSel.selectedIndex;
  var end = document.frmSearch.publicationSel.length;
  
  for (var idx = start; idx < end; idx++) {
    if (document.frmSearch.publicationSel.options[idx].selected) {
      text.value += document.frmSearch.publicationSel.options[idx].text + " ";
    }
  }
  
  text.value = text.value.replace(/^\s + |\s + $/g, '');
}
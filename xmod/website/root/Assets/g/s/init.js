// xMod 1.3 JS Library: Initialisation
// This file should NOT be edited: copy it into your personality pack and edit it there.
//
// The default file loads two functions which work on every xMod 1.3 site.  The other functions
// will throw an error if they are called on pages where there are no tabs or collapsible content
// so don't use them unless you know you need to.

window.onload = function() {
externalLinks();
popupManager();

// Enable the following functions ONLY if they're needed: copy this file into the local 
// personality pack and make sure it's loaded in from there.  
// Note that collapseContent() and tabContent() REQUIRE entries in the config.js file, which should
// also be moved into the PPack and loaded in here.

//collapseContent();
//tabContent();

}

var gilll = { src: '/assets/flash/sifr-gill-l.swf' };
var gillr = { src: '/assets/flash/sifr-gill-r.swf' };

  sIFR.delayCSS  = true;
  sIFR.activate(gillr,gilll);
  
  sIFR.replace(gillr, {
    selector: '#contentcenter h2'
    ,css: ['.sIFR-root { color: #ffffff; background-color: #230c1b; letter-spacing: 0.3; leading: -1; }' ],tuneHeight: '-3',tuneWidth: '2',fitExactly: 'true'
  });

  sIFR.replace(gillr, {
    selector: '#wrapper #contentleft div.box h3.collections'
    ,css: ['.sIFR-root { color: #b4ac98; letter-spacing: 0.3; }'],tuneHeight: '0',tuneWidth: '2',fitExactly: 'true',wmode: 'transparent'
  });

  sIFR.replace(gillr, {
    selector: '#wrapper #contentcenter .boxnone h1,contentleft div.box h3,#contentleft div.box h3,#contenttwo div.box h1,#contentone div.box h1,#contentcenter .newbox .inner h1,#wrapper #contentright .box h3'
    ,css: ['.sIFR-root { color: #ffffff; background-color: #f5eff0; letter-spacing: 0.3; }'],tuneHeight: '0',tuneWidth: '2',fitExactly: 'true',wmode: 'transparent'
  });

  sIFR.replace(gillr, {
    selector: 'ul#nav li span'
   ,css: ['.sIFR-root { color: #ffffff; background-color: #230c1b; letter-spacing: 0.3; }'
   ,'a { color: #a3ac88; text-decoration: none; }'
   ,'a:hover { color: #ffffff; }']
   ,tuneHeight: '0',tuneWidth: '2',fitExactly: 'true'
  });

  sIFR.replace(gillr, {
    selector: '#contentleft div.box h4'
   ,css: ['.sIFR-root { color: #b4ac98; background-color: #381928; }'],tuneHeight: '-7',fitExactly: 'true'  });

function openURL(url, hidden) {
    if (hidden === true){
    var windowName = document.querySelectorAll("title")[0].text;
    var iframe = '<html><head><style>body, html {width: 100%; height: 100%; margin: 0; padding: 0}</style><title>'+windowName+'</title></head><body><iframe frameBorder="0" id="iframe" src="'+url+ '"style="height:calc(100%);width:calc(100%)"></iframe><script>function update(){document.title = document.getElementById("iframe").contentDocument.document.title;window.requestAnimationFrame(update);}window.requestAnimationFrame(update);</script></html></body>';
    var tab = window.open("about:blank", '_blank');
    tab.focus();
    tab.document.write(iframe);}
    else {window.location.href = url;}
}
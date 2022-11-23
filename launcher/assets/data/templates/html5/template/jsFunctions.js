
function openURL(url, hidden) {
    if (hidden === true){
    var windowName = document.querySelectorAll("title")[0].text;
    var iframe = '<html><head><style>body, html {width: 100%; height: 100%; margin: 0; padding: 0}</style><title>'+windowName+'</title></head><body><iframe frameBorder="0" id="iframe" src="'+url+ '"style="height:calc(100%);width:calc(100%)"></iframe><script>function update(){document.title = document.getElementById("iframe").contentDocument.document.title;window.requestAnimationFrame(update);}window.requestAnimationFrame(update);</script></html></body>';
    var tab = window.open("about:blank", '_blank');
    tab.focus();
    tab.document.write(iframe);}
    else {window.location.href = url;}
}
var deferredPrompt;
window.addEventListener('beforeinstallprompt', (e) => {
    // Prevent Chrome 67 and earlier from automatically showing the prompt
    e.preventDefault();
    // Stash the event so it can be triggered later.
    deferredPrompt = e;
    // Update UI notify the user they can add to home screen
    btnAdd.style.display = 'block';
  });
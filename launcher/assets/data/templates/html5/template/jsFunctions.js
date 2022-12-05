
function openURL(url, hidden, title) {
    if (hidden === true) {
        const windowName = title;
        const iframe = '<html><head><style>body, html {width: 100%; height: 100%; margin: 0; padding: 0} * {overflow-x: hidden; overflow-y: hidden; overflow: hidden;}</style><title>' + windowName + '</title></head><body><iframe scrolling="no" frameBorder="0" id="iframe" src="' + url + '"style="height:calc(100%);width:calc(100%)"></iframe><script>function update(){document.title = document.getElementById("iframe").contentDocument.document.title;window.requestAnimationFrame(update);}window.requestAnimationFrame(update);</script></html></body>';
        var tab = popupWindow("about:blank", "_blank", window, 640, 480);
        tab.focus();
        tab.document.write(iframe);
    }
    else { window.location.href = url; }
}
function popupWindow(url, windowName, win, w, h) {
    const y = win.top.outerHeight / 2 + win.top.screenY - (h / 2);
    const x = win.top.outerWidth / 2 + win.top.screenX - (w / 2);
    return win.open(url, windowName, `toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=${w}, height=${h}, top=${y}, left=${x}`);
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
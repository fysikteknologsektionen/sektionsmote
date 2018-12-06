function focusField(event, key, field) {
  var tag = event.target.tagName;
  if (field === null || event.defaultPrevented ||
      event.key !== key || tag === 'INPUT' || tag === 'TEXTAREA') {
    return; // Do nothing if the event was already processed or key was not s
  }

  field.focus();
  event.preventDefault();
}

function searchKeydown(event) {
  focusField(event, 's', document.getElementById('search-card'))
}

function adjustKey(event) {
  focusField(event, 'a', document.getElementById('adjust'))
}

function sendAdjustStatus(event) {
  // Wait for UI to update until data is fetched
  setTimeout(function(){

    clearTimeout(statusWindow.resetTimer);
    var adjustButton = event.target;
    var adjustType = !(adjustButton.getAttribute('data-method') === 'delete');
    statusWindow.document.getElementById('message').textContent = '⏳';
    statusWindow.checkTimer = setTimeout(function(){
      if (document.getElementById('error-display').hasChildNodes()) {
        statusWindow.document.getElementById('message').textContent = '⚠️ Error!';
        clearTimeout(statusWindow.resetTimer);
        setTimeout(function(){location.reload();},3000);
      } else {
        statusWindow.document.getElementById('message').textContent = (adjustType ? '✔️ ': '❌ ') + $('#vote-user h3').text().trim();
        adjustButton.setAttribute('data-method', adjustType ? 'delete' : 'patch');
        adjustButton.textContent = adjustType ? 'Justera ut' : 'Justera in';
      }
    }, 1000);
    statusWindow.resetTimer = setTimeout(function(){
      statusWindow.document.getElementById('message').textContent = 'Dra ditt kårkort...';
    }, 5000);

  }, 100);
}

function setupShortcuts() {
  document.addEventListener('keydown', adjustKey, true);
  document.addEventListener('keydown', searchKeydown, true);
}

function setupStatusWindow() {
  if (document.getElementById('vote-user')) {
    window.statusWindow = window.open("about:blank", "Status",'menubar=no,toolbar=no,location=no,personalbar=no,status=no');
    var html = '<html><head><title>Status</title><style>body{margin:0;}p{font-size: 8rem;width: 100vw;height: 100vh;display: table-cell;text-align: center;vertical-align: middle;}</style></head><body><p id="message">';
    html += 'Dra ditt kårkort...';
    html += '</p></body></html>';
    statusWindow.document.write(html);
    statusWindow.document.close();
  }
}

function removeShortcuts() {
  document.removeEventListener('keydown', adjustKey, true);
  document.removeEventListener('keydown', searchKeydown, true);
}

document.addEventListener('turbolinks:load', setupShortcuts);
document.addEventListener('turbolinks:load', setupStatusWindow);
document.addEventListener('turbolinks:before-cache', removeShortcuts);

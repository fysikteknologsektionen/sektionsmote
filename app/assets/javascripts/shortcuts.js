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

function autoAdjustOnSearch(event) {
  clearTimeout(statusWindow.resetTimer);
  var adjustButton = event.target;
  var adjustType = !(adjustButton.getAttribute('data-method') === 'delete');
  adjustButton.setAttribute('data-method', adjustType ? 'delete' : 'patch');
  adjustButton.textContent = adjustType ? 'Justera ut' : 'Justera in';
  var message = (adjustType ? '✔️ ': '❌ ') + $('#vote-user h3').text().trim();
  statusWindow.document.getElementById('message').textContent = message;
  statusWindow.resetTimer = setTimeout(function(){
    statusWindow.document.getElementById('message').textContent = 'Väntar på kort...';
  }, 5000);
}

function setupShortcuts() {
  document.addEventListener('keydown', adjustKey, true);
  document.addEventListener('keydown', searchKeydown, true);
}

function setupStatusWindow() {
  if (document.getElementById('vote-user')) {
    window.statusWindow = window.open("about:blank", "Status",'menubar=no,toolbar=no,location=no,personalbar=no,status=no');
    var html = '<html><head><title>Status</title><style>body{margin:0;}p{font-size: 8rem;width: 100vw;height: 100vh;display: table-cell;text-align: center;vertical-align: middle;}</style></head><body><p id="message">';
    html += 'Väntar på kort...';
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

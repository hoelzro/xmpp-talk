const BOSH_ENDPOINT = 'http://chat.madmongers:5280/http-bind'
const ERROR_START = "<span class='error'>";
const ERROR_END = "</span>";

var connection;

function handleError(error) {
  $.notify({
    title: 'Error',
    text: error + ''
  });
}

function showChatUI() {
  $('#chat_ui').removeClass('invisible');

  var iq = $iq({
    type: 'get',
    id: 'roster-iq'
  });
  iq.c('query', {
    xmlns: Strophe.NS.ROSTER
  });
  iq.up();

  connection.sendIQ(iq, function(reply) {
    window.reply = reply;
    console.log($('query > item' ,reply));
  }, function() {
    console.log('not ok', arguments);
  }, 1000);
}

function showLoginDialog() {
  $('#login').dialog({
    hide: 'fade',
    show: 'fade',
    title: 'XMPP Login',
    closeOnEscape: false,
    closeText: '',
    beforeClose: function() {
      return !!connection;
    }
  });
}

function onConnectStatusChange(status, error) {
  switch(status) {
    case Strophe.Status.ERROR:
      $('#login_status').html(ERROR_START + 'Error: ' + error + ERROR_END);
      break;
    case Strophe.Status.AUTHFAIL:
      $('#login_status').html(ERROR_START + 'Authentication failed' + ERROR_END);
      break;
    case Strophe.Status.CONNECTING:
      $('#login_status').html('Connecting...');
      break;
    case Strophe.Status.AUTHENTICATING:
      $('#login_status').html('Authenticating...');
      break;
    case Strophe.Status.CONNECTED:
      $('#login').dialog('close');
      showChatUI();
      break;
  }
}

function doLogin() {
  var jid      = $('#login_jid').val();
  var password = $('#login_password').val();

  $('#login_status').html('');
  connection = new Strophe.Connection(BOSH_ENDPOINT);
  connection.connect(jid, password, onConnectStatusChange);
}

function doRegister() {
  alert('Registering');
  $('#login').dialog('close');
}

function newChat() {
}

function onDisconnect() {
  connection = undefined;
  $('#chat_ui').addClass('invisible');
  showLoginDialog();
}

$(document).ready(function() {
  $('.tabs').tabs();
  $('.button').button();
  $('#login_button').click(doLogin);
  $('#register_button').click(doRegister);
  $('#roster').dblclick(newChat);
  showLoginDialog();
});

/*

- Display roster
- Open chat on roster double click
- Ability to subscribe to new JIDs
- Open chat to non-subscribed contact
- Accept contact subscription
- Join MUCs
 - Show room roster

*/

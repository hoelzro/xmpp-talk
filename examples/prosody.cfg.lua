local lfs = require 'lfs'

admins = {
  "rob@chat.madmongers";
};

modules_enabled = {
  "roster";
  "saslauth";
  "tls";
  "dialback";
  "disco";
  "private";
  "vcard";
  "legacyauth";
  "version";
  "uptime";
  "time";
  "ping";
  "pep";
  "register";
  "bosh";
  "httpserver";
  "announce";
  "privacy";
  "private";
};

modules_disabled = { };
allow_registration = true;
log = "prosody.log";
debug = true;

bosh_ports = { 5280 };
cross_domain_bosh = true;

http_path = lfs.currentdir() .. '/www';
http_ports = { 80 };

VirtualHost "chat.madmongers"

Component "conference.chat.madmongers" "muc"

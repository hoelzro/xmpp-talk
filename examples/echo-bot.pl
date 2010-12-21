#!/usr/bin/env perl

# examples/echo-bot.pl

# This example connects to the server, and loops until terminated.
# This bot accepts all presence subscription requests, and echoes
# every message sent to it back to its sender.

use strict;
use warnings;

use AnyEvent::XMPP::IM::Connection;

my $cond = AnyEvent->condvar;

my $conn = AnyEvent::XMPP::IM::Connection->new(
    jid      => 'bot@chat.madmongers',
    password => 'abc123',
);

$conn->reg_cb(contact_request_subscribe => sub {
    my ( undef, undef, $contact ) = @_;

    $contact->send_subscribed;
});

$conn->reg_cb(message => sub {
    my ( undef, $msg ) = @_;

    my $reply = $msg->make_reply;
    $reply->add_body($msg->body);
    $reply->send;
});

$conn->connect;
$cond->recv;

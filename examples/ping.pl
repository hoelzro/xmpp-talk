#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';

use AnyEvent::XMPP::IM::Connection;

my $cond = AnyEvent->condvar;
my $conn = AnyEvent::XMPP::IM::Connection->new(
    jid      => 'bot@chat.madmongers',
    password => 'abc123',
);

$conn->reg_cb(session_ready => sub {
    $conn->send_iq('get', sub {
        my ( $w ) = @_;

        $w->emptyTag('ping', xmlns => 'urn:xmpp:ping');
    }, sub {
        my ( $result, $error ) = @_;

        if($error) {
            say $error->string;
        } else {
            say 'received pong';
        }
        $cond->send;
    }, to => 'rob@chat.madmongers/Laptop');
});

$conn->connect;

$cond->recv;

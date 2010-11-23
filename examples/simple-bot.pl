#!/usr/bin/env perl

# examples/simple-bot.pl

# This example connects just like bare-bot.pl, but it
# listens for the session_ready and error events and
# discontinues the event loop after either after issuing
# a short status message.

use strict;
use warnings;
use feature 'say';

use AnyEvent::XMPP::IM::Connection;

my $cond = AnyEvent->condvar;

my $conn = AnyEvent::XMPP::IM::Connection->new(
    jid      => 'rob@localhost',
    password => 'abc123',
);

$conn->reg_cb(session_ready => sub {
    say "Successfully connected!";
    $cond->send;
});

$conn->reg_cb(error => sub {
    my ( undef, $error ) = @_;

    say "Uh-oh: " . $error->string;
    $cond->send;
});

$conn->connect;
$cond->recv;

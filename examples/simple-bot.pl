#!/usr/bin/env perl

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

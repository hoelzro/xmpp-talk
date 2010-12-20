#!/usr/bin/env perl

# examples/bare-bot.pl

# This example connects to localhost as the user rob with the password abc123.
# It doesn't handle any events, so the program hangs whether or not the
# login was successful.

use strict;
use warnings;

use AnyEvent::XMPP::IM::Connection;

my $cond = AnyEvent->condvar;

my $conn = AnyEvent::XMPP::IM::Connection->new(
    #jid      => 'rob@localhost',
    username => 'rob',
    domain   => 'localhost',
    resource => scalar(getpwuid $<),
    host     => 'localhost',
    port     => 5222,
    password => 'abc123',
);

$conn->connect;
$cond->recv;

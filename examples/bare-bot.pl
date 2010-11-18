#!/usr/bin/env perl

use strict;
use warnings;

use AnyEvent::XMPP::IM::Connection;

my $cond = AnyEvent->condvar;

my $conn = AnyEvent::XMPP::IM::Connection->new(
    jid      => 'rob@localhost',
    password => 'abc123',
);

$conn->connect;
$cond->recv;

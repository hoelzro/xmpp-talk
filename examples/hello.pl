#!/usr/bin/env perl

use 5.12.0;
use warnings;

use AnyEvent::XMPP::IM::Connection;

die "usage: $0 [destination]\n" unless @ARGV;
my ( $to ) = @ARGV;

my $cond = AnyEvent->condvar;
my $conn = AnyEvent::XMPP::IM::Connection->new(
    username => 'bot',
    domain   => 'chat.madmongers',
    resource => scalar(getpwuid $<),
    host     => 'localhost',
    port     => 5222,
    password => 'abc123',
);

$conn->reg_cb(session_ready => sub {
    my $msg = AnyEvent::XMPP::IM::Message->new(
        to   => $to,
        body => 'Hello, World!',
    );

    $msg->send($conn);

    my $timer;
    $timer = AnyEvent->timer(
        after => 3,
        cb    => sub {
            undef $timer;
            $cond->send;
        },
    );
});

$conn->connect;

$cond->recv;

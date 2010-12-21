#!/usr/bin/env perl

# examples/muc-bot.pl

# This example is basically the same as echo-bot.pl, only
# it also sits inside a MUC room, and responds to messages
# there if preceded with "nickname: " or "nickname, ".

use strict;
use warnings;

use AnyEvent::XMPP::IM::Connection;
use AnyEvent::XMPP::Ext::Disco;
use AnyEvent::XMPP::Ext::MUC;

die "usage: $0 [room]\n" unless @ARGV;
my ( $room ) = @ARGV;
my $nick = getpwuid $<;

my $cond = AnyEvent->condvar;

my $conn = AnyEvent::XMPP::IM::Connection->new(
    jid      => 'bot@chat.madmongers',
    password => 'abc123',
);
my $disco = AnyEvent::XMPP::Ext::Disco->new;
my $muc   = AnyEvent::XMPP::Ext::MUC->new(disco => $disco);

$conn->add_extension($disco);
$conn->add_extension($muc);

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

$conn->reg_cb(session_ready => sub {
    $muc->join_room($conn, $room, $nick);
});

$muc->reg_cb(message => sub {
    my ( undef, undef, $msg ) = @_;

    return if $msg->is_delayed;

    my $type = $msg->type;
    my $body = $msg->body;

    if($type eq 'groupchat') {
        if($body =~ /^$nick[:,]\s*(.*)/) {
            $body = $1;
        } else {
            return;
        }
    }

    my $reply = $msg->make_reply;
    $reply->add_body($body);
    $reply->send;
});

$conn->connect;
$cond->recv;

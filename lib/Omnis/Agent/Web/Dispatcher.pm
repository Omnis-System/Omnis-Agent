package Omnis::Agent::Web::Dispatcher;

use strict;
use warnings;
use 5.010;
use utf8;

use Amon2::Web::Dispatcher::RouterBoom;
use Omnis::Agent::Util;
use Omnis::Agent::Handler::Fs;
use Omnis::Agent::Handler::Command;

any '/' => sub {
    my($c) = @_;

    return $c->render_json({message => "Heeeeeeeeeeeellllloo"});
};

any '/fs/{path:.*}' => sub {
    my($c, $p) = @_;

    my $res = Omnis::Agent::Handler::Fs::process($c, $p);

    return ref($res) eq 'HASH' ? $c->render_json($res) : $res;
};

get '/cmd/{path:.*}' => sub {
    my($c, $p) = @_;

    my $res = Omnis::Agent::Handler::Command::process($c, $p);

    return ref($res) eq 'HASH' ? $c->render_json($res) : $res;
};

1;

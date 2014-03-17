package Omnis::Agent::Web::Dispatcher;

use strict;
use warnings;
use 5.010;
use Carp;
use utf8;

use Amon2::Web::Dispatcher::RouterBoom;
use Log::Minimal;

use Omnis::Agent::Util;
use Omnis::Agent::Response;
use Omnis::Agent::Handler::Fs;
use Omnis::Agent::Handler::Command;
use Omnis::Agent::Handler::Daemontools;
use Omnis::Agent::Handler::Metric;;

any '/' => sub {
    my($c) = @_;

    return $c->create_response(
        200,
        ["Content-Type", "text/plain"],
        ["show help fixme\n"],
    );
};

get '/metric/{metric}' => sub {
    my($c, $p) = @_;

    my $metric = lc $p->{metric};

    if (! $c->{handler}{metric}) {
        eval {
            $c->{handler}{metric} = Omnis::Agent::Handler::Metric->new($c->config);
        };
        if ($@) {
            $c->{handler}{metric} = undef;
            return $c->render_json(Omnis::Agent::Response->new(404)->finalize);
        }
    }

    my $res;
    if ($c->{handler}{metric}->can($metric)) {
        $res = $c->{handler}{metric}->$metric();
    } else {
        $res = Omnis::Agent::Response->new(501);
    }

    return $c->render_json($res->finalize);
};

any '/fs/{path:.*}' => sub {
    my($c, $p) = @_;

    my $res = Omnis::Agent::Handler::Fs::process($c, $p);

    return $c->render_json($res->finalize);
};

get '/cmd/{path:.*}' => sub {
    my($c, $p) = @_;

    my $res = Omnis::Agent::Handler::Command::process($c, $p);

    return $c->render_json($res->finalize);
};

get '/daemontools/{service}' => sub {
    my($c, $p) = @_;

    my $res = Omnis::Agent::Handler::Daemontools::process($c, $p);

    return $c->render_json($res->finalize);
};

1;

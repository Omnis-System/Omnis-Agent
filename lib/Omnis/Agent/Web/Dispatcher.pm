package Omnis::Agent::Web::Dispatcher;

use strict;
use warnings;
use 5.010;
use Carp;
use utf8;

use Amon2::Web::Dispatcher::RouterBoom;
use Log::Minimal;

use Omnis::Agent::Util;
use Omnis::Agent::Handler::Fs;
use Omnis::Agent::Handler::Command;
use Omnis::Agent::Handler::Daemontools;
use Omnis::Agent::Handler::Metric;;

any '/' => sub {
    my($c) = @_;

    return $c->render_json({message => "Heeeeeeeeeeeellllloo"});
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
            debugf("XXX: %s", $@);
            return $c->res_404(); # fixme
        }
    }

    my $res;
    if ($c->{handler}{metric}->can($metric)) {
        $res = $c->{handler}{metric}->$metric();
    } else {
        $res = {
            status  => 501,
            message => 'Not Implemented',
        };
    }

    return ref($res) eq 'HASH' ? $c->render_json($res) : $res;
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

get '/daemontools/{service}' => sub {
    my($c, $p) = @_;

    my $res = Omnis::Agent::Handler::Daemontools::process($c, $p);

    return ref($res) eq 'HASH' ? $c->render_json($res) : $res;
};

1;

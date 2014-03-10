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

get '/metric/{metric}' => sub {
    my($c, $p) = @_;

    my $metric = lc $p->{metric};
    if (! $c->{metric}{$metric}) {
        eval {
            my $class = Plack::Util::load_class($metric, 'Omnis::Agent::Handler::Metric');
            $c->{metric}{$metric} = $class->new($c->config);
        };
        if ($@) {
            $c->{metric}{$metric} = undef;
            return $c->res_404(); # fixme
        }
    }

    my $res = $c->{metric}{$metric}->metric;

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

1;

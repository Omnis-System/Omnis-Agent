package Omnis::Agent::Handler::Metric::Base;

use strict;
use warnings;
use 5.010;
use Carp;
use utf8;

use Omnis::Agent::Response;

sub new {
    my($class, $config, $os) = @_;

    my $metric = $class;
    $metric =~ s/^Omnis::Metric:://;
    $metric =~ s/::/-/g;

    my $self = bless {
        config => $config,
        os     => $os,
        metric => $metric,
    }, $class;

    return $self;
}

sub memory { croak "override me" }

sub loadavg {
    my($self) = @_;

    my $res = Omnis::Agent::Response->new(200);

    my @buf = qx{uptime};
    if ($? != 0) {
        $res->status(500, $!);
        return $res;
    }

    for (@buf) {
        if (/load average:\s*(.+)$/) {
            my @lav = split /,\s*/, $1;
            $res->{1}  = $lav[0];
            $res->{5}  = $lav[1];
            $res->{15} = $lav[2];
            last;
        }
    }

    return $res;
}

1;

__END__

# for Emacsen
# Local Variables:
# mode: cperl
# cperl-indent-level: 4
# cperl-close-paren-offset: -4
# cperl-indent-parens-as-block: t
# indent-tabs-mode: nil
# coding: utf-8
# End:

# vi: set ts=4 sw=4 sts=0 et ft=perl fenc=utf-8 :

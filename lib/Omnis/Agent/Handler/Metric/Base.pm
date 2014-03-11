package Omnis::Agent::Handler::Metric::Base;

use strict;
use warnings;
use 5.010;
use Carp;
use utf8;

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

    my $metric = {};

    my @buf = qx{uptime};
    if ($? != 0) {
        return { status => 500, message => $! }; # fixme
    }

    for (@buf) {
        if (/load average:\s*(.+)$/) {
            my @lav = split /,\s*/, $1;
            $metric = {
                1  => $lav[0],
                5  => $lav[1],
                15 => $lav[2],
            };
            last;
        }
    }


    return $metric;
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

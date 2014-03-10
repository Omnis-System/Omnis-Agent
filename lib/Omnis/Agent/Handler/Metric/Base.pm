package Omnis::Agent::Handler::Metric::Base;

use strict;
use warnings;
use 5.010;
use Carp;

use Omnis::Agent::Util;

sub new {
    my($class, $config) = @_;

    my $metric = $class;
    $metric =~ s/^Omnis::Metric:://;
    $metric =~ s/::/-/g;

    my $self = bless {
        %{ $config },
        metric => $metric,
    }, $class;

    return $self;
}

sub memory { croak "override me" }

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

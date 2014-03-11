package Omnis::Agent::Handler::Metric::BaseAsync;

use strict;
use warnings;
use 5.010;
use Carp;
use utf8;

our @EXPORT = qw(scoreboard_reader scoreboard_writer);

sub import {
    my ($class, $name) = @_;
    my $caller = caller;
    {
        no strict 'refs';
        if ( $name && $name =~ /^-base/ ) {
            if ( ! $caller->isa($class) && $caller ne 'main' ) {
                push @{"$caller\::ISA"}, $class;
            }
            for my $func (@EXPORT) {
                *{"$caller\::$func"} = \&$func;
            }
        }
    }

    strict->import;
    warnings->import;
}

use Parallel::Scoreboard; # fixme 要件的に別なの使ったほうがいい

use Omnis::Agent::Util;

sub scoreboard_reader {
    my($base) = @_;
    return Parallel::Scoreboard->new(
        base_dir  => $base->{config}{metric}{async}{scoreboard},
    );
}

sub scoreboard_writer {
    my($base, $metric) = @_;
    return Parallel::Scoreboard->new(
        base_dir  => $base->{config}{metric}{async}{scoreboard},
        worker_id => sub { $metric },
    );
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

package Omnis::Agent::Handler::Metric::Linux;

use strict;
use warnings;
use 5.010;
use Carp;

use parent qw(Omnis::Agent::Handler::Metric::Base);

use Omnis::Agent::Util;

our %MEMORY_ITEM = (
    MemTotal  => 'total',
    MemFree   => 'free',
    Buffers   => 'buffers',
    Cached    => 'cached',
    SwapTotal => 'total',
    SwapFree  => 'free',
    Inactive  => 'inactive',
);
# "used" and "swap_used" are caluculated at last
my $memory_item_re = '^(?:' . join('|', keys %MEMORY_ITEM) . '):';

sub memory {
    my($self) = @_;

    my $metric = {};

    open my $fh, '<', '/proc/meminfo' or do {
        critf("%s", $!);
        return;
    };
    while (<$fh>) {
        next unless /$memory_item_re/;
        chomp;
        my($key, $val) = split /[\s:]+/, $_, 2;

        $metric->{$key =~ /^Swap/ ? 'swap' : 'memory' }{ $MEMORY_ITEM{$key} || "${key}_OOPS" } = to_byte($val);
    }
    close $fh;

    $metric->{memory}{used} = $metric->{memory}{total} - $metric->{memory}{free} - $metric->{memory}{inactive};

    $metric->{swap}{used} = $metric->{swap}{total} - $metric->{swap}{free};

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

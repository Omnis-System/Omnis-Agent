package Omnis::Agent::Handler::Metric::Linux;

use strict;
use warnings;
use 5.010;
use Carp;
use utf8;

use parent qw(Omnis::Agent::Handler::Metric::Base);

use Omnis::Agent::Util;
use Omnis::Agent::Response;
use Omnis::Agent::Handler::Metric::LinuxAsync;

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

    my $res = Omnis::Agent::Response->new(200);

    open my $fh, '<', '/proc/meminfo' or do {
        critf("%s", $!);
        return;
    };
    while (<$fh>) {
        next unless /$memory_item_re/;
        chomp;
        my($key, $val) = split /[\s:]+/, $_, 2;

        $res->{$key =~ /^Swap/ ? 'swap' : 'memory' }{ $MEMORY_ITEM{$key} || "${key}_OOPS" } = to_byte($val);
    }
    close $fh;

    $res->{memory}{used} = $res->{memory}{total} - $res->{memory}{free} - $res->{memory}{inactive};

    $res->{swap}{used} = $res->{swap}{total} - $res->{swap}{free};

    return $res;
}

sub loadavg {
    my($self) = @_;

    my $res = Omnis::Agent::Response->new(200);

    open my $fh, '<', '/proc/loadavg' or do {
        $res->status(500, $!);
        return $res;
    };
    while (<$fh>) {
        if (my @e = split /\s+/) {
            $res->{1}  = $e[0];
            $res->{5}  = $e[1];
            $res->{15} = $e[2];
            last;
        }
    }
    close $fh;

    return $res;
}

sub system {
    my($self) = @_;

    my $res = Omnis::Agent::Response->new(200);

    open my $fh, '<', '/proc/stat' or do {
        $res->status(500, $!);
        return $res;
    };
    while (<$fh>) {
        next if /^cpu/;
        chomp;
        my($key, @val) = split /\s+/;
        if ($key =~ /^(?:intr|ctxt|btime|processes|procs_running|procs_blocked|softirq)$/) {
            $res->{$key} = $val[0];
        }
    }
    close $fh;

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

package Omnis::Agent::Handler::Metric::LinuxAsync;

use strict;
use warnings;
use 5.010;
use Carp;
use utf8;

use parent qw(Exporter);
use Omnis::Agent::Handler::Metric::BaseAsync qw(-base);

our @EXPORT = qw(async_metrics cpu_run cpu);
push @EXPORT, @Omnis::Agent::Handler::Metric::BaseAsync::EXPORT;

our @Async_Metrics = qw(cpu);

use Log::Minimal;
use POSIX qw(sysconf _SC_CLK_TCK);

use Omnis::Agent::Util;

sub async_metrics { return @Async_Metrics }

sub cpu_run {
    my($base) = @_;

    my $sb = $base->scoreboard_writer('cpu');
    my $user_hz  = sysconf(_SC_CLK_TCK);
    my $interval = 5;           # fixme configurable
    my $ncpu     = qx{getconf _NPROCESSORS_ONLN};
    debugf("interval: %d", $interval);
    debugf("ncpu: %d", $ncpu);
    my($prev,$cur);

    $prev = _cpu_time();
    sleep $interval;

    while (1) {
        $cur = _cpu_time();
        my $cpu_usage = _calc_cpu_usage($prev, $cur, $user_hz, $ncpu);
        $prev = $cur;

        my $json = json->encode($cpu_usage);
        $sb->update($json);
        debugf("cpu: %s", $json);

        sleep $interval;
    }
}

sub cpu {
    my($base) = @_;

    my $sb = $base->scoreboard_reader;
    my $stats = $sb->read_all(); # fixme 効率悪いよねぇ
    if (my $json = $stats->{cpu}) {
        return json->decode($json);
    } else {
        return {}; # fixme
    }
}

sub _cpu_time {
    my $cpu_time;

    open my $fh, '<', '/proc/stat' or do {
        critf("%s", $!);
        return;
    };
    while (<$fh>) {
        if (/^cpu\s+/) {
            chomp;
            my(undef, @t) = split /\s+/;
            @$cpu_time{qw(user nice system idle iowait irq softirq steal guest guest_nice)} = @t;
            last;
        }
    }
    close $fh;

    $cpu_time->{time} = time();

    return $cpu_time;
}

sub _calc_cpu_usage {
    my($prev, $cur, $hz, $ncpu) = @_;
    my $usage;

    my $interval = $cur->{time} - $prev->{time};

    for my $key (grep !/^time$/, keys %$prev) {
        next unless (defined $cur->{$key} && defined $prev->{$key});
        $usage->{$key} = sprintf "%.3f", ( ( ($cur->{$key} - $prev->{$key}) / $interval * 100 / $hz ) / $ncpu );
    }
    $usage->{time} = $cur->{time};

    return $usage;
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

package Omnis::Agent::Handler::Metric;

use strict;
use warnings;
use 5.010;
use Carp;
use utf8;

use Log::Minimal;

use Omnis::Agent::Util;

sub new {
    my $os = check_os();
    my $class = Plack::Util::load_class($os->{family}, 'Omnis::Agent::Handler::Metric');
    return $class->new($os);
}

sub check_os {
    # fixme return by config or env
    my $os = {
        family  => undef,
        release => undef,
    };

    # fixme steal from specinfra's backend/exec.rb
    if (-f "/etc/redhat-release") {
        $os->{family} = 'RedHat';

        open my $fh, '<', "/etc/redhat-release" or croak $!;
        while (<$fh>) {
            if (/release ([1-9]+[0-9.]*)/) {
                $os->{release} = $1;
                last;
            }
        }
        close $fh;
    } elsif (-f "/etc/system-release") {
        $os->{family}  = 'RedHat'; # Amazon Linux
        $os->{release} = undef;
    } elsif (-f "/etc/SuSE-release") {
        $os->{family}  = 'SuSE';

        open my $fh, '<', "/etc/SuSE-release" or croak $!;
        while (<$fh>) {
            if (/SUSE Linux Enterprise Server (\d+)/) {
                $os->{release} = $1;
                last;
            }
        }
        close $fh;
    } elsif (-f "/etc/debian_version") {
        my $lsb_release = qx{lsb_release -i};
        my $distro;
        if ($? == 0 && $lsb_release =~ /:\s*(.+)$/) {
            $distro = $1;
        } elsif (-r "/etc/lsb-release") {
            open my $fh, '<', "/etc/lsb-release" or croak $!;
            while (<$fh>) {
                if (/DISTRIB_ID=\s*(.+)$/) {
                    $distro = $1;
                    last;
                }
            }
            close $fh;
        }
        $distro ||= 'Debian';

        $os->{family}  = $distro;
        $os->{release} = undef;
    }
    # fixme

    return $os;
}

1;

__END__

=encoding utf-8

=head1 NAME

{{$name}} - fixme

=begin readme

=head1 INSTALLATION

To install this module, run the following commands:

    perl Build.PL
    ./Build
    ./Build test
    ./Build install

=end readme

=head1 SYNOPSIS

    use {{$name}};
    fixme

=head1 DESCRIPTION

{{$name}} is fixme

=head1 METHODS

=head2 Class Methods

=head3 B<new>(%args:Hash) :{{$name}}

Creates and returns a new InfluxDB client instance. Dies on errors.

%args is following:

=over 4

=item hostname => Str ("127.0.0.1")

=back

=head2 Instance Methods

=head3 B<method_name>($message:Str) :Bool

=head1 ENVIRONMENT VARIABLES

=over 4

=item HOME

Used to determine the user's home directory.

=back

=head1 FILES

=over 4

=item F</path/to/config.ph>

設定ファイル。

=back

=head1 AUTHOR

{{(my $a = $dist->authors->[0]) =~ s/([<>])/"E<" . {qw(< lt > gt)}->{$1} . ">"/eg; $a}}

=head1 REPOSITORY

L<https://github.com/hirose31/{{$dist->name}}>

    git clone https://github.com/hirose31/{{$dist->name}}.git

patches and collaborators are welcome.

=head1 SEE ALSO

L<Module::Hoge|Module::Hoge>,
ls(1), cd(1)

=head1 COPYRIGHT

Copyright {{(my $a = $dist->authors->[0]) =~ s/\s*<.*$//; $a}}

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

package Omnis::Agent::Util;

use strict;
use warnings;
use 5.010;
use Carp;
use utf8;

use parent qw(Exporter);
our @EXPORT = qw(p to_byte json);

use Data::Dumper;
use JSON 2 qw();

sub p(@) {
    local $Data::Dumper::Indent    = 1;
    local $Data::Dumper::Deepcopy  = 1;
    local $Data::Dumper::Sortkeys  = 1;
    local $Data::Dumper::Terse     = 1;
    local $Data::Dumper::Useqq     = 0;
    local $Data::Dumper::Quotekeys = 0;

    my $d =  Dumper(\@_);
    # $d =~ s/\\x{([0-9a-z]+)}/chr(hex($1))/ge;
    print STDERR $d;
}

# Convert string like a "123 KB" into as byte
sub to_byte {
    my $s = shift;
    my $b = 0;

    ($s) = ($s =~ /^\s*(.+?)\s*$/); # trim

    if ($s =~ /^[0-9]+$/) {
        $b = $s;
    } elsif ($s =~ /^([0-9]+)\s*([a-zA-Z]+)$/) {
        $b = $1;
        my $u = lc $2;
        if ($u eq 'kb') {
            $b = $b * 1024;
        } elsif ($u eq 'mb') {
            $b = $b * 1024 * 1024;
        } elsif ($u eq 'gb') {
            $b = $b * 1024 * 1024 * 1024;
        } elsif ($u eq 'tb') {
            $b = $b * 1024 * 1024 * 1024 * 1024;
        } else {
            warnf("Unknown unit: %s", $u);
        }
    } else {
        warnf("Failed to convert into as byte: %s", $s);
    }

    return $b;
}

sub json() {
    state $_json = JSON->new()->ascii(1);
    return $_json;
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

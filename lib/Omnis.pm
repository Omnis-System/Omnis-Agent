package Omnis;

use strict;
use warnings;
use 5.008_005;

our $VERSION = '0.001';

use Class::Accessor::Lite (
    new => 0,
    rw  => [qw(name)],
    ro  => [qw(id)],
    wo  => [qw()],
);
# or
# use Class::Accessor::Lite;
# Class::Accessor::Lite->mk_accessors(qw(name));
# Class::Accessor::Lite->mk_ro_accessors(qw(id));

use Data::Validator;
use Log::Minimal;
use Carp;

sub new {
    my($class, $args) = Data::Validator->new(
        id   => { isa => 'Int', default  => 'foo' },
        name => { isa => 'Str', optional => 1 },
    )->with('Method')->validate(@_);

    my $self = bless {
        id   => 0,
        name => 'no name',
        %$args
    }, $class;
    Carp::croak("missing mandatory args: id") unless $self->{id};
    return $self;
}

1;

__END__

=encoding utf-8

=begin html

<a href="https://travis-ci.org/hirose31/Omnis"><img src="https://travis-ci.org/hirose31/Omnis.png?branch=master" alt="Build Status" /></a>
<a href="https://coveralls.io/r/hirose31/Omnis?branch=master"><img src="https://coveralls.io/repos/hirose31/Omnis/badge.png?branch=master" alt="Coverage Status" /></a>

=end html

=head1 NAME

Omnis - fixme

=begin readme

=head1 INSTALLATION

To install this module, run the following commands:

    perl Build.PL
    ./Build
    ./Build test
    ./Build install

=end readme

=head1 SYNOPSIS

    use Omnis;
    fixme

=head1 DESCRIPTION

Omnis is fixme

=head1 METHODS

=head2 Class Methods

=head3 B<new>(%args:Hash) :Omnis

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

HIROSE Masaaki E<lt>hirose31@gmail.comE<gt>

=head1 REPOSITORY

L<https://github.com/hirose31/Omnis>

    git clone https://github.com/hirose31/Omnis.git

patches and collaborators are welcome.

=head1 SEE ALSO

L<Module::Hoge|Module::Hoge>,
ls(1), cd(1)

=head1 COPYRIGHT

Copyright HIROSE Masaaki

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

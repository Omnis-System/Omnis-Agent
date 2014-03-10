package Omnis::Agent::Handler::Command;

use strict;
use warnings;
use 5.010;
use Carp;

our $VERSION = '0.001';

use Log::Minimal;
use IPC::Run;
use IPC::Cmd;

use Omnis::Agent::Util;

sub process {
    my($c, $p) = @_;

    my $req = $c->req;
    my $path;
    if ($p->{path} =~ m{/}) {
        $path = '/' . $p->{path};
    } else {
        $path = IPC::Cmd::can_run($p->{path});
    }
    my $method = $req->method;

    my $res = {
        status => 200,
        path   => $path,
    };

    if ($method ne 'GET') {
        $res->{status} = 405;
        $res->{message} = 'Method Not Allowd';
        return $res;
    }

    if (! -x $path) {
        $res->{status} = 403;
        $res->{message} = 'Forbidden';
        return $res;
    }

    my @arg = $req->query_parameters->get_all('arg');
    my $command = [$path, @arg];

    my($ok, $err, $full_buf, $stdout_buf, $stderr_buf) = IPC::Cmd::run(
        command => $command,
        timeout => 8,
    );

    $res->{status} = 500 unless $ok;
    $res->{stdout} = $stdout_buf;
    $res->{stderr} = $stderr_buf;

    return $res;
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

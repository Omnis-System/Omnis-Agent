package Omnis::Agent::Handler::Fs;

use strict;
use warnings;
use 5.010;
use Carp;
use utf8;

use Log::Minimal;
use File::stat;
use Fcntl qw(:mode);
use POSIX qw(:errno_h);
use IO::File::AtomicChange;

use Omnis::Agent::Util;
use Omnis::Agent::Response;

sub process {
    my($c, $p) = @_;

    my $req = $c->req;
    my $path = '/' . $p->{path};
    my $method = $req->method;

    my $res = Omnis::Agent::Response->new(200);

    if ($method eq 'GET') {
        my $st = lstat($path) or do {
            set_error($res);
            goto RETURN;
        };

        if (S_ISLNK($st->mode)) {
            if (my $symlink_to = readlink $path) {
                $res->{symlink_to} = $symlink_to;
            }
            $st = stat($path);
        }

        $res->{$_} = $st->$_ for qw(nlink uid gid size mtime ctime blksize blocks);

        $res->{mode}  = substr(sprintf("%o", $st->mode), -4);
        $res->{user}  = getpwuid($st->uid);
        $res->{group} = getgrgid($st->gid);
        $res->{type}  = do {
            if (S_ISREG($st->mode)) {
                "file";
            } elsif (S_ISDIR($st->mode)) {
                "directory";
            } elsif (S_ISBLK($st->mode)) {
                "block";
            } elsif (S_ISCHR($st->mode)) {
                "character";
            } elsif (S_ISFIFO($st->mode)) {
                "fifo";
            } elsif (S_ISSOCK($st->mode)) {
                "socket";
            } else {
                "unknown";
            }
        };

        if (! defined $req->param('stat')) {
            $res->{content} = "";

            if (S_ISREG($st->mode)) {
                open my $fh, '<', $path or do {
                    set_error($res);
                    goto RETURN;
                };
                $res->{content} = do { local $/; <$fh> };
                close $fh;
            } elsif (S_ISDIR($st->mode)) {
                opendir my $dh, $path or do {
                    set_error($res);
                    goto RETURN;
                };
                push @{ $res->{content} }, grep !/^\.{1,2}$/, readdir $dh;
                close $dh;
            }
        }

        return $res;
    } elsif ($method eq 'PUT') {
        # fixme mkdir?
        # fixme specify mode,
        # fixme backup_dir を conf で指定可能にする で、自動でmkdirする
        # fixme 任意のファイルの書き換えはin-house useとは危険すぎるので、
        # 指定したディレクトリ配下のだけ書き換え可能とか制限が必要
        my $content = $req->content;

        my $fh = IO::File::AtomicChange->new($path, "w",
                                         { backup_dir => "/var/tmp/bk" })
            or do {
                set_error($res);
                goto RETURN;
            };
        $fh->print($content);
        $fh->close;
    }

 RETURN:
    return $res;
}

sub set_error {
    my($res) = @_;

    $res->status(500, $!);

    my $errno = POSIX::errno;
    if ($errno == EACCES) {
        $res->status(403);
    } elsif ($errno == ENOENT) {
        $res->status(404);
    } else {
        $res->status(400);
    }
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

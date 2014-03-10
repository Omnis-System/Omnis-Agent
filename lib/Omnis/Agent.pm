package Omnis::Agent;
use strict;
use warnings;
use utf8;
our $VERSION='0.01';
use 5.010;
# use Omnis::Agent::DB::Schema;
# use Omnis::Agent::DB;

use parent qw/Amon2/;
# Enable project local mode.
__PACKAGE__->make_local_context();

# my $schema = Omnis::Agent::DB::Schema->instance;

# sub db {
#     my $c = shift;
#     if (!exists $c->{db}) {
#         my $conf = $c->config->{DBI}
#             or die "Missing configuration about DBI";
#         $c->{db} = Omnis::Agent::DB->new(
#             schema       => $schema,
#             connect_info => [@$conf],
#             # I suggest to enable following lines if you are using mysql.
#             # on_connect_do => [
#             #     'SET SESSION sql_mode=STRICT_TRANS_TABLES;',
#             # ],
#         );
#     }
#     $c->{db};
# }

1;
__END__

=head1 NAME

Omnis::Agent - Omnis::Agent

=head1 DESCRIPTION

This is a main context class for Omnis::Agent

=head1 AUTHOR

HIROSE Masaaki E<lt>hirose31@gmail.comE<gt>

=head1 REPOSITORY

L<https://github.com/Omnis-System/Omnis-Agent>

    git clone https://github.com/Omnis-System/Omnis-Agent.git

patches and collaborators are welcome.

=head1 COPYRIGHT

Copyright HIROSE Masaaki

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

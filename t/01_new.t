use strict;
use Test::More;

require Omnis;
Omnis->import;
note("new");
my $obj = new_ok("Omnis");

# diag explain $obj

done_testing;

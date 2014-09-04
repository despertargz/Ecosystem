use strict;
use warnings;

my @list = ("giraf", "bear", "tiger");
@list = grep { $_ ne "bear" } @list;

print "@list";
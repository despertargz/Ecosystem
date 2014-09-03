use strict;
use warnings;
use diagnostics;
use v5.10;

my $hash = {
	list => [ "one", "two", "three" ]
};


say @{$hash->{list}} == 3;
exit;


#unshift $hash->{blah}, "one";
#shift $hash->{blah};

my @items = $hash->{blah};

print scalar(@items);
print "@items";

#say Empty();
#push $hash->{blah}, "somethning";
#say Empty();


sub Empty {
	return !exists($hash->{blah}) || scalar(@{$hash->{blah}}) == 0;
}
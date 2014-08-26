use strict;
use warnings;


my $point = {
	x => 0,
	y => 0
};

my $grid = {
	"0,0" => "X",
	"4,4" => "X",
	"9,9" => "X"
};

my $downSpace = "";
my $rightSpace = "";

foreach my $row (0..9) {
	foreach my $col (0..9) {
		my $coords = $row . ',' . $col;
		
		my $point = $grid->{$coords};
		
		print " ";
		if ($point) {
			print $point;
		}
		else {
			print "o";
		}
		print " ";
		#print "[" . $coords . "]";
	}
	
	print "\n";
}




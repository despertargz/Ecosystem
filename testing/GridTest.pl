use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(usleep);

my $point = {
	x => 0,
	y => 0
};

my $grid = {
	"0,0" => "X",
};

my $coords = "0,0";
while (1) {
	moveItem();
	system 'cls';
	drawGrid();
	usleep 100000;
}

sub moveItem {
	my $moveX = int(rand(3)) - 1;
	my $moveY = int(rand(3)) - 1;
	
	print "moving $moveX,$moveY\n";
	
	my @currentCoords = split /,/, $coords;
	print Dumper(@currentCoords) . "\n";
	
	my $curX = $currentCoords[0];
	my $newX = $curX + $moveX;
	print "$curX + $moveX = $newX\n";
	
	
	$newX = $newX < 0 ? 0 : $newX;
	$newX = $newX > 9 ? 9 : $newX;
	print "newx: $newX\n";
	
	my $newY = $currentCoords[1] + $moveY;
	$newY = $newY < 0 ? 0 : $newY;
	$newY = $newY > 9 ? 9 : $newY;
	
	my $item = $grid->{$coords};

	delete $grid->{$coords};
	$coords = $newX . ',' . $newY;
	print $coords . "\n";
	#print $item . "\n";
	$grid->{$coords} = $item;
}

sub drawGrid {
	foreach my $row (0..9) {
		foreach my $col (0..9) {
			my $coords = $row . ',' . $col;
			
			my $point = $grid->{$coords};
			
			print " ";
			if ($point) {
				print $point;
			}
			else {
				print "_";
			}
			print " ";
			#print "[" . $coords . "]";
		}
		
		print "\n";
	}
}



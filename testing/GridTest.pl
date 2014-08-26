use strict;
use warnings;
use Data::Dumper;
use Time::HiRes qw(usleep);

my $LIMIT = 9;

my $grid = {
	"0,0" => "X",
	"$LIMIT,$LIMIT" => "O"
};

while (1) {
	
	foreach my $key (keys %$grid) {
		moveItem($key);
		system 'cls';
		drawGrid();
		usleep 50000;
		#\sleep 1;
	}
	

}

sub moveItem {
	my $coords = shift;
	
	my $moveX = int(rand(3)) - 1;
	my $moveY = int(rand(3)) - 1;
	
	my @currentCoords = split /,/, $coords;
	
	my $curX = $currentCoords[0];
	my $newX = $curX + $moveX;

	$newX = $newX < 0 ? 0 : $newX;
	$newX = $newX > $LIMIT ? $LIMIT : $newX;
	
	my $newY = $currentCoords[1] + $moveY;
	$newY = $newY < 0 ? 0 : $newY;
	$newY = $newY > $LIMIT ? $LIMIT : $newY;
	
	my $item = $grid->{$coords};

	delete $grid->{$coords};
	$coords = $newX . ',' . $newY;
	$grid->{$coords} = $item;
}

sub drawGrid {
	foreach my $row (0..$LIMIT) {
		foreach my $col (0..$LIMIT) {
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
		}
		
		print "\n";
	}
}



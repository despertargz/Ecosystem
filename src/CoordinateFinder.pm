package CoordinateFinder;

use List::Util 'shuffle';

sub New {
	return bless {};
}

sub GetAdjacentCoordinates {
	my ($self, $gridSize, $centerCoord) = @_;

	my $x = (split /,/, $centerCoord)[0];
	my $y = (split /,/, $centerCoord)[1];
	#print "Finding adjacent coords for $x,$y";
	
	my @translations = (
		[-1, 0], [-1, 1], [-1, -1],
		[1, 0], [1, 1], [1, -1],
		[0, 1], [0, -1]
	);
	
	my @adjacents = ();
	foreach my $translation (@translations) {
		 my $newX = $x + $translation->[0];
		 my $newY = $y + $translation->[1];
		 my $newCoord = "$newX,$newY";
		 if ($newY >= 0 && $newX >= 0 && $newY < $gridSize && $newX < $gridSize && $newCoord ne $centerCoord) {
			push @adjacents, $newCoord;
		 }
		 else {
			#print "off grid! $newCoord\n";
		 }
	}
	
	return shuffle(@adjacents);
}

return 1;
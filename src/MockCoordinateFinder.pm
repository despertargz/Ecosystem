package MockCoordinateFinder;

sub New {
	my ($class, $coordinateToMoveTo) = @_;
	
	return bless {
		CoordinateToMoveTo => $coordinateToMoveTo
	};
}

sub GetAdjacentCoordinates {
	my ($self, $grid, $centerCoord) = @_;
	
	return $self->{CoordinateToMoveTo};
}

return 1;
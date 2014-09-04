package MockCoordinateFinder;

sub New {
	my ($class, $coordinatesToMoveTo) = @_;
	
	return bless {
		CoordinatesToMoveTo => $coordinatesToMoveTo
	};
}

sub GetAdjacentCoordinates {
	my ($self, $grid, $centerCoord) = @_;
	
	return shift $self->{CoordinatesToMoveTo};
}

return 1;
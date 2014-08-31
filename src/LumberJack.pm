package LumberJack;

sub New {
	my ($class, $grid, $counts, $lumberJackOptions) = @_;
	
	return bless {
		Grid => $grid,
		Counts => $counts,
		LumberJackOptions => $lumberJackOptions
	};
}

sub TakeTurn {
	my ($self, $coords) = @_;
	
	$self->{Grid}->MoveEntity($self, $coords);
}

return 1;
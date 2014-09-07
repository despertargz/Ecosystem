package Bear;

use Bucket;

sub New {
	my ($class, $grid, $data, $bearOptions) = @_;
	
	return bless {
		Grid => $grid,
		Data => $data,
		Options => $bearOptions
	};
}

sub TakeTurn {
	my ($self, $coords) = @_;
	
	foreach (1..$self->{Options}->{Moves}) {
		my $moveResult = $self->{Grid}->MoveEntity($self, $coords);
		my $targetEntities = $moveResult->{TargetEntity};

		if (Bucket->HasType($targetEntities, "LumberJack")) {
			#print "[Bear] mawed [LumberJack]\n";
		
			$self->{Grid}->RemoveEntity($moveResult->{NewCoords}, "LumberJack");
			$self->{Grid}->RemoveEntity($coords, $self->GetType());
			$self->{Grid}->SetEntity($moveResult->{NewCoords}, $self);
			
			$self->{Data}->{MonthlyData}->{Maws}++;
			$self->{Data}->{Counts}->{LumberJack}--;
			
			if ($self->{Data}->{Counts}->{LumberJack} == 0) {
				$self->{Grid}->AddRandomEntity("LumberJack");
			}
			
			#print "Finished mawing\n";
			
			return;
		}
		else {
			#empty space, move there
			$self->{Grid}->RemoveEntity($coords, $self->GetType());
			$self->{Grid}->SetEntity($moveResult->{NewCoords}, $self);
			$coords = $moveResult->{NewCoords};
		}
	}
}

sub GetSymbol {
	return "B";
}

sub GetType {
	return "Bear";
}

return 1;
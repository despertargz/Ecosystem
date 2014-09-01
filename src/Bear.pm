package Bear;

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
		
		my $targetEntityType = defined($moveResult->{TargetEntity}) ?
			$moveResult->{TargetEntity}->GetType() :
			undef;
			
		if ($targetEntityType eq "LumberJack") {
			$self->{Grid}->RemoveEntity($moveResult->{NewCoords}, $moveResult->{TargetEntity});
			$self->{Grid}->RemoveEntity($coords, $self);
			$self->{Grid}->SetEntity($moveResult->{NewCoords}, $self);
			
			$self->{Data}->{MonthlyData}->{Maws} += 1;
			$self->{Data}->{Counts}->{LumberJack}--;
			return;
		}
		elsif ($targetEntityType eq "Tree") {
			
		}
		elsif ($targetEntityType eq "ElderTree") {
			
		}
		elsif ($targetEntityType eq "Sapling") {
			#if sappling dont kill him
		}
		else {
			#empty space, move there
			$self->{Grid}->RemoveEntity($coords, $self);
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
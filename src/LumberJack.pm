package LumberJack;

sub New {
	my ($class, $grid, $data, $lumberJackOptions) = @_;
	
	return bless {
		Grid => $grid,
		Data => $data,
		Options => $lumberJackOptions
	};
}

sub TakeTurn {
	my ($self, $coords) = @_;
	
	#print "LumberJack is taking a turn!\n";
	
	foreach (1..$self->{Options}->{Moves}) {
		my $moveResult = $self->{Grid}->MoveEntity($self, $coords);
		
		my $targetEntityType = defined($moveResult->{TargetEntity}) ?
			$moveResult->{TargetEntity}->GetType() :
			undef;
			
		#print "Moving to spot with " . $targetEntityType . "\n";
		if ($targetEntityType eq "Bear") {
			$self->{Grid}->RemoveEntity($coords, $self);
			
			$self->{Data}->{MonthlyData}->{Maws}++;
			$self->{Data}->{Counts}->{LumberJack}--;
			return;
		}
		elsif ($targetEntityType eq "Tree") {
			#print "Lumber jack cut down a tree!\n";
			
			$self->{Grid}->RemoveEntity($moveResult->{NewCoords}, $moveResult->{TargetEntity});
			$self->{Grid}->RemoveEntity($coords, $self);
			$self->{Grid}->SetEntity($moveResult->{NewCoords}, $self);
			
			$self->{Data}->{MonthlyData}->{Lumber} += 1;
			$self->{Data}->{Counts}->{Tree}--;
			
			return;
		}
		elsif ($targetEntityType eq "ElderTree") {
			$self->{Grid}->RemoveEntity($moveResult->{TargetEntity}, $moveResult->{NewCoords});
			$self->{Grid}->RemoveEntity($coords, $self);
			$self->{Grid}->SetEntity($moveResult->{NewCoords}, $self);
			
			$self->{Data}->{MonthlyData}->{Lumber} += 2;
			$self->{Data}->{Counts}->{Tree}--;
			return;
		}
		elsif ($targetEntityType eq "Sapling") {
			#if sappling dont kill him
		}
		else {
			#empty space, move there
			#print "Moving from $coords to " . $moveResult->{NewCoords} . "\n";
			$self->{Grid}->RemoveEntity($coords, $self);
			$self->{Grid}->SetEntity($moveResult->{NewCoords}, $self);
			$coords = $moveResult->{NewCoords};
		}
	}
}

sub GetSymbol {
	return "L";
}

sub GetType {
	return "LumberJack";
}

return 1;
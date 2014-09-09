package LumberJack;

use Bucket;
use Data::Dumper;

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
	
	foreach (1..$self->{Options}->{Moves}) {
		my $moveResult = $self->{Grid}->MoveEntity($self, $coords);
		my $targetEntities = $moveResult->{TargetEntity};
			
		#print "BEFORE: " . Dumper($targetEntities);
			
		if (!$moveResult->{NewCoords}) {
			# could not move
		}
		elsif (Bucket->HasType($targetEntities, "Bear")) {
			#print "[LumberJack] got himself mawed\n";
		
			$self->{Grid}->RemoveEntity($coords, $self->GetType());
			
			$self->{Data}->{MonthlyData}->{Maws}++;
			$self->{Data}->{StaticData}->{TotalMaws}++;
			$self->{Data}->{Counts}->{LumberJack}--;
			
			if ($self->{Data}->{Counts}->{LumberJack} == 0) {
				$self->{Grid}->AddRandomEntity("LumberJack");
			}
			
			#print "Finished getting mawed\n";
			return;
		}
		elsif (Bucket->HasType($targetEntities, "Tree")) {
			#print "[LumberJack] cut down a tree!\n";
			
			$self->{Grid}->RemoveEntity($moveResult->{NewCoords}, "Tree");
			$self->{Grid}->RemoveEntity($coords, $self->GetType());
			$self->{Grid}->SetEntity($moveResult->{NewCoords}, $self);
			
			$self->{Data}->{MonthlyData}->{Lumber} += 1;
			$self->{Data}->{StaticData}->{TotalLumber} += 1;
			$self->{Data}->{Counts}->{Tree}--;
			
			return;
		}
		elsif (Bucket->HasType($targetEntities, "ElderTree")) {
			#print "[LumberJack] cut down an elder tree!\n";
		
			$self->{Grid}->RemoveEntity($moveResult->{NewCoords}, "ElderTree");
			$self->{Grid}->RemoveEntity($coords, $self->GetType());
			$self->{Grid}->SetEntity($moveResult->{NewCoords}, $self);
			
			$self->{Data}->{MonthlyData}->{Lumber} += 2;
			$self->{Data}->{StaticData}->{TotalLumber} += 2;
			$self->{Data}->{Counts}->{Tree}--;
			return;
		}
		else {
			#empty space or sappling, move there
			
			$self->{Grid}->RemoveEntity($coords, $self->GetType());
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
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
	
	#print "LumberJack is taking a turn!\n";
	
	foreach (1..$self->{Options}->{Moves}) {
		my $moveResult = $self->{Grid}->MoveEntity($self, $coords);
		my $targetEntities = $moveResult->{TargetEntity};
			
		if (Bucket->HasType($targetEntities, "Bear")) {
			#print "[LumberJack] got himself mawed\n";
		
			$self->{Grid}->RemoveEntity($coords, $self->GetType());
			
			$self->{Data}->{MonthlyData}->{Maws}++;
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
			$self->{Data}->{Counts}->{Tree}--;
			
			return;
		}
		elsif (Bucket->HasType($targetEntities, "ElderTree")) {
			#print "[LumberJack] cut down an elder tree!\n";
		
			$self->{Grid}->RemoveEntity($moveResult->{NewCoords}, "ElderTree");
			$self->{Grid}->RemoveEntity($coords, $self->GetType());
			$self->{Grid}->SetEntity($moveResult->{NewCoords}, $self);
			
			$self->{Data}->{MonthlyData}->{Lumber} += 2;
			$self->{Data}->{Counts}->{Tree}--;
			return;
		}
		else {
			#empty space or sappling, move there
			#print "[LumberJack] moves onto [" . $typeText . "]\n";
			

			
			
			$self->{Grid}->RemoveEntity($coords, $self->GetType());
			$self->{Grid}->SetEntity($moveResult->{NewCoords}, $self);
			$coords = $moveResult->{NewCoords};
			
			#print Dumper($self->{Grid}->GetEntity($moveResult->{NewCoords}));
			
			#print "[LumberJack] is living with $typeText\n";
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
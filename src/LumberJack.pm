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
			
		#print Dumper($moveResult);
		#print "Moving to spot with " . $targetEntityType . "\n";
		
		#print Dumper($targetEntities) . "\n";
		
		if (Bucket->HasType($targetEntities, "Bear")) {
			$self->{Grid}->RemoveEntity($coords, $self->GetType());
			
			$self->{Data}->{MonthlyData}->{Maws}++;
			$self->{Data}->{Counts}->{LumberJack}--;
			return;
		}
		elsif (Bucket->HasType($targetEntities, "Tree")) {
			print "Lumber jack cut down a tree!\n";
			
			$self->{Grid}->RemoveEntity($moveResult->{NewCoords}, "Tree");
			$self->{Grid}->RemoveEntity($coords, $self->GetType());
			$self->{Grid}->SetEntity($moveResult->{NewCoords}, $self);
			
			$self->{Data}->{MonthlyData}->{Lumber} += 1;
			$self->{Data}->{Counts}->{Tree}--;
			
			return;
		}
		elsif (Bucket->HasType($targetEntities, "ElderTree")) {
			$self->{Grid}->RemoveEntity($moveResult->{NewCoords}, "ElderTree");
			$self->{Grid}->RemoveEntity($coords, $self->GetType());
			$self->{Grid}->SetEntity($moveResult->{NewCoords}, $self);
			
			$self->{Data}->{MonthlyData}->{Lumber} += 2;
			$self->{Data}->{Counts}->{Tree}--;
			return;
		}
		else {
			#empty space or sappling, move there
			print "Moving from $coords to " . $moveResult->{NewCoords} . "\n";
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
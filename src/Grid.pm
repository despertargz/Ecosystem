package Grid;

use Term::ANSIColor;
use Win32::Console::ANSI;

sub New {
	my ($class, $size, $coordinateFinder) = @_;

	return bless {
		Size => $size,
		Grid => {},
		CoordinateFinder => $coordinateFinder
	};
}

sub GetCoords {
	my $self = shift;

	return keys $self->{Grid};
}

sub GetEntity {
	my ($self, $coords) = @_;
	
	return $self->{Grid}->{$coords};
}

sub SetEntity {
	my ($self, $coords, $entity) = @_;
	
	$self->{Grid}->{$coords} = $entity;
}

sub RemoveEntity {
	my ($self, $coords, $entity) = @_;
	
	delete $self->{Grid}->{$coords};
}

sub CreateEntityNearby {
	my ($self, $entity, $coords) = @_;
	
	my @adjacentCoords = $self->{CoordinateFinder}->GetAdjacentCoordinates($self->{Size}, $coords);
	
	foreach my $coord (@adjacentCoords) {
		my $existingEntity = $self->GetEntity($coord);
		if ($existingEntity == undef) {
			$self->{Grid}->{$coord} = $entity;
			return 1;
		}
	}
	
	#print "Could not find space to put entity!\n";
	return 0;
}



sub MoveEntity {
	my ($self, $movingEntity, $coords) = @_;
	
	my @adjacentCoords = $self->{CoordinateFinder}->GetAdjacentCoordinates($self->{Size}, $coords);
	foreach my $adjacentCoord (@adjacentCoords) {
		my $entity = $self->GetEntity($adjacentCoord);
		
		if ($entity == undef) {
			return {
				NewCoords => $adjacentCoord,
				TargetEntity => undef,
			}
		}
		elsif ($entity->GetType() ne $movingEntity->GetType()) {
			return {
				NewCoords => $adjacentCoord,
				TargetEntity => $entity
			}
		}
	}
	
	# could not find a space which does not have the same entity, cannot move
	return {
		NewCoords => undef,
		TargetEntity => undef
	}
}

sub Draw {
	my $self = shift;

	my $colors = {
		S => "cyan",
		T => "green",
		E => "magenta",
		L => "red"
	};
	
	foreach my $row (0..$self->{Size} - 1) {
		foreach my $col (0..$self->{Size} - 1) {
			my $coords = $row . ',' . $col;
			
			my $entity = $self->{Grid}->{$coords};
			
			print "";
			if ($entity) {
				my $symbol = $entity->GetSymbol();
				print color($colors->{$symbol});
				print $symbol;
				print color('white');
			}
			else {
				print " ";
			}
			print "";
		}
		
		print "\n";
	}
}

return 1;
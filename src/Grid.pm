package Grid;

use Term::ANSIColor;
use Win32::Console::ANSI;
use Data::Dumper;


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
	
	if ($self->IsEmpty($coords)) {
		return undef;
	}
	else {
		return $self->{Grid}->{$coords};
	}
}

sub GetOneEntity {
	my ($self, $coords, $entityType) = @_;

	my $entities = $self->GetEntity($coords);
	if (!defined($entities)) {
		return undef;
	}
	
	foreach my $entity (@$entities) {
		if ($entity->GetType() eq $entityType) {
			return $entity;
		}
	}
	
	#did not find the entity type we were searching for
	return undef;
}

sub IsEmpty {
	my ($self, $coords) = @_;
	
	#print Dumper($self);
	#print "\n";
	
	my $exists = exists $self->{Grid}->{$coords};
	my $empty = 0;
	
	if ($exists) {
		$empty = @{$self->{Grid}->{$coords}} == 0;
	}
	
	my $result = !$exists || $empty;
	
	#print "isempty: " . $result . "\n";
	return $result;
}

sub SetEntity {
	my ($self, $coords, $entity) = @_;
	
	my $exists = exists $self->{Grid}->{$coords};
	if (!$exists) {
		$self->{Grid}->{$coords} = [];
	}
	
	push $self->{Grid}->{$coords}, $entity;
}

sub RemoveEntity {
	my ($self, $coords, $entity) = @_;
	
	delete $self->{Grid}->{$coords};
}

sub CreateEntityNearby {
	my ($self, $entity, $coords) = @_;
	
	my @adjacentCoords = $self->{CoordinateFinder}->GetAdjacentCoordinates($self->{Size}, $coords);
	
	foreach my $coord (@adjacentCoords) {
		if ($self->IsEmpty($coord)) {
			$self->{Grid}->{$coord} = [$entity];
			return 1;
		}
	}
	
	#print "Could not find space to put entity!\n";
	return 0;
}

sub CreateEntityRandom {
	my ($self, $entity) = @_;
	
	while (1) {
		my $x = int(rand($self->{Size}));
		my $y = int(rand($self->{Size}));
	}
}

sub MoveEntity {
	my ($self, $movingEntity, $coords) = @_;
	
	my @adjacentCoords = $self->{CoordinateFinder}->GetAdjacentCoordinates($self->{Size}, $coords);
	foreach my $adjacentCoord (@adjacentCoords) {
		my $entities = $self->GetEntity($adjacentCoord);
		
		if ($entity == undef) {
			return {
				NewCoords => $adjacentCoord,
				TargetEntity => undef,
			}
		}
		elsif ($entity->GetType() ne $movingEntity->GetType()) {
			return {
				NewCoords => $adjacentCoord,
				TargetEntity => $entities
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
		L => "red",
		B => "yellow"
	};
	
	foreach my $row (0..$self->{Size} - 1) {
		foreach my $col (0..$self->{Size} - 1) {
			my $coords = $row . ',' . $col;
			
			my $entities = $self->GetEntity($coords);
			foreach my $entity (@$entities) {
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
		}
		
		print "\n";
	}
}

return 1;
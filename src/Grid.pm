package Grid;

use Term::ANSIColor;
use Win32::Console::ANSI;
use Data::Dumper;
use Bucket;
use List::Util 'shuffle';


sub New {
	my ($class, $size, $data, $options, $coordinateFinder) = @_;

	return bless {
		Data => $data,
		Options => $options,
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
	
	my $exists = exists $self->{Grid}->{$coords};
	my $empty = 0;
	
	if ($exists) {
		$empty = @{$self->{Grid}->{$coords}} == 0;
	}
	
	my $result = !$exists || $empty;
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
	my ($self, $coords, $entityType) = @_;
	
	my $entities = $self->GetEntity($coords);
	@$entities = grep { $_->GetType() ne $entityType } @$entities
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
		
		if ($entities == undef) {
			# empty space
			return {
				NewCoords => $adjacentCoord,
				TargetEntity => undef,
			}
		}
		elsif (Bucket->HasType($entities, $movingEntity->GetType())) {
			# if same type do not move there, check next adjacent spot
		}
		else {
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
			if ($entities && @$entities > 0) {
				my $entity = $entities->[-1];
				print "";
				my $symbol = $entity->GetSymbol();
				print color($colors->{$symbol});
				print $symbol;
				print color('white');
				print "";
			} 
			else {
				print " ";
			}
		}
		
		print "\n";
	}
}

sub AddRandomEntity {
	my ($self, $typeOfEntity) = @_;
	
	my $numAttempts = 1000;
	for (1..$numAttempts) {
		my $x = int(rand($self->{Size}));
		my $y = int(rand($self->{Size}));
		
		my $entity = $self->GetOneEntity("$x,$y", $typeOfEntity);
		if (!defined($entity)) {
			print "Yearly spawn of $typeOfEntity to $x,$y\n";
			
			my $entityOptions = $self->{Options}->{$typeOfEntity};
			my $entity = $typeOfEntity->New($self, $self->{Data}, $entityOptions);
			$self->SetEntity("$x,$y", $entity);
			$self->{Data}->{Counts}->{$typeOfEntity}++;
			last;
		}
		else {
			print "spot taken ($x,$y)\n";
		}
	}
}

sub RemoveRandomEntity {
	my ($self, $typeOfEntity) = @_;
	
	my @coords = shuffle($self->GetCoords());
	foreach my $coord (@coords) {
		my $entities = $self->GetEntity($coord);
		if (Bucket->HasType($coord, $typeOfEntity)) {	
			$self->RemoveEntity($coord, $typeOfEntity);
			$self->{Data}->{Counts}->{$typeOfEntity}--;
			print "Yearly removal of [$typeOfEntity]\n";
			last;
		}
	}
}

return 1;
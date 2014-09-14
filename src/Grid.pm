package Grid;

use Data::Dumper;
use Bucket;
use List::Util 'shuffle';
use IO::Handle;

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
	#print "---------------------\n";
	#print Dumper($self->{Grid}->{$coords});
	#print "ISEMPTYRESULT: $result\n\n";
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
			$self->SetEntity($coord, $entity);
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
		
		if (!defined($entities)) {
		
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



sub AddRandomEntity {
	my ($self, $typeOfEntity) = @_;
	
	my $numAttempts = 1000;
	for (1..$numAttempts) {
		my $x = int(rand($self->{Size}));
		my $y = int(rand($self->{Size}));
		
		my $entities = $self->GetEntity("$x,$y");
	
		#if (!Bucket->HasType($entities, $typeOfEntity))  {
		if (!defined($entities)) {
			#print "spawning $typeOfEntity @ $x,$y\n";
			my $entityOptions = $self->{Options}->{$typeOfEntity};
			my $entity = $typeOfEntity->New($self, $self->{Data}, $entityOptions);
			$self->SetEntity("$x,$y", $entity);
			$self->{Data}->{Counts}->{$typeOfEntity}++;
			$entities = $self->GetEntity("$x,$y");
			#print Dumper($entities);
			#my $wait = <>;
			return 1;
		}
	}
	
	#print "FAILED TO SPAWN";
	return 0;
}

sub RemoveRandomEntity {
	my ($self, $typeOfEntity) = @_;
	
	my @coords = shuffle($self->GetCoords());
	foreach my $coord (@coords) {
		my $entities = $self->GetEntity($coord);
		if (Bucket->HasType($entities, $typeOfEntity)) {	
			$self->RemoveEntity($coord, $typeOfEntity);
			$self->{Data}->{Counts}->{$typeOfEntity}--;
			#print "Yearly removal of [$typeOfEntity]\n";
			last;
		}
	}
}

return 1;
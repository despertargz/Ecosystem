package Grid;

use List::Util 'shuffle';

sub _FindAdjacentCoords {
	my ($self, $centerCoord) = @_;

	my $x = (split /,/, $centerCoord)[0];
	my $y = (split /,/, $centerCoord)[1];
	#print "Finding adjacent coords for $x,$y";
	
	my @translations = (
		[-1, 0], [-1, 1], [-1, -1],
		[1, 0], [1, 1], [1, -1],
		[0, 1], [0, -1]
	);
	
	my @adjacents = ();
	foreach my $translation (@translations) {
		 my $newX = $x + $translation->[0];
		 my $newY = $y + $translation->[1];
		 my $newCoord = "$newX,$newY";
		 if ($newY >= 0 && $newX >= 0 && $newY < $self->{Size} && $newX < $self->{Size} && $newCoord != $centerCoord) {
			push @adjacents, $newCoord;
		 }
		 else {
			#print "off grid! $newCoord\n";
		 }
	}
	
	return @adjacents;
}

sub New {
	my ($class, $size) = @_;

	my $self = {
		Size => $size,
		Grid => {}
	};
	
	return bless $self;
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
	my ($self, $coords) = @_;
	
}

sub MoveEntity {
	my ($self, $coords, $spaces) = @_;
	
	
}

sub CreateEntityNearby {
	my ($self, $entity, $coords) = @_;
	

	@coords = $self->_FindAdjacentCoords($coords);
	#print "Found adjacent coords: @coords";
	
	@shuffledCoords = shuffle(@coords);
	
	foreach my $coord (@shuffledCoords) {
		my $existingEntity = $self->GetEntity($coord);
		if ($existingEntity == undef) {
			$self->{Grid}->{$coord} = $entity;
			return 1;
		}
	}
	
	#print "Could not find space to put entity!\n";
	return 0;
}

sub Draw {
	my $self = shift;

	foreach my $row (0..$self->{Size} - 1) {
		foreach my $col (0..$self->{Size} - 1) {
			my $coords = $row . ',' . $col;
			
			my $entity = $self->{Grid}->{$coords};
			
			print "";
			if ($entity) {
				print $entity->GetSymbol();
			}
			else {
				print "_";
			}
			print "";
		}
		
		print "\n";
	}
}

return 1;
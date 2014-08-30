package Grid;

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

sub CreateEntity {
	my ($self, $entity, $coords) = @_;
	
	if ($coords == undef) {
		# keep trying to find empty space
		while (1) {
			my $x = int(rand($self->{Size}));
			my $y = int(rand($self->{Size}));
			
			$coords = "$x,$y";
			my $existingEntity = $self->GetEntity($coords);
			if ($existingEntity == undef) {
				print "Creating entity @ $coords\n";
				$self->{Grid}->{$coords} = $entity;
				return 1;
			}
		}
	}
	else {
		my $existingEntity = $self->GetEntity($coords);
		if ($existingEntity == undef) {
			$self->{Grid}->{$coords} = $entity;
			return 1;
		}
		else {
			return 0;
		}
	}
}

sub Draw {
	my $self = shift;

	foreach my $row (0..$self->{Size}) {
		foreach my $col (0..$self->{Size}) {
			my $coords = $row . ',' . $col;
			
			my $entity = $self->{Grid}->{$coords};
			
			print " ";
			if ($entity) {
				print $entity->GetSymbol();
			}
			else {
				print "_";
			}
			print " ";
		}
		
		print "\n";
	}
}

return 1;
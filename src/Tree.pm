package Tree;

sub New {
	my ($class, $grid, $data, $treeOptions) = @_;

	#age in months
	return bless {
		Age => 0,
		Grid => $grid,
		Data => $data,
		TreeOptions => $treeOptions
	};
}

sub GetType {
	my ($self) = @_;
	
	if ($self->{Age} < $self->{TreeOptions}->{Age}->{Tree}) {
		return "Sapling";
	}
	elsif ($self->{Age} < $self->{TreeOptions}->{Age}->{ElderTree}) {
		return "Tree";
	}
	else {
		return "ElderTree";
	}
}

sub SpawnSappling {
	my ($self, $coord) = @_;
	
	my $tree = Tree->New($self->{Grid}, $self->{Data}, $self->{TreeOptions});
	my $result = $self->{Grid}->CreateEntityNearby($tree, $coord);
	if ($result) {
		$self->{Data}->{Counts}->{Tree}++;
	}
	
	
	#$treeCount = $self->{Counts}->{Tree};
	#print "Spawning sappling! There are $treeCount trees.\n";
	
}

sub TakeTurn {
	my ($self, $coord) = @_;
	
	#print "Tree is taking turn!\n";
	$self->{Age}++;
	
	my $treeType = $self->GetType();
	my $spawnPercentage = $self->{TreeOptions}->{SpawnPercentage}->{$treeType};
	if (rand(1) < $spawnPercentage) {
		$self->SpawnSappling($coord);
	}
}

sub GetSymbol {
	my $self = shift;

	return substr $self->GetType(), 0, 1;
}

return 1;
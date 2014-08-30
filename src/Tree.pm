package Tree;

sub New {
	my ($class, $grid, $counts, $treeOptions) = @_;

	#age in months
	return bless {
		Age => 0,
		Grid => $grid,
		Counts => $counts,
		TreeOptions => $treeOptions
	};
}

sub GetTreeType {
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
	my $self = shift;
	
	
	
	my $tree = Tree->New();
	$self->{Grid}->CreateEntity($tree);
	$self->{Counts}->{Tree}++;
	
	$treeCount = $self->{Counts}->{Tree};
	print "Spawning sappling! There are $treeCount trees.\n";
	
}

sub TakeTurn {
	my $self = shift;
	
	print "Tree is taking turn!\n";
	$self->{Age}++;
	
	my $treeType = $self->GetTreeType();
	my $spawnPercentage = $self->{TreeOptions}->{SpawnPercentage}->{$treeType};
	if (rand(1) < $spawnPercentage) {
		$self->SpawnSappling();
	}
}

sub GetSymbol {
	return "T";
}

return 1;
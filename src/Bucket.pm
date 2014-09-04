package Bucket;

sub New {
	my ($self, $entities) = @_;
	
	return bless {
		Entities => $entities
	};
}

sub HasType {
	my ($class, $entities, $type) = @_;
	
	foreach my $entity (@$entities) {
		if ($entity->GetType() eq $type) {
			return 1;
		}
	}
	
	# could not find type in bucket
	return 0;
}

return 1;
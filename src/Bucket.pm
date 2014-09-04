package Bucket;

sub HasType {
	my ($class, $entities, $type) = @_;
	
	foreach my $entity (@$entities) {
		#print "Checking bucket..." . $entity->GetType() . "\n";
		if ($entity->GetType() eq $type) {
			return 1;
		}
	}
	
	#print "Bucket empty..." . "\n";
	# could not find type in bucket
	return 0;
}

return 1;
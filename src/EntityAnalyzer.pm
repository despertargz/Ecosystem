package EntityAnalyzer;

sub New {
	return bless { 
		"TreeVsLumberJack" => "Lesser",
		"LumberJackVsTree" => "Greater",
		"LumberJackVsBear" => "Lesser",
		"BearVsLumberJack" => "Greater"
	};
}

sub Analyze {
	my ($self, $movingEntity, $targetEntity) = @_;
	
	my $movingType = $movingEntity->GetType();
	my $targetType = $targetEntity->GetType();
	
	if ($targetEntity == undef) {
		return "Empty";
	}
	
	if ($movingType eq $targetType) {
		return "Same";
	}
	
	my $vs = $movingType . "Vs" . $targetType;
	my $result = $self->{$vs};
	
	if ($result eq undef) {
		#undef means there is no enemy mapping so they are friendly
		return "Friendly"
	}
	else {
		return $result;
	}
}

return 1;
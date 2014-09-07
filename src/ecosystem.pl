use strict;
use warnings;
#use diagnostics;

use FindBin qw($Bin);
use lib $Bin;

use Time::HiRes qw(sleep usleep);
use Carp::Always;
use List::Util 'shuffle';

use Grid;
use CoordinateFinder;
use Tree;
use LumberJack;
use Bear;

my $options = {
	Tree => {
		Age => {
			ElderTree => 120,
			Tree => 12,
			Sapling => 0
		},
		SpawnPercentage => {
			ElderTree => .20,
			Tree => .10,
			Sappling => .00
		}
	},
	LumberJack => { 
		Moves => 3
	},
	Bear => {
		Moves => 5
	}
};

my $data = {
	Counts => {
		Tree => 0,
		LumberJack => 0,
		Bear => 0
	},
	MonthlyData => {
		Lumber => 0,
		Maws => 0
	}
};

my $spawnPercentages = {
	Bear => .02,
	LumberJack => .10,
	Tree => .50
};

my $gridSize = 25;
my $totalSpots = $gridSize * $gridSize;

my $coordinateFinder = CoordinateFinder->New();
my $grid = Grid->New($gridSize, $coordinateFinder);

foreach my $entityType (keys $spawnPercentages) {
	my $numEntitiesToSpawn = int($totalSpots * $spawnPercentages->{$entityType});
	$data->{Counts}->{$entityType} = $numEntitiesToSpawn;
	print "spawning $numEntitiesToSpawn $entityType\n";
	
	foreach (1..$numEntitiesToSpawn) {
		AddRandomEntity($data, $grid, $options, $entityType);
	}
}

my $MONTHS_PER_YEAR = 12;
my $YEARS = 400;
my $MONTHS_TO_SIMULATE = $YEARS * $MONTHS_PER_YEAR;

foreach my $month (1..$MONTHS_TO_SIMULATE) {
	foreach my $coord ($grid->GetCoords()) {
		my $ecoEntities = $grid->GetEntity($coord);
		if (defined($ecoEntities)) {
			foreach my $ecoEntity (@$ecoEntities) {
				$ecoEntity->TakeTurn($coord);
			}
		}
	}
	
	if ($month % $MONTHS_PER_YEAR == 0) {
		RunYearlyEvents($data, $grid, $options);
	}
	
	system 'cls';
	$grid->Draw();
	
	print "Year " . int($month / $MONTHS_PER_YEAR) . "." . ($month % $MONTHS_PER_YEAR) . "\n";
	print "--------------------\n";
	print "trees: " . $data->{Counts}->{Tree} . "\n";
	print "lumberjacks: " . $data->{Counts}->{LumberJack} . "\n";
	print "bears: " . $data->{Counts}->{Bear} . "\n";
	print "--------------------\n";
	print "lumber: " . $data->{MonthlyData}->{Lumber} . "\n";
	print "maws: " . $data->{MonthlyData}->{Maws} . "\n";
	print "\n";
	sleep(.25);
	
}

sub AddRandomEntity {
	my ($data, $grid, $options, $typeOfEntity) = @_;
	
	my $numAttempts = 1000;
	for (1..$numAttempts) {
		my $x = int(rand($grid->{Size}));
		my $y = int(rand($grid->{Size}));
		
		my $entity = $grid->GetOneEntity("$x,$y", $typeOfEntity);
		if (!defined($entity)) {
			print "adding $typeOfEntity to $x,$y\n";
			
			my $entityOptions = $options->{$typeOfEntity};
			my $entity = $typeOfEntity->New($grid, $data, $entityOptions);
			$grid->SetEntity("$x,$y", $entity);
			$data->{Counts}->{$typeOfEntity}++;
			last;
		}
		else {
			print "spot taken ($x,$y)\n";
		}
	}
}

sub RemoveRandomEntity {
	my ($grid, $typeOfEntity) = @_;
	
	my @coords = shuffle($grid->GetCoords());
	foreach my $coord (@coords) {
		my $entities = $grid->GetEntity($coord);
		if (Bucket->HasType($coord, $typeOfEntity)) {	
			$grid->RemoveEntity($coord, $typeOfEntity);
			$data->{Counts}->{$typeOfEntity}--;
			print "Removing entity [$typeOfEntity]\n";
			last;
		}
	}
}

sub CheckMaws {
	my ($data, $grid, $options) = @_;

	if ($data->{MonthlyData}->{Maws} > 0) {
		RemoveRandomEntity($grid, "Bear");
	}
	else {
		AddRandomEntity($data, $grid, $options, "Bear");
	}
	
	$data->{MonthlyData}->{Maws} = 0;
}

sub CheckLumber {
	my ($data, $grid, $options) = @_;
	
	my $lumberJacksToHire = int($data->{MonthlyData}->{Lumber} / $data->{Counts}->{LumberJack});
	if ($lumberJacksToHire > 0) {
		foreach (1..$lumberJacksToHire) {
			AddRandomEntity($data, $grid, $options, "LumberJack");
		}
	}
	elsif ($data->{Counts}->{LumberJack} > 1) {
		RemoveRandomEntity($grid, $options, "LumberJack");
	}
	
	$data->{MonthlyData}->{Lumber} = 0;
}

sub RunYearlyEvents {
	my ($data, $grid, $options) = @_;
	
	CheckMaws($data, $grid, $options);
	CheckLumber($data, $grid, $options)
}
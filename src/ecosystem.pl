use strict;
use warnings;
#use diagnostics;

use FindBin qw($Bin);
use lib $Bin;

use Time::HiRes qw(sleep usleep);
use Carp::Always;

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
		Moves = 5
	}
}

my $data = {
	Counts => {
		Tree => 5,
		LumberJack => 4,
		Bear => 1
	},
	MonthlyData => {
		Lumber => 0,
		Maws => 0
	}
};

my $coordinateFinder = CoordinateFinder->New();
my $grid = Grid->New(25, $coordinateFinder);



my $MONTHS_PER_YEAR = 12;
my $YEARS = 400;
my $MONTHS_TO_SIMILUATE = $YEARS * $MONTHS_PER_YEAR;

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
	print "trees: " . $data->{Counts}->{Tree} . "\n";
	print "lumberjacks: " . $data->{Counts}->{LumberJack} . "\n";
	print "lumber: " . $data->{MonthlyData}->{Lumber} . "\n";
	print "maws: " . $data->{MonthlyData}->{Maws} . "\n";
	print "\n";
	sleep(.25);
	
}

sub RemoveBear {
	my ($grid) = @_;
	
	my $coords = shuffle($grid->GetCoords());
	foreach my $coord ($coords) {
		if (Bucket->HasType($coord, "Bear")) {
			$data->{CountS}->{Bear}--;
			$grid->RemoveEntity($coord, "Bear");
			print "ZooKeeper has removed a bear!";
		}
	}
}

sub AddRandomEntity {
	my ($data, $grid, $options, $typeOfEntity) = @_;
	
	my $x = int(rand($grid->{Size}));
	my $y = int(rand($grid->{Size}));
	
	my $entityOptions = $globalOptions->{$typeOfEntity};
	my $entity = $typeOfEntity->New($grid, $data, $options);
	$grid->SetEntity("$x,$y", $entity);
	
	$data->{Counts}->{$typeOfEntity}++;
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
		RemoveBear($grid);
	}
	else {
		AddEntity($grid, $data, 
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
	else if ($data->{Counts}->{LumberJack} > 1) {
		RemoveRandomEntity($grid, $options, "LumberJack");
	}
	
	$data->{MonthlyData}->{Lumber} = 0;
}

sub RunYearlyEvents {
	my ($data, $grid, $options) = @_;
	
	CheckMaws($data, $grid, $options);
	CheckLumber($data, $grid, $options)
}
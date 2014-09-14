use strict;
use warnings;
#use diagnostics;

use FindBin qw($Bin);
use lib $Bin;

use Time::HiRes qw(sleep usleep gettimeofday);
use Carp::Always;
use List::Util 'shuffle';
use Tk;
use threads;

use Grid;
use CoordinateFinder;
use Tree;
use LumberJack;
use Bear;
use Bucket;
use ConsoleGridDrawer;
use TkGridDrawer;

my ($gridSize) = @ARGV;
$gridSize = $gridSize ? $gridSize : 25;

$Data::Dumper::Maxdepth = 2;

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
	},
	StaticData => {
		TotalLumber => 0,
		TotalMaws => 0,
	}
};

my $spawnPercentages = {
	Bear => .04,
	LumberJack => .10,
	Tree => .50
};

my $totalSpots = $gridSize * $gridSize;

my $coordinateFinder = CoordinateFinder->New();
my $grid = Grid->New($gridSize, $data, $options, $coordinateFinder);

foreach my $entityType (keys $spawnPercentages) {
	my $numEntitiesToSpawn = int($totalSpots * $spawnPercentages->{$entityType});
	
	print "spawning $numEntitiesToSpawn $entityType\n";
	
	foreach (1..$numEntitiesToSpawn) {
		my $spawnResult = $grid->AddRandomEntity($entityType);
		if (!$spawnResult) {
			print "FAILED TO SPAWN: $entityType";
		}
	}
}


#my $gridDrawer = ConsoleGridDrawer->new();
my $gridDrawer = TkGridDrawer->new(\&mainForestLoop);

my $MONTHS_PER_YEAR = 12;
my $YEARS = 400;
my $MONTHS_TO_SIMULATE = $YEARS * $MONTHS_PER_YEAR;

$Data::Dumper::Maxdepth = 2;

MainLoop();

sub mainForestLoop {
	foreach my $month (1..$MONTHS_TO_SIMULATE) {
		#my $time_start = gettimeofday();

		foreach my $coord ($grid->GetCoords()) {
			#my $coord_start = gettimeofday();
			
			my $ecoEntities = $grid->GetEntity($coord);
			if (defined($ecoEntities)) {
				foreach my $ecoEntity (@$ecoEntities) {
					#print "[" . $ecoEntity->GetType() . "] taking turn...\n";
					$ecoEntity->TakeTurn($coord);
				}
			}
			
			#print((gettimeofday() - $coord_start) . "\n");
		}
		
		#print((gettimeofday() - $time_start) . "\n");
		
		if ($month % $MONTHS_PER_YEAR == 0) {
			RunYearlyEvents($data, $grid, $options);
			$gridDrawer->draw($grid);
		}
		
		system 'cls';
		
		
		
		print "Year " . int($month / $MONTHS_PER_YEAR) . "." . ($month % $MONTHS_PER_YEAR) . "\n";
		print "--------------------\n";
		print "trees: " . $data->{Counts}->{Tree} . "\n";
		print "lumberjacks: " . $data->{Counts}->{LumberJack} . "\n";
		print "bears: " . $data->{Counts}->{Bear} . "\n";
		print "--------------------\n";
		print "lumber: " . $data->{MonthlyData}->{Lumber} . "\n";
		print "maws: " . $data->{MonthlyData}->{Maws} . "\n";
		#print "--------------------\n";
		#print "total lumber: $data->{StaticData}->{TotalLumber}\n";
		#print "total maws: $data->{StaticData}->{TotalMaws}\n";
		#print "--------------------\n";
		print "\n";

		#sleep(1);
	}
}

sub CheckMaws {
	my ($data, $grid, $options) = @_;

	if ($data->{MonthlyData}->{Maws} > 0) {
		$grid->RemoveRandomEntity("Bear");
	}
	else {
		$grid->AddRandomEntity("Bear");
	}
	
	$data->{MonthlyData}->{Maws} = 0;
}

sub CheckLumber {
	my ($data, $grid, $options) = @_;
	
	my $lumberJacksToHire = int($data->{MonthlyData}->{Lumber} / $data->{Counts}->{LumberJack});

	if ($lumberJacksToHire > 0) {
		foreach (1..$lumberJacksToHire) {
			$grid->AddRandomEntity("LumberJack");
		}
	}
	elsif ($data->{Counts}->{LumberJack} > 1) {
		$grid->RemoveRandomEntity("LumberJack");
	}
	
	$data->{MonthlyData}->{Lumber} = 0;
}

sub RunYearlyEvents {
	my ($data, $grid, $options) = @_;
	
	CheckMaws($data, $grid, $options);
	CheckLumber($data, $grid, $options)
}
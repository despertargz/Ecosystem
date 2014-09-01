use strict;
use warnings;

use FindBin qw($Bin);
use lib $Bin;
use Time::HiRes qw(sleep usleep);

use Grid;
use Tree;
use LumberJack;
use CoordinateFinder;

my $treeOptions = {
	Age => {
		ElderTree => 120,
		Tree => 12,
		Sappling => 0
	},
	SpawnPercentage => {
		ElderTree => .20,
		Tree => .10,
		Sappling => .00
	}
};

my $lumberJackOptions = {
	Moves => 3
};

my $data = {
	Counts => {
		Tree => 1,
		LumberJack => 1,
		Bear => 0
	},
	MonthlyData => {
		Lumber => 0,
		Maws => 0
	}
};

my $coordinateFinder = CoordinateFinder->New();
my $grid = Grid->New(10, $coordinateFinder);

my $tree = Tree->New($grid, $data, $treeOptions);
$tree->{Age} = 12;
my $lumberJack = LumberJack->New($grid, $data, $lumberJackOptions);
$grid->SetEntity("0,0", $tree);
$grid->SetEntity("9,9", $lumberJack);

my $MONTHS_PER_YEAR = 12;
my $YEARS = 400;
my $MONTHS = $YEARS * $MONTHS_PER_YEAR;

foreach my $month (1..$MONTHS) {
	foreach my $coord ($grid->GetCoords()) {
		my $ecoEntity = $grid->GetEntity($coord);
		if (defined($ecoEntity)) {
			$ecoEntity->TakeTurn($coord);
		}
	}
	
	system 'cls';
	$grid->Draw();
	
	print "Year " . int($month / 12) . "." . ($month % 12) . "\n";
	print "trees: " . $data->{Counts}->{Tree} . "\n";
	print "lumberjacks: " . $data->{Counts}->{LumberJack} . "\n";
	print "lumber: " . $data->{MonthlyData}->{Lumber} . "\n";
	print "\n";
	sleep(.10);
	
}
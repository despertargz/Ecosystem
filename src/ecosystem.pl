use strict;
use warnings;

use FindBin qw($Bin);
use lib $Bin;
use Time::HiRes qw(sleep usleep);

use Grid;
use Tree;

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

my $counts = {
	Tree => 1,
	LumberJacks => 0,
	Bears => 0
};

my $grid = Grid->New(50);
my $tree = Tree->New($grid, $counts, $treeOptions);
$grid->CreateEntityNearby($tree, "25,25");

my $MONTHS_PER_YEAR = 12;
my $YEARS = 400;
my $MONTHS = $YEARS * $MONTHS_PER_YEAR;
foreach my $month (1..$MONTHS) {
	foreach my $coord ($grid->GetCoords()) {
		my $ecoEntity = $grid->GetEntity($coord);
		$ecoEntity->TakeTurn($coord);
	}
	
	
	system 'cls';
	$grid->Draw();
	print "Year #" . int($month / 12) . "." . ($month % 12) . "\n";
	print $counts->{Tree};
	#if ($counts->{Tree} >= 100) {
		#exit;
	#}
	
	#sleep(.001);
}
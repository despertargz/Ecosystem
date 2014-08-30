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
	Tree => 0,
	LumberJacks => 0,
	Bears => 0
};

my $grid = Grid->New(10);
my $tree = Tree->New($grid, $counts, $treeOptions);
$grid->CreateEntity($tree, "5,5");

my $MONTHS_PER_YEAR = 12;
my $YEARS = 400;
my $MONTHS = $YEARS * $MONTHS_PER_YEAR;
for (1..$MONTHS) {
	foreach my $coord ($grid->GetCoords()) {
		my $ecoEntity = $grid->GetEntity($coord);
		$ecoEntity->TakeTurn();
		$grid->Draw();
		
		sleep(.25);
	}
}
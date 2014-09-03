use strict;
use warnings;

use FindBin qw($Bin);
use lib $Bin;
use Time::HiRes qw(sleep usleep);

use Grid;
use Tree;
use LumberJack;
use MockCoordinateFinder;
use CoordinateFinder;

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

#LumberJack_TakeTurn_MovingOnTopOfTreeShouldCutItDown();
#Grid_RemoveEntity();
#Grid_SetEntity();
CoordinateFinder_GetAdjacentCoordinates();

sub LumberJack_TakeTurn_MovingOnTopOfTreeShouldCutItDown {
	my $coordinateFinder = MockCoordinateFinder->New("0,0");
	my $grid = Grid->New(10, $coordinateFinder);

	my $tree = Tree->New($grid, $data, undef);
	my $lumberJack = LumberJack->New($grid, $data, $lumberJackOptions);
	$grid->SetEntity("0,0", $tree);
	$grid->SetEntity("0,1", $lumberJack);
	$lumberJack->TakeTurn("0,1");

	print "trees: " . $data->{Counts}->{Tree} . "\n";
	print "lumberjacks: " . $data->{Counts}->{LumberJack} . "\n";
	print "lumber: " . $data->{MonthlyData}->{Lumber} . "\n";
	$grid->Draw();
}



sub Grid_SetEntity {
	my $grid = Grid->New(10, undef);
	
	my $tree = Tree->New($grid, $data, undef);
	$grid->SetEntity("0,0", $tree);
	$grid->Draw();
}

sub Grid_RemoveEntity { 
	my $grid = Grid->New(10, undef);
	
	my $tree = Tree->New($grid, $data, undef);
	
	$grid->SetEntity("0,0", $tree);
	$grid->RemoveEntity("0,0", $tree);
	$grid->Draw();
}

sub CoordinateFinder_GetAdjacentCoordinates {
	my $coordinateFinder = CoordinateFinder->New();
	my @coords = $coordinateFinder->GetAdjacentCoordinates(10, "5,5");
	$, = "\n";
	print @coords;
}
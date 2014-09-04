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

my $treeOptions = {
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
};


#LumberJack_TakeTurn_MovingOnTopOfTreeShouldCutItDown();
LumberJack_TakeTurn_MovingOnTopOfSaplingShouldNotCutItDown();
#Grid_RemoveEntity();
#Grid_SetEntity();
#CoordinateFinder_GetAdjacentCoordinates();
#Grid_IsEmpty_WhenEmptyShouldReturnTrue();
#Grid_IsEmpty_WhenNotEmptyShouldReturnFalse();
#Grid_IsEmpty_WithMultipleEntitiesShouldReturnFalse();



sub LumberJack_TakeTurn_MovingOnTopOfTreeShouldCutItDown {
	my $coordinateFinder = MockCoordinateFinder->New("0,0");
	my $grid = Grid->New(10, $coordinateFinder);

	my $tree = Tree->New($grid, $data, );
	my $lumberJack = LumberJack->New($grid, $data, $lumberJackOptions);
	$grid->SetEntity("0,0", $tree);
	$grid->SetEntity("0,1", $lumberJack);
	$lumberJack->TakeTurn("0,1");

	print "trees: " . $data->{Counts}->{Tree} . "\n";
	print "lumberjacks: " . $data->{Counts}->{LumberJack} . "\n";
	print "lumber: " . $data->{MonthlyData}->{Lumber} . "\n";
	$grid->Draw();
}

sub LumberJack_TakeTurn_MovingOnTopOfSaplingShouldNotCutItDown {
	my $coordinateFinder = MockCoordinateFinder->New(["0,0", "0,0", "0,0"]);
	my $grid = Grid->New(10, $coordinateFinder);

	my $tree = Tree->New($grid, $data, $treeOptions);
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

sub Grid_IsEmpty_WhenEmptyShouldReturnTrue {
	my $grid = Grid->New(10, undef);
	my $tree = Tree->New($grid, $data, undef);
	
	$grid->SetEntity("0,0", $tree);
	print $grid->IsEmpty("0,0") ? "EMPTY" : "NOT-EMPTY";
}

sub Grid_IsEmpty_WhenNotEmptyShouldReturnFalse {
	my $grid = Grid->New(10, undef);
	my $tree = Tree->New($grid, $data, undef);
	
	print $grid->IsEmpty("0,0") ? "EMPTY" : "NOT-EMPTY";
}

sub Grid_IsEmpty_WithMultipleEntitiesShouldReturnFalse {
	my $grid = Grid->New(10, undef);
	my $tree = Tree->New($grid, $data, undef);
	
	$grid->SetEntity("0,0", Tree->New($grid, $data, undef));
	$grid->SetEntity("0,0", Tree->New($grid, $data, undef));
	
	print $grid->IsEmpty("0,0") ? "EMPTY" : "NOT-EMPTY";
}

sub CoordinateFinder_GetAdjacentCoordinates {
	my $coordinateFinder = CoordinateFinder->New();
	my @coords = $coordinateFinder->GetAdjacentCoordinates(10, "5,5");
	$, = "\n";
	print @coords;
}
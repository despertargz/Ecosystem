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

my $lumberJackOptions = {
	Moves => 3
};

my $bearOptions = {
	Moves => 5
};

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

my $tree = Tree->New($grid, $data, $treeOptions);
$tree->{Age} = 12;
my $lumberJack = LumberJack->New($grid, $data, $lumberJackOptions);
my $bear = Bear->New($grid, $data, $bearOptions);

$grid->SetEntity("1,1", Tree->New($grid, $data, $treeOptions));
$grid->SetEntity("1,2", Tree->New($grid, $data, $treeOptions));
$grid->SetEntity("1,3", Tree->New($grid, $data, $treeOptions));
$grid->SetEntity("1,4", Tree->New($grid, $data, $treeOptions));
$grid->SetEntity("1,5", Tree->New($grid, $data, $treeOptions));
$grid->SetEntity("6,9", $lumberJack);
$grid->SetEntity("8,9", $lumberJack);
$grid->SetEntity("7,9", $lumberJack);
$grid->SetEntity("5,9", $lumberJack);
#$grid->SetEntity("5,5", $bear);


my $MONTHS_PER_YEAR = 12;
my $YEARS = 400;
my $MONTHS = $YEARS * $MONTHS_PER_YEAR;

foreach my $month (1..$MONTHS) {
	foreach my $coord ($grid->GetCoords()) {
		my $ecoEntities = $grid->GetEntity($coord);
		if (defined($ecoEntities)) {
			foreach my $ecoEntity (@$ecoEntities) {
				$ecoEntity->TakeTurn($coord);
			}
		}
	}
	
	if ($month % $MONTHS_PER_YEAR == 0) {
		
	}
	
	system 'cls';
	$grid->Draw();
	
	print "Year " . int($month / 12) . "." . ($month % 12) . "\n";
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
	my ($grid, $type, $options) = @_;
	
	my $x = int(rand($grid->{Size}));
	my $y = int(rand($grid->{Size}));
	$grid->SetEntity("$x,$y", $type->New($options));
}

sub RemoveRandomEntity {
	my ($grid, $type) = @_;
}

sub CheckMaws {
	my ($data, $grid, $bearOptions) = @_;

	if ($data->{MonthlyData}->{Maws} > 0) {
		RemoveBear($grid);
	}
	else {
		AddEntity($grid, "Bear" $bearOptions);
	}
	
	$data->{MonthlyData}->{Maws} = 0;
}

sub Add

sub CheckLumber {
	my ($data, $grid, $lumberJackOptions) = @_;
	
	my $lumberJacksToHire = int($data->{MonthlyData}->{Lumber} / $data->{Counts}->{LumberJack});
	foreach (1..$lumberJacksToHire) {
	}
}

sub IncrementYear {
	my ($data, $grid, $bearOptions, $lumberJackOptions) = @_;
	
	CheckMaws($data, $grid, $bearOptions);
	
}
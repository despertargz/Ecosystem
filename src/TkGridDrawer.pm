package TkGridDrawer;

use Tk;
use Tk::Canvas;

sub new {
	my $window = MainWindow->new();
	$window->minsize(qw(250 250));

	my $canvas = $window->Canvas(-background => "white");
	$canvas->pack(-expand => 1, -fill => "both");

	return bless {
		Canvas => $canvas
	};
}

sub draw {
	my ($self, $grid) = @_;
	
	my $colors = {
		S => "cyan",
		T => "green",
		E => "magenta",
		L => "red",
		B => "yellow"
	};
	
	my $PIXEL_SIZE = 15;
	
	foreach my $row (0..$grid->{Size} - 1) {
		foreach my $col (0..$grid->{Size} - 1) {
			my $coords = $row . ',' . $col;
			
			my $pixelX = $row * $PIXEL_SIZE;
			my $pixelY = $col * $PIXEL_SIZE;
			
			my $entities = $grid->GetEntity($coords);
			
			my $color = "white";
			if ($entities && @$entities > 0) {
				my $entity = $entities->[-1];
				my $symbol = $entity->GetSymbol();
				$color = $colors->{$symbol};
			}
			
			$self->{Canvas}->createRectangle($pixelX, $pixelY, $PIXEL_SIZE, $PIXEL_SIZE, -fill => $color);

		}
	}
}

return 1;

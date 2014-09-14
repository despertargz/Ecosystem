package TkGridDrawer;

use Tk;
use Tk::Canvas;

sub new {
	my ($class, $forestLoop) = @_;

	my $window = MainWindow->new();
	$window->minsize(qw(250 250));

	my $canvas = $window->Canvas(-background => "white");
	$canvas->pack(-expand => 1, -fill => "both");

	$window->after(10, $forestLoop);
	
	return bless {
		Canvas => $canvas
	};
}

sub draw {
	my ($self, $grid) = @_;
	
	my $colors = {
		S => "#00FF2F",
		T => "#479455",
		E => "#004D0E",
		L => "#FFAE00",
		B => "#E80000"
	};
	
	my $PIXEL_SIZE = 15;
	$self->{Canvas}->delete('all');
	
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
			
			$self->{Canvas}->createRectangle(
				$pixelX, $pixelY, $pixelX + $PIXEL_SIZE, $pixelY + $PIXEL_SIZE, -fill => $color
			);

		}
	}
	
	$self->{Canvas}->update();
}

return 1;

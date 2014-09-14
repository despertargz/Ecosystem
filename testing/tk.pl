use strict;
use warnings;

use Tk;
use Tk::Canvas;
use threads;

my $window = MainWindow->new();
$window->minsize(qw(250 250));

my $canvas = $window->Canvas(-background => "white");
$canvas->pack(-expand => 1, -fill => "both");

#$canvas->createRectangle(0, 0, 15, 15, -fill => 'green');
#$canvas->createRectangle(15, 0, 30, 15, -fill => 'blue');

#threads->create(\&draw);
draw();

MainLoop();


print "NOOOO: $@";


print "done!";

sub draw {
	my @colors = qw(green blue purple);
	my $n = 0;

	$window->after(10 => sub {
		while (1) {
			print $n++ . "\n";
			$canvas->delete('all');
			
			foreach my $x (0..49) {
				foreach my $y (0..49) {
					my $num = int(rand(@colors));
					my $color = $colors[$num];
					my $r = $canvas->createRectangle($x * 15, $y * 15, $x * 15 + 15, $y * 15 + 15, -fill => $color);
				}
			}
			
			
			
			$canvas->update();
			#sleep 1;
		}
	});
	
}

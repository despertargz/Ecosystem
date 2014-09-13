use strict;
use warnings;
use Tk;
use Tk::Canvas;

my $window = MainWindow->new();
$window->minsize(qw(250 250));

my $canvas = $window->Canvas(-background => "white");

$canvas->createRectangle(0, 0, 50, 50, -fill => 'blue');
$canvas->pack(-expand => 1, -fill => "both");

MainLoop();
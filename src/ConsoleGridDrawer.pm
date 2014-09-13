package ConsoleGridDrawer;

use Term::ANSIColor;
use Win32::Console::ANSI;

sub new {
	return bless {};
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
	
	STDOUT->autoflush(0);
	my $outputBuffer = "";
	foreach my $row (0..$grid->{Size} - 1) {
		foreach my $col (0..$grid->{Size} - 1) {
			my $coords = $row . ',' . $col;
			
			my $entities = $grid->GetEntity($coords);
			if ($entities && @$entities > 0) {
				my $entity = $entities->[-1];
				#print "";
				
				my $symbol = $entity->GetSymbol();
				
				#print color($colors->{$symbol});
				#print $symbol;
				#print color('white');
				#print "";
				
				#if (0) {
					#$outputBuffer .= color($colors->{$symbol}) . $symbol . color('white');
				#}
				
				$outputBuffer .= color("white on_$colors->{$symbol}") . "  " . color('black on_white');
				#$outputBuffer .= color($colors->{$symbol}) . $symbol . color('white');
				
				
			} 
			else {
				#print " ";
				$outputBuffer .= "  ";
			}
		}
		
		#print "\n";
		$outputBuffer .= "\n";
	}
	
	print $outputBuffer;
	#STDOUT->flush();
}

return 1;
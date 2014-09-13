use threads;

my $thread1 = threads->create(\&count);
my $thread2 = threads->create(\&count);
my $thread3 = threads->create(\&count);

$thread1->join();
$thread2->join();
$thread3->join();

sub count {
	foreach (1..10) {
		print $_ . "\n";
		sleep 1;
	}
}
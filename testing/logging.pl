use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($DEBUG);

DEBUG "testing a debug";
ERROR "testing error";

my $logger = Log::Log4perl->get_logger('my.logger');
$logger->debug('obj debug');
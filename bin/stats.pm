package hipify_stats;
use strict;
use warnings;
use Exporter 'import';
our @EXPORT = qw(init_stats inc_total inc_converted inc_replaced inc_unsupported emit_stats);

sub init_stats {
  return {
    total       => 0,
    converted   => 0,
    replaced    => 0,
    unsupported => 0,
  };
}

sub inc_total       { $_[0]->{total}++ }
sub inc_converted   { $_[0]->{converted}++ }
sub inc_replaced    { $_[0]->{replaced}++ }
sub inc_unsupported { $_[0]->{unsupported}++ }

sub emit_stats {
  my ($stats, $json) = @_;
  if ($json) {
    require JSON::PP;
    my $encoder = JSON::PP->new->ascii->canonical(1);
    print $encoder->encode($stats) . "\n";
  } else {
    printf("HIPIFY stats: total=%d converted=%d replaced=%d unsupported=%d\n",
      $stats->{total}, $stats->{converted}, $stats->{replaced}, $stats->{unsupported});
  }
}
1;

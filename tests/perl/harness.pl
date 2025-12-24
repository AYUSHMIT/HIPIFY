#!/usr/bin/env perl
use strict;
use warnings;

sub read_file {
  my $file = shift;
  open my $fh, '<', $file or die "Cannot open $file: $!";
  local $/;
  my $content = <$fh>;
  close $fh;
  return $content;
}

my $hipify = 'bin/hipify-perl';
my @tests = (
  {
    name => 'simple-kernel',
    in   => 'tests/perl/fixtures/simple_kernel.cu',
    out  => 'tests/perl/expected/simple_kernel.hip.cpp',
  },
);

my $fail = 0;
for my $t (@tests) {
  my $output = qx(perl $hipify $t->{in});
  my $expected = read_file($t->{out});

  if ($output ne $expected) {
    print STDERR "Test '$t->{name}' failed\n";
    $fail = 1;
  } else {
    print "Test '$t->{name}' passed\n";
  }
}
exit($fail);

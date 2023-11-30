#!/usr/bin/env perl

use 5.38.0;
use warnings;
use utf8;
use FindBin;
use Carp qw/croak/;

sub docker {
    my @args = @_;
    say STDERR "docker @args";
    if (system('docker', @args) == 0) {
        return;
    }
    say STDERR "failed to build, try...";
    sleep(5);
    if (system('docker', @args) == 0) {
        return;
    }
    say STDERR "failed to build, try...";
    sleep(10);
    if (system('docker', @args) == 0) {
        return;
    }
    croak 'gave up, failed to run docker';
}

my $perl_version = $ARGV[0];
my $variant = $ARGV[1];

chdir "$FindBin::Bin/../dockerfiles/$perl_version/$variant" or die "failed to chdir: $!";

docker(
    "build",
    "--platform", "linux/amd64",
    "--load",
    "-t", "lambda-perl:$perl_version-$variant-x86_64",
    ".",
);

docker(
    "build",
    "--platform", "linux/arm64",
    "--load",
    "-t", "lambda-perl:$perl_version-$variant-arm64",
    ".",
);

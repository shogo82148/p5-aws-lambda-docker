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

my $repository = $ARGV[0];
my $perl_version = $ARGV[1];
my $variant = $ARGV[2];
my $tag = $ARGV[3];

docker(
    "tag",
    "lambda-perl:$perl_version-$variant-x86_64",
    "$repository:$tag-x86_64",
);

docker(
    "tag",
    "lambda-perl:$perl_version-$variant-arm64",
    "$repository:$tag-arm64",
);

my $ref = $ENV{GITHUB_REF} || '';
if ($ref !~ m(^refs/tags/[^/]+/(.*))) {
    say STDERR "skip, '$ref' is not a tag";
    exit 0;
}
my $version = $1;

# push the images for all architectures
docker(
    "push",
    "$repository:$tag-x86_64",
);
docker(
    "push",
    "$repository:$tag-arm64",
);

# create and push the manifest
docker(
    "manifest",
    "create",
    "$repository:$tag",
    "$repository:$tag-x86_64",
    "$repository:$tag-arm64",
);
docker(
    "manifest",
    "push",
    "$repository:$tag",
);

# create and push the images for the version
docker(
    "tag",
    "lambda-perl:$perl_version-$variant-x86_64",
    "$repository:$tag-$version-x86_64",
);
docker(
    "push",
    "$repository:$tag-$version-x86_64",
);

docker(
    "tag",
    "lambda-perl:$perl_version-$variant-arm64",
    "$repository:$tag-$version-arm64",
);
docker(
    "push",
    "$repository:$tag-$version-arm64",
);

# create and push the manifest for the version
docker(
    "manifest",
    "create",
    "$repository:$tag-$version",
    "$repository:$tag-$version-x86_64",
    "$repository:$tag-$version-arm64",
);
docker(
    "manifest",
    "push",
    "$repository:$tag-$version",
);

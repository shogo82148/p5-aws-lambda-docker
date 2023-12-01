#!/usr/bin/env perl

use 5.38.0;
use warnings;
use utf8;
use FindBin;
use Carp qw/croak/;
use JSON::PP;
use Time::Piece;

my $force = $ARGV[0] && $ARGV[0] eq "--force";

sub new_tag($version, $variant) {
    my $utc_time = Time::Piece->new()->gmtime();
    my $tag = sprintf("%s-%s/%04d.%02d.%02d", $version, $variant, $utc_time->year, $utc_time->mon, $utc_time->mday);
    say "New tag: $tag";
    if ($force) {
        system("git", "tag", $tag);
        system("git", "push", "origin", $tag);
    }
}

chdir "$FindBin::Bin/../dockerfiles" or die "failed to chdir: $!";
my $versions = [glob "*"];

for my $version(@$versions) {
    say "Checking $version";
    chdir "$FindBin::Bin/../dockerfiles/$version" or die "failed to chdir: $!";
    for my $variant(glob "*") {
        my $latest = `git tag --sort -v:refname --list '$version-$variant/*' | head -n 1`;
        chomp $latest;
        unless ($latest) {
            new_tag($version, $variant);
            next;
        }

        my $context = "$variant";
        my $exit_code = system("git", "diff", "--exit-code", "--quiet", $latest, "HEAD", "--", $context);
        if ($exit_code != 0) {
            new_tag($version, $variant);
            next;
        }
    }
}

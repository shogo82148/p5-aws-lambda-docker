#!/usr/bin/env perl

use 5.38.0;
use warnings;
use utf8;
use FindBin;
use Carp qw/croak/;
use File::Basename;
use JSON::PP qw/decode_json/;

my $version = $ARGV[0];
my $runtime = $ARGV[1];

sub slurp($file) {
    local $/;
    open my $fh, "<", $file or die "Can't open $file: $!";
    my $content = <$fh>;
    close $fh;
    return $content;
}

sub spew($file, $content) {
    open my $fh, ">", "$file.tmp$$" or die "failed to open $file: $!";
    print $fh $content;
    close $fh or die "failed to close $file: $!";
    rename "$file.tmp$$", $file or die "failed to rename $file.tmp$$ to $file: $!";
}

sub generate($version, $variant, $tag) {
    my $workflow = slurp("$FindBin::Bin/../templates/workflow.yml");
    $workflow =~ s/__PERL_VERSION__/$version/g;
    $workflow =~ s/__VARIANT__/$variant/g;
    $workflow =~ s/__TAG__/$tag/g;
    system("mkdir", "-p", "$FindBin::Bin/../.github/workflows");
    spew("$FindBin::Bin/../.github/workflows/$version-$variant.yml", $workflow);
}

generate($version, "run.$runtime", "$version.$runtime");
generate($version, "run-paws.$runtime", "$version-paws.$runtime");

#!/usr/bin/env perl

use v5.40;
use warnings;
use utf8;
use FindBin;
use Carp qw/croak/;
use File::Basename;
use JSON::PP qw/decode_json/;

my $version = $ARGV[0];
my $runtime = $ARGV[1];
unless ($version || $runtime) {
    die "usage: $0 <version> <runtime>";
}

my $version_hyphen = $version =~ s/[.]/-/r;

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

my $variables = {};

# get the latest version of the runtime
for my $arch (qw/x86_64 arm64/) {
    my $metadata = decode_json(`curl -sSL https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-$version_hyphen-runtime-$runtime-$arch.json`);
    $variables->{uc "__PERL_${runtime}_${arch}_URL__"} = $metadata->{url};
}

# get the latest version of the paws layer
for my $arch (qw/x86_64 arm64/) {
    my $metadata = decode_json(`curl -sSL https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-$version_hyphen-paws-$runtime-$arch.json`);
    $variables->{uc "__PAWS_${runtime}_${arch}_URL__"} = $metadata->{url};
}

# get the latest version of base image
for my $provided(qw/provided.al2 provided.al2023/) {
    for my $variant(qw/run build/) {
        my $version = `gh api --jq '[.[].ref] | sort | last' /repos/shogo82148/docker-lambda/git/matching-refs/tags/$provided-$variant/ | cut -d/ -f4`;
        chomp $version;
        if ($version !~ /^[0-9.]+$/) {
            die "failed to get the metadata of docker-lambda";
        }
        $variables->{uc "__DOCKER_LAMBDA_${provided}_${variant}__"} = $version;
    }
}

$ENV{AWS_SDK_LOAD_CONFIG} = 1;
chomp($variables->{__BASE_AL2__} = `docker-tags public.ecr.aws/lambda/provided | grep -E '^al2[.][.0-9]+\$' | sort | tail -n 1`);
chomp($variables->{__BASE_AL2023__} = `docker-tags public.ecr.aws/lambda/provided | grep -E '^al2023[.][.0-9]+\$' | sort | tail -n 1`);

say STDERR "$_ => $variables->{$_}" for sort keys %$variables;

for my $template (<$FindBin::Bin/../templates/$runtime/*>) {
    my $dir = basename($template);
    my $content = slurp("$template/Dockerfile");
    for my $key (keys %$variables) {
        $content =~ s/$key/$variables->{$key}/g;
    }

    system("mkdir", "-p", "$FindBin::Bin/../dockerfiles/$version/$dir");
    spew("$FindBin::Bin/../dockerfiles/$version/$dir/Dockerfile", $content);
}

#!/usr/bin/env perl5.10
# Hello. I compare units of code across languages for a given problem number
use 5.010;
use strict;
use warnings;
use Data::Dumper;
use Benchmark qw/:all/;
use File::Spec::Functions;

my %interp = (
    parrot => $ENV{PARROT} || catfile( $ENV{HOME},qw{git parrot parrot}),
    perl5  => 'perl5.10',
    # we should change perl6 to rakudo
    perl6  => $ENV{PERL6} || catfile( $ENV{HOME},qw{git rakudo perl6}),
);
my @languages = qw/ parrot perl5 perl6 /;

my ($euler_problem,$count) = @ARGV;
$euler_problem ||= '001';
$count ||= 100;

my @codez;
for my $language (@languages) {
     push @codez, grep { $_ } glob(catdir($language,$euler_problem,'*'));
}
#warn Dumper [ @codez ];

my %bench_data = map {
    my $file = $_;
    my $lang;
    if ($file =~ m/^([a-z0-9]+)/i ) {
        $lang = $1;
    }
    die "Unknown language $lang" unless $interp{$lang};

    $file => sub { system("$interp{$lang} $file &>/dev/null") },
} @codez;

#warn Dumper [ %bench_data ];
say "Benchmarking EP#$euler_problem with $count iterations";
cmpthese($count, \%bench_data);


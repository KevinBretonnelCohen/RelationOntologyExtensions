#!/usr/bin/perl

# purpose: implement Geoff Barnbrook's approach to finding frequently-occurring strings phreasemnt

# test cases in barnbrook.test01.txt:
# single-word term
# two-word term
# long term

use strict 'vars';


my %strings; # where you store the strings

# OBO files
#my $infile = "/Users/kev/Dropbox/A-M/Corpora/gene_ontology.obo.filtered";
#my $infile = "go.obo.no.brackets.no.parentheses.txt";
my $infile = "/Users/transfer/Documents/scripts/go.obo.no.brackets.no.parentheses.txt";
#my $infile = "/Users/kev/Dropbox/A-M/Corpora/bfo.obo";
#my $infile = "/Users/kev/Dropbox/A-M/Corpora/behavior.obo";
#my $infile = "/Users/kev/Dropbox/A-M/Corpora/2017MeshTree.txt";
my $mesh = undef; # set to 1 if you're processing MeSH, as the format is different from the

open (IN, $infile) || die "Couldn't open infile.\n";

my $total_number_of_terms = 0; # note that this is the total number of terms after a prior filtering step
# to remove ones that contain characters like [ and ( that will break the perl regular expressions

while (my $line = <IN>) {
    # there's a bunch of short-circuit logic in this script to control debugging output
    # ---this is what that short-circuit logic looks like
    0 && print $line;
    #$line !~ /^name: / && next;
    0 && print $line;
    chomp $line;
    
    # special handling for MeSH terms
    if ($mesh) {
        #$line =~ /^[^\s]+\s+[^\S]+\s+(.+)/o;
        $line =~ /^[\S]+\s+[^\s]+(.+)/o;
        $line = $1;
        0 && print $line;
    } # handle MeSH
    
    # main work happens here
    my $edge_string = extractLeft($line);
    0 && print $edge_string . "\n";
    #push @{$strings{$edge_string}}, $line;
    $strings{$edge_string}++;
    $total_number_of_terms++; 
} # close while-loop through file

# for getting the distribution of numbers of examples
my %distribution_of_occurrences;

# now sort by frequency and produce the output
open (OUT, '>', "barnbrook.go.strings.ordered.by.count.txt") || die "Couldn't open output file for counts: $!\n";
my @strings_by_frequency = sort { $strings{$b} <=> $strings{$a} } keys(%strings);
for (my $i = 0; $i < @strings_by_frequency; $i++) {
    #my $number_of_examples = @{strings{$strings_by_frequency[$i]}};
    my $number_of_examples = $strings{$strings_by_frequency[$i]};
    $distribution_of_occurrences{$number_of_examples}++;
    my $normalized_frequency = $number_of_examples / $total_number_of_terms;
    print OUT $strings_by_frequency[$i] . "," . $normalized_frequency . "," . $number_of_examples . "\n";
} # close for-loop through strings ordered by frequency

# ...and the distribution of numbers of examples
# this actually doesn't sort correctly 'cause it's alphabetical, but I'll straighten
# that out in R
# for capturing the number of examples
open (DISTRIBUTION, '>', "/Users/transfer/Documents/scripts/barnbrook.go.number.of.examples.txt") || die "Couldn't open outfile: $!\n";

my @distribution = sort { $a <=> $b } keys(%distribution_of_occurrences);
for (my $i = 0; $i < @distribution; $i++) {
    print DISTRIBUTION $distribution[$i] . "," . $distribution_of_occurrences{$distribution[$i]} . "\n"; 
}
# takes a term as its input and returns the leftmost token
sub extractLeft() {

    my ($input) = @_;
    unless ($input) { die "No input to the extractLeft() function--quitting.\n";}
    0 && print $input;
    my @tokens = split(' ', $input);
    0 && print $tokens[1]; # 1 versus zero because the first word is "name:"
    return $tokens[1];
}

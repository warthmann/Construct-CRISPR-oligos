#!/usr/bin/env perl
#given desired sgRNA sequences, the script will return the required oligos
#provide the sgRNA sequences (without PAM) and a unique name in a tab delimited text file <INPUT_FILE>. Don't include the PAM sequence. The script will check for sequence length of 20 bp and exit with ERROR if different. DNA only, but should be robust to all IUPAC code. The script will return a list of comma-separated entries. Primer sequences matching the template plasmid are returned in upper case, 5'-overhangs in lower case.

#INPUT file example line:
#sgRNA Name<tab>sgRNA sequence

#usage: perl Construct-greengate-CRISPR-oligos.pl <INPUT_FILE>
# by Norman Warthmann, August 1st, 2022

use strict;

# Read commandline parameters
my $input_filename = $ARGV[0];

# Open input file
open( INPUT_FILE, "$input_filename" )
	or die "Couldn't open input file $input_filename $!\n";


# Parse file
while( <INPUT_FILE> ){
	chomp;
	my ($sgRNA_name, $sgRNA_seq) = split(/\t/, $_);
  #check for length of input $sgRNA_seq and exit if different from 20 bp
	die "\n**ERROR: the sgRNA sequence of $sgRNA_name is not 20 bp long! (did you strip the PAM?)\n\n"  unless (length($sgRNA_seq) == 20); #20
  #extract the necessary substrings
	my $first_12 = substr($sgRNA_seq, 0, 12);
	my $last_12 = substr($sgRNA_seq, -12);
  # reverse complement DNA (2 steps: reverse and then complement)
	my $reverse_first_12 = reverse($first_12);
	$reverse_first_12 =~ tr/ACTGactgMRVHmrvhKYBDkybd/TGACtgacKYBDkybdMRVHmrvh/;

#concatenate to desired overhangs and print to STDout (comma separated), for easier checking, dash-separated components can be returned (#)
	print "\n". $sgRNA_name ."\n";
#	print $sgRNA_name ."-gRNA1-R," . lc("cgGGTCTCg") ."-". lc($reverse_first_12) . "-" .  uc("TGCACCAGCCGGGAATCGAACCC") . "\n";
	print $sgRNA_name ."-gRNA1-R," . lc("cgGGTCTCg") . lc($reverse_first_12) . uc("TGCACCAGCCGGGAATCGAACCC") . "\n";

#	print $sgRNA_name ."-gRNA1-F," . lc("cgGGTCTCg") ."-". lc($last_12) . "-" .  uc("GTTTTAGAGCTAGAAATAGCA") . "\n";
	print $sgRNA_name ."-gRNA1-F," . lc("cgGGTCTCg") . lc($last_12) .  uc("GTTTTAGAGCTAGAAATAGCA") . "\n";

#	print $sgRNA_name ."-In-Vitro-FWD-primer_(A)," . lc("GCGGCCTCTAATACGACTCACTATAGG") ."-". lc($sgRNA_seq) . "-" .  uc("GTTTTAGAGCTAGAAA") . "\n\n";
	print $sgRNA_name ."-In-Vitro-FWD-primer_(A)," . lc("GCGGCCTCTAATACGACTCACTATAGG") . lc($sgRNA_seq) . uc("GTTTTAGAGCTAGAAA") . "\n\n";
}

##PSEUDO-CODE
# Design for in-vitro test:
#Primer A (FWD):
#5´-GCGGCCTCTAATACGACTCACTATAGG-NNNNNNNNNNNNNNNNNNNN-GTTTTAGAGCTAGAAA -3´

#step-by-step design for cloning oligos
#Let this be the guide RNA suggested by a prediction software:
#GGAGTGACTGATCTTCA’GCC-PAM
#Primer Design:
#1)	take the first 12 bp of your desired gRNA sequence (counting from the left) #and reverse complement GGAGTGACTGAT -> atcagtcactcc
#2)	integrate this sequence into primer gRNA1-R:
#cgGGTCTCg ATCAGTCACTCC TGCACCAGCCGGGAATCGAACCC
#3)	take the last 12 bp of your desired gRNA sequence (counting from right, not #including the PAM!) TGATCTTCAGCC
#4)	integrate this sequence as is into primer gRNA1-F:
#cgGGTCTCg TGATCTTCAGCC GTTTTAGAGCTAGAAATAGCA

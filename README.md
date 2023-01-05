# Design-CRISPR-oligos
Scripts for CRISPR GreenGate Cloning


Given desired sgRNA sequences, the script will return the required oligos for GreenGate Cloning.

Provide the sgRNA sequences (without PAM) and a unique name in a tab delimited text file <INPUT_FILE>. 
Don't include the PAM sequence. The script will check for sequence length of 20 bp and exit with ERROR if different. 
DNA only, but should be robust to all IUPAC code. 

The script will return a list of comma-separated entries. Primer sequences matching the template plasmid are returned in upper case, 5'-overhangs in lower case.

INPUT file example line:
sgRNA Name \<tab\> sgRNA sequence

#usage: perl Design-CRISPR-oligos.pl <INPUT_FILE>


by Norman Warthmann, 1.8.2022


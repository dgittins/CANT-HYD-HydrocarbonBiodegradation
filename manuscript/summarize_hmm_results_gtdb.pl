#!/usr/bin/perl 

#this script summarizes all individual GTDB HMM results from gtdb_hmmsearch_for_loop_bash.sh into one table containing accessions, scores, and e-values

use strict;

#USAGE: $0 <folder_with_tables>
my $Dir = $ARGV[0];
opendir(DIR,$Dir) or die "Can't open the folder";
my @files = readdir(DIR);
print "GTDB_Acc\tHMM\tEvalue\tScore\tAccession\n";
foreach my $f (@files){
	my $genome = $f;
	$genome =~ s/\.tbl//;
	open(FH,"./$Dir/$f") or die "Can't open the file: $f";
	while(my $line = <FH>){
		if($line =~/^#/){	}
		else{
			$line =~ tr/ +/ /s;
			my @data = split(/ /,$line);
			print "$genome\t$data[2]\t$data[7]\t$data[8]\t$data[0]\n";
		}
	}
}

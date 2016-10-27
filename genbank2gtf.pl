#!/usr/bin/perl

########################################
# Convert genbank to gtf.
#
# USAGE:
# cat <Genbank File> | genbank2gtf.pl > file.gtf
#
# AUTHOR:
# Benjamin King, PhD.
# bking@mdibl.org
#######################################

# Manual input of Genome ID below.

$GenomeID = "gi|358331475|gb|EU203571.2|";

while (<STDIN>) {

    $line = $_;
# 	Set each new line in stream to default variable.
    chomp($line);
# 	Remove the new line string from $line

    if ($line =~ /gene\s+([a-z]*)\(*(\d+)\.\.(\d+)\)*/) {
#	Regex Translation:
#	/gene - matches the characters 'gene' literally
#	\s+ - matches any whitespace character, + means catch between one and an unlimited number f times, ignore 
#	([a-z]*) - first capture group - capture any lowercase characters between 0 and an unlimited number of times, return (either '' or 'complement')
#	\(* - matches the '(' character, ignore
#	(\d+) - second capture group - matches a digit between 0 - 9 between one and an unlimited number of times, return (start region)
#	\.\. - matches '..' literally, ignore
#	(\d+) - third capture group - matches a digit between 0 - 9 between one and an unlimited number of times, return (end region)
#	/)* matches ')' character, ignore
	$complement = $1;
#	variable 'complement' = first capture group
	$start = $2;
#	variable 'start' = second capture group
	$end = $3;
#	variable 'end' = third capture group
    }

    elsif ($line =~ /\/locus_tag=\"(\w+)\"/) {
#	Regex Translation:
#	\/locus_tag= - matches the string /locus_tag= literally 
#	\" - matches the character "
#	(\w+) - first capture group - matches any word character (equal to regex [a-zA-Z0-9_]) between one and an unlimited number of times.
#	\" - matches the character " 
	$symbol = $1;
#	variable 'symbol' = first capture group

	if ($complement eq "complement") {
	    print $GenomeID,"\tena\texon\t",$start,"\t",$end,"\t.\t-\t.\ttranscript_id \"transcript:",$symbol,"\"\; gene_id \"gene:",$symbol,"\"\; gene_name \"",$symbol,"\"\n";
	    print $GenomeID,"\tena\tCDS\t",$start,"\t",$end,"\t.\t-\t0\ttranscript_id \"transcript:",$symbol,"\"\; gene_id \"gene:",$symbol,"\"\; gene_name \"",$symbol,"\"\n";
#	    print "Chromosome      ena     exon    ",$start,"     ",$end,"    .       -       .       transcript_id \"transcript:",$symbol,"\"\; gene_id \"gene:",$symbol,"\"\; gene_name \"",$symbol,"\"\n";
#	    print "Chromosome      ena     CDS    ",$start,"     ",$end,"    .       -       0       transcript_id \"transcript:",$symbol,"\"\; gene_id \"gene:",$symbol,"\"\; gene_name \"",$symbol,"\"\n";
	}
	else {
	    print $GenomeID,"\tena\texon\t",$start,"\t",$end,"\t.\t+\t.\ttranscript_id \"transcript:",$symbol,"\"\; gene_id \"gene:",$symbol,"\"\; gene_name \"",$symbol,"\"\n";
	    print $GenomeID,"\tena\tCDS\t",$start,"\t",$end,"\t.\t+\t0\ttranscript_id \"transcript:",$symbol,"\"\; gene_id \"gene:",$symbol,"\"\; gene_name \"",$symbol,"\"\n";
#	    print "Chromosome      ena     exon    ",$start,"     ",$end,"    .       +       .       transcript_id \"transcript:",$symbol,"\"\; gene_id \"gene:",$symbol,"\"\; gene_name \"",$symbol,"\"\n";
#	    print "Chromosome      ena     CDS    ",$start,"     ",$end,"    .       +       0       transcript_id \"transcript:",$symbol,"\"\; gene_id \"gene:",$symbol,"\"\; gene_name \"",$symbol,"\"\n";
	}

    }
}

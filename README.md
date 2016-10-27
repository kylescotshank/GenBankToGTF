# Converting a Genbank file to a GTF file.

***

### Still to do:
  * Convert `.pl` to `.py` for `Python` version
  * Convert `.pl` to `.r` for `R` version

***

More often than not, one will encounter a problem during implementation of a bioinformatics workflow where you'll need to perform some kind of file conversion in order to move forward. Though there are many different software solutions available that can perform the task, it is useful to be able to perform such conversions yourself at the command line to mitigate costs and have more control over your output. For this tutorial, we will convert a [GenBank](https://www.ncbi.nlm.nih.gov/Sitemap/samplerecord.html) file to a [GTF](http://useast.ensembl.org/info/website/upload/gff.html). Specifically, we're going to convert the [GenBank](https://www.ncbi.nlm.nih.gov/nuccore/KT373978.1) file for the Mycobacterium phage _Ukelele_ to a GTF file.

**Note**: Per [this release](https://www.ncbi.nlm.nih.gov/news/10-17-2016-gi-numbers-removed/) from the NCBI, output of GenBank files does not, by default, contain GenInfo ("GI") numbers. You have to manually set this option upon export. **If you do not do this, the following script will not work**. 

***

### Why do we need to do this?

Good question! A raw GenBank file looks like this:

```
LOCUS       KT373978               75114 bp    DNA     linear   PHG 23-AUG-2015
DEFINITION  Mycobacterium phage Ukulele, complete genome.
ACCESSION   KT373978
VERSION     KT373978.1
KEYWORDS    .
SOURCE      Mycobacterium phage Ukulele
  ORGANISM  Mycobacterium phage Ukulele
            Viruses; dsDNA viruses, no RNA stage; Caudovirales; Siphoviridae.
REFERENCE   1  (bases 1 to 75114)
  AUTHORS   Beacham,G.M., Harris,K.B., Bard,E., Botieri,M., Hashmi,H.N.,
            Kwok,S.F., LaFollette,M., Sheltra,M.R., Wood,S., Hutchison,K.W.,
            Molly,S.D., Ball,S.L., Bradley,K.W., Asai,D.J., Bowman,C.A.,
            Russell,D.A., Pope,W.H., Jacobs-Sera,D., Hendrix,R.W. and
            Hatfull,G.F.
  TITLE     Direct Submission
  JOURNAL   Submitted (06-AUG-2015) Center for Life Sciences Education, The
            Ohio State University, 1735 Neil Ave, Columbus, OH 43210, USA
COMMENT     Phage Isolation, DNA preparation, annotation analysis was performed
            at University of Maine, Honors College, Orono, ME
            Sequencing by  Ion torrent to approximately 133x coverage was
            performed at Pittsburgh Bacteriophage Institute
            Assembly performed with Newbler and Consed software as of Jan,
            2012.
            Supported by Science Education Alliance, Howard Hughes Medical
            Institute, Chevy Chase, MD.
            
            ##Assembly-Data-START##
            Assembly Method       :: Newbler and Consed v. Jan-2012
            Coverage              :: 133x
            Sequencing Technology :: Ion Torrent
            ##Assembly-Data-END##
FEATURES             Location/Qualifiers
     source          1..75114
                     /organism="Mycobacterium phage Ukulele"
                     /mol_type="genomic DNA"
                     /isolation_source="soil"
                     /db_xref="taxon:1701847"
                     /lab_host="Mycobacterium smegmatis mc2 155"
                     /country="USA: Old Orchard Beach, ME"
                     /lat_lon="43.5177650 N 70.37728881835938 W"
                     /collection_date="01-Aug-2011"
                     /collected_by="Maryanne LaFollette and Matthew Sheltra"
                     /identified_by="Maryanne LaFollette and Matthew Sheltra"
     gene            267..560
                     /locus_tag="SEA_UKULELE_1"
     CDS             267..560
                     /locus_tag="SEA_UKULELE_1"
                     /codon_start=1
                     /transl_table=11
                     /product="hypothetical protein"
                     /protein_id="ALA06233.1"
                     /translation="MSALTPGTVITDPRKHGLPDFCEGCTVMGAIREDEPAVKTWGKG
                     TGTVSWPVDDEDLRWASSLGELVAKRLAEMLGVKLDPAIFRGRESLNDGHKLQ"
```

This file contains an immense amount of information. However, for certain applications (such as, say, gene annotation), we need to deliver a subset of this information in a particular form to another piece of software. If that software needs a GTF file, for example, then it must be in this particular format:

```
gi|918360239|gb|KT373978.1|	ena	exon	267	560	.	+	.	transcript_id "transcript:SEA_UKULELE_1"; gene_id "gene:SEA_UKULELE_1"; gene_name "SEA_UKULELE_1"
gi|918360239|gb|KT373978.1|	ena	CDS	267	560	.	+	0	transcript_id "transcript:SEA_UKULELE_1"; gene_id "gene:SEA_UKULELE_1"; gene_name "SEA_UKULELE_1"
gi|918360239|gb|KT373978.1|	ena	exon	267	560	.	+	.	transcript_id "transcript:SEA_UKULELE_1"; gene_id "gene:SEA_UKULELE_1"; gene_name "SEA_UKULELE_1"
gi|918360239|gb|KT373978.1|	ena	CDS	267	560	.	+	0	transcript_id "transcript:SEA_UKULELE_1"; gene_id "gene:SEA_UKULELE_1"; gene_name "SEA_UKULELE_1"
```

Thus, we'll need to parse our GenBank file and do a little text manipulation. To accomplish this, we'll turn to our friend `Perl`.

***

### Why `Perl`?

Good question!

  * `Perl` has history and inertia. There was a major expansion in bioinformatics training and practice at the turn of the century to meet the needs of the Human Genome Project. At that time, `Perl` was by far the most popular scripting language in general use - especially amongst the computer scientists involved in the HGP.
  * `Perl` has the native ability to parse strings and regular expressions, which means you can use low-level code to perform your tasks (i.e., no need to download packages or libraries). 
  * There are _many_ scripts and tools that are widely used in bioinformatics that are written in `Perl`. 

As time permits, we'll also load `Python` and `R` scripts that accomplish the same task so that you'll be able to perform this task in your language of choice. 

***

### The `perl` script

Our unannotated script is below! Note that the actual `.pl` file contains a copious amount of comments. 

```perl
while (<STDIN>) {


    $line = $_;
    chomp($line);

	if ($line =~/VERSION\s+(\w+.\d+)\s+(\w+.)(\d+)/) {
	$GenBank = $1;
	$GenInfo = $3;
	}

    if ($line =~ /gene\s+([a-z]*)\(*(\d+)\.\.(\d+)\)*/) {
	$complement = $1;
	$start = $2;
	$end = $3;
    }

    elsif ($line =~ /\/locus_tag=\"(\w+)\"/) {
	$symbol = $1;

	if ($complement eq "complement") {
	    print "gi|",$GenInfo,"|gb|",$GenBank,"|","\tena\texon\t",$start,"\t",$end,"\t.\t-\t.\ttranscript_id \"transcript:",$symbol,"\"\; gene_id \"gene:",$symbol,"\"\; gene_name \"",$symbol,"\"\n";
	    print "gi|",$GenInfo,"|gb|",$GenBank,"|","\tena\tCDS\t",$start,"\t",$end,"\t.\t-\t0\ttranscript_id \"transcript:",$symbol,"\"\; gene_id \"gene:",$symbol,"\"\; gene_name \"",$symbol,"\"\n";
	}
	else {
	    print "gi|",$GenInfo,"|gb|",$GenBank,"|","\tena\texon\t",$start,"\t",$end,"\t.\t+\t.\ttranscript_id \"transcript:",$symbol,"\"\; gene_id \"gene:",$symbol,"\"\; gene_name \"",$symbol,"\"\n";
	    print "gi|",$GenInfo,"|gb|",$GenBank,"|","\tena\tCDS\t",$start,"\t",$end,"\t.\t+\t0\ttranscript_id \"transcript:",$symbol,"\"\; gene_id \"gene:",$symbol,"\"\; gene_name \"",$symbol,"\"\n";
	}

    }
}
```

Let's break what the script is doing down into some psuedocode:

```
While I'm receiving standard input:
	
		Ignore the line-terminator 

		If you find (via regular expression matching) the info that gives me the GenInfo and GenBank data that I want, grab it:
			Save info to variable genbank
			Save info to variable geninfo

		If you find (via regular expression matching) the info that gives me the gene information that I want, grab it:
			Save info to variable complement
			Save info to variable start
			Save info to variable end

		If you find (via regular expression matching) the info that gives me the locus information that I want, grab it:
			Save info to variable symbol

		If the variable complement isn't empty:
			Print two new lines that contain information in the order that I want it

		If the variable complement is empty:
			Print two new lines that contain information in the order that I want it.
END
```
***

### Using the script

At the terminal, use the following command:

```bash
cat <GenBankFile.txt> | perl genbank2gtf.pl > <GTFOutput.gtf> 
```

Using the `ukelele_phage_genbank.txt` file:

```bash
cat ukelele_phage_genbank.txt | perl genbank2gtf.pl > uekelele_phage.gtf
```










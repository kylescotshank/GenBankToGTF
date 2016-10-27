# Converting a Genbank file to a GTF file.

***

### Still to do:
  * Convert .pl to .py for Python version
  * Convert .pl to .r for R version

***

More often than not, one will encounter a problem during implementation of a bioinformatics workflow where you'll need to perform some file conversions in order to use a particular set of tools. Though there are certainly software solutions available that can perform the task, it is useful to be able to perform such conversions yourself at the command line. For this tutorial, we will convert a [GenBank](https://www.ncbi.nlm.nih.gov/Sitemap/samplerecord.html) file to a [GTF](http://useast.ensembl.org/info/website/upload/gff.html) file using Perl (with equivalent scripts in other languages to follow).

### Why Perl?

  * Perl has history and inertia. There was a major expansion in bioinformatics training and practice at the turn of the century because of the Human Genome Project. At that time, Perl was by far the most popular scripting language in general use. 
  * Perl has the native ability to parse strings and regular expressions, which means you can use low-level code to perform your tasks (i.e., no need to download packages or libraries). 
  * There are _many_ scripts and tools that are widely used in bioinformatics that are written in Perl. 

***

For this example, we are going to convert the [GenBank](https://www.ncbi.nlm.nih.gov/nuccore/KT373978.1) file for the Mycobacterium phage _Ukelele_ to a GTF file. The raw GenBank file looks like this:

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

This file contains an immense amount of information, far more than we need for our purposes. What we want in the end is something that looks like this:

```
SomeGenomeID	ena	exon	start	end	.	+	.	transcript_id "transcript:###; gene_id "gene:### gene_name "###"
SomeGenomeID	ena	exon	start	end	.	+	.	transcript_id "transcript:###; gene_id "gene:### gene_name "###"
SomeGenomeID	ena	exon	start	end	.	+	.	transcript_id "transcript:###; gene_id "gene:### gene_name "###"
```

Thus, we'll need to parse it. To do so, we'll use a Perl script. 

***

Though we are going to provide the script below, it's important that one not only knows how to _use_ a script, but also understands _how_ the script performs its function. A useful pedagogical technique to do this is to first write what you want to achieve in [pseudocode](http://www.unf.edu/~broggio/cop2221/2221pseu.htm). Think of psuedocode as a set of easily interpreted directions, written in plain speech, that you can then convert into your programming language of choice. In this case, the "high-level" function of our code is as follows:

```
read in text file:
	extract just the key bits of information that we need
	store these bits in a useful fashion

print new lines that contain the stored information
```

With this in mind, we can thus build out our code:

***

First, we will set the only variable that need to: `#$GenomeID`:

```perl
$GenomeID = "gi|358331475|gb|EU203571.2|";
```







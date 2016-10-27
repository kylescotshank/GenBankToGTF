# Converting a Genbank file to a GTF file.

## To do:
  * Convert .pl to .py for Python version
  * Convert .pl to .r for R version

More often than not, one will encounter a problem during implementation of a bioinformatics workflow where you'll need to perform some file conversions in order to use a particular set of tools. Though there are certainly software solutions available that can perform the task, it is useful to be able to perform such conversions yourself at the command line. For this tutorial, we will convert a [GenBank](https://www.ncbi.nlm.nih.gov/Sitemap/samplerecord.html) file to a [GTF](http://useast.ensembl.org/info/website/upload/gff.html) file using Perl (with equivalent scripts in other languages to follow).

Why Perl?

  * Perl has history and inertia. There was a major expansion in bioinformatics training and practice at the turn of the century because of the Human Genome Project. At that time, Perl was by far the most popular scripting language in general use. 
  * Perl has the native ability to parse strings and regular expressions, which means you can use low-level code to perform your tasks (i.e., no need to download packages or libraries). 
  * There are _many_ scripts and tools that are widely used in bioinformatics that are written in Perl. 

  

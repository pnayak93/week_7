# week_7

for RNAseq, ATACseq, and DNAseq data, the aligning and sorting/indexing steps were done in separate scripts for testing purposes. The RNAseq alignment was performed utilizing parallelization on hpc3, and the ATACseq and DNAseq dataset alignment and sorting was performed without parallelization, just to see if i could do it using a looped single job with lots of cores. Both methods worked well with the parallelized job obviously being faster and more efficient.

For the RNAseq job, the RNAprefixlist.txt file was generated separately using the following commands, utilizing only a subset of the actual symlinks (a total of 96 fq.gz files, 48 pairs):


```
echo *_R1.fq.gz > RNAprefix.txt
for i in {1..48}; do cut -d " " -f $i RNAprefix.txt ; done > RNAprefix2.txt
cut -b 1-7 RNAprefix2.txt > RNAprefixlist.txt
```
for the ATACseq and DNAseq jobs, the prefixes were simply kept in an array and looped through for the alignment/sorting/indexing.

The ATACseq and DNAseq alignment jobs were designed to be left one directory above the fq.gz files, and the RNAseq job was designed to be left in the directory with the fq.gz symlinks.

The ATACseq and DNAseq align jobs `alignATAC.sh` and `alignDNA.sh` were created without parallelization and using `bwa mem`, and the RNAseq `alignRNA.sh` job was created WITH parallelization in slurm, and using the `hisat2` aligner. Additionally, the alignment and sorting steps were split into separate scripts for testing purposes, but they could easily be combined together into single scripts as well. The `samsortATAC.sh`, `samsortRNA.sh` and `samsortDNA.sh` scripts are the respective samtool sorting scripts and designed to be run on the data after the alignment has completed for each dataset.


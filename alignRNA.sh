#!/bin/bash
#SBATCH --job-name=RNAtest      ## Name of the job.
#SBATCH -A ecoevo283         ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --array=1-48         ## number of tasks to launch, given hint below wc -l $file is helpful
#SBATCH --cpus-per-task=2    ## number of cores the job needs, can the programs you run make used of multiple cores?

module load bwa/0.7.8
module load samtools/1.10
module load bcftools/1.10.2
module load java/1.8.0
module load picard-tools/1.87
module load hisat2

ref="/data/class/ecoevo283/pnayak/seq_symlinks/ref/dmel-all-chromosome-r6.13.fasta"
file="/data/class/ecoevo283/pnayak/seq_symlinks/RNAseq/subsamp/RNAprefixlist.txt"
dir="/data/class/ecoevo283/pnayak/seq_symlinks/RNAseq/subsamp/hibam"
prefix=`head -n $SLURM_ARRAY_TASK_ID $file | tail -n 1`

#bwa mem -t 2 -M $ref $prefix"_R1.fq.gz" $prefix"_R2.fq.gz" | samtools view -bS - > "./sbam/"aligned_$prefix".bam"
hisat2 -p 2 -x $ref -1 $prefix"_R1.fq.gz" -2 $prefix"_R2.fq.gz" -S $dir/"aligned_"$prefix".sam"


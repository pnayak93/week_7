#!/bin/bash
#SBATCH --job-name=RNAsort      ## Name of the job.
#SBATCH -A ecoevo283         ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --array=1-48         ## number of tasks to launch, given hint below wc -l $file is helpful
#SBATCH --cpus-per-task=2    ## number of cores the job needs, can the

module load bwa/0.7.8
module load samtools/1.10
module load bcftools/1.10.2
module load java/1.8.0
module load picard-tools/1.87


prefix=`head -n $SLURM_ARRAY_TASK_ID  ../RNAprefixlist.txt | tail -n 1`

samtools view -bS "aligned_"$prefix".sam" > "aligned_"$prefix".bam"
samtools sort "aligned_"$prefix".bam" -o "aligned_"$prefix".sort.bam"
samtools index "aligned_"$prefix".sort.bam"



#!/bin/bash
#SBATCH --job-name=ecoevo283-test-pnayak      ## Name of the job.
#SBATCH -A ecoevo283         ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --array=1         ## number of tasks to launch, given hint below wc -l $file is helpful
#SBATCH --cpus-per-task=12    ## number of cores the job needs, can the

module load bwa/0.7.8
module load samtools/1.10
module load bcftools/1.10.2
module load java/1.8.0
module load picard-tools/1.87


array=(A4_1 A4_2 A4_3 A5_1 A5_2 A5_3 A6_1 A6_2 A6_3 A7_1 A7_2 A7_3)

for j in ${!array[@]};
do
id=${array[j]}
idname=${id:0:2}
samtools sort alignedDNA_"${array[j]}".bam -o alignedDNA_"${array[j]}".sort.bam
java -jar  /opt/apps/picard-tools/1.87/AddOrReplaceReadGroups.jar I=alignedDNA_"${array[j]}".sort.bam O=alignedDNA_"${array[j]}".RG.bam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=$idname RGSM=$idname VALIDATION_STRINGENCY=LENIENT
samtools index alignedDNA_"${array[j]}".RG.bam
done

#!/bin/bash
#SBATCH --job-name=ecoevo283-test-pnayak      ## Name of the job.
#SBATCH -A ecoevo283         ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --array=1         ## number of tasks to launch, given hint below wc -l $file is helpful
#SBATCH --cpus-per-task=5    ## number of cores the job needs, can the



module load bwa/0.7.8
module load samtools/1.10
module load bcftools/1.10.2
module load java/1.8.0
module load picard-tools/1.87

DNAseq="./DNAseq/"
ref="./ref/dmel-all-chromosome-r6.13.fasta"
array=(A4_1_1 A4_2_1 A4_3_1 A5_1_1 A5_2_1 A5_3_1 A6_1_1 A6_2_1 A6_3_1 A7_1_1 A7_2_1 A7_3_1)
# A4_2_1 A4_3_1 A5_1_1 A5_2_1 A5_3_1 A6_1_1 A6_2_1 A6_3_1 A7_1_1 A7_2_1 A7_3_1

array2=(A4_1_2 A4_2_2 A4_3_2 A5_1_2 A5_2_2 A5_3_2 A6_1_2 A6_2_2 A6_3_3 A7_1_2 A7_2_2 A7_3_2)

array3=(A4_1 A4_2 A4_3 A5_1 A5_2 A5_3 A6_1 A6_2 A6_3 A7_1 A7_2 A7_3)
#A4_2_2 A4_3_2 A5_1_2 A5_2_2 A5_3_2 A6_1_2 A6_2_2 A6_3_3 A7_1_2 A7_2_2 A7_3_2



j=1
for i in "${!array[@]}"; do
prefix=`head -n $j prefixes.txt | tail -n 1`
idname=`echo $prefix | cut -d "/" -f 2 | cut -d "_" -f 1`
bwa mem -t 2 -M $ref $DNAseq"${array[i]}"".fq.gz" $DNAseq"${array2[i]}"".fq.gz" | samtools view -bS - > alignedtest_"$j".bam
#samtools sort alignedtest_"$j".bam -o alignedtest_"$j".sort.bam
#java -jar  /opt/apps/picard-tools/1.87/AddOrReplaceReadGroups.jar I=alignedtest_"$j".sort.bam O=alignedtest_"$j".RG.bam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=$idname RGSM=$idname VALIDATION_STRINGENCY=LENIENT
#samtools index alignedtest_"$j".RG.bam
((j=j+1))
done


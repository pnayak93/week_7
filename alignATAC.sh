#!/bin/bash
#SBATCH --job-name=ATACalign      ## Name of the job.
#SBATCH -A ecoevo283         ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --array=1         ## number of tasks to launch, given hint below wc -l $file is helpful
#SBATCH --cpus-per-task=16    ## number of cores the job needs, can the



module load bwa/0.7.8
module load samtools/1.10
module load bcftools/1.10.2
module load java/1.8.0
module load picard-tools/1.87

ATACseq="./ATACseq/"
ATACbam="./ATACseq/bam/"

ref="./ref/dmel-all-chromosome-r6.13.fasta"
array=(A4_ED_2 A4_ED_3 A4_ED_4 A4_WD_1 A4_WD_2 A4_WD_4 A5_ED_1 A5_ED_2 A5_ED_3 A5_WD_1 A5_WD_2 A5_WD_3 A6_ED_1 A6_ED_2 A6_ED_3 A6_WD_1 A6_WD_2 A6_WD_3 A7_ED_1 A7_ED_2 A7_ED_3 A7_WD_1 A7_WD_2 A7_WD_3)






j=1
for i in "${!array[@]}"; do
prefix=`head -n $j prefixes.txt | tail -n 1`
idname=`echo $prefix | cut -d "/" -f 2 | cut -d "_" -f 1`
bwa mem -t 8 -M $ref $ATACseq"${array[i]}""_R1.fq.gz" $ATACseq"${array[i]}""_R2.fq.gz" | samtools view -bS - > $ATACbam"ATACalign_""${array[i]}".bam
#samtools sort alignedtest_"$j".bam -o alignedtest_"$j".sort.bam
#java -jar  /opt/apps/picard-tools/1.87/AddOrReplaceReadGroups.jar I=alignedtest_"$j".sort.bam O=alignedtest_"$j".RG.bam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=$idname RGSM=$idname VALIDATION_STRINGENCY=LENIENT
#samtools index alignedtest_"$j".RG.bam
((j=j+1))
done


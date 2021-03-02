#!/bin/bash
#SBATCH --job-name=ATACsort      ## Name of the job.
#SBATCH -A ecoevo283         ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --array=1         ## number of tasks to launch, given hint below wc -l $file is helpful
#SBATCH --cpus-per-task=16    ## number of cores the job needs, can the

module load bwa/0.7.8
module load samtools/1.10
module load bcftools/1.10.2
module load java/1.8.0
module load picard-tools/1.87


#array=(A4_ED_2 A4_ED_3 A4_ED_4 A4_WD_1 A4_WD_2 A4_WD_4 A5_ED_1 A5_ED_2 A5_ED_3 A5_WD_1 A5_WD_2 A5_WD_3 A6_ED_1 A6_ED_2 A6_ED_3 A6_WD_1 A6_WD_2 A6_WD_3 A7_WD_1 A7_WD_2 A7_WD_3)

array=(A4_ED_2 A4_ED_3 A4_ED_4 A4_WD_1 A4_WD_2 A4_WD_4 A5_ED_1 A5_ED_2 A5_ED_3 A5_WD_1 A5_WD_2 A5_WD_3 A6_ED_1 A6_ED_2 A6_ED_3 A6_WD_1 A6_WD_2 A6_WD_3 A7_ED_1 A7_ED_2 A7_ED_3 A7_WD_1 A7_WD_2 A7_WD_3)



for j in "${!array[@]}"; do
id=${array[j]}
idname=${id:0:5}
samtools sort "ATACalign_""${array[j]}".bam -o "ATACalign_""${array[j]}"".sort.bam"
java -jar  /opt/apps/picard-tools/1.87/AddOrReplaceReadGroups.jar I="ATACalign_""${array[j]}"".sort.bam" O="ATACalign_""${array[j]}"".RG.bam" SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID="$idname" RGSM="$idname" VALIDATION_STRINGENCY=LENIENT
samtools index "ATACalign_""${array[j]}"".RG.bam"
done

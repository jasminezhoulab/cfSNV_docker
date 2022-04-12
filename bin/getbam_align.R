#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(cfSNV)

fastq1 = args[1]
fastq2 = args[2]
reference = args[3]
SNP.database = args[4]
sample.id = args[5] 
output.dir = args[6]

samtools.dir <- '/usr/local/bin/samtools'
picard.dir <- '/usr/local/bin/picard.jar'
bedtools.dir <- '/usr/local/bin/bedtools'
GATK.dir <- '/usr/local/bin/GenomeAnalysisTK.jar'	
bwa.dir <- '/usr/local/bin/bwa'

start <- Sys.time()
getbam_align(fastq1, fastq2, reference, SNP.database, samtools.dir, picard.dir, bedtools.dir, GATK.dir, bwa.dir, sample.id, output.dir)
end <- Sys.time()

write(paste("getbam_align", sample.id, end-start), file="timing.txt", append=TRUE)

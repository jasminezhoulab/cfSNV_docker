#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(cfSNV)

plasma.unmerged = args[1]
normal = args[2]
plasma.merged.extendedFrags = args[3]
plasma.merge.notCombined = args[4]
target.bed = args[5]
reference = args[6]
SNP.database = args[7]
sample.id = args[8] 
minHold = as.numeric(args[9])
minPass = as.numeric(args[10])
output.dir = args[11]

samtools.dir <- '/usr/local/bin/samtools'
picard.dir <- '/usr/local/bin/picard.jar'
bedtools.dir <- '/usr/local/bin/bedtools'
java.dir <- 'java'
python.dir <- '/usr/local/bin/python'

#start <- Sys.time()
results <- variant_calling(
  plasma.unmerged, normal,
  plasma.merged.extendedFrags, plasma.merge.notCombined,
  target.bed, reference, SNP.database, samtools.dir, picard.dir, bedtools.dir, 
  sample.id, minHold, minPass, java.dir, python.dir
)

tf.file <- paste0(output.dir, "/", sample.id, ".tumor_fraction.txt")
cat(paste(sample.id, "tumor fraction:", results$tumor.fraction), file=tf.file, sep="\n")

header.file <- paste0(output.dir, "/", sample.id, ".header")
cat("##fileformat=VCFv4.2", file=header.file, sep="\n")
time.today <- strsplit(strsplit(toString(Sys.time()), " ")[[1]][1], "-")[[1]]
cat(paste0("##fileDate=", time.today[1], time.today[2], time.today[3]), file=header.file, append=TRUE, sep="\n")
cat(paste0("##source=", sample.id), file=header.file, append=TRUE, sep="\n")
cat(paste0("##reference=", reference), file=header.file, append=TRUE, sep="\n")
cat('##INFO=<ID=VAF,Number=1,Type=Float,Description="Variant Allele Frequency">', file=header.file, append=TRUE, sep="\n")
cat('##FILTER=<ID=ID,Description="PASS if this position has passed all filters">', file=header.file, append=TRUE, sep="\n")

output.file <- paste0(output.dir, "/", sample.id, ".table")
colnames(results$variant.list) <- c("#CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "INFO")
write.table(results$variant.list, output.file, row.names=FALSE, sep="\t", quote=FALSE)
#end <- Sys.time()

#write(paste("variant_calling", sample.id, end-start), file="timing.txt", append=TRUE)
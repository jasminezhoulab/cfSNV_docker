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

start <- Sys.time()
results <- variant_calling(
  plasma.unmerged, normal,
  plasma.merged.extendedFrags, plasma.merge.notCombined,
  target.bed, reference, SNP.database, samtools.dir, picard.dir, bedtools.dir, 
  sample.id, minHold, minPass, java.dir, python.dir
)

cat(paste("Tumor fraction:", results$tumor.fraction))

output.file <- paste0(output.dir, "/", sample.id, "_variant_list.vcf")
cat("##fileformat=VCFv4.2", file=output.file, sep="\n")
time.today <- strsplit(strsplit(toString(Sys.time()), " ")[[1]][1], "-")[[1]]
cat(paste0("##fileDate=", time.today[1], time.today[2], time.today[3]), file=output.file, append=TRUE)
cat(paste0("##source=", sample.id), file=output.file, append=TRUE)
cat(paste0("##reference=", reference), file=output.file, append=TRUE)
cat('##INFO=<ID=VAF,Number=1,Type=Float,Description="Variant Allele Frequency">', file=output.file, append=TRUE)
cat('##FILTER=<ID=ID,Description="PASS if this position has passed all filters">', file=output.file, append=TRUE)
colnames(results$variant.list) <- c("#CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "INFO")
write.table(results$variant.list, output.file, append=TRUE, row.names=FALSE, sep="\t", quote=FALSE)
end <- Sys.time()

write(paste("variant_calling", sample.id, end-start), file="timing.txt", append=TRUE)
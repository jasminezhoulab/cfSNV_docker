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
roughly_estimated_tf = as.logical(args[9])

samtools.dir <- '/usr/local/bin/samtools'
python.dir <- '/usr/local/bin/python'

start <- Sys.time()
parameter_recommend(
  plasma.unmerged, normal,
  plasma.merged.extendedFrags, plasma.merge.notCombined,
  target.bed, reference, SNP.database, samtools.dir, 
  sample.id, roughly_estimated_tf, python.dir
)
end <- Sys.time()

write(paste("parameter_recommend", sample.id, end-start), file="timing.txt", append=TRUE)

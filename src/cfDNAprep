if [ "$1" == "-h" ]; then
	echo ""
	echo "This function first merges the overlapping read mates in cfDNA sequencing data and then maps raw reads from FASTQ (gzip or not) files to the reference genome"
	echo ""
	echo "Usage: ./getbam_align_after_merge.sh -f1 \${fastq1} -f2 \${fastq2} -g \${genome} -d \${database} -i \${id} -o \${output}
	-f1|--fastq1 the 1st FASTQ file
	-f2|--fastq2 the 2nd FASTQ file
	-g|--genome a FASTA file of the reference genome
	-d|--database a VCF file of the positions that are blocked from mutation calling, e.g. a common SNP database
	-i|--id a sample ID name
	-o|--output the output directory"
	exit 0
fi

while [[ "$#" -gt 0 ]]; do case $1 in
	-f1|--fastq1) fastq1="$2"; shift;;
	-f2|--fastq2) fastq2="$2"; shift;;
	-g|--genome) genome="$2"; shift;;
	-d|--database) database="$2"; shift;;
	-i|--id) id="$2"; shift;;
	-o|--output) output="$2"; shift;;
	*) echo "Unknown parameter passed: $1"; exit 1;;
esac; shift; done

checkDir(){
	if [ ! -e "$1" ]; then
		echo -e "Making directory: $1"
		mkdir -p $1
	fi
}

checkDir $output

echo ""
echo "Sample ID: $id"
echo ""

Rscript --vanilla getbam_align_after_merge.R $fastq1 $fastq2 $genome $database $id $output

echo ""

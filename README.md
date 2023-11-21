# cfSNV Docker

## Overview

`cfSNV` is an ultra-sensitive and accurate somatic SNV caller designed for cfDNA sequencing. Taking advantage of modern statistical models and machine learning approaches, `cfSNV` provides hierarchical mutation profiling and multi-layer error suppression, including error suppression in read mates, site-level error filtration and read-level error filtration.

Here we present a Docker image of the `cfSNV` package, which is designed such that researchers and clinicians with a limited computational background can easily carry out analyses on both high-performance computing platforms and local computers.

`cfSNV Docker` can be freely used for educational and research purposes by non-profit institutions and U.S. government agencies only under the UCLA Academic Software License. For information on the use for a commercial purpose or by a commercial or for-profit entity, please contact Prof. Xianghong Jasmine Zhou (XJZhou@mednet.ucla.edu) and Prof. Wenyuan Li (WenyuanLi@mednet.ucla.edu).

## Equipment setup

The Docker container can be built and run on most operating systems, including Windows, MacOS, or Linux.
The Docker image can also be found on Docker Hub at this link: https://hub.docker.com/repository/docker/ranhu/cfsnv-docker/general.

#### 1. Install Docker

Get Docker from https://docs.docker.com/get-docker/.

#### 2. Download cfSNV Docker image

Download our latest `cfsnv_image.tar.gz` from https://github.com/jasminezhoulab/cfSNV_docker/releases. Save the docker image to your `working_directory`.

#### 3. Load cfSNV Docker image

After starting the Docker software and enter the `working_directory`, type the following command in Unix Terminal or Windows Command Prompt:

```bash
docker load < cfsnv_image.tar.gz
```

The Docker image called `cfsnv_docker` will be loaded. 

#### 4. Create cfSNV Docker container and mount data directory

Users need to specify two directory paths for mounting: (1) a local directory called `local_directory` on the host machine, where all input data are located, and (2) a container directory called `container_directory`, through which the data on the host machine can be accessed in the container. Type the following command:

```bash
docker run -it -d -v <local_directory>:<container_directory> --name <cfsnv_container> cfsnv_docker bash
```

In this command, please replace `<local_directory>` with a local directory in the host machine (e.g., C:\Documents\cfSNV\demo for Windows and /home/users/cfSNV/demo for Unix), replace `<container_directory>` with the directory in the docker (a path name in Linux, e.g. /home/cfSNV/demo), and replace `<cfsnv_container>` with a name as the container's name.

#### 5. Run cfSNV Docker container

Then, execute the following line to start the container:

```bash
docker exec -it <cfsnv_container> bash
```

#### Tips

1. If users want to remove the existing container and create a new one with the same name, execute:

   ```bash
   docker rm -f <cfsnv_container>
   ```

   where `<cfsnv_container>` is the existing container's name. Then repeat step 4 and 5.
2. If we release a new Docker image version, users should first remove or rename the old Docker image, then download and load the new image.


## Pipeline

There are three main modules in the `cfSNV Docker` package: preprocessing, parameter recommendation, and mutation detection.

![cfSNV_pipeline](./pic/cfSNV_pipeline.jpg)

The detailed usage of each function can be found using flag `-h` (help). For example, to check how to use `DetectMuts`, type the following command in the container directory `/home/cfSNV`:

```
./DetectMuts -h
```

which will return:

```bash
This function outputs the variant list to a VCF file and writes the tumor fraction to a TXT file.

Usage: ./DetectMuts -p ${plasma} -n ${normal} -e ${extended} -u ${uncombined} -t ${target} -g ${genome} -d ${database} -i ${id} -mh ${minHold} -mp ${minPass} -o ${output}
	-p|--plasma a BAM file of the cfDNA sequencing data
	-n|--normal a BAM file of the normal sample sequencing data
	-e|--extended a BAM file of the combined cfDNA reads
	-u|--uncombined a BAM file of the cfDNA reads that are not combined
	-t|--target a BED file of target regions
	-g|--genome a FASTA file of the reference genome
	-d|--database a VCF file of the positions that are blocked from mutation calling, e.g. a common SNP database
	-i|--id a sample ID name
	-mh|--minHold a minimum number of supporting read pairs that are required for mutations in the HOLD category. Default is 12
	-mp|--minPass a minimum number of supporting read pairs that are required for mutations in the PASS category. Default is 5
	-o|--output an output directory for the variant list
```

## Example data and test demo data

**Example data files**

The example data can be downloaded by executing the script `DownloadEg` or through:

```bash
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR850/ERR850376/ERR850376_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR850/ERR850376/ERR850376_2.fastq.gz

wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR852/ERR852106/ERR852106_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR852/ERR852106/ERR852106_2.fastq.gz
```

The example reference files can be downloaded through

```bash
wget https://zenodo.org/record/7191202/files/example_reference_files.tar.gz
```

**Test demo data files**

The demo data for quick testing can be downloaded through

```bash
wget https://zenodo.org/record/7191202/files/demo_data.tar.gz
```

The demo reference files can be downloaded through

```bash
wget https://zenodo.org/record/7191202/files/demo_reference_files.tar.gz
```

## The demo output

The output of running `RecParams` on the demo data:

```bash
Sample ID: demo_cfDNA

The per base coverage of the plasma sample for each genomic region in the target bed file:
average = 149.833, median = 139.046, 95th percentile = 280.356 

The roughly estimated tumor fraction in the plasma sample: 10.025% 
For a more accurate estimation, please run DetectMuts. 

Lowest detectable VAF range under the default parameters: [1.783%, 4.28%] 

To detect different levels of lowest VAF, 
at 1% VAF: MIN_HOLD_SUPPORT_COUNT = 9, MIN_PASS_SUPPORT_COUNT = 3; 
at 5% VAF: MIN_HOLD_SUPPORT_COUNT = 20, MIN_PASS_SUPPORT_COUNT = 14 
Note: decreasing the parameters (i.e. MIN_HOLD_SUPPORT_COUNT and MIN_PASS_SUPPORT_COUNT) 
can lower the detection limit, but may also lower the variant quality.
```

The output of running `DetectMuts` on the demo data, including the `${id}.tumor_fraction.txt` file:

```bash
demo_cfDNA tumor fraction: 10.4117553285%
```

and the `${id}.variant_list.vcf` file:

```bash
##fileformat=VCFv4.2
##fileDate=20220417
##source=demo_cfDNA
##reference=demo_reference_files/demo_ref_genome.fa
##INFO=<ID=VAF,Number=1,Type=Float,Description="Variant Allele Frequency">
##FILTER=<ID=ID,Description="PASS if this position has passed all filters">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
chr22	22730851	.	A	G	4.76876578963686e+29	PASS	VAF=0.177570093458
chr22	22730852	.	T	C	8.5492017941142e+28	PASS	VAF=0.173076923077
chr22	22730853	.	G	C	2.79763925080629e+32	PASS	VAF=0.173076923077
chr22	25115549	.	T	G	9.66499609454881e+71	PASS	VAF=0.189189189189
chr22	25570329	.	C	T	643924.75349	PASS	VAF=0.026315789474
chr22	29179472	.	C	T	518422.76463	PASS	VAF=0.056179775281
chr22	40660923	.	C	G	754256842110353792	PASS	VAF=0.078651685393
chr22	41363836	.	C	T	665638501276337	PASS	VAF=0.042553191489
chr22	42899171	.	T	C	13161.69048	PASS	VAF=0.054794520548
chr22	45723880	.	T	G	246.7265	PASS	VAF=0.069767441860
```

## Citation

[1] Li, S., Hu, R., Small, C., Kang, T. Y., Liu, C. C., Zhou, X. J., & Li, W. (2023). cfSNV: a software tool for the sensitive detection of somatic mutations from cell-free DNA. Nature Protocols, 1-21.

[2] Li, S., Noor, Z. S., Zeng, W., Stackpole, M. L., Ni, X., Zhou, Y., ... & Zhou, X. J. (2021). Sensitive detection of tumor mutations from blood and its application to immunotherapy prognosis. Nature communications, 12(1), 4172.

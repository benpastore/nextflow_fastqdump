process DOWNLOAD {

    publishDir "$params.results/fastq", mode : 'copy', pattern : '*fastq.gz'

    input :
        tuple val(sra), val(sample)
    
    output : 
        path("*")
    
    script : 
    """
    #!/bin/bash

    module load python
    source activate rnaseq_basic

    wget -q https://sra-pub-run-odp.s3.amazonaws.com/sra/${sra}/${sra} 

    fasterq-dump --threads ${task.cpus} --outdir \$PWD --split-files ${sra} --quiet

    rename "${sra}" "${sample}" *
    
    gzip *fastq
        
    """
}
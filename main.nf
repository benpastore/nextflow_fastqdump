#!/usr/bin/env nextflow
/*
========================================================================================
                         Parallel Fastq Dump
========================================================================================
Ben Pastore
pastore.28@osu.edu
----------------------------------------------------------------------------------------
*/

def helpMessage() {
    log.info"""
    Usage:
    The typical command for running the pipeline is as follows:

      nextflow main.nf --srr srr.txt --results /path/to/results

    Mandatory arguments:
    --srr       SRR file, tab delimited in the form: srr  sample_name
    --results   Path to the directory where the output files will be written to
    -profile    Configuration to use can be: local or cluster
    """.stripIndent()
}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

////////////////////////////////////////////////////
/* --          VALIDATE INPUTS                 -- */
////////////////////////////////////////////////////

if (params.srr)         { ch_srr = file(params.srr, checkIfExists: true) } else { exit 1, 'SRR File not specified!' }
if (params.results)     { ch_results = file(params.results, checkIfExists: false) } else { exit 1, 'Results path not specified' }

////////////////////////////////////////////////////
/* --          Workflow params                 -- */
////////////////////////////////////////////////////

// enable dsl 2 language
nextflow.enable.dsl=2

// include modules
include {
    DOWNLOAD
} from './modules'


////////////////////////////////////////////////////
/* --                Workflow                  -- */
////////////////////////////////////////////////////
workflow {

    Channel
        .fromPath( ch_srr )
        .splitCsv(header: ['srr', 'name'], sep:'\t')
        .map { row -> [ row.srr, row.name ] }
        .tap{ srr }

    DOWNLOAD(srr)

}
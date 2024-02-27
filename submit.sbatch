#!/bin/bash

#SBATCH --no-requeue
#SBATCH -c 1
#SBATCH --account=PAS1473 --nodes=1 --ntasks-per-node=1 --time=8:00:00 --mem=2gb

nextflow /fs/ess/PCON0160/ben/pipelines/fastqdump/main.nf --srr srr.txt --results /fs/ess/PAS1473/deep_sequencing/DISL2_published_seq -profile cluster




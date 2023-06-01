#!/usr/bin/env nextflow

include {PHASE1} from './subworkflows/phase1'
include {PHASE2} from './subworkflows/phase2'

workflow {

    channel.fromPath(params.samplesheet)
        .splitCsv(header: true)
        .map {row -> [['id': row.sample], row.fastq_1, row.fastq_2]}
        .set {reads}

    // alignment and QC
    star_index = channel.value(params.star_index)

    PHASE1(
        reads,
        star_index
    )
    
    // quantification and fusion calling
    transcriptome_bam = PHASE1.out.transcriptome_bam
    junctions = PHASE1.out.junctions
    ctat_lib = channel.value(params.ctat_lib)
    salmon_index = channel.value(params.salmon_index)

    PHASE2(
        transcriptome_bam,
        junctions,
        ctat_lib,
        salmon_index
    )

}
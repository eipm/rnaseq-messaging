#!/usr/bin/env nextflow

include {SALMON} from '../modules/salmon'
include {STAR_FUSION} from '../modules/starfusion'    

workflow PHASE2 {

    take:
    // input data
    junctions // tuple val(meta), path(junctions)
    transcriptome_bam // tuple val(meta), path(transcriptome_bam)
    // references
    ctat_lib // path(ctat_lib)
    salmon_index // path(index)

    main:
    // fusion calling
    STAR_FUSION(junctions, ctat_lib)

    // quantification
    SALMON(transcriptome_bam, salmon_index)

}
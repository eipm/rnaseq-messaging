#!/usr/bin/env nextflow

process SORT_BAM {
    
    input:
    tuple val(meta), path(bam)
    
    output:
    tuple val(meta), path("${meta.id}.star.sorted.bam"), path("${meta.id}.star.sorted.bam.bai"), emit: sorted_bam

    publishDir "${params.outputdir}/phase1/${meta.id}"

    stub:
    """
    touch ${meta.id}.star.sorted.bam
    touch ${meta.id}.star.sorted.bam.bai
    """

}
#!/usr/bin/env nextflow

process SALMON {
    
    input:
    tuple val(meta), path(transcriptome_bam)
    path(salmon_index)

    output:
    tuple val(meta), path("${meta.id}.quant.sf"), emit: quant

    publishDir "${params.outputdir}/phase2/${meta.id}/salmon"

    stub:
    """
    touch ${meta.id}.quant.sf
    """

}
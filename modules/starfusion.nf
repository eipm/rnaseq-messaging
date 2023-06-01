#!/usr/bin/env nextflow

process STAR_FUSION {

    input:
    tuple val(meta), path(junctions)
    path(ctat_lib)

    output:
    tuple val(meta), path("${meta.id}.fusion_predictions.tsv")

    publishDir "${params.outputdir}/phase2/starfusion"

    stub:
    """
    touch ${meta.id}.fusion_predictions.tsv
    """

}
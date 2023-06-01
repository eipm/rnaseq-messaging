#!/usr/bin/env nextflow

process STAR {
    
    input:
    tuple val(meta), path(left_fastq), path(right_fastq)
    path(star_index)

    output:
    tuple val(meta), path("${meta.id}.Aligned.out.bam"), emit: bam
    tuple val(meta), path("${meta.id}.Junctions"), emit: junctions
    tuple val(meta), path("${meta.id}.Transcriptome.bam"), emit: transcriptome_bam

    stub:
    """
    touch ${meta.id}.Aligned.out.bam
    touch ${meta.id}.Junctions
    touch ${meta.id}.Transcriptome.bam
    """

}
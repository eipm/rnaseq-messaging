#!/usr/bin/env nextflow

include {STAR} from '../modules/star'
include {SORT_BAM} from '../modules/sortbam'

workflow PHASE1 {

    take:
    reads // val(meta), path(left_fastq), path(right_fastq)
    star_index // path(star_index)

    main:
    STAR(reads, star_index)
    SORT_BAM(STAR.out.bam)

    emit:
    genomic_bam = SORT_BAM.out.sorted_bam // val(meta), path(bam), path(bai)
    transcriptome_bam = STAR.out.transcriptome_bam // val(meta), path(transcriptome_bam)
    junctions = STAR.out.junctions // val(meta), path(junctions)

}
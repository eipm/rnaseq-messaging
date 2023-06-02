#!/usr/bin/env nextflow
import edu.cornell.eipm.messaging.zeromess.messages.*

process SORT_BAM {

    tag "${meta.id}"

    beforeScript ProcessMessage.started('SORT_BAM').forTopic('processevents').buildCommand()
    afterScript ProcessMessage.completed('SORT_BAM').forTopic('processevents').buildCommand()

    input:
    tuple val(meta), path(bam)
    
    output:
    tuple val(meta), path("${meta.id}.star.sorted.bam"), path("${meta.id}.star.sorted.bam.bai"), emit: sorted_bam

    publishDir "${params.outputdir}/phase1/${meta.id}"

    stub:
    """
    touch ${meta.id}.star.sorted.bam
    touch ${meta.id}.star.sorted.bam.bai

    MD5SUM=\$(md5sum ${meta.id}.star.sorted.bam | cut -d " " -f 1)
    FILEPATH="${params.outputdir}/phase1/${meta.id}/${meta.id}.star.sorted.bam"

    BashMessage 'taskevents' '"sample_barcode":"${meta.id}","filepath":"\${FILEPATH}","checksum":"\${MD5SUM}"'
    """

}
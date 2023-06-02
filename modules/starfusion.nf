#!/usr/bin/env nextflow
import edu.cornell.eipm.messaging.zeromess.messages.*

process STAR_FUSION {

    tag "${meta.id}"

    beforeScript ProcessMessage.started('STAR_FUSION').forTopic('processevents').buildCommand()
    afterScript ProcessMessage.completed('STAR_FUSION').forTopic('processevents').buildCommand()

    input:
    tuple val(meta), path(junctions)
    path(ctat_lib)

    output:
    tuple val(meta), path("${meta.id}.fusion_predictions.tsv")

    publishDir "${params.outputdir}/phase2/${meta.id}/starfusion"

    stub:
    """
    touch ${meta.id}.fusion_predictions.tsv

    MD5SUM=\$(md5sum ${meta.id}.fusion_predictions.tsv | cut -d " " -f 1)
    FILEPATH="${params.outputdir}/phase2/${meta.id}/starfusion/${meta.id}.fusion_predictions.tsv"

    BashMessage 'taskevents' '"sample_barcode":"${meta.id}","filepath":"\${FILEPATH}","checksum":"\${MD5SUM}"'
    """

}
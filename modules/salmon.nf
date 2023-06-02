#!/usr/bin/env nextflow
import edu.cornell.eipm.messaging.zeromess.messages.*

process SALMON {

    tag "${meta.id}"

    beforeScript ProcessMessage.started('SALMON').forTopic('processevents').buildCommand()
    afterScript ProcessMessage.completed('SALMON').forTopic('processevents').buildCommand()
    
    input:
    tuple val(meta), path(transcriptome_bam)
    path(salmon_index)

    output:
    tuple val(meta), path("${meta.id}.quant.sf"), emit: quant

    publishDir "${params.outputdir}/phase2/${meta.id}/salmon"

    stub:
    """
    touch ${meta.id}.quant.sf

    MD5SUM=\$(md5sum ${meta.id}.quant.sf | cut -d " " -f 1)
    FILEPATH="${params.outputdir}/phase2/${meta.id}/salmon/${meta.id}.quant.sf"

    BashMessage 'taskevents' '"sample_barcode":"${meta.id}",filepath":"\${FILEPATH}","checksum":"\${MD5SUM}"'
    """

}
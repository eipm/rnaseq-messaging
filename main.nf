#!/usr/bin/env nextflow
import edu.cornell.eipm.messaging.zeromess.messages.*
import edu.cornell.eipm.messaging.zeromess.ZeroMessInitializer

ZeroMessInitializer.init(
    workflow.manifest.name,
    params.dispatcherURL,
    workflow.sessionId,
    params.pipeline_messaging_enabled
)

include {PHASE1} from './subworkflows/phase1'
include {PHASE2} from './subworkflows/phase2'

workflow {

    PipelineMessage.started(workflow).forTopic("pipelineevents")
        .data('message', "RNAseq pipeline run ${workflow.runName} started").send()

    channel.fromPath(params.samplesheet)
        .splitCsv(header: true)
        .map {row -> [['id': row.sample], row.fastq_1, row.fastq_2]}
        .set {reads}

    // alignment
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

workflow.onError {
    PipelineMessage.error(workflow).forTopic('pipelineevents')
        .data('message', "RNAseq pipeline run ${workflow.runName} failed with error message ${workflow.errorMessage}").send()
}

workflow.onComplete {
    if (workflow.success) {
        PipelineMessage.completed(workflow).forTopic('pipelineevents')
            .data('message', "RNAseq pipeline run ${workflow.runName} completed successfully").send()
    } else {
        PipelineMessage.failed(workflow).forTopic('pipelineevents')
            .data('message', "RNAseq pipeline run ${workflow.runName} completed with errors").send()
    }
}
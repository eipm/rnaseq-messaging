rnaseq-messaging
===
This pipeline is a basic demonstration of integrating Kafka messaging with Nextflow, in this case a RNAseq pipeline. Note that it can only be run as a `-stub`. In order to use messaging with this pipeline, a KafkaDispatcher reachable from the execution environment is required. This repo is meant to provide a simple example of what _can_ be done with the DispatcherSuite messaging framework.

For a pipeline that explains the types of messages you can send, refer to [eipm/hello-mess-nf](https://github.com/eipm/hello-mess-nf/). 

## Description
The simulated workflow begins by aligning with `STAR`. The resulting genomic BAM is passed into `SORT_BAM`. This is followed by quantification with `SALMON` and fusion detection with `STAR_FUSION`. Results from `SORT_BAM`, `SALMON`, and `STAR_FUSION` are published. 

### Messages
Messages containing metadata regarding file output (final published addresses, MD5 sums) are sent from processes with published data. Workflow status is communicated using `beforeScript` and `afterScript` to relay `process` progress, and the `onComplete` and `onError` handlers to relay main workflow status. 

### Parameters
The following parameters are specific to the messaging service:
* `pipeline_messaging_enabled`: boolean value indicating whether messaging is enabled. **This parameter is required.**
* `dispatcherURL`: the URL and port at which the KafkaDispatcher can be reached. This parameter is only required if messaging is enabled. 

**The following parameters are required for execution regardless of whether or not messaging is enabled.** Note that all paths must point to existing files; as this is merely a stub the contents do not matter, but the paths must exist. 
* `samplesheet`: a path to a samplesheet in the following format. All fastq paths must point to existing files. (This pipeline cannot handle samples with multiple fastqs e.g. sequenced in multiple lanes, nor is it designed for single end sequencing.)

    | sample | fastq_1               | fastq_2               |
    |--------|-----------------------|-----------------------|
    | ID1    | /path/to/ID1_R1.fq.gz | /path/to/ID1_R2.fq.gz |
    | ID2    | /path/to/ID2_R1.fq.gz | /path/to/ID2_R2.fq.gz |

* `star_index`, `ctat_lib`, `salmon_index`: paths to references for the processes `STAR`, `STAR_FUSION`, and `SALMON` respectively
* `outputdir`: location to publish the output

## Running the pipeline
To run via pipeline sharing:
```shell
nextflow run eipm/rnaseq-messaging -stub -params-file your-params.yml
```

### Running on Azure batch services
This pipeline can run on Azure batch services with Azure Event Hubs as a broker. 

The following parameters are specific to implementing the pipeline with messaging on Azure and are only required for `azurebatch` execution:
* `workdir`: Path to desired workdir on the specified blob storage account
* `active_directory_principal_id`, `active_directory_principal_secret`, `active_directory_tenant_id`: Microsoft Entra credentials (formerly Active Directory) for Azure batch and storage accounts
* `batch_location`, `batch_account_name`: Azure batch account information
* `storage_account_name`: Azure storage account information (linked with the specified batch account)
* `virtual_network`: An Azure virtual network to link together the nodes on the batch pool with the job submit node
* `registry_username`, `registry_password`: docker.io registry credentials

Using a `-params-file` containing all the aforementioned parameters, the pipeline can be run using the `azurebatch` executor with the command
```shell
nextflow run eipm/rnaseq-messaging -stub -params-file your-params.yml -profile azurebatch
```
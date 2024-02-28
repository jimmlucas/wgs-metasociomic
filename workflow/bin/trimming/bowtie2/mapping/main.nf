process PRUNING-MAPPING {
    tag "Mapping ${sample_id}"

    publishDir "${params.outdir}/2-pruning",
     saveAs: { filename ->
        filename.contains("output_cleaned_%.fastq") ? "Human_report/$filename" :
        filename.contains(".bam") ? "Pruning_report/$filename" : filename
    }

    input:

    tuple val(sample_id), path (paired_reads), path (unpaired_reads)
    path reference_id

    output:
    
    tuple val(sample_id),
    path("${sample_id}_output_cleaned_%.fastq"), 
    path("${sample_id}.sam"),
    path("${sample_id}.bam"),
    path("${sample_id}.bam.bai")

    script:

    def isMappingHuman = reference_id == file(human_index)

    if isMappingHuman = reference_id == file(human_index).exists()
    { 
        """

        bowtie2 -x ${params.reference} -1 ${reads[0]} -2 ${reads[1]} --un-conc ${sample_id}_output_cleaned_%.fastq
    
        """
    }

    """

    bowtie2 -x ${params.reference} -1 ${reads[0]} -2 ${reads[1]} -S output_mapping.sam > ${}.sam
    samtools sort < ${sample_id}.sam > ${sample_id}.bam
    samtools index ${sample_id}.bam

    """

}
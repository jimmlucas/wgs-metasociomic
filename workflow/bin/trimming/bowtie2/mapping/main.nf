process PRUNING_MAPPING {
    tag "Mapping ${sample_id}"

    publishDir "${params.outdir}/2-pruning", mode: 'copy',
     saveAs: { filename ->
        filename.endsWith(".fastq") ? "No_human_report/$filename" :
        filename.endsWith(".bam") || filename.endsWith(".bai") ? "Pruning_report/$filename" : null
    }

    input:

    tuple val(sample_id),
    path(paired_reads)
    path(reference_id)


    output:
    
    tuple val(sample_id),
    path("*_output_cleaned_%.fastq"), 
    path("*.sam"),
    path("*.bam"),
    path("*.bam.bai")

    script:

    """
    bowtie2 -x ${params.index_genome_human} -1 ${paired_reads[0]} -2 ${paired_reads[1]} --un-conc ${sample_id}_output_cleaned_%.fastq
    """
}
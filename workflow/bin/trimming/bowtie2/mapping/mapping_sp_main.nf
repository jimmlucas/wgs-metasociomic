process SPECIE_GENOME_MAPPING {
    tag "Mapping ${sample_id}"
    
    input:

    tuple val(sample_id), path(paired_reads)
    path(index_base)


    output:
    
    tuple val(sample_id), path("*_output_cleaned_*.fastq")

    script:
    """
     bowtie2 -x ${params.index_genome_specie} -1 ${paired_reads[0]} -2 ${paired_reads[1]} --al-conc ${sample_id}_output_cleaned_%.fastq
    """
}

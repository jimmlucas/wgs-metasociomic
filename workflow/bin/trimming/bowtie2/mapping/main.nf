process PRUNING-MAPPING {
    tag "Mapping ${ref_id}"

    publishDir "${params.outdir}/2-pruning",
     saveAs: { filename ->
        filename.contains("output_cleaned_*.fastq") ? "Human_report/$filename" :
        filename.contains("output_mapping.sam") ? "Pruning_report/$filename" : filename
    }

    input:

    tuple val(pair_id), path (reads) from trimmed_reads
    path referencegenome

    output:
    
    tuple val(pair_id),
    path("pruning_${pair_id}_{1,2}_paired.fq.gz"), 
    path("purning_${pair_id}_{1,2}_unpaired.fq.gz"),
    path("output_mapping.sam")

    script:

    def isMappingHuman = ref_id == file(human_index)

    if isMappingHuman = ref_id == file(human_index).exists()) {

    """
    bowtie2 -x $rencegenome -1 ${reads[0]} -2 ${reads[1]} --un-conc output_cleaned_%.fastq
    """
    }

    else

        """

        bowtie2 -x $referencegenome -1 ${} -2 ${} -S output_mapping.sam
        

        """

}
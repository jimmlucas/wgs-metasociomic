process PRUNING-MAPPING {
    tag "Mapping ${ref_id}"
    publishDir "${params.outdir}/2-pruning",
     saveAs: { filename ->
        filename.contains("human_mapping") ? "human/$filename" :
        filename.contains("personal_maping") ? "personal/$filename" : filename
    }

    input:
    tuple val(pair_id), path (reads) 
    path humanreferencegenome

    output:
    tuple val(pair_id),
    path("pruning_${pair_id}_{1,2}_paired.fq.gz"), 
    path("purning_${pair_id}_{1,2}_unpaired.fq.gz")

    script:
    def isMappingHuman = ref_id == file(human_index)


    """
    bowtie2-x $humanreferencegenome -1 ${reads[0]} -2 ${reads[1]} --un-conc [lecturas_no_humanas.fq]
    """


}
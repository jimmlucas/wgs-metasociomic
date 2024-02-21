process PRUNING-MAPPING {
    tag "Mapping ${ref_id}"
    publishDir "${params.outdir}/2-pruning",
     saveAs: { filename ->
        filename.contains("human_mapping") ? "human/$filename" :
        filename.contains("personal_maping") ? "personal/$filename" : filename
    }

    input:
    path 

    output:
    path  

    script:
    def 


    """
    bowtie2 

    """


}
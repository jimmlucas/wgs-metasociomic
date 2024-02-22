process PRUNING-MAPPING {
    tag "Mapping ${ref_id}"
    publishDir "${params.outdir}/2-pruning",
     saveAs: { filename ->
        filename.contains("human_mapping") ? "human/$filename" :
        filename.contains("personal_maping") ? "personal/$filename" : filename
    }

    input:
    path (ref_id)
    path ()

    output:
    path  

    script:
    def 


    """
    bowtie2-x [índice_genoma_humano] -1 [lecturas_fastq_pareja1.fq] -2 [lecturas_fastq_pareja2.fq] --un-conc [lecturas_no_humanas.fq]
    """


}
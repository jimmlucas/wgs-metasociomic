process bwaIndex {
    tag "index"
    label 'index_process'
    
    publishDir "${params.outdir}/reference-genome", mode: 'copy'
    
    input:
    path(params.reference)

    output:
    path("*")

    script:
    """
	bwa index $params.reference
    """
}
//Quality analisis 
process FASTQC_QUALITY {
    tag "FASTQC"

    publishDir "${params.outdir}/out/1-fastqc", mode: 'copy'

    input:
    path (reads)

    output:
    path ("*.html")

    script:
    """
    fastqc ${reads}
    """
}
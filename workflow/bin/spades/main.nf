//ENSAMBLY
process METASPADES_ASSEMBLY {
    tag "ASSEMBLY"

    publishDir "${params.outdir}/out/1-ensambly", mode: 'copy'

    input:
    path (reads)

    output:
    path ("*.")
}
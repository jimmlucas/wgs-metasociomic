process buildIndex {
    tag "Index-referenceGenome"
    publishDir "${params.outdir}/reference-genome", mode: 'copy'

    input:
    path (params.reference)

    output:
    path 'genome.index*'

    """
    bowtie2-build $params.reference genome.index
    """
}
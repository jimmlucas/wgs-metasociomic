process BUILD_INDEX {
    tag "Index-ReferenceGenome"
    
    publishDir "${params.reference}",
     saveAs: {filename ->
            if (filename.indexOf("human_genome.index") > 0) "human/$filename"
            else if (filename.indexOf("personal_genome.index") > 0) "personal/$filename"
            else filename
    }

    input:
    path (params.reference)

    output:
    path 'genome.index*'

    script:
    def refGenome = file(params.reference)
    
    if (!refGenome.exists()) {
        """
        wget -q -O - https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh37_latest/refseq_identifiers/GRCh37_latest_genomic.fna.gz | gunzip > ${refGenome}
        bowtie2-build $params.reference genome.index
        """
    }
    
    else 
    """
    
    """
}
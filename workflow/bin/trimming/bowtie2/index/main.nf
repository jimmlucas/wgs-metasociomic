process BUILD_INDEX {
    tag "Index-ReferenceGenome ${reference_id}"
    
    publishDir "${params.reference}",
     saveAs: {filename ->
            if (filename.indexOf("human_genome.index") > 0) "human/$filename"
            else if (filename.indexOf("personal_genome.index") > 0) "personal/$filename"
            else filename
    }

    input:
    path (reference_id)

    output:
    path 'genome.index*'

    script:
    def refGenome = file( "${params.human_ref}" )
    
    if (!refGenome.exists()) {
        """
        wget -q -O - https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh37_latest/refseq_identifiers/GRCh37_latest_genomic.fna.gz | gunzip > ${refGenome}
        bowtie2-build ${reference_id} human_genome.index
        """
    }
    else
        if (refGenome.exists()) {
        """
        bowtie2-build ${reference_id} personal_genome.index
        """    
        }
    else print ("No Reference Genome. Please check if the reference Genome is in the correct Folder")

}
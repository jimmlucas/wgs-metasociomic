process BUILD_INDEX {
    tag "Index-ReferenceGenome ${reference_id}"
    
    publishDir "${params.reference}",
     saveAs: {filename ->
            if filename.contains("index_human_genome") ? "human/$filename" :
            else if filename.contains("index_personal_genome") ? "personal/$filename" : filename
    }

    input:
    path (reference_id)

    output:
    path 'index_{personal,human}_genome*'

    script:
    def isHumanref = reference_id == file( "${params.human_ref}" )
    
    if (isHumanRef && !reference_id.toFile().exists()) {
        """
        wget -q -O - https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh37_latest/refseq_identifiers/GRCh37_latest_genomic.fna.gz | gunzip > ${reference_id}
        """
    }
    else
        if (refGenome.exists() == reference_id) {
        """
        bowtie2-build ${reference_id} index_human_genome
        """    
        }
    else
        """
        bowtie2-build ${reference_id} index_personal_genome
        """  
}
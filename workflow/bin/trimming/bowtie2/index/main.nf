process BUILD_INDEX {
    tag "Index-ReferenceGenome ${reference_id}"
    
    publishDir "${params.reference}",
     saveAs: { filename ->
        filename.contains("index_human_genome") ? "human/$filename" :
        filename.contains("index_personal_genome") ? "personal/$filename" : filename
    }

    input:
    path reference_id

    output:
    path 'index_{human,personal}_genome*'

    script:
    def isHumanRef = reference_id == file(params.human_ref)
    
    if (isHumanRef && !reference_id.toFile().exists()) {
        """
        wget -q -O - https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh37_latest/refseq_identifiers/GRCh37_latest_genomic.fna.gz | gunzip > ${reference_id}
        """
    }

    """
    bowtie2-build ${reference_id} ${isHumanRef ? 'index_human_genome' : 'index_personal_genome'}
    """
}
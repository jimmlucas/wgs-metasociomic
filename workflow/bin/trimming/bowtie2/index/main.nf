process BUILD_INDEX {
    tag "Index-ReferenceGenome ${reference_id.name}"

    // Asumiendo que `params.reference` es el directorio donde se guardarán los índices
    publishDir "${params.reference}", mode: 'copy', saveAs: { filename ->
        if (filename.contains("index_human_genome")) "human/$filename"
        else if (filename.contains("index_personal_genome")) "personal/$filename"
        else if (filename.contains("index_sp_genome")) "Specie/$filename"
        else filename
    }

    input:
    path reference_id

    output:
    path "index_*_genome*", emit: index_data

    script:
    def index_prefix = ""
    def command = ""

    if (reference_id == file(params.human_ref)) {
        index_prefix = "index_human_genome"
        if (!reference_id.toFile().exists()) {
            command = "wget -q -O - https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh37_latest/refseq_identifiers/GRCh37_latest_genomic.fna.gz | gunzip > ${reference_id}"
        }
    } else if (reference_id == file(params.sp_ref)) {
        index_prefix = "index_sp_genome"
    } else {
        index_prefix = "index_personal_genome"
    }

    if (index_prefix == "index_human_genome" && command) {
        """
        $command
        bowtie2-build ${reference_id} $index_prefix
        """
    } else {
        """
        bowtie2-build ${reference_id} $index_prefix
        """
    }
}